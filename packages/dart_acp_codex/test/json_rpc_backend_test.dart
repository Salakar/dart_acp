import 'dart:async';

import 'package:dart_acp_codex/src/app_server/backend.dart';
import 'package:dart_acp_codex/src/app_server/json_rpc_backend.dart';
import 'package:dart_acp_codex/src/app_server/json_values.dart';
import 'package:dart_acp_codex/src/runtime/diagnostics.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

Future<T> _quick<T>(Future<T> future, String step) => future.timeout(
  const Duration(seconds: 2),
  onTimeout: () => throw TimeoutException(step),
);

void main() {
  test('correlates requests and routes notifications', () async {
    final pair = acpInProcessTransportPair<Object?>();
    final backend = CodexJsonRpcBackend.connect(pair.left);
    final peer = StreamIterator<Object?>(pair.right.readable);

    final responseFuture = backend.request(
      'model/list',
      params: CodexJsonObject.from(<Object?, Object?>{'cursor': null}),
    );
    expect(await peer.moveNext(), isTrue);
    final request = (peer.current as Map<Object?, Object?>);
    expect(request['jsonrpc'], isNull);
    expect(request['method'], 'model/list');
    await pair.right.writable.write(<String, Object?>{
      'id': request['id'],
      'result': <String, Object?>{'nextCursor': null},
    });
    expect((await responseFuture).containsKey('nextCursor'), isTrue);

    final notificationFuture = backend.notifications.first;
    await pair.right.writable.write(<String, Object?>{
      'method': 'turn/started',
      'params': <String, Object?>{
        'threadId': 'thread',
        'turn': <String, Object?>{'id': 'turn'},
      },
    });
    final notification = await notificationFuture;
    expect(notification.threadId?.value, 'thread');
    expect(notification.turnId?.value, 'turn');

    await backend.close();
    await peer.cancel();
  });

  test('uses conservative defaults without a request listener', () async {
    final pair = acpInProcessTransportPair<Object?>();
    final backend = CodexJsonRpcBackend.connect(pair.left);
    final response = pair.right.readable.first;
    await pair.right.writable.write(<String, Object?>{
      'id': 7,
      'method': 'item/commandExecution/requestApproval',
      'params': <String, Object?>{'threadId': 'thread', 'turnId': 'turn'},
    });
    final value = await response as Map<Object?, Object?>;
    expect((value['result'] as Map<Object?, Object?>)['decision'], 'cancel');
    await backend.close();
  });

  test(
    'validates outbound methods and decodes null and malformed results',
    () async {
      final pair = acpInProcessTransportPair<Object?>();
      var closed = 0;
      final backend = CodexJsonRpcBackend.connect(
        pair.left,
        onClose: () async => closed += 1,
      );
      final peer = StreamIterator<Object?>(pair.right.readable);

      expect(() => backend.request(' '), throwsArgumentError);
      expect(() => backend.notify(''), throwsArgumentError);

      final notification = backend.notify(
        'initialized',
        params: CodexJsonObject.from(<String, Object?>{'ready': true}),
      );
      expect(await peer.moveNext(), isTrue);
      expect((peer.current! as Map<Object?, Object?>)['method'], 'initialized');
      await notification;

      final nullFuture = backend.request('null/result');
      expect(await peer.moveNext(), isTrue);
      final nullRequest = peer.current! as Map<Object?, Object?>;
      await pair.right.writable.write(<String, Object?>{
        'id': nullRequest['id'],
        'result': null,
      });
      expect(await nullFuture, same(CodexJsonObject.empty));

      final malformedFuture = backend.request('bad/result');
      expect(await peer.moveNext(), isTrue);
      final malformedRequest = peer.current! as Map<Object?, Object?>;
      await pair.right.writable.write(<String, Object?>{
        'id': malformedRequest['id'],
        'result': <Object?>['not', 'an', 'object'],
      });
      await expectLater(
        malformedFuture,
        throwsA(isA<CodexProtocolException>()),
      );

      await backend.close();
      await backend.close();
      expect(closed, 1);
      await peer.cancel();
    },
  );

  test('routes pending server requests and protocol errors', () async {
    final pair = acpInProcessTransportPair<Object?>();
    final backend = CodexJsonRpcBackend.connect(pair.left);
    final peer = StreamIterator<Object?>(pair.right.readable);
    final pending = backend.requests.first;

    final sendFile = pair.right.writable.write(<String, Object?>{
      'id': 1,
      'method': 'item/fileChange/requestApproval',
      'params': <String, Object?>{'threadId': 'thread', 'turnId': 'turn'},
    });
    final request = await _quick(pending, 'receive file request');
    expect(request.request, isA<CodexFileChangeApprovalRequest>());
    final fileResponse = peer.moveNext();
    final respondFile = request.respond(
      CodexJsonObject.from(<String, Object?>{'decision': 'accept'}),
    );
    expect(await _quick(fileResponse, 'read file response'), isTrue);
    await respondFile;
    await sendFile;
    expect(
      ((peer.current! as Map<Object?, Object?>)['result']
          as Map<Object?, Object?>)['decision'],
      'accept',
    );

    final rejected = backend.requests.first;
    final sendInput = pair.right.writable.write(<String, Object?>{
      'id': 2,
      'method': 'item/tool/requestUserInput',
      'params': <String, Object?>{'threadId': 'thread', 'turnId': 'turn'},
    });
    final rejectedRequest = await _quick(rejected, 'receive user input');
    final rejectedResponse = peer.moveNext();
    final reject = rejectedRequest.reject(-32000, 'rejected');
    expect(await _quick(rejectedResponse, 'read rejected response'), isTrue);
    await reject;
    await sendInput;
    expect(
      ((peer.current! as Map<Object?, Object?>)['error']
          as Map<Object?, Object?>)['code'],
      -32000,
    );

    final unknownResponse = peer.moveNext();
    await pair.right.writable.write(<String, Object?>{
      'id': 3,
      'method': 'unknown/request',
      'params': <String, Object?>{},
    });
    expect(await _quick(unknownResponse, 'read unknown response'), isTrue);
    expect(
      ((peer.current! as Map<Object?, Object?>)['error']
          as Map<Object?, Object?>)['code'],
      -32601,
    );

    final invalidResponse = peer.moveNext();
    await pair.right.writable.write(<String, Object?>{
      'id': 4,
      'method': 'item/fileChange/requestApproval',
      'params': <String, Object?>{'threadId': 'thread'},
    });
    expect(await _quick(invalidResponse, 'read invalid response'), isTrue);
    expect(
      ((peer.current! as Map<Object?, Object?>)['error']
          as Map<Object?, Object?>)['code'],
      -32602,
    );

    await backend.close();
    await peer.cancel();
  });

  test('suppresses stale turns and returns each safe default', () async {
    final pair = acpInProcessTransportPair<Object?>();
    final backend = CodexJsonRpcBackend.connect(pair.left);
    final peer = StreamIterator<Object?>(pair.right.readable);
    backend.markTurnStale(
      const CodexThreadId('thread'),
      const CodexTurnId('stale'),
    );

    final notifications = <CodexNotification>[];
    final subscription = backend.notifications.listen(notifications.add);
    await pair.right.writable.write(<String, Object?>{
      'method': 'event',
      'params': <String, Object?>{'threadId': 'thread', 'turnId': 'stale'},
    });
    await Future<void>.delayed(Duration.zero);
    expect(notifications, isEmpty);

    final cases = <(String, Map<String, Object?>)>[
      (
        'item/commandExecution/requestApproval',
        <String, Object?>{'threadId': 'thread', 'turnId': 'turn'},
      ),
      (
        'item/permissions/requestApproval',
        <String, Object?>{'threadId': 'thread', 'turnId': 'turn'},
      ),
      (
        'mcpServer/elicitation/request',
        <String, Object?>{'threadId': 'thread'},
      ),
      (
        'item/tool/requestUserInput',
        <String, Object?>{'threadId': 'thread', 'turnId': 'turn'},
      ),
      (
        'item/commandExecution/requestApproval',
        <String, Object?>{'threadId': 'thread', 'turnId': 'stale'},
      ),
    ];
    for (var index = 0; index < cases.length; index += 1) {
      final response = peer.moveNext();
      await pair.right.writable.write(<String, Object?>{
        'id': index,
        'method': cases[index].$1,
        'params': cases[index].$2,
      });
      expect(await response, isTrue);
      expect(
        (peer.current! as Map<Object?, Object?>)['result'],
        isA<Map<Object?, Object?>>(),
      );
    }

    await subscription.cancel();
    await backend.close();
    await peer.cancel();
  });
}
