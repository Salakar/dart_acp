import 'http_server_adapter.dart';
import 'http_server_adapter_stub.dart'
    if (dart.library.io) 'http_server_adapter_io.dart'
    as platform;

/// Creates the native ACP server adapter for this platform.
///
/// Browser builds receive an explicit unsupported adapter without importing
/// `dart:io`.
AcpHttpServerAdapter createPlatformAcpHttpServerAdapter() =>
    platform.createPlatformAcpHttpServerAdapter();
