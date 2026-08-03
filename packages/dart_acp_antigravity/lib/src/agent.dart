import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import 'event_mapper.dart';
import 'events.dart';
import 'executable.dart';
import 'options.dart';

/// Renders ACP prompt content into the single text prompt accepted by the
/// Antigravity CLI's print mode.
///
/// Text blocks pass through unchanged, resource links become their URI, and
/// embedded text resources become fenced context blocks. Image, audio, and
/// binary resource blocks are omitted because print mode accepts only text.
String renderAntigravityPrompt(Iterable<ContentBlock> prompt) {
  final List<String> parts = <String>[];
  for (final ContentBlock block in prompt) {
    final Map<String, Object?> json = block.toJson();
    switch (block) {
      case ContentBlockText():
        if (json['text'] case final String text when text.isNotEmpty) {
          parts.add(text);
        }
      case ContentBlockResourceLink():
        if (json['uri'] case final String uri when uri.isNotEmpty) {
          final Object? name = json['name'];
          parts.add(name is String && name.isNotEmpty ? '$name ($uri)' : uri);
        }
      case ContentBlockResource():
        final Object? resource = json['resource'];
        if (resource is Map<Object?, Object?>) {
          final Object? uri = resource['uri'];
          final Object? text = resource['text'];
          if (text is String) {
            final String reference = uri is String ? uri : 'resource';
            parts.add('<context ref="$reference">\n$text\n</context>');
          }
        }
      case ContentBlockImage() || ContentBlockAudio():
        break;
    }
  }
  return parts.join('\n\n');
}

/// ACP agent backed by headless Antigravity CLI (`agy`) print-mode runs.
///
/// Each ACP session owns one Antigravity conversation. The first prompt
/// creates the conversation; later prompts resume it with `--conversation`,
/// so session history survives across prompt turns and adapter restarts are
/// bounded to the CLI's own state directory.
///
/// Print mode cannot prompt for tool permissions, so this agent never sends
/// `session/request_permission`. Select an [AntigravityPermissionPolicy] or
/// configure CLI `settings.json` allow-rules instead.
final class AntigravityAcpAgent {
  /// Creates an agent and its immutable typed ACP application.
  AntigravityAcpAgent({AntigravityAcpOptions? options})
    : options = options ?? AntigravityAcpOptions() {
    app = AcpAgentApp.v1(
      implementation: Implementation(
        name: 'dart_acp_antigravity',
        title: 'Antigravity',
        version: dartAcpAntigravityVersion,
      ),
      capabilities: AgentCapabilities(
        loadSession: false,
        promptCapabilities: PromptCapabilities(
          image: false,
          audio: false,
          embeddedContext: true,
        ),
        mcpCapabilities: McpCapabilities(http: false, sse: false),
        sessionCapabilities: SessionCapabilities(),
        auth: AgentAuthCapabilities(),
      ),
    ).onNewSession(_newSession).onPrompt(_prompt).onCancelSession(_cancel);
  }

  /// Adapter options shared by every session.
  final AntigravityAcpOptions options;

  /// Immutable typed ACP application.
  late final AcpAgentApp app;

  final Map<String, _AntigravitySession> _sessions =
      <String, _AntigravitySession>{};
  int _sessionCounter = 0;
  Future<void>? _disposeFuture;

  /// Stops active child processes and rejects further prompts, idempotently.
  Future<void> dispose() => _disposeFuture ??= _dispose();

  Future<void> _dispose() async {
    final List<_AntigravitySession> sessions = _sessions.values.toList();
    _sessions.clear();
    for (final _AntigravitySession session in sessions) {
      session.cancelRequested = true;
      if (session.activeProcess case final Process process) {
        await _stopProcess(process, timeout: options.shutdownTimeout);
      }
    }
  }

  Future<NewSessionResponse> _newSession(
    AcpAgentRequestContext<NewSessionRequest> context,
  ) async {
    if (_disposeFuture != null) {
      throw JsonRpcRequestException.invalidRequest(
        data: <String, Object?>{'reason': 'The adapter has been disposed.'},
      );
    }
    final String cwd = context.params.cwd;
    if (cwd.trim().isEmpty) {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{'cwd': cwd},
      );
    }
    final SessionId sessionId = SessionId(
      'antigravity-${DateTime.now().microsecondsSinceEpoch}-'
      '${++_sessionCounter}',
    );
    _sessions[sessionId.value] = _AntigravitySession(
      id: sessionId,
      cwd: cwd,
      additionalDirectories: List<String>.unmodifiable(
        context.params.additionalDirectories ?? const <String>[],
      ),
    );
    return NewSessionResponse(sessionId: sessionId);
  }

  Future<PromptResponse> _prompt(
    AcpAgentRequestContext<PromptRequest> context,
  ) async {
    final PromptRequest request = context.params;
    final _AntigravitySession session = _requireSession(request.sessionId);
    if (session.activeProcess != null) {
      throw JsonRpcRequestException.invalidRequest(
        data: <String, Object?>{
          'sessionId': session.id.value,
          'reason': 'A prompt is already running for this session.',
        },
      );
    }
    final String promptText = renderAntigravityPrompt(request.prompt);
    if (promptText.trim().isEmpty) {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{
          'reason': 'The prompt contains no text the Antigravity CLI accepts.',
        },
      );
    }

    session.cancelRequested = false;
    final String executable =
        options.executable ??
        findAntigravityExecutable(environment: _mergedEnvironment());
    final List<String> arguments = _arguments(session, promptText);
    final Process process;
    try {
      process = await Process.start(
        executable,
        arguments,
        workingDirectory: session.cwd,
        environment: options.environment,
        includeParentEnvironment: options.includeParentEnvironment,
        runInShell: Platform.isWindows,
      );
    } on Object catch (error) {
      throw JsonRpcRequestException.internalError(
        data: <String, Object?>{
          'message': 'Unable to start the Antigravity CLI print-mode process.',
          'executable': executable,
          'cause': '$error',
        },
      );
    }
    session.activeProcess = process;
    final _StderrCapture stderrCapture = _StderrCapture(
      input: process.stderr,
      maximumCharacters: options.maximumStderrTailCharacters,
      onStderr: options.onStderr,
    );

    AntigravityResultEvent? result;
    String? unexpectedConversationId;
    final int exitCode;
    try {
      unawaited(
        process.stdin.close().then<void>((_) {}, onError: (Object _) {}),
      );
      final Stream<String> lines = process.stdout
          .transform(const Utf8Decoder(allowMalformed: true))
          .transform(const LineSplitter());
      await for (final String line in lines) {
        switch (AntigravityEvent.tryParse(line)) {
          case final AntigravityInitEvent init:
            if (init.conversationId.isEmpty) {
              break;
            }
            if (session.conversationId == null) {
              session.conversationId = init.conversationId;
            } else if (init.conversationId != session.conversationId) {
              // An unknown --conversation id makes the CLI silently start a
              // fresh conversation; surface that as a resume failure instead
              // of continuing without the session's history.
              unexpectedConversationId = init.conversationId;
              process.kill();
            }
          case final AntigravityStepUpdateEvent step:
            for (final SessionUpdate update in session.mapper.map(step)) {
              await context.client.updateSession(
                SessionNotification(sessionId: session.id, update: update),
              );
            }
          case final AntigravityResultEvent value:
            result = value;
          case AntigravityInitEvent() || null:
            break;
        }
      }
      exitCode = await process.exitCode;
    } finally {
      session.activeProcess = null;
      await stderrCapture.close();
    }

    if (session.cancelRequested) {
      return PromptResponse(stopReason: StopReason.cancelled);
    }
    if (unexpectedConversationId != null) {
      throw JsonRpcRequestException.internalError(
        data: <String, Object?>{
          'message':
              'The Antigravity CLI could not resume conversation '
              '${session.conversationId}; it started '
              '$unexpectedConversationId instead.',
          'sessionId': session.id.value,
        },
      );
    }
    if (result == null || !result.isSuccess || exitCode != 0) {
      throw JsonRpcRequestException.internalError(
        data: <String, Object?>{
          'message': 'The Antigravity CLI run did not complete successfully.',
          'executable': executable,
          'exitCode': exitCode,
          if (result != null) 'status': result.status,
          if (stderrCapture.value.trim().isNotEmpty)
            'stderrTail': stderrCapture.value.trim(),
        },
      );
    }
    return PromptResponse(stopReason: StopReason.endTurn);
  }

  Future<void> _cancel(
    AcpAgentNotificationContext<CancelNotification> context,
  ) async {
    final _AntigravitySession? session =
        _sessions[context.params.sessionId.value];
    final Process? process = session?.activeProcess;
    if (session == null || process == null) {
      return;
    }
    session.cancelRequested = true;
    await _stopProcess(process, timeout: options.shutdownTimeout);
  }

  List<String> _arguments(_AntigravitySession session, String promptText) {
    final Set<String> addDirectories = <String>{
      ...options.additionalDirectories,
      ...session.additionalDirectories,
    };
    return <String>[
      '--print',
      promptText,
      '--output-format',
      'stream-json',
      if (session.conversationId case final String conversation) ...<String>[
        '--conversation',
        conversation,
      ],
      if (options.model case final String model) ...<String>['--model', model],
      if (options.agentName case final String agent) ...<String>[
        '--agent',
        agent,
      ],
      if (options.effort
          case final AntigravityReasoningEffort effort) ...<String>[
        '--effort',
        effort.name,
      ],
      ...switch (options.permissionPolicy) {
        AntigravityPermissionPolicy.requestReview => const <String>[],
        AntigravityPermissionPolicy.acceptEdits => const <String>[
          '--mode',
          'accept-edits',
        ],
        AntigravityPermissionPolicy.plan => const <String>['--mode', 'plan'],
        AntigravityPermissionPolicy.bypassPermissions => const <String>[
          '--dangerously-skip-permissions',
        ],
      },
      for (final String directory in addDirectories) ...<String>[
        '--add-dir',
        directory,
      ],
      if (options.promptTimeout case final Duration timeout) ...<String>[
        '--print-timeout',
        '${timeout.inSeconds}s',
      ],
    ];
  }

  Map<String, String> _mergedEnvironment() => <String, String>{
    if (options.includeParentEnvironment) ...Platform.environment,
    ...?options.environment,
  };

  _AntigravitySession _requireSession(SessionId id) {
    final _AntigravitySession? session = _sessions[id.value];
    if (session == null) {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{'sessionId': id.value},
      );
    }
    return session;
  }
}

Future<void> _stopProcess(Process process, {required Duration timeout}) async {
  final Future<int> exitCode = process.exitCode;
  process.kill();
  try {
    await exitCode.timeout(timeout);
    return;
  } on TimeoutException {
    // The CLI ignored the graceful termination request. Escalate once and
    // keep the final wait bounded.
  }
  if (!Platform.isWindows) {
    process.kill(ProcessSignal.sigkill);
  } else {
    process.kill();
  }
  try {
    await exitCode.timeout(timeout);
  } on TimeoutException {
    // Give up; the exit future still resolves in the background.
  }
}

final class _AntigravitySession {
  _AntigravitySession({
    required this.id,
    required this.cwd,
    required this.additionalDirectories,
  });

  final SessionId id;
  final String cwd;
  final List<String> additionalDirectories;
  final AntigravityEventMapper mapper = AntigravityEventMapper();
  String? conversationId;
  Process? activeProcess;
  bool cancelRequested = false;
}

final class _StderrCapture {
  _StderrCapture({
    required Stream<List<int>> input,
    required this.maximumCharacters,
    required AntigravityStderrHandler? onStderr,
  }) : _onStderr = onStderr {
    _subscription = input
        .transform(const Utf8Decoder(allowMalformed: true))
        .listen(
          _observe,
          onError: (Object error, StackTrace _) {
            _observe('Unable to read Antigravity stderr: $error\n');
          },
        );
  }

  final int maximumCharacters;
  final AntigravityStderrHandler? _onStderr;
  late final StreamSubscription<String> _subscription;
  String value = '';

  void _observe(String chunk) {
    if (maximumCharacters > 0) {
      value += chunk;
      if (value.length > maximumCharacters) {
        value = value.substring(value.length - maximumCharacters);
      }
    }
    try {
      _onStderr?.call(chunk);
    } on Object {
      // Observational callbacks cannot alter process lifecycle.
    }
  }

  Future<void> close() => _subscription.cancel();
}
