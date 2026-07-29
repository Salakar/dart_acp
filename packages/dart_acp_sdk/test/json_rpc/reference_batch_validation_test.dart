import 'dart:async';

import 'package:dart_acp_sdk/src/json_rpc/connection.dart';
import 'package:dart_acp_sdk/src/json_rpc/handler.dart';
import 'package:test/test.dart';

import 'test_stream_pair.dart';

void main() {
  test(
    'malformed call-batch members receive per-entry Invalid Request',
    () async {
      final pair = TestStreamPair.create();
      final server = _server(pair);
      final peer = StreamIterator<Object?>(pair.left.readable);

      await pair.left.writable.write(<Object?>[
        <String, Object?>{'jsonrpc': '2.0', 'id': 1, 'method': 'test/ping'},
        17,
        <String, Object?>{'jsonrpc': '2.0', 'method': 'test/note'},
      ]);

      expect(await peer.moveNext(), isTrue);
      final responses = peer.current! as List<Object?>;
      expect(responses, hasLength(2));
      final objects = responses.cast<Map<String, Object?>>();
      final success = objects.singleWhere((response) => response['id'] == 1);
      expect(success['result'], 'pong');
      final invalid = objects.singleWhere((response) => response['id'] == null);
      expect(invalid['error'], containsPair('code', -32600));

      await peer.cancel();
      server.close();
      await pair.close();
    },
  );

  test(
    'an empty batch returns one non-batch Invalid Request response',
    () async {
      final pair = TestStreamPair.create();
      final server = _server(pair);
      final peer = StreamIterator<Object?>(pair.left.readable);

      await pair.left.writable.write(<Object?>[]);

      expect(await peer.moveNext(), isTrue);
      final response = peer.current! as Map<String, Object?>;
      expect(response['id'], isNull);
      expect(response['error'], containsPair('code', -32600));

      await peer.cancel();
      server.close();
      await pair.close();
    },
  );

  test(
    'response members in a call batch do not resolve pending calls',
    () async {
      final pair = TestStreamPair.create();
      final server = _server(pair);
      final peer = StreamIterator<Object?>(pair.left.readable);
      var pendingSettled = false;
      final pending = server
          .sendRequest<String>(method: 'peer/pending')
          .whenComplete(() => pendingSettled = true);

      expect(await peer.moveNext(), isTrue);
      final outgoing = peer.current! as Map<String, Object?>;
      final pendingId = outgoing['id'];
      await pair.left.writable.write(<Object?>[
        <String, Object?>{
          'jsonrpc': '2.0',
          'id': pendingId,
          'result': 'premature',
        },
        <String, Object?>{'jsonrpc': '2.0', 'id': 2, 'method': 'test/ping'},
      ]);

      expect(await peer.moveNext(), isTrue);
      final responses = peer.current! as List<Object?>;
      expect(
        responses.cast<Map<String, Object?>>().map(
          (response) => response['id'],
        ),
        containsAll(<Object?>[null, 2]),
      );
      await Future<void>.delayed(Duration.zero);
      expect(pendingSettled, isFalse);

      await pair.left.writable.write(<String, Object?>{
        'jsonrpc': '2.0',
        'id': pendingId,
        'result': 'completed',
      });
      expect(await pending, 'completed');

      await peer.cancel();
      server.close();
      await pair.close();
    },
  );
}

JsonRpcConnection _server(TestStreamPair pair) => JsonRpcConnectionBuilder()
    .onRequest<Object?>(
      method: 'test/ping',
      parse: (value) => value,
      handler: (_, responder, _) async {
        await responder.respond('pong');
        return const JsonRpcHandled();
      },
    )
    .onNotification<Object?>(
      method: 'test/note',
      parse: (value) => value,
      handler: (_, _) => const JsonRpcHandled(),
    )
    .connect(stream: pair.right);
