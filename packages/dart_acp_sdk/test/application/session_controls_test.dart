import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('session controls use inventories returned by session/new', () async {
    final sessionId = SessionId('session-1');
    final modeId = SessionModeId('code');
    final configId = SessionConfigId('verbose');
    final config = SessionConfigOptionBoolean(
      SessionConfigBoolean(currentValue: false),
      id: configId,
      name: 'Verbose output',
    );
    var modeCalls = 0;
    var configCalls = 0;
    final agent =
        AcpAgentApp.v1(
              implementation: Implementation(name: 'agent', version: '1'),
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
            )
            .onNewSession(
              (_) => NewSessionResponse(
                sessionId: sessionId,
                modes: SessionModeState(
                  currentModeId: modeId,
                  availableModes: <SessionMode>[
                    SessionMode(id: modeId, name: 'Code'),
                  ],
                ),
                configOptions: <SessionConfigOption>[config],
              ),
            )
            .onSetSessionMode((context) {
              modeCalls++;
              expect(context.params.modeId, modeId);
              return SetSessionModeResponse();
            })
            .onSetSessionConfigOption((context) {
              configCalls++;
              expect(context.params.configId, configId);
              return SetSessionConfigOptionResponse(
                configOptions: <SessionConfigOption>[config],
              );
            });
    final client = AcpClientApp.v1(
      implementation: Implementation(name: 'client', version: '1'),
      capabilities: ClientCapabilities(
        fs: FileSystemCapabilities(readTextFile: false, writeTextFile: false),
        terminal: false,
      ),
    );
    final pair = await client.connectWith(agent);
    final session = await pair.client.agent.sessions
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start();

    await session.setMode(modeId);
    await session.setConfigOption(
      SetSessionConfigOptionRequest(
        sessionId: sessionId,
        configId: configId,
        variant: SetSessionConfigOptionRequestBoolean(value: true),
      ),
    );

    expect(modeCalls, 1);
    expect(configCalls, 1);
    await pair.close();
  });

  test('session controls reject unadvertised IDs locally', () async {
    final sessionId = SessionId('session-1');
    final agent = AcpAgentApp.v1(
      implementation: Implementation(name: 'agent', version: '1'),
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
    ).onNewSession((_) => NewSessionResponse(sessionId: sessionId));
    final client = AcpClientApp.v1(
      implementation: Implementation(name: 'client', version: '1'),
      capabilities: ClientCapabilities(
        fs: FileSystemCapabilities(readTextFile: false, writeTextFile: false),
        terminal: false,
      ),
    );
    final pair = await client.connectWith(agent);
    final session = await pair.client.agent.sessions
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start();

    expect(
      () => session.setMode(SessionModeId('missing')),
      throwsArgumentError,
    );
    expect(
      () => session.setConfigOption(
        SetSessionConfigOptionRequest(
          sessionId: sessionId,
          configId: SessionConfigId('missing'),
          variant: SetSessionConfigOptionRequestBoolean(value: true),
        ),
      ),
      throwsArgumentError,
    );
    await pair.close();
  });
}
