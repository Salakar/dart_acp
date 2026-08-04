import 'dart:async';
import 'dart:math';

import 'package:dart_acp_codex/dart_acp_codex.dart';
import 'package:dart_acp_sdk/experimental/v1_unstable.dart' as unstable;
import 'package:test/test.dart';

import 'helpers/fake_backend.dart';

final class _Harness {
  _Harness({
    required this.backend,
    required this.agent,
    required this.pair,
    required this.updates,
    required this.permissions,
    required this.elicitations,
    required this.completedElicitations,
  });

  final FakeCodexBackend backend;
  final CodexAgent agent;
  final AcpDirectConnectionPair pair;
  final List<SessionNotification> updates;
  final List<RequestPermissionRequest> permissions;
  final List<CreateElicitationRequest> elicitations;
  final List<String> completedElicitations;

  Future<void> close() async {
    await pair.close();
    await backend.close();
  }
}

Future<_Harness> _connect({
  CodexAdapterOptions? options,
  void Function(FakeCodexBackend backend)? configureBackend,
  String? permissionOption,
  bool handlePermissions = true,
  bool handleElicitations = true,
  bool advertiseElicitations = true,
  String elicitationAction = 'accept',
  Map<String, Object?> elicitationContent = const <String, Object?>{
    'answer': 'accepted',
  },
  FutureOr<CreateElicitationResponse> Function(CreateElicitationRequest)?
  elicitationResponder,
}) async {
  final backend = FakeCodexBackend();
  configureBackend?.call(backend);
  final agent = CodexAgent(
    backend: backend,
    options:
        options ?? CodexAdapterOptions(environment: const <String, String>{}),
  );
  final updates = <SessionNotification>[];
  final permissions = <RequestPermissionRequest>[];
  final elicitations = <CreateElicitationRequest>[];
  final completedElicitations = <String>[];
  var client = AcpClientApp.v1(
    implementation: Implementation(name: 'test-client', version: '1.0.0'),
    capabilities: ClientCapabilities.fromJson(<String, Object?>{
      'fs': <String, Object?>{'readTextFile': true, 'writeTextFile': true},
      'terminal': true,
      if (advertiseElicitations)
        'elicitation': <String, Object?>{
          'form': <String, Object?>{},
          'url': <String, Object?>{},
        },
    }),
  );
  client = unstable.AcpV1UnstableClientApp(client).withV1UnstableMethods();
  client = client.onSessionUpdate((context) {
    updates.add(context.params);
  });
  if (handlePermissions) {
    client = client.onRequestPermission((context) {
      permissions.add(context.params);
      final selectedId =
          permissionOption ??
          (context.params.options
                      .where(
                        (option) => option.optionId.value.contains('for-turn'),
                      )
                      .firstOrNull ??
                  context.params.options.first)
              .optionId
              .value;
      return RequestPermissionResponse(
        outcome: RequestPermissionOutcomeSelected(
          SelectedPermissionOutcome(optionId: PermissionOptionId(selectedId)),
        ),
      );
    });
  }
  if (handleElicitations) {
    client = client.onCreateElicitation((context) {
      elicitations.add(context.params);
      final responder = elicitationResponder;
      if (responder != null) {
        return responder(context.params);
      }
      return CreateElicitationResponse.fromJson(<String, Object?>{
        'action': elicitationAction,
        if (elicitationAction == 'accept') 'content': elicitationContent,
      });
    });
  }
  client = client.onElicitationComplete((context) {
    completedElicitations.add(context.params.elicitationId.value);
  });
  final pair = await client.connectWith(agent.app);
  while (backend.count('model/list') == 0) {
    await _flush();
  }
  return _Harness(
    backend: backend,
    agent: agent,
    pair: pair,
    updates: updates,
    permissions: permissions,
    elicitations: elicitations,
    completedElicitations: completedElicitations,
  );
}

P _params<P, R>(AcpMethodDescriptor<P, R> method, Map<String, Object?> json) =>
    method.paramsCodec.decode(json);

ContentBlock _text(String value) => ContentBlockText(TextContent(text: value));

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  test('initializes, authenticates, and configures providers', () async {
    final harness = await _connect(
      options: CodexAdapterOptions(
        environment: const <String, String>{
          'CODEX_API_KEY': 'test-secret',
          'NO_BROWSER': '1',
        },
      ),
    );
    addTearDown(harness.close);

    expect(harness.backend.count('initialize'), 1);
    expect(harness.backend.count('model/list'), 1);
    expect(
      harness.pair.client.lifecycle.peerCapabilities.supports(
        'agentCapabilities._meta.goalControl.supported',
      ),
      isTrue,
    );
    expect(
      harness.backend.calls.where(
        (call) => call.method == 'initialized' && call.isNotification,
      ),
      hasLength(1),
    );
    expect(
      harness.pair.client.lifecycle.peerAuthMethods.map(
        (method) => (method as AuthMethodAgentVariant).value.id.value,
      ),
      <String>['api-key', 'gateway'],
    );

    await harness.pair.client.agent.authenticate(
      AuthenticateRequest(methodId: AuthMethodId('api-key')),
    );
    final login = harness.backend.lastCall('account/login/start').params;
    expect(login.requireString('type'), 'apiKey');
    expect(login.requireString('apiKey'), 'test-secret');

    await harness.pair.client.agent.authenticate(
      AuthenticateRequest(
        methodId: AuthMethodId('gateway'),
        meta: AcpJsonObject.fromObject(<String, Object?>{
          'gateway': <String, Object?>{
            'baseUrl': 'https://gateway.example.test/openai',
            'headers': <String, Object?>{'Authorization': 'Bearer secret'},
            'providerName': 'Test gateway',
          },
        }),
      ),
    );

    final listed = await harness.pair.client.agent.request(
      unstable.providersListMethod,
      unstable.ListProvidersRequest(),
    );
    expect(listed.providers.single.providerId.value, 'custom-gateway');
    expect(
      listed.providers.single.current?.baseUrl,
      contains('gateway.example'),
    );
    expect(
      listed.providers.single.toJson().toString(),
      isNot(contains('secret')),
    );

    await harness.pair.client.agent.request(
      unstable.providersSetMethod,
      unstable.SetProviderRequest(
        providerId: unstable.ProviderId('custom-gateway'),
        apiType: unstable.LlmProtocol.openai,
        baseUrl: 'https://new-gateway.example.test/v1',
        headers: const <String, String>{'X-Key': 'private'},
      ),
    );
    final configured = await harness.pair.client.agent.request(
      unstable.providersListMethod,
      unstable.ListProvidersRequest(),
    );
    expect(
      configured.providers.single.current?.baseUrl,
      'https://new-gateway.example.test/v1',
    );
    expect(
      configured.providers.single.toJson().toString(),
      isNot(contains('private')),
    );

    await expectLater(
      harness.pair.client.agent.request(
        unstable.providersSetMethod,
        unstable.SetProviderRequest(
          providerId: unstable.ProviderId('unknown'),
          apiType: unstable.LlmProtocol.openai,
          baseUrl: 'https://example.test',
        ),
      ),
      throwsA(isA<JsonRpcRequestException>()),
    );
    await expectLater(
      harness.pair.client.agent.request(
        unstable.providersSetMethod,
        unstable.SetProviderRequest(
          providerId: unstable.ProviderId('custom-gateway'),
          apiType: unstable.LlmProtocol.anthropic,
          baseUrl: 'https://example.test',
        ),
      ),
      throwsA(isA<JsonRpcRequestException>()),
    );
    await expectLater(
      harness.pair.client.agent.request(
        unstable.providersSetMethod,
        unstable.SetProviderRequest(
          providerId: unstable.ProviderId('custom-gateway'),
          apiType: unstable.LlmProtocol.openai,
          baseUrl: 'relative',
        ),
      ),
      throwsA(isA<JsonRpcRequestException>()),
    );

    await harness.pair.client.agent.request(
      unstable.providersDisableMethod,
      unstable.DisableProviderRequest(
        providerId: unstable.ProviderId('not-known'),
      ),
    );
    expect(
      (await harness.pair.client.agent.request(
        unstable.providersListMethod,
        unstable.ListProvidersRequest(),
      )).providers.single.current,
      isNotNull,
    );
    await harness.pair.client.agent.request(
      unstable.providersDisableMethod,
      unstable.DisableProviderRequest(
        providerId: unstable.ProviderId('custom-gateway'),
      ),
    );
    expect(
      (await harness.pair.client.agent.request(
        unstable.providersListMethod,
        unstable.ListProvidersRequest(),
      )).providers.single.current,
      isNull,
    );

    await harness.pair.client.agent.logout(LogoutRequest());
    expect(harness.backend.count('account/logout'), 1);
  });

  test('runs session lifecycle, configuration, commands, and turns', () async {
    final harness = await _connect();
    addTearDown(harness.close);
    harness.backend.on(
      'thread/list',
      (_) => CodexJsonObject.from(<String, Object?>{
        'data': <Object?>[
          <String, Object?>{
            'id': 'listed',
            'cwd': '/workspace',
            'name': 'Listed thread',
            'updatedAt': 12,
          },
          <String, Object?>{'id': 'ignored-without-cwd'},
        ],
        'nextCursor': 'next',
      }),
    );

    final listed = await harness.pair.client.agent.listSessions(
      ListSessionsRequest(cwd: '/workspace'),
    );
    expect(listed.sessions.single.sessionId.value, 'listed');
    expect(listed.nextCursor, 'next');

    final created = await harness.pair.client.agent.createSession(
      NewSessionRequest(
        cwd: '/workspace',
        mcpServers: const <McpServer>[],
        additionalDirectories: const <String>['/extra'],
      ),
    );
    final sessionId = created.sessionId;
    expect(sessionId.value, 'thread-1');
    expect(created.modes?.currentModeId.value, 'default');
    expect(created.configOptions, isNotEmpty);
    await _flush();
    expect(
      harness.updates.any(
        (update) =>
            update.sessionId == sessionId &&
            update.update.discriminator == 'available_commands_update',
      ),
      isTrue,
    );
    expect(
      harness.updates
          .where(
            (update) =>
                update.sessionId == sessionId &&
                update.update.discriminator == 'session_info_update',
          )
          .map((update) => update.update.toJson().toString()),
      contains(contains('Ship it')),
    );

    await harness.pair.client.agent.setSessionMode(
      SetSessionModeRequest(
        sessionId: sessionId,
        modeId: SessionModeId('plan'),
      ),
    );
    expect(
      harness.backend.lastCall('thread/settings/update').params.toJson(),
      containsPair('threadId', sessionId.value),
    );
    await expectLater(
      harness.pair.client.agent.setSessionMode(
        SetSessionModeRequest(
          sessionId: sessionId,
          modeId: SessionModeId('missing'),
        ),
      ),
      throwsA(isA<JsonRpcRequestException>()),
    );

    for (final entry in <(String, Object?)>[
      ('agent-mode', 'read-only'),
      ('model', 'gpt-test'),
      ('reasoning-effort', 'high'),
      ('fast-mode', true),
    ]) {
      final response = await harness.pair.client.agent.setSessionConfigOption(
        _params(sessionSetConfigOptionMethod, <String, Object?>{
          'sessionId': sessionId.value,
          'configId': entry.$1,
          'value': entry.$2,
          if (entry.$2 is bool) 'type': 'boolean',
        }),
      );
      expect(response.configOptions, isNotEmpty);
    }
    await expectLater(
      harness.pair.client.agent.setSessionConfigOption(
        _params(sessionSetConfigOptionMethod, <String, Object?>{
          'sessionId': sessionId.value,
          'configId': 'missing',
          'value': 'value',
        }),
      ),
      throwsA(isA<JsonRpcRequestException>()),
    );

    harness.backend.emit('thread/tokenUsage/updated', <String, Object?>{
      'tokenUsage': <String, Object?>{
        'totalTokens': 1200,
        'modelContextWindow': 128000,
      },
    }, threadId: sessionId.value);
    harness.backend.emit('thread/goal/updated', <String, Object?>{
      'goal': <String, Object?>{
        'objective': 'Release adapter',
        'status': 'active',
      },
    }, threadId: sessionId.value);
    harness.backend.emit('account/rateLimits/updated', <String, Object?>{
      'rateLimitsByLimitId': <String, Object?>{
        'codex': <String, Object?>{
          'primary': <String, Object?>{'usedPercent': 25},
        },
      },
    });
    await _flush();

    for (final command in <String>[
      '/status',
      '/mcp',
      '/skills',
      '/compact',
      '/plan off',
      '/review instructions',
      '/review-branch main',
      '/review-commit abc123',
      '/goal',
      '/goal New objective',
      '/goal pause',
      '/goal resume',
      '/goal clear',
      '/logout',
    ]) {
      final response = await harness.pair.client.agent.sendPrompt(
        PromptRequest(
          sessionId: sessionId,
          prompt: <ContentBlock>[_text(command)],
        ),
      );
      expect(response.stopReason, StopReason.endTurn);
    }
    expect(harness.backend.count('skills/list'), 1);
    expect(harness.backend.count('review/start'), 3);
    expect(
      harness.updates
          .map((update) => update.update.toJson().toString())
          .join('\n'),
      allOf(
        contains('1200 / 128000 tokens'),
        contains('Release adapter'),
        contains('75% remaining'),
      ),
    );

    final turnFuture = harness.pair.client.agent.sendPrompt(
      PromptRequest(
        sessionId: sessionId,
        prompt: <ContentBlock>[
          _text('<hidden context>ignore me</hidden context>\nhello'),
        ],
        meta: AcpJsonObject.fromObject(<String, Object?>{
          codexThreadTitlePromptMetaKey: 'hello',
        }),
      ),
    );
    await _flush();
    expect(harness.backend.count('turn/start'), 1);
    expect(harness.backend.count('thread/name/set'), 1);
    expect(
      harness.backend.lastCall('thread/name/set').params.toJson(),
      containsPair('name', 'hello'),
    );
    expect(
      harness.updates
          .where(
            (update) =>
                update.sessionId == sessionId &&
                update.update.discriminator == 'session_info_update',
          )
          .map((update) => update.update.toJson().toString()),
      contains(contains('hello')),
    );
    harness.backend.emit(
      'item/agentMessage/delta',
      <String, Object?>{'delta': 'world'},
      threadId: sessionId.value,
      turnId: 'turn-1',
      itemId: 'message-1',
    );
    harness.backend.emit(
      'turn/completed',
      <String, Object?>{
        'turn': <String, Object?>{'id': 'turn-1', 'status': 'completed'},
      },
      threadId: sessionId.value,
      turnId: 'turn-1',
    );
    expect((await turnFuture).stopReason, StopReason.endTurn);
    await _flush();
    expect(
      harness.updates.any(
        (update) =>
            update.update.discriminator == 'agent_message_chunk' &&
            update.update.toJson().toString().contains('world'),
      ),
      isTrue,
    );

    final cancelFuture = harness.pair.client.agent.sendPrompt(
      PromptRequest(
        sessionId: sessionId,
        prompt: <ContentBlock>[_text('cancel me')],
      ),
    );
    await _flush();
    await harness.pair.client.agent.cancelSession(
      CancelNotification(sessionId: sessionId),
    );
    expect((await cancelFuture).stopReason, StopReason.cancelled);
    expect(harness.backend.count('turn/interrupt'), 1);
    expect(harness.backend.count('thread/name/set'), 1);

    await harness.pair.client.agent.closeSession(
      CloseSessionRequest(sessionId: sessionId),
    );
    expect(harness.backend.count('thread/unsubscribe'), 1);
    await expectLater(
      harness.pair.client.agent.sendPrompt(
        PromptRequest(
          sessionId: sessionId,
          prompt: <ContentBlock>[_text('late')],
        ),
      ),
      throwsA(isA<JsonRpcRequestException>()),
    );

    await harness.pair.client.agent.resumeSession(
      ResumeSessionRequest(sessionId: SessionId('resumed'), cwd: '/workspace'),
    );
    await harness.pair.client.agent.loadSession(
      LoadSessionRequest(
        sessionId: SessionId('loaded'),
        cwd: '/workspace',
        mcpServers: const <McpServer>[],
      ),
    );
    await harness.pair.client.agent.deleteSession(
      DeleteSessionRequest(sessionId: SessionId('loaded')),
    );
    expect(harness.backend.count('thread/archive'), 1);
  });

  test('scopes automatic approval review to standard workspace work', () async {
    final harness = await _connect(
      options: CodexAdapterOptions(
        environment: const <String, String>{},
        workspaceWriteApprovalsReviewer: CodexApprovalsReviewer.autoReview,
      ),
    );
    addTearDown(harness.close);
    final created = await harness.pair.client.agent.createSession(
      NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
    );
    final sessionId = created.sessionId;

    Future<CodexJsonObject> startAndComplete(String text) async {
      final turnNumber = harness.backend.count('turn/start') + 1;
      final turnId = 'turn-$turnNumber';
      final turn = harness.pair.client.agent.sendPrompt(
        PromptRequest(
          sessionId: sessionId,
          prompt: <ContentBlock>[_text(text)],
        ),
      );
      await _flush();
      final params = harness.backend.lastCall('turn/start').params;
      harness.backend.emit(
        'turn/completed',
        <String, Object?>{
          'turn': <String, Object?>{'id': turnId, 'status': 'completed'},
        },
        threadId: sessionId.value,
        turnId: turnId,
      );
      expect((await turn).stopReason, StopReason.endTurn);
      return params;
    }

    expect(
      (await startAndComplete('workspace work'))['approvalsReviewer'],
      'auto_review',
    );

    await harness.pair.client.agent.setSessionConfigOption(
      _params(sessionSetConfigOptionMethod, <String, Object?>{
        'sessionId': sessionId.value,
        'configId': 'agent-mode',
        'value': 'read-only',
      }),
    );
    expect(
      (await startAndComplete('read-only work'))['approvalsReviewer'],
      'user',
    );

    await harness.pair.client.agent.setSessionConfigOption(
      _params(sessionSetConfigOptionMethod, <String, Object?>{
        'sessionId': sessionId.value,
        'configId': 'agent-mode',
        'value': 'agent',
      }),
    );
    await harness.pair.client.agent.setSessionMode(
      SetSessionModeRequest(
        sessionId: sessionId,
        modeId: SessionModeId('plan'),
      ),
    );
    expect((await startAndComplete('plan work'))['approvalsReviewer'], 'user');
  });

  test('bridges approvals, elicitations, steering, and goals', () async {
    final harness = await _connect(
      elicitationContent: const <String, Object?>{
        'choice': 'A',
        'choice__other': 'custom',
      },
    );
    addTearDown(harness.close);
    final created = await harness.pair.client.agent.createSession(
      NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
    );
    final sessionId = created.sessionId;

    final commandDecision = await harness.backend.ask(
      CodexCommandApprovalRequest(
        threadId: CodexThreadId(sessionId.value),
        turnId: const CodexTurnId('turn-approval'),
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': sessionId.value,
          'turnId': 'turn-approval',
          'itemId': 'command-approval',
          'command': 'dart test',
          'cwd': '/workspace',
          'proposedExecpolicyAmendment': <Object?>['dart', 'test'],
          'proposedNetworkPolicyAmendments': <Object?>[
            <String, Object?>{'host': 'example.test', 'action': 'allow'},
          ],
        }),
      ),
    );
    expect(commandDecision.requireString('decision'), 'accept');
    expect(harness.permissions.single.options, hasLength(5));

    final fileDecision = await harness.backend.ask(
      CodexFileChangeApprovalRequest(
        threadId: CodexThreadId(sessionId.value),
        turnId: const CodexTurnId('turn-file'),
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': sessionId.value,
          'turnId': 'turn-file',
          'itemId': 'file-approval',
          'reason': 'Update files',
          'grantRoot': '/workspace',
        }),
      ),
    );
    expect(fileDecision.requireString('decision'), 'accept');

    final permissionDecision = await harness.backend.ask(
      CodexPermissionsRequest(
        threadId: CodexThreadId(sessionId.value),
        turnId: const CodexTurnId('turn-permission'),
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': sessionId.value,
          'turnId': 'turn-permission',
          'itemId': 'permission',
          'permissions': <String, Object?>{'network': true},
        }),
      ),
    );
    expect(permissionDecision.requireString('scope'), 'turn');
    expect(permissionDecision['strictAutoReview'], false);

    harness.backend.emit(
      'item/started',
      <String, Object?>{
        'item': <String, Object?>{
          'id': 'mcp-call',
          'type': 'mcpToolCall',
          'server': 'demo',
          'tool': 'ask',
        },
      },
      threadId: sessionId.value,
      itemId: 'mcp-call',
    );
    await _flush();
    final form = await harness.backend.ask(
      CodexMcpElicitationRequest(
        threadId: CodexThreadId(sessionId.value),
        turnId: null,
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': sessionId.value,
          'mode': 'form',
          'serverName': 'demo',
          'message': 'Choose',
          'requestedSchema': <String, Object?>{
            'properties': <String, Object?>{
              'choice': <String, Object?>{
                'type': 'string',
                'enum': <Object?>['a', 'b'],
                'enumNames': <Object?>['A', 'B'],
              },
            },
          },
        }),
      ),
    );
    expect(form.requireString('action'), 'accept');
    expect(harness.elicitations.single.toJson().toString(), contains('oneOf'));

    final userInput = await harness.backend.ask(
      CodexUserInputRequest(
        threadId: CodexThreadId(sessionId.value),
        turnId: const CodexTurnId('turn-input'),
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': sessionId.value,
          'turnId': 'turn-input',
          'itemId': 'input',
          'questions': <Object?>[
            <String, Object?>{
              'id': 'choice',
              'header': 'Choice',
              'question': 'Pick one',
              'isOther': true,
              'options': <Object?>[
                <String, Object?>{'label': 'A', 'description': 'First'},
              ],
            },
          ],
        }),
      ),
    );
    final answers = userInput.requireObject('answers');
    expect(answers.requireObject('choice')['answers'], <Object?>['custom']);

    final steering = await harness.pair.client.agent.request(
      codexSteeringMethod,
      CodexSteeringRequest(
        sessionId: sessionId,
        prompt: <ContentBlock>[_text('steer')],
      ),
    );
    expect(steering, CodexSteeringResponse.startedNewTurn);
    final injected = await harness.pair.client.agent.request(
      codexSteeringMethod,
      CodexSteeringRequest(
        sessionId: sessionId,
        prompt: <ContentBlock>[_text('more')],
      ),
    );
    expect(injected, CodexSteeringResponse.injected);

    await harness.pair.client.agent.request(
      acpSessionGoalControlMethod,
      AcpGoalControlRequest(
        sessionId: sessionId,
        action: AcpGoalControlAction.update,
        objective: 'Ship goal controls',
      ),
    );
    await harness.pair.client.agent.request(
      acpSessionGoalControlMethod,
      AcpGoalControlRequest(
        sessionId: sessionId,
        action: AcpGoalControlAction.pause,
      ),
    );
    await harness.pair.client.agent.request(
      acpSessionGoalControlMethod,
      AcpGoalControlRequest(
        sessionId: sessionId,
        action: AcpGoalControlAction.resume,
      ),
    );
    await harness.pair.client.agent.request(
      acpSessionGoalControlMethod,
      AcpGoalControlRequest(
        sessionId: sessionId,
        action: AcpGoalControlAction.clear,
      ),
    );
    expect(harness.backend.count('thread/goal/set'), 3);
    final goalCalls = harness.backend.calls
        .where((call) => call.method == 'thread/goal/set')
        .map((call) => call.params.toJson())
        .toList(growable: false);
    expect(goalCalls, <Map<Object?, Object?>>[
      <Object?, Object?>{
        'threadId': sessionId.value,
        'objective': 'Ship goal controls',
      },
      <Object?, Object?>{'threadId': sessionId.value, 'status': 'paused'},
      <Object?, Object?>{'threadId': sessionId.value, 'status': 'active'},
    ]);
    expect(harness.backend.count('thread/goal/clear'), 1);

    final unknown = await harness.backend.ask(
      CodexCommandApprovalRequest(
        threadId: const CodexThreadId('unknown-thread'),
        turnId: const CodexTurnId('unknown-turn'),
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': 'unknown-thread',
          'turnId': 'unknown-turn',
        }),
      ),
    );
    expect(unknown.requireString('decision'), 'cancel');
  });

  test(
    'handles URL, permission-fallback, decline, and empty elicitations',
    () async {
      final harness = await _connect();
      addTearDown(harness.close);
      final session = await harness.pair.client.agent.createSession(
        NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
      );

      final fallback = await harness.backend.ask(
        CodexMcpElicitationRequest(
          threadId: CodexThreadId(session.sessionId.value),
          turnId: null,
          params: CodexJsonObject.from(<String, Object?>{
            'threadId': session.sessionId.value,
            'mode': 'openai/form',
            'serverName': 'fallback',
            'message': 'Allow fallback?',
          }),
        ),
      );
      expect(fallback.requireString('action'), 'accept');
      expect(harness.permissions.single.options, hasLength(2));

      final url = await harness.backend.ask(
        CodexMcpElicitationRequest(
          threadId: CodexThreadId(session.sessionId.value),
          turnId: null,
          params: CodexJsonObject.from(<String, Object?>{
            'threadId': session.sessionId.value,
            'mode': 'url',
            'serverName': 'demo',
            'message': 'Open sign-in',
            'url': 'https://example.test/sign-in',
            'elicitationId': 'url-1',
          }),
        ),
      );
      expect(url.requireString('action'), 'accept');
      harness.backend.emit(
        'serverRequest/resolved',
        const <String, Object?>{},
        threadId: session.sessionId.value,
      );
      await _flush();
      expect(harness.completedElicitations, <String>['url-1']);

      final empty = await harness.backend.ask(
        CodexUserInputRequest(
          threadId: CodexThreadId(session.sessionId.value),
          turnId: const CodexTurnId('turn-empty'),
          params: CodexJsonObject.from(<String, Object?>{
            'threadId': session.sessionId.value,
            'turnId': 'turn-empty',
            'questions': <Object?>[],
          }),
        ),
      );
      expect(empty.requireObject('answers').toJson(), isEmpty);

      final custom = await harness.backend.ask(
        CodexMcpElicitationRequest(
          threadId: CodexThreadId(session.sessionId.value),
          turnId: null,
          params: CodexJsonObject.from(<String, Object?>{
            'threadId': session.sessionId.value,
            'mode': 'vendor/custom',
          }),
        ),
      );
      expect(custom.requireString('action'), 'accept');
    },
  );

  test('uses conservative bridge defaults without client handlers', () async {
    final harness = await _connect(
      handlePermissions: false,
      handleElicitations: false,
      advertiseElicitations: false,
    );
    addTearDown(harness.close);
    final session = await harness.pair.client.agent.createSession(
      NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
    );
    final thread = CodexThreadId(session.sessionId.value);

    final command = await harness.backend.ask(
      CodexCommandApprovalRequest(
        threadId: thread,
        turnId: const CodexTurnId('turn'),
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': thread.value,
          'turnId': 'turn',
        }),
      ),
    );
    expect(command.requireString('decision'), 'cancel');

    final permissions = await harness.backend.ask(
      CodexPermissionsRequest(
        threadId: thread,
        turnId: const CodexTurnId('turn'),
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': thread.value,
          'turnId': 'turn',
          'permissions': <String, Object?>{'network': true},
        }),
      ),
    );
    expect(permissions['strictAutoReview'], isTrue);

    final elicitation = await harness.backend.ask(
      CodexMcpElicitationRequest(
        threadId: thread,
        turnId: null,
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': thread.value,
          'mode': 'form',
          'requestedSchema': <String, Object?>{
            'properties': <String, Object?>{},
          },
        }),
      ),
    );
    expect(elicitation.requireString('action'), 'cancel');

    final input = await harness.backend.ask(
      CodexUserInputRequest(
        threadId: thread,
        turnId: const CodexTurnId('turn'),
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': thread.value,
          'turnId': 'turn',
          'questions': <Object?>[
            <String, Object?>{'id': 'answer', 'question': 'Answer?'},
          ],
        }),
      ),
    );
    expect(input.requireObject('answers').toJson(), isEmpty);
  });

  test('declines and auto-resolves user input safely', () async {
    final declined = await _connect(elicitationAction: 'decline');
    addTearDown(declined.close);
    final declinedSession = await declined.pair.client.agent.createSession(
      NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
    );
    final declinedResult = await declined.backend.ask(
      CodexMcpElicitationRequest(
        threadId: CodexThreadId(declinedSession.sessionId.value),
        turnId: null,
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': declinedSession.sessionId.value,
          'mode': 'form',
          'requestedSchema': <String, Object?>{
            'properties': <String, Object?>{
              'answer': <String, Object?>{'type': 'string'},
            },
          },
        }),
      ),
    );
    expect(declinedResult.requireString('action'), 'decline');
    expect(declinedResult['content'], isNull);

    final timed = await _connect(
      elicitationResponder: (_) =>
          Completer<CreateElicitationResponse>().future,
    );
    addTearDown(timed.close);
    final timedSession = await timed.pair.client.agent.createSession(
      NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
    );
    final timedResult = await timed.backend.ask(
      CodexUserInputRequest(
        threadId: CodexThreadId(timedSession.sessionId.value),
        turnId: const CodexTurnId('turn-timeout'),
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': timedSession.sessionId.value,
          'turnId': 'turn-timeout',
          'autoResolutionMs': 1,
          'questions': <Object?>[
            <String, Object?>{
              'id': 'answer',
              'header': 'Answer',
              'question': 'Answer quickly',
              'isSecret': true,
            },
          ],
        }),
      ),
    );
    expect(timedResult.requireObject('answers').toJson(), isEmpty);
  });

  test(
    'filters paginated models and supports browser authentication',
    () async {
      final harness = await _connect(
        configureBackend: (backend) {
          backend.on('model/list', (params) {
            if (params.optionalString('cursor') == null) {
              return CodexJsonObject.from(<String, Object?>{
                'data': <Object?>[
                  <String, Object?>{'id': '', 'displayName': 'Missing'},
                  <String, Object?>{'id': 'hidden', 'hidden': true},
                  <String, Object?>{
                    'model': 'fallback-model',
                    'supportedReasoningEfforts': <Object?>[
                      'low',
                      <String, Object?>{'effort': 'high'},
                      'not-an-effort',
                    ],
                    'inputModalities': <Object?>['image'],
                    'serviceTiers': <Object?>['fast'],
                    'contextWindow': 64000,
                  },
                ],
                'nextCursor': 'page-2',
              });
            }
            return CodexJsonObject.from(<String, Object?>{
              'data': <Object?>[
                <String, Object?>{
                  'id': 'second-model',
                  'defaultReasoningEffort': 'xhigh',
                },
              ],
              'nextCursor': '',
            });
          });
          backend.on(
            'account/read',
            (_) => CodexJsonObject.from(<String, Object?>{
              'account': <String, Object?>{'type': 'apiKey'},
            }),
          );
        },
      );
      addTearDown(harness.close);

      expect(harness.backend.count('model/list'), 2);
      expect(
        harness.pair.client.lifecycle.peerAuthMethods.map(
          (method) => (method as AuthMethodAgentVariant).value.id.value,
        ),
        contains('chat-gpt'),
      );
      await harness.pair.client.agent.authenticate(
        AuthenticateRequest(methodId: AuthMethodId('chat-gpt')),
      );
      expect(
        harness.backend.lastCall('account/login/start').params['type'],
        'chatgpt',
      );

      final created = await harness.pair.client.agent.createSession(
        NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
      );
      expect(
        created.configOptions!.map((option) => option.toJson()).toString(),
        allOf(
          contains('fallback-model'),
          contains('second-model'),
          isNot(contains('hidden')),
        ),
      );
      final modelConfig = created.configOptions!
          .whereType<SessionConfigOptionSelect>()
          .singleWhere(
            (option) => option.category == SessionConfigOptionCategory.model,
          );
      final modelOptions = switch (modelConfig.value.options) {
        SessionConfigSelectOptionsUngrouped(:final value) => value,
        SessionConfigSelectOptionsGrouped() => throw StateError(
          'Codex model options must be ungrouped',
        ),
      };
      final modalities = <String, Set<AcpModelInputModality>?>{
        for (final option in modelOptions)
          option.value.value: option.modelInputModalities,
      };
      expect(modalities['fallback-model'], <AcpModelInputModality>{
        AcpModelInputModality.text,
        AcpModelInputModality.image,
      });
      expect(modalities['second-model'], <AcpModelInputModality>{
        AcpModelInputModality.text,
      });
      final startParams = harness.backend.lastCall('thread/start').params;
      expect(startParams['model'], 'fallback-model');
      expect(startParams['threadSource'], 'appServer');
      expect(startParams.containsKey('sessionStartSource'), isFalse);
    },
  );

  test('reports authentication and gateway validation failures', () async {
    final failedLogin = await _connect(
      options: CodexAdapterOptions(
        environment: const <String, String>{'OPENAI_API_KEY': 'bad-key'},
      ),
      configureBackend: (backend) {
        backend.on('account/login/start', (_) {
          scheduleMicrotask(() {
            backend.emit('account/login/completed', <String, Object?>{
              'success': false,
            });
          });
          return CodexJsonObject.empty;
        });
      },
    );
    addTearDown(failedLogin.close);
    await expectLater(
      failedLogin.pair.client.agent.authenticate(
        AuthenticateRequest(methodId: AuthMethodId('api-key')),
      ),
      throwsA(anything),
    );
    await expectLater(
      failedLogin.pair.client.agent.authenticate(
        AuthenticateRequest(methodId: AuthMethodId('unknown')),
      ),
      throwsA(anything),
    );
    await expectLater(
      failedLogin.pair.client.agent.authenticate(
        AuthenticateRequest(
          methodId: AuthMethodId('gateway'),
          meta: AcpJsonObject.fromObject(<String, Object?>{
            'gateway': <String, Object?>{
              'baseUrl': 'https://gateway.example.test',
              'headers': <String, Object?>{'X-Good': 12},
            },
          }),
        ),
      ),
      throwsA(anything),
    );

    final noKey = await _connect();
    addTearDown(noKey.close);
    await expectLater(
      noKey.pair.client.agent.authenticate(
        AuthenticateRequest(methodId: AuthMethodId('api-key')),
      ),
      throwsA(anything),
    );
  });

  test('steers concurrent prompts and interrupts active deletion', () async {
    final harness = await _connect();
    addTearDown(harness.close);
    final session = await harness.pair.client.agent.createSession(
      NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
    );
    final first = harness.pair.client.agent.sendPrompt(
      PromptRequest(
        sessionId: session.sessionId,
        prompt: <ContentBlock>[_text('first')],
      ),
    );
    await _flush();
    final second = harness.pair.client.agent.sendPrompt(
      PromptRequest(
        sessionId: session.sessionId,
        prompt: <ContentBlock>[_text('second')],
      ),
    );
    await _flush();
    expect(harness.backend.count('turn/steer'), 1);
    harness.backend.emit(
      'turn/completed',
      <String, Object?>{
        'turn': <String, Object?>{'id': 'turn-1', 'status': 'completed'},
      },
      threadId: session.sessionId.value,
      turnId: 'turn-1',
    );
    expect((await first).stopReason, StopReason.endTurn);
    expect((await second).stopReason, StopReason.endTurn);

    final deleting = harness.pair.client.agent.sendPrompt(
      PromptRequest(
        sessionId: session.sessionId,
        prompt: <ContentBlock>[_text('delete')],
      ),
    );
    await _flush();
    await harness.pair.client.agent.deleteSession(
      DeleteSessionRequest(sessionId: session.sessionId),
    );
    expect((await deleting).stopReason, StopReason.cancelled);
    expect(harness.backend.count('turn/interrupt'), 1);
  });

  test('fences completion and close races around turn start', () async {
    final closeStart = Completer<CodexJsonObject>();
    final harness = await _connect(
      configureBackend: (backend) {
        backend.on('turn/start', (_) => closeStart.future);
      },
    );
    addTearDown(harness.close);
    final session = await harness.pair.client.agent.createSession(
      NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
    );
    final prompt = harness.pair.client.agent.sendPrompt(
      PromptRequest(
        sessionId: session.sessionId,
        prompt: <ContentBlock>[_text('close while starting')],
      ),
    );
    await _flush();
    await harness.pair.client.agent.closeSession(
      CloseSessionRequest(sessionId: session.sessionId),
    );
    closeStart.complete(
      CodexJsonObject.from(<String, Object?>{
        'turn': <String, Object?>{'id': 'late-turn'},
      }),
    );
    expect((await prompt).stopReason, StopReason.cancelled);
    expect(
      harness.backend.calls
          .where((call) => call.method == 'turn/interrupt')
          .single
          .params['turnId'],
      'late-turn',
    );

    final early = await _connect(
      configureBackend: (backend) {
        backend.on('turn/start', (_) {
          backend.emit(
            'turn/completed',
            <String, Object?>{
              'threadId': 'thread-1',
              'turn': <String, Object?>{
                'id': 'early-turn',
                'status': 'completed',
              },
            },
            threadId: 'thread-1',
            turnId: 'early-turn',
          );
          return CodexJsonObject.from(<String, Object?>{
            'turn': <String, Object?>{'id': 'early-turn'},
          });
        });
      },
    );
    addTearDown(early.close);
    final earlySession = await early.pair.client.agent.createSession(
      NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
    );
    final earlyResponse = await early.pair.client.agent.sendPrompt(
      PromptRequest(
        sessionId: earlySession.sessionId,
        prompt: <ContentBlock>[_text('early')],
      ),
    );
    expect(earlyResponse.stopReason, StopReason.endTurn);
    final next = early.pair.client.agent.sendPrompt(
      PromptRequest(
        sessionId: earlySession.sessionId,
        prompt: <ContentBlock>[_text('next')],
      ),
    );
    await _flush();
    expect(early.backend.count('turn/start'), 2);
    expect(early.backend.count('turn/steer'), 0);
    early.backend.emit(
      'turn/completed',
      <String, Object?>{
        'turn': <String, Object?>{'id': 'early-turn', 'status': 'completed'},
      },
      threadId: earlySession.sessionId.value,
      turnId: 'early-turn',
    );
    await next;
  });

  test('keeps seeded interleaved session events isolated', () async {
    final harness = await _connect();
    addTearDown(harness.close);
    final sessions = <SessionId>[
      (await harness.pair.client.agent.createSession(
        NewSessionRequest(cwd: '/workspace/a', mcpServers: const <McpServer>[]),
      )).sessionId,
      (await harness.pair.client.agent.createSession(
        NewSessionRequest(cwd: '/workspace/b', mcpServers: const <McpServer>[]),
      )).sessionId,
    ];
    final random = Random(1337);
    final expected = <String, List<String>>{
      for (final session in sessions) session.value: <String>[],
    };
    for (var index = 0; index < 100; index += 1) {
      final session = sessions[random.nextInt(sessions.length)];
      final text = '${session.value}:$index';
      expected[session.value]!.add(text);
      harness.backend.emit(
        'item/agentMessage/delta',
        <String, Object?>{'delta': text},
        threadId: session.value,
        itemId: 'message-$index',
      );
      if (random.nextBool()) {
        harness.backend.emit(
          'unknown/event',
          const <String, Object?>{},
          threadId: session.value,
        );
      }
    }
    await _flush();
    await Future<void>.delayed(const Duration(milliseconds: 1));

    for (final session in sessions) {
      final actual = <String>[
        for (final notification in harness.updates)
          if (notification.sessionId == session &&
              notification.update.discriminator == 'agent_message_chunk')
            (notification.update.toJson()['content']
                    as Map<String, Object?>)['text']
                as String,
      ];
      expect(actual, expected[session.value]);
      expect(
        actual.every((text) => text.startsWith('${session.value}:')),
        isTrue,
      );
    }
  });

  test(
    'native thread naming is best effort and only applies to new sessions',
    () async {
      final diagnostics = <CodexDiagnostic>[];
      final harness = await _connect(
        options: CodexAdapterOptions(
          environment: const <String, String>{},
          onDiagnostic: diagnostics.add,
        ),
        configureBackend: (backend) {
          backend.on(
            'thread/name/set',
            (_) => throw StateError('unsupported in fixture'),
          );
        },
      );
      addTearDown(harness.close);

      final created = await harness.pair.client.agent.createSession(
        NewSessionRequest(cwd: '/workspace', mcpServers: const <McpServer>[]),
      );
      final createdTurn = harness.pair.client.agent.sendPrompt(
        PromptRequest(
          sessionId: created.sessionId,
          prompt: <ContentBlock>[_text('name me')],
        ),
      );
      await _flush();
      expect(harness.backend.count('thread/name/set'), 1);
      expect(harness.backend.count('turn/start'), 1);
      harness.backend.emit(
        'turn/completed',
        <String, Object?>{
          'turn': <String, Object?>{'id': 'turn-1', 'status': 'completed'},
        },
        threadId: created.sessionId.value,
        turnId: 'turn-1',
      );
      expect((await createdTurn).stopReason, StopReason.endTurn);
      expect(
        diagnostics.map((diagnostic) => diagnostic.message),
        contains('The Codex app server could not name the new thread.'),
      );

      const resumedIdValue = 'resumed';
      final resumedId = SessionId(resumedIdValue);
      await harness.pair.client.agent.resumeSession(
        ResumeSessionRequest(sessionId: resumedId, cwd: '/workspace'),
      );
      final resumedTurn = harness.pair.client.agent.sendPrompt(
        PromptRequest(
          sessionId: resumedId,
          prompt: <ContentBlock>[_text('do not rename me')],
        ),
      );
      await _flush();
      expect(harness.backend.count('thread/name/set'), 1);
      expect(harness.backend.count('turn/start'), 2);
      harness.backend.emit(
        'turn/completed',
        <String, Object?>{
          'turn': <String, Object?>{'id': 'turn-2', 'status': 'completed'},
        },
        threadId: resumedIdValue,
        turnId: 'turn-2',
      );
      expect((await resumedTurn).stopReason, StopReason.endTurn);
    },
  );
}
