import 'dart:io';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

Future<void> main() async {
  final sessionId = SessionId('stdio-example-session');
  final app =
      AcpAgentApp.v1(
            implementation: Implementation(
              name: 'stdio-agent',
              version: '1.0.0',
            ),
            capabilities: AgentCapabilities(
              loadSession: false,
              promptCapabilities: PromptCapabilities(
                image: false,
                audio: false,
                embeddedContext: false,
              ),
              mcpCapabilities: McpCapabilities(http: false, sse: false),
              sessionCapabilities: SessionCapabilities(
                close: SessionCloseCapabilities(),
              ),
              auth: AgentAuthCapabilities(),
            ),
          )
          .onNewSession((_) {
            stderr.writeln('stdio agent created a session');
            return NewSessionResponse(sessionId: sessionId);
          })
          .onPrompt((context) async {
            await context.client.updateSession(
              SessionNotification(
                sessionId: sessionId,
                update: SessionUpdateAgentMessageChunk(
                  ContentChunk(
                    content: ContentBlockText(
                      TextContent(text: 'Hello across stdio.'),
                    ),
                  ),
                ),
              ),
            );
            return PromptResponse(stopReason: StopReason.endTurn);
          })
          .onCloseSession((_) => CloseSessionResponse());

  // stdout is exclusively the ACP NDJSON wire. Human logs use stderr.
  final connection = app.connect(AcpStdioTransport.connect());
  await connection.closed;
}
