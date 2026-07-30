import 'elicitation.dart';
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

  /// Replaces the system prompt with independently cacheable [blocks].
  ///
  /// Insert [systemPromptDynamicBoundary] as a standalone block to separate
  /// the globally cacheable prefix from session-specific content.
  factory SystemPrompt.blocks(List<String> blocks) = BlockSystemPrompt;

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

/// Marker separating static and dynamic custom system-prompt blocks.
const String systemPromptDynamicBoundary = '__SYSTEM_PROMPT_DYNAMIC_BOUNDARY__';

/// A custom system prompt represented as cache-boundary-aware blocks.
final class BlockSystemPrompt extends SystemPrompt {
  /// Creates a block system prompt.
  BlockSystemPrompt(List<String> blocks)
    : blocks = List<String>.unmodifiable(blocks) {
    if (blocks.isEmpty || blocks.any((block) => block.isEmpty)) {
      throw ArgumentError.value(
        blocks,
        'blocks',
        'must contain non-empty values',
      );
    }
  }

  /// Ordered prompt blocks.
  final List<String> blocks;
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
    this.criticalSystemReminder,
    List<String>? skills,
    this.memory,
    List<AgentMcpServer>? mcpServers,
    this.initialPrompt,
    this.maxTurns,
    this.runsInBackground,
    this.effort,
    this.numericEffort,
    this.permissionMode,
    this.observer,
    this.observerMessage,
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

  /// Experimental critical reminder appended to the agent system prompt.
  final String? criticalSystemReminder;

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

  /// Agent type launched as a read-only observer for this agent.
  final String? observer;

  /// Supplemental instructions sent with observer activity digests.
  final String? observerMessage;

  /// Encodes this definition for the CLI initialize request.
  JsonMap toJson() => {
    'description': description,
    'prompt': prompt,
    if (tools != null) 'tools': tools,
    if (disallowedTools != null) 'disallowedTools': disallowedTools,
    if (model != null) 'model': model,
    if (criticalSystemReminder != null)
      'criticalSystemReminder_EXPERIMENTAL': criticalSystemReminder,
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
    if (observer != null) 'observer': observer,
    if (observerMessage != null) 'observerMessage': observerMessage,
  };
}

/// Preview markup requested from the built-in AskUserQuestion tool.
enum QuestionPreviewFormat {
  /// Markdown or ASCII content.
  markdown,

  /// Self-contained HTML fragments.
  html,
}

/// Per-tool behavior that is otherwise fixed by Claude Code.
final class BuiltinToolConfig {
  /// Creates built-in tool configuration.
  const BuiltinToolConfig({this.questionPreviewFormat});

  /// Preview format produced by AskUserQuestion options.
  final QuestionPreviewFormat? questionPreviewFormat;
}

/// Network options for the CLI command sandbox.
final class SandboxNetworkConfig {
  /// Creates sandbox network options.
  SandboxNetworkConfig({
    List<String> allowedDomains = const [],
    List<String> deniedDomains = const [],
    this.allowManagedDomainsOnly,
    this.strictAllowlist,
    List<String> allowedUnixSockets = const [],
    this.allowAllUnixSockets,
    this.allowLocalBinding,
    List<String> allowedMachServices = const [],
    this.httpProxyPort,
    this.socksProxyPort,
    this.tlsCaCertificatePath,
    this.tlsCaKeyPath,
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

  /// Whether any host not explicitly allowlisted must be denied.
  final bool? strictAllowlist;

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

  /// CA certificate used by sandbox TLS termination.
  final String? tlsCaCertificatePath;

  /// CA private key used by sandbox TLS termination.
  final String? tlsCaKeyPath;

  /// Encodes these options for Claude Code settings.
  JsonMap toJson() => {
    if (allowedDomains.isNotEmpty) 'allowedDomains': allowedDomains,
    if (deniedDomains.isNotEmpty) 'deniedDomains': deniedDomains,
    if (allowManagedDomainsOnly != null)
      'allowManagedDomainsOnly': allowManagedDomainsOnly,
    if (strictAllowlist != null) 'strictAllowlist': strictAllowlist,
    if (allowedUnixSockets.isNotEmpty) 'allowUnixSockets': allowedUnixSockets,
    if (allowAllUnixSockets != null) 'allowAllUnixSockets': allowAllUnixSockets,
    if (allowLocalBinding != null) 'allowLocalBinding': allowLocalBinding,
    if (allowedMachServices.isNotEmpty) 'allowMachLookup': allowedMachServices,
    if (httpProxyPort != null) 'httpProxyPort': httpProxyPort,
    if (socksProxyPort != null) 'socksProxyPort': socksProxyPort,
    if (tlsCaCertificatePath != null || tlsCaKeyPath != null)
      'tlsTerminate': {
        if (tlsCaCertificatePath != null) 'caCertPath': tlsCaCertificatePath,
        if (tlsCaKeyPath != null) 'caKeyPath': tlsCaKeyPath,
      },
  };
}

/// Filesystem rules applied by the command sandbox.
final class SandboxFilesystemConfig {
  /// Creates sandbox filesystem rules.
  SandboxFilesystemConfig({
    List<String> allowedWritePaths = const [],
    List<String> deniedWritePaths = const [],
    List<String> deniedReadPaths = const [],
    List<String> allowedReadPaths = const [],
    this.allowManagedReadPathsOnly,
    this.disabled,
  }) : allowedWritePaths = List<String>.unmodifiable(allowedWritePaths),
       deniedWritePaths = List<String>.unmodifiable(deniedWritePaths),
       deniedReadPaths = List<String>.unmodifiable(deniedReadPaths),
       allowedReadPaths = List<String>.unmodifiable(allowedReadPaths);

  /// Paths writable inside the sandbox.
  final List<String> allowedWritePaths;

  /// Paths explicitly denied for writes.
  final List<String> deniedWritePaths;

  /// Paths explicitly denied for reads.
  final List<String> deniedReadPaths;

  /// Paths readable inside the sandbox.
  final List<String> allowedReadPaths;

  /// Whether only managed policy may expand readable paths.
  final bool? allowManagedReadPathsOnly;

  /// Whether filesystem isolation is disabled.
  final bool? disabled;

  /// Encodes these rules for Claude Code settings.
  JsonMap toJson() => {
    if (allowedWritePaths.isNotEmpty) 'allowWrite': allowedWritePaths,
    if (deniedWritePaths.isNotEmpty) 'denyWrite': deniedWritePaths,
    if (deniedReadPaths.isNotEmpty) 'denyRead': deniedReadPaths,
    if (allowedReadPaths.isNotEmpty) 'allowRead': allowedReadPaths,
    if (allowManagedReadPathsOnly != null)
      'allowManagedReadPathsOnly': allowManagedReadPathsOnly,
    if (disabled != null) 'disabled': disabled,
  };
}

/// One credential file denied inside the command sandbox.
final class SandboxCredentialFile {
  /// Creates a denied credential file rule.
  const SandboxCredentialFile(this.path);

  /// Credential file path.
  final String path;

  JsonMap _toJson() => {'path': path, 'mode': 'deny'};
}

/// How a credential environment variable is exposed in the sandbox.
enum SandboxCredentialEnvironmentMode {
  /// Do not expose the variable.
  deny,

  /// Inject only a masked value for selected hosts.
  mask,
}

/// One credential environment-variable rule.
final class SandboxCredentialEnvironmentVariable {
  /// Creates a credential environment-variable rule.
  SandboxCredentialEnvironmentVariable({
    required this.name,
    this.mode = SandboxCredentialEnvironmentMode.deny,
    List<String> injectHosts = const [],
  }) : injectHosts = List<String>.unmodifiable(injectHosts);

  /// Variable name.
  final String name;

  /// Exposure mode.
  final SandboxCredentialEnvironmentMode mode;

  /// Hosts for which a masked credential may be injected.
  final List<String> injectHosts;

  JsonMap _toJson() => {
    'name': name,
    'mode': mode.name,
    if (injectHosts.isNotEmpty) 'injectHosts': injectHosts,
  };
}

/// Credential controls applied by the command sandbox.
final class SandboxCredentialsConfig {
  /// Creates sandbox credential controls.
  SandboxCredentialsConfig({
    List<SandboxCredentialFile> files = const [],
    List<SandboxCredentialEnvironmentVariable> environmentVariables = const [],
    this.allowPlaintextInjection,
  }) : files = List<SandboxCredentialFile>.unmodifiable(files),
       environmentVariables =
           List<SandboxCredentialEnvironmentVariable>.unmodifiable(
             environmentVariables,
           );

  /// Denied credential files.
  final List<SandboxCredentialFile> files;

  /// Credential environment-variable rules.
  final List<SandboxCredentialEnvironmentVariable> environmentVariables;

  /// Whether plaintext credential injection is allowed.
  final bool? allowPlaintextInjection;

  /// Encodes these controls for Claude Code settings.
  JsonMap toJson() => {
    if (files.isNotEmpty)
      'files': files.map((file) => file._toJson()).toList(growable: false),
    if (environmentVariables.isNotEmpty)
      'envVars': environmentVariables
          .map((variable) => variable._toJson())
          .toList(growable: false),
    if (allowPlaintextInjection != null)
      'allowPlaintextInject': allowPlaintextInjection,
  };
}

/// Custom ripgrep command used inside the sandbox.
final class SandboxRipgrepConfig {
  /// Creates a custom ripgrep configuration.
  SandboxRipgrepConfig({
    required this.command,
    List<String> arguments = const [],
  }) : arguments = List<String>.unmodifiable(arguments);

  /// Executable.
  final String command;

  /// Executable arguments.
  final List<String> arguments;

  JsonMap _toJson() => {
    'command': command,
    if (arguments.isNotEmpty) 'args': arguments,
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
    this.failIfUnavailable,
    this.autoAllowBashIfSandboxed,
    List<String> excludedCommands = const [],
    this.allowUnsandboxedCommands,
    this.network,
    this.filesystem,
    this.credentials,
    this.ignoreViolations,
    this.enableWeakerNestedSandbox,
    this.enableWeakerNetworkIsolation,
    this.allowAppleEvents,
    this.ripgrep,
    this.bwrapPath,
    this.socatPath,
  }) : excludedCommands = List<String>.unmodifiable(excludedCommands);

  /// Whether command sandboxing is enabled.
  final bool? isEnabled;

  /// Whether startup fails when sandbox dependencies are unavailable.
  final bool? failIfUnavailable;

  /// Whether sandboxed Bash calls are auto-approved.
  final bool? autoAllowBashIfSandboxed;

  /// Commands launched outside the sandbox.
  final List<String> excludedCommands;

  /// Whether a command may explicitly bypass the sandbox.
  final bool? allowUnsandboxedCommands;

  /// Network options.
  final SandboxNetworkConfig? network;

  /// Filesystem isolation rules.
  final SandboxFilesystemConfig? filesystem;

  /// Credential isolation rules.
  final SandboxCredentialsConfig? credentials;

  /// Ignored violation patterns.
  final SandboxIgnoreViolations? ignoreViolations;

  /// Whether to use a weaker nested sandbox in restricted containers.
  final bool? enableWeakerNestedSandbox;

  /// Whether weaker nested network isolation may be used.
  final bool? enableWeakerNetworkIsolation;

  /// Whether macOS Apple Events are available.
  final bool? allowAppleEvents;

  /// Custom ripgrep command.
  final SandboxRipgrepConfig? ripgrep;

  /// Explicit bubblewrap executable path.
  final String? bwrapPath;

  /// Explicit socat executable path.
  final String? socatPath;

  /// Encodes these sandbox settings for Claude Code.
  JsonMap toJson() => {
    if (isEnabled != null) 'enabled': isEnabled,
    if (failIfUnavailable != null) 'failIfUnavailable': failIfUnavailable,
    if (autoAllowBashIfSandboxed != null)
      'autoAllowBashIfSandboxed': autoAllowBashIfSandboxed,
    if (excludedCommands.isNotEmpty) 'excludedCommands': excludedCommands,
    if (allowUnsandboxedCommands != null)
      'allowUnsandboxedCommands': allowUnsandboxedCommands,
    if (network != null) 'network': network!.toJson(),
    if (filesystem != null) 'filesystem': filesystem!.toJson(),
    if (credentials != null) 'credentials': credentials!.toJson(),
    if (ignoreViolations != null)
      'ignoreViolations': ignoreViolations!.toJson(),
    if (enableWeakerNestedSandbox != null)
      'enableWeakerNestedSandbox': enableWeakerNestedSandbox,
    if (enableWeakerNetworkIsolation != null)
      'enableWeakerNetworkIsolation': enableWeakerNetworkIsolation,
    if (allowAppleEvents != null) 'allowAppleEvents': allowAppleEvents,
    if (ripgrep != null) 'ripgrep': ripgrep!._toJson(),
    if (bwrapPath != null) 'bwrapPath': bwrapPath,
    if (socatPath != null) 'socatPath': socatPath,
  };
}

/// A local plugin directory loaded for one session.
final class SdkPluginConfig {
  /// Creates a local plugin configuration.
  SdkPluginConfig(this.path, {this.skipMcpDiscovery = false}) {
    if (path.isEmpty) {
      throw ArgumentError.value(path, 'path', 'must not be empty');
    }
  }

  /// Local plugin path.
  final String path;

  /// Whether this plugin's MCP declarations are ignored.
  final bool skipMcpDiscovery;
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
    this.agent,
    List<String> allowedTools = const [],
    Map<String, String> toolAliases = const {},
    this.toolConfig,
    this.systemPrompt,
    this.mcp,
    this.strictMcpConfig = false,
    this.permissionMode,
    this.planModeInstructions,
    this.allowDangerouslySkipPermissions = false,
    this.continueSession = false,
    this.resume,
    this.resumeSessionAt,
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
    JsonMap? inlineSettings,
    JsonMap? managedSettings,
    List<String> addDirectories = const [],
    Map<String, String> environment = const {},
    Map<String, String?> extraArguments = const {},
    this.maxBufferSize,
    this.stderr,
    this.canUseTool,
    this.onElicitation,
    this.onUserDialog,
    List<String> supportedDialogKinds = const <String>[],
    Map<HookEvent, List<HookMatcher>> hooks = const {},
    this.user,
    this.includePartialMessages = false,
    this.includeHookEvents = false,
    this.forwardSubagentText = false,
    this.promptSuggestions = false,
    this.agentProgressSummaries = false,
    this.forkSession = false,
    Map<String, AgentDefinition> agents = const {},
    List<SettingSource>? settingSources,
    this.skills,
    this.sandbox,
    List<SdkPluginConfig> plugins = const [],
    this.title,
    this.persistSession = true,
    this.debug = false,
    this.debugFile,
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
       toolAliases = Map<String, String>.unmodifiable(toolAliases),
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
       supportedDialogKinds = List<String>.unmodifiable(supportedDialogKinds),
       inlineSettings = inlineSettings == null
           ? null
           : immutableJsonMap(inlineSettings),
       managedSettings = managedSettings == null
           ? null
           : immutableJsonMap(managedSettings),
       agents = Map<String, AgentDefinition>.unmodifiable(agents),
       settingSources = settingSources == null
           ? null
           : List<SettingSource>.unmodifiable(settingSources),
       plugins = List<SdkPluginConfig>.unmodifiable(plugins) {
    if (continueSession && resume != null) {
      throw ArgumentError('continueSession and resume are mutually exclusive');
    }
    if (settings != null && inlineSettings != null) {
      throw ArgumentError('settings and inlineSettings are mutually exclusive');
    }
    if (resumeSessionAt != null && resume == null) {
      throw ArgumentError('resumeSessionAt requires resume');
    }
    if (resume != null && sessionId != null && !forkSession) {
      throw ArgumentError('resume and sessionId require forkSession');
    }
    if (model != null && fallbackModel == model) {
      throw ArgumentError('fallbackModel must differ from model');
    }
    if (!persistSession && sessionStore != null) {
      throw ArgumentError('sessionStore requires persistSession');
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
    if (supportedDialogKinds.isNotEmpty && onUserDialog == null) {
      throw ArgumentError('supportedDialogKinds requires onUserDialog');
    }
    if (permissionMode == PermissionMode.bypassPermissions &&
        !allowDangerouslySkipPermissions) {
      throw ArgumentError(
        'bypassPermissions requires allowDangerouslySkipPermissions: true',
      );
    }
    if (toolAliases.entries.any(
      (entry) => entry.key.isEmpty || entry.value.isEmpty,
    )) {
      throw ArgumentError.value(
        toolAliases,
        'toolAliases',
        'names must not be empty',
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
    if (supportedDialogKinds.any((kind) => kind.trim().isEmpty)) {
      throw ArgumentError.value(
        supportedDialogKinds,
        'supportedDialogKinds',
        'must not contain empty values',
      );
    }
  }

  /// Base built-in tool set.
  final ToolConfiguration? tools;

  /// Programmatic agent selected for the main conversation.
  final String? agent;

  /// Tools auto-approved without prompting.
  final List<String> allowedTools;

  /// Single-hop aliases applied to model-emitted tool names.
  final Map<String, String> toolAliases;

  /// Per-tool built-in behavior.
  final BuiltinToolConfig? toolConfig;

  /// System prompt behavior.
  final SystemPrompt? systemPrompt;

  /// MCP configuration.
  final McpConfiguration? mcp;

  /// Whether only [mcp] servers are loaded.
  final bool strictMcpConfig;

  /// Initial permission mode.
  final PermissionMode? permissionMode;

  /// Custom implementation workflow used while in plan mode.
  final String? planModeInstructions;

  /// Explicit acknowledgement required by [PermissionMode.bypassPermissions].
  final bool allowDangerouslySkipPermissions;

  /// Whether to continue the most recent session in the working directory.
  final bool continueSession;

  /// Session ID or title to resume.
  final String? resume;

  /// Assistant-message UUID at which a resumed transcript is truncated.
  final String? resumeSessionAt;

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

  /// Inline flag-tier settings.
  final JsonMap? inlineSettings;

  /// Restrictive policy-tier settings supplied by the embedding process.
  final JsonMap? managedSettings;

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

  /// MCP elicitation callback.
  final OnClaudeElicitation? onElicitation;

  /// Declared non-tool dialog callback.
  final OnClaudeUserDialog? onUserDialog;

  /// Dialog kinds accepted by [onUserDialog].
  final List<String> supportedDialogKinds;

  /// SDK hook callbacks keyed by lifecycle event.
  final Map<HookEvent, List<HookMatcher>> hooks;

  /// Optional operating-system user for the child process.
  final String? user;

  /// Whether stream-event messages are included.
  final bool includePartialMessages;

  /// Whether hook lifecycle messages are included.
  final bool includeHookEvents;

  /// Whether full subagent text and thinking are forwarded.
  final bool forwardSubagentText;

  /// Whether next-prompt suggestions are emitted after turns.
  final bool promptSuggestions;

  /// Whether running subagents emit generated progress summaries.
  final bool agentProgressSummaries;

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

  /// User-facing title for a new session.
  final String? title;

  /// Whether the CLI writes the session transcript to local storage.
  final bool persistSession;

  /// Whether verbose CLI debug logging is enabled.
  final bool debug;

  /// Explicit debug-log file, which also enables debug mode.
  final String? debugFile;

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
    agent: agent,
    allowedTools: allowedTools,
    toolAliases: toolAliases,
    toolConfig: toolConfig,
    systemPrompt: systemPrompt,
    mcp: mcp,
    strictMcpConfig: strictMcpConfig,
    permissionMode: permissionMode,
    planModeInstructions: planModeInstructions,
    allowDangerouslySkipPermissions: allowDangerouslySkipPermissions,
    resume: resumeSessionId,
    resumeSessionAt: resumeSessionAt,
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
    inlineSettings: inlineSettings,
    managedSettings: managedSettings,
    addDirectories: addDirectories,
    environment: {...environment, 'CLAUDE_CONFIG_DIR': configDirectory},
    extraArguments: extraArguments,
    maxBufferSize: maxBufferSize,
    stderr: stderr,
    canUseTool: canUseTool,
    onElicitation: onElicitation,
    onUserDialog: onUserDialog,
    supportedDialogKinds: supportedDialogKinds,
    hooks: hooks,
    user: user,
    includePartialMessages: includePartialMessages,
    includeHookEvents: includeHookEvents,
    forwardSubagentText: forwardSubagentText,
    promptSuggestions: promptSuggestions,
    agentProgressSummaries: agentProgressSummaries,
    forkSession: forkSession,
    agents: agents,
    settingSources: settingSources,
    skills: skills,
    sandbox: sandbox,
    plugins: plugins,
    title: title,
    persistSession: persistSession,
    debug: debug,
    debugFile: debugFile,
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
