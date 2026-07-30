import 'dart:io';

import 'package:dart_acp_codex/dart_acp_codex.dart';

import 'fake_codex_backend.dart';

Future<void> main() async {
  for (final line in await runExample()) {
    stdout.writeln(line);
  }
}

/// Runs the deterministic embedding example and returns its display lines.
Future<List<String>> runExample() async {
  final backend = ExampleCodexBackend();
  final lines = <String>[];
  final clientApp =
      AcpClientApp.v1(
            implementation: Implementation(
              name: 'dart-acp-codex-example',
              version: dartAcpCodexVersion,
            ),
            capabilities: ClientCapabilities.fromJson(<String, Object?>{
              'fs': <String, Object?>{
                'readTextFile': false,
                'writeTextFile': false,
              },
              'terminal': false,
            }),
          )
          .onRequestPermission((context) {
            lines.add('Permission requested: ${context.params.toolCall.title}');
            return RequestPermissionResponse(
              outcome: RequestPermissionOutcomeSelected(
                SelectedPermissionOutcome(
                  optionId: context.params.options.first.optionId,
                ),
              ),
            );
          })
          .onSessionUpdate((context) {
            final update = context.params.update;
            if (update is SessionUpdateAgentMessageChunk) {
              final content = update.value.content;
              if (content is ContentBlockText) {
                lines.add('Agent: ${content.value.text}');
              }
            }
          });

  final client = await CodexAcpClient.start(
    app: clientApp,
    backend: backend,
    options: CodexAcpClientOptions(environment: const <String, String>{}),
  );
  try {
    final session = await client.agent.createSession(
      NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
    );
    lines.add('Session: ${session.sessionId.value}');
    lines.add('Model options: ${session.configOptions?.length ?? 0}');

    final response = await client.agent.sendPrompt(
      PromptRequest(
        sessionId: session.sessionId,
        prompt: <ContentBlock>[
          ContentBlockText(TextContent(text: 'Run the deterministic example.')),
        ],
      ),
    );
    await Future<void>.delayed(Duration.zero);
    lines.add('Stop reason: ${response.stopReason.toJson()}');

    return lines;
  } finally {
    await client.close();
  }
}
