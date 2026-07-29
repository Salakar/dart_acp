// coverage-exempt: conditional-fallback
import 'http_server.dart';
import 'http_server_adapter.dart';
import 'web_socket_server.dart';

/// Creates a web-safe unsupported native-listener adapter.
AcpHttpServerAdapter createPlatformAcpHttpServerAdapter() =>
    const _UnsupportedHttpServerAdapter();

final class _UnsupportedHttpServerAdapter implements AcpHttpServerAdapter {
  const _UnsupportedHttpServerAdapter();

  @override
  bool get isSupported => false;

  @override
  Future<AcpHttpServerBinding> serve(
    AcpHttpServer server, {
    String host = '127.0.0.1',
    int port = 0,
    String path = '/acp',
    bool shared = false,
    AcpWebSocketServer? webSocketServer,
  }) => Future<AcpHttpServerBinding>.error(
    UnsupportedError(
      'Native ACP HTTP servers are unavailable on this platform',
    ),
  );
}
