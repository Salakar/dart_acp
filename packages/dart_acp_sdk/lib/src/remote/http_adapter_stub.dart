// coverage-exempt: conditional-fallback
import 'http_adapter.dart';

/// Creates a typed adapter that reports this platform as unsupported.
AcpHttpAdapter createPlatformHttpAdapter() => _UnsupportedHttpAdapter();

final class _UnsupportedHttpAdapter implements AcpHttpAdapter {
  @override
  Future<AcpHttpResponse> send(AcpHttpRequest request) {
    throw UnsupportedError(
      'The experimental ACP HTTP transport is unsupported on this platform.',
    );
  }

  @override
  Future<void> close() async {}
}
