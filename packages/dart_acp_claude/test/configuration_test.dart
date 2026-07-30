import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

import 'helpers/fake_transport.dart';

void main() {
  test('validates immutable process options', () {
    expect(() => ClaudeAcpOptions(maxTurns: 0), throwsArgumentError);
    expect(
      () => ClaudeAcpOptions(maximumQueuedPrompts: 0),
      throwsArgumentError,
    );
    expect(() => ClaudeAcpOptions(maxBudgetUsd: 0), throwsArgumentError);
    expect(() => ClaudeAcpOptions(maxBufferSize: 0), throwsArgumentError);
    expect(
      () => ClaudeAcpOptions(initializeTimeout: Duration.zero),
      throwsArgumentError,
    );
    expect(
      () => ClaudeAcpOptions(
        permissionMode: claude.PermissionMode.bypassPermissions,
      ),
      throwsArgumentError,
    );
    expect(
      () => ClaudeAcpOptions(
        settings: '{}',
        inlineSettings: const <String, Object?>{},
      ),
      throwsArgumentError,
    );
    expect(
      () => ClaudeAcpOptions(model: 'same', fallbackModel: 'same'),
      throwsArgumentError,
    );
    final options = ClaudeAcpOptions(
      environment: const <String, String>{'KEY': 'value'},
      allowedTools: const <String>['Read'],
      disallowedTools: const <String>['Bash'],
    );
    expect(() => options.environment['KEY'] = 'other', throwsUnsupportedError);
    expect(() => options.allowedTools.add('Write'), throwsUnsupportedError);

    const byType = ClaudeSdkMessageFilter(type: 'system');
    const exact = ClaudeSdkMessageFilter(
      type: 'result',
      subtype: 'success',
      origin: 'observer',
    );
    expect(byType.matches(const <String, Object?>{'type': 'system'}), isTrue);
    expect(byType.matches(const <String, Object?>{'type': 'result'}), isFalse);
    expect(
      exact.matches(const <String, Object?>{
        'type': 'result',
        'subtype': 'error',
      }),
      isFalse,
    );
    expect(
      exact.matches(const <String, Object?>{
        'type': 'result',
        'subtype': 'success',
        'origin': 'observer',
      }),
      isFalse,
    );
    expect(
      exact.matches(const <String, Object?>{
        'type': 'result',
        'subtype': 'success',
        'origin': <String, Object?>{'kind': 'observer'},
      }),
      isTrue,
    );
  });

  test('applies model, effort, agent, mode, and fast selections', () async {
    final transport = FakeClaudeTransport();
    transport.onWrite = transport.autoRespond;
    final client = claude.ClaudeAgentClient(transport: transport);
    await client.connect();
    addTearDown(client.close);

    final initialization = claude.ClaudeInitializationResult.fromJson(
      <String, Object?>{
        'models': <Object?>[
          <String, Object?>{
            'value': 'default',
            'displayName': 'Default',
            'supportsAutoMode': true,
            'supportsEffort': true,
            'supportsFastMode': true,
            'supportedEffortLevels': <Object?>['low', 'high'],
          },
          <String, Object?>{
            'value': 'restricted',
            'displayName': 'Restricted',
            'resolvedModel': 'provider-restricted',
            'supportsAutoMode': false,
            'supportsEffort': false,
            'supportsFastMode': false,
          },
          <String, Object?>{'value': 'hidden', 'displayName': 'Hidden'},
        ],
        'agents': <Object?>[
          <String, Object?>{
            'name': 'reviewer',
            'description': 'Reviews changes',
          },
          <String, Object?>{'name': 'general-purpose'},
        ],
      },
    );
    final configuration = ClaudeSessionConfiguration(
      initialization: initialization,
      initialMode: claude.PermissionMode.auto,
      requestedModel: 'default',
      availableModels: const <String>['restricted'],
    );

    expect(configuration.models.map((model) => model.value), <String>[
      'default',
      'restricted',
    ]);
    expect(
      configuration.options.map((option) => option.toJson()['id']),
      <Object?>['model', 'effort', 'agent', 'fast'],
    );
    expect(
      configuration.options
          .firstWhere((option) => option.toJson()['id'] == 'fast')
          .toJson()['type'],
      'select',
    );
    expect(
      configuration.modes.availableModes.map((mode) => mode.id.value),
      contains('auto'),
    );

    await configuration.apply('effort', 'high', client);
    expect(configuration.effort, claude.EffortLevel.high);
    await configuration.apply('agent', 'reviewer', client);
    expect(configuration.agent, 'reviewer');
    await configuration.apply('fast', true, client);
    expect(configuration.fastMode, isTrue);
    await configuration.apply('model', 'restricted', client);
    expect(configuration.model, 'restricted');
    expect(configuration.mode, claude.PermissionMode.standard);
    expect(configuration.effort, isNull);
    expect(configuration.fastMode, isFalse);
    expect(
      configuration.modes.availableModes.map((mode) => mode.id.value),
      isNot(contains('auto')),
    );

    await expectLater(
      configuration.apply('fast', true, client),
      throwsFormatException,
    );
    await expectLater(
      configuration.apply('model', 'missing', client),
      throwsFormatException,
    );
    await expectLater(
      configuration.apply('effort', 'extreme', client),
      throwsFormatException,
    );
    await expectLater(
      configuration.apply('agent', 'missing', client),
      throwsFormatException,
    );
    await expectLater(
      configuration.apply('unknown', true, client),
      throwsFormatException,
    );

    await configuration.apply('agent', 'default', client);
    expect(configuration.agent, isNull);
  });

  test('uses native Fast-mode booleans only for capable ACP clients', () {
    final configuration = ClaudeSessionConfiguration(
      initialization: claude.ClaudeInitializationResult.fromJson(
        <String, Object?>{
          'models': <Object?>[
            <String, Object?>{
              'value': 'default',
              'displayName': 'Default',
              'supportsFastMode': true,
            },
          ],
          'fast_mode_state': 'off',
          'fast_mode_disabled_reason': 'extra_usage_disabled',
        },
      ),
      useBooleanFastMode: true,
    );
    final fast = configuration.options
        .firstWhere((option) => option.toJson()['id'] == 'fast')
        .toJson();
    expect(fast['type'], 'boolean');
    expect(fast['description'], contains('extra usage'));

    expect(configuration.reconcileFastMode('cooldown'), isTrue);
    expect(configuration.fastMode, isTrue);
    expect(configuration.fastModeDisabledReason, isNull);
  });

  test('reconciles every Fast-mode wire state and clears defaults', () async {
    final transport = FakeClaudeTransport();
    transport.onWrite = transport.autoRespond;
    final client = claude.ClaudeAgentClient(transport: transport);
    await client.connect();
    addTearDown(client.close);
    final configuration = ClaudeSessionConfiguration(
      initialization: claude.ClaudeInitializationResult.fromJson(
        <String, Object?>{
          'models': <Object?>[
            <String, Object?>{
              'value': 'default',
              'displayName': 'Default',
              'supportsEffort': true,
              'supportsFastMode': true,
              'supportedEffortLevels': <Object?>['low'],
            },
          ],
          'fast_mode_state': 'off',
          'fast_mode_disabled_reason': 'model_not_allowed',
        },
      ),
      requestedEffort: claude.EffortLevel.high,
    );
    expect(configuration.effort, isNull);
    expect(configuration.reconcileFastMode('on'), isTrue);
    expect(configuration.fastMode, isTrue);
    expect(
      configuration.reconcileFastMode('off', disabledReason: 'network_error'),
      isTrue,
    );
    expect(configuration.fastModeDisabledReason, 'network_error');
    expect(configuration.reconcileFastMode('future'), isFalse);

    await configuration.apply('effort', 'default', client);
    await configuration.apply('fast', 'on', client);
    await configuration.apply('fast', 'off', client);
    await configuration.apply('fast', false, client);
    expect(configuration.fastMode, isFalse);
  });

  test('resolves model aliases, context lanes, and pinned versions', () {
    final initialization = claude.ClaudeInitializationResult.fromJson(
      <String, Object?>{
        'models': <Object?>[
          <String, Object?>{
            'value': 'default',
            'displayName': 'Default',
            'resolvedModel': 'claude-sonnet-4-6',
          },
          <String, Object?>{
            'value': 'sonnet',
            'displayName': 'Claude Sonnet 4.6',
            'resolvedModel': 'claude-sonnet-4-6',
          },
          <String, Object?>{
            'value': 'sonnet[1m]',
            'displayName': 'Claude Sonnet 4.6 (1M context)',
            'resolvedModel': 'claude-sonnet-4-6-1m',
          },
          <String, Object?>{
            'value': 'opus',
            'displayName': 'Claude Opus 4.7',
            'resolvedModel': 'claude-opus-4-7',
          },
        ],
      },
    );

    final extended = ClaudeSessionConfiguration(
      initialization: initialization,
      requestedModel: 'claude-sonnet-4-6-1m',
    );
    expect(extended.model, 'sonnet[1m]');
    expect(extended.inferredContextWindow, 1000000);
    expect(extended.reconcileModel('Claude Opus 4.7'), isTrue);
    expect(extended.model, 'opus');
    expect(extended.inferredContextWindow, 200000);

    final incompatible = ClaudeSessionConfiguration(
      initialization: initialization,
      requestedModel: 'claude-opus-4-6',
    );
    expect(incompatible.model, 'default');
  });

  test('surfaces exact allowlist IDs, overrides, and custom models', () {
    final initialization = claude.ClaudeInitializationResult.fromJson(
      <String, Object?>{
        'models': <Object?>[
          <String, Object?>{'value': 'default', 'displayName': 'Default'},
          <String, Object?>{
            'value': 'sonnet',
            'displayName': 'Claude Sonnet',
            'supportsEffort': true,
          },
          <String, Object?>{
            'value': 'custom-provider-model',
            'displayName': 'Custom',
          },
        ],
      },
    );
    final configuration = ClaudeSessionConfiguration(
      initialization: initialization,
      availableModels: const <String>['sonnet', 'unlisted-zebra'],
      modelOverrides: const <String, String>{'sonnet': 'provider-sonnet-arn'},
      customModelOption: 'custom-provider-model',
    );

    expect(configuration.models.map((model) => model.value), <String>[
      'default',
      'provider-sonnet-arn',
      'unlisted-zebra',
      'custom-provider-model',
    ]);
    expect(configuration.models[1].supportsEffort, isTrue);
    expect(configuration.models[2].displayName, 'unlisted-zebra');
  });

  test('reconciles supported runtime permission mode changes', () {
    final configuration = ClaudeSessionConfiguration(
      initialization: claude.ClaudeInitializationResult.fromJson(
        <String, Object?>{
          'models': <Object?>[
            <String, Object?>{
              'value': 'default',
              'displayName': 'Default',
              'supportsAutoMode': true,
            },
          ],
        },
      ),
    );

    expect(configuration.reconcileMode('plan'), isTrue);
    expect(configuration.mode, claude.PermissionMode.plan);
    expect(configuration.reconcileMode('plan'), isFalse);
    expect(configuration.reconcileMode('bypassPermissions'), isFalse);
    expect(configuration.reconcileMode('future-mode'), isFalse);

    final bypassEnabled = ClaudeSessionConfiguration(
      initialization: claude.ClaudeInitializationResult.fromJson(
        <String, Object?>{
          'models': <Object?>[
            <String, Object?>{
              'value': 'default',
              'displayName': 'Default',
              'supportsAutoMode': true,
            },
          ],
        },
      ),
      allowBypassPermissions: true,
    );
    expect(
      bypassEnabled.modes.availableModes.map((mode) => mode.id.value),
      contains('bypassPermissions'),
    );
    expect(bypassEnabled.reconcileMode('bypassPermissions'), isTrue);
    expect(bypassEnabled.mode, claude.PermissionMode.bypassPermissions);
  });

  test('preserves a resumed live model and reuses SDK capabilities', () {
    final configuration = ClaudeSessionConfiguration(
      initialization: claude.ClaudeInitializationResult.fromJson(
        <String, Object?>{
          'models': <Object?>[
            <String, Object?>{'value': 'default', 'displayName': 'Default'},
            <String, Object?>{
              'value': 'sonnet',
              'displayName': 'Claude Sonnet 4.6',
              'resolvedModel': 'claude-sonnet-4-6',
              'supportsAutoMode': true,
              'supportsEffort': true,
              'supportsFastMode': true,
              'supportedEffortLevels': <Object?>['high'],
            },
          ],
        },
      ),
      requestedModel: 'provider/claude-sonnet-4-6',
      availableModels: const <String>[],
      preserveUnknownRequestedModel: true,
      initialMode: claude.PermissionMode.auto,
      requestedEffort: claude.EffortLevel.high,
    );

    expect(configuration.model, 'provider/claude-sonnet-4-6');
    expect(
      configuration.options
          .firstWhere((option) => option.toJson()['id'] == 'model')
          .toJson()['currentValue'],
      'provider/claude-sonnet-4-6',
    );
    expect(configuration.modes.currentModeId.value, 'auto');
    expect(
      configuration.options.map((option) => option.toJson()['id']),
      containsAll(<Object?>['effort', 'fast']),
    );
  });

  test('maps MCP transports and rejects malformed server data', () {
    const mapper = ClaudeMcpMapper();
    final mapped = mapper.map(<McpServer>[
      McpServer.fromJson(<String, Object?>{
        'name': 'stdio',
        'command': '/bin/tool',
        'args': <Object?>['serve'],
        'env': <Object?>[
          <String, Object?>{'name': 'KEY', 'value': 'value'},
        ],
      }),
      McpServer.fromJson(<String, Object?>{
        'type': 'http',
        'name': 'http',
        'url': 'https://mcp.example/rpc',
        'headers': <Object?>[
          <String, Object?>{'name': 'Authorization', 'value': 'secret'},
        ],
      }),
      McpServer.fromJson(<String, Object?>{
        'type': 'sse',
        'name': 'sse',
        'url': 'https://mcp.example/events',
        'headers': <Object?>[
          <String, Object?>{'name': 'X-Test', 'value': 'yes'},
        ],
      }),
    ]);
    final servers = (mapped! as claude.McpServers).servers;
    expect(servers.keys, containsAll(<String>['stdio', 'http', 'sse']));
    expect(servers['stdio']!.toJson().toString(), contains('/bin/tool'));
    expect(servers['http']!.toJson().toString(), contains('mcp.example'));
    expect(servers['sse']!.toJson().toString(), contains('X-Test'));
    expect(mapper.map(const <McpServer>[]), isNull);
  });

  test('configures all supported provider environments', () {
    final bedrock = ClaudeProviderConfiguration(
      apiType: 'bedrock',
      baseUrl: Uri.parse('https://bedrock.example'),
    );
    expect(bedrock.environment, containsPair('CLAUDE_CODE_USE_BEDROCK', '1'));

    final vertex = ClaudeProviderConfiguration(
      apiType: 'vertex',
      baseUrl: Uri.parse('https://vertex.example'),
      vertexProjectId: 'project',
      vertexRegion: 'region',
    );
    expect(
      vertex.environment,
      containsPair('ANTHROPIC_VERTEX_PROJECT_ID', 'project'),
    );
    expect(
      () => ClaudeProviderConfiguration(
        apiType: 'anthropic',
        baseUrl: Uri.parse('ftp://invalid.example'),
      ),
      throwsFormatException,
    );
  });
}
