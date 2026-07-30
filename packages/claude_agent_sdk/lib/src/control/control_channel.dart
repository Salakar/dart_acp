import 'dart:async';

import '../context_usage.dart';
import '../elicitation.dart';
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
import 'control_models.dart';

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
    if (options.mcp case McpServers(:final servers)) {
      _sdkMcpServers.addEntries(
        servers.entries
            .where((entry) => entry.value is SdkMcpServer)
            .map((entry) => MapEntry(entry.key, entry.value as SdkMcpServer)),
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
  final Map<String, SdkMcpServer> _sdkMcpServers = {};
  final Set<String> _cancelledIncoming = {};
  final Map<String, ControlCallbackCancellation> _incomingCancellations = {};
  final Set<String> _inflightTasks = {};
  final Completer<void> _runEnded = Completer<void>();
  StreamSubscription<JsonMap>? _readSubscription;
  Future<void> _routingTail = Future<void>.value();
  SessionMirrorBatcher? _mirrorBatcher;
  JsonMap? _initializationResult;
  JsonMap? _initializeRequest;
  List<JsonMap>? _latestCommands;
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
  Future<JsonMap> initialize({Duration? timeout}) async {
    if (_initialized) return _initializationResult ?? const {};
    final request = _initializeRequest ??= _buildInitializeRequest();
    final result = await _sendInitializeRequest(request, timeout: timeout);
    _initialized = true;
    _initializationResult = result;
    return result;
  }

  /// Repeats the initialize handshake against the running CLI.
  Future<JsonMap> reinitialize() async {
    final request = _initializeRequest ??= _buildInitializeRequest();
    final result = await _sendInitializeRequest(request);
    _initialized = true;
    _initializationResult = result;
    return result;
  }

  JsonMap _buildInitializeRequest() {
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
      if (_sdkMcpServers.isNotEmpty)
        'sdkMcpServers': _sdkMcpServers.keys.toList(growable: false),
      if (options.systemPrompt case BlockSystemPrompt(:final blocks))
        'systemPrompt': blocks,
      if (options.planModeInstructions != null)
        'planModeInstructions': options.planModeInstructions,
      if (options.toolAliases.isNotEmpty) 'toolAliases': options.toolAliases,
      if (options.agents.isNotEmpty)
        'agents': options.agents.map(
          (name, agent) => MapEntry(name, agent.toJson()),
        ),
      if (options.title != null) 'title': options.title,
      if (options.systemPrompt case ClaudeCodeSystemPrompt(
        :final excludeDynamicSections?,
      ))
        'excludeDynamicSections': excludeDynamicSections,
      if (options.skills case NamedSkills(:final names)) 'skills': names,
      if (options.promptSuggestions)
        'promptSuggestions': options.promptSuggestions,
      if (options.agentProgressSummaries)
        'agentProgressSummaries': options.agentProgressSummaries,
      if (options.forwardSubagentText)
        'forwardSubagentText': options.forwardSubagentText,
      if (options.supportedDialogKinds.isNotEmpty)
        'supportedDialogKinds': options.supportedDialogKinds,
    };
    return immutableJsonMap(request);
  }

  Future<JsonMap> _sendInitializeRequest(
    JsonMap request, {
    Duration? timeout,
  }) => sendControlRequest(
    request,
    timeout:
        timeout ??
        (options.initializeTimeout < const Duration(seconds: 60)
            ? const Duration(seconds: 60)
            : options.initializeTimeout),
  );

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
          _redeliverPendingControlRequests(response);
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
        if (id is String) {
          _cancelledIncoming.add(id);
          _incomingCancellations[id]?.cancel();
        }
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
        if (message['subtype'] == 'commands_changed') {
          _latestCommands = _objectList(
            message['commands'],
            'commands_changed.commands',
          );
        }
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

  void _redeliverPendingControlRequests(JsonMap response) {
    for (final key in const [
      'pending_permission_requests',
      'pending_user_dialog_requests',
    ]) {
      final pending = response[key];
      if (pending is! List<Object?>) continue;
      for (final value in pending) {
        final request = asJsonMap(value, '$key item');
        unawaited(_handleIncomingRequest(request));
      }
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
    final cancellation = ControlCallbackCancellation(requestId: requestId);
    _incomingCancellations[requestId] = cancellation;
    try {
      final request = asJsonMap(envelope['request'], 'control request payload');
      final subtype = requiredString(
        request,
        'subtype',
        'control request payload',
      );
      final response = switch (subtype) {
        'can_use_tool' => await _handlePermissionRequest(request, cancellation),
        'hook_callback' => await _handleHookRequest(request, cancellation),
        'mcp_message' => await _handleMcpRequest(request),
        'mcp_elicitation' ||
        'elicitation' => await _handleElicitationRequest(request, cancellation),
        'user_dialog' || 'request_user_dialog' =>
          await _handleUserDialogRequest(request, cancellation),
        _ => throw ControlProtocolException(
          'Unsupported incoming control request: $subtype',
        ),
      };
      if (_cancelledIncoming.remove(requestId) || _closed) return;
      if (response == null) return;
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
    } finally {
      _incomingCancellations.remove(requestId);
    }
  }

  Future<JsonMap> _handleElicitationRequest(
    JsonMap request,
    ControlCallbackCancellation cancellation,
  ) async {
    final callback = options.onElicitation;
    if (callback == null) {
      return const ClaudeElicitationResult.decline().toJson();
    }
    final result = await callback(
      ClaudeElicitationRequest.fromJson(request),
      ControlCallbackContext(cancellation: cancellation),
    );
    return result.toJson();
  }

  Future<JsonMap?> _handleUserDialogRequest(
    JsonMap request,
    ControlCallbackCancellation cancellation,
  ) async {
    final parsed = ClaudeUserDialogRequest.fromJson(request);
    final callback = options.onUserDialog;
    if (callback == null ||
        !options.supportedDialogKinds.contains(parsed.dialogKind)) {
      return null;
    }
    return (await callback(
      parsed,
      ControlCallbackContext(cancellation: cancellation),
    )).toJson();
  }

  Future<JsonMap?> _handlePermissionRequest(
    JsonMap request,
    ControlCallbackCancellation cancellation,
  ) async {
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
      requestId: cancellation.requestId,
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
      decisionReasonType: optionalString(
        request,
        'decision_reason_type',
        'permission request',
      ),
      classifierApprovable: optionalBool(
        request,
        'classifier_approvable',
        'permission request',
      ),
      suppressAlwaysAllowRule: optionalBool(
        request,
        'suppress_always_allow_rule',
        'permission request',
      ),
      requiresUserInteraction: optionalBool(
        request,
        'requires_user_interaction',
        'permission request',
      ),
      matchedAskRule: _matchedAskRule(request['matched_ask_rule']),
      title: optionalString(request, 'title', 'permission request'),
      displayName: optionalString(
        request,
        'display_name',
        'permission request',
      ),
      description: optionalString(request, 'description', 'permission request'),
      cancellation: cancellation,
    );
    final result = await callback(
      requiredString(request, 'tool_name', 'permission request'),
      originalInput,
      context,
    );
    if (result == null) return null;
    return switch (result) {
      PermissionAllowed(
        :final updatedInput,
        :final updatedPermissions,
        :final decisionClassification,
      ) =>
        {
          'behavior': 'allow',
          'updatedInput': updatedInput ?? originalInput,
          if (updatedPermissions != null)
            'updatedPermissions': updatedPermissions
                .map((update) => update.toJson())
                .toList(growable: false),
          if (decisionClassification != null)
            'decisionClassification': decisionClassification.wireValue,
        },
      PermissionDenied(
        :final message,
        :final shouldInterrupt,
        :final decisionClassification,
      ) =>
        {
          'behavior': 'deny',
          'message': message,
          if (shouldInterrupt) 'interrupt': true,
          if (decisionClassification != null)
            'decisionClassification': decisionClassification.wireValue,
        },
    };
  }

  Future<JsonMap> _handleHookRequest(
    JsonMap request,
    ControlCallbackCancellation cancellation,
  ) async {
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
      ControlCallbackContext(cancellation: cancellation),
    );
    return output.toJson();
  }

  Future<JsonMap> _handleMcpRequest(JsonMap request) async {
    final serverName = requiredString(request, 'server_name', 'MCP request');
    final server = _sdkMcpServers[serverName];
    final message = asJsonMap(request['message'], 'MCP request message');
    final response = server != null
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
  Future<ClaudeInterruptReceipt> interrupt({bool cancelQueued = false}) async =>
      ClaudeInterruptReceipt.fromJson(
        await sendControlRequest({
          'subtype': 'interrupt',
          if (cancelQueued) 'cancel_queued': true,
        }),
      );

  /// Returns currently supported slash commands.
  Future<List<JsonMap>> supportedCommands() async {
    final latest = _latestCommands;
    if (latest != null) return List<JsonMap>.unmodifiable(latest);
    return _objectList(
      _initializationResult?['commands'],
      'initialize.commands',
    );
  }

  /// Returns currently supported agents.
  Future<List<JsonMap>> supportedAgents() async {
    return _objectList(_initializationResult?['agents'], 'initialize.agents');
  }

  /// Applies session-scoped CLI [settings].
  Future<void> applyFlagSettings(ClaudeFlagSettings settings) async {
    await sendControlRequest({
      'subtype': 'apply_flag_settings',
      'settings': settings.toJson(),
    });
  }

  /// Changes the active permission [mode].
  Future<void> setPermissionMode(PermissionMode mode) async {
    await sendControlRequest({
      'subtype': 'set_permission_mode',
      'mode': mode.wireValue,
    });
  }

  /// Tightens or clears the permission policy for one MCP server.
  Future<McpPermissionModeOverrideResult> setMcpPermissionModeOverride(
    String serverName,
    McpPermissionModeOverride? mode,
  ) async => McpPermissionModeOverrideResult.fromJson(
    await sendControlRequest({
      'subtype': 'set_mcp_permission_mode_override',
      'serverName': serverName,
      'mode': mode?.wireValue,
    }),
  );

  /// Changes the active [model], or restores the default when `null`.
  Future<void> setModel(String? model) async {
    await sendControlRequest({'subtype': 'set_model', 'model': model});
  }

  /// Rewinds checkpointed files to [userMessageId].
  Future<RewindFilesResult> rewindFiles(
    String userMessageId, {
    bool dryRun = false,
  }) async => RewindFilesResult.fromJson(
    await sendControlRequest({
      'subtype': 'rewind_files',
      'user_message_id': userMessageId,
      if (dryRun) 'dry_run': true,
    }),
  );

  /// Seeds the runtime's file-read state for subsequent edit validation.
  Future<void> seedReadState(String path, int modifiedAtMilliseconds) async {
    await sendControlRequest({
      'subtype': 'seed_read_state',
      'path': path,
      'mtime': modifiedAtMilliseconds,
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

  /// Replaces the dynamically managed MCP servers.
  Future<McpSetServersResult> setMcpServers(
    Map<String, McpServerConfig> servers,
  ) async {
    if (servers.keys.any((name) => name.isEmpty)) {
      throw ArgumentError.value(servers, 'servers', 'names must not be empty');
    }
    _sdkMcpServers
      ..clear()
      ..addEntries(
        servers.entries
            .where((entry) => entry.value is SdkMcpServer)
            .map((entry) => MapEntry(entry.key, entry.value as SdkMcpServer)),
      );
    final serializable = servers.map(
      (name, config) => MapEntry(
        name,
        config is SdkMcpServer
            ? <String, Object?>{'type': 'sdk', 'name': name}
            : config.toJson(),
      ),
    );
    return McpSetServersResult.fromJson(
      await sendControlRequest({
        'subtype': 'mcp_set_servers',
        'servers': serializable,
      }),
    );
  }

  /// Stops a delegated task.
  Future<void> stopTask(String taskId) async {
    await sendControlRequest({'subtype': 'stop_task', 'task_id': taskId});
  }

  /// Backgrounds one or all foreground tasks.
  Future<bool> backgroundTasks([String? toolUseId]) async {
    final response = await sendControlRequest({
      'subtype': 'background_tasks',
      'tool_use_id': ?toolUseId,
    });
    return optionalBool(response, 'backgrounded', 'background tasks') ?? true;
  }

  /// Gets current MCP connection state.
  Future<McpStatus> getMcpStatus() async =>
      McpStatus.fromJson(await sendControlRequest({'subtype': 'mcp_status'}));

  /// Gets current context-window usage.
  Future<ContextUsage> getContextUsage() async => ContextUsage.fromJson(
    await sendControlRequest({'subtype': 'get_context_usage'}),
  );

  /// Gets the experimental structured usage snapshot.
  Future<ClaudeUsageSnapshot> getUsage() async => ClaudeUsageSnapshot.fromJson(
    await sendControlRequest({'subtype': 'get_usage'}),
  );

  /// Reads one file through the runtime's permission-gated filesystem.
  Future<ClaudeReadFileResult?> readFile(
    String path, {
    int? maxBytes,
    ClaudeReadFileEncoding encoding = ClaudeReadFileEncoding.utf8,
  }) async {
    if (maxBytes != null && maxBytes <= 0) {
      throw ArgumentError.value(maxBytes, 'maxBytes', 'must be positive');
    }
    try {
      return ClaudeReadFileResult.fromJson(
        await sendControlRequest({
          'subtype': 'read_file',
          'path': path,
          'max_bytes': ?maxBytes,
          if (encoding == ClaudeReadFileEncoding.base64)
            'encoding': encoding.wireValue,
        }),
      );
    } on ControlProtocolException {
      return null;
    }
  }

  /// Reloads plugins and returns refreshed session components.
  Future<ReloadPluginsResult> reloadPlugins() async =>
      ReloadPluginsResult.fromJson(
        await sendControlRequest({'subtype': 'reload_plugins'}),
      );

  /// Reloads skills and returns the refreshed list.
  Future<ReloadSkillsResult> reloadSkills() async =>
      ReloadSkillsResult.fromJson(
        await sendControlRequest({'subtype': 'reload_skills'}),
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
    for (final cancellation in _incomingCancellations.values) {
      cancellation.cancel();
    }
    _incomingCancellations.clear();
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

  List<JsonMap> _objectList(Object? raw, String context) {
    if (raw == null) return const <JsonMap>[];
    if (raw is! List<Object?>) {
      throw ControlProtocolException('$context must be an array');
    }
    return List<JsonMap>.unmodifiable(
      raw.map((value) => asJsonMap(value, '$context item')),
    );
  }

  MatchedAskRule? _matchedAskRule(Object? value) {
    if (value == null) return null;
    final rule = asJsonMap(value, 'permission matched ask rule');
    return MatchedAskRule(
      source: requiredString(rule, 'source', 'permission matched ask rule'),
      toolName: requiredString(
        rule,
        'tool_name',
        'permission matched ask rule',
      ),
      ruleContent: optionalString(
        rule,
        'rule_content',
        'permission matched ask rule',
      ),
    );
  }
}
