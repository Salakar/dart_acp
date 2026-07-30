import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';

Future<void> main() async {
  final options = ClaudeAgentOptions(
    workingDirectory: Directory.current.path,
    permissionMode: PermissionMode.plan,
    allowedTools: const ['Read', 'Glob', 'Grep'],
  );
  if (Platform.environment['CLAUDE_AGENT_SDK_LIVE_TEST'] != '1') {
    stdout.writeln(
      'Configuration ready. Set CLAUDE_AGENT_SDK_LIVE_TEST=1 for a live query.',
    );
    return;
  }

  await for (final message in query(
    'Reply with exactly: Dart agent ready',
    options: options,
  )) {
    if (message case AssistantMessage(:final content)) {
      for (final block in content.whereType<TextBlock>()) {
        stdout.write(block.text);
      }
    }
  }
  stdout.writeln();
}
