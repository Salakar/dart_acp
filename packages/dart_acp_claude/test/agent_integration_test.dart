import 'dart:async';

import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:dart_acp_sdk/experimental/v1_unstable.dart' as unstable;
import 'package:test/test.dart';

import 'helpers/fake_transport.dart';

final class _FakeFileSystem implements ClaudeAcpFileSystem {
  @override
  bool isAbsolute(String path) => path.startsWith('/');

  @override
  Future<bool> isDirectory(String path) async => path != '/missing';
}

void main() {
  test(
    'runs typed session, prompt, config, permission, and lifecycle',
    () async {
      final transports = <FakeClaudeTransport>[];
      final capturedOptions = <claude.ClaudeAgentOptions>[];
      final agent = ClaudeAcpAgent(
        options: ClaudeAcpOptions(
          tools: claude.ToolConfiguration.explicit(const <String>[
            'Read',
            'Agent',
          ]),
          fallbackModel: 'fallback',
          betas: const <claude.SdkBeta>[claude.SdkBeta.context1m],
          planModeInstructions: 'Plan carefully.',
          strictMcpConfig: true,
          inlineSettings: const <String, Object?>{'model': 'configured'},
          managedSettings: const <String, Object?>{'cleanupPeriodDays': 7},
          extraArguments: const <String, String?>{'future-flag': 'value'},
          maxBufferSize: 1024 * 1024,
          includeHookEvents: true,
          user: 'runner',
          title: 'ACP session',
          debug: true,
          debugFile: '/tmp/claude-debug.log',
          outputFormat: claude.JsonSchemaOutputFormat(const <String, Object?>{
            'type': 'object',
          }),
          initializeTimeout: const Duration(seconds: 75),
          controlRequestTimeout: const Duration(seconds: 30),
          agent: 'reviewer',
          agents: <String, claude.AgentDefinition>{
            'reviewer': claude.AgentDefinition(
              description: 'Reviews code',
              prompt: 'Review carefully',
            ),
          },
          agentProgressSummaries: true,
        ),
        idGenerator: () => '11111111-2222-4333-8444-555555555555',
        fileSystem: _FakeFileSystem(),
        environment: ClaudeAcpEnvironment(variables: const <String, String>{}),
        sessionInfoLookup: (sessionId, {directory}) => claude.SessionInfo(
          sessionId: sessionId,
          summary: 'Generated title',
          lastModified: DateTime.utc(2026, 7, 30),
          cwd: directory,
        ),
        clientFactory: (options) async {
          capturedOptions.add(options);
          final transport = FakeClaudeTransport();
          transport.onWrite = (frame) {
            transport.autoRespond(frame);
            if (frame['type'] == 'user') {
              final message = frame['message'];
              final content = message is Map<Object?, Object?>
                  ? message['content']
                  : null;
              final first = content is List<Object?> && content.isNotEmpty
                  ? content.first
                  : null;
              final text = first is Map<Object?, Object?>
                  ? first['text']
                  : null;
              if (text is String && text.startsWith('/goal ')) {
                transport.emitActiveGoal(
                  text == '/goal clear'
                      ? null
                      : text.substring('/goal '.length),
                );
              }
              transport.emitSuccessfulTurn();
            }
          };
          transports.add(transport);
          return claude.ClaudeAgentClient(
            options: options,
            transport: transport,
          );
        },
      );
      addTearDown(agent.dispose);

      final updates = <SessionNotification>[];
      final permissions = <RequestPermissionRequest>[];
      final elicitations = <CreateElicitationRequest>[];
      final completedElicitations = <CompleteElicitationNotification>[];
      final sdkMessages = <ClaudeSdkMessageNotification>[];
      var client = AcpClientApp.v1(
        implementation: Implementation(name: 'test', version: '1'),
        capabilities: ClientCapabilities.fromJson(<String, Object?>{
          'fs': <String, Object?>{
            'readTextFile': false,
            'writeTextFile': false,
          },
          'terminal': false,
          'elicitation': <String, Object?>{
            'form': <String, Object?>{},
            'url': <String, Object?>{},
          },
        }),
      );
      client = unstable.AcpV1UnstableClientApp(client).withV1UnstableMethods();
      client = client
          .onSessionUpdate((context) => updates.add(context.params))
          .onRequestPermission((context) {
            permissions.add(context.params);
            return RequestPermissionResponse.fromJson(<String, Object?>{
              'outcome': <String, Object?>{
                'outcome': 'selected',
                'optionId': 'allow-once',
              },
            });
          })
          .onCreateElicitation((context) {
            elicitations.add(context.params);
            return CreateElicitationResponse.fromJson(<String, Object?>{
              'action': 'accept',
              'content': <String, Object?>{
                'answer': 'yes',
                'question_0': 'VM',
                'choice': 'retry_fallback',
              },
            });
          })
          .onElicitationComplete(
            (context) => completedElicitations.add(context.params),
          )
          .onNotification(
            claudeSdkMessageMethod,
            (context) => sdkMessages.add(context.params),
          );

      final pair = await client.connectWith(agent.app);
      addTearDown(pair.close);
      final created = await pair.client.agent.createSession(
        NewSessionRequest(
          cwd: '/workspace',
          mcpServers: const <McpServer>[],
          additionalDirectories: const <String>['/extra'],
          meta: AcpJsonObject.fromObject(<String, Object?>{
            'claudeCode': <String, Object?>{
              'emitRawSDKMessages': true,
              'options': <String, Object?>{
                'additionalDirectories': <Object?>['/sdk-extra'],
                'model': 'session-model',
                'allowedTools': <Object?>['Bash'],
                'forwardSubagentText': false,
                'agentProgressSummaries': false,
                'settings': <String, Object?>{'model': 'session-configured'},
                'env': <String, Object?>{'SESSION_VALUE': 'present'},
                'title': 'Per-session title',
              },
            },
          }),
        ),
      );
      expect(created.sessionId.value, '11111111-2222-4333-8444-555555555555');
      expect(created.modes?.currentModeId.value, 'default');
      expect(created.configOptions, isNotEmpty);
      expect(
        pair.client.lifecycle.peerCapabilities.supports(
          'agentCapabilities._meta.goalControl',
        ),
        isTrue,
      );
      expect(capturedOptions.single.addDirectories, <String>[
        '/sdk-extra',
        '/extra',
      ]);
      expect(capturedOptions.single.model, 'session-model');
      expect(capturedOptions.single.allowedTools, <String>['Bash']);
      expect(capturedOptions.single.agent, 'reviewer');
      expect(capturedOptions.single.agents, contains('reviewer'));
      expect(capturedOptions.single.forwardSubagentText, isFalse);
      expect(capturedOptions.single.agentProgressSummaries, isFalse);
      expect(capturedOptions.single.tools, isA<claude.ExplicitTools>());
      expect(capturedOptions.single.fallbackModel, 'fallback');
      expect(capturedOptions.single.betas, <claude.SdkBeta>[
        claude.SdkBeta.context1m,
      ]);
      expect(capturedOptions.single.planModeInstructions, 'Plan carefully.');
      expect(capturedOptions.single.strictMcpConfig, isTrue);
      expect(
        capturedOptions.single.inlineSettings,
        containsPair('model', 'session-configured'),
      );
      expect(
        capturedOptions.single.environment,
        containsPair('SESSION_VALUE', 'present'),
      );
      expect(capturedOptions.single.managedSettings, isNotNull);
      expect(
        capturedOptions.single.extraArguments,
        containsPair('future-flag', 'value'),
      );
      expect(
        capturedOptions.single.extraArguments,
        contains('replay-user-messages'),
      );
      expect(capturedOptions.single.maxBufferSize, 1024 * 1024);
      expect(capturedOptions.single.includeHookEvents, isTrue);
      expect(capturedOptions.single.user, 'runner');
      expect(capturedOptions.single.title, 'Per-session title');
      expect(capturedOptions.single.debug, isTrue);
      expect(capturedOptions.single.debugFile, '/tmp/claude-debug.log');
      expect(capturedOptions.single.outputFormat, isNotNull);
      expect(
        capturedOptions.single.initializeTimeout,
        const Duration(seconds: 75),
      );
      expect(
        capturedOptions.single.controlRequestTimeout,
        const Duration(seconds: 30),
      );
      expect(capturedOptions.single.onElicitation, isNotNull);
      expect(capturedOptions.single.onUserDialog, isNotNull);
      expect(capturedOptions.single.supportedDialogKinds, <String>[
        claudeRefusalFallbackDialogKind,
      ]);
      expect(
        updates.any(
          (value) => value.update.discriminator == 'available_commands_update',
        ),
        isTrue,
      );
      expect(
        updates
            .where(
              (value) => value.update.discriminator == 'session_info_update',
            )
            .map((value) => value.update.toJson().toString()),
        contains(contains('goal: null')),
      );

      final beforeModeChange = updates.length;
      transports.single.emit(<String, Object?>{
        'type': 'system',
        'subtype': 'status',
        'permissionMode': 'acceptEdits',
        'uuid': 'mode-status',
        'session_id': created.sessionId.value,
      });
      for (
        var attempt = 0;
        !updates
                .skip(beforeModeChange)
                .any(
                  (value) =>
                      value.update.discriminator == 'current_mode_update',
                ) &&
            attempt < 20;
        attempt++
      ) {
        await Future<void>.delayed(const Duration(milliseconds: 1));
      }
      expect(
        updates
            .skip(beforeModeChange)
            .map((value) => value.update.toJson().toString())
            .join(),
        allOf(
          contains('current_mode_update'),
          contains('acceptEdits'),
          contains('config_option_update'),
        ),
      );

      final internalPlanHook =
          capturedOptions.single.hooks[claude.HookEvent.postToolUse]!.last;
      await internalPlanHook.hooks.single(
        claude.PostToolUseHookInput(
          sessionId: created.sessionId.value,
          transcriptPath: '/tmp/transcript.jsonl',
          cwd: '/workspace',
          toolName: 'EnterPlanMode',
          toolInput: const <String, Object?>{},
          toolResponse: 'Entered plan mode',
          toolUseId: 'enter-plan',
          raw: const <String, Object?>{},
        ),
        'enter-plan',
        claude.ControlCallbackContext(
          cancellation: claude.ControlCallbackCancellation(
            requestId: 'enter-plan-hook',
          ),
        ),
      );
      expect(
        updates
            .lastWhere(
              (value) => value.update.discriminator == 'current_mode_update',
            )
            .update
            .toJson(),
        containsPair('currentModeId', 'plan'),
      );

      final mcpResponse = transports.single.nextWriteWhere(
        (value) =>
            value['type'] == 'control_response' &&
            (value['response'] as Map?)?['request_id'] == 'mcp-elicit',
      );
      transports.single.emit(<String, Object?>{
        'type': 'control_request',
        'request_id': 'mcp-elicit',
        'request': <String, Object?>{
          'subtype': 'mcp_elicitation',
          'mode': 'form',
          'message': 'Choose',
          'requestedSchema': <String, Object?>{
            'type': 'object',
            'properties': <String, Object?>{
              'answer': <String, Object?>{'type': 'string'},
            },
          },
        },
      });
      expect(
        ((await mcpResponse)['response']! as Map)['response'],
        containsPair('action', 'accept'),
      );

      final questionResponse = transports.single.nextWriteWhere(
        (value) =>
            value['type'] == 'control_response' &&
            (value['response'] as Map?)?['request_id'] == 'ask',
      );
      transports.single.emit(<String, Object?>{
        'type': 'control_request',
        'request_id': 'ask',
        'request': <String, Object?>{
          'subtype': 'can_use_tool',
          'tool_name': 'AskUserQuestion',
          'tool_use_id': 'question-tool',
          'input': <String, Object?>{
            'questions': <Object?>[
              <String, Object?>{
                'question': 'Which target?',
                'options': <Object?>[
                  <String, Object?>{'label': 'VM'},
                ],
              },
            ],
          },
        },
      });
      final questionPayload =
          ((await questionResponse)['response']! as Map)['response']! as Map;
      expect(questionPayload, containsPair('behavior', 'allow'));
      expect(
        (questionPayload['updatedInput']! as Map)['answers'],
        <String, Object?>{'Which target?': 'VM'},
      );
      expect(elicitations, hasLength(2));

      final agentPermissionResponse = transports.single.nextWriteWhere(
        (value) =>
            value['type'] == 'control_response' &&
            (value['response'] as Map?)?['request_id'] == 'agent-permission',
      );
      transports.single.emit(<String, Object?>{
        'type': 'control_request',
        'request_id': 'agent-permission',
        'request': <String, Object?>{
          'subtype': 'can_use_tool',
          'tool_name': 'Agent',
          'tool_use_id': 'agent-tool',
          'input': <String, Object?>{
            'description': 'Explore',
            'prompt': 'Inspect the project',
          },
        },
      });
      expect(
        ((await agentPermissionResponse)['response']! as Map)['response'],
        containsPair('behavior', 'allow'),
      );
      expect(permissions.last.toolCall.toJson(), containsPair('kind', 'think'));

      final taskPermissionResponse = transports.single.nextWriteWhere(
        (value) =>
            value['type'] == 'control_response' &&
            (value['response'] as Map?)?['request_id'] == 'task-permission',
      );
      transports.single.emit(<String, Object?>{
        'type': 'control_request',
        'request_id': 'task-permission',
        'request': <String, Object?>{
          'subtype': 'can_use_tool',
          'tool_name': 'TaskCreate',
          'tool_use_id': 'task-tool',
          'input': <String, Object?>{'subject': 'Inspect parity'},
        },
      });
      expect(
        ((await taskPermissionResponse)['response']! as Map)['response'],
        containsPair('behavior', 'allow'),
      );
      expect(
        updates
            .where(
              (value) => value.update.toJson()['toolCallId'] == 'task-tool',
            )
            .single
            .update
            .discriminator,
        'tool_call',
      );
      transports.single.emit(<String, Object?>{
        'type': 'user',
        'uuid': 'task-result',
        'session_id': created.sessionId.value,
        'message': <String, Object?>{
          'role': 'user',
          'content': <Object?>[
            <String, Object?>{
              'type': 'tool_result',
              'tool_use_id': 'task-tool',
              'content': 'Permission denied',
              'is_error': true,
            },
          ],
        },
        'tool_result_meta': <Object?>[
          <String, Object?>{
            'id': 'task-tool',
            'non_execution_kind': 'user-rejected',
          },
        ],
      });
      for (
        var attempt = 0;
        !updates.any(
              (value) =>
                  value.update.toJson()['toolCallId'] == 'task-tool' &&
                  value.update.discriminator == 'tool_call_update',
            ) &&
            attempt < 20;
        attempt++
      ) {
        await Future<void>.delayed(const Duration(milliseconds: 1));
      }
      expect(
        updates
            .lastWhere(
              (value) =>
                  value.update.toJson()['toolCallId'] == 'task-tool' &&
                  value.update.discriminator == 'tool_call_update',
            )
            .update
            .toJson()
            .toString(),
        allOf(contains('failed'), contains('user-rejected')),
      );

      final response = await pair.client.agent.sendPrompt(
        PromptRequest(
          sessionId: created.sessionId,
          prompt: <ContentBlock>[ContentBlockText(TextContent(text: 'hello'))],
        ),
      );
      expect(response.stopReason, StopReason.endTurn);
      expect(completedElicitations.single.elicitationId.value, 'elicitation-1');
      expect(
        sdkMessages.map((value) => value.message.toObject()['type']),
        containsAll(<String>['assistant', 'user', 'system', 'result']),
      );
      expect(
        updates.map((value) => value.update.discriminator),
        containsAll(<String>[
          'agent_message_chunk',
          'tool_call',
          'tool_call_update',
          'usage_update',
          'session_info_update',
        ]),
      );

      final beforeBackground = updates.length;
      transports.single.emit(<String, Object?>{
        'type': 'assistant',
        'uuid': 'background-uuid',
        'session_id': created.sessionId.value,
        'message': <String, Object?>{
          'id': 'background-message',
          'model': 'claude-test',
          'content': <Object?>[
            <String, Object?>{'type': 'text', 'text': 'background output'},
          ],
        },
      });
      for (
        var attempt = 0;
        updates.length == beforeBackground && attempt < 20;
        attempt++
      ) {
        await Future<void>.delayed(const Duration(milliseconds: 1));
      }
      expect(
        updates
            .skip(beforeBackground)
            .map((value) => value.update.toJson().toString())
            .join(),
        contains('background output'),
      );

      await pair.client.agent.request(
        acpSessionGoalControlMethod,
        AcpGoalControlRequest(
          sessionId: created.sessionId,
          action: AcpGoalControlAction.update,
          objective: 'Ship Claude goals',
        ),
      );
      expect(
        updates
            .where(
              (value) => value.update.discriminator == 'session_info_update',
            )
            .map((value) => value.update.toJson().toString()),
        contains(contains('Ship Claude goals')),
      );
      await expectLater(
        pair.client.agent.request(
          acpSessionGoalControlMethod,
          AcpGoalControlRequest(
            sessionId: created.sessionId,
            action: AcpGoalControlAction.pause,
          ),
        ),
        throwsA(isA<JsonRpcRequestException>()),
      );
      await pair.client.agent.request(
        acpSessionGoalControlMethod,
        AcpGoalControlRequest(
          sessionId: created.sessionId,
          action: AcpGoalControlAction.clear,
        ),
      );
      expect(
        transports.single.written
            .where((frame) => frame['type'] == 'user')
            .map((frame) => frame.toString()),
        containsAll(<Matcher>[
          contains('/goal Ship Claude goals'),
          contains('/goal clear'),
        ]),
      );

      await pair.client.agent.setSessionMode(
        SetSessionModeRequest(
          sessionId: created.sessionId,
          modeId: SessionModeId('plan'),
        ),
      );
      final setConfig = await pair.client.agent.setSessionConfigOption(
        sessionSetConfigOptionMethod.paramsCodec.decode(<String, Object?>{
          'sessionId': created.sessionId.value,
          'configId': 'effort',
          'value': 'high',
        }),
      );
      expect(setConfig.configOptions, isNotEmpty);

      final providers = await pair.client.agent.request(
        unstable.providersListMethod,
        unstable.ListProvidersRequest(),
      );
      expect(providers.providers.single.providerId.value, 'main');
      await pair.client.agent.request(
        unstable.providersSetMethod,
        unstable.SetProviderRequest(
          providerId: unstable.ProviderId('main'),
          apiType: unstable.LlmProtocol.anthropic,
          baseUrl: 'https://gateway.example',
          headers: const <String, String>{'X-Key': 'secret'},
        ),
      );
      final configured = await pair.client.agent.request(
        unstable.providersListMethod,
        unstable.ListProvidersRequest(),
      );
      expect(configured.providers.single.current?.baseUrl, contains('gateway'));
      expect(
        configured.providers.single.toJson().toString(),
        isNot(contains('secret')),
      );

      var loggedOut = false;
      final logoutAgent = ClaudeAcpAgent(
        fileSystem: _FakeFileSystem(),
        logoutRunner: (options, environment) async {
          loggedOut = true;
          return 0;
        },
      );
      addTearDown(logoutAgent.dispose);
      final logoutPair = await AcpClientApp.v1(
        implementation: Implementation(name: 'test', version: '1'),
        capabilities: ClientCapabilities.fromJson(<String, Object?>{
          'fs': <String, Object?>{
            'readTextFile': false,
            'writeTextFile': false,
          },
          'terminal': false,
        }),
      ).connectWith(logoutAgent.app);
      addTearDown(logoutPair.close);
      await logoutPair.client.agent.logout(LogoutRequest());
      expect(loggedOut, isTrue);

      await pair.client.agent.closeSession(
        CloseSessionRequest(sessionId: created.sessionId),
      );
      expect(agent.sessionCount, 0);
      expect(transports.single.isReady, isFalse);
    },
  );

  test(
    'rejects invalid working directories before creating a client',
    () async {
      final agent = ClaudeAcpAgent(
        fileSystem: _FakeFileSystem(),
        clientFactory: (_) async => throw StateError('must not be called'),
      );
      addTearDown(agent.dispose);
      final client = AcpClientApp.v1(
        implementation: Implementation(name: 'test', version: '1'),
        capabilities: ClientCapabilities.fromJson(<String, Object?>{
          'fs': <String, Object?>{
            'readTextFile': false,
            'writeTextFile': false,
          },
          'terminal': false,
        }),
      );
      final pair = await client.connectWith(agent.app);
      addTearDown(pair.close);
      await expectLater(
        pair.client.agent.createSession(
          NewSessionRequest(cwd: 'relative', mcpServers: const <McpServer>[]),
        ),
        throwsA(isA<JsonRpcRequestException>()),
      );
    },
  );

  test('supports resume through per-session Claude metadata', () async {
    claude.ClaudeAgentOptions? captured;
    final agent = ClaudeAcpAgent(
      fileSystem: _FakeFileSystem(),
      sessionInfoLookup: (sessionId, {directory}) => claude.SessionInfo(
        sessionId: sessionId,
        summary: 'Existing session',
        lastModified: DateTime.utc(2026, 7, 30),
        cwd: directory,
      ),
      clientFactory: (options) async {
        captured = options;
        final transport = FakeClaudeTransport();
        transport.onWrite = transport.autoRespond;
        return claude.ClaudeAgentClient(options: options, transport: transport);
      },
    );
    addTearDown(agent.dispose);
    final client = AcpClientApp.v1(
      implementation: Implementation(name: 'test', version: '1'),
      capabilities: ClientCapabilities.fromJson(<String, Object?>{
        'fs': <String, Object?>{'readTextFile': false, 'writeTextFile': false},
        'terminal': false,
      }),
    );
    final pair = await client.connectWith(agent.app);
    addTearDown(pair.close);

    final created = await pair.client.agent.createSession(
      NewSessionRequest(
        cwd: '/workspace',
        mcpServers: const <McpServer>[],
        meta: AcpJsonObject.fromObject(<String, Object?>{
          'claudeCode': <String, Object?>{
            'options': <String, Object?>{'resume': 'existing-session'},
          },
        }),
      ),
    );

    expect(created.sessionId.value, 'existing-session');
    expect(captured!.resume, 'existing-session');
    expect(captured!.sessionId, isNull);
  });
}
