import 'dart:async';
import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:claude_agent_sdk/src/transport/subprocess_cli_transport.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('launches, decodes stdout, writes stdin, and closes', () async {
    final directory = Directory.systemTemp.createTempSync('claude-cli-');
    addTearDown(() => directory.deleteSync(recursive: true));
    final executable = File(p.join(directory.path, 'claude'));
    executable.writeAsStringSync('''
#!/bin/sh
if [ "\$1" = "-v" ]; then
  echo "2.0.0 (Claude Code)"
  exit 0
fi
echo '{"type":"system","subtype":"ready"}'
while IFS= read -r line; do
  echo "\$line"
done
''');
    Process.runSync('chmod', ['700', executable.path], runInShell: false);
    final stderrLines = <String>[];
    final transport = SubprocessCliTransport(
      ClaudeAgentOptions(
        cliPath: executable.path,
        stderr: stderrLines.add,
        environment: const {'TEST_VALUE': '1'},
      ),
    );

    await transport.connect();
    expect(transport.isReady, isTrue);
    final iterator = StreamIterator<JsonMap>(transport.messages);
    expect(await iterator.moveNext(), isTrue);
    expect(iterator.current['subtype'], 'ready');
    await transport.write('{"type":"user","value":1}\n');
    expect(await iterator.moveNext(), isTrue);
    expect(iterator.current['value'], 1);
    await transport.endInput();
    expect(transport.isReady, isFalse);
    await iterator.cancel();
    await transport.close();
    expect(stderrLines, isEmpty);
  });

  test('surfaces a non-zero subprocess exit', () async {
    final directory = Directory.systemTemp.createTempSync('claude-fail-');
    addTearDown(() => directory.deleteSync(recursive: true));
    final executable = File(p.join(directory.path, 'claude'));
    executable.writeAsStringSync('''
#!/bin/sh
if [ "\$1" = "-v" ]; then
  echo "2.0.0"
  exit 0
fi
exit 7
''');
    Process.runSync('chmod', ['700', executable.path], runInShell: false);
    final transport = SubprocessCliTransport(
      ClaudeAgentOptions(cliPath: executable.path),
    );
    await transport.connect();

    await expectLater(
      transport.messages.drain<void>(),
      throwsA(
        isA<CliProcessException>().having(
          (error) => error.exitCode,
          'exit code',
          7,
        ),
      ),
    );
    await transport.close();
  });

  test('rejects unsupported operating-system user switching', () async {
    final transport = SubprocessCliTransport(ClaudeAgentOptions(user: 'other'));
    expect(transport.connect(), throwsUnsupportedError);
  });
}
