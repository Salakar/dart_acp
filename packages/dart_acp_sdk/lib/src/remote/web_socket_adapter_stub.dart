// coverage-exempt: conditional-fallback
import 'web_socket_adapter.dart';

/// Creates a typed adapter that reports this platform as unsupported.
AcpWebSocketAdapter createPlatformWebSocketAdapter() =>
    _UnsupportedWebSocketAdapter();

final class _UnsupportedWebSocketAdapter implements AcpWebSocketAdapter {
  @override
  Future<AcpWebSocketChannel> connect(AcpWebSocketConnectRequest request) {
    throw UnsupportedError(
      'The experimental ACP WebSocket transport is unsupported on this '
      'platform.',
    );
  }

  @override
  Future<void> close() async {}
}
