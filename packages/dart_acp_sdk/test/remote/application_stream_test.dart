import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:test/test.dart';

void main() {
  test(
    'adapts typed remote messages to the application JSON boundary',
    () async {
      final incoming = StreamController<JsonRpcWireMessage>();
      final writes = <JsonRpcWireMessage>[];
      var closed = false;
      final typed = AcpDuplexStream<JsonRpcWireMessage>(
        readable: incoming.stream,
        writable: AcpWritable<JsonRpcWireMessage>(
          write: (message) async => writes.add(message),
          close: () async => closed = true,
        ),
      );
      final application = acpApplicationStream(typed);
      final received = <Object?>[];
      final readableDone = Completer<void>();
      final subscription = application.readable.listen(
        received.add,
        onDone: readableDone.complete,
      );

      incoming
        ..add(
          const JsonRpcSuccessResponse(
            id: JsonRpcId.string('response'),
            result: <String, Object?>{'ok': true},
          ),
        )
        ..add(
          JsonRpcBatch(<JsonRpcMessage>[
            const JsonRpcNotification(method: '_vendor/one'),
            const JsonRpcNotification(method: '_vendor/two'),
          ]),
        );
      await application.writable.write(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 7,
        'method': '_vendor/request',
      });
      await application.writable.write(<Object?>[
        <String, Object?>{'jsonrpc': '2.0', 'method': '_vendor/note'},
      ]);
      await application.writable.close();
      await incoming.close();
      await readableDone.future;
      await subscription.cancel();

      expect(received.first, <String, Object?>{
        'jsonrpc': '2.0',
        'id': 'response',
        'result': <String, Object?>{'ok': true},
      });
      expect(received.last, isA<List<Object>>());
      expect(writes.first, isA<JsonRpcRequest>());
      expect(writes.last, isA<JsonRpcBatch>());
      expect(closed, isTrue);
    },
  );

  test('rejects malformed application output before transport write', () async {
    final writes = <JsonRpcWireMessage>[];
    final typed = AcpDuplexStream<JsonRpcWireMessage>(
      readable: const Stream<JsonRpcWireMessage>.empty(),
      writable: AcpWritable<JsonRpcWireMessage>(
        write: (message) async => writes.add(message),
        close: () async {},
      ),
    );
    final application = acpApplicationStream(typed);

    await expectLater(
      () => application.writable.write(<String, Object?>{'not': 'json-rpc'}),
      throwsA(isA<JsonRpcFormatException>()),
    );
    expect(writes, isEmpty);
  });
}
