import 'dart:async';

import 'package:dart_acp_sdk/src/json_rpc/batch.dart';
import 'package:dart_acp_sdk/src/json_rpc/connection.dart';
import 'package:dart_acp_sdk/src/json_rpc/error.dart';
import 'package:dart_acp_sdk/src/json_rpc/handler.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:test/test.dart';

import 'test_stream_pair.dart';

void main() {
  test('batch responses are emitted in handler completion order', () async {
    final pair = TestStreamPair.create();
    final slowStarted = Completer<void>();
    final releaseSlow = Completer<void>();
    final server = JsonRpcConnectionBuilder()
        .onRequest<Object?>(
          method: 'test/slow',
          parse: (value) => value,
          handler: (_, responder, _) async {
            slowStarted.complete();
            await releaseSlow.future;
            await responder.respond('slow');
            return const JsonRpcHandled();
          },
        )
        .onRequest<Object?>(
          method: 'test/fast',
          parse: (value) => value,
          handler: (_, responder, _) async {
            await responder.respond('fast');
            return const JsonRpcHandled();
          },
        )
        .connect(stream: pair.right);
    final peer = StreamIterator<Object?>(pair.left.readable);

    await pair.left.writable.write(<Object?>[
      <String, Object?>{'jsonrpc': '2.0', 'id': 1, 'method': 'test/slow'},
      <String, Object?>{'jsonrpc': '2.0', 'id': 2, 'method': 'test/fast'},
    ]);
    await slowStarted.future;
    releaseSlow.complete();

    expect(await peer.moveNext(), isTrue);
    final responses = peer.current! as List<Object?>;
    expect(
      responses.map((value) => (value! as Map<String, Object?>)['id']),
      <Object?>[2, 1],
    );

    await peer.cancel();
    server.close();
    await pair.close();
  });

  test('batch response waits for notification handlers', () async {
    final pair = TestStreamPair.create();
    final notificationStarted = Completer<void>();
    final releaseNotification = Completer<void>();
    final server = JsonRpcConnectionBuilder()
        .onNotification<Object?>(
          method: 'test/note',
          parse: (value) => value,
          handler: (_, _) async {
            notificationStarted.complete();
            await releaseNotification.future;
            return const JsonRpcHandled();
          },
        )
        .onRequest<Object?>(
          method: 'test/request',
          parse: (value) => value,
          handler: (_, responder, _) async {
            await responder.respond('done');
            return const JsonRpcHandled();
          },
        )
        .connect(stream: pair.right);
    final peer = StreamIterator<Object?>(pair.left.readable);

    await pair.left.writable.write(<Object?>[
      <String, Object?>{'jsonrpc': '2.0', 'method': 'test/note'},
      <String, Object?>{'jsonrpc': '2.0', 'id': 1, 'method': 'test/request'},
    ]);
    var responseArrived = false;
    final next = peer.moveNext().then((value) {
      responseArrived = true;
      return value;
    });
    await notificationStarted.future;
    await Future<void>.delayed(Duration.zero);
    expect(responseArrived, isFalse);

    releaseNotification.complete();
    expect(await next, isTrue);
    expect(peer.current, isA<List<Object?>>());

    await peer.cancel();
    server.close();
    await pair.close();
  });

  test(
    'malformed matching response in a batch rejects only that call',
    () async {
      final pair = TestStreamPair.create();
      final outgoing = <Object?>[];
      final subscription = pair.right.readable.listen(outgoing.add);
      final client = JsonRpcConnection(stream: pair.left);

      final first = client.sendRequest<Object?>(method: 'test/first');
      final second = client.sendRequest<String>(method: 'test/second');
      await _pumpUntil(() => outgoing.length == 2);
      final firstId = (outgoing[0]! as Map<String, Object?>)['id'];
      final secondId = (outgoing[1]! as Map<String, Object?>)['id'];
      await pair.right.writable.write(<Object?>[
        <String, Object?>{'jsonrpc': '2.0', 'id': firstId, 'error': null},
        <String, Object?>{'jsonrpc': '2.0', 'id': secondId, 'result': 'ok'},
      ]);

      await expectLater(
        first,
        throwsA(
          isA<JsonRpcRequestException>().having(
            (error) => error.code,
            'code',
            -32600,
          ),
        ),
      );
      expect(await second, 'ok');
      await Future<void>.delayed(Duration.zero);
      expect(
        outgoing,
        hasLength(2),
        reason: 'response batches must not be echoed',
      );

      client.close();
      await subscription.cancel();
      await pair.close();
    },
  );

  test('notification-only sendBatch waits for the transport write', () async {
    final writeStarted = Completer<void>();
    final releaseWrite = Completer<void>();
    final connection = JsonRpcConnection(
      stream: AcpDuplexStream<Object?>(
        readable: const Stream<Object?>.empty(),
        writable: AcpWritable<Object?>(
          write: (_) async {
            writeStarted.complete();
            await releaseWrite.future;
          },
          close: () async {},
        ),
      ),
    );

    var finished = false;
    final sending = connection
        .sendBatch(<JsonRpcBatchEntry>[
          const JsonRpcBatchNotification(method: 'test/note'),
        ])
        .whenComplete(() => finished = true);
    await writeStarted.future;
    expect(finished, isFalse);

    releaseWrite.complete();
    expect(await sending, <Object?>[null]);
    connection.close();
  });
}

Future<void> _pumpUntil(bool Function() predicate) async {
  for (var attempt = 0; attempt < 100; attempt += 1) {
    if (predicate()) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  fail('Condition was not reached');
}
