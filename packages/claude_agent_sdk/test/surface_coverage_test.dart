import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:test/test.dart';

JsonMap hookPayload(String event, JsonMap fields) => {
  'hook_event_name': event,
  'session_id': 'session',
  'transcript_path': '/tmp/session.jsonl',
  'cwd': '/tmp',
  'permission_mode': 'default',
  ...fields,
};

void main() {
  test('all content block variants encode at the protocol boundary', () {
    final blocks = <ContentBlock>[
      const TextBlock('text'),
      const ThinkingBlock(thinking: 'thought', signature: 'signature'),
      ToolUseBlock(id: 'tool', name: 'Read', input: {'path': 'a'}),
      ToolResultBlock(toolUseId: 'tool', content: 'done', isError: false),
      ServerToolUseBlock(
        id: 'server',
        name: 'web_search',
        input: {'query': 'Dart'},
      ),
      ServerToolResultBlock(
        toolUseId: 'server',
        content: {'type': 'search_results'},
      ),
      UnknownContentBlock({'type': 'future', 'value': 1}),
    ];

    expect(blocks.map((block) => block.toJson()), everyElement(isA<JsonMap>()));
    expect(
      (blocks[4] as ServerToolUseBlock).knownName,
      ServerToolName.webSearch,
    );
    expect((blocks.last as UnknownContentBlock).type, 'future');
  });

  test('all hook input variants decode', () {
    final values = <HookInput>[
      HookInput.fromJson(
        hookPayload('PostToolUse', {
          'tool_name': 'Read',
          'tool_input': {'path': 'a'},
          'tool_response': {'ok': true},
          'tool_use_id': 'tool',
          'agent_id': 'agent',
          'agent_type': 'reviewer',
        }),
      ),
      HookInput.fromJson(
        hookPayload('PostToolUseFailure', {
          'tool_name': 'Read',
          'tool_input': {'path': 'a'},
          'tool_use_id': 'tool',
          'error': 'missing',
          'is_interrupt': true,
        }),
      ),
      HookInput.fromJson(hookPayload('UserPromptSubmit', {'prompt': 'hello'})),
      HookInput.fromJson(hookPayload('Stop', {'stop_hook_active': true})),
      HookInput.fromJson(
        hookPayload('SubagentStop', {
          'stop_hook_active': false,
          'agent_id': 'agent',
          'agent_transcript_path': '/tmp/agent.jsonl',
          'agent_type': 'reviewer',
        }),
      ),
      HookInput.fromJson(
        hookPayload('PreCompact', {
          'trigger': 'manual',
          'custom_instructions': 'keep tests',
        }),
      ),
      HookInput.fromJson(
        hookPayload('SubagentStart', {
          'agent_id': 'agent',
          'agent_type': 'reviewer',
        }),
      ),
      HookInput.fromJson(
        hookPayload('PermissionRequest', {
          'tool_name': 'Bash',
          'tool_input': {'command': 'pwd'},
          'permission_suggestions': [
            {'type': 'setMode', 'mode': 'plan'},
          ],
        }),
      ),
    ];

    expect(values[0], isA<PostToolUseHookInput>());
    expect(values[1], isA<PostToolUseFailureHookInput>());
    expect(values[2], isA<UserPromptSubmitHookInput>());
    expect(values[3], isA<StopHookInput>());
    expect(values[4], isA<SubagentStopHookInput>());
    expect(values[5], isA<PreCompactHookInput>());
    expect(values[6], isA<SubagentStartHookInput>());
    expect(values[7], isA<PermissionRequestHookInput>());
    expect(
      (values[7] as PermissionRequestHookInput).permissionSuggestions,
      hasLength(1),
    );
  });

  test('all hook-specific output variants encode', () {
    final outputs = <HookSpecificOutput>[
      PreToolUseHookOutput(
        permissionDecision: 'allow',
        permissionDecisionReason: 'safe',
        updatedInput: {'path': 'b'},
        additionalContext: 'checked',
      ),
      PostToolUseHookOutput(
        additionalContext: 'complete',
        updatedToolOutput: {'result': true},
      ),
      const AdditionalContextHookOutput(
        event: HookEvent.stop,
        additionalContext: 'context',
      ),
      PermissionRequestHookOutput({'behavior': 'allow'}),
    ];

    expect(
      outputs.map((output) => output.toJson()),
      everyElement(contains('hookEventName')),
    );
  });

  test('all MCP configuration and result content variants encode', () {
    final configs = <McpServerConfig>[
      McpStdioServerConfig(
        command: 'server',
        arguments: const ['--stdio'],
        environment: const {'TOKEN': 'redacted'},
      ),
      McpSseServerConfig(
        url: 'https://example.com/sse',
        headers: const {'X-Test': '1'},
      ),
      McpHttpServerConfig(
        url: 'https://example.com/mcp',
        headers: const {'X-Test': '1'},
      ),
    ];
    final content = <McpToolContent>[
      const McpTextContent('text'),
      const McpImageContent(data: 'base64', mimeType: 'image/png'),
      const McpAudioContent(data: 'base64', mimeType: 'audio/wav'),
      const McpResourceLinkContent(
        uri: 'file:///tmp/a',
        name: 'a',
        description: 'file',
        mimeType: 'text/plain',
      ),
      const McpEmbeddedResourceContent(
        uri: 'file:///tmp/a',
        text: 'contents',
        mimeType: 'text/plain',
      ),
    ];

    expect(configs.map((config) => config.toJson()), everyElement(isNotEmpty));
    expect(content.map((item) => item.toJson()), everyElement(isNotEmpty));
    expect(() => McpSseServerConfig(url: ''), throwsArgumentError);
    expect(
      () => SdkMcpServer(
        name: 'duplicate',
        tools: [
          SdkMcpTool(
            name: 'same',
            description: '',
            inputSchema: const {},
            handler: (_) async => McpToolResult(content: const []),
          ),
          SdkMcpTool(
            name: 'same',
            description: '',
            inputSchema: const {},
            handler: (_) async => McpToolResult(content: const []),
          ),
        ],
      ),
      throwsArgumentError,
    );
  });

  test('decodes a complete MCP status response', () {
    final status = McpStatus.fromJson({
      'mcpServers': [
        {
          'name': 'server',
          'status': 'connected',
          'serverInfo': {'name': 'server', 'version': '1.0'},
          'config': {'type': 'http'},
          'scope': 'project',
          'tools': [
            {
              'name': 'lookup',
              'description': 'Lookup',
              'annotations': {'readOnlyHint': true},
            },
          ],
        },
        {'name': 'disabled', 'status': 'disabled', 'error': null},
      ],
    });

    expect(status.servers, hasLength(2));
    expect(status.servers.first.serverInfo?.version, '1.0');
    expect(status.servers.first.tools.single.annotations, isNotNull);
  });

  test('decodes a complete context usage response', () {
    final usage = ContextUsage.fromJson({
      'categories': [
        {'name': 'system', 'tokens': 10, 'color': 'blue'},
      ],
      'totalTokens': 10,
      'maxTokens': 100,
      'rawMaxTokens': 120,
      'percentage': 10,
      'model': 'claude',
      'isAutoCompactEnabled': true,
      'mcpTools': [
        {
          'name': 'lookup',
          'tokens': 2,
          'serverName': 'server',
          'isLoaded': true,
        },
      ],
      'memoryFiles': [
        {'path': '/tmp/CLAUDE.md', 'type': 'project', 'tokens': 3},
      ],
      'agents': [
        {'agentType': 'reviewer', 'source': 'sdk', 'tokens': 4},
      ],
      'gridRows': [
        [
          {'tokens': 1},
        ],
      ],
      'autoCompactThreshold': 90,
      'deferredBuiltinTools': [
        {'name': 'WebFetch'},
      ],
      'systemTools': [
        {'name': 'Read'},
      ],
      'systemPromptSections': [
        {'name': 'base'},
      ],
      'slashCommands': {'count': 1},
      'skills': {'count': 2},
      'messageBreakdown': {'user': 5},
      'apiUsage': {'inputTokens': 4},
    });

    expect(usage.categories.single.color, 'blue');
    expect(usage.mcpTools.single.serverName, 'server');
    expect(usage.memoryFiles.single.path, '/tmp/CLAUDE.md');
    expect(usage.agents.single.agentType, 'reviewer');
    expect(usage.agents.single.tokens, 4);
    expect(usage.rawMaxTokens, 120);
    expect(usage.isAutoCompactEnabled, isTrue);
    expect(usage.gridRows.single.single, containsPair('tokens', 1));
    expect(usage.autoCompactThreshold, 90);
    expect(usage.deferredBuiltinTools, hasLength(1));
    expect(usage.systemTools, hasLength(1));
    expect(usage.systemPromptSections, hasLength(1));
    expect(usage.slashCommands, containsPair('count', 1));
    expect(usage.skills, containsPair('count', 2));
    expect(usage.messageBreakdown, containsPair('user', 5));
    expect(usage.apiUsage, containsPair('inputTokens', 4));
  });

  test('sandbox and agent option objects cover every current field', () {
    final network = SandboxNetworkConfig(
      allowedDomains: const ['allowed.example'],
      deniedDomains: const ['denied.example'],
      allowManagedDomainsOnly: true,
      allowedUnixSockets: const ['/tmp/socket'],
      allowAllUnixSockets: false,
      allowLocalBinding: true,
      allowedMachServices: const ['com.example.*'],
      httpProxyPort: 8080,
      socksProxyPort: 1080,
    );
    final sandbox = SandboxSettings(
      isEnabled: true,
      autoAllowBashIfSandboxed: true,
      excludedCommands: const ['docker'],
      allowUnsandboxedCommands: false,
      network: network,
      ignoreViolations: SandboxIgnoreViolations(
        files: const ['/tmp/cache'],
        networkHosts: const ['localhost'],
      ),
      enableWeakerNestedSandbox: true,
    );
    final agent = AgentDefinition(
      description: 'description',
      prompt: 'prompt',
      tools: const ['Read'],
      disallowedTools: const ['Bash'],
      model: 'sonnet',
      skills: const ['review'],
      memory: SettingSource.project,
      mcpServers: [
        AgentMcpServer.inline(
          'server',
          McpSseServerConfig(url: 'https://example.com'),
        ),
      ],
      initialPrompt: 'start',
      maxTurns: 2,
      runsInBackground: true,
      numericEffort: 5,
      permissionMode: PermissionMode.plan,
    );

    expect(network.toJson(), hasLength(9));
    expect(sandbox.toJson(), containsPair('enableWeakerNestedSandbox', true));
    expect(agent.toJson(), containsPair('background', true));
    expect(agent.toJson(), containsPair('effort', 5));
  });

  test('SDK exception strings preserve diagnostic fields', () {
    final errors = <ClaudeAgentException>[
      const CliConnectionException('connection'),
      CliNotFoundException(cliPath: '/missing/claude'),
      CliProcessException('failed', exitCode: 1, stderr: 'details'),
      CliJsonDecodeException(line: 'not-json', cause: const FormatException()),
      const MessageParseException('message'),
      const ControlProtocolException('control'),
      const SessionException('session'),
    ];

    expect(errors.map((error) => error.toString()), everyElement(isNotEmpty));
    expect((errors[2] as CliProcessException).exitCode, 1);
  });
}
