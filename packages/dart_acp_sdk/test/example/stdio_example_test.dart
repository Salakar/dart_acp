@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('stdio client and agent examples complete as separate processes', () {
    expect(() async {
      final process = await Process.start(Platform.resolvedExecutable, <String>[
        '--suppress-analytics',
        'run',
        'example/stdio_client.dart',
      ], workingDirectory: Directory.current.path);
      final stdoutText = utf8.decodeStream(process.stdout);
      final stderrText = utf8.decodeStream(process.stderr);

      expect(
        await process.exitCode.timeout(const Duration(seconds: 20)),
        0,
        reason: await stderrText,
      );
      expect(await stdoutText, 'end_turn: Hello across stdio.\n');
    }(), completes);
  });
}
