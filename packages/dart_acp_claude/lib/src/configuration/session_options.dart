import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import 'agent_options.dart';

/// Serializable Claude options accepted through ACP session metadata.
///
/// The wire shape matches the upstream adapter's
/// `_meta.claudeCode.options` extension. Callback-bearing SDK options remain
/// process-owned because JSON metadata cannot carry Dart functions.
final class ClaudeAcpSessionOptions {
  ClaudeAcpSessionOptions._({
    required this.additionalRoots,
    required this.disableBuiltInTools,
    required this.emitRawSdkMessages,
    this.resume,
    this.resumeSessionAt,
    this.tools,
    this.agent,
    this.agents,
    this.allowedTools,
    this.disallowedTools,
    this.toolAliases,
    this.toolConfig,
    this.systemPrompt,
    this.mcpServers,
    this.strictMcpConfig,
    this.planModeInstructions,
    this.maxTurns,
    this.maxBudgetUsd,
    this.taskBudget,
    this.model,
    this.fallbackModel,
    this.betas,
    this.settings,
    this.inlineSettings,
    this.managedSettings,
    this.additionalDirectories,
    this.environment,
    this.extraArguments,
    this.maxBufferSize,
    this.includeHookEvents,
    this.forwardSubagentText,
    this.promptSuggestions,
    this.agentProgressSummaries,
    this.settingSources,
    this.skills,
    this.sandbox,
    this.plugins,
    this.user,
    this.title,
    this.persistSession,
    this.debug,
    this.debugFile,
    this.thinking,
    this.effort,
    this.outputFormat,
    this.enableFileCheckpointing,
  });

  /// Decodes the adapter extension from an ACP `_meta` object.
  factory ClaudeAcpSessionOptions.fromMeta(AcpJsonObject? meta) {
    final root = meta?.toObject() ?? const <String, Object?>{};
    final claudeCode = _optionalMap(root, 'claudeCode');
    final rawOptions = _optionalMap(claudeCode, 'options');
    final settingsValue = rawOptions?['settings'];
    final optionsPrompt = rawOptions?['systemPrompt'];
    final outerPrompt = root['systemPrompt'];
    return ClaudeAcpSessionOptions._(
      additionalRoots: _strings(root['additionalRoots'], 'additionalRoots'),
      disableBuiltInTools: _boolean(root, 'disableBuiltInTools') ?? false,
      emitRawSdkMessages: _rawMessageSelection(
        claudeCode?['emitRawSDKMessages'],
      ),
      resume: _string(rawOptions, 'resume'),
      resumeSessionAt: _string(rawOptions, 'resumeSessionAt'),
      tools: rawOptions?.containsKey('tools') ?? false
          ? _tools(rawOptions!['tools'])
          : null,
      agent: _string(rawOptions, 'agent'),
      agents: _agents(rawOptions?['agents']),
      allowedTools: _optionalStrings(rawOptions, 'allowedTools'),
      disallowedTools: _optionalStrings(rawOptions, 'disallowedTools'),
      toolAliases: _stringMap(rawOptions?['toolAliases'], 'toolAliases'),
      toolConfig: _toolConfig(rawOptions?['toolConfig']),
      systemPrompt: optionsPrompt != null
          ? _systemPrompt(optionsPrompt)
          : outerPrompt != null
          ? _systemPrompt(outerPrompt)
          : null,
      mcpServers: _mcpServers(rawOptions?['mcpServers']),
      strictMcpConfig: _boolean(rawOptions, 'strictMcpConfig'),
      planModeInstructions: _string(rawOptions, 'planModeInstructions'),
      maxTurns: _integer(rawOptions, 'maxTurns'),
      maxBudgetUsd: _number(rawOptions, 'maxBudgetUsd'),
      taskBudget: _taskBudget(rawOptions?['taskBudget']),
      model: _string(rawOptions, 'model'),
      fallbackModel: _string(rawOptions, 'fallbackModel'),
      betas: _betas(rawOptions?['betas']),
      settings: settingsValue is String ? settingsValue : null,
      inlineSettings: settingsValue is Map<Object?, Object?>
          ? _jsonMap(settingsValue, 'settings')
          : null,
      managedSettings: _optionalJsonMap(rawOptions, 'managedSettings'),
      additionalDirectories: _optionalStrings(
        rawOptions,
        'additionalDirectories',
      ),
      environment: _nullableStringMap(rawOptions?['env'], 'env'),
      extraArguments: _nullableStringMap(rawOptions?['extraArgs'], 'extraArgs'),
      maxBufferSize: _integer(rawOptions, 'maxBufferSize'),
      includeHookEvents: _boolean(rawOptions, 'includeHookEvents'),
      forwardSubagentText: _boolean(rawOptions, 'forwardSubagentText'),
      promptSuggestions: _boolean(rawOptions, 'promptSuggestions'),
      agentProgressSummaries: _boolean(rawOptions, 'agentProgressSummaries'),
      settingSources: _settingSources(rawOptions?['settingSources']),
      skills: _skills(rawOptions?['skills']),
      sandbox: _sandbox(rawOptions?['sandbox']),
      plugins: _plugins(rawOptions?['plugins']),
      user: _string(rawOptions, 'user'),
      title: _string(rawOptions, 'title'),
      persistSession: _boolean(rawOptions, 'persistSession'),
      debug: _boolean(rawOptions, 'debug'),
      debugFile: _string(rawOptions, 'debugFile'),
      thinking: _thinking(rawOptions?['thinking']),
      effort: _effort(rawOptions?['effort']),
      outputFormat: _outputFormat(rawOptions?['outputFormat']),
      enableFileCheckpointing: _boolean(rawOptions, 'enableFileCheckpointing'),
    );
  }

  /// Legacy additional roots from the ACP extension.
  final List<String> additionalRoots;

  /// Legacy request to disable all built-in tools.
  final bool disableBuiltInTools;

  /// Per-session raw SDK-message selection.
  final Object emitRawSdkMessages;

  /// Session identifier or title to resume from `session/new`.
  final String? resume;

  /// Assistant UUID at which a resumed transcript is truncated.
  final String? resumeSessionAt;

  /// Built-in tool selection.
  final ToolConfiguration? tools;

  /// Main-thread programmatic agent.
  final String? agent;

  /// Programmatic subagent definitions.
  final Map<String, AgentDefinition>? agents;

  /// Auto-approved tools.
  final List<String>? allowedTools;

  /// Hidden tools.
  final List<String>? disallowedTools;

  /// Tool-name aliases.
  final Map<String, String>? toolAliases;

  /// Built-in tool behavior.
  final BuiltinToolConfig? toolConfig;

  /// System prompt override.
  final SystemPrompt? systemPrompt;

  /// Additional MCP servers merged with ACP servers.
  final Map<String, McpServerConfig>? mcpServers;

  /// Whether only explicitly supplied MCP servers are loaded.
  final bool? strictMcpConfig;

  /// Plan-mode implementation instructions.
  final String? planModeInstructions;

  /// Maximum turns.
  final int? maxTurns;

  /// Maximum spend in USD.
  final double? maxBudgetUsd;

  /// API-side task-token budget.
  final TaskBudget? taskBudget;

  /// Primary model.
  final String? model;

  /// Fallback model.
  final String? fallbackModel;

  /// Enabled SDK beta features.
  final List<SdkBeta>? betas;

  /// Settings path or JSON text.
  final String? settings;

  /// Inline flag-tier settings.
  final Map<String, Object?>? inlineSettings;

  /// Parent-managed policy settings.
  final Map<String, Object?>? managedSettings;

  /// Additional SDK directories merged with ACP directories.
  final List<String>? additionalDirectories;

  /// Child environment additions.
  final Map<String, String?>? environment;

  /// Extra CLI arguments.
  final Map<String, String?>? extraArguments;

  /// Maximum stdout frame size.
  final int? maxBufferSize;

  /// Whether hook lifecycle messages are emitted.
  final bool? includeHookEvents;

  /// Whether complete subagent transcripts are forwarded.
  final bool? forwardSubagentText;

  /// Whether next-prompt suggestions are emitted.
  final bool? promptSuggestions;

  /// Whether subagents emit generated progress summaries.
  final bool? agentProgressSummaries;

  /// Filesystem settings tiers.
  final List<SettingSource>? settingSources;

  /// Main-session skills.
  final SkillsConfiguration? skills;

  /// Command sandbox behavior.
  final SandboxSettings? sandbox;

  /// Local plugins.
  final List<SdkPluginConfig>? plugins;

  /// Operating-system user for the Claude subprocess.
  final String? user;

  /// User-facing session title.
  final String? title;

  /// Whether the transcript is persisted.
  final bool? persistSession;

  /// Whether debug logging is enabled.
  final bool? debug;

  /// Debug log path.
  final String? debugFile;

  /// Thinking behavior.
  final ThinkingConfig? thinking;

  /// Reasoning effort.
  final EffortLevel? effort;

  /// Structured JSON output.
  final JsonSchemaOutputFormat? outputFormat;

  /// Whether file checkpointing is enabled.
  final bool? enableFileCheckpointing;
}

Object _rawMessageSelection(Object? value) {
  if (value == null || value == false) return false;
  if (value == true) return true;
  if (value is! List<Object?>) {
    throw const FormatException(
      'claudeCode.emitRawSDKMessages must be a boolean or array',
    );
  }
  return List<ClaudeSdkMessageFilter>.unmodifiable(
    value.map((item) {
      final map = _jsonMap(item, 'emitRawSDKMessages filter');
      return ClaudeSdkMessageFilter(
        type: _requiredString(map, 'type'),
        subtype: _string(map, 'subtype'),
        origin: _string(map, 'origin'),
      );
    }),
  );
}

ToolConfiguration? _tools(Object? value) {
  if (value is List<Object?>) {
    return ToolConfiguration.explicit(
      value
          .map((item) {
            if (item is! String) {
              throw const FormatException('tools must contain only strings');
            }
            return item;
          })
          .toList(growable: false),
    );
  }
  final map = _jsonMap(value, 'tools');
  if (map['type'] == 'preset' && map['preset'] == 'claude_code') {
    return const ToolConfiguration.claudeCode();
  }
  throw const FormatException('Unsupported tools value');
}

SystemPrompt _systemPrompt(Object? value) {
  if (value is String) return SystemPrompt.text(value);
  if (value is List<Object?>) {
    return SystemPrompt.blocks(
      value
          .map((item) {
            if (item is! String) {
              throw const FormatException(
                'systemPrompt blocks must contain only strings',
              );
            }
            return item;
          })
          .toList(growable: false),
    );
  }
  final map = _jsonMap(value, 'systemPrompt');
  if (map['type'] == 'preset' && map['preset'] == 'claude_code') {
    return SystemPrompt.claudeCode(
      append: _string(map, 'append'),
      excludeDynamicSections: _boolean(map, 'excludeDynamicSections'),
    );
  }
  throw const FormatException('Unsupported systemPrompt value');
}

Map<String, AgentDefinition>? _agents(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'agents');
  return Map<String, AgentDefinition>.unmodifiable(
    map.map((name, raw) {
      final agent = _jsonMap(raw, 'agents.$name');
      final effort = agent['effort'];
      return MapEntry(
        name,
        AgentDefinition(
          description: _requiredString(agent, 'description'),
          prompt: _requiredString(agent, 'prompt'),
          tools: _optionalStrings(agent, 'tools'),
          disallowedTools: _optionalStrings(agent, 'disallowedTools'),
          model: _string(agent, 'model'),
          criticalSystemReminder: _string(
            agent,
            'criticalSystemReminder_EXPERIMENTAL',
          ),
          skills: _optionalStrings(agent, 'skills'),
          memory: _settingSource(agent['memory']),
          mcpServers: _agentMcpServers(agent['mcpServers']),
          initialPrompt: _string(agent, 'initialPrompt'),
          maxTurns: _integer(agent, 'maxTurns'),
          runsInBackground: _boolean(agent, 'background'),
          effort: effort is String ? _effort(effort) : null,
          numericEffort: effort is int ? effort : null,
          permissionMode: _permissionMode(agent['permissionMode']),
          observer: _string(agent, 'observer'),
          observerMessage: _string(agent, 'observerMessage'),
        ),
      );
    }),
  );
}

List<AgentMcpServer>? _agentMcpServers(Object? value) {
  if (value == null) return null;
  if (value is! List<Object?>) {
    throw const FormatException('agent mcpServers must be an array');
  }
  return List<AgentMcpServer>.unmodifiable(
    value.map((item) {
      if (item is String) return AgentMcpServer.named(item);
      final map = _jsonMap(item, 'agent mcpServer');
      if (map.length != 1) {
        throw const FormatException(
          'inline agent mcpServer must have one named entry',
        );
      }
      final entry = map.entries.single;
      return AgentMcpServer.inline(
        entry.key,
        _mcpServer(entry.value, 'agent mcpServers.${entry.key}'),
      );
    }),
  );
}

Map<String, McpServerConfig>? _mcpServers(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'mcpServers');
  return Map<String, McpServerConfig>.unmodifiable(
    map.map((name, raw) => MapEntry(name, _mcpServer(raw, 'mcpServers.$name'))),
  );
}

McpServerConfig _mcpServer(Object? value, String context) {
  final map = _jsonMap(value, context);
  final type = _string(map, 'type');
  final timeout = _integer(map, 'timeout');
  final duration = timeout == null ? null : Duration(milliseconds: timeout);
  if (type == 'http' || type == 'sse' || map.containsKey('url')) {
    final url = _requiredString(map, 'url');
    final headers = _stringMap(map['headers'], '$context.headers') ?? const {};
    final tools = _mcpToolPolicies(map['tools'], '$context.tools');
    return type == 'sse'
        ? McpSseServerConfig(
            url: url,
            headers: headers,
            tools: tools,
            timeout: duration,
            alwaysLoad: _boolean(map, 'alwaysLoad'),
          )
        : McpHttpServerConfig(
            url: url,
            headers: headers,
            tools: tools,
            timeout: duration,
            alwaysLoad: _boolean(map, 'alwaysLoad'),
          );
  }
  return McpStdioServerConfig(
    command: _requiredString(map, 'command'),
    arguments: _optionalStrings(map, 'args') ?? const [],
    environment: _stringMap(map['env'], '$context.env') ?? const {},
    timeout: duration,
    alwaysLoad: _boolean(map, 'alwaysLoad'),
  );
}

List<McpServerToolPolicy> _mcpToolPolicies(Object? value, String context) {
  if (value == null) return const <McpServerToolPolicy>[];
  if (value is! List<Object?>) {
    throw FormatException('$context must be an array');
  }
  return List<McpServerToolPolicy>.unmodifiable(
    value.map((item) {
      final map = _jsonMap(item, context);
      return McpServerToolPolicy(
        name: _requiredString(map, 'name'),
        permissionPolicy: _string(map, 'permission_policy'),
        organizationMaximumPermission: _string(map, 'org_max_permission'),
      );
    }),
  );
}

BuiltinToolConfig? _toolConfig(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'toolConfig');
  final ask = _optionalMap(map, 'askUserQuestion');
  final format = _string(ask, 'previewFormat');
  return BuiltinToolConfig(
    questionPreviewFormat: switch (format) {
      'markdown' => QuestionPreviewFormat.markdown,
      'html' => QuestionPreviewFormat.html,
      null => null,
      _ => throw FormatException('Unsupported question preview: $format'),
    },
  );
}

List<SdkBeta>? _betas(Object? value) {
  if (value == null) return null;
  if (value is! List<Object?>) {
    throw const FormatException('betas must be an array');
  }
  return List<SdkBeta>.unmodifiable(
    value.map((item) {
      if (item == SdkBeta.context1m.wireValue) return SdkBeta.context1m;
      throw FormatException('Unsupported SDK beta: $item');
    }),
  );
}

TaskBudget? _taskBudget(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'taskBudget');
  return TaskBudget(_requiredInt(map, 'total'));
}

List<SettingSource>? _settingSources(Object? value) {
  if (value == null) return null;
  if (value is! List<Object?>) {
    throw const FormatException('settingSources must be an array');
  }
  return List<SettingSource>.unmodifiable(value.map(_settingSourceRequired));
}

SettingSource? _settingSource(Object? value) =>
    value == null ? null : _settingSourceRequired(value);

SettingSource _settingSourceRequired(Object? value) {
  if (value is String) {
    for (final source in SettingSource.values) {
      if (source.name == value) return source;
    }
  }
  throw FormatException('Unsupported setting source: $value');
}

SkillsConfiguration? _skills(Object? value) {
  if (value == null) return null;
  if (value == 'all') return const SkillsConfiguration.all();
  if (value is List<Object?>) {
    return SkillsConfiguration.named(
      value
          .map((item) {
            if (item is! String) {
              throw const FormatException('skills must contain only strings');
            }
            return item;
          })
          .toList(growable: false),
    );
  }
  throw const FormatException('skills must be "all" or an array');
}

ThinkingConfig? _thinking(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'thinking');
  final display = switch (_string(map, 'display')) {
    'summarized' => ThinkingDisplay.summarized,
    'omitted' => ThinkingDisplay.omitted,
    null => null,
    final value => throw FormatException(
      'Unsupported thinking display: $value',
    ),
  };
  return switch (_requiredString(map, 'type')) {
    'adaptive' => ThinkingConfig.adaptive(display: display),
    'enabled' => ThinkingConfig.enabled(
      budget: _requiredInt(map, 'budgetTokens'),
      display: display,
    ),
    'disabled' => const ThinkingConfig.disabled(),
    final value => throw FormatException('Unsupported thinking type: $value'),
  };
}

EffortLevel? _effort(Object? value) {
  if (value == null) return null;
  if (value is String) {
    for (final effort in EffortLevel.values) {
      if (effort.name == value) return effort;
    }
  }
  throw FormatException('Unsupported effort: $value');
}

PermissionMode? _permissionMode(Object? value) {
  if (value == null) return null;
  if (value is String) {
    for (final mode in PermissionMode.values) {
      if (mode.wireValue == value) return mode;
    }
  }
  throw FormatException('Unsupported permission mode: $value');
}

JsonSchemaOutputFormat? _outputFormat(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'outputFormat');
  if (map['type'] != 'json_schema') {
    throw const FormatException('Only json_schema output is supported');
  }
  return JsonSchemaOutputFormat(_jsonMap(map['schema'], 'outputFormat.schema'));
}

List<SdkPluginConfig>? _plugins(Object? value) {
  if (value == null) return null;
  if (value is! List<Object?>) {
    throw const FormatException('plugins must be an array');
  }
  return List<SdkPluginConfig>.unmodifiable(
    value.map((item) {
      final map = _jsonMap(item, 'plugin');
      if (map['type'] != null && map['type'] != 'local') {
        throw FormatException('Unsupported plugin type: ${map['type']}');
      }
      return SdkPluginConfig(
        _requiredString(map, 'path'),
        skipMcpDiscovery: _boolean(map, 'skipMcpDiscovery') ?? false,
      );
    }),
  );
}

SandboxSettings? _sandbox(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'sandbox');
  return SandboxSettings(
    isEnabled: _boolean(map, 'enabled'),
    failIfUnavailable: _boolean(map, 'failIfUnavailable'),
    autoAllowBashIfSandboxed: _boolean(map, 'autoAllowBashIfSandboxed'),
    excludedCommands: _optionalStrings(map, 'excludedCommands') ?? const [],
    allowUnsandboxedCommands: _boolean(map, 'allowUnsandboxedCommands'),
    network: _sandboxNetwork(map['network']),
    filesystem: _sandboxFilesystem(map['filesystem']),
    credentials: _sandboxCredentials(map['credentials']),
    ignoreViolations: _sandboxIgnore(map['ignoreViolations']),
    enableWeakerNestedSandbox: _boolean(map, 'enableWeakerNestedSandbox'),
    enableWeakerNetworkIsolation: _boolean(map, 'enableWeakerNetworkIsolation'),
    allowAppleEvents: _boolean(map, 'allowAppleEvents'),
    ripgrep: _sandboxRipgrep(map['ripgrep']),
    bwrapPath: _string(map, 'bwrapPath'),
    socatPath: _string(map, 'socatPath'),
  );
}

SandboxNetworkConfig? _sandboxNetwork(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'sandbox.network');
  final tls = _optionalMap(map, 'tlsTerminate');
  return SandboxNetworkConfig(
    allowedDomains: _optionalStrings(map, 'allowedDomains') ?? const [],
    deniedDomains: _optionalStrings(map, 'deniedDomains') ?? const [],
    allowManagedDomainsOnly: _boolean(map, 'allowManagedDomainsOnly'),
    strictAllowlist: _boolean(map, 'strictAllowlist'),
    allowedUnixSockets: _optionalStrings(map, 'allowUnixSockets') ?? const [],
    allowAllUnixSockets: _boolean(map, 'allowAllUnixSockets'),
    allowLocalBinding: _boolean(map, 'allowLocalBinding'),
    allowedMachServices: _optionalStrings(map, 'allowMachLookup') ?? const [],
    httpProxyPort: _integer(map, 'httpProxyPort'),
    socksProxyPort: _integer(map, 'socksProxyPort'),
    tlsCaCertificatePath: _string(tls, 'caCertPath'),
    tlsCaKeyPath: _string(tls, 'caKeyPath'),
  );
}

SandboxFilesystemConfig? _sandboxFilesystem(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'sandbox.filesystem');
  return SandboxFilesystemConfig(
    allowedWritePaths: _optionalStrings(map, 'allowWrite') ?? const [],
    deniedWritePaths: _optionalStrings(map, 'denyWrite') ?? const [],
    deniedReadPaths: _optionalStrings(map, 'denyRead') ?? const [],
    allowedReadPaths: _optionalStrings(map, 'allowRead') ?? const [],
    allowManagedReadPathsOnly: _boolean(map, 'allowManagedReadPathsOnly'),
    disabled: _boolean(map, 'disabled'),
  );
}

SandboxCredentialsConfig? _sandboxCredentials(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'sandbox.credentials');
  final files = map['files'];
  final variables = map['envVars'];
  return SandboxCredentialsConfig(
    files: files is List<Object?>
        ? files
              .map((item) {
                final entry = _jsonMap(item, 'sandbox.credentials.files');
                return SandboxCredentialFile(_requiredString(entry, 'path'));
              })
              .toList(growable: false)
        : const [],
    environmentVariables: variables is List<Object?>
        ? variables
              .map((item) {
                final entry = _jsonMap(item, 'sandbox.credentials.envVars');
                return SandboxCredentialEnvironmentVariable(
                  name: _requiredString(entry, 'name'),
                  mode: switch (_string(entry, 'mode')) {
                    'mask' => SandboxCredentialEnvironmentMode.mask,
                    'deny' || null => SandboxCredentialEnvironmentMode.deny,
                    final mode => throw FormatException(
                      'Unsupported credential mode: $mode',
                    ),
                  },
                  injectHosts:
                      _optionalStrings(entry, 'injectHosts') ?? const [],
                );
              })
              .toList(growable: false)
        : const [],
    allowPlaintextInjection: _boolean(map, 'allowPlaintextInject'),
  );
}

SandboxIgnoreViolations? _sandboxIgnore(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'sandbox.ignoreViolations');
  return SandboxIgnoreViolations(
    files: _optionalStrings(map, 'file') ?? const [],
    networkHosts: _optionalStrings(map, 'network') ?? const [],
  );
}

SandboxRipgrepConfig? _sandboxRipgrep(Object? value) {
  if (value == null) return null;
  final map = _jsonMap(value, 'sandbox.ripgrep');
  return SandboxRipgrepConfig(
    command: _requiredString(map, 'command'),
    arguments: _optionalStrings(map, 'args') ?? const [],
  );
}

Map<String, Object?> _jsonMap(Object? value, String context) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException('$context must be an object');
  }
  return <String, Object?>{
    for (final entry in value.entries)
      if (entry.key is String) entry.key! as String: entry.value,
  };
}

Map<String, Object?>? _optionalMap(Map<String, Object?>? map, String key) {
  final value = map?[key];
  return value == null ? null : _jsonMap(value, key);
}

Map<String, Object?>? _optionalJsonMap(Map<String, Object?>? map, String key) =>
    map?[key] == null ? null : _jsonMap(map![key], key);

String _requiredString(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is String) return value;
  throw FormatException('$key must be a string');
}

int _requiredInt(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is int) return value;
  throw FormatException('$key must be an integer');
}

String? _string(Map<String, Object?>? map, String key) {
  final value = map?[key];
  if (value == null) return null;
  if (value is String) return value;
  throw FormatException('$key must be a string');
}

bool? _boolean(Map<String, Object?>? map, String key) {
  final value = map?[key];
  if (value == null) return null;
  if (value is bool) return value;
  throw FormatException('$key must be a boolean');
}

int? _integer(Map<String, Object?>? map, String key) {
  final value = map?[key];
  if (value == null) return null;
  if (value is int) return value;
  throw FormatException('$key must be an integer');
}

double? _number(Map<String, Object?>? map, String key) {
  final value = map?[key];
  if (value == null) return null;
  if (value is num) return value.toDouble();
  throw FormatException('$key must be a number');
}

List<String> _strings(Object? value, String context) {
  if (value == null) return const <String>[];
  if (value is! List<Object?>) {
    throw FormatException('$context must be an array');
  }
  return List<String>.unmodifiable(
    value.map((item) {
      if (item is! String) {
        throw FormatException('$context must contain only strings');
      }
      return item;
    }),
  );
}

List<String>? _optionalStrings(Map<String, Object?>? map, String key) =>
    map?.containsKey(key) ?? false ? _strings(map![key], key) : null;

Map<String, String>? _stringMap(Object? value, String context) {
  if (value == null) return null;
  final map = _jsonMap(value, context);
  return Map<String, String>.unmodifiable(
    map.map((key, value) {
      if (value is! String) {
        throw FormatException('$context.$key must be a string');
      }
      return MapEntry(key, value);
    }),
  );
}

Map<String, String?>? _nullableStringMap(Object? value, String context) {
  if (value == null) return null;
  final map = _jsonMap(value, context);
  return Map<String, String?>.unmodifiable(
    map.map((key, value) {
      if (value != null && value is! String) {
        throw FormatException('$context.$key must be a string or null');
      }
      return MapEntry(key, value as String?);
    }),
  );
}
