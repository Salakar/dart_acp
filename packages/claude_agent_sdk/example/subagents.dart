import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';

Future<void> main() async {
  final options = ClaudeAgentOptions(
    workingDirectory: Directory.current.path,
    agents: {
      'test-runner': AgentDefinition(
        description: 'Runs tests and reports actionable failures.',
        prompt: 'Run the smallest relevant tests and cite their output.',
        tools: const ['Read', 'Glob', 'Grep', 'Bash'],
        model: 'haiku',
        maxTurns: 8,
      ),
    },
    forwardSubagentText: true,
    agentProgressSummaries: true,
  );

  if (Platform.environment['CLAUDE_AGENT_SDK_LIVE_TEST'] != '1') {
    stdout.writeln(
      'Configured ${options.agents.length} programmatic subagent. '
      'Set CLAUDE_AGENT_SDK_LIVE_TEST=1 for a live query.',
    );
    return;
  }

  await for (final message in query(
    'Ask the test-runner to identify the smallest test command for this repo.',
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
