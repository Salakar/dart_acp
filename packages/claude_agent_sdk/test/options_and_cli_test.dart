import 'dart:convert';
import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:claude_agent_sdk/src/transport/cli_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClaudeAgentOptions', () {
    test('defensively copies collection inputs', () {
      final tools = ['Read'];
      final environment = {'A': 'B'};
      final options = ClaudeAgentOptions(
        allowedTools: tools,
        environment: environment,
      );
      tools.add('Write');
      environment['A'] = 'changed';

      expect(options.allowedTools, ['Read']);
      expect(options.environment, {'A': 'B'});
      expect(() => options.allowedTools.add('Bash'), throwsUnsupportedError);
    });

    test('validates conflicting and numeric options', () {
      expect(
        () => ClaudeAgentOptions(continueSession: true, resume: 'id'),
        throwsArgumentError,
      );
      expect(() => ClaudeAgentOptions(maxTurns: 0), throwsArgumentError);
      expect(
        () => ClaudeAgentOptions(
          canUseTool: (_, _, _) async => const PermissionDenied(message: 'no'),
          permissionPromptToolName: 'other',
        ),
        throwsArgumentError,
      );
      expect(() => EnabledThinking(budget: 0), throwsArgumentError);
      expect(() => TaskBudget(0), throwsArgumentError);
      expect(() => NamedSkills(['']), throwsArgumentError);
      expect(
        () => AgentDefinition(description: '', prompt: 'prompt'),
        throwsArgumentError,
      );
      expect(
        () => AgentDefinition(
          description: 'agent',
          prompt: 'prompt',
          maxTurns: 0,
        ),
        throwsArgumentError,
      );
      expect(
        () => AgentDefinition(
          description: 'agent',
          prompt: 'prompt',
          effort: EffortLevel.high,
          numericEffort: 3,
        ),
        throwsArgumentError,
      );
      expect(() => SdkPluginConfig(''), throwsArgumentError);
      expect(() => ClaudeAgentOptions(maxBudgetUsd: 0), throwsArgumentError);
      expect(() => ClaudeAgentOptions(maxBufferSize: 0), throwsArgumentError);
      expect(
        () => ClaudeAgentOptions(initializeTimeout: Duration.zero),
        throwsArgumentError,
      );
      expect(
        () => ClaudeAgentOptions(
          agents: {'': AgentDefinition(description: 'agent', prompt: 'prompt')},
        ),
        throwsArgumentError,
      );
      expect(
        () => ClaudeAgentOptions(resumeSessionAt: 'message'),
        throwsArgumentError,
      );
      expect(
        () => ClaudeAgentOptions(
          permissionMode: PermissionMode.bypassPermissions,
        ),
        throwsArgumentError,
      );
      expect(
        () => ClaudeAgentOptions(supportedDialogKinds: const ['dialog']),
        throwsArgumentError,
      );
      expect(
        () => ClaudeAgentOptions(
          settings: '/tmp/settings.json',
          inlineSettings: const {'model': 'sonnet'},
        ),
        throwsArgumentError,
      );
    });

    test('copies options for a materialized resume tree', () {
      final original = ClaudeAgentOptions(
        tools: const ToolConfiguration.claudeCode(),
        systemPrompt: const SystemPrompt.file('/prompt.txt'),
        resume: 'old-session',
        workingDirectory: '/workspace',
        environment: const {'EXISTING': 'value'},
        taskBudget: TaskBudget(500),
        skills: const SkillsConfiguration.all(),
      );

      final copied = original.withMaterializedResume(
        configDirectory: '/temporary/config',
        resumeSessionId: 'stored-session',
      );

      expect(copied.resume, 'stored-session');
      expect(copied.continueSession, isFalse);
      expect(copied.environment, {
        'EXISTING': 'value',
        'CLAUDE_CONFIG_DIR': '/temporary/config',
      });
      expect(copied.workingDirectory, '/workspace');
      expect(copied.taskBudget?.totalTokens, 500);
    });
  });

  group('CLI argument mapping', () {
    test('maps current option surface and skills', () async {
      final arguments = await buildCliArguments(
        ClaudeAgentOptions(
          tools: ToolConfiguration.explicit(['Read', 'Write']),
          allowedTools: ['Bash(git status:*)'],
          systemPrompt: const SystemPrompt.claudeCode(append: 'Be concise'),
          permissionMode: PermissionMode.plan,
          maxTurns: 3,
          maxBudgetUsd: 1.5,
          model: 'sonnet',
          fallbackModel: 'haiku',
          betas: const [SdkBeta.context1m],
          addDirectories: const ['/tmp/extra'],
          includePartialMessages: true,
          includeHookEvents: true,
          strictMcpConfig: true,
          forkSession: true,
          settingSources: const [SettingSource.project],
          skills: SkillsConfiguration.named(['review']),
          plugins: [SdkPluginConfig('/tmp/plugin')],
          thinking: ThinkingConfig.adaptive(
            display: ThinkingDisplay.summarized,
          ),
          effort: EffortLevel.high,
          outputFormat: JsonSchemaOutputFormat({'type': 'object'}),
          extraArguments: const {'future-flag': null, 'value': '-x'},
        ),
        windows: false,
      );

      expect(arguments, containsAllInOrder(['--tools', 'Read,Write']));
      expect(
        arguments,
        containsAllInOrder([
          '--allowedTools',
          'Bash(git status:*),Skill(review)',
        ]),
      );
      expect(arguments, containsAll(['--permission-mode', 'plan']));
      expect(arguments, contains('--include-partial-messages'));
      expect(arguments, contains('--include-hook-events'));
      expect(arguments, contains('--strict-mcp-config'));
      expect(arguments, contains('--fork-session'));
      expect(arguments, contains('--setting-sources=project'));
      expect(arguments, contains('--future-flag'));
      expect(arguments, contains('--value=-x'));
      expect(arguments.last, 'stream-json');
    });

    test('maps current process and initialization-oriented options', () async {
      final options = ClaudeAgentOptions(
        agent: 'reviewer',
        agents: {
          'reviewer': AgentDefinition(
            description: 'Reviews code',
            prompt: 'Review carefully',
            criticalSystemReminder: 'Never edit',
            observer: 'audit',
            observerMessage: 'Focus on safety',
          ),
        },
        toolAliases: const {'Bash': 'mcp__workspace__bash'},
        toolConfig: const BuiltinToolConfig(
          questionPreviewFormat: QuestionPreviewFormat.html,
        ),
        permissionMode: PermissionMode.bypassPermissions,
        allowDangerouslySkipPermissions: true,
        resume: 'session',
        resumeSessionAt: '-message-id',
        inlineSettings: const {'model': 'sonnet'},
        managedSettings: const {
          'sandbox': {
            'network': {'strictAllowlist': true},
          },
        },
        persistSession: false,
        plugins: [SdkPluginConfig('/tmp/plugin', skipMcpDiscovery: true)],
        debugFile: '/tmp/claude.log',
      );

      final arguments = await buildCliArguments(options, windows: false);
      expect(arguments, containsAllInOrder(['--agent', 'reviewer']));
      expect(arguments, contains('--allow-dangerously-skip-permissions'));
      expect(arguments, contains('--resume-session-at=-message-id'));
      expect(arguments, contains('--no-session-persistence'));
      expect(
        arguments,
        containsAllInOrder(['--plugin-dir-no-mcp', '/tmp/plugin']),
      );
      expect(
        arguments,
        containsAllInOrder(['--debug-file', '/tmp/claude.log']),
      );
      final settingsIndex = arguments.indexOf('--settings');
      expect(
        jsonDecode(arguments[settingsIndex + 1]),
        containsPair('model', 'sonnet'),
      );
      final plan = await createCliLaunchPlan(
        ClaudeAgentOptions(
          cliPath: '/bin/true',
          toolConfig: options.toolConfig,
        ),
        parentEnvironment: const <String, String>{},
        isWindows: false,
      );
      expect(plan.environment['CLAUDE_CODE_QUESTION_PREVIEW_FORMAT'], 'html');
      expect(
        options.agents['reviewer']!.toJson(),
        containsPair('observer', 'audit'),
      );
    });

    test('forces stdio permission prompts for callbacks', () async {
      final arguments = await buildCliArguments(
        ClaudeAgentOptions(canUseTool: (_, _, _) async => PermissionAllowed()),
        windows: false,
      );
      expect(
        arguments,
        containsAllInOrder(['--permission-prompt-tool', 'stdio']),
      );
    });

    test('serializes MCP servers and sandbox settings', () async {
      final options = ClaudeAgentOptions(
        mcp: McpServers({
          'local': McpStdioServerConfig(
            command: 'server',
            arguments: const ['--stdio'],
          ),
        }),
        settings: '{"theme":"dark"}',
        sandbox: SandboxSettings(
          isEnabled: true,
          network: SandboxNetworkConfig(allowedDomains: const ['example.com']),
        ),
      );
      final arguments = await buildCliArguments(options, windows: false);
      final mcpIndex = arguments.indexOf('--mcp-config');
      final settingsIndex = arguments.indexOf('--settings');

      expect(jsonDecode(arguments[mcpIndex + 1]), contains('mcpServers'));
      expect(
        jsonDecode(arguments[settingsIndex + 1]),
        containsPair('theme', 'dark'),
      );
      expect(
        (jsonDecode(arguments[settingsIndex + 1]) as Map)['sandbox'],
        containsPair('enabled', true),
      );
    });

    test('rejects Windows batch wrappers and unsafe values', () {
      expect(
        () => rejectWindowsBatchCli(r'C:\bin\claude.cmd', windows: true),
        throwsA(isA<CliConnectionException>()),
      );
      expect(
        () => validateWindowsCliValue('resume', 'id&whoami', windows: true),
        throwsArgumentError,
      );
      expect(
        () => validateWindowsCliValue('resume', 'safe-id', windows: true),
        returnsNormally,
      );
    });

    test('finds an explicit executable on PATH', () {
      final temporary = Directory.systemTemp.createTempSync('claude-path-');
      addTearDown(() => temporary.deleteSync(recursive: true));
      final executable = File('${temporary.path}/claude')
        ..writeAsStringSync('');

      expect(
        findCli({'PATH': temporary.path}, windows: false),
        executable.path,
      );
    });

    test('encodes preset tools, source MCP, and all skill defaults', () async {
      final arguments = await buildCliArguments(
        ClaudeAgentOptions(
          tools: const ToolConfiguration.claudeCode(),
          mcp: const McpConfigSource('/tmp/mcp.json'),
          skills: const SkillsConfiguration.all(),
          taskBudget: TaskBudget(1000),
          thinking: const ThinkingConfig.disabled(),
        ),
        windows: false,
      );

      expect(arguments, containsAllInOrder(['--tools', 'default']));
      expect(arguments, containsAllInOrder(['--allowedTools', 'Skill']));
      expect(arguments, containsAllInOrder(['--task-budget', '1000']));
      expect(arguments, containsAllInOrder(['--mcp-config', '/tmp/mcp.json']));
      expect(arguments, containsAllInOrder(['--thinking', 'disabled']));
      expect(arguments, contains('--setting-sources=user,project'));
    });
  });
}
