import 'web_socket_adapter.dart';
import 'web_socket_adapter_stub.dart'
    if (dart.library.io) 'web_socket_adapter_io.dart'
    if (dart.library.js_interop) 'web_socket_adapter_web.dart'
    as platform;

/// Creates the WebSocket adapter for the current platform.
AcpWebSocketAdapter createPlatformWebSocketAdapter() =>
    platform.createPlatformWebSocketAdapter();
