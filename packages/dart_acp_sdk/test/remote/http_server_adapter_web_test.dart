@TestOn('browser')
library;

import 'package:dart_acp_sdk/src/remote/http_server_adapter_factory.dart';
import 'package:test/test.dart';

void main() {
  test('browser build exposes an explicit unsupported native adapter', () {
    final adapter = createPlatformAcpHttpServerAdapter();

    expect(adapter.isSupported, isFalse);
  });
}
