// coverage-exempt: abstract-declarations-only
import 'http_server.dart';
import 'web_socket_server.dart';

/// A running platform HTTP listener serving experimental ACP transports.
abstract interface class AcpHttpServerBinding {
  /// Loopback or explicitly configured endpoint.
  Uri get endpoint;

  /// Whether [close] has completed.
  bool get isClosed;

  /// Stops accepting traffic and releases transport-owned resources.
  Future<void> close();
}

/// Platform boundary for hosting [AcpHttpServer].
abstract interface class AcpHttpServerAdapter {
  /// Whether this platform can bind a native HTTP listener.
  bool get isSupported;

  /// Binds [server] at [host], [port], and [path].
  ///
  /// The loopback default is intentional. Authentication, TLS, CORS, rate
  /// limiting, quotas, and authorization remain host-application concerns.
  Future<AcpHttpServerBinding> serve(
    AcpHttpServer server, {
    String host = '127.0.0.1',
    int port = 0,
    String path = '/acp',
    bool shared = false,
    AcpWebSocketServer? webSocketServer,
  });
}
