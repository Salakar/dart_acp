import 'package:dart_acp_sdk/experimental/v2.dart';
import 'package:test/test.dart';

void main() {
  group('draft-v2 elicitation capabilities', () {
    test('empty and all-null capability objects advertise no modes', () async {
      for (final ClientCapabilities capabilities in <ClientCapabilities>[
        _capabilities(),
        _capabilities(form: null, url: null),
      ]) {
        final AcpV2DirectConnectionPair pair = await _connect(capabilities);

        _expectUnavailable(
          () => pair.agent.client.createElicitation(_formRequest()),
          'capabilities.elicitation.form',
        );
        _expectUnavailable(
          () => pair.agent.client.createElicitation(_urlRequest()),
          'capabilities.elicitation.url',
        );
        _expectUnavailable(
          () => pair.agent.client.completeElicitation(_completion()),
          'capabilities.elicitation.url',
        );
        await pair.close();
      }
    });

    test('form support accepts forms but not URL operations', () async {
      var requests = 0;
      final AcpV2DirectConnectionPair pair = await _connect(
        _capabilities(form: <String, Object?>{}),
        onCreate: (_) {
          requests++;
          return CreateElicitationResponseCancel();
        },
      );

      final CreateElicitationResponse response = await pair.agent.client
          .createElicitation(_formRequest());
      expect(response, isA<CreateElicitationResponseCancel>());
      expect(requests, 1);
      _expectUnavailable(
        () => pair.agent.client.createElicitation(_urlRequest()),
        'capabilities.elicitation.url',
      );
      _expectUnavailable(
        () => pair.agent.client.completeElicitation(_completion()),
        'capabilities.elicitation.url',
      );
      await pair.close();
    });

    test('URL support accepts URL creation and completion only', () async {
      var requests = 0;
      var completions = 0;
      final AcpV2DirectConnectionPair pair = await _connect(
        _capabilities(url: <String, Object?>{}),
        onCreate: (_) {
          requests++;
          return CreateElicitationResponseCancel();
        },
        onComplete: (_) => completions++,
      );

      final CreateElicitationResponse response = await pair.agent.client
          .createElicitation(_urlRequest());
      await pair.agent.client.completeElicitation(_completion());
      await Future<void>.delayed(Duration.zero);

      expect(response, isA<CreateElicitationResponseCancel>());
      expect(requests, 1);
      expect(completions, 1);
      _expectUnavailable(
        () => pair.agent.client.createElicitation(_formRequest()),
        'capabilities.elicitation.form',
      );
      await pair.close();
    });

    test('custom modes use the top-level elicitation marker', () async {
      final AcpV2DirectConnectionPair pair = await _connect(
        _capabilities(),
        onCreate: (context) {
          expect(context.params, isA<CreateElicitationRequestCustom>());
          return CreateElicitationResponseCancel();
        },
      );

      final CreateElicitationResponse response = await pair.agent.client
          .createElicitation(
            CreateElicitationRequestCustom(
              discriminator: '_vendor',
              payload: AcpJsonObject.fromObject(<String, Object?>{
                'message': 'Vendor-defined input',
              }),
            ),
          );

      expect(response, isA<CreateElicitationResponseCancel>());
      await pair.close();
    });
  });
}

Future<AcpV2DirectConnectionPair> _connect(
  ClientCapabilities capabilities, {
  CreateElicitationResponse Function(
    AcpV2ClientRequestContext<CreateElicitationRequest> context,
  )?
  onCreate,
  void Function(
    AcpV2ClientNotificationContext<CompleteElicitationNotification> context,
  )?
  onComplete,
}) {
  final AcpV2AgentApp agent = AcpV2AgentApp(
    implementation: _implementation('agent'),
    capabilities: AgentCapabilities(),
  );
  var client = AcpV2ClientApp(
    implementation: _implementation('client'),
    capabilities: capabilities,
  );
  if (onCreate != null) {
    client = client.onCreateElicitation(onCreate);
  }
  if (onComplete != null) {
    client = client.onCompleteElicitation(onComplete);
  }
  return client.connectWith(agent);
}

Implementation _implementation(String name) =>
    Implementation(name: name, version: '1');

ClientCapabilities _capabilities({
  Object? form = _absent,
  Object? url = _absent,
}) {
  final Map<String, Object?> elicitation = <String, Object?>{};
  if (!identical(form, _absent)) {
    elicitation['form'] = form;
  }
  if (!identical(url, _absent)) {
    elicitation['url'] = url;
  }
  return ClientCapabilities.fromJson(<String, Object?>{
    'elicitation': elicitation,
  });
}

CreateElicitationRequest _formRequest() =>
    CreateElicitationRequest.fromJson(<String, Object?>{
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

CreateElicitationRequest _urlRequest() =>
    CreateElicitationRequest.fromJson(<String, Object?>{
      'mode': 'url',
      'message': 'Continue in the browser',
      'sessionId': 'session-1',
      'elicitationId': 'elicitation-1',
      'url': 'https://example.test/continue',
    });

CompleteElicitationNotification _completion() =>
    CompleteElicitationNotification(
      elicitationId: ElicitationId('elicitation-1'),
    );

void _expectUnavailable(void Function() call, String capabilityPath) {
  expect(
    call,
    throwsA(
      isA<AcpV2CapabilityUnavailableException>().having(
        (AcpV2CapabilityUnavailableException error) => error.capabilityPath,
        'capabilityPath',
        capabilityPath,
      ),
    ),
  );
}

const Object _absent = Object();
