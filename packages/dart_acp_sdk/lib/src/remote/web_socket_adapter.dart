import 'dart:convert';

import 'http_adapter.dart';

/// One inbound WebSocket frame.
sealed class AcpWebSocketFrame {
  const AcpWebSocketFrame();

  /// Payload byte length used by transport limits.
  int get length;
}

/// One UTF-8 text frame.
final class AcpWebSocketTextFrame extends AcpWebSocketFrame {
  /// Creates a text frame.
  const AcpWebSocketTextFrame(this.text);

  /// Frame text.
  final String text;

  @override
  int get length => utf8.encode(text).length;
}

/// One unsupported binary frame.
final class AcpWebSocketBinaryFrame extends AcpWebSocketFrame {
  /// Creates a binary frame.
  AcpWebSocketBinaryFrame(List<int> bytes)
    : bytes = List<int>.unmodifiable(bytes);

  /// Binary payload.
  final List<int> bytes;

  @override
  int get length => bytes.length;
}

/// Immutable request to open a WebSocket.
final class AcpWebSocketConnectRequest {
  /// Creates a connection request.
  const AcpWebSocketConnectRequest({
    required this.uri,
    this.protocols = const <String>[],
    this.headers = const AcpHttpHeaders(),
  });

  /// WebSocket URI.
  final Uri uri;

  /// Requested subprotocols.
  final List<String> protocols;

  /// Native handshake headers. Browsers reject nonempty custom headers.
  final AcpHttpHeaders headers;
}

/// One connected WebSocket channel.
abstract interface class AcpWebSocketChannel {
  /// Upgrade response headers when exposed by the platform.
  AcpHttpHeaders get responseHeaders;

  /// Incoming text and binary frames.
  Stream<AcpWebSocketFrame> get frames;

  /// Completes after the peer closes or the socket fails.
  Future<void> get closed;

  /// Sends one text frame.
  Future<void> sendText(String text);

  /// Closes the socket.
  Future<void> close({int? code, String? reason});
}

/// Platform boundary used by the experimental WebSocket client.
abstract interface class AcpWebSocketAdapter {
  /// Opens a WebSocket.
  Future<AcpWebSocketChannel> connect(AcpWebSocketConnectRequest request);

  /// Releases adapter-owned resources.
  Future<void> close();
}
