import 'package:claude_agent_sdk/claude_agent_sdk.dart';

/// Process-wide defaults applied to newly created ACP sessions.
final class ClaudeAcpOptions {
  /// Creates immutable adapter options.
  ClaudeAcpOptions({
    this.cliPath,
    Map<String, String> environment = const <String, String>{},
    this.tools,
    this.model,
    this.fallbackModel,
    this.agent,
    Map<String, AgentDefinition> agents = const <String, AgentDefinition>{},
    List<SdkBeta> betas = const <SdkBeta>[],
    this.permissionMode = PermissionMode.standard,
    this.allowDangerouslySkipPermissions = false,
    List<String> allowedTools = const <String>[],
    List<String> disallowedTools = const <String>[],
    Map<String, String> toolAliases = const <String, String>{},
    this.toolConfig,
    this.systemPrompt,
    this.planModeInstructions,
    this.maxTurns,
    this.maxBudgetUsd,
    this.taskBudget,
    this.strictMcpConfig = false,
    this.settings,
    Map<String, Object?>? inlineSettings,
    Map<String, Object?>? managedSettings,
    Map<String, String?> extraArguments = const <String, String?>{},
    this.maxBufferSize,
    this.skills,
    List<SettingSource>? settingSources,
    this.sandbox,
    List<SdkPluginConfig> plugins = const <SdkPluginConfig>[],
    this.thinking,
    this.effort,
    Map<HookEvent, List<HookMatcher>> hooks =
        const <HookEvent, List<HookMatcher>>{},
    this.forwardSubagentText = true,
    this.agentProgressSummaries = false,
    this.promptSuggestions = false,
    this.includeHookEvents = false,
    this.enableFileCheckpointing = false,
    this.persistSession = true,
    this.user,
    this.title,
    this.debug = false,
    this.debugFile,
    this.outputFormat,
    this.initializeTimeout = const Duration(seconds: 60),
    this.controlRequestTimeout = const Duration(seconds: 60),
    this.forceCancelGrace = const Duration(seconds: 30),
    this.maximumQueuedPrompts = 64,
    this.forwardSdkMessages = false,
    List<ClaudeSdkMessageFilter> sdkMessageFilters =
        const <ClaudeSdkMessageFilter>[],
  }) : environment = Map<String, String>.unmodifiable(environment),
       agents = Map<String, AgentDefinition>.unmodifiable(agents),
       betas = List<SdkBeta>.unmodifiable(betas),
       allowedTools = List<String>.unmodifiable(allowedTools),
       disallowedTools = List<String>.unmodifiable(disallowedTools),
       toolAliases = Map<String, String>.unmodifiable(toolAliases),
       inlineSettings = inlineSettings == null
           ? null
           : Map<String, Object?>.unmodifiable(inlineSettings),
       managedSettings = managedSettings == null
           ? null
           : Map<String, Object?>.unmodifiable(managedSettings),
       extraArguments = Map<String, String?>.unmodifiable(extraArguments),
       settingSources = settingSources == null
           ? null
           : List<SettingSource>.unmodifiable(settingSources),
       plugins = List<SdkPluginConfig>.unmodifiable(plugins),
       sdkMessageFilters = List<ClaudeSdkMessageFilter>.unmodifiable(
         sdkMessageFilters,
       ),
       hooks = Map<HookEvent, List<HookMatcher>>.unmodifiable(
         hooks.map(
           (event, matchers) =>
               MapEntry(event, List<HookMatcher>.unmodifiable(matchers)),
         ),
       ) {
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
    if (settings != null && inlineSettings != null) {
      throw ArgumentError('settings and inlineSettings are mutually exclusive');
    }
    if (model != null && fallbackModel == model) {
      throw ArgumentError('fallbackModel must differ from model');
    }
    if (initializeTimeout <= Duration.zero ||
        controlRequestTimeout <= Duration.zero ||
        forceCancelGrace <= Duration.zero) {
      throw ArgumentError('SDK timeout values must be positive');
    }
    if (maximumQueuedPrompts <= 0) {
      throw ArgumentError.value(
        maximumQueuedPrompts,
        'maximumQueuedPrompts',
        'must be positive',
      );
    }
    if (permissionMode == PermissionMode.bypassPermissions &&
        !allowDangerouslySkipPermissions) {
      throw ArgumentError(
        'bypassPermissions requires allowDangerouslySkipPermissions: true',
      );
    }
  }

  /// Explicit Claude executable.
  final String? cliPath;

  /// Environment additions for Claude processes.
  final Map<String, String> environment;

  /// Base built-in tool set.
  final ToolConfiguration? tools;

  /// Initial model preference.
  final String? model;

  /// Model used if the primary model is unavailable.
  final String? fallbackModel;

  /// Programmatic agent selected for the main conversation.
  final String? agent;

  /// Programmatic subagents available through Claude's Agent tool.
  final Map<String, AgentDefinition> agents;

  /// Enabled SDK beta features.
  final List<SdkBeta> betas;

  /// Initial permission mode.
  final PermissionMode permissionMode;

  /// Explicit acknowledgement for bypass-permissions mode.
  final bool allowDangerouslySkipPermissions;

  /// Tools approved without prompting.
  final List<String> allowedTools;

  /// Tools hidden from the model.
  final List<String> disallowedTools;

  /// Single-hop aliases for model-emitted tool names.
  final Map<String, String> toolAliases;

  /// Per-tool built-in behavior.
  final BuiltinToolConfig? toolConfig;

  /// System-prompt policy.
  final SystemPrompt? systemPrompt;

  /// Custom implementation workflow used in plan mode.
  final String? planModeInstructions;

  /// Maximum model turns per prompt.
  final int? maxTurns;

  /// Maximum spend per ACP-backed Claude session.
  final double? maxBudgetUsd;

  /// API-side task token budget.
  final TaskBudget? taskBudget;

  /// Whether only ACP-provided MCP servers are loaded.
  final bool strictMcpConfig;

  /// Additional settings path or JSON object string.
  final String? settings;

  /// Inline flag-tier settings.
  final Map<String, Object?>? inlineSettings;

  /// Restrictive embedding-process policy settings.
  final Map<String, Object?>? managedSettings;

  /// Future CLI flags without the leading `--`.
  final Map<String, String?> extraArguments;

  /// Maximum bytes accepted in one Claude stdout frame.
  final int? maxBufferSize;

  /// Skills available to the main session.
  final SkillsConfiguration? skills;

  /// Filesystem settings tiers, or `null` for runtime defaults.
  final List<SettingSource>? settingSources;

  /// Command sandbox settings.
  final SandboxSettings? sandbox;

  /// Local plugins loaded into each session.
  final List<SdkPluginConfig> plugins;

  /// Thinking behavior.
  final ThinkingConfig? thinking;

  /// Reasoning effort.
  final EffortLevel? effort;

  /// Hook callbacks inherited by each ACP session.
  final Map<HookEvent, List<HookMatcher>> hooks;

  /// Whether complete subagent text/thinking is projected to ACP.
  final bool forwardSubagentText;

  /// Whether subagent task events include generated progress summaries.
  final bool agentProgressSummaries;

  /// Whether Claude emits predicted next prompts.
  final bool promptSuggestions;

  /// Whether hook lifecycle messages are included.
  final bool includeHookEvents;

  /// Whether file checkpointing and rewind support are enabled.
  final bool enableFileCheckpointing;

  /// Whether local session transcripts are persisted.
  final bool persistSession;

  /// Operating-system user for the Claude subprocess.
  final String? user;

  /// User-facing title for new sessions.
  final String? title;

  /// Whether verbose Claude debug logging is enabled.
  final bool debug;

  /// Explicit debug log file.
  final String? debugFile;

  /// Requested structured JSON output.
  final JsonSchemaOutputFormat? outputFormat;

  /// Initialization handshake timeout.
  final Duration initializeTimeout;

  /// Timeout applied to SDK control requests.
  final Duration controlRequestTimeout;

  /// Maximum time an interrupted turn may remain wedged before ACP settles it.
  final Duration forceCancelGrace;

  /// Maximum prompts retained by one session.
  final int maximumQueuedPrompts;

  /// Whether raw SDK messages should be forwarded through the custom channel.
  final bool forwardSdkMessages;

  /// Selective raw-message forwarding rules used when forwarding-all is off.
  final List<ClaudeSdkMessageFilter> sdkMessageFilters;
}

/// Matches one class of raw Claude SDK messages for diagnostic forwarding.
final class ClaudeSdkMessageFilter {
  /// Creates a raw SDK message filter.
  const ClaudeSdkMessageFilter({required this.type, this.subtype, this.origin});

  /// Top-level message type.
  final String type;

  /// Optional system/result subtype.
  final String? subtype;

  /// Optional `origin.kind` discriminator.
  final String? origin;

  /// Whether this filter accepts [message].
  bool matches(Map<String, Object?> message) {
    if (message['type'] != type) return false;
    if (subtype != null && message['subtype'] != subtype) return false;
    if (origin == null) return true;
    final rawOrigin = message['origin'];
    return rawOrigin is Map<Object?, Object?> && rawOrigin['kind'] == origin;
  }
}
