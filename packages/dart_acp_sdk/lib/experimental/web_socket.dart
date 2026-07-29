// coverage-exempt: directives-only
/// Experimental ACP WebSocket client APIs.
///
/// These APIs may change before a stable release. Browser WebSocket uses the
/// browser cookie jar and cannot attach caller-provided handshake headers.
///
/// {@canonicalFor web_socket_adapter.AcpWebSocketBinaryFrame}
/// {@canonicalFor web_socket_adapter.AcpWebSocketChannel}
/// {@canonicalFor web_socket_adapter.AcpWebSocketFrame}
/// {@canonicalFor web_socket_adapter.AcpWebSocketTextFrame}
library;

export '../src/remote/affinity_cookie_store.dart';
export '../src/remote/application_stream.dart';
export '../src/remote/http_adapter.dart'
    show AcpHttpCookiePolicy, AcpHttpHeaders;
export '../src/remote/sse.dart'
    show AcpRemoteDiagnostic, AcpRemoteDiagnosticHandler;
export '../src/remote/web_socket_adapter.dart';
export '../src/remote/web_socket_adapter_factory.dart';
export '../src/remote/web_socket_client.dart';
