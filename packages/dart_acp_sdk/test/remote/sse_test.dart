import 'dart:convert';

import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:dart_acp_sdk/src/json_rpc/id.dart';
import 'package:dart_acp_sdk/src/json_rpc/message.dart';
import 'package:test/test.dart';

void main() {
  test('encodes events and keepalives', () {
    const message = JsonRpcSuccessResponse(
      id: JsonRpcId.string('one'),
      result: <String, Object?>{'ok': true},
    );

    expect(
      encodeSseEvent(message),
      'data: {"jsonrpc":"2.0","id":"one","result":{"ok":true}}\n\n',
    );
    expect(encodeSseKeepAlive(), ':\n\n');
  });

  test(
    'parses chunks, CRLF, comments, multiline data, and final event',
    () async {
      final diagnostics = <AcpRemoteDiagnostic>[];
      final chunks = <String>[
        ': keepalive\r\n\r\nevent: message\r\n',
        'data: {"jsonrpc":"2.0",\r\n',
        'data: "id":1,"result":{"ok":true}}\r\n\r\n',
        'data: 42\n\n',
        'data: {not-json}\n\n',
        'data: {"final":true}\n',
      ];

      final values = await decodeSseJson(
        Stream<List<int>>.fromIterable(chunks.map<List<int>>(utf8.encode)),
        onDiagnostic: diagnostics.add,
      ).toList();

      expect(values, <Object>[
        <String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'result': <String, Object?>{'ok': true},
        },
        <String, Object?>{'final': true},
      ]);
      expect(diagnostics, hasLength(2));
      expect(diagnostics.first.message, contains('primitive'));
      expect(diagnostics.last.message, contains('malformed'));
    },
  );

  test('preserves a batch array as one event', () async {
    final values = await decodeSseJson(
      Stream<List<int>>.value(
        utf8.encode(
          'data: [{"jsonrpc":"2.0","id":1,"result":null},'
          '{"jsonrpc":"2.0","id":2,"result":null}]\n\n',
        ),
      ),
    ).toList();

    expect(values, hasLength(1));
    expect(values.single, isA<List<Object?>>());
  });

  test('enforces combined event byte limits', () async {
    final stream = decodeSseJson(
      Stream<List<int>>.value(utf8.encode('data: 1234\ndata: 5678\n\n')),
      limits: const AcpSseLimits(maximumEventBytes: 8),
    );

    await expectLater(
      stream.toList(),
      throwsA(
        isA<AcpSseLimitException>()
            .having((error) => error.length, 'length', 9)
            .having((error) => error.maximum, 'maximum', 8),
      ),
    );
  });

  test('skips over-depth JSON and continues with the next event', () async {
    final diagnostics = <AcpRemoteDiagnostic>[];
    final values = await decodeSseJson(
      Stream<List<int>>.value(
        utf8.encode('data: {"too":[[{}]]}\n\ndata: {"after":true}\n\n'),
      ),
      limits: const AcpSseLimits(maximumJsonNestingDepth: 3),
      onDiagnostic: diagnostics.add,
    ).toList();

    expect(values, <Object>[
      <String, Object?>{'after': true},
    ]);
    expect(diagnostics, hasLength(1));
    expect(diagnostics.single.message, contains('malformed'));
  });

  test('throwing diagnostics cannot interrupt SSE parsing', () async {
    final values = await decodeSseJson(
      Stream<List<int>>.value(
        utf8.encode('data: not-json\n\ndata: {"after":true}\n\n'),
      ),
      onDiagnostic: (_) => throw StateError('observer failed'),
    ).toList();

    expect(values, <Object>[
      <String, Object?>{'after': true},
    ]);
  });
}
