import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/json_rpc/error.dart';
import 'package:dart_acp_sdk/src/protocol/method.dart';
import 'package:test/test.dart';

void main() {
  test('ordered middleware can handle typed custom requests', () async {
    final AcpMethodDescriptor<String, String> method =
        acpCustomRequestMethod<String, String>(
          name: '_example/echo',
          direction: AcpMethodDirection.clientToAgent,
          paramsCodec: const _StringCodec(),
          resultCodec: const _StringCodec(),
        );
    final List<String> order = <String>[];
    final AcpApplicationOptions options = const AcpApplicationOptions(
      requireInitialization: false,
    );
    final AcpAgentApp agent = AcpAgentApp(options: options)
        .onMessage((AcpIncomingMessage message, AcpCallContext _) {
          order.add('observe');
          return AcpMiddlewareResult.pass;
        })
        .onMessage((AcpIncomingMessage message, AcpCallContext _) async {
          order.add('handle');
          final AcpIncomingRequest request = message as AcpIncomingRequest;
          await request.respond(const _StringCodec(), 'echo');
          return AcpMiddlewareResult.handled;
        });
    final AcpClientApp client = AcpClientApp(options: options);
    final AcpDirectConnectionPair pair = await client.connectWith(agent);

    expect(await pair.client.agent.request(method, 'input'), 'echo');
    expect(order, <String>['observe', 'handle']);
    await pair.close();
  });

  test('unhandled custom requests receive method-not-found', () async {
    final AcpMethodDescriptor<String, String> method =
        acpCustomRequestMethod<String, String>(
          name: '_example/missing',
          direction: AcpMethodDirection.clientToAgent,
          paramsCodec: const _StringCodec(),
          resultCodec: const _StringCodec(),
        );
    final AcpApplicationOptions options = const AcpApplicationOptions(
      requireInitialization: false,
    );
    final AcpDirectConnectionPair pair = await AcpClientApp(
      options: options,
    ).connectWith(AcpAgentApp(options: options));

    await expectLater(
      pair.client.agent.request(method, 'input'),
      throwsA(
        isA<JsonRpcRequestException>().having(
          (JsonRpcRequestException error) => error.code,
          'code',
          -32601,
        ),
      ),
    );
    await pair.close();
  });
}

final class _StringCodec implements AcpCodec<String> {
  const _StringCodec();

  @override
  String decode(Object? value) {
    if (value is! String) {
      throw const FormatException('Expected a string');
    }
    return value;
  }

  @override
  String encode(String value) => value;
}
