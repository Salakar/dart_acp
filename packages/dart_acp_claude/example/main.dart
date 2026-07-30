import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';

import 'scripted_claude_transport.dart';

Future<void> main() async {
  for (final line in await runExample()) {
    stdout.writeln(line);
  }
}

/// Runs the deterministic embedding example and returns its display lines.
Future<List<String>> runExample() async {
  final lines = <String>[];
  late ScriptedClaudeTransport transport;
  final clientApp =
      AcpClientApp.v1(
            implementation: Implementation(
              name: 'dart-acp-claude-example',
              version: dartAcpClaudeVersion,
            ),
            capabilities: ClientCapabilities(
              fs: FileSystemCapabilities(
                readTextFile: false,
                writeTextFile: false,
              ),
              terminal: false,
            ),
          )
          .onRequestPermission((context) {
            lines.add(
              'Permission: ${context.params.toolCall.toJson()['title']}',
            );
            return RequestPermissionResponse(
              outcome: RequestPermissionOutcomeSelected(
                SelectedPermissionOutcome(
                  optionId: context.params.options.first.optionId,
                ),
              ),
            );
          })
          .onSessionUpdate((context) {
            switch (context.params.update) {
              case SessionUpdateAgentThoughtChunk(:final value):
                if (value.content is ContentBlockText) {
                  lines.add(
                    'Thought: '
                    '${(value.content as ContentBlockText).value.text}',
                  );
                }
              case SessionUpdateAgentMessageChunk(:final value):
                if (value.content is ContentBlockText) {
                  lines.add(
                    'Agent: '
                    '${(value.content as ContentBlockText).value.text}',
                  );
                }
              case SessionUpdateToolCall(:final value):
                lines.add('Tool: ${value.title}');
              case SessionUpdateUsageUpdate(:final value):
                lines.add('Usage: ${value.used}/${value.size}');
              default:
                break;
            }
          });

  final client = await ClaudeAcpClient.start(
    app: clientApp,
    environment: ClaudeAcpEnvironment(variables: const <String, String>{}),
    idGenerator: () => '11111111-2222-4333-8444-555555555555',
    clientFactory: (options) async {
      transport = ScriptedClaudeTransport();
      return claude.ClaudeAgentClient(options: options, transport: transport);
    },
  );
  try {
    final session = await client.agent.createSession(
      NewSessionRequest(
        cwd: Directory.current.path,
        mcpServers: const <McpServer>[],
      ),
    );
    lines.add('Session: ${session.sessionId.value}');
    lines.add('Config options: ${session.configOptions?.length ?? 0}');

    final prompt = client.agent.sendPrompt(
      PromptRequest(
        sessionId: session.sessionId,
        prompt: <ContentBlock>[
          ContentBlockText(
            TextContent(text: 'Verify this package and summarize the result.'),
          ),
        ],
      ),
    );
    await transport.promptStarted.future;
    final steering = await client.agent.request(
      claudeSteeringMethod,
      ClaudeSteeringRequest(
        sessionId: session.sessionId,
        prompt: <ContentBlock>[
          ContentBlockText(TextContent(text: 'Include the test status.')),
        ],
      ),
    );
    lines.add('Steering: ${steering.outcome.name}');
    final response = await prompt;
    lines.add('Stop reason: ${response.stopReason.toJson()}');
    return lines;
  } finally {
    await client.close();
  }
}
