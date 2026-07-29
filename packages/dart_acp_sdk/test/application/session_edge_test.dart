import 'dart:async';

import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/common/value_types.dart';
import 'package:dart_acp_sdk/src/json_rpc/error.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';
import 'package:test/test.dart';

import 'test_values.dart';

void main() {
  test('a failed prompt does not poison the next turn', () async {
    final SessionId sessionId = SessionId('recover');
    var prompts = 0;
    final AcpAgentApp agent =
        AcpAgentApp.v1(
              implementation: implementation('agent'),
              capabilities: agentCapabilities(),
            )
            .onNewSession((_) => NewSessionResponse(sessionId: sessionId))
            .onPrompt((AcpAgentRequestContext<PromptRequest> context) async {
              prompts++;
              if (prompts == 1) {
                throw JsonRpcRequestException.internalError(
                  data: 'first failed',
                );
              }
              await context.client.updateSession(
                SessionNotification(
                  sessionId: sessionId,
                  update: SessionUpdateAgentMessageChunk(
                    ContentChunk(
                      content: ContentBlockText(TextContent(text: 'recovered')),
                    ),
                  ),
                ),
              );
              return PromptResponse(stopReason: StopReason.endTurn);
            });
    final AcpDirectConnectionPair pair = await _client().connectWith(agent);
    final AcpActiveSession session = await pair.client.agent
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start();

    final AcpPromptTurn first = session.prompt(content: _prompt('first'));
    await expectLater(first.completed, throwsA(isA<JsonRpcRequestException>()));
    final AcpCollectedText second = await session
        .prompt(content: _prompt('second'))
        .collectText();

    expect(second.text, 'recovered');
    session.dispose();
    await pair.close();
  });

  test(
    'a newer v1 collector rejects an overlapping earlier collector',
    () async {
      final SessionId sessionId = SessionId('overlap');
      final List<Completer<PromptResponse>> responses =
          <Completer<PromptResponse>>[];
      final List<AcpAgentContext> contexts = <AcpAgentContext>[];
      final StreamController<void> started = StreamController<void>.broadcast();
      final AcpAgentApp agent =
          AcpAgentApp.v1(
                implementation: implementation('agent'),
                capabilities: agentCapabilities(),
              )
              .onNewSession((_) => NewSessionResponse(sessionId: sessionId))
              .onPrompt((AcpAgentRequestContext<PromptRequest> context) {
                contexts.add(context.client);
                final Completer<PromptResponse> response =
                    Completer<PromptResponse>();
                responses.add(response);
                started.add(null);
                return response.future;
              });
      final AcpDirectConnectionPair pair = await _client().connectWith(agent);
      final AcpActiveSession session = await pair.client.agent
          .newSession(cwd: AcpAbsolutePath('/workspace'))
          .start();

      final Future<void> firstStarted = started.stream.first;
      final AcpPromptTurn first = session.prompt(content: _prompt('first'));
      final Future<AcpCollectedText> firstText = first.collectText();
      await firstStarted;
      final Future<void> secondStarted = started.stream.first;
      final AcpPromptTurn second = session.prompt(content: _prompt('second'));
      final Future<AcpCollectedText> secondText = second.collectText();
      await expectLater(firstText, throwsA(isA<AcpSessionStateException>()));
      await secondStarted;

      await contexts.last.updateSession(
        SessionNotification(
          sessionId: sessionId,
          update: SessionUpdateAgentMessageChunk(
            ContentChunk(
              content: ContentBlockText(TextContent(text: 'latest')),
            ),
          ),
        ),
      );
      responses.last.complete(PromptResponse(stopReason: StopReason.endTurn));
      expect((await secondText).text, 'latest');
      responses.first.complete(
        PromptResponse(stopReason: StopReason.cancelled),
      );

      await started.close();
      session.dispose();
      await pair.close();
    },
  );
}

AcpClientApp _client() => AcpClientApp.v1(
  implementation: implementation('client'),
  capabilities: clientCapabilities(),
);

List<ContentBlock> _prompt(String text) => <ContentBlock>[
  ContentBlockText(TextContent(text: text)),
];
