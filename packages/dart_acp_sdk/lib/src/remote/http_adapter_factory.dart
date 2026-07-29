import 'http_adapter.dart';
import 'http_adapter_stub.dart'
    if (dart.library.io) 'http_adapter_io.dart'
    if (dart.library.js_interop) 'http_adapter_web.dart'
    as platform;

/// Creates the HTTP adapter for the current platform.
AcpHttpAdapter createPlatformHttpAdapter() =>
    platform.createPlatformHttpAdapter();
