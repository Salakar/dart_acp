import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

Future<void> main() async {
  // ignore: avoid_print
  print(await runStdioClientExample());
}

/// Runs the child-process stdio example and returns its deterministic summary.
Future<String> runStdioClientExample() async {
  final child = await Process.start(Platform.resolvedExecutable, <String>[
    '--suppress-analytics',
    'run',
    'example/stdio_agent.dart',
  ], workingDirectory: Directory.current.path);
  final agentLogs = utf8.decodeStream(child.stderr);
  final transport = ndJsonStream(
    input: child.stdout,
    output: AcpWritable<List<int>>.fromStreamSink(child.stdin),
    options: const NdJsonStreamOptions(closeOutput: true),
  );
  final client = AcpClientApp.v1(
    implementation: Implementation(name: 'stdio-client', version: '1.0.0'),
    capabilities: ClientCapabilities(
      fs: FileSystemCapabilities(readTextFile: false, writeTextFile: false),
      terminal: false,
    ),
  );
  final connection = client.connect(transport);
  String? output;

  try {
    await connection.lifecycle.ready.timeout(const Duration(seconds: 10));
    final session = await connection.agent
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start()
        .timeout(const Duration(seconds: 10));
    final result = await session
        .prompt(
          content: <ContentBlock>[
            ContentBlockText(TextContent(text: 'Say hello')),
          ],
        )
        .collectText()
        .timeout(const Duration(seconds: 10));

    output = '${result.response.stopReason.value}: ${result.text}';
    await session.close();
  } finally {
    connection.close();
    await transport.writable.close();
  }

  final exitCode = await child.exitCode.timeout(const Duration(seconds: 10));
  final logs = await agentLogs;
  if (exitCode != 0) {
    throw ProcessException(
      Platform.resolvedExecutable,
      <String>['--suppress-analytics', 'run', 'example/stdio_agent.dart'],
      logs,
      exitCode,
    );
  }
  return output;
}
