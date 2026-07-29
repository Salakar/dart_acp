import 'package:dart_acp_sdk/experimental/web_socket.dart';
import 'package:dart_acp_sdk/src/json_rpc/message.dart';
import 'package:test/test.dart';

import 'web_socket_test_support.dart';

void main() {
  test('rejects disallowed origins before adapter I/O', () {
    final adapter = FakeWebSocketAdapter();

    expect(
      () => AcpWebSocketClientTransport(
        Uri.parse('wss://untrusted.example/acp'),
        adapter: adapter,
        originValidator: (_) => false,
      ),
      throwsArgumentError,
    );
    expect(adapter.requests, isEmpty);
  });

  test('rejects oversized writes without closing the transport', () async {
    final adapter = FakeWebSocketAdapter();
    final channel = FakeWebSocketChannel();
    final transport = AcpWebSocketClientTransport(
      Uri.parse('ws://agent.example/acp'),
      adapter: adapter,
      maximumFrameBytes: 4,
    );
    adapter.connection.complete(channel);

    await expectLater(
      transport.stream.writable.write(
        const JsonRpcNotification(method: '_vendor/too-large'),
      ),
      throwsA(isA<AcpWebSocketTransportException>()),
    );

    expect(channel.sent, isEmpty);
    expect(transport.isClosed, isFalse);
    await transport.close();
  });

  test('skips over-depth inbound JSON and remains usable', () async {
    final diagnostics = <AcpRemoteDiagnostic>[];
    final adapter = FakeWebSocketAdapter();
    final channel = FakeWebSocketChannel();
    final transport = AcpWebSocketClientTransport(
      Uri.parse('ws://agent.example/acp'),
      adapter: adapter,
      maximumJsonNestingDepth: 3,
      onDiagnostic: diagnostics.add,
    );
    adapter.connection.complete(channel);
    final received = transport.stream.readable.first;
    await pumpWebSocketUntil(() => channel.frameController.hasListener);

    channel.frameController
      ..add(
        const AcpWebSocketTextFrame(
          '{"jsonrpc":"2.0","method":"_too-deep","params":[[{}]]}',
        ),
      )
      ..add(const AcpWebSocketTextFrame('{"jsonrpc":"2.0","method":"_after"}'));

    expect((await received as JsonRpcNotification).method, '_after');
    expect(diagnostics, hasLength(1));
    expect(diagnostics.single.message, contains('malformed'));
    await transport.close();
  });

  test('rejects a nonpositive JSON nesting limit', () {
    expect(
      () => AcpWebSocketClientTransport(
        Uri.parse('ws://agent.example/acp'),
        adapter: FakeWebSocketAdapter(),
        maximumJsonNestingDepth: 0,
      ),
      throwsRangeError,
    );
  });

  test('throwing diagnostics cannot interrupt WebSocket input', () async {
    final adapter = FakeWebSocketAdapter();
    final channel = FakeWebSocketChannel();
    final transport = AcpWebSocketClientTransport(
      Uri.parse('ws://agent.example/acp'),
      adapter: adapter,
      onDiagnostic: (_) => throw StateError('observer failed'),
    );
    adapter.connection.complete(channel);
    final received = transport.stream.readable.first;
    await pumpWebSocketUntil(() => channel.frameController.hasListener);

    channel.frameController
      ..add(const AcpWebSocketTextFrame('not-json'))
      ..add(const AcpWebSocketTextFrame('{"jsonrpc":"2.0","method":"_after"}'));

    expect((await received as JsonRpcNotification).method, '_after');
    await transport.close();
  });

  test(
    'close releases queued writes before a pending connect finishes',
    () async {
      final adapter = FakeWebSocketAdapter();
      final channel = FakeWebSocketChannel();
      final transport = AcpWebSocketClientTransport(
        Uri.parse('ws://agent.example/acp'),
        adapter: adapter,
      );
      final write = transport.stream.writable.write(
        const JsonRpcNotification(method: '_vendor/queued'),
      );
      final writeFailure = expectLater(write, throwsStateError);
      await Future<void>.delayed(Duration.zero);

      await transport.close().timeout(const Duration(seconds: 1));
      await writeFailure;
      adapter.connection.complete(channel);
      await pumpWebSocketUntil(() => channel.closeCount == 1);

      expect(channel.sent, isEmpty);
    },
  );
}
