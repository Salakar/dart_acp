@TestOn('browser')
library;

import 'package:dart_acp_sdk/src/transport/stdio.dart';
import 'package:test/test.dart';

void main() {
  test('stdio entrypoint stays importable with an unsupported web stub', () {
    expect(AcpStdioTransport.isSupported, isFalse);
    expect(AcpStdioTransport.connect, throwsUnsupportedError);
  });
}
