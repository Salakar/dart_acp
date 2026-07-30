import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('session controls keep inventories live after responses', () async {
    final sessionId = SessionId('session-1');
    final modeId = SessionModeId('code');
    final reviewModeId = SessionModeId('review');
    final configId = SessionConfigId('verbose');
    final extraConfigId = SessionConfigId('show-cost');
    final initialConfig = SessionConfigOptionBoolean(
      SessionConfigBoolean(currentValue: false),
      id: configId,
      name: 'Verbose output',
    );
    final updatedConfig = SessionConfigOptionBoolean(
      SessionConfigBoolean(currentValue: true),
      id: configId,
      name: 'Verbose output',
    );
    final extraConfig = SessionConfigOptionBoolean(
      SessionConfigBoolean(currentValue: false),
      id: extraConfigId,
      name: 'Show cost',
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
                    SessionMode(id: reviewModeId, name: 'Review'),
                  ],
                ),
                configOptions: <SessionConfigOption>[initialConfig],
              ),
            )
            .onSetSessionMode((context) {
              modeCalls++;
              expect(context.params.modeId, reviewModeId);
              return SetSessionModeResponse();
            })
            .onSetSessionConfigOption((context) {
              configCalls++;
              if (configCalls == 1) {
                expect(context.params.configId, configId);
              } else {
                expect(context.params.configId, extraConfigId);
              }
              return SetSessionConfigOptionResponse(
                configOptions: <SessionConfigOption>[
                  updatedConfig,
                  extraConfig,
                ],
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

    await session.setMode(reviewModeId);
    await session.setConfigOption(
      SetSessionConfigOptionRequest(
        sessionId: sessionId,
        configId: configId,
        variant: SetSessionConfigOptionRequestBoolean(value: true),
      ),
    );
    await session.setConfigOption(
      SetSessionConfigOptionRequest(
        sessionId: sessionId,
        configId: extraConfigId,
        variant: SetSessionConfigOptionRequestBoolean(value: true),
      ),
    );

    expect(modeCalls, 1);
    expect(session.modes?.currentModeId, reviewModeId);
    expect(configCalls, 2);
    expect(session.configOptions, hasLength(2));
    expect(
      (session.configOptions!.first as SessionConfigOptionBoolean)
          .value
          .currentValue,
      isTrue,
    );
    await pair.close();
  });

  test(
    'session updates refresh inventories without an event listener',
    () async {
      final sessionId = SessionId('session-1');
      final codeModeId = SessionModeId('code');
      final reviewModeId = SessionModeId('review');
      final initialConfigId = SessionConfigId('verbose');
      final addedConfigId = SessionConfigId('show-cost');
      late AcpAgentContext peer;
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
              .onNewSession((context) async {
                peer = context.client;
                await peer.updateSession(
                  SessionNotification(
                    sessionId: sessionId,
                    update: SessionUpdateCurrentModeUpdate(
                      CurrentModeUpdate(currentModeId: reviewModeId),
                    ),
                  ),
                );
                await peer.updateSession(
                  SessionNotification(
                    sessionId: sessionId,
                    update: SessionUpdateConfigOptionUpdate(
                      ConfigOptionUpdate(
                        configOptions: <SessionConfigOption>[
                          SessionConfigOptionBoolean(
                            SessionConfigBoolean(currentValue: false),
                            id: addedConfigId,
                            name: 'Show cost',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                return NewSessionResponse(
                  sessionId: sessionId,
                  modes: SessionModeState(
                    currentModeId: codeModeId,
                    availableModes: <SessionMode>[
                      SessionMode(id: codeModeId, name: 'Code'),
                      SessionMode(id: reviewModeId, name: 'Review'),
                    ],
                  ),
                  configOptions: <SessionConfigOption>[
                    SessionConfigOptionBoolean(
                      SessionConfigBoolean(currentValue: false),
                      id: initialConfigId,
                      name: 'Verbose output',
                    ),
                  ],
                );
              })
              .onSetSessionConfigOption((context) {
                configCalls++;
                expect(context.params.configId, addedConfigId);
                return SetSessionConfigOptionResponse(
                  configOptions: <SessionConfigOption>[
                    SessionConfigOptionBoolean(
                      SessionConfigBoolean(currentValue: true),
                      id: addedConfigId,
                      name: 'Show cost',
                    ),
                  ],
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

      expect(session.modes?.currentModeId, reviewModeId);
      expect(session.configOptions?.map(_configId), <SessionConfigId>[
        addedConfigId,
      ]);

      await peer.updateSession(
        SessionNotification(
          sessionId: sessionId,
          update: SessionUpdateCurrentModeUpdate(
            CurrentModeUpdate(currentModeId: codeModeId),
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(session.modes?.currentModeId, codeModeId);

      await session.setConfigOption(
        SetSessionConfigOptionRequest(
          sessionId: sessionId,
          configId: addedConfigId,
          variant: SetSessionConfigOptionRequestBoolean(value: true),
        ),
      );
      expect(configCalls, 1);
      await pair.close();
    },
  );

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

SessionConfigId _configId(SessionConfigOption option) => switch (option) {
  SessionConfigOptionSelect(:final id) => id,
  SessionConfigOptionBoolean(:final id) => id,
};
