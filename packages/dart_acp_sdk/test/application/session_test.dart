import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/common/value_types.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/method_descriptors.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';
import 'package:test/test.dart';

import 'test_values.dart';

void main() {
  test('prompt turn buffers early updates and collects message text', () async {
    final SessionId sessionId = SessionId('session-1');
    final AcpAgentApp agent =
        AcpAgentApp.v1(
              implementation: implementation('agent'),
              capabilities: agentCapabilities(),
            )
            .onNewSession((_) => NewSessionResponse(sessionId: sessionId))
            .onPrompt((AcpAgentRequestContext<PromptRequest> context) async {
              await context.client.updateSession(
                SessionNotification(
                  sessionId: sessionId,
                  update: SessionUpdateAgentMessageChunk(
                    ContentChunk(
                      content: ContentBlockText(TextContent(text: 'Hello ')),
                    ),
                  ),
                ),
              );
              await context.client.updateSession(
                SessionNotification(
                  sessionId: sessionId,
                  update: SessionUpdateAgentMessageChunk(
                    ContentChunk(
                      content: ContentBlockText(TextContent(text: 'world')),
                    ),
                  ),
                ),
              );
              return PromptResponse(stopReason: StopReason.endTurn);
            });
    final AcpClientApp client = AcpClientApp.v1(
      implementation: implementation('client'),
      capabilities: clientCapabilities(),
    );
    final AcpDirectConnectionPair pair = await client.connectWith(agent);
    final AcpActiveSession session = await pair.client.agent
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start();

    final AcpPromptTurn turn = session.prompt(
      content: <ContentBlock>[ContentBlockText(TextContent(text: 'Say hello'))],
    );
    final AcpCollectedText collected = await turn.collectText();

    expect(collected.text, 'Hello world');
    expect(collected.thoughts, isEmpty);
    expect(collected.response.stopReason, StopReason.endTurn);
    session.dispose();
    await pair.close();
  });

  test('nested client request completes without deadlock', () async {
    final SessionId sessionId = SessionId('nested');
    final AcpAgentApp agent =
        AcpAgentApp.v1(
          implementation: implementation('agent'),
          capabilities: agentCapabilities(),
        ).onNewSession((
          AcpAgentRequestContext<NewSessionRequest> context,
        ) async {
          final ReadTextFileResponse file = await context.client.readTextFile(
            ReadTextFileRequest(
              sessionId: sessionId,
              path: '/workspace/readme.md',
            ),
          );
          expect(file.content, 'nested response');
          return NewSessionResponse(sessionId: sessionId);
        });
    final AcpClientApp client = AcpClientApp.v1(
      implementation: implementation('client'),
      capabilities: clientCapabilities(readTextFile: true),
    ).onReadTextFile((_) => ReadTextFileResponse(content: 'nested response'));
    final AcpDirectConnectionPair pair = await client.connectWith(agent);

    final AcpActiveSession session = await pair.client.agent
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start();

    expect(session.sessionId, sessionId);
    session.dispose();
    await pair.close();
  });

  test(
    'convenience gates optional methods but low-level request can proxy',
    () async {
      var calls = 0;
      final AcpAgentApp agent =
          AcpAgentApp.v1(
            implementation: implementation('agent'),
            capabilities: agentCapabilities(),
          ).onListSessions((_) {
            calls++;
            return ListSessionsResponse(sessions: const <SessionInfo>[]);
          });
      final AcpClientApp client = AcpClientApp.v1(
        implementation: implementation('client'),
        capabilities: clientCapabilities(),
      );
      final AcpDirectConnectionPair pair = await client.connectWith(agent);

      expect(
        () => pair.client.agent.sessions.list(ListSessionsRequest()),
        throwsA(isA<AcpCapabilityUnavailableException>()),
      );
      final ListSessionsResponse proxied = await pair.client.agent.request(
        sessionListMethod,
        ListSessionsRequest(),
      );

      expect(proxied.sessions, isEmpty);
      expect(calls, 1);
      await pair.close();
    },
  );

  test('list validates a non-null cwd before transport', () async {
    var calls = 0;
    final AcpAgentApp agent =
        AcpAgentApp.v1(
          implementation: implementation('agent'),
          capabilities: agentCapabilities(
            sessions: SessionCapabilities(list: SessionListCapabilities()),
          ),
        ).onListSessions((_) {
          calls++;
          return ListSessionsResponse(sessions: const <SessionInfo>[]);
        });
    final AcpClientApp client = AcpClientApp.v1(
      implementation: implementation('client'),
      capabilities: clientCapabilities(),
    );
    final AcpDirectConnectionPair pair = await client.connectWith(agent);

    expect(
      () => pair.client.agent.sessions.list(
        ListSessionsRequest(cwd: 'relative/workspace'),
      ),
      throwsFormatException,
    );
    expect(calls, 0);

    final ListSessionsResponse response = await pair.client.agent.sessions.list(
      ListSessionsRequest(cwd: '/workspace'),
    );
    expect(response.sessions, isEmpty);
    expect(calls, 1);
    await pair.close();
  });
}
