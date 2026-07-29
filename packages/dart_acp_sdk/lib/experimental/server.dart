// coverage-exempt: directives-only
/// Experimental ACP HTTP/SSE and WebSocket server APIs.
///
/// Native listeners default to loopback and are unavailable in browser
/// builds. These APIs provide routing, not authentication or authorization.
/// Hosts remain responsible for TLS, origin/CORS policy, credentials, rate
/// limits, quotas, privileged handler policy, and audit logging.
library;

export '../src/remote/http_adapter.dart'
    show AcpHttpHeaders, AcpHttpRequest, AcpHttpResponse;
export '../src/remote/http_server.dart';
export '../src/remote/http_server_adapter.dart';
export '../src/remote/http_server_adapter_factory.dart';
export '../src/remote/outbound_hub.dart';
export '../src/remote/server_connection.dart';
export '../src/remote/server_limits.dart';
export '../src/remote/server_registry.dart';
export '../src/remote/server_sse.dart';
export '../src/remote/web_socket_adapter.dart'
    show
        AcpWebSocketBinaryFrame,
        AcpWebSocketChannel,
        AcpWebSocketFrame,
        AcpWebSocketTextFrame;
export '../src/remote/web_socket_server.dart';
