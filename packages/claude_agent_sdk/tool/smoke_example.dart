import 'dart:io';

Future<void> main() async {
  for (final example in const [
    'example/quick_start.dart',
    'example/session_store.dart',
  ]) {
    final result = await Process.run(Platform.resolvedExecutable, [
      'run',
      example,
    ], runInShell: false);
    if (result.exitCode != 0) {
      stderr
        ..writeln('Example failed: $example')
        ..write(result.stderr);
      exitCode = result.exitCode;
      return;
    }
  }
  stdout.writeln('Example smoke passed.');
}
