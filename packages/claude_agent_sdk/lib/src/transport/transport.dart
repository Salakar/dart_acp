import '../json.dart';

/// Low-level bidirectional transport for the CLI control protocol.
///
/// Most callers should use `query()` or `ClaudeAgentClient`. Implement this
/// interface only for remote CLI bridges or deterministic tests.
abstract interface class Transport {
  /// Establishes the transport.
  Future<void> connect();

  /// Writes raw protocol text, normally one JSON line.
  Future<void> write(String data);

  /// Decoded JSON messages received from the transport.
  Stream<JsonMap> get messages;

  /// Closes the input side while leaving output readable.
  Future<void> endInput();

  /// Closes the transport and releases all resources.
  Future<void> close();

  /// Whether [write] can currently accept data.
  bool get isReady;
}
