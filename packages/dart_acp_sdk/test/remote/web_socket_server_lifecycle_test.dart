import 'dart:convert';

import 'package:dart_acp_sdk/src/remote/web_socket_server.dart';
import 'package:test/test.dart';

import 'web_socket_server_test_support.dart';

void main() {
  late WebSocketServerHarness harness;

  tearDown(() => harness.close());

  test(
    'pre-initialize malformed, primitive, and binary frames close safely',
    () async {
      harness = WebSocketServerHarness();
      var socket = await harness.connect();
      socket.receiveText('{');
      await waitFor(() => socket.closeCode != null);
      expect(socket.closeCode, 1007);

      await harness.close();
      harness = WebSocketServerHarness();
      socket = await harness.connect();
      socket.receiveText('1');
      await waitFor(() => socket.closeCode != null);
      expect(socket.closeCode, 1002);

      await harness.close();
      harness = WebSocketServerHarness();
      socket = await harness.connect();
      socket.receiveBinary(<int>[1, 2]);
      await waitFor(() => socket.closeCode != null);
      expect(socket.closeCode, 1003);
    },
  );

  test('oversized frames close with 1009', () async {
    harness = WebSocketServerHarness(maximumFrameBytes: 4);
    final socket = await harness.connect();
    socket.receiveText('12345');

    await waitFor(() => socket.closeCode != null);
    expect(socket.closeCode, 1009);
  });

  test('over-depth pre-initialize JSON closes safely', () async {
    harness = WebSocketServerHarness(maximumJsonNestingDepth: 3);
    final socket = await harness.connect();
    socket.receiveText(
      '{"jsonrpc":"2.0","id":1,"method":"initialize","params":[[{}]]}',
    );

    await waitFor(() => socket.closeCode != null);
    expect(socket.closeCode, 1007);
    expect(harness.inbound, isEmpty);
  });

  test('v1 initializes, forwards events, and rejects later batches', () async {
    harness = WebSocketServerHarness();
    final socket = await harness.connect();
    harness.initialize();
    await waitFor(() => socket.sent.isNotEmpty);

    final response = jsonDecode(socket.sent.first) as Map<String, Object?>;
    expect(response['id'], 1);
    expect(harness.session!.isInitialized, isTrue);
    expect(harness.server.socketCount, 1);

    harness.emit(<String, Object?>{'jsonrpc': '2.0', 'method': '_event'});
    await waitFor(() => socket.sent.length == 2);
    expect(socket.sent.last, contains('_event'));

    socket.receiveText(
      jsonEncode(<Object?>[
        <String, Object?>{'jsonrpc': '2.0', 'method': '_batch'},
      ]),
    );
    await waitFor(() => socket.closeCode != null);
    expect(socket.closeCode, 1002);
  });

  test('one-entry initialize batch preserves response framing', () async {
    harness = WebSocketServerHarness();
    final socket = await harness.connect();
    harness.initialize(batch: true);

    await waitFor(() => socket.sent.isNotEmpty);
    expect(jsonDecode(socket.sent.single), isA<List<Object?>>());
  });

  test(
    'duplicate individual initialize gets invalid-request and stays open',
    () async {
      harness = WebSocketServerHarness();
      final socket = await harness.connect();
      harness.initialize();
      await waitFor(() => socket.sent.isNotEmpty);

      harness.initialize();
      await waitFor(() => socket.sent.length == 2);
      final response = jsonDecode(socket.sent.last) as Map<String, Object?>;
      final error = response['error']! as Map<String, Object?>;
      expect(error['code'], -32600);
      expect(socket.closeCode, isNull);
    },
  );

  test(
    'initialize failure sends safe internal error then closes 1011',
    () async {
      harness = WebSocketServerHarness(failInitialize: true);
      final socket = await harness.connect();
      harness.initialize();

      await waitFor(() => socket.closeCode != null);
      expect(socket.closeCode, 1011);
      expect(socket.sent, hasLength(1));
      expect(socket.sent.single, contains('-32603'));
      expect(socket.sent.single, isNot(contains('connector detail')));
    },
  );

  test('upgrade policy fails closed and redacts thrown details', () async {
    harness = WebSocketServerHarness(
      policy: (_) => throw StateError('auth secret'),
    );

    await expectLater(
      harness.server.prepare(
        AcpWebSocketUpgradeContext(uri: Uri.parse('ws://localhost/acp')),
      ),
      throwsA(
        isA<AcpWebSocketUpgradeRejected>().having(
          (error) => error.toString(),
          'message',
          isNot(contains('auth secret')),
        ),
      ),
    );
  });

  test('server shutdown uses close code 1001', () async {
    harness = WebSocketServerHarness();
    final socket = await harness.connect();
    harness.initialize();
    await waitFor(() => socket.sent.isNotEmpty);

    await harness.server.close();
    expect(socket.closeCode, 1001);
  });
}
