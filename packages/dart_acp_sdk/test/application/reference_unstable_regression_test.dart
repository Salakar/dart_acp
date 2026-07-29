import 'dart:async';

import 'package:dart_acp_sdk/experimental/v1_unstable.dart';
import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:test/test.dart';

void main() {
  const options = AcpApplicationOptions(requireInitialization: false);

  test(
    'unstable NES requests and notifications preserve their lifecycle',
    () async {
      final notifications = <String>[];
      final notificationsHandled = Completer<void>();
      final agent = AcpAgentApp(options: options)
          .withV1UnstableMethods()
          .onRequest(nesStartMethod, (context) {
            expect(context.params.workspaceUri.toString(), 'file:///workspace');
            return nesStartMethod.resultCodec.decode(<String, Object?>{
              'sessionId': 'nes-1',
            });
          })
          .onRequest(
            nesSuggestMethod,
            (_) => nesSuggestMethod.resultCodec.decode(<String, Object?>{
              'suggestions': <Object?>[],
            }),
          )
          .onRequest(
            nesCloseMethod,
            (_) => nesCloseMethod.resultCodec.decode(const <String, Object?>{}),
          )
          .onNotification(nesAcceptMethod, (context) {
            notifications.add('accept:${context.params.id.value}');
          })
          .onNotification(nesRejectMethod, (context) {
            notifications.add('reject:${context.params.id.value}');
            notificationsHandled.complete();
          });
      final pair = await AcpClientApp(
        options: options,
      ).withV1UnstableMethods().connectWith(agent);

      final start = await pair.client.agent.request(
        nesStartMethod,
        nesStartMethod.paramsCodec.decode(<String, Object?>{
          'workspaceUri': 'file:///workspace',
        }),
      );
      expect(start.sessionId.value, 'nes-1');
      final suggestions = await pair.client.agent.request(
        nesSuggestMethod,
        nesSuggestMethod.paramsCodec.decode(<String, Object?>{
          'sessionId': 'nes-1',
          'position': <String, Object?>{'line': 0, 'character': 5},
          'triggerKind': 'manual',
          'uri': 'file:///workspace/main.dart',
          'version': 1,
        }),
      );
      expect(suggestions.suggestions, isEmpty);
      await pair.client.agent.request(
        nesCloseMethod,
        nesCloseMethod.paramsCodec.decode(<String, Object?>{
          'sessionId': 'nes-1',
        }),
      );
      await pair.client.agent.notify(
        nesAcceptMethod,
        nesAcceptMethod.paramsCodec.decode(<String, Object?>{
          'sessionId': 'nes-1',
          'id': 'suggestion-1',
        }),
      );
      await pair.client.agent.notify(
        nesRejectMethod,
        nesRejectMethod.paramsCodec.decode(<String, Object?>{
          'sessionId': 'nes-1',
          'id': 'suggestion-2',
          'reason': 'not applicable',
        }),
      );
      await notificationsHandled.future;
      expect(notifications, <String>[
        'accept:suggestion-1',
        'reject:suggestion-2',
      ]);
      await pair.close();
    },
  );

  test('unstable document notifications preserve every variant', () async {
    final methods = <String>[];
    final allHandled = Completer<void>();
    void record(String method) {
      methods.add(method);
      if (methods.length == 5) {
        allHandled.complete();
      }
    }

    final agent = AcpAgentApp(options: options)
        .withV1UnstableMethods()
        .onNotification(documentDidOpenMethod, (_) => record('open'))
        .onNotification(documentDidChangeMethod, (_) => record('change'))
        .onNotification(documentDidSaveMethod, (_) => record('save'))
        .onNotification(documentDidFocusMethod, (_) => record('focus'))
        .onNotification(documentDidCloseMethod, (_) => record('close'));
    final pair = await AcpClientApp(
      options: options,
    ).withV1UnstableMethods().connectWith(agent);

    await pair.client.agent.notify(
      documentDidOpenMethod,
      documentDidOpenMethod.paramsCodec.decode(<String, Object?>{
        'sessionId': 'session-1',
        'uri': 'file:///workspace/main.dart',
        'languageId': 'dart',
        'version': 1,
        'text': 'void main() {}',
      }),
    );
    await pair.client.agent.notify(
      documentDidChangeMethod,
      documentDidChangeMethod.paramsCodec.decode(<String, Object?>{
        'sessionId': 'session-1',
        'uri': 'file:///workspace/main.dart',
        'version': 2,
        'contentChanges': <Object?>[
          <String, Object?>{'text': 'void main() { print("ok"); }'},
        ],
      }),
    );
    await pair.client.agent.notify(
      documentDidSaveMethod,
      documentDidSaveMethod.paramsCodec.decode(<String, Object?>{
        'sessionId': 'session-1',
        'uri': 'file:///workspace/main.dart',
      }),
    );
    await pair.client.agent.notify(
      documentDidFocusMethod,
      documentDidFocusMethod.paramsCodec.decode(<String, Object?>{
        'sessionId': 'session-1',
        'uri': 'file:///workspace/main.dart',
        'version': 2,
        'position': <String, Object?>{'line': 0, 'character': 5},
        'visibleRange': <String, Object?>{
          'start': <String, Object?>{'line': 0, 'character': 0},
          'end': <String, Object?>{'line': 10, 'character': 0},
        },
      }),
    );
    await pair.client.agent.notify(
      documentDidCloseMethod,
      documentDidCloseMethod.paramsCodec.decode(<String, Object?>{
        'sessionId': 'session-1',
        'uri': 'file:///workspace/main.dart',
      }),
    );
    await allHandled.future;
    expect(methods, <String>['open', 'change', 'save', 'focus', 'close']);
    await pair.close();
  });
}
