import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:dart_acp_sdk/experimental/v1_unstable.dart' as unstable;
import 'package:test/test.dart';

import 'helpers/fake_transport.dart';

final class _Directories implements ClaudeAcpFileSystem {
  @override
  bool isAbsolute(String path) => path.startsWith('/');

  @override
  Future<bool> isDirectory(String path) async => path != '/missing';
}

AcpClientApp _client({
  required void Function(unstable.InitializeResponse response) initialized,
}) {
  final initialization =
      AcpClientInitialization<
        unstable.InitializeRequest,
        unstable.InitializeResponse
      >(
        method: unstable.initializeMethod,
        request: unstable.InitializeRequest.fromJson(<String, Object?>{
          'protocolVersion': 1,
          'clientCapabilities': <String, Object?>{
            'fs': <String, Object?>{
              'readTextFile': false,
              'writeTextFile': false,
            },
            'terminal': true,
            'auth': <String, Object?>{
              'terminal': true,
              '_meta': <String, Object?>{'gateway': true},
            },
            'elicitation': <String, Object?>{
              'form': <String, Object?>{},
              'url': <String, Object?>{},
            },
          },
          'clientInfo': <String, Object?>{
            'name': 'lifecycle-test',
            'version': '1',
          },
        }),
        peerCapabilities: (response) {
          initialized(response);
          return AcpPeerCapabilities(
            AcpJsonObject.fromObject(<String, Object?>{
              'agentCapabilities': <String, Object?>{
                ...response.agentCapabilities.toJson(),
                if (response.authMethods.isNotEmpty)
                  'authMethods': <String, Object?>{},
              },
            }),
          );
        },
        peerImplementation: (response) => response.agentInfo?.toAcpJson(),
        peerAuthMethods: (response) => <AuthMethod>[
          for (final method in response.authMethods)
            AuthMethod.fromJson(method.toJson()! as Map<String, Object?>),
        ],
      );
  return unstable.AcpV1UnstableClientApp(
    AcpClientApp(initialization: initialization),
  ).withV1UnstableMethods();
}

void main() {
  test(
    'negotiates auth and manages resume, load, fork, and providers',
    () async {
      final ids = <String>[
        '11111111-2222-4333-8444-555555555555',
        '66666666-7777-4888-8999-aaaaaaaaaaaa',
      ];
      var idIndex = 0;
      final transports = <FakeClaudeTransport>[];
      final captured = <claude.ClaudeAgentOptions>[];
      final agent = ClaudeAcpAgent(
        idGenerator: () => ids[idIndex++],
        fileSystem: _Directories(),
        environment: ClaudeAcpEnvironment(variables: const <String, String>{}),
        logoutRunner: (_, _) async => 0,
        sessionDelete: (_, {directory}) {},
        sessionInfoLookup: (sessionId, {directory}) => claude.SessionInfo(
          sessionId: sessionId,
          summary: 'Persisted title',
          lastModified: DateTime.utc(2026, 7, 30),
          cwd: directory,
        ),
        settingsResolver: (cwd, environment) async =>
            claude.ClaudeResolvedSettings(<String, Object?>{
              'model': 'claude-test',
              'permissions': <String, Object?>{'defaultMode': 'acceptEdits'},
              'env': <String, Object?>{'POLICY': 'enabled'},
              'availableModels': <Object?>['claude-test'],
            }),
        clientFactory: (options) async {
          captured.add(options);
          final transport = FakeClaudeTransport()..onWrite = (_) {};
          transport.onWrite = transport.autoRespond;
          transports.add(transport);
          return claude.ClaudeAgentClient(
            options: options,
            transport: transport,
          );
        },
      );
      addTearDown(agent.dispose);

      unstable.InitializeResponse? initialization;
      late final AcpDirectConnectionPair pair;
      try {
        pair = await _client(
          initialized: (value) => initialization = value,
        ).connectWith(agent.app);
      } on JsonRpcRequestException catch (error) {
        fail('Initialization failed: ${error.error.toJson()}');
      }
      addTearDown(pair.close);
      expect(initialization?.agentCapabilities.providers, isNotNull);
      expect(
        pair.client.lifecycle.peerAuthMethods.map(
          (method) => (method.toJson()! as Map<Object?, Object?>)['id'],
        ),
        containsAll(<Object?>[
          'claude-ai-login',
          'console-login',
          'gateway',
          'gateway-bedrock',
        ]),
      );

      await pair.client.agent.authenticate(
        AuthenticateRequest.fromJson(<String, Object?>{
          'methodId': 'gateway',
          '_meta': <String, Object?>{
            'gateway': <String, Object?>{
              'baseUrl': 'https://gateway.example',
              'headers': <String, Object?>{'X-Key': 'secret'},
            },
          },
        }),
      );
      final providers = await pair.client.agent.request(
        unstable.providersListMethod,
        unstable.ListProvidersRequest(),
      );
      expect(providers.providers.single.current?.baseUrl, contains('gateway'));

      final created = await pair.client.agent.createSession(
        NewSessionRequest(
          cwd: '/workspace',
          mcpServers: const <McpServer>[],
          additionalDirectories: const <String>['/extra'],
        ),
      );
      expect(created.modes?.currentModeId.value, 'acceptEdits');
      expect(captured.single.model, 'claude-test');
      expect(captured.single.environment, containsPair('POLICY', 'enabled'));
      expect(
        captured.single.environment['ANTHROPIC_BASE_URL'],
        contains('gateway'),
      );

      await pair.client.agent.resumeSession(
        ResumeSessionRequest(
          sessionId: created.sessionId,
          cwd: '/workspace',
          additionalDirectories: const <String>['/extra'],
        ),
      );
      expect(
        captured,
        hasLength(1),
        reason: 'unchanged resume reuses the client',
      );

      await pair.client.agent.loadSession(
        LoadSessionRequest(
          sessionId: created.sessionId,
          cwd: '/workspace',
          mcpServers: const <McpServer>[],
          additionalDirectories: const <String>['/extra'],
        ),
      );
      expect(captured, hasLength(1));

      await pair.client.agent.resumeSession(
        ResumeSessionRequest(
          sessionId: created.sessionId,
          cwd: '/other',
          additionalDirectories: const <String>['/extra'],
        ),
      );
      expect(captured, hasLength(2));
      expect(transports.first.isReady, isFalse);

      await pair.client.agent.setSessionMode(
        SetSessionModeRequest(
          sessionId: created.sessionId,
          modeId: SessionModeId('plan'),
        ),
      );
      await expectLater(
        pair.client.agent.setSessionMode(
          SetSessionModeRequest(
            sessionId: created.sessionId,
            modeId: SessionModeId('invalid'),
          ),
        ),
        throwsA(isA<JsonRpcRequestException>()),
      );
      await expectLater(
        pair.client.agent.setSessionConfigOption(
          sessionSetConfigOptionMethod.paramsCodec.decode(<String, Object?>{
            'sessionId': created.sessionId.value,
            'configId': 'missing',
            'value': 'value',
          }),
        ),
        throwsA(isA<JsonRpcRequestException>()),
      );

      final forked = await pair.client.agent.request(
        unstable.sessionForkMethod,
        unstable.ForkSessionRequest.fromJson(<String, Object?>{
          'sessionId': created.sessionId.value,
          'cwd': '/other',
          'mcpServers': <Object?>[],
          'additionalDirectories': <Object?>['/extra'],
        }),
      );
      expect(forked.sessionId.value, ids[1]);
      expect(captured, hasLength(3));

      await pair.client.agent.closeSession(
        CloseSessionRequest(sessionId: SessionId(forked.sessionId.value)),
      );
      await expectLater(
        pair.client.agent.closeSession(
          CloseSessionRequest(sessionId: SessionId(forked.sessionId.value)),
        ),
        throwsA(isA<JsonRpcRequestException>()),
      );
      await pair.client.agent.deleteSession(
        DeleteSessionRequest(sessionId: created.sessionId),
      );
      expect(agent.sessionCount, 0);

      await pair.client.agent.logout(LogoutRequest());
      final loggedOut = await pair.client.agent.request(
        unstable.providersListMethod,
        unstable.ListProvidersRequest(),
      );
      expect(loggedOut.providers.single.current, isNull);
    },
  );

  test('rejects invalid gateway and missing persisted sessions', () async {
    final agent = ClaudeAcpAgent(
      fileSystem: _Directories(),
      environment: ClaudeAcpEnvironment(variables: const <String, String>{}),
      sessionInfoLookup: (_, {directory}) => null,
      settingsResolver: (_, _) async =>
          claude.ClaudeResolvedSettings(const <String, Object?>{}),
      clientFactory: (_) async => throw StateError('must not connect'),
    );
    addTearDown(agent.dispose);
    final pair = await _client(initialized: (_) {}).connectWith(agent.app);
    addTearDown(pair.close);

    await expectLater(
      pair.client.agent.authenticate(
        AuthenticateRequest.fromJson(<String, Object?>{
          'methodId': 'gateway',
          '_meta': <String, Object?>{
            'gateway': <String, Object?>{
              'baseUrl': 'not-a-url',
              'headers': <String, Object?>{},
            },
          },
        }),
      ),
      throwsA(isA<JsonRpcRequestException>()),
    );
    await expectLater(
      pair.client.agent.resumeSession(
        ResumeSessionRequest(
          sessionId: SessionId('11111111-2222-4333-8444-555555555555'),
          cwd: '/workspace',
        ),
      ),
      throwsA(isA<JsonRpcRequestException>()),
    );
  });
}
