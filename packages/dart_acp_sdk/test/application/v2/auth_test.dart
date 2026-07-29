import 'package:dart_acp_sdk/experimental/v2.dart';
import 'package:test/test.dart';

Implementation _implementation(String name) =>
    Implementation(name: name, version: '1');

AuthMethod _authMethod(AuthMethodId id) => AuthMethodAgentVariant(
  AuthMethodAgent(methodId: id, name: 'Test authentication'),
);

void main() {
  group('draft-v2 authentication helpers', () {
    test(
      'reject calls when initialization advertised no auth methods',
      () async {
        final agent = AcpV2AgentApp(
          implementation: _implementation('agent'),
          capabilities: AgentCapabilities(auth: AgentAuthCapabilities()),
        );
        final client = AcpV2ClientApp(
          implementation: _implementation('client'),
          capabilities: ClientCapabilities(),
        );
        final pair = await client.connectWith(agent);

        expect(pair.client.lifecycle.peerAuthMethods, isEmpty);
        await expectLater(
          pair.client.agent.authLogin(
            LoginAuthRequest(methodId: AuthMethodId('missing')),
          ),
          throwsA(
            isA<AcpV2CapabilityUnavailableException>().having(
              (AcpV2CapabilityUnavailableException error) => error.method,
              'method',
              'auth/login',
            ),
          ),
        );
        await expectLater(
          pair.client.agent.authLogout(LogoutAuthRequest()),
          throwsA(
            isA<AcpV2CapabilityUnavailableException>().having(
              (AcpV2CapabilityUnavailableException error) => error.method,
              'method',
              'auth/logout',
            ),
          ),
        );
        await pair.close();
      },
    );

    test('dispatches calls when auth methods were advertised', () async {
      final methodId = AuthMethodId('test-auth');
      var loginCalls = 0;
      var logoutCalls = 0;
      final agent =
          AcpV2AgentApp(
                implementation: _implementation('agent'),
                capabilities: AgentCapabilities(),
                authMethods: <AuthMethod>[_authMethod(methodId)],
              )
              .onAuthLogin((context) {
                loginCalls++;
                expect(context.params.methodId, methodId);
                return LoginAuthResponse();
              })
              .onAuthLogout((_) {
                logoutCalls++;
                return LogoutAuthResponse();
              });
      final client = AcpV2ClientApp(
        implementation: _implementation('client'),
        capabilities: ClientCapabilities(),
      );
      final pair = await client.connectWith(agent);

      expect(pair.client.lifecycle.peerAuthMethods, hasLength(1));
      expect(
        pair.client.lifecycle.peerAuthMethods.single,
        isA<AuthMethodAgentVariant>().having(
          (AuthMethodAgentVariant method) => method.value.methodId,
          'methodId',
          methodId,
        ),
      );
      expect(
        () => pair.client.lifecycle.peerAuthMethods.add(_authMethod(methodId)),
        throwsUnsupportedError,
      );
      await pair.client.agent.authLogin(LoginAuthRequest(methodId: methodId));
      await pair.client.agent.authLogout(LogoutAuthRequest());

      expect(loginCalls, 1);
      expect(logoutCalls, 1);
      await pair.close();
    });

    test('rejects a method ID that was not advertised', () async {
      final advertised = AuthMethodId('advertised');
      var loginCalls = 0;
      final agent =
          AcpV2AgentApp(
            implementation: _implementation('agent'),
            capabilities: AgentCapabilities(),
            authMethods: <AuthMethod>[_authMethod(advertised)],
          ).onAuthLogin((_) {
            loginCalls++;
            return LoginAuthResponse();
          });
      final client = AcpV2ClientApp(
        implementation: _implementation('client'),
        capabilities: ClientCapabilities(),
      );
      final pair = await client.connectWith(agent);

      await expectLater(
        pair.client.agent.authLogin(
          LoginAuthRequest(methodId: AuthMethodId('not-advertised')),
        ),
        throwsArgumentError,
      );
      expect(loginCalls, 0);
      await pair.close();
    });

    test('does not treat custom auth variants as protocol login', () async {
      final methodId = AuthMethodId('external');
      final custom = AuthMethodCustom(
        discriminator: '_external',
        payload: AcpJsonObject.fromObject(<String, Object?>{
          'methodId': methodId.value,
          'name': 'External auth',
        }),
      );
      final agent = AcpV2AgentApp(
        implementation: _implementation('agent'),
        capabilities: AgentCapabilities(),
        authMethods: <AuthMethod>[custom],
      );
      final client = AcpV2ClientApp(
        implementation: _implementation('client'),
        capabilities: ClientCapabilities(),
      );
      final pair = await client.connectWith(agent);

      expect(
        pair.client.lifecycle.peerAuthMethods.single,
        isA<AuthMethodCustom>().having(
          (AuthMethodCustom method) => method.discriminator,
          'discriminator',
          '_external',
        ),
      );
      await expectLater(
        pair.client.agent.authLogin(LoginAuthRequest(methodId: methodId)),
        throwsArgumentError,
      );
      await pair.close();
    });
  });
}
