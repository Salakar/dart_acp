import 'hooks.dart';
import 'json.dart';
import 'mcp.dart';
import 'permissions.dart';
import 'sessions/session_store.dart';
import 'uuid.dart';

/// How much reasoning effort the model should apply.
enum EffortLevel {
  /// Minimal reasoning.
  low,

  /// Moderate reasoning.
  medium,

  /// Deep reasoning.
  high,

  /// Extended reasoning on models that support it.
  xhigh,

  /// Maximum available reasoning effort.
  max,
}

/// Filesystem settings layer loaded by the CLI.
enum SettingSource {
  /// User-global settings.
  user,

  /// Versioned project settings.
  project,

  /// Unversioned project-local settings.
  local,
}

/// Opt-in SDK beta feature.
enum SdkBeta {
  /// Enables the one-million-token context window where supported.
  context1m('context-1m-2025-08-07');

  const SdkBeta(this.wireValue);

  /// Beta header value.
  final String wireValue;
}

/// Base set of built-in tools made available to the model.
sealed class ToolConfiguration {
  const ToolConfiguration();

  /// Uses the default Claude Code tool set.
  const factory ToolConfiguration.claudeCode() = ClaudeCodeTools;

  /// Uses exactly [tools]. An empty list disables all built-in tools.
  factory ToolConfiguration.explicit(List<String> tools) = ExplicitTools;
}

/// The default Claude Code tool set.
final class ClaudeCodeTools extends ToolConfiguration {
  /// Creates the default tool set.
  const ClaudeCodeTools();
}

/// An explicit built-in tool set.
final class ExplicitTools extends ToolConfiguration {
  /// Creates an explicit tool set.
  ExplicitTools(List<String> tools) : tools = List<String>.unmodifiable(tools);

  /// Tool names.
  final List<String> tools;
}

/// System prompt configuration.
sealed class SystemPrompt {
  const SystemPrompt();

  /// Replaces the system prompt with [text].
  const factory SystemPrompt.text(String text) = TextSystemPrompt;

  /// Uses the default Claude Code prompt.
  const factory SystemPrompt.claudeCode({
    String? append,
    bool? excludeDynamicSections,
  }) = ClaudeCodeSystemPrompt;

  /// Loads the system prompt from [path].
  const factory SystemPrompt.file(String path) = FileSystemPrompt;
}

/// A literal system prompt.
final class TextSystemPrompt extends SystemPrompt {
  /// Creates a literal system prompt.
  const TextSystemPrompt(this.text);

  /// Prompt text.
  final String text;
}

/// The default Claude Code prompt with optional changes.
final class ClaudeCodeSystemPrompt extends SystemPrompt {
  /// Creates a preset system prompt.
  const ClaudeCodeSystemPrompt({this.append, this.excludeDynamicSections});

  /// Text appended to the preset.
  final String? append;

  /// Whether per-user dynamic sections are moved to the first user message.
  final bool? excludeDynamicSections;
}

/// A system prompt loaded from a file.
final class FileSystemPrompt extends SystemPrompt {
  /// Creates a file prompt.
  const FileSystemPrompt(this.path);

  /// Prompt file path.
  final String path;
}

/// Model thinking text display behavior.
enum ThinkingDisplay {
  /// Return summarized thinking text.
  summarized,

  /// Return signatures without thinking text.
  omitted,
}

/// Thinking/reasoning configuration.
sealed class ThinkingConfig {
  const ThinkingConfig();

  /// Lets the model choose when and how much to think.
  const factory ThinkingConfig.adaptive({ThinkingDisplay? display}) =
      AdaptiveThinking;

  /// Uses a fixed positive token [budget].
  factory ThinkingConfig.enabled({
    required int budget,
    ThinkingDisplay? display,
  }) = EnabledThinking;

  /// Disables extended thinking.
  const factory ThinkingConfig.disabled() = DisabledThinking;
}

/// Adaptive thinking configuration.
final class AdaptiveThinking extends ThinkingConfig {
  /// Creates adaptive thinking.
  const AdaptiveThinking({this.display});

  /// Thinking text display behavior.
  final ThinkingDisplay? display;
}

/// Fixed-budget thinking configuration.
final class EnabledThinking extends ThinkingConfig {
  /// Creates fixed-budget thinking.
  EnabledThinking({required this.budget, this.display}) {
    if (budget <= 0) {
      throw ArgumentError.value(budget, 'budget', 'must be positive');
    }
  }

  /// Thinking token budget.
  final int budget;

  /// Thinking text display behavior.
  final ThinkingDisplay? display;
}

/// Disabled thinking configuration.
final class DisabledThinking extends ThinkingConfig {
  /// Creates disabled thinking.
  const DisabledThinking();
}

/// API-side token budget for a task.
final class TaskBudget {
  /// Creates a task budget.
  TaskBudget(this.totalTokens) {
    if (totalTokens <= 0) {
      throw ArgumentError.value(totalTokens, 'totalTokens', 'must be positive');
    }
  }

  /// Total available tokens.
  final int totalTokens;
}

/// Skill listing and tool configuration.
sealed class SkillsConfiguration {
  const SkillsConfiguration();

  /// Enables every discovered skill.
  const factory SkillsConfiguration.all() = AllSkills;

  /// Enables only [names]. An empty list hides all skills.
  factory SkillsConfiguration.named(List<String> names) = NamedSkills;
}

/// Enables every discovered skill.
final class AllSkills extends SkillsConfiguration {
  /// Creates an all-skills configuration.
  const AllSkills();
}

/// Enables an explicit skill allowlist.
final class NamedSkills extends SkillsConfiguration {
  /// Creates an explicit skill allowlist.
  NamedSkills(List<String> names) : names = List<String>.unmodifiable(names) {
    if (names.any((name) => name.isEmpty)) {
      throw ArgumentError.value(names, 'names', 'must not contain empty names');
    }
  }

  /// Enabled skill names.
  final List<String> names;
}

/// One MCP reference available to a programmatic subagent.
sealed class AgentMcpServer {
  const AgentMcpServer();

  /// Refers to a configured server by name.
  const factory AgentMcpServer.named(String name) = NamedAgentMcpServer;

  /// Defines one inline named server configuration.
  factory AgentMcpServer.inline(String name, McpServerConfig config) =
      InlineAgentMcpServer;

  /// Encodes this reference for the CLI initialize request.
  JsonValue toJson();
}

/// A named server reference.
final class NamedAgentMcpServer extends AgentMcpServer {
  /// Creates a named reference.
  const NamedAgentMcpServer(this.name);

  /// Server name.
  final String name;

  @override
  JsonValue toJson() => name;
}

/// An inline server reference.
final class InlineAgentMcpServer extends AgentMcpServer {
  /// Creates an inline server.
  InlineAgentMcpServer(this.name, this.config) {
    if (name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
  }

  /// Server name.
  final String name;

  /// Server configuration.
  final McpServerConfig config;

  @override
  JsonValue toJson() => {name: config.toJson()};
}

/// Definition of a programmatic subagent.
final class AgentDefinition {
  /// Creates an agent definition.
  AgentDefinition({
    required this.description,
    required this.prompt,
    List<String>? tools,
    List<String>? disallowedTools,
    this.model,
    List<String>? skills,
    this.memory,
    List<AgentMcpServer>? mcpServers,
    this.initialPrompt,
    this.maxTurns,
    this.runsInBackground,
    this.effort,
    this.numericEffort,
    this.permissionMode,
  }) : tools = tools == null ? null : List<String>.unmodifiable(tools),
       disallowedTools = disallowedTools == null
           ? null
           : List<String>.unmodifiable(disallowedTools),
       skills = skills == null ? null : List<String>.unmodifiable(skills),
       mcpServers = mcpServers == null
           ? null
           : List<AgentMcpServer>.unmodifiable(mcpServers) {
    if (description.isEmpty || prompt.isEmpty) {
      throw ArgumentError('Agent description and prompt must not be empty');
    }
    if (maxTurns != null && maxTurns! <= 0) {
      throw ArgumentError.value(maxTurns, 'maxTurns', 'must be positive');
    }
    if (effort != null && numericEffort != null) {
      throw ArgumentError('effort and numericEffort are mutually exclusive');
    }
  }

  /// When the agent should be used.
  final String description;

  /// Agent system prompt.
  final String prompt;

  /// Explicit tool set.
  final List<String>? tools;

  /// Tools hidden from the agent.
  final List<String>? disallowedTools;

  /// Model alias or full identifier.
  final String? model;

  /// Skills available to the agent.
  final List<String>? skills;

  /// Optional memory scope.
  final SettingSource? memory;

  /// Named or inline MCP servers.
  final List<AgentMcpServer>? mcpServers;

  /// Initial user prompt.
  final String? initialPrompt;

  /// Maximum turns.
  final int? maxTurns;

  /// Whether to start in the background.
  final bool? runsInBackground;

  /// Named effort level.
  final EffortLevel? effort;

  /// Numeric effort accepted by the CLI for an agent definition.
  final int? numericEffort;

  /// Agent permission mode.
  final PermissionMode? permissionMode;

  /// Encodes this definition for the CLI initialize request.
  JsonMap toJson() => {
    'description': description,
    'prompt': prompt,
    if (tools != null) 'tools': tools,
    if (disallowedTools != null) 'disallowedTools': disallowedTools,
    if (model != null) 'model': model,
    if (skills != null) 'skills': skills,
    if (memory != null) 'memory': memory!.name,
    if (mcpServers != null)
      'mcpServers': mcpServers!
          .map((server) => server.toJson())
          .toList(growable: false),
    if (initialPrompt != null) 'initialPrompt': initialPrompt,
    if (maxTurns != null) 'maxTurns': maxTurns,
    if (runsInBackground != null) 'background': runsInBackground,
    if (effort != null) 'effort': effort!.name,
    if (numericEffort != null) 'effort': numericEffort,
    if (permissionMode != null) 'permissionMode': permissionMode!.wireValue,
  };
}

/// Network options for the CLI command sandbox.
final class SandboxNetworkConfig {
  /// Creates sandbox network options.
  SandboxNetworkConfig({
    List<String> allowedDomains = const [],
    List<String> deniedDomains = const [],
    this.allowManagedDomainsOnly,
    List<String> allowedUnixSockets = const [],
    this.allowAllUnixSockets,
    this.allowLocalBinding,
    List<String> allowedMachServices = const [],
    this.httpProxyPort,
    this.socksProxyPort,
  }) : allowedDomains = List<String>.unmodifiable(allowedDomains),
       deniedDomains = List<String>.unmodifiable(deniedDomains),
       allowedUnixSockets = List<String>.unmodifiable(allowedUnixSockets),
       allowedMachServices = List<String>.unmodifiable(allowedMachServices);

  /// Allowed domain names.
  final List<String> allowedDomains;

  /// Always-denied domain names.
  final List<String> deniedDomains;

  /// Whether only managed settings may allow domains.
  final bool? allowManagedDomainsOnly;

  /// Accessible Unix socket paths.
  final List<String> allowedUnixSockets;

  /// Whether every Unix socket is accessible.
  final bool? allowAllUnixSockets;

  /// Whether local port binding is allowed.
  final bool? allowLocalBinding;

  /// Allowed macOS Mach/XPC service patterns.
  final List<String> allowedMachServices;

  /// Bring-your-own HTTP proxy port.
  final int? httpProxyPort;

  /// Bring-your-own SOCKS proxy port.
  final int? socksProxyPort;

  /// Encodes these options for Claude Code settings.
  JsonMap toJson() => {
    if (allowedDomains.isNotEmpty) 'allowedDomains': allowedDomains,
    if (deniedDomains.isNotEmpty) 'deniedDomains': deniedDomains,
    if (allowManagedDomainsOnly != null)
      'allowManagedDomainsOnly': allowManagedDomainsOnly,
    if (allowedUnixSockets.isNotEmpty) 'allowUnixSockets': allowedUnixSockets,
    if (allowAllUnixSockets != null) 'allowAllUnixSockets': allowAllUnixSockets,
    if (allowLocalBinding != null) 'allowLocalBinding': allowLocalBinding,
    if (allowedMachServices.isNotEmpty) 'allowMachLookup': allowedMachServices,
    if (httpProxyPort != null) 'httpProxyPort': httpProxyPort,
    if (socksProxyPort != null) 'socksProxyPort': socksProxyPort,
  };
}

/// Sandbox violations that should be ignored.
final class SandboxIgnoreViolations {
  /// Creates ignored violation patterns.
  SandboxIgnoreViolations({
    List<String> files = const [],
    List<String> networkHosts = const [],
  }) : files = List<String>.unmodifiable(files),
       networkHosts = List<String>.unmodifiable(networkHosts);

  /// Ignored file paths.
  final List<String> files;

  /// Ignored network hosts.
  final List<String> networkHosts;

  /// Encodes these ignore rules for Claude Code settings.
  JsonMap toJson() => {
    if (files.isNotEmpty) 'file': files,
    if (networkHosts.isNotEmpty) 'network': networkHosts,
  };
}

/// Bash sandbox behavior.
final class SandboxSettings {
  /// Creates sandbox settings.
  SandboxSettings({
    this.isEnabled,
    this.autoAllowBashIfSandboxed,
    List<String> excludedCommands = const [],
    this.allowUnsandboxedCommands,
    this.network,
    this.ignoreViolations,
    this.enableWeakerNestedSandbox,
  }) : excludedCommands = List<String>.unmodifiable(excludedCommands);

  /// Whether command sandboxing is enabled.
  final bool? isEnabled;

  /// Whether sandboxed Bash calls are auto-approved.
  final bool? autoAllowBashIfSandboxed;

  /// Commands launched outside the sandbox.
  final List<String> excludedCommands;

  /// Whether a command may explicitly bypass the sandbox.
  final bool? allowUnsandboxedCommands;

  /// Network options.
  final SandboxNetworkConfig? network;

  /// Ignored violation patterns.
  final SandboxIgnoreViolations? ignoreViolations;

  /// Whether to use a weaker nested sandbox in restricted containers.
  final bool? enableWeakerNestedSandbox;

  /// Encodes these sandbox settings for Claude Code.
  JsonMap toJson() => {
    if (isEnabled != null) 'enabled': isEnabled,
    if (autoAllowBashIfSandboxed != null)
      'autoAllowBashIfSandboxed': autoAllowBashIfSandboxed,
    if (excludedCommands.isNotEmpty) 'excludedCommands': excludedCommands,
    if (allowUnsandboxedCommands != null)
      'allowUnsandboxedCommands': allowUnsandboxedCommands,
    if (network != null) 'network': network!.toJson(),
    if (ignoreViolations != null)
      'ignoreViolations': ignoreViolations!.toJson(),
    if (enableWeakerNestedSandbox != null)
      'enableWeakerNestedSandbox': enableWeakerNestedSandbox,
  };
}

/// A local plugin directory loaded for one session.
final class SdkPluginConfig {
  /// Creates a local plugin configuration.
  SdkPluginConfig(this.path) {
    if (path.isEmpty) {
      throw ArgumentError.value(path, 'path', 'must not be empty');
    }
  }

  /// Local plugin path.
  final String path;
}

/// Structured JSON Schema output requested from the agent.
final class JsonSchemaOutputFormat {
  /// Creates a structured output format.
  JsonSchemaOutputFormat(JsonMap schema) : schema = immutableJsonMap(schema);

  /// Requested JSON Schema.
  final JsonMap schema;
}

/// Receives one framed stderr line from the CLI subprocess.
typedef StderrCallback = void Function(String line);

/// Complete configuration for one agent session.
final class ClaudeAgentOptions {
  /// Creates immutable agent options.
  ClaudeAgentOptions({
    this.tools,
    List<String> allowedTools = const [],
    this.systemPrompt,
    this.mcp,
    this.strictMcpConfig = false,
    this.permissionMode,
    this.continueSession = false,
    this.resume,
    this.sessionId,
    this.maxTurns,
    this.maxBudgetUsd,
    List<String> disallowedTools = const [],
    this.model,
    this.fallbackModel,
    List<SdkBeta> betas = const [],
    this.permissionPromptToolName,
    this.workingDirectory,
    this.cliPath,
    this.settings,
    List<String> addDirectories = const [],
    Map<String, String> environment = const {},
    Map<String, String?> extraArguments = const {},
    this.maxBufferSize,
    this.stderr,
    this.canUseTool,
    Map<HookEvent, List<HookMatcher>> hooks = const {},
    this.user,
    this.includePartialMessages = false,
    this.includeHookEvents = false,
    this.forkSession = false,
    Map<String, AgentDefinition> agents = const {},
    List<SettingSource>? settingSources,
    this.skills,
    this.sandbox,
    List<SdkPluginConfig> plugins = const [],
    this.thinking,
    this.effort,
    this.outputFormat,
    this.enableFileCheckpointing = false,
    this.sessionStore,
    this.sessionStoreFlush = SessionStoreFlushMode.batched,
    this.sessionLoadTimeout = const Duration(seconds: 60),
    this.taskBudget,
    this.initializeTimeout = const Duration(seconds: 60),
    this.controlRequestTimeout = const Duration(seconds: 60),
  }) : allowedTools = List<String>.unmodifiable(allowedTools),
       disallowedTools = List<String>.unmodifiable(disallowedTools),
       betas = List<SdkBeta>.unmodifiable(betas),
       addDirectories = List<String>.unmodifiable(addDirectories),
       environment = Map<String, String>.unmodifiable(environment),
       extraArguments = Map<String, String?>.unmodifiable(extraArguments),
       hooks = Map<HookEvent, List<HookMatcher>>.unmodifiable(
         hooks.map(
           (event, matchers) =>
               MapEntry(event, List<HookMatcher>.unmodifiable(matchers)),
         ),
       ),
       agents = Map<String, AgentDefinition>.unmodifiable(agents),
       settingSources = settingSources == null
           ? null
           : List<SettingSource>.unmodifiable(settingSources),
       plugins = List<SdkPluginConfig>.unmodifiable(plugins) {
    if (continueSession && resume != null) {
      throw ArgumentError('continueSession and resume are mutually exclusive');
    }
    if (sessionId != null && !isUuid(sessionId!)) {
      throw ArgumentError.value(sessionId, 'sessionId', 'must be a UUID');
    }
    if (maxTurns != null && maxTurns! <= 0) {
      throw ArgumentError.value(maxTurns, 'maxTurns', 'must be positive');
    }
    if (maxBudgetUsd != null && maxBudgetUsd! <= 0) {
      throw ArgumentError.value(
        maxBudgetUsd,
        'maxBudgetUsd',
        'must be positive',
      );
    }
    if (maxBufferSize != null && maxBufferSize! <= 0) {
      throw ArgumentError.value(
        maxBufferSize,
        'maxBufferSize',
        'must be positive',
      );
    }
    if (canUseTool != null && permissionPromptToolName != null) {
      throw ArgumentError(
        'canUseTool and permissionPromptToolName are mutually exclusive',
      );
    }
    if (sessionLoadTimeout.isNegative ||
        initializeTimeout <= Duration.zero ||
        controlRequestTimeout <= Duration.zero) {
      throw ArgumentError('SDK timeout values must not be negative or zero');
    }
    if (agents.keys.any((name) => name.isEmpty)) {
      throw ArgumentError.value(agents, 'agents', 'names must not be empty');
    }
  }

  /// Base built-in tool set.
  final ToolConfiguration? tools;

  /// Tools auto-approved without prompting.
  final List<String> allowedTools;

  /// System prompt behavior.
  final SystemPrompt? systemPrompt;

  /// MCP configuration.
  final McpConfiguration? mcp;

  /// Whether only [mcp] servers are loaded.
  final bool strictMcpConfig;

  /// Initial permission mode.
  final PermissionMode? permissionMode;

  /// Whether to continue the most recent session in the working directory.
  final bool continueSession;

  /// Session ID or title to resume.
  final String? resume;

  /// Explicit UUID for a new session.
  final String? sessionId;

  /// Maximum agent turns.
  final int? maxTurns;

  /// Maximum spend in US dollars.
  final double? maxBudgetUsd;

  /// Tools removed from the model context.
  final List<String> disallowedTools;

  /// Primary model alias or identifier.
  final String? model;

  /// Model used if the primary is unavailable.
  final String? fallbackModel;

  /// Enabled beta features.
  final List<SdkBeta> betas;

  /// MCP tool that receives permission prompts.
  final String? permissionPromptToolName;

  /// Child process working directory.
  final String? workingDirectory;

  /// Explicit Claude Code executable.
  final String? cliPath;

  /// Additional settings path or JSON object string.
  final String? settings;

  /// Additional accessible directories.
  final List<String> addDirectories;

  /// Child environment overrides.
  final Map<String, String> environment;

  /// Future CLI flags without leading `--`.
  final Map<String, String?> extraArguments;

  /// Maximum bytes in one stdout JSON frame.
  final int? maxBufferSize;

  /// Optional stderr line receiver.
  final StderrCallback? stderr;

  /// Runtime permission decision callback.
  final CanUseTool? canUseTool;

  /// SDK hook callbacks keyed by lifecycle event.
  final Map<HookEvent, List<HookMatcher>> hooks;

  /// Optional operating-system user for the child process.
  final String? user;

  /// Whether stream-event messages are included.
  final bool includePartialMessages;

  /// Whether hook lifecycle messages are included.
  final bool includeHookEvents;

  /// Whether a resumed session forks to a new ID.
  final bool forkSession;

  /// Programmatic subagent definitions.
  final Map<String, AgentDefinition> agents;

  /// Filesystem settings layers, or `null` for CLI defaults.
  final List<SettingSource>? settingSources;

  /// Main-session skill configuration.
  final SkillsConfiguration? skills;

  /// Command sandbox behavior.
  final SandboxSettings? sandbox;

  /// Local plugins.
  final List<SdkPluginConfig> plugins;

  /// Thinking behavior.
  final ThinkingConfig? thinking;

  /// Reasoning effort.
  final EffortLevel? effort;

  /// Requested structured output.
  final JsonSchemaOutputFormat? outputFormat;

  /// Whether file changes can be rewound.
  final bool enableFileCheckpointing;

  /// Optional external transcript store.
  final SessionStore? sessionStore;

  /// Transcript mirror flush policy.
  final SessionStoreFlushMode sessionStoreFlush;

  /// Timeout for each store call during resume materialization.
  final Duration sessionLoadTimeout;

  /// API-side task token budget.
  final TaskBudget? taskBudget;

  /// Initialization control request timeout.
  final Duration initializeTimeout;

  /// Default timeout for other control requests.
  final Duration controlRequestTimeout;

  /// Returns a copy repointed at a materialized session tree.
  ClaudeAgentOptions withMaterializedResume({
    required String configDirectory,
    required String resumeSessionId,
  }) => ClaudeAgentOptions(
    tools: tools,
    allowedTools: allowedTools,
    systemPrompt: systemPrompt,
    mcp: mcp,
    strictMcpConfig: strictMcpConfig,
    permissionMode: permissionMode,
    resume: resumeSessionId,
    sessionId: sessionId,
    maxTurns: maxTurns,
    maxBudgetUsd: maxBudgetUsd,
    disallowedTools: disallowedTools,
    model: model,
    fallbackModel: fallbackModel,
    betas: betas,
    permissionPromptToolName: permissionPromptToolName,
    workingDirectory: workingDirectory,
    cliPath: cliPath,
    settings: settings,
    addDirectories: addDirectories,
    environment: {...environment, 'CLAUDE_CONFIG_DIR': configDirectory},
    extraArguments: extraArguments,
    maxBufferSize: maxBufferSize,
    stderr: stderr,
    canUseTool: canUseTool,
    hooks: hooks,
    user: user,
    includePartialMessages: includePartialMessages,
    includeHookEvents: includeHookEvents,
    forkSession: forkSession,
    agents: agents,
    settingSources: settingSources,
    skills: skills,
    sandbox: sandbox,
    plugins: plugins,
    thinking: thinking,
    effort: effort,
    outputFormat: outputFormat,
    enableFileCheckpointing: enableFileCheckpointing,
    sessionStore: sessionStore,
    sessionStoreFlush: sessionStoreFlush,
    sessionLoadTimeout: sessionLoadTimeout,
    taskBudget: taskBudget,
    initializeTimeout: initializeTimeout,
    controlRequestTimeout: controlRequestTimeout,
  );
}
