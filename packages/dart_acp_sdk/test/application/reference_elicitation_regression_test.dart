import 'dart:async';

import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/json_rpc/error.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/method_descriptors.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';
import 'package:test/test.dart';

import 'test_values.dart';

void main() {
  test(
    'elicitation requests and completion notifications round trip',
    () async {
      late AcpAgentContext agentContext;
      final completed = Completer<String>();
      final agent = AcpAgentApp.v1(
        implementation: implementation('agent'),
        capabilities: agentCapabilities(),
      ).onConnect((connection) => agentContext = connection.client);
      final client =
          AcpClientApp.v1(
                implementation: implementation('client'),
                capabilities: _clientCapabilities(),
              )
              .onCreateElicitation((context) {
                final request = context.params as CreateElicitationRequestForm;
                expect(request.message, 'Enter your name');
                expect(
                  request.value.requestedSchema.properties,
                  contains('name'),
                );
                return elicitationCreateMethod.resultCodec.decode(
                  <String, Object?>{
                    'action': 'accept',
                    'content': <String, Object?>{'name': 'Alice'},
                  },
                );
              })
              .onElicitationComplete((context) {
                completed.complete(context.params.elicitationId.value);
              });
      final pair = await client.connectWith(agent);

      final response = await agentContext.createElicitation(_formElicitation());
      expect(response.discriminator, 'accept');
      expect(response.toJson()['content'], <String, Object?>{'name': 'Alice'});
      await agentContext.completeElicitation(
        elicitationCompleteMethod.paramsCodec.decode(<String, Object?>{
          'elicitationId': 'elicitation-1',
        }),
      );
      expect(await completed.future, 'elicitation-1');
      await pair.close();
    },
  );

  test(
    'missing elicitation requests reject while notifications are ignored',
    () async {
      late AcpAgentContext agentContext;
      final agent = AcpAgentApp.v1(
        implementation: implementation('agent'),
        capabilities: agentCapabilities(),
      ).onConnect((connection) => agentContext = connection.client);
      final client = AcpClientApp.v1(
        implementation: implementation('client'),
        capabilities: _clientCapabilities(),
      );
      final pair = await client.connectWith(agent);

      await expectLater(
        agentContext.createElicitation(_formElicitation()),
        throwsA(
          isA<JsonRpcRequestException>().having(
            (error) => error.code,
            'code',
            -32601,
          ),
        ),
      );
      await agentContext.completeElicitation(
        elicitationCompleteMethod.paramsCodec.decode(<String, Object?>{
          'elicitationId': 'ignored',
        }),
      );
      await pair.close();
    },
  );
}

CreateElicitationRequest _formElicitation() =>
    elicitationCreateMethod.paramsCodec.decode(<String, Object?>{
      'mode': 'form',
      'message': 'Enter your name',
      'sessionId': 'session-1',
      'requestedSchema': <String, Object?>{
        'type': 'object',
        'properties': <String, Object?>{
          'name': <String, Object?>{'type': 'string'},
        },
      },
    });

ClientCapabilities _clientCapabilities() =>
    ClientCapabilities.decode(<String, Object?>{
      'elicitation': <String, Object?>{
        'form': <String, Object?>{},
        'url': <String, Object?>{},
      },
    }).value;
