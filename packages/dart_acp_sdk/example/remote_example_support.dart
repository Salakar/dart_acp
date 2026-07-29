import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:dart_acp_sdk/experimental/server.dart';

/// Builds the stable-v1 agent shared by the remote transport examples.
AcpAgentApp createRemoteExampleAgent({void Function(String event)? trace}) {
  final sessionId = SessionId('remote-example-session');
  var app =
      AcpAgentApp.v1(
            implementation: Implementation(
              name: 'remote-example-agent',
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
          .onNewSession((_) => NewSessionResponse(sessionId: sessionId))
          .onPrompt((context) async {
            await context.client.updateSession(
              SessionNotification(
                sessionId: sessionId,
                update: SessionUpdateAgentMessageChunk(
                  ContentChunk(
                    content: ContentBlockText(
                      TextContent(text: 'Hello over a remote ACP transport.'),
                    ),
                  ),
                ),
              ),
            );
            return PromptResponse(stopReason: StopReason.endTurn);
          })
          .onCloseSession((_) => CloseSessionResponse());
  if (trace != null) {
    app = app.onMessage((message, _) {
      trace('agent received ${message.method}');
      return AcpMiddlewareResult.pass;
    });
  }
  return app;
}

/// Builds one server-routing state connected to [agent] in process.
AcpServerConnectionState connectRemoteExampleAgent(
  AcpAgentApp agent,
  String connectionId,
) {
  final pair = acpInProcessTransportPair<Object?>();
  final application = agent.connect(pair.right);
  final state = AcpServerConnectionState(
    connectionId: connectionId,
    inbound: pair.left.writable,
    outbound: pair.left.readable,
  );
  unawaited(
    state.closed.whenComplete(() {
      application.close();
    }),
  );
  return state;
}

/// Builds the stable-v1 client shared by the remote transport examples.
AcpClientApp createRemoteExampleClient() {
  return AcpClientApp.v1(
    implementation: Implementation(
      name: 'remote-example-client',
      version: '1.0.0',
    ),
    capabilities: ClientCapabilities(
      fs: FileSystemCapabilities(readTextFile: false, writeTextFile: false),
      terminal: false,
    ),
  );
}

/// Runs one complete stable-v1 prompt over an application-compatible stream.
Future<String> runRemoteExamplePrompt(AcpDuplexStream<Object?> stream) async {
  final connection = createRemoteExampleClient().connect(stream);
  try {
    await _within(connection.lifecycle.ready, 'ACP initialization');
    final session = await connection.agent
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start()
        .then((value) => value)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('session/new timed out'),
        );
    try {
      final turn = await session
          .prompt(
            content: <ContentBlock>[
              ContentBlockText(TextContent(text: 'Say hello')),
            ],
          )
          .collectText()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('session/prompt timed out'),
          );
      return '${turn.response.stopReason.value}: ${turn.text}';
    } finally {
      await session.close().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('session/close timed out'),
      );
    }
  } finally {
    connection.close();
    await stream.writable.close();
  }
}

Future<T> _within<T>(Future<T> future, String operation) => future.timeout(
  const Duration(seconds: 10),
  onTimeout: () => throw TimeoutException('$operation timed out'),
);
