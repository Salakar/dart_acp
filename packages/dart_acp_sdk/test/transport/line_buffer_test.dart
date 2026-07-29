import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_acp_sdk/src/transport/line_buffer.dart';
import 'package:test/test.dart';

void main() {
  List<String> addAll(LineBuffer buffer, Iterable<String> chunks) {
    final List<String> lines = <String>[];
    for (final String chunk in chunks) {
      lines.addAll(
        buffer
            .add(utf8.encode(chunk))
            .map<String>((Uint8List line) => utf8.decode(line)),
      );
    }
    return lines;
  }

  test('splits lines and carries tails across chunks', () {
    final LineBuffer buffer = LineBuffer();

    expect(addAll(buffer, <String>['ab', 'cd\nnext', '\n\n']), <String>[
      'abcd',
      'next',
      '',
    ]);
    expect(buffer.flush(), isNull);
  });

  test('flushes a final unterminated line once', () {
    final LineBuffer buffer = LineBuffer();

    expect(addAll(buffer, <String>['tail']), isEmpty);
    expect(utf8.decode(buffer.flush()!), 'tail');
    expect(buffer.flush(), isNull);
  });

  test('defensively copies submitted chunks', () {
    final LineBuffer buffer = LineBuffer();
    final Uint8List chunk = Uint8List.fromList(utf8.encode('mutable'));

    buffer.add(chunk);
    chunk.fillRange(0, chunk.length, 0);

    expect(utf8.decode(buffer.flush()!), 'mutable');
  });

  test('enforces maximum line bytes across chunks and complete lines', () {
    final LineBuffer split = LineBuffer(maximumLineBytes: 4);
    split.add(utf8.encode('ab'));
    expect(
      () => split.add(utf8.encode('cde')),
      throwsA(isA<LineLengthExceededException>()),
    );

    final LineBuffer complete = LineBuffer(maximumLineBytes: 4);
    expect(
      () => complete.add(utf8.encode('abcde\n')),
      throwsA(isA<LineLengthExceededException>()),
    );
  });
}
