import 'dart:async';

import 'package:dart_acp_sdk/experimental/v2.dart';
import 'package:test/test.dart';

Implementation _implementation(String name) =>
    Implementation(name: name, version: '1');

Future<({AcpV2DirectConnectionPair pair, AcpV2ActiveSession session})>
_openSession() async {
  final agent =
      AcpV2AgentApp(
            implementation: _implementation('agent'),
            capabilities: AgentCapabilities(session: SessionCapabilities()),
          )
          .onNewSession(
            (_) => NewSessionResponse(sessionId: SessionId('session-1')),
          )
          .onPrompt((_) => PromptResponse());
  final client = AcpV2ClientApp(
    implementation: _implementation('client'),
    capabilities: ClientCapabilities(),
  );
  final pair = await client.connectWith(agent);
  final session = await pair.client.agent.sessions
      .newSession(cwd: AbsolutePath('/workspace'))
      .start();
  return (pair: pair, session: session);
}

UpdateSessionNotification _update(SessionUpdate update) =>
    UpdateSessionNotification(
      sessionId: SessionId('session-1'),
      update: update,
    );

SessionUpdate _idle() =>
    SessionUpdateStateUpdate(StateUpdateIdle(IdleStateUpdate()));

void main() {
  group('draft-v2 prompt turns', () {
    test('pre-prompt and pre-acceptance idle cannot complete a turn', () async {
      final opened = await _openSession();
      await opened.pair.agent.client.updateSession(_update(_idle()));

      final turn = opened.session.prompt(
        content: <ContentBlock>[ContentBlockText(TextContent(text: 'hello'))],
      );
      await opened.pair.agent.client.updateSession(_update(_idle()));
      await turn.accepted;

      var completed = false;
      unawaited(turn.completed.then((_) => completed = true));
      await Future<void>.delayed(Duration.zero);
      expect(completed, isFalse);

      await opened.pair.agent.client.updateSession(_update(_idle()));
      expect((await turn.completed).state, isA<IdleStateUpdate>());
      await opened.pair.close();
    });

    test('prompt response acknowledges acceptance before completion', () async {
      final opened = await _openSession();
      final turn = opened.session.prompt(content: const <ContentBlock>[]);

      expect(await turn.accepted, isA<PromptResponse>());
      var completed = false;
      unawaited(turn.completed.then((_) => completed = true));
      await Future<void>.delayed(Duration.zero);
      expect(completed, isFalse);

      await opened.pair.agent.client.updateSession(_update(_idle()));
      await turn.completed;
      expect(completed, isTrue);
      await opened.pair.close();
    });

    test(
      'complete message patches precede chunks during text collection',
      () async {
        final opened = await _openSession();
        final turn = opened.session.prompt(content: const <ContentBlock>[]);
        await turn.accepted;
        final id = MessageId('message-1');

        await opened.pair.agent.client.updateSession(
          _update(
            SessionUpdateAgentMessage(
              AgentMessage(
                messageId: id,
                content: AcpPatch<List<ContentBlock>>.set(<ContentBlock>[
                  ContentBlockText(TextContent(text: 'replaced')),
                ]),
              ),
            ),
          ),
        );
        await opened.pair.agent.client.updateSession(
          _update(
            SessionUpdateAgentMessage(
              AgentMessage(
                messageId: id,
                content: const AcpPatch<List<ContentBlock>>.clear(),
              ),
            ),
          ),
        );
        await opened.pair.agent.client.updateSession(
          _update(
            SessionUpdateAgentMessageChunk(
              ContentChunk(
                messageId: id,
                content: ContentBlockText(TextContent(text: 'final')),
              ),
            ),
          ),
        );
        await opened.pair.agent.client.updateSession(_update(_idle()));

        final collected = await turn.collectText();
        expect(collected.text, 'final');
        expect(
          opened.session.snapshot.messages[id.value]!.content,
          hasLength(1),
        );
        await opened.pair.close();
      },
    );

    test('overlapping collectors fail deterministically', () async {
      final opened = await _openSession();
      final first = opened.session.prompt(content: const <ContentBlock>[]);
      final second = opened.session.prompt(content: const <ContentBlock>[]);
      await Future.wait(<Future<PromptResponse>>[
        first.accepted,
        second.accepted,
      ]);

      final firstCollection = first.collectText();
      final firstFailure = expectLater(
        firstCollection,
        throwsA(isA<AcpV2SessionStateException>()),
      );
      await expectLater(
        second.collectText(),
        throwsA(isA<AcpV2SessionStateException>()),
      );
      await firstFailure;
      await opened.pair.close();
    });
  });
}
