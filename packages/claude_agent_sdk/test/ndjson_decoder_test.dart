import 'dart:convert';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:claude_agent_sdk/src/transport/ndjson_decoder.dart';
import 'package:test/test.dart';

void main() {
  test('decodes fragmented CRLF and ignores non-object output', () async {
    final chunks = [
      utf8.encode('diagnostic\n{"type":"sys'),
      utf8.encode('tem","value":1}\r\n\n'),
    ];

    final values = await Stream<List<int>>.fromIterable(
      chunks,
    ).transform(const NdjsonDecoder()).toList();

    expect(values, [
      {'type': 'system', 'value': 1},
    ]);
  });

  test('drops a malformed unterminated tail', () async {
    final values = await Stream<List<int>>.value(
      utf8.encode('{"type":'),
    ).transform(const NdjsonDecoder()).toList();
    expect(values, isEmpty);
  });

  test('reports malformed complete JSON lines', () async {
    expect(
      Stream<List<int>>.value(
        utf8.encode('{"type":}\n'),
      ).transform(const NdjsonDecoder()).drain<void>(),
      throwsA(isA<CliJsonDecodeException>()),
    );
  });

  test('enforces the per-frame buffer limit', () async {
    expect(
      Stream<List<int>>.value(
        utf8.encode('{"long":"123456"}'),
      ).transform(const NdjsonDecoder(maxBufferSize: 5)).drain<void>(),
      throwsA(isA<CliJsonDecodeException>()),
    );
  });
}
