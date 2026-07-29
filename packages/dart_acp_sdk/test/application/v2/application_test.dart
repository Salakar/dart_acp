import 'package:dart_acp_sdk/experimental/v2.dart';
import 'package:test/test.dart';

Implementation _implementation(String name) =>
    Implementation(name: name, version: '1.0.0');

void main() {
  group('draft-v2 application', () {
    test(
      'initializes version 2 and runs connect handlers exactly once',
      () async {
        var agentConnects = 0;
        var clientConnects = 0;
        final agent = AcpV2AgentApp(
          implementation: _implementation('agent'),
          capabilities: AgentCapabilities(session: SessionCapabilities()),
        ).onConnect((_) => agentConnects++);
        final client = AcpV2ClientApp(
          implementation: _implementation('client'),
          capabilities: ClientCapabilities(),
        ).onConnect((_) => clientConnects++);

        final pair = await client.connectWith(agent);
        expect(pair.agent.lifecycle.state, AcpV2ConnectionState.ready);
        expect(pair.client.lifecycle.state, AcpV2ConnectionState.ready);
        expect(
          pair.agent.lifecycle.peerImplementation?['name']?.toObject(),
          'client',
        );
        expect(
          pair.client.lifecycle.peerImplementation?['name']?.toObject(),
          'agent',
        );
        expect(
          pair.client.lifecycle.peerCapabilities.supports(
            'capabilities.session',
          ),
          isTrue,
        );
        expect(
          pair.client.lifecycle.peerCapabilities.supports(
            'agentCapabilities.session',
          ),
          isFalse,
        );
        expect(
          pair.agent.lifecycle.peerCapabilities.supports('capabilities'),
          isTrue,
        );
        expect(agentConnects, 1);
        expect(clientConnects, 1);

        pair.agent.startConnectHandlers();
        pair.client.startConnectHandlers();
        expect(agentConnects, 1);
        expect(clientConnects, 1);
        await pair.close();
      },
    );

    test('typed handlers and calls use v2 models', () async {
      final agent =
          AcpV2AgentApp(
            implementation: _implementation('agent'),
            capabilities: AgentCapabilities(session: SessionCapabilities()),
          ).onListSessions(
            (context) => ListSessionsResponse(sessions: const <SessionInfo>[]),
          );
      final client = AcpV2ClientApp(
        implementation: _implementation('client'),
        capabilities: ClientCapabilities(),
      );
      final pair = await client.connectWith(agent);

      final response = await pair.client.agent.request(
        AcpV2Methods.listSessions,
        ListSessionsRequest(),
      );
      expect(response.sessions, isEmpty);
      await pair.close();
    });

    test('omitted session capability blocks curated session calls', () async {
      final agent =
          AcpV2AgentApp(
            implementation: _implementation('agent'),
            capabilities: AgentCapabilities(),
          ).onNewSession(
            (_) => NewSessionResponse(sessionId: SessionId('unexpected')),
          );
      final client = AcpV2ClientApp(
        implementation: _implementation('client'),
        capabilities: ClientCapabilities(),
      );
      final pair = await client.connectWith(agent);

      await expectLater(
        pair.client.agent.sessions
            .newSession(cwd: AbsolutePath('/workspace'))
            .start(),
        throwsA(
          isA<AcpV2CapabilityUnavailableException>()
              .having(
                (AcpV2CapabilityUnavailableException error) => error.method,
                'method',
                'session/new',
              )
              .having(
                (AcpV2CapabilityUnavailableException error) =>
                    error.capabilityPath,
                'capabilityPath',
                'capabilities.session',
              ),
        ),
      );
      await pair.close();
    });

    test('session deletion requires the nested delete marker', () async {
      var deleteCalls = 0;
      AcpV2AgentApp agentWith(SessionCapabilities session) =>
          AcpV2AgentApp(
            implementation: _implementation('agent'),
            capabilities: AgentCapabilities(session: session),
          ).onDeleteSession((_) {
            deleteCalls++;
            return DeleteSessionResponse();
          });
      AcpV2ClientApp client() => AcpV2ClientApp(
        implementation: _implementation('client'),
        capabilities: ClientCapabilities(),
      );
      final request = DeleteSessionRequest(sessionId: SessionId('session-1'));

      final unsupported = await client().connectWith(
        agentWith(SessionCapabilities()),
      );
      expect(
        () => unsupported.client.agent.sessions.delete(request),
        throwsA(
          isA<AcpV2CapabilityUnavailableException>().having(
            (AcpV2CapabilityUnavailableException error) => error.capabilityPath,
            'capabilityPath',
            'capabilities.session.delete',
          ),
        ),
      );
      await unsupported.close();

      final supported = await client().connectWith(
        agentWith(SessionCapabilities(delete: SessionDeleteCapabilities())),
      );
      await supported.client.agent.sessions.delete(request);
      expect(deleteCalls, 1);
      await supported.close();
    });

    test('baseline permission requests reach the client', () async {
      final agent = AcpV2AgentApp(
        implementation: _implementation('agent'),
        capabilities: AgentCapabilities(session: SessionCapabilities()),
      );
      final client =
          AcpV2ClientApp(
            implementation: _implementation('client'),
            capabilities: ClientCapabilities(),
          ).onRequestPermission(
            (_) => RequestPermissionResponse(
              outcome: const RequestPermissionOutcomeCancelled(),
            ),
          );
      final pair = await client.connectWith(agent);

      final response = await pair.agent.client.requestPermission(
        RequestPermissionRequest(
          sessionId: SessionId('session-1'),
          title: 'Allow operation?',
          options: <PermissionOption>[
            PermissionOption(
              optionId: PermissionOptionId('allow'),
              name: 'Allow',
              kind: PermissionOptionKind.allowOnce,
            ),
          ],
        ),
      );

      expect(response.outcome, isA<RequestPermissionOutcomeCancelled>());
      await pair.close();
    });

    test('custom method names must begin with underscore', () {
      expect(
        () => acpV2CustomRequestMethod<Object?, Object?>(
          name: 'vendor/method',
          direction: AcpMethodDirection.clientToAgent,
          paramsCodec: const _IdentityCodec(),
          resultCodec: const _IdentityCodec(),
        ),
        throwsArgumentError,
      );
      expect(
        acpV2CustomRequestMethod<Object?, Object?>(
          name: '_vendor/method',
          direction: AcpMethodDirection.clientToAgent,
          paramsCodec: const _IdentityCodec(),
          resultCodec: const _IdentityCodec(),
        ).name,
        '_vendor/method',
      );
    });

    test('non-positive JSON-RPC limits are rejected on connect', () {
      final agent = AcpV2AgentApp(
        implementation: _implementation('agent'),
        capabilities: AgentCapabilities(),
        options: const AcpV2ApplicationOptions(
          jsonRpcOptions: JsonRpcConnectionOptions(maximumBatchEntries: 0),
        ),
      );
      final transports = acpInProcessTransportPair<Object?>();
      expect(() => agent.connect(transports.left), throwsArgumentError);
    });
  });
}

final class _IdentityCodec implements AcpCodec<Object?> {
  const _IdentityCodec();

  @override
  Object? decode(Object? value) => value;

  @override
  Object? encode(Object? value) => value;
}
