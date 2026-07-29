import 'package:dart_acp_sdk/dart_acp_sdk.dart' as v1;
import 'package:dart_acp_sdk/experimental/protocol_router.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  group('protocol router v2-to-v1 downgrade fidelity', () {
    test(
      'maps info, capabilities, metadata, and canonical empty values',
      () async {
        Map<String, Object?>? captured;
        final agent = v1Agent(
          observe: (v1.AcpIncomingMessage message) {
            if (message.method == 'initialize') {
              captured = asObject(message.params.value);
            }
          },
        );
        final harness = RouterHarness(AcpProtocolRouter(v1: agent));
        final output = harness.nextOutput();
        final request = initializeRequest(
          2,
          capabilities: <String, Object?>{
            'auth': <String, Object?>{
              'terminal': <String, Object?>{},
              '_meta': <String, Object?>{'auth': true},
            },
            'elicitation': <String, Object?>{},
            'nes': <String, Object?>{},
            'positionEncodings': <Object?>['utf-8'],
            '_meta': <String, Object?>{'capability': true},
          },
        );
        asObject(asObject(request)['params'])['_meta'] = <String, Object?>{
          'request': true,
        };
        harness.add(request);
        await output;

        expect(captured?['protocolVersion'], 1);
        expect(asObject(captured?['clientInfo'])['name'], 'client');
        expect(asObject(captured?['_meta'])['request'], isTrue);
        final capabilities = asObject(captured?['clientCapabilities']);
        expect(asObject(capabilities['fs']), <String, Object?>{
          'readTextFile': false,
          'writeTextFile': false,
        });
        expect(capabilities['terminal'], isFalse);
        expect(asObject(capabilities['plan']), isEmpty);
        expect(asObject(capabilities['auth'])['terminal'], isTrue);
        expect(capabilities['positionEncodings'], <Object?>['utf-8']);
        await harness.close();
      },
    );

    test('rejects terminal-auth metadata that v1 cannot represent', () async {
      final harness = RouterHarness(AcpProtocolRouter(v1: v1Agent()));
      final output = harness.nextOutput();
      harness.add(
        initializeRequest(
          2,
          capabilities: <String, Object?>{
            'auth': <String, Object?>{
              'terminal': <String, Object?>{
                '_meta': <String, Object?>{'unsafe': true},
              },
            },
          },
        ),
      );

      expect(errorOf(await output)['code'], -32602);
      await harness.connection.closed;
    });

    test(
      'normalizes a future version to v1 when v1 is the only agent',
      () async {
        Map<String, Object?>? captured;
        final harness = RouterHarness(
          AcpProtocolRouter(
            v1: v1Agent(
              observe: (v1.AcpIncomingMessage message) {
                if (message.method == 'initialize') {
                  captured = asObject(message.params.value);
                }
              },
            ),
          ),
        );
        final output = harness.nextOutput();
        harness.add(initializeRequest(3));
        await output;

        expect(captured?['protocolVersion'], 1);
        expect(harness.connection.selectedProtocolVersion, 1);
        await harness.close();
      },
    );
  });
}
