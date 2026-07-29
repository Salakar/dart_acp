import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

import 'test_values.dart';

AuthMethod _authMethod(AuthMethodId id) =>
    AuthMethodAgentVariant(AuthMethodAgent(id: id, name: 'Test auth'));

AgentCapabilities _agentCapabilities({required bool logout}) =>
    AgentCapabilities(
      loadSession: false,
      promptCapabilities: PromptCapabilities(
        image: false,
        audio: false,
        embeddedContext: false,
      ),
      mcpCapabilities: McpCapabilities(http: false, sse: false),
      sessionCapabilities: SessionCapabilities(),
      auth: AgentAuthCapabilities(logout: logout ? LogoutCapabilities() : null),
    );

void main() {
  group('stable-v1 authentication negotiation', () {
    test('no advertised methods block authenticate', () async {
      final agent = AcpAgentApp(
        implementation: implementation('agent'),
        capabilities: _agentCapabilities(logout: false),
      );
      final client = AcpClientApp(
        implementation: implementation('client'),
        capabilities: clientCapabilities(),
      );
      final pair = await client.connectWith(agent);

      expect(pair.client.lifecycle.peerAuthMethods, isEmpty);
      await expectLater(
        pair.client.agent.authenticate(
          AuthenticateRequest(methodId: AuthMethodId('missing')),
        ),
        throwsA(
          isA<AcpCapabilityUnavailableException>().having(
            (AcpCapabilityUnavailableException error) => error.method,
            'method',
            'authenticate',
          ),
        ),
      );
      await pair.close();
    });

    test(
      'exposes inventory and dispatches only advertised method IDs',
      () async {
        final advertised = AuthMethodId('advertised');
        var calls = 0;
        final agent =
            AcpAgentApp(
              implementation: implementation('agent'),
              capabilities: _agentCapabilities(logout: false),
              authMethods: <AuthMethod>[_authMethod(advertised)],
            ).onAuthenticate((context) {
              calls++;
              expect(context.params.methodId, advertised);
              return AuthenticateResponse();
            });
        final client = AcpClientApp(
          implementation: implementation('client'),
          capabilities: clientCapabilities(),
        );
        final pair = await client.connectWith(agent);

        expect(pair.client.lifecycle.peerAuthMethods, hasLength(1));
        expect(
          () => pair.client.lifecycle.peerAuthMethods.add(
            _authMethod(advertised),
          ),
          throwsUnsupportedError,
        );
        await pair.client.agent.authenticate(
          AuthenticateRequest(methodId: advertised),
        );
        await expectLater(
          pair.client.agent.authenticate(
            AuthenticateRequest(methodId: AuthMethodId('not-advertised')),
          ),
          throwsArgumentError,
        );
        expect(calls, 1);
        await pair.close();
      },
    );

    test('logout requires the nested auth.logout marker', () async {
      Future<AcpDirectConnectionPair> connect({required bool logout}) {
        final agent = AcpAgentApp(
          implementation: implementation('agent'),
          capabilities: _agentCapabilities(logout: logout),
        ).onLogout((_) => LogoutResponse());
        return AcpClientApp(
          implementation: implementation('client'),
          capabilities: clientCapabilities(),
        ).connectWith(agent);
      }

      final blocked = await connect(logout: false);
      await expectLater(
        blocked.client.agent.logout(LogoutRequest()),
        throwsA(isA<AcpCapabilityUnavailableException>()),
      );
      await blocked.close();

      final allowed = await connect(logout: true);
      await allowed.client.agent.logout(LogoutRequest());
      await allowed.close();
    });
  });
}
