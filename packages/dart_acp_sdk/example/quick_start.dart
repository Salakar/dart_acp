import 'package:dart_acp_sdk/dart_acp_sdk.dart';

Future<void> main() async {
  // ignore: avoid_print
  print(await runQuickStartExample());
}

/// Runs a minimal stable-v1 conversation entirely in memory.
Future<String> runQuickStartExample() async {
  final sessionId = SessionId('quick-start');
  final agent =
      AcpAgentApp.v1(
        implementation: Implementation(name: 'example-agent', version: '1.0.0'),
        capabilities: AgentCapabilities(
          loadSession: false,
          promptCapabilities: PromptCapabilities(
            image: false,
            audio: false,
            embeddedContext: false,
          ),
          mcpCapabilities: McpCapabilities(http: false, sse: false),
          sessionCapabilities: SessionCapabilities(),
          auth: AgentAuthCapabilities(),
        ),
      ).onNewSession((_) => NewSessionResponse(sessionId: sessionId)).onPrompt((
        context,
      ) async {
        await context.client.updateSession(
          SessionNotification(
            sessionId: context.params.sessionId,
            update: SessionUpdateAgentMessageChunk(
              ContentChunk(
                content: ContentBlockText(
                  TextContent(text: 'Hello from Dart ACP.'),
                ),
              ),
            ),
          ),
        );
        return PromptResponse(stopReason: StopReason.endTurn);
      });

  final client = AcpClientApp.v1(
    implementation: Implementation(name: 'example-client', version: '1.0.0'),
    capabilities: ClientCapabilities(
      fs: FileSystemCapabilities(readTextFile: false, writeTextFile: false),
      terminal: false,
    ),
  );

  final pair = await client.connectWith(agent);
  try {
    final session = await pair.client.agent
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start();
    final turn = await session
        .prompt(
          content: <ContentBlock>[
            ContentBlockText(TextContent(text: 'Say hello')),
          ],
        )
        .collectText();
    return turn.text;
  } finally {
    await pair.close();
  }
}
