import 'dart:async';

import '../context_usage.dart';
import '../errors.dart';
import '../hooks.dart';
import '../json.dart';
import '../mcp.dart';
import '../options.dart';
import '../permissions.dart';
import '../sessions/session_mirror_batcher.dart';
import '../sessions/session_store.dart';
import '../transport/transport.dart';
import '../uuid.dart';

const _deferringTaskTypes = {'local_agent', 'local_workflow'};
const _terminalTaskStatuses = {'completed', 'failed', 'killed', 'stopped'};

/// Routes the bidirectional Claude Code control protocol over a [Transport].
final class ControlChannel {
  /// Creates a control channel.
  ControlChannel({required this.transport, required this.options}) {
    final store = options.sessionStore;
    if (store != null) {
      _mirrorBatcher = SessionMirrorBatcher(
        store: store,
        projectsDirectory: projectsDirectoryForEnvironment(options.environment),
        maxPendingEntries:
            options.sessionStoreFlush == SessionStoreFlushMode.eager ? 0 : 500,
        maxPendingBytes:
            options.sessionStoreFlush == SessionStoreFlushMode.eager
            ? 0
            : 1024 * 1024,
        onError: _reportMirrorError,
      );
    }
  }

  /// Underlying raw transport.
  final Transport transport;

  /// Session options used to configure callbacks and timeouts.
  final ClaudeAgentOptions options;

  final StreamController<JsonMap> _messages = StreamController<JsonMap>();
  final Map<String, Completer<JsonMap>> _pending = {};
  final Map<String, HookCallback> _hookCallbacks = {};
  final Set<String> _cancelledIncoming = {};
  final Set<String> _inflightTasks = {};
  final Completer<void> _runEnded = Completer<void>();
  StreamSubscription<JsonMap>? _readSubscription;
  Future<void> _routingTail = Future<void>.value();
  SessionMirrorBatcher? _mirrorBatcher;
  JsonMap? _initializationResult;
  int _requestCounter = 0;
  int _callbackCounter = 0;
  bool _closed = false;
  bool _initialized = false;
  String? _lastErrorResultText;

  /// Non-control messages received from the CLI.
  Stream<JsonMap> get messages => _messages.stream;

  /// Information returned by the initialize handshake.
  JsonMap? get initializationResult => _initializationResult;

  /// Starts routing transport output.
  Future<void> start() async {
    if (_readSubscription != null) return;
    _readSubscription = transport.messages.listen(
      (message) {
        _routingTail = _routingTail
            .catchError((Object error, StackTrace stackTrace) {
              _handleReadError(error, stackTrace);
            })
            .then((_) => _routeMessage(message));
      },
      onError: _handleReadError,
      onDone: _handleReadDone,
      cancelOnError: false,
    );
  }

  /// Performs the SDK initialize handshake.
  Future<JsonMap> initialize() async {
    if (_initialized) return _initializationResult ?? const {};
    final hooks = <String, Object?>{};
    for (final eventEntry in options.hooks.entries) {
      final configs = <Object?>[];
      for (final matcher in eventEntry.value) {
        final callbackIds = <String>[];
        for (final callback in matcher.hooks) {
          final id = 'hook_${_callbackCounter++}';
          _hookCallbacks[id] = callback;
          callbackIds.add(id);
        }
        configs.add({
          'matcher': matcher.matcher,
          'hookCallbackIds': callbackIds,
          if (matcher.timeout != null)
            'timeout': matcher.timeout!.inMilliseconds,
        });
      }
      if (configs.isNotEmpty) hooks[eventEntry.key.wireValue] = configs;
    }
    final request = <String, Object?>{
      'subtype': 'initialize',
      'hooks': hooks.isEmpty ? null : hooks,
      if (options.agents.isNotEmpty)
        'agents': options.agents.map(
          (name, agent) => MapEntry(name, agent.toJson()),
        ),
      if (options.systemPrompt case ClaudeCodeSystemPrompt(
        :final excludeDynamicSections?,
      ))
        'excludeDynamicSections': excludeDynamicSections,
      if (options.skills case NamedSkills(:final names)) 'skills': names,
    };
    final result = await sendControlRequest(
      request,
      timeout: options.initializeTimeout < const Duration(seconds: 60)
          ? const Duration(seconds: 60)
          : options.initializeTimeout,
    );
    _initialized = true;
    _initializationResult = result;
    return result;
  }

  Future<void> _routeMessage(JsonMap message) async {
    if (_closed) return;
    switch (message['type']) {
      case 'control_response':
        final response = asJsonMap(message['response'], 'control response');
        final id = optionalString(response, 'request_id', 'control response');
        if (id == null) return;
        final pending = _pending.remove(id);
        if (pending == null || pending.isCompleted) return;
        if (response['subtype'] == 'error') {
          pending.completeError(
            ControlProtocolException(
              optionalString(response, 'error', 'control response') ??
                  'Unknown control request failure',
            ),
          );
        } else {
          final value = response['response'];
          pending.complete(
            value == null
                ? const {}
                : asJsonMap(value, 'control response payload'),
          );
        }
        return;
      case 'control_request':
        unawaited(_handleIncomingRequest(message));
        return;
      case 'control_cancel_request':
        final id = message['request_id'];
        if (id is String) _cancelledIncoming.add(id);
        return;
      case 'transcript_mirror':
        // Transcript mirror frames are consumed by SessionMirrorBatcher when
        // attached by the higher-level client. They never enter the public
        // message stream.
        final path = message['filePath'];
        final entries = message['entries'];
        if (path is String && entries is List<Object?>) {
          _mirrorBatcher?.enqueue(
            path,
            entries
                .map((value) => asJsonMap(value, 'transcript mirror entry'))
                .toList(growable: false),
          );
        }
        return;
      case 'system':
        _trackTaskLifecycle(message);
        _messages.add(message);
        return;
      case 'result':
        await _mirrorBatcher?.flush();
        if (message['is_error'] == true) {
          final errors = message['errors'];
          _lastErrorResultText = errors is List<Object?>
              ? errors.whereType<String>().join('; ')
              : '${message['subtype'] ?? 'unknown error'}';
        } else {
          _lastErrorResultText = null;
        }
        if (_inflightTasks.isEmpty && !_runEnded.isCompleted) {
          _runEnded.complete();
        }
        _messages.add(message);
        return;
      default:
        _messages.add(message);
        return;
    }
  }

  Future<void> _reportMirrorError(SessionKey? key, String error) async {
    if (_messages.isClosed) return;
    _messages.add({
      'type': 'system',
      'subtype': 'mirror_error',
      'error': error,
      if (key != null) 'key': key.toJson(),
      'uuid': uuidV4(),
      'session_id': key?.sessionId ?? '',
    });
  }

  Future<void> _handleIncomingRequest(JsonMap envelope) async {
    final requestId = requiredString(envelope, 'request_id', 'control request');
    try {
      final request = asJsonMap(envelope['request'], 'control request payload');
      final subtype = requiredString(
        request,
        'subtype',
        'control request payload',
      );
      final response = switch (subtype) {
        'can_use_tool' => await _handlePermissionRequest(request),
        'hook_callback' => await _handleHookRequest(request),
        'mcp_message' => await _handleMcpRequest(request),
        _ => throw ControlProtocolException(
          'Unsupported incoming control request: $subtype',
        ),
      };
      if (_cancelledIncoming.remove(requestId) || _closed) return;
      await transport.write(
        encodeJsonLine({
          'type': 'control_response',
          'response': {
            'subtype': 'success',
            'request_id': requestId,
            'response': response,
          },
        }),
      );
    } catch (error) {
      if (_cancelledIncoming.remove(requestId) || _closed) return;
      await transport.write(
        encodeJsonLine({
          'type': 'control_response',
          'response': {
            'subtype': 'error',
            'request_id': requestId,
            'error': error.toString(),
          },
        }),
      );
    }
  }

  Future<JsonMap> _handlePermissionRequest(JsonMap request) async {
    final callback = options.canUseTool;
    if (callback == null) {
      throw const ControlProtocolException(
        'canUseTool callback is not configured',
      );
    }
    final originalInput = asJsonMap(
      request['input'],
      'permission request input',
    );
    final suggestions = request['permission_suggestions'];
    final context = ToolPermissionContext(
      suggestions: suggestions is List<Object?>
          ? suggestions
                .map(
                  (value) => PermissionUpdate.fromJson(
                    asJsonMap(value, 'permission suggestion'),
                  ),
                )
                .toList(growable: false)
          : const [],
      toolUseId: optionalString(request, 'tool_use_id', 'permission request'),
      agentId: optionalString(request, 'agent_id', 'permission request'),
      blockedPath: optionalString(
        request,
        'blocked_path',
        'permission request',
      ),
      decisionReason: optionalString(
        request,
        'decision_reason',
        'permission request',
      ),
      title: optionalString(request, 'title', 'permission request'),
      displayName: optionalString(
        request,
        'display_name',
        'permission request',
      ),
      description: optionalString(request, 'description', 'permission request'),
    );
    final result = await callback(
      requiredString(request, 'tool_name', 'permission request'),
      originalInput,
      context,
    );
    return switch (result) {
      PermissionAllowed(:final updatedInput, :final updatedPermissions) => {
        'behavior': 'allow',
        'updatedInput': updatedInput ?? originalInput,
        if (updatedPermissions != null)
          'updatedPermissions': updatedPermissions
              .map((update) => update.toJson())
              .toList(growable: false),
      },
      PermissionDenied(:final message, :final shouldInterrupt) => {
        'behavior': 'deny',
        'message': message,
        if (shouldInterrupt) 'interrupt': true,
      },
    };
  }

  Future<JsonMap> _handleHookRequest(JsonMap request) async {
    final callbackId = requiredString(request, 'callback_id', 'hook callback');
    final callback = _hookCallbacks[callbackId];
    if (callback == null) {
      throw ControlProtocolException(
        'No hook callback registered for $callbackId',
      );
    }
    final input = HookInput.fromJson(
      asJsonMap(request['input'], 'hook callback input'),
    );
    final output = await callback(
      input,
      optionalString(request, 'tool_use_id', 'hook callback'),
    );
    return output.toJson();
  }

  Future<JsonMap> _handleMcpRequest(JsonMap request) async {
    final serverName = requiredString(request, 'server_name', 'MCP request');
    final servers = switch (options.mcp) {
      McpServers(:final servers) => servers,
      _ => const <String, McpServerConfig>{},
    };
    final server = servers[serverName];
    final message = asJsonMap(request['message'], 'MCP request message');
    final response = server is SdkMcpServer
        ? await server.handle(message)
        : <String, Object?>{
            'jsonrpc': '2.0',
            'id': message['id'],
            'error': {
              'code': -32601,
              'message': "SDK MCP server '$serverName' was not found",
            },
          };
    return {'mcp_response': response};
  }

  /// Sends an outgoing control request and returns its response payload.
  Future<JsonMap> sendControlRequest(
    JsonMap request, {
    Duration? timeout,
  }) async {
    if (_closed || !transport.isReady) {
      throw const CliConnectionException('Control channel is not connected');
    }
    final id = 'req_${++_requestCounter}_${uuidV4().substring(0, 8)}';
    final completer = Completer<JsonMap>();
    _pending[id] = completer;
    await transport.write(
      encodeJsonLine({
        'type': 'control_request',
        'request_id': id,
        'request': request,
      }),
    );
    final effectiveTimeout = timeout ?? options.controlRequestTimeout;
    try {
      return await completer.future.timeout(
        effectiveTimeout,
        onTimeout: () => throw ControlProtocolException(
          'Control request timed out: ${request['subtype']}',
        ),
      );
    } finally {
      _pending.remove(id);
    }
  }

  /// Requests interruption of the active turn.
  Future<void> interrupt() async {
    await sendControlRequest({'subtype': 'interrupt'});
  }

  /// Changes the active permission [mode].
  Future<void> setPermissionMode(PermissionMode mode) async {
    await sendControlRequest({
      'subtype': 'set_permission_mode',
      'mode': mode.wireValue,
    });
  }

  /// Changes the active [model], or restores the default when `null`.
  Future<void> setModel(String? model) async {
    await sendControlRequest({'subtype': 'set_model', 'model': model});
  }

  /// Rewinds checkpointed files to [userMessageId].
  Future<void> rewindFiles(String userMessageId) async {
    await sendControlRequest({
      'subtype': 'rewind_files',
      'user_message_id': userMessageId,
    });
  }

  /// Reconnects a failed MCP server.
  Future<void> reconnectMcpServer(String serverName) async {
    await sendControlRequest({
      'subtype': 'mcp_reconnect',
      'serverName': serverName,
    });
  }

  /// Enables or disables an MCP server.
  Future<void> toggleMcpServer(
    String serverName, {
    required bool enabled,
  }) async {
    await sendControlRequest({
      'subtype': 'mcp_toggle',
      'serverName': serverName,
      'enabled': enabled,
    });
  }

  /// Stops a delegated task.
  Future<void> stopTask(String taskId) async {
    await sendControlRequest({'subtype': 'stop_task', 'task_id': taskId});
  }

  /// Gets current MCP connection state.
  Future<McpStatus> getMcpStatus() async =>
      McpStatus.fromJson(await sendControlRequest({'subtype': 'mcp_status'}));

  /// Gets current context-window usage.
  Future<ContextUsage> getContextUsage() async => ContextUsage.fromJson(
    await sendControlRequest({'subtype': 'get_context_usage'}),
  );

  /// Writes a user input frame.
  Future<void> sendInput(JsonMap input) =>
      transport.write(encodeJsonLine(input));

  /// Writes every input and then closes stdin after the run-ending result.
  Future<void> streamInput(Stream<JsonMap> input) async {
    await for (final message in input) {
      if (_closed) break;
      await sendInput(message);
    }
    await waitForResultAndEndInput();
  }

  /// Waits for a result with no deferring task in flight, then closes stdin.
  Future<void> waitForResultAndEndInput() async {
    await _runEnded.future;
    if (!_closed) await transport.endInput();
  }

  void _trackTaskLifecycle(JsonMap message) {
    final subtype = message['subtype'];
    final taskId = message['task_id'];
    if (taskId is! String) return;
    if (subtype == 'task_started' &&
        _deferringTaskTypes.contains(message['task_type'])) {
      _inflightTasks.add(taskId);
      return;
    }
    if (subtype == 'task_notification') {
      _inflightTasks.remove(taskId);
      return;
    }
    if (subtype == 'task_updated') {
      final patch = message['patch'];
      if (patch is Map<Object?, Object?> &&
          _terminalTaskStatuses.contains(patch['status'])) {
        _inflightTasks.remove(taskId);
      }
    }
  }

  void _handleReadError(Object error, StackTrace stackTrace) {
    final structured =
        error is CliProcessException && _lastErrorResultText?.isNotEmpty == true
        ? CliProcessException(
            _lastErrorResultText!,
            exitCode: error.exitCode,
            stderr: error.stderr,
          )
        : error;
    if (!_messages.isClosed) _messages.addError(structured, stackTrace);
    _completePending(structured, stackTrace);
    if (!_runEnded.isCompleted) _runEnded.complete();
  }

  void _handleReadDone() {
    unawaited(_finishRead());
  }

  Future<void> _finishRead() async {
    await _routingTail.catchError((Object _) {});
    await _mirrorBatcher?.flush();
    if (!_runEnded.isCompleted) _runEnded.complete();
    if (!_messages.isClosed) unawaited(_messages.close());
    _completePending(
      const CliConnectionException('CLI output closed during control request'),
      StackTrace.current,
    );
  }

  void _completePending(Object error, StackTrace stackTrace) {
    for (final pending in _pending.values) {
      if (!pending.isCompleted) pending.completeError(error, stackTrace);
    }
    _pending.clear();
  }

  /// Closes routing and the underlying transport.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    if (!_runEnded.isCompleted) _runEnded.complete();
    await _readSubscription?.cancel();
    _readSubscription = null;
    await _routingTail.catchError((Object _) {});
    await _mirrorBatcher?.close();
    _mirrorBatcher = null;
    _completePending(
      const CliConnectionException('Control channel closed'),
      StackTrace.current,
    );
    if (!_messages.isClosed) unawaited(_messages.close());
    await transport.close();
  }
}
