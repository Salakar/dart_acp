import 'dart:convert';
import 'dart:math';

import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:dart_acp_sdk/src/transport/line_buffer.dart';
import 'package:dart_acp_sdk/src/transport/ndjson_stream.dart';
import 'package:test/test.dart';

void main() {
  test('seeded arbitrary byte partitions preserve NDJSON values', () async {
    const seeds = <int>[0, 1, 0x414350, 0x5eed1234];
    final messages = <Object?>[
      <String, Object?>{
        'jsonrpc': '2.0',
        'id': 'é😀न',
        'method': 'session/prompt',
        'params': <String, Object?>{
          'text': 'split: \u0000 / \n / € / 𐍈',
          'values': <Object?>[null, true, -42, 1.25],
        },
      },
      <Object?>[
        <String, Object?>{'jsonrpc': '2.0', 'method': 'note/α'},
        <String, Object?>{'jsonrpc': '2.0', 'id': 7, 'result': <Object?>[]},
      ],
    ];
    final bytes = utf8.encode('${messages.map(jsonEncode).join('\n')}\n');

    for (final seed in seeds) {
      final random = Random(seed);
      for (var caseIndex = 0; caseIndex < 75; caseIndex += 1) {
        final chunks = _partition(bytes, random);
        final actual = await _decode(chunks);
        expect(
          actual,
          messages,
          reason:
              'seed=$seed case=$caseIndex chunks=${chunks.map((e) {
                return e.length;
              }).toList()}',
        );
      }
    }
  });

  test('every byte boundary preserves split Unicode code points', () async {
    final message = <String, Object?>{
      'jsonrpc': '2.0',
      'method': 'unicode/😀/é/न',
    };
    final bytes = utf8.encode(jsonEncode(message));

    for (var split = 0; split <= bytes.length; split += 1) {
      final actual = await _decode(<List<int>>[
        bytes.sublist(0, split),
        bytes.sublist(split),
      ]);
      expect(actual, <Object?>[message], reason: 'split=$split');
    }
  });

  test('oversized unterminated data fails at the exact boundary', () async {
    final atLimit = utf8.encode('{"v":"1234"}');
    expect(atLimit, hasLength(12));
    expect(
      await _decode(<List<int>>[
        atLimit.sublist(0, 6),
        atLimit.sublist(6),
      ], maximumLineBytes: 12),
      <Object?>[
        <String, Object?>{'v': '1234'},
      ],
    );
    await expectLater(
      _decode(<List<int>>[
        atLimit,
        const <int>[0x20],
      ], maximumLineBytes: 12),
      throwsA(
        isA<LineLengthExceededException>()
            .having((error) => error.maximum, 'maximum', 12)
            .having((error) => error.length, 'length', 13),
      ),
    );
  });
}

List<List<int>> _partition(List<int> bytes, Random random) {
  final chunks = <List<int>>[];
  var offset = 0;
  while (offset < bytes.length) {
    if (random.nextInt(8) == 0) {
      chunks.add(const <int>[]);
    }
    final remaining = bytes.length - offset;
    final length = 1 + random.nextInt(min(remaining, 31));
    chunks.add(bytes.sublist(offset, offset + length));
    offset += length;
  }
  if (random.nextBool()) {
    chunks.add(const <int>[]);
  }
  return chunks;
}

Future<List<Object?>> _decode(
  List<List<int>> chunks, {
  int maximumLineBytes = 1024 * 1024,
}) {
  final stream = ndJsonStream(
    input: Stream<List<int>>.fromIterable(chunks),
    output: AcpWritable<List<int>>(
      write: (_) => Future<void>.value(),
      close: () => Future<void>.value(),
    ),
    options: NdJsonStreamOptions(maximumLineBytes: maximumLineBytes),
  );
  return stream.readable.toList();
}
