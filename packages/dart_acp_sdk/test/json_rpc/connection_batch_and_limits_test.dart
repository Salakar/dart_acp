import 'dart:async';

import 'package:dart_acp_sdk/src/json_rpc/batch.dart';
import 'package:dart_acp_sdk/src/json_rpc/codec.dart';
import 'package:dart_acp_sdk/src/json_rpc/connection.dart';
import 'package:dart_acp_sdk/src/json_rpc/error.dart';
import 'package:dart_acp_sdk/src/json_rpc/handler.dart';
import 'package:dart_acp_sdk/src/json_rpc/id.dart';
import 'package:dart_acp_sdk/src/json_rpc/params.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:test/test.dart';

import 'test_stream_pair.dart';

void main() {
  group('JsonRpcConnection batches and limits', () {
    test(
      'batch outputs retain input order while handlers run concurrently',
      () async {
        final TestStreamPair pair = TestStreamPair.create();
        final Completer<void> slowStarted = Completer<void>();
        final Completer<void> releaseSlow = Completer<void>();
        final List<Object?> notifications = <Object?>[];
        final JsonRpcConnection server = JsonRpcConnectionBuilder()
            .onRequest<Object?>(
              method: 'example/slow',
              parse: (Object? value) => value,
              handler:
                  (
                    Object? _,
                    JsonRpcRequestResponder responder,
                    JsonRpcHandlerContext _,
                  ) async {
                    slowStarted.complete();
                    await releaseSlow.future;
                    await responder.respond('slow');
                    return const JsonRpcHandled();
                  },
            )
            .onRequest<Object?>(
              method: 'example/fast',
              parse: (Object? value) => value,
              handler:
                  (
                    Object? _,
                    JsonRpcRequestResponder responder,
                    JsonRpcHandlerContext _,
                  ) async {
                    await responder.respond('fast');
                    return const JsonRpcHandled();
                  },
            )
            .onNotification<Object?>(
              method: 'example/note',
              parse: (Object? value) => value,
              handler: (Object? value, JsonRpcHandlerContext _) {
                notifications.add(value);
                return const JsonRpcHandled();
              },
            )
            .connect(stream: pair.right);
        final JsonRpcConnection client = JsonRpcConnection(stream: pair.left);

        final Future<List<Object?>> outputs = client.sendBatch(
          <JsonRpcBatchEntry>[
            const JsonRpcBatchRequest<String>(method: 'example/slow'),
            const JsonRpcBatchNotification(
              method: 'example/note',
              params: JsonRpcParams.value(<String, Object?>{'value': 8}),
            ),
            const JsonRpcBatchRequest<String>(method: 'example/fast'),
          ],
        );
        await slowStarted.future;
        releaseSlow.complete();

        expect(await outputs, <Object?>['slow', null, 'fast']);
        expect(notifications, <Object?>[
          <String, Object?>{'value': 8},
        ]);

        client.close();
        server.close();
        await pair.close();
      },
    );

    test(
      'malformed matching response rejects only its pending request',
      () async {
        final TestStreamPair pair = TestStreamPair.create();
        final JsonRpcConnection client = JsonRpcConnection(stream: pair.left);
        final StreamIterator<Object?> peer = StreamIterator<Object?>(
          pair.right.readable,
        );

        final Future<Object?> first = client.sendRequest<Object?>(
          method: 'example/first',
        );
        expect(await peer.moveNext(), isTrue);
        final Map<String, Object?> request =
            peer.current! as Map<String, Object?>;
        await pair.right.writable.write(<String, Object?>{
          'jsonrpc': '2.0',
          'id': request['id'],
          'error': null,
        });

        await expectLater(
          first,
          throwsA(
            isA<JsonRpcRequestException>().having(
              (JsonRpcRequestException error) => error.code,
              'code',
              -32600,
            ),
          ),
        );

        final Future<String> second = client.sendRequest<String>(
          method: 'example/second',
        );
        expect(await peer.moveNext(), isTrue);
        final Map<String, Object?> next = peer.current! as Map<String, Object?>;
        await pair.right.writable.write(<String, Object?>{
          'jsonrpc': '2.0',
          'id': next['id'],
          'result': 'ok',
        });
        expect(await second, 'ok');

        await peer.cancel();
        client.close();
        await pair.close();
      },
    );

    test('enforces pending and batch limits', () async {
      final StreamController<Object?> input = StreamController<Object?>();
      final JsonRpcConnection connection = JsonRpcConnection(
        stream: AcpDuplexStream<Object?>(
          readable: input.stream,
          writable: AcpWritable<Object?>(
            write: (Object? _) => Future<void>.value(),
            close: () => Future<void>.value(),
          ),
        ),
        options: const JsonRpcConnectionOptions(
          maximumPendingRequests: 1,
          maximumBatchEntries: 1,
        ),
      );
      final Future<Object?> pending = connection.sendRequest<Object?>(
        method: 'example/pending',
      );
      unawaited(pending.catchError((Object _) => null));

      expect(
        () => connection.sendRequest<Object?>(method: 'example/overflow'),
        throwsStateError,
      );
      await expectLater(
        connection.sendBatch(<JsonRpcBatchEntry>[
          const JsonRpcBatchNotification(method: 'example/one'),
          const JsonRpcBatchNotification(method: 'example/two'),
        ]),
        throwsStateError,
      );

      connection.close();
      await input.close();
    });

    test('distinguishes null, string, and number request ids', () {
      const JsonRpcId nullId = JsonRpcId.nullValue();
      const JsonRpcId stringId = JsonRpcId.string('1');
      final JsonRpcId numberId = JsonRpcId.number(1);

      expect(<JsonRpcId>{nullId, stringId, numberId}, hasLength(3));
    });

    test('ACP codec validates methods before sending', () async {
      final TestStreamPair pair = TestStreamPair.create();
      final AcpJsonRpcCodec codec = AcpJsonRpcCodec(
        protocolMethods: <String>{'session/new'},
      );
      final JsonRpcConnection server = JsonRpcConnectionBuilder()
          .onRequest<Object?>(
            method: 'session/new',
            parse: (Object? value) => value,
            handler:
                (
                  Object? _,
                  JsonRpcRequestResponder responder,
                  JsonRpcHandlerContext _,
                ) async {
                  await responder.respond('created');
                  return const JsonRpcHandled();
                },
          )
          .connect(stream: pair.right, codec: codec);
      final JsonRpcConnection client = JsonRpcConnection(
        stream: pair.left,
        codec: codec,
      );

      expect(
        () => client.sendRequest<Object?>(method: 'session/unknown'),
        throwsArgumentError,
      );
      expect(
        await client.sendRequest<String>(method: 'session/new'),
        'created',
      );
      await client.sendNotification(method: '_vendor/event');

      client.close();
      server.close();
      await pair.close();
    });
  });
}
