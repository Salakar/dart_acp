import 'package:dart_acp_sdk/experimental/protocol_router.dart';
import 'package:dart_acp_sdk/experimental/v2.dart' as v2;
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  group('protocol router v1-to-v2 negotiation fidelity', () {
    test('maps shared info, capabilities, and metadata', () async {
      v2.AcpV2AgentConnection? selected;
      final agent = v2.AcpV2AgentApp(
        implementation: v2.Implementation(name: 'v2-agent', version: '1'),
        capabilities: v2.AgentCapabilities(),
      ).onConnect((connection) => selected = connection);
      final harness = RouterHarness(AcpProtocolRouter(v2: agent));
      final output = harness.nextOutput();
      final request = initializeRequest(
        1,
        capabilities: <String, Object?>{
          'fs': <String, Object?>{'readTextFile': true, 'writeTextFile': true},
          'terminal': true,
          'session': <String, Object?>{},
          'plan': <String, Object?>{},
          'auth': <String, Object?>{
            'terminal': true,
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

      final result = asObject(asObject(await output)['result']);
      expect(() => v2.initializeResponseCodec.decode(result), returnsNormally);
      await Future<void>.delayed(Duration.zero);

      expect(result['protocolVersion'], 2);
      expect(
        selected?.lifecycle.peerImplementation?['name']?.toObject(),
        'client',
      );
      final advertised = asObject(
        selected!.lifecycle.peerCapabilities.value.toObject(),
      );
      final capabilities = asObject(advertised['clientCapabilities']);
      expect(capabilities, isNot(contains('fs')));
      expect(capabilities, isNot(contains('terminal')));
      expect(capabilities, isNot(contains('session')));
      expect(capabilities, isNot(contains('plan')));
      expect(capabilities, isNot(contains('auth')));
      expect(capabilities, isNot(contains('nes')));
      expect(capabilities, isNot(contains('positionEncodings')));
      expect(asObject(capabilities['elicitation']), isEmpty);
      expect(asObject(capabilities['_meta'])['capability'], isTrue);
      await harness.close();
    });

    test('supplies v2 implementation info omitted by a v1 client', () async {
      v2.AcpV2AgentConnection? selected;
      final agent = v2Agent().onConnect((connection) => selected = connection);
      final harness = RouterHarness(AcpProtocolRouter(v2: agent));
      final output = harness.nextOutput();
      final request = initializeRequest(1);
      asObject(asObject(request)['params']).remove('clientInfo');
      harness.add(request);

      final result = asObject(asObject(await output)['result']);
      expect(result['protocolVersion'], 2);
      await Future<void>.delayed(Duration.zero);
      expect(
        selected?.lifecycle.peerImplementation?['name']?.toObject(),
        'unknown-acp-client',
      );
      expect(
        selected?.lifecycle.peerImplementation?['version']?.toObject(),
        'unknown',
      );
      await harness.close();
    });
  });
}
