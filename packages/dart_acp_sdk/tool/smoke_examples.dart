import 'dart:async';
import 'dart:convert';
import 'dart:io';

const Duration _timeout = Duration(seconds: 30);

/// Runs every executable example with deterministic smoke-sized work.
Future<void> main() async {
  final examples = <_Example>[
    const _Example('quick_start.dart', expectedOutput: 'Hello from Dart ACP.'),
    const _Example('main.dart', expectedOutput: 'client: initialized v1'),
    const _Example(
      'stdio_client.dart',
      expectedOutput: 'end_turn: Hello across stdio.',
    ),
    const _Example('http_server.dart', arguments: <String>['--smoke']),
    const _Example('http_client.dart', arguments: <String>['--smoke']),
    const _Example('web_socket_client.dart', arguments: <String>['--smoke']),
    const _Example('dual_version_agent.dart', arguments: <String>['--smoke']),
  ];

  for (final example in examples) {
    await _run(example);
  }
  stdout.writeln('Example smoke passed for ${examples.length} entrypoints.');
}

Future<void> _run(_Example example) async {
  final process = await Process.start(Platform.resolvedExecutable, <String>[
    '--suppress-analytics',
    'run',
    'example/${example.path}',
    ...example.arguments,
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
        <String>['run', 'example/${example.path}', ...example.arguments],
        errors,
        code,
      );
    }
    final expected = example.expectedOutput;
    if (expected != null && !output.contains(expected)) {
      throw StateError(
        '${example.path} output did not contain `$expected`: $output',
      );
    }
  } on TimeoutException {
    process.kill();
    await process.exitCode;
    throw TimeoutException('${example.path} exceeded $_timeout', _timeout);
  }
}

final class _Example {
  const _Example(
    this.path, {
    this.arguments = const <String>[],
    this.expectedOutput,
  });

  final String path;
  final List<String> arguments;
  final String? expectedOutput;
}
