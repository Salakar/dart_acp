import 'package:dart_acp_sdk/dart_acp_sdk.dart' as v1;
import 'package:dart_acp_sdk/experimental/protocol_router.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  group('protocol router lifecycle and forwarding', () {
    test(
      'deferred-start race runs selected connect handlers exactly once',
      () async {
        var connects = 0;
        final harness = RouterHarness(
          AcpProtocolRouter(v1: v1Agent(onConnect: () => connects++)),
          options: const AcpProtocolRouterConnectOptions(
            deferConnectHandlers: true,
          ),
        );
        harness.connection.startConnectHandlers();
        harness.connection.startConnectHandlers();
        final output = harness.nextOutput();
        harness.add(initializeRequest(1));
        await output;
        await Future<void>.delayed(Duration.zero);

        expect(connects, 1);
        harness.connection.startConnectHandlers();
        expect(connects, 1);
        await harness.close();
      },
    );

    test(
      'forwards subsequent params by identity without translation',
      () async {
        Object? observedParams;
        final agent = v1Agent(
          observe: (v1.AcpIncomingMessage message) {
            if (message.method == '_ping') {
              observedParams = message.params.value;
            }
          },
        );
        final harness = RouterHarness(AcpProtocolRouter(v1: agent));
        final initializeOutput = harness.nextOutput();
        harness.add(initializeRequest(1));
        await initializeOutput;

        final params = <String, Object?>{
          'nested': <Object?>[
            <String, Object?>{'value': 1},
          ],
        };
        final pingOutput = harness.nextOutput();
        harness.add(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 2,
          'method': '_ping',
          'params': params,
        });
        await pingOutput;

        expect(identical(observedParams, params), isTrue);
        await harness.close();
      },
    );

    test('preserves batch framing for initialize errors', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      final output = harness.nextOutput();
      harness.add(<Object?>[initializeRequest('bad', id: 'batch-error')]);

      final batch = await output as List<Object?>;
      expect(batch, hasLength(1));
      final response = asObject(batch.single);
      expect(response['id'], 'batch-error');
      expect(errorOf(response)['code'], -32602);
      await harness.connection.closed;
    });

    test('EOF before initialize closes without a response', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      await harness.closeInput();

      await harness.connection.closed;
      expect(await harness.outputIsDone(), isTrue);
    });

    test('selected connector failure closes output and lifecycle', () async {
      final broken = v1.AcpAgentApp(
        implementation: v1.Implementation(name: 'broken', version: '1'),
        capabilities: v1.AgentCapabilities.fromJson(<String, Object?>{}),
        options: const v1.AcpApplicationOptions(
          jsonRpcOptions: v1.JsonRpcConnectionOptions(
            maximumIncomingRequests: 0,
          ),
        ),
      );
      final harness = RouterHarness(AcpProtocolRouter(v1: broken));
      harness.add(initializeRequest(1));

      await harness.connection.closed;
      expect(await harness.outputIsDone(), isTrue);
    });
  });
}
