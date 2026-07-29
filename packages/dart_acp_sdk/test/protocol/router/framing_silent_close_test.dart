import 'package:dart_acp_sdk/experimental/protocol_router.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  group('protocol router framing and silent close', () {
    test('preserves one-entry v2 initialize batch framing', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      final output = harness.nextOutput();
      harness.add(<Object?>[initializeRequest(2, id: 'v2')]);

      final batch = await output as List<Object?>;
      expect(batch, hasLength(1));
      expect(asObject(batch.single)['id'], 'v2');
      await harness.close();
    });

    test('unwraps v1 initialize and rewraps only its first response', () async {
      final harness = RouterHarness(AcpProtocolRouter(v1: v1Agent()));
      final output = harness.nextOutput();
      harness.add(<Object?>[initializeRequest(1, id: 'v1')]);

      final batch = await output as List<Object?>;
      expect(batch, hasLength(1));
      expect(asObject(batch.single)['id'], 'v1');
      await harness.close();
    });

    test('silently closes for an initial notification', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      harness.add(<String, Object?>{
        'jsonrpc': '2.0',
        'method': '_notification',
      });

      await harness.connection.closed;
      expect(await harness.outputIsDone(), isTrue);
    });

    test('silently closes for an initial response', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      harness.add(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 1,
        'result': <String, Object?>{},
      });

      await harness.connection.closed;
      expect(await harness.outputIsDone(), isTrue);
    });

    test('silently closes for an initial response batch', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      harness.add(<Object?>[
        <String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'result': <String, Object?>{},
        },
      ]);

      await harness.connection.closed;
      expect(await harness.outputIsDone(), isTrue);
    });

    test('silently closes for ambiguous notification-response batch', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      harness.add(<Object?>[
        <String, Object?>{'jsonrpc': '2.0', 'method': '_notification'},
        <String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'result': <String, Object?>{},
        },
      ]);

      await harness.connection.closed;
      expect(await harness.outputIsDone(), isTrue);
    });

    test('rejects malformed individual first message with null id', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      final output = harness.nextOutput();
      harness.add('not-json-rpc');

      final response = asObject(await output);
      expect(response['id'], isNull);
      expect(errorOf(response)['code'], -32600);
      await harness.connection.closed;
    });

    test('rejects empty first batch with null id', () async {
      final harness = RouterHarness(AcpProtocolRouter(v2: v2Agent()));
      final output = harness.nextOutput();
      harness.add(const <Object?>[]);

      final response = asObject(await output);
      expect(response['id'], isNull);
      expect(errorOf(response)['code'], -32600);
      await harness.connection.closed;
    });
  });
}
