part of 'application.dart';

/// A local v2 session operation was attempted after disposal.
final class AcpV2SessionStateException implements Exception {
  /// Creates a session state error.
  const AcpV2SessionStateException(this.message);

  /// Concise diagnostic.
  final String message;

  @override
  String toString() => 'AcpV2SessionStateException: $message';
}

/// Idempotent registration for a local v2 update route.
final class AcpV2SessionSubscription {
  AcpV2SessionSubscription._(this._dispose);

  void Function()? _dispose;

  /// Removes this route.
  void dispose() {
    final void Function()? callback = _dispose;
    _dispose = null;
    callback?.call();
  }
}

/// Kind of message stored in a v2 snapshot.
enum AcpV2MessageKind {
  /// User message.
  user,

  /// Agent-visible response.
  agent,

  /// Agent thought/reasoning message.
  thought,
}

/// Materialized message content after replacement and chunk semantics.
final class AcpV2MessageState {
  /// Creates message state.
  const AcpV2MessageState({
    required this.messageId,
    required this.kind,
    required this.content,
  });

  /// Agent-owned message ID.
  final v2.MessageId messageId;

  /// Message role/category.
  final AcpV2MessageKind kind;

  /// Current complete content.
  final List<v2.ContentBlock> content;
}

/// Materialized terminal state.
final class AcpV2TerminalState {
  /// Creates terminal state.
  const AcpV2TerminalState({
    required this.terminalId,
    required this.output,
    this.command,
    this.cwd,
    this.exitStatus,
  });

  /// Agent-owned terminal ID.
  final v2.TerminalId terminalId;

  /// Current command.
  final String? command;

  /// Current working directory.
  final v2.AbsolutePath? cwd;

  /// Current output bytes.
  final List<int> output;

  /// Current exit status.
  final v2.TerminalExitStatus? exitStatus;
}

/// Materialized client-side session state.
final class AcpV2SessionSnapshot {
  AcpV2SessionSnapshot._();

  AcpV2SessionSnapshot._copy(
    Map<String, AcpV2MessageState> messages,
    Map<String, AcpV2TerminalState> terminals,
    this.state,
  ) : messages = Map<String, AcpV2MessageState>.unmodifiable(messages),
      terminals = Map<String, AcpV2TerminalState>.unmodifiable(terminals);

  /// Messages keyed by exact message ID.
  Map<String, AcpV2MessageState> messages = <String, AcpV2MessageState>{};

  /// Terminals keyed by exact terminal ID.
  Map<String, AcpV2TerminalState> terminals = <String, AcpV2TerminalState>{};

  /// Latest foreground state, including custom variants.
  v2.StateUpdate? state;

  /// Returns an immutable point-in-time view.
  AcpV2SessionSnapshot copy() =>
      AcpV2SessionSnapshot._copy(messages, terminals, state);

  void _apply(v2.SessionUpdate update) {
    switch (update) {
      case v2.SessionUpdateUserMessage(:final value):
        _applyMessagePatch(
          messages,
          id: value.messageId,
          kind: AcpV2MessageKind.user,
          content: value.content,
        );
      case v2.SessionUpdateUserMessageChunk(:final value):
        _appendMessageChunk(messages, value, AcpV2MessageKind.user);
      case v2.SessionUpdateAgentMessage(:final value):
        _applyMessagePatch(
          messages,
          id: value.messageId,
          kind: AcpV2MessageKind.agent,
          content: value.content,
        );
      case v2.SessionUpdateAgentMessageChunk(:final value):
        _appendMessageChunk(messages, value, AcpV2MessageKind.agent);
      case v2.SessionUpdateAgentThought(:final value):
        _applyMessagePatch(
          messages,
          id: value.messageId,
          kind: AcpV2MessageKind.thought,
          content: value.content,
        );
      case v2.SessionUpdateAgentThoughtChunk(:final value):
        _appendMessageChunk(messages, value, AcpV2MessageKind.thought);
      case v2.SessionUpdateStateUpdate(:final value):
        state = value;
      case v2.SessionUpdateTerminalUpdate(:final value):
        final AcpV2TerminalState? previous = terminals[value.terminalId.value];
        final v2.TerminalOutput? output = value.output.applyTo(
          previous == null
              ? null
              : v2.TerminalOutput(data: base64Encode(previous.output)),
        );
        terminals[value.terminalId.value] = AcpV2TerminalState(
          terminalId: value.terminalId,
          command: value.command.applyTo(previous?.command),
          cwd: value.cwd.applyTo(previous?.cwd),
          output: List<int>.unmodifiable(
            output == null ? const <int>[] : base64Decode(output.data),
          ),
          exitStatus: value.exitStatus.applyTo(previous?.exitStatus),
        );
      case v2.SessionUpdateTerminalOutputChunk(:final value):
        final AcpV2TerminalState? previous = terminals[value.terminalId.value];
        terminals[value.terminalId.value] = AcpV2TerminalState(
          terminalId: value.terminalId,
          command: previous?.command,
          cwd: previous?.cwd,
          output: List<int>.unmodifiable(<int>[
            ...?previous?.output,
            ...base64Decode(value.data),
          ]),
          exitStatus: previous?.exitStatus,
        );
      default:
        break;
    }
  }
}

/// Base event emitted by active v2 sessions and prompt turns.
sealed class AcpV2SessionEvent {
  const AcpV2SessionEvent();
}

/// One sequenced session update.
final class AcpV2SessionUpdateEvent extends AcpV2SessionEvent {
  /// Creates an update event.
  const AcpV2SessionUpdateEvent({
    required this.sequence,
    required this.notification,
    required this.snapshot,
  });

  /// Monotonic local observation sequence.
  final int sequence;

  /// Full wire notification.
  final v2.UpdateSessionNotification notification;

  /// State after applying this update.
  final AcpV2SessionSnapshot snapshot;

  /// Typed update.
  v2.SessionUpdate get update => notification.update;
}

/// Prompt acceptance event; this is not completion.
final class AcpV2PromptAcceptedEvent extends AcpV2SessionEvent {
  /// Creates an acceptance event.
  const AcpV2PromptAcceptedEvent(this.response);

  /// Wire acknowledgement.
  final v2.PromptResponse response;
}

/// Information from the first post-acceptance idle update.
final class AcpV2PromptCompletion {
  /// Creates completion details.
  const AcpV2PromptCompletion({
    required this.notification,
    required this.state,
  });

  /// Idle notification that completed the turn.
  final v2.UpdateSessionNotification notification;

  /// Idle state.
  final v2.IdleStateUpdate state;

  /// Optional stop reason after clear/omission handling.
  v2.StopReason? get stopReason => state.stopReason.valueOrNull;
}

/// Prompt completion event.
final class AcpV2PromptCompletedEvent extends AcpV2SessionEvent {
  /// Creates a completion event.
  const AcpV2PromptCompletedEvent(this.completion);

  /// Completion details.
  final AcpV2PromptCompletion completion;
}

/// Result of v2 text collection.
final class AcpV2CollectedText {
  /// Creates collected text.
  const AcpV2CollectedText({
    required this.text,
    required this.thoughts,
    required this.completion,
  });

  /// Materialized agent-message text.
  final String text;

  /// Materialized thought text when requested.
  final String thoughts;

  /// Idle completion.
  final AcpV2PromptCompletion completion;
}

/// Immutable builder for `session/new`.
final class AcpV2SessionBuilder {
  AcpV2SessionBuilder._(this._context, this._router, this._request);

  final AcpV2ClientContext _context;
  final _AcpV2SessionRouter _router;
  final v2.NewSessionRequest _request;

  /// Exact request that will be sent.
  v2.NewSessionRequest toRequest() =>
      v2.NewSessionRequest.fromJson(_request.toJson());

  /// Returns a copy with complete additional-directory replacement.
  AcpV2SessionBuilder withAdditionalDirectories(
    Iterable<v2.AbsolutePath> directories,
  ) => AcpV2SessionBuilder._(
    _context,
    _router,
    v2.NewSessionRequest(
      cwd: _request.cwd,
      additionalDirectories: List<v2.AbsolutePath>.of(directories),
      mcpServers: _request.mcpServers,
      meta: _request.meta,
    ),
  );

  /// Returns a copy with one appended MCP server.
  AcpV2SessionBuilder withMcpServer(v2.McpServer server) =>
      AcpV2SessionBuilder._(
        _context,
        _router,
        v2.NewSessionRequest(
          cwd: _request.cwd,
          additionalDirectories: _request.additionalDirectories,
          mcpServers: <v2.McpServer>[...?_request.mcpServers, server],
          meta: _request.meta,
        ),
      );

  /// Creates and attaches the session, retaining updates raced with response.
  Future<AcpV2ActiveSession> start({
    CancellationToken? cancellationToken,
  }) async {
    _validateV2SessionSetupCapabilities(
      _context,
      additionalDirectories: _request.additionalDirectories,
      mcpServers: _request.mcpServers,
      method: v2_methods.sessionNewMethod.name,
    );
    final channel = _AcpV2SessionChannel();
    final _AcpV2PendingRoute pending = _router.beginPending(channel);
    try {
      final response = await _context._request(
        v2_methods.sessionNewMethod,
        toRequest(),
        cancellationToken: cancellationToken,
      );
      return AcpV2ActiveSession._(
        context: _context,
        channel: channel,
        subscription: pending.activate(response.sessionId),
        sessionId: response.sessionId,
        configOptions: response.configOptions,
        newSessionResponse: response,
      );
    } on Object catch (error, stackTrace) {
      pending.dispose();
      channel.fail(error, stackTrace);
      rethrow;
    }
  }

  /// Runs an operation with guaranteed local disposal.
  Future<T> withSession<T>(
    FutureOr<T> Function(AcpV2ActiveSession session) operation,
  ) async {
    final AcpV2ActiveSession session = await start();
    try {
      return await operation(session);
    } finally {
      session.dispose();
    }
  }
}

/// Session lifecycle helpers for one initialized client connection.
final class AcpV2Sessions {
  AcpV2Sessions._(this._context, this._router);

  final AcpV2ClientContext _context;
  final _AcpV2SessionRouter _router;

  /// Builds a new session from a generated request.
  AcpV2SessionBuilder build(v2.NewSessionRequest request) =>
      AcpV2SessionBuilder._(_context, _router, request);

  /// Builds a new session for [cwd].
  AcpV2SessionBuilder newSession({
    required v2.AbsolutePath cwd,
    Iterable<v2.AbsolutePath>? additionalDirectories,
    Iterable<v2.McpServer>? mcpServers,
    AcpJsonObject? meta,
  }) => build(
    v2.NewSessionRequest(
      cwd: cwd,
      additionalDirectories: additionalDirectories?.toList(),
      mcpServers: mcpServers?.toList(),
      meta: meta,
    ),
  );

  /// Resumes a session and captures replay updates before the response.
  Future<AcpV2ActiveSession> resume(
    v2.ResumeSessionRequest request, {
    CancellationToken? cancellationToken,
  }) async {
    _validateV2SessionSetupCapabilities(
      _context,
      additionalDirectories: request.additionalDirectories,
      mcpServers: request.mcpServers,
      method: v2_methods.sessionResumeMethod.name,
    );
    final channel = _AcpV2SessionChannel();
    final AcpV2SessionSubscription subscription = _router.attach(
      request.sessionId,
      channel,
    );
    try {
      final response = await _context._request(
        v2_methods.sessionResumeMethod,
        request,
        cancellationToken: cancellationToken,
      );
      return AcpV2ActiveSession._(
        context: _context,
        channel: channel,
        subscription: subscription,
        sessionId: request.sessionId,
        configOptions: response.configOptions,
      );
    } on Object catch (error, stackTrace) {
      subscription.dispose();
      channel.fail(error, stackTrace);
      rethrow;
    }
  }

  /// Lists sessions.
  Future<v2.ListSessionsResponse> list(
    v2.ListSessionsRequest request, {
    CancellationToken? cancellationToken,
  }) => _context._request(
    v2_methods.sessionListMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Deletes a session when the separate delete marker is advertised.
  Future<v2.DeleteSessionResponse> delete(
    v2.DeleteSessionRequest request, {
    CancellationToken? cancellationToken,
  }) => _context._request(
    v2_methods.sessionDeleteMethod,
    request,
    cancellationToken: cancellationToken,
  );
}

/// A locally routed draft-v2 session.
final class AcpV2ActiveSession {
  AcpV2ActiveSession._({
    required this.sessionId,
    required AcpV2ClientContext context,
    required _AcpV2SessionChannel channel,
    required AcpV2SessionSubscription subscription,
    this.configOptions,
    this.newSessionResponse,
  }) : _context = context,
       _channel = channel,
       _subscription = subscription {
    _closeRegistration = context.lifecycle.cancellationToken.register(
      (Object? reason) => _fail(
        reason ?? const AcpV2SessionStateException('ACP v2 connection closed'),
      ),
    );
  }

  final AcpV2ClientContext _context;
  final _AcpV2SessionChannel _channel;
  final AcpV2SessionSubscription _subscription;
  late final CancellationRegistration _closeRegistration;
  _AcpV2PromptTurnState? _collectingTurn;
  Completer<void>? _collectorAbort;
  bool _disposed = false;

  /// Protocol session identifier.
  final v2.SessionId sessionId;

  /// Initial config options.
  final List<v2.SessionConfigOption>? configOptions;

  /// Creation response, or `null` for resume.
  final v2.NewSessionResponse? newSessionResponse;

  /// Broadcast raw event stream; collectors do not consume it.
  Stream<AcpV2SessionEvent> get events => _channel.events;

  /// Latest materialized state.
  AcpV2SessionSnapshot get snapshot => _channel._snapshot.copy();

  /// Starts a turn; acceptance and idle completion remain separate.
  AcpV2PromptTurn prompt({
    required Iterable<v2.ContentBlock> content,
    CancellationToken? cancellationToken,
    AcpJsonObject? meta,
  }) {
    _ensureActive();
    final List<v2.ContentBlock> blocks = List<v2.ContentBlock>.of(content);
    _validateV2PromptCapabilities(_context, blocks);
    final state = _channel.beginTurn();
    final response = _context._request(
      v2_methods.sessionPromptMethod,
      v2.PromptRequest(sessionId: sessionId, prompt: blocks, meta: meta),
      cancellationToken: cancellationToken,
    );
    unawaited(
      response.then<void>(
        state.accept,
        onError: (Object error, StackTrace stackTrace) {
          state.fail(error, stackTrace);
        },
      ),
    );
    return AcpV2PromptTurn._(this, state);
  }

  /// Sends session cancellation.
  Future<void> cancel({AcpJsonObject? meta}) {
    _ensureActive();
    return _context.notify(
      v2_methods.sessionCancelMethod,
      v2.CancelSessionNotification(sessionId: sessionId, meta: meta),
    );
  }

  /// Sends a generated configuration option update.
  Future<v2.SetSessionConfigOptionResponse> setConfigOption(
    v2.SetSessionConfigOptionRequest request, {
    CancellationToken? cancellationToken,
  }) {
    _ensureActive();
    return _context._request(
      v2_methods.sessionSetConfigOptionMethod,
      request,
      cancellationToken: cancellationToken,
    );
  }

  /// Closes the protocol session then disposes local routing.
  Future<v2.CloseSessionResponse> close({
    CancellationToken? cancellationToken,
    AcpJsonObject? meta,
  }) async {
    _ensureActive();
    try {
      return await _context._request(
        v2_methods.sessionCloseMethod,
        v2.CloseSessionRequest(sessionId: sessionId, meta: meta),
        cancellationToken: cancellationToken,
      );
    } finally {
      dispose();
    }
  }

  /// Removes local routing without closing the protocol session.
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _closeRegistration.dispose();
    _subscription.dispose();
    _abortCollector(
      const AcpV2SessionStateException('Session disposed during collection'),
    );
    _channel.close();
  }

  Future<AcpV2CollectedText> _collect(
    _AcpV2PromptTurnState turn, {
    required bool includeThoughts,
  }) async {
    _ensureActive();
    if (_collectingTurn != null) {
      final error = const AcpV2SessionStateException(
        'Text cannot be attributed across overlapping ACP v2 prompt turns',
      );
      _abortCollector(error);
      throw error;
    }
    _collectingTurn = turn;
    final Completer<void> abort = Completer<void>();
    _collectorAbort = abort;
    try {
      final AcpV2PromptCompletion completion =
          await Future.any(<Future<AcpV2PromptCompletion>>[
            turn.completed,
            abort.future.then<AcpV2PromptCompletion>(
              (_) => throw const AcpV2SessionStateException(
                'Text collection was aborted',
              ),
            ),
          ]);
      final Map<String, List<v2.ContentBlock>> messages =
          <String, List<v2.ContentBlock>>{};
      final Map<String, List<v2.ContentBlock>> thoughts =
          <String, List<v2.ContentBlock>>{};
      final List<String> messageOrder = <String>[];
      final List<String> thoughtOrder = <String>[];
      for (final AcpV2SessionUpdateEvent event in turn.updates) {
        switch (event.update) {
          case v2.SessionUpdateAgentMessage(:final value):
            _collectPatch(
              messages,
              messageOrder,
              value.messageId,
              value.content,
            );
          case v2.SessionUpdateAgentMessageChunk(:final value):
            _collectChunk(messages, messageOrder, value);
          case v2.SessionUpdateAgentThought(:final value) when includeThoughts:
            _collectPatch(
              thoughts,
              thoughtOrder,
              value.messageId,
              value.content,
            );
          case v2.SessionUpdateAgentThoughtChunk(:final value)
              when includeThoughts:
            _collectChunk(thoughts, thoughtOrder, value);
          default:
            break;
        }
      }
      return AcpV2CollectedText(
        text: _textFrom(messages, messageOrder),
        thoughts: _textFrom(thoughts, thoughtOrder),
        completion: completion,
      );
    } finally {
      if (identical(_collectingTurn, turn)) {
        _collectingTurn = null;
        _collectorAbort = null;
      }
    }
  }

  void _abortCollector(Object error) {
    final Completer<void>? abort = _collectorAbort;
    if (abort != null && !abort.isCompleted) {
      abort.completeError(error);
    }
    _collectingTurn = null;
    _collectorAbort = null;
  }

  void _fail(Object error) {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _subscription.dispose();
    _abortCollector(error);
    _channel.fail(error);
  }

  void _ensureActive() {
    if (_disposed) {
      throw const AcpV2SessionStateException('Session route is inactive');
    }
  }
}

/// One prompt turn with independent acceptance and idle completion.
final class AcpV2PromptTurn {
  AcpV2PromptTurn._(this._session, this._state);

  final AcpV2ActiveSession _session;
  final _AcpV2PromptTurnState _state;

  /// Events observed after prompt submission.
  Stream<AcpV2SessionEvent> get events => _state.events;

  /// Resolves when the prompt request is accepted.
  Future<v2.PromptResponse> get accepted => _state.accepted;

  /// Resolves at the first idle state observed after acceptance.
  Future<AcpV2PromptCompletion> get completed => _state.completed;

  /// Cancels session work.
  Future<void> cancel() => _session.cancel();

  /// Collects materialized agent message text without consuming raw events.
  Future<AcpV2CollectedText> collectText({bool includeThoughts = false}) =>
      _session._collect(_state, includeThoughts: includeThoughts);
}

void _validateV2SessionSetupCapabilities(
  AcpV2ClientContext context, {
  required Iterable<v2.AbsolutePath>? additionalDirectories,
  required Iterable<v2.McpServer>? mcpServers,
  required String method,
}) {
  if (additionalDirectories?.isNotEmpty ?? false) {
    context.lifecycle.peerCapabilities._require(
      'agentCapabilities.session.additionalDirectories',
      method,
    );
  }
  for (final v2.McpServer server in mcpServers ?? const <v2.McpServer>[]) {
    final String? capability = switch (server) {
      v2.McpServerStdioVariant() => 'agentCapabilities.session.mcp.stdio',
      v2.McpServerHttpVariant() => 'agentCapabilities.session.mcp.http',
      _ => null,
    };
    context.lifecycle.peerCapabilities._require(capability, method);
  }
}

void _validateV2PromptCapabilities(
  AcpV2ClientContext context,
  Iterable<v2.ContentBlock> blocks,
) {
  for (final v2.ContentBlock block in blocks) {
    final String? capability = switch (block) {
      v2.ContentBlockImage() => 'agentCapabilities.session.prompt.image',
      v2.ContentBlockAudio() => 'agentCapabilities.session.prompt.audio',
      v2.ContentBlockResource() =>
        'agentCapabilities.session.prompt.embeddedContext',
      _ => null,
    };
    context.lifecycle.peerCapabilities._require(
      capability,
      v2_methods.sessionPromptMethod.name,
    );
  }
}

void _collectPatch(
  Map<String, List<v2.ContentBlock>> target,
  List<String> order,
  v2.MessageId id,
  AcpPatch<List<v2.ContentBlock>> patch,
) {
  if (!target.containsKey(id.value)) {
    order.add(id.value);
    target[id.value] = <v2.ContentBlock>[];
  }
  final List<v2.ContentBlock>? result = patch.applyTo(target[id.value]);
  target[id.value] = <v2.ContentBlock>[...?result];
}

void _collectChunk(
  Map<String, List<v2.ContentBlock>> target,
  List<String> order,
  v2.ContentChunk chunk,
) {
  if (!target.containsKey(chunk.messageId.value)) {
    order.add(chunk.messageId.value);
    target[chunk.messageId.value] = <v2.ContentBlock>[];
  }
  target[chunk.messageId.value]!.add(chunk.content);
}

String _textFrom(
  Map<String, List<v2.ContentBlock>> target,
  List<String> order,
) {
  final StringBuffer result = StringBuffer();
  for (final String id in order) {
    for (final v2.ContentBlock block
        in target[id] ?? const <v2.ContentBlock>[]) {
      if (block case v2.ContentBlockText(:final value)) {
        result.write(value.text);
      }
    }
  }
  return result.toString();
}
