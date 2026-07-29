import 'dart:async';

import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:dart_acp_sdk/src/json_rpc/connection.dart';
import 'package:dart_acp_sdk/src/json_rpc/error.dart';
import 'package:dart_acp_sdk/src/json_rpc/handler.dart';
import 'package:dart_acp_sdk/src/json_rpc/params.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:test/test.dart';

import 'test_stream_pair.dart';

void main() {
  group('JsonRpcConnection', () {
    test('correlates requests and typed responses', () async {
      final TestStreamPair pair = TestStreamPair.create();
      final JsonRpcConnection server = JsonRpcConnectionBuilder()
          .onRequest<(int, int)>(
            method: 'math/add',
            parse: (Object? value) {
              final Map<String, Object?> params =
                  value! as Map<String, Object?>;
              return (params['left']! as int, params['right']! as int);
            },
            handler:
                (
                  (int, int) params,
                  JsonRpcRequestResponder responder,
                  JsonRpcHandlerContext _,
                ) async {
                  await responder.respond(params.$1 + params.$2);
                  return const JsonRpcHandled();
                },
          )
          .connect(stream: pair.right);
      final JsonRpcConnection client = JsonRpcConnection(stream: pair.left);

      final int result = await client.sendRequest<int>(
        method: 'math/add',
        params: const JsonRpcParams.value(<String, Object?>{
          'left': 2,
          'right': 3,
        }),
      );

      expect(result, 5);
      client.close();
      server.close();
      await pair.close();
    });

    test('returns method-not-found and keeps the connection usable', () async {
      final TestStreamPair pair = TestStreamPair.create();
      final JsonRpcConnection server = JsonRpcConnectionBuilder()
          .onRequest<Object?>(
            method: 'example/ping',
            parse: (Object? value) => value,
            handler:
                (
                  Object? _,
                  JsonRpcRequestResponder responder,
                  JsonRpcHandlerContext _,
                ) async {
                  await responder.respond('pong');
                  return const JsonRpcHandled();
                },
          )
          .connect(stream: pair.right);
      final JsonRpcConnection client = JsonRpcConnection(stream: pair.left);

      await expectLater(
        client.sendRequest<Object?>(method: 'example/missing'),
        throwsA(
          isA<JsonRpcRequestException>().having(
            (JsonRpcRequestException error) => error.code,
            'code',
            -32601,
          ),
        ),
      );
      expect(await client.sendRequest<String>(method: 'example/ping'), 'pong');

      client.close();
      server.close();
      await pair.close();
    });

    test('typed parser failures return JSON-RPC invalid params', () async {
      final TestStreamPair pair = TestStreamPair.create();
      var handlerCalled = false;
      final JsonRpcConnection server = JsonRpcConnectionBuilder()
          .onRequest<String>(
            method: 'example/typed',
            parse: (Object? value) {
              if (value case {'message': final String message}) {
                return message;
              }
              throw const FormatException('secret parser detail');
            },
            handler: (_, responder, _) async {
              handlerCalled = true;
              await responder.respond('unreachable');
              return const JsonRpcHandled();
            },
          )
          .connect(stream: pair.right);
      final JsonRpcConnection client = JsonRpcConnection(stream: pair.left);

      await expectLater(
        client.sendRequest<Object?>(
          method: 'example/typed',
          params: const JsonRpcParams.value(<String, Object?>{'message': 123}),
        ),
        throwsA(
          isA<JsonRpcRequestException>()
              .having((error) => error.code, 'code', -32602)
              .having((error) => error.message, 'message', 'Invalid params')
              .having((error) => error.data, 'redacted data', isNull),
        ),
      );
      expect(handlerCalled, isFalse);

      client.close();
      server.close();
      await pair.close();
    });

    test(
      'cancellation is cooperative and does not settle the request',
      () async {
        final TestStreamPair pair = TestStreamPair.create();
        final Completer<JsonRpcRequestResponder> received =
            Completer<JsonRpcRequestResponder>();
        final JsonRpcConnection server = JsonRpcConnectionBuilder()
            .onRequest<Object?>(
              method: 'example/slow',
              parse: (Object? value) => value,
              handler:
                  (
                    Object? _,
                    JsonRpcRequestResponder responder,
                    JsonRpcHandlerContext _,
                  ) {
                    received.complete(responder);
                    return const JsonRpcHandled();
                  },
            )
            .connect(stream: pair.right);
        final JsonRpcConnection client = JsonRpcConnection(stream: pair.left);
        final CancellationSource cancellation = CancellationSource();
        bool settled = false;

        final Future<String> response = client.sendRequest<String>(
          method: 'example/slow',
          cancellationToken: cancellation.token,
        );
        unawaited(
          response.then<void>(
            (_) => settled = true,
            onError: (Object _, StackTrace _) => settled = true,
          ),
        );
        final JsonRpcRequestResponder responder = await received.future;

        cancellation.cancel('user');
        await responder.cancellationToken.whenCancelled;
        await Future<void>.delayed(Duration.zero);
        expect(settled, isFalse);

        await responder.respond('completed anyway');
        expect(await response, 'completed anyway');

        client.close();
        server.close();
        await pair.close();
      },
    );

    test(
      'already-cancelled requests are written before cancellation',
      () async {
        final StreamController<Object?> input = StreamController<Object?>();
        final List<Object?> writes = <Object?>[];
        final Completer<void> firstWriteStarted = Completer<void>();
        final Completer<void> releaseFirstWrite = Completer<void>();
        final JsonRpcConnection connection = JsonRpcConnection(
          stream: AcpDuplexStream<Object?>(
            readable: input.stream,
            writable: AcpWritable<Object?>(
              write: (Object? value) async {
                writes.add(value);
                if (writes.length == 1) {
                  firstWriteStarted.complete();
                  await releaseFirstWrite.future;
                }
              },
              close: () => Future<void>.value(),
            ),
          ),
        );
        final CancellationSource cancellation = CancellationSource()
          ..cancel('already');
        final Future<Object?> response = connection.sendRequest<Object?>(
          method: 'example/slow',
          cancellationToken: cancellation.token,
        );
        unawaited(response.catchError((Object _) => null));
        await firstWriteStarted.future;

        final Future<void> later = connection.sendNotification(
          method: 'example/later',
        );
        releaseFirstWrite.complete();
        await later;

        expect((writes[0]! as Map<String, Object?>)['method'], 'example/slow');
        expect(
          (writes[1]! as Map<String, Object?>)['method'],
          r'$/cancel_request',
        );
        expect((writes[2]! as Map<String, Object?>)['method'], 'example/later');

        connection.close(StateError('test complete'));
        await input.close();
      },
    );
  });
}
