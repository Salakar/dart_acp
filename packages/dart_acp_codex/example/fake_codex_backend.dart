import 'dart:async';

import 'package:dart_acp_codex/dart_acp_codex.dart';

final class ExampleCodexBackend implements CodexBackend {
  final StreamController<CodexNotification> _notifications =
      StreamController<CodexNotification>.broadcast(sync: true);
  final StreamController<CodexPendingServerRequest> _requests =
      StreamController<CodexPendingServerRequest>.broadcast(sync: true);

  @override
  Stream<CodexNotification> get notifications => _notifications.stream;

  @override
  Stream<CodexPendingServerRequest> get requests => _requests.stream;

  @override
  Future<CodexJsonObject> request(
    String method, {
    CodexJsonObject params = CodexJsonObject.empty,
  }) async {
    switch (method) {
      case 'initialize':
        return CodexJsonObject.empty;
      case 'model/list':
        return CodexJsonObject.from(<String, Object?>{
          'data': <Object?>[
            <String, Object?>{
              'id': 'example-model',
              'displayName': 'Example model',
              'isDefault': true,
              'defaultReasoningEffort': 'medium',
              'supportedReasoningEfforts': <Object?>['medium'],
              'inputModalities': <Object?>['text'],
            },
          ],
        });
      case 'thread/start':
        return CodexJsonObject.from(<String, Object?>{
          'thread': <String, Object?>{'id': 'example-session'},
          'cwd': params.optionalString('cwd') ?? '/workspace',
          'model': 'example-model',
          'reasoningEffort': 'medium',
        });
      case 'turn/start':
        Timer.run(_completeExampleTurn);
        return CodexJsonObject.from(<String, Object?>{
          'turn': <String, Object?>{'id': 'example-turn'},
        });
      default:
        return CodexJsonObject.empty;
    }
  }

  void _completeExampleTurn() {
    final approval = CodexCommandApprovalRequest(
      threadId: const CodexThreadId('example-session'),
      turnId: const CodexTurnId('example-turn'),
      params: CodexJsonObject.from(<String, Object?>{
        'threadId': 'example-session',
        'turnId': 'example-turn',
        'itemId': 'example-command',
        'command': 'dart test',
        'cwd': '/workspace',
      }),
    );
    _requests.add(
      CodexPendingServerRequest(
        request: approval,
        respond: (_) async {},
        reject: (_, _) async {},
      ),
    );
    _notifications
      ..add(
        CodexNotification(
          method: 'item/agentMessage/delta',
          params: CodexJsonObject.from(<String, Object?>{
            'threadId': 'example-session',
            'turnId': 'example-turn',
            'itemId': 'example-message',
            'delta': 'Hello from the deterministic Codex backend.',
          }),
          threadId: const CodexThreadId('example-session'),
          turnId: const CodexTurnId('example-turn'),
          itemId: const CodexItemId('example-message'),
        ),
      )
      ..add(
        CodexNotification(
          method: 'turn/completed',
          params: CodexJsonObject.from(<String, Object?>{
            'threadId': 'example-session',
            'turn': <String, Object?>{
              'id': 'example-turn',
              'status': 'completed',
            },
          }),
          threadId: const CodexThreadId('example-session'),
          turnId: const CodexTurnId('example-turn'),
        ),
      );
  }

  @override
  Future<void> notify(
    String method, {
    CodexJsonObject params = CodexJsonObject.empty,
  }) async {}

  @override
  void markTurnStale(CodexThreadId threadId, CodexTurnId turnId) {}

  @override
  Future<void> close() async {
    await _notifications.close();
    await _requests.close();
  }
}
