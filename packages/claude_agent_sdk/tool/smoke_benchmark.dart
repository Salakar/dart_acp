import 'dart:io';

Future<void> main() async {
  final result = await Process.run(Platform.resolvedExecutable, [
    'run',
    'benchmark/model_benchmark.dart',
    '--smoke',
  ], runInShell: false);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exitCode = result.exitCode;
    return;
  }
  stdout.writeln('Benchmark smoke passed.');
}
