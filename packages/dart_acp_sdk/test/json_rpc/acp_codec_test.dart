import 'package:dart_acp_sdk/src/json_rpc/codec.dart';
import 'package:test/test.dart';

void main() {
  group('AcpJsonRpcCodec', () {
    final AcpJsonRpcCodec codec = AcpJsonRpcCodec(
      protocolMethods: <String>{'session/new'},
    );

    test('accepts registered methods, controls, and underscore extensions', () {
      for (final String method in <String>[
        'session/new',
        r'$/cancel_request',
        '_vendor/custom',
      ]) {
        expect(
          codec.isNotification(<String, Object?>{
            'jsonrpc': '2.0',
            'method': method,
          }),
          isTrue,
        );
      }
    });

    test('rejects unregistered reserved and empty extension methods', () {
      for (final String method in <String>['session/unknown', '_']) {
        final Map<String, Object?> notification = <String, Object?>{
          'jsonrpc': '2.0',
          'method': method,
        };
        expect(codec.isNotification(notification), isFalse);
        expect(() => codec.decodeMessage(notification), throwsFormatException);
        expect(() => codec.validateMethod(method), throwsArgumentError);
      }
    });
  });
}
