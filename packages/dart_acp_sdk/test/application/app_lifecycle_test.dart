import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/common/value_types.dart';
import 'package:dart_acp_sdk/src/json_rpc/error.dart';
import 'package:dart_acp_sdk/src/protocol/method.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/method_descriptors.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';
import 'package:test/test.dart';

import 'test_values.dart';

void main() {
  test(
    'stable apps initialize before connect handlers and correlate types',
    () async {
      final List<String> order = <String>[];
      final AcpAgentApp baseAgent = AcpAgentApp(
        implementation: implementation('agent'),
        capabilities: agentCapabilities(),
      );
      final AcpAgentApp agent = baseAgent
          .onConnect((AcpAgentConnection connection) {
            expect(connection.lifecycle.isReady, isTrue);
            expect(
              connection.lifecycle.peerCapabilities.supports(
                'clientCapabilities.fs.readTextFile',
              ),
              isTrue,
            );
            order.add('agent');
          })
          .onNewSession((AcpAgentRequestContext<NewSessionRequest> context) {
            expect(context.params.cwd, '/workspace');
            return NewSessionResponse(sessionId: SessionId('session-1'));
          });
      final AcpClientApp client =
          AcpClientApp(
            implementation: implementation('client'),
            capabilities: clientCapabilities(readTextFile: true),
          ).onConnect((AcpClientConnection connection) {
            expect(connection.lifecycle.isReady, isTrue);
            order.add('client');
          });

      final AcpDirectConnectionPair pair = await client.connectWith(agent);
      final NewSessionResponse response = await pair.client.agent.createSession(
        NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
      );

      expect(response.sessionId, SessionId('session-1'));
      expect(order, containsAll(<String>['agent', 'client']));
      expect(baseAgent, isNot(same(agent)));
      await expectLater(
        pair.client.agent.request(
          initializeMethod,
          InitializeRequest(
            protocolVersion: ProtocolVersion(1),
            clientCapabilities: clientCapabilities(),
            clientInfo: implementation('duplicate'),
          ),
        ),
        throwsA(
          isA<JsonRpcRequestException>().having(
            (JsonRpcRequestException error) => error.code,
            'code',
            -32600,
          ),
        ),
      );
      expect(pair.agent.lifecycle.state, AcpConnectionState.ready);
      await pair.close();
      expect(pair.agent.lifecycle.state, AcpConnectionState.closed);
      expect(pair.client.lifecycle.state, AcpConnectionState.closed);
    },
  );

  test('duplicate handlers and invalid custom names fail locally', () {
    final AcpAgentApp agent = AcpAgentApp(
      options: const AcpApplicationOptions(requireInitialization: false),
    ).onNewSession((_) => NewSessionResponse(sessionId: SessionId('one')));

    expect(
      () => agent.onNewSession(
        (_) => NewSessionResponse(sessionId: SessionId('two')),
      ),
      throwsStateError,
    );
    expect(
      () => acpCustomRequestMethod<Object?, Object?>(
        name: 'vendor/method',
        direction: AcpMethodDirection.clientToAgent,
        paramsCodec: _IdentityCodec(),
        resultCodec: _IdentityCodec(),
      ),
      throwsArgumentError,
    );
  });

  test('version mismatch rejects direct initialization', () async {
    final AcpAgentApp agent = AcpAgentApp.v1(
      implementation: implementation('agent'),
      capabilities: agentCapabilities(),
    );
    final AcpClientApp client = AcpClientApp(
      initialization:
          AcpClientInitialization<InitializeRequest, InitializeResponse>(
            method: initializeMethod,
            request: InitializeRequest(
              protocolVersion: ProtocolVersion(2),
              clientCapabilities: clientCapabilities(),
              clientInfo: implementation('bad-client'),
            ),
            peerCapabilities: (_) => AcpPeerCapabilities.empty(),
          ),
    );

    await expectLater(
      client.connectWith(agent),
      throwsA(anyOf(isA<JsonRpcRequestException>(), isA<StateError>())),
    );
  });

  test('session builder validates absolute paths', () {
    expect(() => AcpAbsolutePath('relative/path'), throwsFormatException);
  });
}

final class _IdentityCodec implements AcpCodec<Object?> {
  @override
  Object? decode(Object? value) => value;

  @override
  Object? encode(Object? value) => value;
}
