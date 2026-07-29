import 'dart:async';

import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/common/value_types.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';
import 'package:test/test.dart';

import 'test_values.dart';

void main() {
  test(
    'session builders preserve additional directories on the wire',
    () async {
      final sessionId = SessionId('roots-session');
      late List<String>? receivedDirectories;
      final agent =
          AcpAgentApp.v1(
            implementation: implementation('agent'),
            capabilities: agentCapabilities(
              sessions: SessionCapabilities(
                additionalDirectories:
                    SessionAdditionalDirectoriesCapabilities(),
              ),
            ),
          ).onNewSession((context) {
            receivedDirectories = context.params.additionalDirectories;
            return NewSessionResponse(sessionId: sessionId);
          });
      final client = AcpClientApp.v1(
        implementation: implementation('client'),
        capabilities: clientCapabilities(),
      );
      final pair = await client.connectWith(agent);
      final roots = <AcpAbsolutePath>[
        AcpAbsolutePath('/workspace/one'),
        AcpAbsolutePath('/workspace/two'),
      ];
      final builder = pair.client.agent.newSession(
        cwd: AcpAbsolutePath('/workspace'),
        additionalDirectories: roots,
      );
      roots.clear();

      expect(builder.toRequest().additionalDirectories, <String>[
        '/workspace/one',
        '/workspace/two',
      ]);
      final session = await builder.start();
      expect(receivedDirectories, <String>['/workspace/one', '/workspace/two']);

      session.dispose();
      await pair.close();
    },
  );

  test(
    'session routes buffer early updates, discard stale updates, and fail reads',
    () async {
      final sessionId = SessionId('reference-session');
      final observed = <String>[];
      final staleObserved = Completer<void>();
      final freshObserved = Completer<void>();
      late AcpAgentContext agentContext;
      var creations = 0;
      final agent =
          AcpAgentApp.v1(
                implementation: implementation('agent'),
                capabilities: agentCapabilities(),
              )
              .onConnect((connection) => agentContext = connection.client)
              .onNewSession((context) async {
                creations += 1;
                if (creations == 1) {
                  await context.client.updateSession(
                    _textUpdate(sessionId, 'early'),
                  );
                }
                return NewSessionResponse(sessionId: sessionId);
              });
      final client =
          AcpClientApp.v1(
            implementation: implementation('client'),
            capabilities: clientCapabilities(),
          ).onSessionUpdate((context) {
            final update = context.params.update;
            if (update case SessionUpdateAgentMessageChunk(
              value: ContentChunk(
                content: ContentBlockText(value: TextContent(:final text)),
              ),
            )) {
              observed.add(text);
              if (text == 'stale') {
                staleObserved.complete();
              } else if (text == 'fresh') {
                freshObserved.complete();
              }
            }
          });
      final pair = await client.connectWith(agent);

      final first = await _startSession(pair, sessionId);
      expect(
        (await first.events.first as AcpSessionUpdateEvent).update,
        isA<SessionUpdateAgentMessageChunk>(),
      );
      expect(observed, <String>['early']);
      first.dispose();

      await agentContext.updateSession(_textUpdate(sessionId, 'stale'));
      await staleObserved.future;
      final second = await _startSession(pair, sessionId);
      var secondReadSettled = false;
      final secondRead = second.events.first.whenComplete(
        () => secondReadSettled = true,
      );
      await Future<void>.delayed(Duration.zero);
      expect(secondReadSettled, isFalse, reason: 'stale update was replayed');
      await agentContext.updateSession(_textUpdate(sessionId, 'fresh'));
      final secondEvent = await secondRead as AcpSessionUpdateEvent;
      expect(
        ((secondEvent.update as SessionUpdateAgentMessageChunk).value.content
                as ContentBlockText)
            .value
            .text,
        'fresh',
      );
      await freshObserved.future;
      expect(observed, <String>['early', 'stale', 'fresh']);
      second.dispose();

      final disposed = await _startSession(pair, sessionId);
      final disposedRead = expectLater(disposed.events.first, throwsStateError);
      disposed.dispose();
      await disposedRead;

      final closed = await _startSession(pair, sessionId);
      final closedRead = expectLater(closed.events.first, throwsStateError);
      pair.client.close(StateError('reference close'));
      await closedRead;
      await pair.close();
    },
  );
}

Future<AcpActiveSession> _startSession(
  AcpDirectConnectionPair pair,
  SessionId sessionId,
) async {
  final session = await pair.client.agent
      .newSession(cwd: AcpAbsolutePath('/workspace'))
      .start();
  expect(session.sessionId, sessionId);
  return session;
}

SessionNotification _textUpdate(SessionId sessionId, String text) =>
    SessionNotification(
      sessionId: sessionId,
      update: SessionUpdateAgentMessageChunk(
        ContentChunk(content: ContentBlockText(TextContent(text: text))),
      ),
    );
