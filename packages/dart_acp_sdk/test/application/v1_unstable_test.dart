import 'package:dart_acp_sdk/experimental/v1_unstable.dart';
import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/json_rpc/error.dart';
import 'package:test/test.dart';

void main() {
  test(
    'unstable provider lifecycle requires the explicit overlay app gate',
    () async {
      const AcpApplicationOptions options = AcpApplicationOptions(
        requireInitialization: false,
      );
      final providerOperations = <Map<String, Object?>>[];
      expect(
        () => AcpAgentApp(options: options).onRequest(
          providersListMethod,
          (_) => ListProvidersResponse(providers: const <ProviderInfo>[]),
        ),
        throwsA(isA<AcpConnectionStateException>()),
      );

      final AcpAgentApp agent = AcpAgentApp(options: options)
          .withV1UnstableMethods()
          .onRequest(
            providersListMethod,
            (_) => ListProvidersResponse(providers: const <ProviderInfo>[]),
          )
          .onRequest(providersSetMethod, (context) {
            providerOperations.add(context.params.toJson());
            return providersSetMethod.resultCodec.decode(
              const <String, Object?>{},
            );
          })
          .onRequest(providersDisableMethod, (context) {
            providerOperations.add(context.params.toJson());
            return providersDisableMethod.resultCodec.decode(
              const <String, Object?>{},
            );
          });
      final AcpClientApp client = AcpClientApp(
        options: options,
      ).withV1UnstableMethods();
      final AcpDirectConnectionPair pair = await client.connectWith(agent);

      final ListProvidersResponse response = await pair.client.agent.request(
        providersListMethod,
        ListProvidersRequest(),
      );

      expect(response.providers, isEmpty);
      await pair.client.agent.request(
        providersSetMethod,
        providersSetMethod.paramsCodec.decode(<String, Object?>{
          'providerId': 'main',
          'apiType': 'openai',
          'baseUrl': 'https://example.test/v1',
        }),
      );
      await pair.client.agent.request(
        providersDisableMethod,
        providersDisableMethod.paramsCodec.decode(<String, Object?>{
          'providerId': 'main',
        }),
      );
      expect(providerOperations, <Map<String, Object?>>[
        <String, Object?>{
          'providerId': 'main',
          'apiType': 'openai',
          'baseUrl': 'https://example.test/v1',
        },
        <String, Object?>{'providerId': 'main'},
      ]);
      await pair.close();
      final missingPair = await client.connectWith(
        AcpAgentApp(options: options).withV1UnstableMethods(),
      );
      await expectLater(
        missingPair.client.agent.request(
          providersSetMethod,
          providersSetMethod.paramsCodec.decode(<String, Object?>{
            'providerId': 'main',
            'apiType': 'openai',
            'baseUrl': 'https://example.test/v1',
          }),
        ),
        throwsA(
          isA<JsonRpcRequestException>().having(
            (error) => error.code,
            'code',
            -32601,
          ),
        ),
      );
      await missingPair.close();
    },
  );
}
