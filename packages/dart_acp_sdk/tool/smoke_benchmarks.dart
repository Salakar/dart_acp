import 'dart:async';
import 'dart:convert';
import 'dart:io';

const Duration _timeout = Duration(seconds: 45);

/// Runs one smoke-sized iteration of every benchmark entrypoint.
Future<void> main() async {
  final benchmarks =
      Directory('benchmark')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('_benchmark.dart'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));
  if (benchmarks.isEmpty) {
    throw StateError('No benchmark entrypoints found');
  }
  for (final benchmark in benchmarks) {
    await _run(benchmark);
  }
  stdout.writeln(
    'Benchmark smoke passed for ${benchmarks.length} entrypoints.',
  );
}

Future<void> _run(File benchmark) async {
  final process = await Process.start(Platform.resolvedExecutable, <String>[
    '--suppress-analytics',
    'run',
    benchmark.path,
    '--smoke',
  ]);
  final stdoutFuture = utf8.decodeStream(process.stdout);
  final stderrFuture = utf8.decodeStream(process.stderr);
  try {
    final code = await process.exitCode.timeout(_timeout);
    final output = await stdoutFuture;
    final errors = await stderrFuture;
    if (code != 0) {
      throw ProcessException(
        Platform.resolvedExecutable,
        <String>['run', benchmark.path, '--smoke'],
        '$errors$output',
        code,
      );
    }
  } on TimeoutException {
    process.kill();
    await process.exitCode;
    throw TimeoutException('${benchmark.path} exceeded $_timeout', _timeout);
  }
}
