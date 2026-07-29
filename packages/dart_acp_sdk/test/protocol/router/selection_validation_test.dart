import 'package:dart_acp_sdk/experimental/protocol_router.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  group('protocol router selection and first-frame validation', () {
    test('routes protocol 1 to a configured v1 agent', () async {
      final harness = RouterHarness(
        AcpProtocolRouter(v1: v1Agent(), v2: v2Agent()),
      );
      final response = harness.nextOutput();
      harness.add(initializeRequest(1));

      expect(asObject(await response)['result'], isA<Map<String, Object?>>());
      expect(harness.connection.selectedProtocolVersion, 1);
      await harness.close();
    });

    test('routes protocol 2 to a configured v2 agent', () async {
      final harness = RouterHarness(
        AcpProtocolRouter(v1: v1Agent(), v2: v2Agent()),
      );
      final response = harness.nextOutput();
      harness.add(initializeRequest(2));

      expect(asObject(await response)['result'], isA<Map<String, Object?>>());
      expect(harness.connection.selectedProtocolVersion, 2);
      await harness.close();
    });

    test('routes future protocol 3 to v2 and normalizes initialize', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      final response = harness.nextOutput();
      harness.add(initializeRequest(3));

      final result = asObject(asObject(await response)['result']);
      expect(result['protocolVersion'], 2);
      expect(harness.connection.selectedProtocolVersion, 2);
      await harness.close();
    });

    for (final Object? version in <Object?>[null, 0.5, -1, 65536, '2']) {
      test(
        'rejects malformed protocol version $version as invalid params',
        () async {
          final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
          final response = harness.nextOutput();
          harness.add(initializeRequest(version));

          expect(errorOf(await response)['code'], -32602);
          await harness.connection.closed;
        },
      );
    }

    test(
      'falls back to the latest configured version for protocol zero',
      () async {
        final harness = RouterHarness(AcpProtocolRouter(v1: v1Agent()));
        final response = harness.nextOutput();
        harness.add(initializeRequest(0));

        final result = asObject(asObject(await response)['result']);
        expect(result['protocolVersion'], 1);
        expect(harness.connection.selectedProtocolVersion, 1);
        await harness.close();
      },
    );

    test('answers a v1-shaped initialize with latest configured v2', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      final response = harness.nextOutput();
      harness.add(initializeRequest(1));

      final result = asObject(asObject(await response)['result']);
      expect(result['protocolVersion'], 2);
      expect(asObject(result['info'])['name'], 'v2-agent');
      expect(harness.connection.selectedProtocolVersion, 2);
      await harness.close();
    });

    test(
      'uses latest v2 when neither configured version was requested',
      () async {
        final harness = RouterHarness(
          AcpProtocolRouter(v1: v1Agent(), v2: v2Agent()),
        );
        final response = harness.nextOutput();
        harness.add(initializeRequest(0));

        final result = asObject(asObject(await response)['result']);
        expect(result['protocolVersion'], 2);
        expect(harness.connection.selectedProtocolVersion, 2);
        await harness.close();
      },
    );

    test('rejects a valid version only when no agent is configured', () async {
      final harness = RouterHarness(AcpProtocolRouter());
      final response = harness.nextOutput();
      harness.add(initializeRequest(1));

      expect(errorOf(await response)['code'], -32600);
      await harness.connection.closed;
    });

    test('rejects a non-initialize first request with its id', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      final response = harness.nextOutput();
      harness.add(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 'request-id',
        'method': '_ping',
      });

      final object = asObject(await response);
      expect(object['id'], 'request-id');
      expect(errorOf(object)['code'], -32600);
      await harness.connection.closed;
    });

    test('rejects a multi-entry first batch with null id', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      final response = harness.nextOutput();
      harness.add(<Object?>[
        initializeRequest(2, id: 1),
        initializeRequest(2, id: 2),
      ]);

      final object = asObject(await response);
      expect(object['id'], isNull);
      expect(errorOf(object)['code'], -32600);
      await harness.connection.closed;
    });
  });
}
