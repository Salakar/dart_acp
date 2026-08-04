import 'dart:async';

import 'package:dart_acp_codex/dart_acp_codex.dart';

typedef FakeCodexHandler =
    FutureOr<CodexJsonObject> Function(CodexJsonObject params);

final class FakeCodexCall {
  const FakeCodexCall({
    required this.method,
    required this.params,
    required this.isNotification,
  });

  final String method;
  final CodexJsonObject params;
  final bool isNotification;
}

final class FakeCodexBackend implements CodexBackend {
  final StreamController<CodexNotification> _notifications =
      StreamController<CodexNotification>.broadcast(sync: true);
  final StreamController<CodexPendingServerRequest> _requests =
      StreamController<CodexPendingServerRequest>.broadcast(sync: true);

  final List<FakeCodexCall> calls = <FakeCodexCall>[];
  final Map<String, FakeCodexHandler> handlers = <String, FakeCodexHandler>{};
  final List<(CodexThreadId, CodexTurnId)> staleTurns =
      <(CodexThreadId, CodexTurnId)>[];

  var _threadCounter = 0;
  var _turnCounter = 0;
  bool isClosed = false;

  @override
  Stream<CodexNotification> get notifications => _notifications.stream;

  @override
  Stream<CodexPendingServerRequest> get requests => _requests.stream;

  void on(String method, FakeCodexHandler handler) {
    handlers[method] = handler;
  }

  @override
  Future<CodexJsonObject> request(
    String method, {
    CodexJsonObject params = CodexJsonObject.empty,
  }) async {
    calls.add(
      FakeCodexCall(method: method, params: params, isNotification: false),
    );
    final handler = handlers[method];
    if (handler != null) {
      return handler(params);
    }
    return _defaultResponse(method, params);
  }

  CodexJsonObject _defaultResponse(String method, CodexJsonObject params) {
    switch (method) {
      case 'initialize':
        return CodexJsonObject.from(<String, Object?>{
          'codexHome': '/tmp/codex-home',
        });
      case 'model/list':
        return CodexJsonObject.from(<String, Object?>{
          'data': <Object?>[
            <String, Object?>{
              'id': 'gpt-test',
              'displayName': 'GPT Test',
              'description': 'Deterministic fake model',
              'isDefault': true,
              'defaultReasoningEffort': 'medium',
              'supportedReasoningEfforts': <Object?>[
                <String, Object?>{'reasoningEffort': 'low'},
                <String, Object?>{'reasoningEffort': 'medium'},
                <String, Object?>{'reasoningEffort': 'high'},
              ],
              'inputModalities': <Object?>['text', 'image'],
              'serviceTiers': <Object?>[
                <String, Object?>{'id': 'fast'},
              ],
              'contextWindow': 128000,
            },
          ],
          'nextCursor': null,
        });
      case 'thread/start':
        final id = 'thread-${++_threadCounter}';
        return CodexJsonObject.from(<String, Object?>{
          'thread': <String, Object?>{'id': id},
          'cwd': params.optionalString('cwd') ?? '/workspace',
          'model': params.optionalString('model') ?? 'gpt-test',
          'reasoningEffort': 'medium',
          'sandbox': <String, Object?>{'type': 'workspaceWrite'},
        });
      case 'thread/resume':
        final id = params.optionalString('threadId') ?? 'thread-resumed';
        return CodexJsonObject.from(<String, Object?>{
          'thread': <String, Object?>{'id': id, 'turns': <Object?>[]},
          'cwd': params.optionalString('cwd') ?? '/workspace',
          'model': 'gpt-test',
          'reasoningEffort': 'medium',
        });
      case 'thread/list':
        return CodexJsonObject.from(<String, Object?>{
          'data': <Object?>[],
          'nextCursor': null,
        });
      case 'thread/name/set':
        scheduleMicrotask(() {
          emit('thread/name/updated', <String, Object?>{
            'threadName': params.requireString('name'),
          }, threadId: params.requireString('threadId'));
        });
        return CodexJsonObject.empty;
      case 'turn/start':
        return CodexJsonObject.from(<String, Object?>{
          'turn': <String, Object?>{'id': 'turn-${++_turnCounter}'},
        });
      case 'account/read':
        return CodexJsonObject.from(<String, Object?>{
          'account': <String, Object?>{
            'type': 'chatgpt',
            'email': 'tester@example.com',
          },
          'requiresOpenaiAuth': false,
        });
      case 'account/login/start':
        scheduleMicrotask(() {
          emit('account/login/completed', <String, Object?>{'success': true});
        });
        return CodexJsonObject.empty;
      case 'skills/list':
        return CodexJsonObject.from(<String, Object?>{
          'data': <Object?>[
            <String, Object?>{'name': 'demo-skill'},
          ],
        });
      case 'mcpServerStatus/list':
        return CodexJsonObject.from(<String, Object?>{
          'data': <Object?>[
            <String, Object?>{'name': 'demo', 'status': 'connected'},
          ],
        });
      case 'thread/goal/get':
        return CodexJsonObject.from(<String, Object?>{
          'goal': <String, Object?>{'objective': 'Ship it', 'status': 'active'},
        });
      default:
        return CodexJsonObject.empty;
    }
  }

  @override
  Future<void> notify(
    String method, {
    CodexJsonObject params = CodexJsonObject.empty,
  }) async {
    calls.add(
      FakeCodexCall(method: method, params: params, isNotification: true),
    );
  }

  void emit(
    String method,
    Map<Object?, Object?> params, {
    String? threadId,
    String? turnId,
    String? itemId,
  }) {
    final json = CodexJsonObject.from(<Object?, Object?>{
      ...params,
      'threadId': ?threadId,
      'turnId': ?turnId,
      'itemId': ?itemId,
    });
    _notifications.add(
      CodexNotification(
        method: method,
        params: json,
        threadId: threadId == null ? null : CodexThreadId(threadId),
        turnId: turnId == null ? null : CodexTurnId(turnId),
        itemId: itemId == null ? null : CodexItemId(itemId),
      ),
    );
  }

  void emitNotificationError(Object error, [StackTrace? stackTrace]) {
    _notifications.addError(error, stackTrace);
  }

  void emitRequestError(Object error, [StackTrace? stackTrace]) {
    _requests.addError(error, stackTrace);
  }

  Future<CodexJsonObject> ask(CodexServerRequest request) {
    final completer = Completer<CodexJsonObject>();
    _requests.add(
      CodexPendingServerRequest(
        request: request,
        respond: (value) async => completer.complete(value),
        reject: (code, message) async =>
            completer.completeError(StateError('$code: $message')),
      ),
    );
    return completer.future;
  }

  @override
  void markTurnStale(CodexThreadId threadId, CodexTurnId turnId) {
    staleTurns.add((threadId, turnId));
  }

  FakeCodexCall lastCall(String method) =>
      calls.lastWhere((call) => call.method == method);

  int count(String method) =>
      calls.where((call) => call.method == method).length;

  @override
  Future<void> close() async {
    if (isClosed) {
      return;
    }
    isClosed = true;
    await _notifications.close();
    await _requests.close();
  }
}
