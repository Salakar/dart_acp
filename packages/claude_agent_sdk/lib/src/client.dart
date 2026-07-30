import 'dart:async';

import 'context_usage.dart';
import 'control/control_channel.dart';
import 'errors.dart';
import 'input.dart';
import 'json.dart';
import 'mcp.dart';
import 'messages/message.dart';
import 'messages/message_codec.dart';
import 'options.dart';
import 'permissions.dart';
import 'sessions/session_resume.dart';
import 'transport/subprocess_cli_transport.dart';
import 'transport/transport.dart';

/// A stateful, bidirectional Claude Code session.
final class ClaudeAgentClient {
  /// Creates a client with optional custom [transport].
  ClaudeAgentClient({ClaudeAgentOptions? options, Transport? transport})
    : options = options ?? ClaudeAgentOptions(),
      _customTransport = transport;

  /// Session configuration.
  final ClaudeAgentOptions options;

  final Transport? _customTransport;
  ControlChannel? _channel;
  StreamIterator<JsonMap>? _iterator;
  MaterializedSession? _materialized;
  final MessageCodec _codec = const MessageCodec();

  /// Whether [connect] completed and the client has not been disconnected.
  bool get isConnected => _channel != null;

  /// Connects and optionally sends an initial prompt or prompt stream.
  Future<void> connect({
    String? prompt,
    Stream<UserInput>? promptStream,
  }) async {
    if (_channel != null) return;
    if (prompt != null && promptStream != null) {
      throw ArgumentError('prompt and promptStream are mutually exclusive');
    }
    if (prompt != null && options.canUseTool != null) {
      throw ArgumentError(
        'canUseTool requires streaming input or an interactive connection',
      );
    }
    validateSessionStoreOptions(options);
    _materialized = _customTransport == null
        ? await materializeResumeSession(options)
        : null;
    final effectiveOptions = _materialized == null
        ? options
        : options.withMaterializedResume(
            configDirectory: _materialized!.configDirectory,
            resumeSessionId: _materialized!.sessionId,
          );
    final transport =
        _customTransport ?? SubprocessCliTransport(effectiveOptions);
    final channel = ControlChannel(
      transport: transport,
      options: effectiveOptions,
    );
    _channel = channel;
    try {
      await transport.connect();
      await channel.start();
      _iterator = StreamIterator<JsonMap>(channel.messages);
      await channel.initialize();
      if (prompt != null) {
        await channel.sendInput(UserInput.text(prompt).toJson());
      } else if (promptStream != null) {
        unawaited(
          channel
              .streamInput(promptStream.map((value) => value.toJson()))
              .catchError((Object _) {}),
        );
      }
    } catch (_) {
      await disconnect();
      rethrow;
    }
  }

  ControlChannel get _connectedChannel {
    final channel = _channel;
    if (channel == null) {
      throw const CliConnectionException(
        'Client is not connected; call connect() first',
      );
    }
    return channel;
  }

  /// Sends a text prompt in the active session.
  Future<void> send(String prompt, {String sessionId = 'default'}) =>
      _connectedChannel.sendInput(
        UserInput.text(prompt, sessionId: sessionId).toJson(),
      );

  /// Sends a prompt; an alias for [send] matching agent-query terminology.
  Future<void> query(String prompt, {String sessionId = 'default'}) =>
      send(prompt, sessionId: sessionId);

  /// Sends a finite stream of user inputs without closing the connection.
  Future<void> sendStream(
    Stream<UserInput> input, {
    String defaultSessionId = 'default',
  }) async {
    await for (final message in input) {
      final adjusted = message.sessionId.isEmpty
          ? UserInput(
              content: message.content,
              sessionId: defaultSessionId,
              parentToolUseId: message.parentToolUseId,
            )
          : message;
      await _connectedChannel.sendInput(adjusted.toJson());
    }
  }

  /// Receives messages until the CLI output closes.
  Stream<AgentMessage> receiveMessages() async* {
    _connectedChannel;
    final iterator = _iterator;
    if (iterator == null) {
      throw const CliConnectionException(
        'Client message stream is unavailable',
      );
    }
    while (await iterator.moveNext()) {
      final message = _codec.decode(iterator.current);
      if (message != null) yield message;
    }
  }

  /// Stream view over [receiveMessages].
  Stream<AgentMessage> get messages => receiveMessages();

  /// Receives one turn, including its terminal [ResultMessage].
  Stream<AgentMessage> receiveResponse() async* {
    await for (final message in receiveMessages()) {
      yield message;
      if (message is ResultMessage) return;
    }
  }

  /// Requests interruption of the active turn.
  Future<void> interrupt() => _connectedChannel.interrupt();

  /// Changes the active permission [mode].
  Future<void> setPermissionMode(PermissionMode mode) =>
      _connectedChannel.setPermissionMode(mode);

  /// Changes the active model, or restores the default when [model] is null.
  Future<void> setModel([String? model]) => _connectedChannel.setModel(model);

  /// Rewinds checkpointed files to [userMessageId].
  Future<void> rewindFiles(String userMessageId) =>
      _connectedChannel.rewindFiles(userMessageId);

  /// Reconnects a failed MCP server.
  Future<void> reconnectMcpServer(String serverName) =>
      _connectedChannel.reconnectMcpServer(serverName);

  /// Enables or disables an MCP server.
  Future<void> toggleMcpServer(String serverName, {required bool enabled}) =>
      _connectedChannel.toggleMcpServer(serverName, enabled: enabled);

  /// Stops a delegated task.
  Future<void> stopTask(String taskId) => _connectedChannel.stopTask(taskId);

  /// Gets current MCP connection state.
  Future<McpStatus> getMcpStatus() => _connectedChannel.getMcpStatus();

  /// Gets current context-window usage.
  Future<ContextUsage> getContextUsage() => _connectedChannel.getContextUsage();

  /// Returns information from the initialize handshake.
  JsonMap? get serverInfo => _connectedChannel.initializationResult;

  /// Disconnects and releases subprocess resources.
  Future<void> disconnect() async {
    final iterator = _iterator;
    _iterator = null;
    await iterator?.cancel();
    final channel = _channel;
    _channel = null;
    await channel?.close();
    final materialized = _materialized;
    _materialized = null;
    await materialized?.cleanup();
  }

  /// Closes the client; an idempotent alias for [disconnect].
  Future<void> close() => disconnect();
}
