import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/experimental/web_socket.dart';
import 'package:dart_acp_sdk/src/json_rpc/batch.dart';
import 'package:dart_acp_sdk/src/json_rpc/message.dart';
import 'package:test/test.dart';

import 'web_socket_test_support.dart';

void main() {
  test(
    'queues writes until open and preserves individual/batch frames',
    () async {
      final adapter = FakeWebSocketAdapter();
      final channel = FakeWebSocketChannel();
      final transport = AcpWebSocketClientTransport(
        Uri.parse('ws://agent.example/acp'),
        adapter: adapter,
        protocols: const <String>['acp'],
      );
      final messages = <JsonRpcWireMessage>[];
      final subscription = transport.stream.readable.listen(messages.add);
      final firstWrite = transport.stream.writable.write(
        const JsonRpcNotification(method: '_vendor/first'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(channel.sent, isEmpty);
      expect(adapter.requests.single.protocols, <String>['acp']);
      adapter.connection.complete(channel);
      await firstWrite;
      final batch = JsonRpcBatch(<JsonRpcMessage>[
        const JsonRpcNotification(method: '_vendor/one'),
        const JsonRpcNotification(method: '_vendor/two'),
      ]);
      await transport.stream.writable.write(batch);

      expect(jsonDecode(channel.sent.first), <String, Object?>{
        'jsonrpc': '2.0',
        'method': '_vendor/first',
      });
      expect(jsonDecode(channel.sent.last), isA<List<Object?>>());

      channel.frameController
        ..add(
          const AcpWebSocketTextFrame(
            '{"jsonrpc":"2.0","id":"one","result":null}',
          ),
        )
        ..add(
          const AcpWebSocketTextFrame(
            '[{"jsonrpc":"2.0","method":"_vendor/one"},'
            '{"jsonrpc":"2.0","method":"_vendor/two"}]',
          ),
        );
      await pumpWebSocketUntil(() => messages.length == 2);
      expect(messages.first, isA<JsonRpcSuccessResponse>());
      expect(messages.last, isA<JsonRpcBatch>());

      await transport.close();
      await subscription.cancel();
      expect(channel.closeCode, 1000);
      expect(adapter.closeCount, 0);
    },
  );

  test('honors send backpressure and serializes queued writes', () async {
    final adapter = FakeWebSocketAdapter();
    final sendGate = Completer<void>();
    final channel = FakeWebSocketChannel(sendGate: sendGate);
    final transport = AcpWebSocketClientTransport(
      Uri.parse('ws://agent.example/acp'),
      adapter: adapter,
    );
    adapter.connection.complete(channel);

    final first = transport.stream.writable.write(
      const JsonRpcNotification(method: '_vendor/first'),
    );
    final second = transport.stream.writable.write(
      const JsonRpcNotification(method: '_vendor/second'),
    );
    await Future<void>.delayed(Duration.zero);
    expect(channel.sent, isEmpty);

    sendGate.complete();
    await Future.wait<void>(<Future<void>>[first, second]);
    expect(
      channel.sent.map<Object?>(jsonDecode).map((value) {
        return (value! as Map<String, Object?>)['method'];
      }),
      <Object?>['_vendor/first', '_vendor/second'],
    );
    await transport.close();
  });

  test('merges cookies and stores upgrade cookies for caller reuse', () async {
    final store = AcpAffinityCookieStore()
      ..store(Uri.parse('wss://agent.example/acp'), <String>['route=managed']);
    final adapter = FakeWebSocketAdapter();
    final channel = FakeWebSocketChannel(
      responseHeaders: const AcpHttpHeaders().withAddedHeader(
        'Set-Cookie',
        'transport=upgrade; Path=/',
      ),
    );
    final transport = AcpWebSocketClientTransport(
      Uri.parse('wss://agent.example/acp'),
      adapter: adapter,
      cookieStore: store,
      headers: const AcpHttpHeaders()
          .withHeader('Authorization', 'Bearer token')
          .withHeader('Cookie', 'route=caller; custom=value'),
    );

    expect(
      adapter.requests.single.headers.value('cookie'),
      'route=caller; custom=value',
    );
    adapter.connection.complete(channel);
    await transport.stream.writable.write(
      const JsonRpcNotification(method: '_vendor/event'),
    );
    await transport.close();

    expect(
      store.cookieHeader(Uri.parse('wss://agent.example/acp')),
      'route=managed; transport=upgrade',
    );
    expect(adapter.closeCount, 0);
  });

  test('skips malformed, primitive, and invalid JSON-RPC text', () async {
    final adapter = FakeWebSocketAdapter();
    final channel = FakeWebSocketChannel();
    final diagnostics = <AcpRemoteDiagnostic>[];
    final messages = <JsonRpcWireMessage>[];
    final transport = AcpWebSocketClientTransport(
      Uri.parse('ws://agent.example/acp'),
      adapter: adapter,
      onDiagnostic: diagnostics.add,
    );
    final subscription = transport.stream.readable.listen(messages.add);
    adapter.connection.complete(channel);
    await Future<void>.delayed(Duration.zero);

    channel.frameController
      ..add(const AcpWebSocketTextFrame('{bad'))
      ..add(const AcpWebSocketTextFrame('42'))
      ..add(const AcpWebSocketTextFrame('{"hello":"world"}'))
      ..add(
        const AcpWebSocketTextFrame('{"jsonrpc":"2.0","method":"_vendor/ok"}'),
      );
    await pumpWebSocketUntil(() => messages.length == 1);

    expect(diagnostics, hasLength(3));
    expect(messages.single, isA<JsonRpcNotification>());
    await transport.close();
    await subscription.cancel();
  });

  test('binary and oversized frames close with protocol errors', () async {
    Future<(Object, FakeWebSocketChannel)> failWith(
      AcpWebSocketFrame frame, {
      required int maximum,
    }) async {
      final adapter = FakeWebSocketAdapter();
      final channel = FakeWebSocketChannel();
      final transport = AcpWebSocketClientTransport(
        Uri.parse('ws://agent.example/acp'),
        adapter: adapter,
        maximumFrameBytes: maximum,
      );
      final error = Completer<Object>();
      transport.stream.readable.listen(
        (_) {},
        onError: (Object value) => error.complete(value),
      );
      adapter.connection.complete(channel);
      await Future<void>.delayed(Duration.zero);
      channel.frameController.add(frame);
      final result = await error.future;
      await transport.done;
      return (result, channel);
    }

    final binary = await failWith(
      AcpWebSocketBinaryFrame(const <int>[1]),
      maximum: 10,
    );
    expect(binary.$1, isA<AcpWebSocketTransportException>());
    expect(binary.$2.closeCode, 1003);

    final oversized = await failWith(
      const AcpWebSocketTextFrame('{"long":true}'),
      maximum: 4,
    );
    expect(oversized.$1, isA<AcpWebSocketTransportException>());
    expect(oversized.$2.closeCode, 1009);
  });

  test('peer close is clean and does not reconnect', () async {
    final adapter = FakeWebSocketAdapter();
    final channel = FakeWebSocketChannel();
    final transport = AcpWebSocketClientTransport(
      Uri.parse('ws://agent.example/acp'),
      adapter: adapter,
    );
    final completed = Completer<void>();
    transport.stream.readable.listen((_) {}, onDone: completed.complete);
    adapter.connection.complete(channel);
    await Future<void>.delayed(Duration.zero);

    await channel.peerClose();
    await transport.done;
    await completed.future;

    expect(adapter.requests, hasLength(1));
    expect(transport.isClosed, isTrue);
  });
}
