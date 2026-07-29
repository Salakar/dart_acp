import 'dart:convert';

import 'package:test/test.dart';

import 'web_socket_server_test_support.dart';

void main() {
  late WebSocketServerHarness harness;

  setUp(() async {
    harness = WebSocketServerHarness(protocolVersion: 2);
    await harness.connect();
    harness.initialize();
    await waitFor(() => harness.socket!.sent.isNotEmpty);
  });

  tearDown(() => harness.close());

  test(
    'empty v2 batch gets invalid-request and connection stays open',
    () async {
      harness.socket!.receiveText('[]');

      await waitFor(() => harness.socket!.sent.length == 2);
      final response =
          jsonDecode(harness.socket!.sent.last) as Map<String, Object?>;
      final error = response['error']! as Map<String, Object?>;
      expect(error['code'], -32600);
      expect(response['id'], isNull);
      expect(harness.socket!.closeCode, isNull);
    },
  );

  test('v2 forwards inbound batches intact', () async {
    final batch = <Object?>[
      <String, Object?>{'jsonrpc': '2.0', 'id': 10, 'method': '_first'},
      <String, Object?>{'jsonrpc': '2.0', 'method': '_second'},
    ];
    harness.socket!.receiveText(jsonEncode(batch));

    await waitFor(() => harness.inbound.length == 2);
    expect(harness.inbound.last, batch);
    expect(harness.socket!.closeCode, isNull);
  });

  test('v2 preserves outbound batch framing', () async {
    final batch = <Object?>[
      <String, Object?>{'jsonrpc': '2.0', 'method': '_one'},
      <String, Object?>{'jsonrpc': '2.0', 'method': '_two'},
    ];
    harness.emit(batch);

    await waitFor(() => harness.socket!.sent.length == 2);
    expect(jsonDecode(harness.socket!.sent.last), batch);
  });

  test('duplicate initialize inside a v2 batch closes with 1002', () async {
    final duplicate = <Object?>[
      <String, Object?>{
        'jsonrpc': '2.0',
        'id': 99,
        'method': 'initialize',
        'params': <String, Object?>{'protocolVersion': 2},
      },
    ];
    harness.socket!.receiveText(jsonEncode(duplicate));

    await waitFor(() => harness.socket!.closeCode != null);
    expect(harness.socket!.closeCode, 1002);
  });

  test('headerless responses to session agent requests are accepted', () async {
    harness.emit(<String, Object?>{
      'jsonrpc': '2.0',
      'id': 'permission',
      'method': 'session/request_permission',
      'params': <String, Object?>{'sessionId': 'session-v2'},
    });
    await waitFor(() => harness.socket!.sent.length == 2);
    harness.socket!.receiveText(
      jsonEncode(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 'permission',
        'result': <String, Object?>{'outcome': 'cancelled'},
      }),
    );

    await waitFor(() => harness.inbound.length == 2);
    expect(harness.socket!.closeCode, isNull);
  });
}
