import '../initialization.dart';
import '../json.dart';
import '../sessions/session_store.dart';
import 'content_block.dart';

/// A typed message emitted by an agent session.
sealed class AgentMessage {
  const AgentMessage();
}

/// A decoded message paired with its immutable original runtime frame.
final class ClaudeMessageEnvelope {
  /// Creates a raw-preserving decoded envelope.
  ClaudeMessageEnvelope({required this.message, required JsonMap raw})
    : raw = immutableJsonMap(raw);

  /// Typed decoded message.
  final AgentMessage message;

  /// Complete runtime frame.
  final JsonMap raw;
}

/// Explains why one tool result represents a tool that never executed.
///
/// Claude Code emits this as an undocumented `tool_result_meta` sidecar on
/// user messages. The kind is intentionally open-ended so newer runtimes can
/// add classifications without requiring an SDK release.
final class ToolResultMetadata {
  /// Creates typed tool-result metadata.
  ToolResultMetadata({
    required this.toolUseId,
    required this.nonExecutionKind,
    this.userFeedback,
    JsonMap raw = const <String, Object?>{},
  }) : raw = immutableJsonMap(raw);

  /// Decodes one runtime sidecar entry.
  factory ToolResultMetadata.fromJson(JsonMap json) => ToolResultMetadata(
    toolUseId: requiredString(json, 'id', 'tool result metadata'),
    nonExecutionKind: requiredString(
      json,
      'non_execution_kind',
      'tool result metadata',
    ),
    userFeedback: optionalString(json, 'user_feedback', 'tool result metadata'),
    raw: json,
  );

  /// Tool-use ID this classification applies to.
  final String toolUseId;

  /// Open-set non-execution classification.
  final String nonExecutionKind;

  /// Optional feedback supplied while rejecting the tool.
  final String? userFeedback;

  /// Complete forward-compatible sidecar entry.
  final JsonMap raw;
}

/// A replayed or streamed user message.
final class UserMessage extends AgentMessage {
  /// Creates a textual user message.
  const UserMessage.text(
    String text, {
    this.uuid,
    this.sessionId,
    this.parentToolUseId,
    this.toolUseResult,
    this.isSynthetic,
    this.priority,
    this.shouldQuery,
    this.timestamp,
    this.subagentType,
    this.taskDescription,
    this.origin,
    this.isReplay = false,
    this.fileAttachments = const [],
    this.toolResultMetadata = const [],
  }) : content = text;

  /// Creates a structured user message.
  UserMessage.blocks(
    List<ContentBlock> blocks, {
    this.uuid,
    this.sessionId,
    this.parentToolUseId,
    JsonMap? toolUseResult,
    this.isSynthetic,
    this.priority,
    this.shouldQuery,
    this.timestamp,
    this.subagentType,
    this.taskDescription,
    JsonMap? origin,
    this.isReplay = false,
    List<JsonValue> fileAttachments = const [],
    List<ToolResultMetadata> toolResultMetadata = const [],
  }) : content = List<ContentBlock>.unmodifiable(blocks),
       toolUseResult = toolUseResult == null
           ? null
           : immutableJsonMap(toolUseResult),
       origin = origin == null ? null : immutableJsonMap(origin),
       fileAttachments = List<JsonValue>.unmodifiable(
         fileAttachments.map(immutableJsonValue),
       ),
       toolResultMetadata = List<ToolResultMetadata>.unmodifiable(
         toolResultMetadata,
       );

  /// A `String` or immutable `List<ContentBlock>`.
  final Object content;

  /// Transcript UUID, when replayed.
  final String? uuid;

  /// Session identifier, when reported.
  final String? sessionId;

  /// Parent tool invocation for subagent/tool sidechains.
  final String? parentToolUseId;

  /// Raw tool result metadata emitted alongside some replayed messages.
  final JsonMap? toolUseResult;

  /// Whether the message was synthesized by the runtime.
  final bool? isSynthetic;

  /// Queue priority (`now`, `next`, or `later`).
  final String? priority;

  /// Whether this message triggers an assistant turn.
  final bool? shouldQuery;

  /// Originating-host display timestamp.
  final DateTime? timestamp;

  /// Subagent type that produced the message.
  final String? subagentType;

  /// Description of the subagent task.
  final String? taskDescription;

  /// Structured message provenance.
  final JsonMap? origin;

  /// Whether this frame was replayed from an existing transcript.
  final bool isReplay;

  /// Forward-compatible replay attachment descriptors.
  final List<JsonValue> fileAttachments;

  /// Per-tool reasons that an error result did not execute.
  final List<ToolResultMetadata> toolResultMetadata;

  /// Whether [content] is plain text.
  bool get isText => content is String;

  /// Plain text content, or `null`.
  String? get text => content is String ? content as String : null;

  /// Structured blocks, or an empty list for text content.
  List<ContentBlock> get blocks =>
      content is List<ContentBlock> ? content as List<ContentBlock> : const [];
}

/// An assistant response.
final class AssistantMessage extends AgentMessage {
  /// Creates an assistant message.
  AssistantMessage({
    required List<ContentBlock> content,
    required this.model,
    this.parentToolUseId,
    this.error,
    JsonMap? usage,
    this.messageId,
    this.stopReason,
    this.sessionId,
    this.uuid,
    this.requestId,
    this.resumedFromIncompleteThinking = false,
    List<String> supersedes = const [],
    this.isAborted = false,
    this.subagentType,
    this.taskDescription,
    this.timestamp,
  }) : content = List<ContentBlock>.unmodifiable(content),
       usage = usage == null ? null : immutableJsonMap(usage),
       supersedes = List<String>.unmodifiable(supersedes);

  /// Response blocks.
  final List<ContentBlock> content;

  /// Model identifier reported by the API.
  final String model;

  /// Parent tool invocation for a subagent response.
  final String? parentToolUseId;

  /// Typed API failure category.
  final AssistantMessageError? error;

  /// Raw forward-compatible usage object.
  final JsonMap? usage;

  /// Provider message ID.
  final String? messageId;

  /// Provider stop reason.
  final String? stopReason;

  /// Session ID.
  final String? sessionId;

  /// Transcript UUID.
  final String? uuid;

  /// Provider request identifier.
  final String? requestId;

  /// Whether this continued a truncated signed-thinking turn.
  final bool resumedFromIncompleteThinking;

  /// Runtime message UUIDs replaced by this message.
  final List<String> supersedes;

  /// Whether interruption truncated this message.
  final bool isAborted;

  /// Subagent type that produced the response.
  final String? subagentType;

  /// Description of the subagent task.
  final String? taskDescription;

  /// Originating-host display timestamp.
  final DateTime? timestamp;
}

/// Error category attached to an assistant message.
enum AssistantMessageError {
  /// Authentication failed.
  authenticationFailed('authentication_failed'),

  /// OAuth is not available for the selected organization.
  oauthOrganizationNotAllowed('oauth_org_not_allowed'),

  /// Billing configuration or balance failed.
  billingError('billing_error'),

  /// A rate limit prevented the request.
  rateLimit('rate_limit'),

  /// The provider is temporarily overloaded.
  overloaded('overloaded'),

  /// The API rejected the request shape.
  invalidRequest('invalid_request'),

  /// The selected model was not found.
  modelNotFound('model_not_found'),

  /// The API failed internally.
  serverError('server_error'),

  /// The response reached its output-token limit.
  maxOutputTokens('max_output_tokens'),

  /// The CLI reported an unclassified error.
  unknown('unknown');

  const AssistantMessageError(this.wireValue);

  /// CLI value.
  final String wireValue;

  /// Decodes a value, mapping newer values to [unknown].
  static AssistantMessageError fromWire(String value) {
    for (final item in values) {
      if (item.wireValue == value) return item;
    }
    return unknown;
  }
}

/// A generic application/CLI lifecycle message.
base class SystemMessage extends AgentMessage {
  /// Creates a system message.
  SystemMessage({required this.subtype, required JsonMap data})
    : data = immutableJsonMap(data);

  /// System-message discriminator.
  final String subtype;

  /// Complete raw system payload.
  final JsonMap data;
}

/// Usage reported by a delegated task.
final class TaskUsage {
  /// Creates task usage.
  const TaskUsage({
    required this.totalTokens,
    required this.toolUses,
    required this.duration,
  });

  /// Total tokens consumed.
  final int totalTokens;

  /// Number of tool calls.
  final int toolUses;

  /// Elapsed task duration.
  final Duration duration;
}

/// Status reported by a task lifecycle frame.
enum TaskStatus {
  /// Waiting to run.
  pending('pending', false),

  /// Currently running.
  running('running', false),

  /// Temporarily paused.
  paused('paused', false),

  /// Completed successfully.
  completed('completed', true),

  /// Failed.
  failed('failed', true),

  /// Killed before completion.
  killed('killed', true),

  /// Stopped before completion.
  stopped('stopped', true);

  const TaskStatus(this.wireValue, this.isTerminal);

  /// CLI status.
  final String wireValue;

  /// Whether this status ends active-task tracking.
  final bool isTerminal;

  /// Decodes a known status, or returns `null`.
  static TaskStatus? tryFromWire(Object? value) {
    if (value is! String) return null;
    for (final item in values) {
      if (item.wireValue == value) return item;
    }
    return null;
  }
}

/// Emitted when a delegated task starts.
final class TaskStartedMessage extends SystemMessage {
  /// Creates a task-started message.
  TaskStartedMessage({
    required super.data,
    required this.taskId,
    required this.description,
    required this.uuid,
    required this.sessionId,
    this.toolUseId,
    this.taskType,
    this.subagentType,
    this.workflowName,
    this.prompt,
    this.skipTranscript = false,
  }) : super(subtype: 'task_started');

  /// Task identifier.
  final String taskId;

  /// Task description.
  final String description;

  /// Event UUID.
  final String uuid;

  /// Session ID.
  final String sessionId;

  /// Originating tool invocation.
  final String? toolUseId;

  /// CLI task type.
  final String? taskType;

  /// Subagent type for an Agent tool task.
  final String? subagentType;

  /// Local workflow name.
  final String? workflowName;

  /// Task prompt, when surfaced.
  final String? prompt;

  /// Whether transcript renderers should hide this task.
  final bool skipTranscript;
}

/// Emitted while a delegated task is running.
final class TaskProgressMessage extends SystemMessage {
  /// Creates a task-progress message.
  TaskProgressMessage({
    required super.data,
    required this.taskId,
    required this.description,
    required this.usage,
    required this.uuid,
    required this.sessionId,
    this.toolUseId,
    this.lastToolName,
    this.subagentType,
    this.summary,
  }) : super(subtype: 'task_progress');

  /// Task identifier.
  final String taskId;

  /// Task description.
  final String description;

  /// Current usage.
  final TaskUsage usage;

  /// Event UUID.
  final String uuid;

  /// Session ID.
  final String sessionId;

  /// Originating tool invocation.
  final String? toolUseId;

  /// Most recently used tool.
  final String? lastToolName;

  /// Subagent type for an Agent tool task.
  final String? subagentType;

  /// Generated progress summary, when enabled.
  final String? summary;
}

/// Emitted when a task completes, fails, or stops.
final class TaskNotificationMessage extends SystemMessage {
  /// Creates a task notification.
  TaskNotificationMessage({
    required super.data,
    required this.taskId,
    required this.status,
    required this.outputFile,
    required this.summary,
    required this.uuid,
    required this.sessionId,
    this.toolUseId,
    this.usage,
    this.skipTranscript = false,
  }) : super(subtype: 'task_notification');

  /// Task identifier.
  final String taskId;

  /// Terminal task status.
  final TaskStatus status;

  /// File containing complete task output.
  final String outputFile;

  /// Task summary.
  final String summary;

  /// Event UUID.
  final String uuid;

  /// Session ID.
  final String sessionId;

  /// Originating tool invocation.
  final String? toolUseId;

  /// Final task usage, when reported.
  final TaskUsage? usage;

  /// Whether transcript renderers should hide this task.
  final bool skipTranscript;
}

/// Emitted when selected fields of a background task change.
final class TaskUpdatedMessage extends SystemMessage {
  /// Creates a task update.
  TaskUpdatedMessage({
    required super.data,
    required this.taskId,
    required JsonMap patch,
    this.sessionId,
    this.uuid,
  }) : patch = immutableJsonMap(patch),
       status = TaskStatus.tryFromWire(patch['status']),
       super(subtype: 'task_updated');

  /// Task identifier.
  final String taskId;

  /// Changed task fields.
  final JsonMap patch;

  /// Typed status in [patch], when present and known.
  final TaskStatus? status;

  /// Session ID.
  final String? sessionId;

  /// Event UUID.
  final String? uuid;
}

/// Non-fatal failure while copying transcript entries to a store.
final class MirrorErrorMessage extends SystemMessage {
  /// Creates a mirror error message.
  MirrorErrorMessage({
    required super.data,
    this.key,
    required this.error,
    this.uuid,
    this.sessionId,
  }) : super(subtype: 'mirror_error');

  /// Transcript key that failed.
  final SessionKey? key;

  /// Adapter failure text.
  final String error;

  /// Event UUID.
  final String? uuid;

  /// Session identifier.
  final String? sessionId;
}

/// Hook lifecycle event included in the message stream.
final class HookEventMessage extends SystemMessage {
  /// Creates a hook event message.
  HookEventMessage({
    required super.subtype,
    required super.data,
    required this.hookEventName,
    this.hookId,
    this.hookName,
    this.stdout,
    this.stderr,
    this.output,
    this.exitCode,
    this.outcome,
    this.sessionId,
    this.uuid,
  });

  /// Hook event name.
  final String hookEventName;

  /// Invocation identifier.
  final String? hookId;

  /// Configured hook name.
  final String? hookName;

  /// Captured standard output.
  final String? stdout;

  /// Captured standard error.
  final String? stderr;

  /// Combined hook output.
  final String? output;

  /// Process exit code for completed hooks.
  final int? exitCode;

  /// Completion outcome (`success`, `error`, or `cancelled`).
  final String? outcome;

  /// Session ID.
  final String? sessionId;

  /// Event UUID.
  final String? uuid;
}

/// Announces a replacement set of slash commands.
final class CommandsChangedMessage extends SystemMessage {
  /// Creates a commands-changed message.
  CommandsChangedMessage({
    required super.data,
    required List<ClaudeCommandInfo> commands,
    this.uuid,
    this.sessionId,
  }) : commands = List<ClaudeCommandInfo>.unmodifiable(commands),
       super(subtype: 'commands_changed');

  /// Current slash commands.
  final List<ClaudeCommandInfo> commands;

  /// Event UUID.
  final String? uuid;

  /// Session identifier.
  final String? sessionId;
}

/// Announces completion of a URL-mode MCP elicitation.
final class ElicitationCompleteMessage extends SystemMessage {
  /// Creates an elicitation-complete message.
  ElicitationCompleteMessage({
    required super.data,
    required this.elicitationId,
    this.mcpServerName,
    this.uuid,
    this.sessionId,
  }) : super(subtype: 'elicitation_complete');

  /// Completed elicitation identifier.
  final String elicitationId;

  /// MCP server that originated the elicitation.
  final String? mcpServerName;

  /// Event UUID.
  final String? uuid;

  /// Session identifier.
  final String? sessionId;
}

/// Reports current Fast-mode eligibility and selection.
final class FastModeStateMessage extends SystemMessage {
  /// Creates a Fast-mode state message.
  FastModeStateMessage({
    required super.subtype,
    required super.data,
    required this.state,
    this.disabledReason,
  });

  /// Open-set state (`on`, `off`, or `cooldown`).
  final String state;

  /// Open-set reason Fast mode is disabled.
  final String? disabledReason;
}

/// Initial runtime state emitted on the public message stream.
final class RuntimeInitializationMessage extends SystemMessage {
  /// Creates a runtime initialization message.
  RuntimeInitializationMessage({
    required super.data,
    required this.claudeCodeVersion,
    required this.cwd,
    required List<String> tools,
    required this.model,
    required this.permissionMode,
    required List<String> slashCommands,
    required List<String> skills,
    required List<String> capabilities,
    required this.uuid,
    required this.sessionId,
    List<String> agents = const [],
    List<String> betas = const [],
    List<RuntimeMcpServer> mcpServers = const [],
    List<RuntimePlugin> plugins = const [],
    this.apiKeySource,
    this.outputStyle,
    this.fastModeState,
    this.fastModeDisabledReason,
  }) : tools = List<String>.unmodifiable(tools),
       slashCommands = List<String>.unmodifiable(slashCommands),
       skills = List<String>.unmodifiable(skills),
       capabilities = List<String>.unmodifiable(capabilities),
       agents = List<String>.unmodifiable(agents),
       betas = List<String>.unmodifiable(betas),
       mcpServers = List<RuntimeMcpServer>.unmodifiable(mcpServers),
       plugins = List<RuntimePlugin>.unmodifiable(plugins),
       super(subtype: 'init');

  /// Claude Code version.
  final String claudeCodeVersion;

  /// Working directory.
  final String cwd;

  /// Available built-in tools.
  final List<String> tools;

  /// Active model.
  final String model;

  /// Active permission mode.
  final String permissionMode;

  /// Available slash-command names.
  final List<String> slashCommands;

  /// Available skill names.
  final List<String> skills;

  /// Available agent names.
  final List<String> agents;

  /// Enabled SDK beta identifiers.
  final List<String> betas;

  /// MCP server state captured at initialization.
  final List<RuntimeMcpServer> mcpServers;

  /// Loaded plugins captured at initialization.
  final List<RuntimePlugin> plugins;

  /// Authentication source.
  final String? apiKeySource;

  /// Active output style.
  final String? outputStyle;

  /// Open-set runtime capabilities.
  final List<String> capabilities;

  /// Current Fast-mode state.
  final String? fastModeState;

  /// Reason Fast mode is unavailable.
  final String? fastModeDisabledReason;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// MCP server summary carried by a runtime initialization frame.
final class RuntimeMcpServer {
  /// Creates an MCP server summary.
  const RuntimeMcpServer({required this.name, required this.status});

  /// Configured server name.
  final String name;

  /// Open-set connection state.
  final String status;
}

/// Plugin summary carried by a runtime initialization frame.
final class RuntimePlugin {
  /// Creates a plugin summary.
  const RuntimePlugin({required this.name, required this.path, this.version});

  /// Plugin name.
  final String name;

  /// Plugin directory.
  final String path;

  /// Plugin manifest version, when declared.
  final String? version;
}

/// Retry scheduled after a transient provider API failure.
final class ApiRetryMessage extends SystemMessage {
  /// Creates an API retry message.
  ApiRetryMessage({
    required super.data,
    required this.attempt,
    required this.maximumRetries,
    required this.retryDelay,
    required this.error,
    required this.uuid,
    required this.sessionId,
    this.errorStatus,
  }) : super(subtype: 'api_retry');

  /// Current retry attempt.
  final int attempt;

  /// Maximum retry count.
  final int maximumRetries;

  /// Delay before the retry.
  final Duration retryDelay;

  /// HTTP status, or `null` for connection failures.
  final int? errorStatus;

  /// Typed provider error category.
  final AssistantMessageError error;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// One live background task in a replacement snapshot.
final class BackgroundTaskSummary {
  /// Creates a background-task summary.
  const BackgroundTaskSummary({
    required this.taskId,
    required this.taskType,
    required this.description,
  });

  /// Task identifier.
  final String taskId;

  /// Task category.
  final String taskType;

  /// Human-readable description.
  final String description;
}

/// Replacement snapshot of all live background tasks.
final class BackgroundTasksChangedMessage extends SystemMessage {
  /// Creates a background-task snapshot.
  BackgroundTasksChangedMessage({
    required super.data,
    required List<BackgroundTaskSummary> tasks,
    required this.uuid,
    required this.sessionId,
  }) : tasks = List<BackgroundTaskSummary>.unmodifiable(tasks),
       super(subtype: 'background_tasks_changed');

  /// Complete current task set.
  final List<BackgroundTaskSummary> tasks;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Context-compaction boundary and its forward-compatible metadata.
final class CompactBoundaryMessage extends SystemMessage {
  /// Creates a compact-boundary message.
  CompactBoundaryMessage({
    required super.data,
    required JsonMap metadata,
    required this.uuid,
    required this.sessionId,
  }) : metadata = immutableJsonMap(metadata),
       super(subtype: 'compact_boundary');

  /// Compaction metadata.
  final JsonMap metadata;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Progress for a long-running client-originated control request.
final class ControlRequestProgressMessage extends SystemMessage {
  /// Creates a control-request progress message.
  ControlRequestProgressMessage({
    required super.data,
    required this.requestId,
    required this.status,
    required this.uuid,
    required this.sessionId,
    this.attempt,
    this.maximumRetries,
    this.retryDelay,
    this.errorStatus,
  }) : super(subtype: 'control_request_progress');

  /// Outgoing control request identifier.
  final String requestId;

  /// Open-set progress status.
  final String status;

  /// Retry attempt, when status is `api_retry`.
  final int? attempt;

  /// Maximum retries.
  final int? maximumRetries;

  /// Retry delay.
  final Duration? retryDelay;

  /// Provider HTTP status.
  final int? errorStatus;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Result of persisting generated files.
final class FilesPersistedMessage extends SystemMessage {
  /// Creates a files-persisted message.
  FilesPersistedMessage({
    required super.data,
    required List<JsonMap> files,
    required List<JsonMap> failed,
    required this.processedAt,
    required this.uuid,
    required this.sessionId,
  }) : files = List<JsonMap>.unmodifiable(files),
       failed = List<JsonMap>.unmodifiable(failed),
       super(subtype: 'files_persisted');

  /// Persisted file descriptors.
  final List<JsonMap> files;

  /// Failed file descriptors.
  final List<JsonMap> failed;

  /// Runtime processing timestamp.
  final DateTime processedAt;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Plaintext runtime banner, notice, suggestion, or warning.
final class InformationalMessage extends SystemMessage {
  /// Creates an informational message.
  InformationalMessage({
    required super.data,
    required this.content,
    required this.level,
    required this.uuid,
    required this.sessionId,
    this.toolUseId,
    this.preventsContinuation = false,
  }) : super(subtype: 'informational');

  /// Plaintext content.
  final String content;

  /// Open-set display level.
  final String level;

  /// Tool invocation used to deduplicate progress.
  final String? toolUseId;

  /// Whether execution stops after this message.
  final bool preventsContinuation;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Output from a local slash command.
final class LocalCommandOutputMessage extends SystemMessage {
  /// Creates a local-command output message.
  LocalCommandOutputMessage({
    required super.data,
    required this.content,
    required this.uuid,
    required this.sessionId,
  }) : super(subtype: 'local_command_output');

  /// Display text.
  final String content;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// One memory surfaced into the current turn.
final class RecalledMemory {
  /// Creates a recalled-memory item.
  const RecalledMemory({required this.path, required this.scope, this.content});

  /// File path, URL, or synthesis sentinel.
  final String path;

  /// Memory scope.
  final String scope;

  /// Surfaced content when carried inline.
  final String? content;
}

/// Memory recall surfaced by the runtime supervisor.
final class MemoryRecallMessage extends SystemMessage {
  /// Creates a memory-recall message.
  MemoryRecallMessage({
    required super.data,
    required this.mode,
    required List<RecalledMemory> memories,
    required this.uuid,
    required this.sessionId,
  }) : memories = List<RecalledMemory>.unmodifiable(memories),
       super(subtype: 'memory_recall');

  /// Recall mode (`select` or `synthesize`).
  final String mode;

  /// Surfaced memories.
  final List<RecalledMemory> memories;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Retry/replacement notice after a model refusal.
final class ModelRefusalFallbackMessage extends SystemMessage {
  /// Creates a refusal-fallback message.
  ModelRefusalFallbackMessage({
    required super.data,
    required this.direction,
    required this.originalModel,
    required this.fallbackModel,
    required this.content,
    required this.uuid,
    required this.sessionId,
    this.requestId,
    this.category,
    this.explanation,
    this.refusedUserMessageId,
    List<String> retractedMessageIds = const [],
  }) : retractedMessageIds = List<String>.unmodifiable(retractedMessageIds),
       super(subtype: 'model_refusal_fallback');

  /// Retry direction.
  final String direction;

  /// Refusing model.
  final String originalModel;

  /// Retry model.
  final String fallbackModel;

  /// Provider request identifier.
  final String? requestId;

  /// Refusal category.
  final String? category;

  /// Refusal explanation.
  final String? explanation;

  /// User message eligible for edit-and-retry.
  final String? refusedUserMessageId;

  /// Runtime messages replaced by the retry.
  final List<String> retractedMessageIds;

  /// Display text.
  final String content;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Notice that a refusal could not be retried on another model.
final class ModelRefusalNoFallbackMessage extends SystemMessage {
  /// Creates a no-fallback refusal message.
  ModelRefusalNoFallbackMessage({
    required super.data,
    required this.originalModel,
    required this.content,
    required this.uuid,
    required this.sessionId,
    this.requestId,
    this.category,
    this.explanation,
    this.refusedUserMessageId,
  }) : super(subtype: 'model_refusal_no_fallback');

  /// Refusing model.
  final String originalModel;

  /// Provider request identifier.
  final String? requestId;

  /// Refusal category.
  final String? category;

  /// Refusal explanation.
  final String? explanation;

  /// User message eligible for edit-and-retry.
  final String? refusedUserMessageId;

  /// Display text.
  final String content;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Loop-side text notification.
final class RuntimeNotificationMessage extends SystemMessage {
  /// Creates a runtime notification.
  RuntimeNotificationMessage({
    required super.data,
    required this.key,
    required this.text,
    required this.priority,
    required this.uuid,
    required this.sessionId,
    this.color,
    this.timeout,
  }) : super(subtype: 'notification');

  /// Deduplication key.
  final String key;

  /// Notification text.
  final String text;

  /// Open-set priority.
  final String priority;

  /// Optional display color.
  final String? color;

  /// Display timeout.
  final Duration? timeout;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Auto-denial that did not invoke the permission callback.
final class PermissionDeniedMessage extends SystemMessage {
  /// Creates a permission-denied message.
  PermissionDeniedMessage({
    required super.data,
    required this.toolName,
    required this.toolUseId,
    required this.message,
    required this.uuid,
    required this.sessionId,
    this.agentId,
    this.decisionReasonType,
    this.decisionReason,
  }) : super(subtype: 'permission_denied');

  /// Tool name.
  final String toolName;

  /// Tool invocation identifier.
  final String toolUseId;

  /// Subagent identifier.
  final String? agentId;

  /// Structured denial discriminator.
  final String? decisionReasonType;

  /// Human-readable decision reason.
  final String? decisionReason;

  /// Message returned to the model.
  final String message;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Headless plugin-install progress.
final class PluginInstallMessage extends SystemMessage {
  /// Creates a plugin-install message.
  PluginInstallMessage({
    required super.data,
    required this.status,
    required this.uuid,
    required this.sessionId,
    this.name,
    this.error,
  }) : super(subtype: 'plugin_install');

  /// Open-set install status.
  final String status;

  /// Marketplace plugin name.
  final String? name;

  /// Failure text.
  final String? error;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Authoritative running/idle/requires-action session state.
final class SessionStateChangedMessage extends SystemMessage {
  /// Creates a session-state change.
  SessionStateChangedMessage({
    required super.data,
    required this.state,
    required this.uuid,
    required this.sessionId,
  }) : super(subtype: 'session_state_changed');

  /// Open-set state.
  final String state;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Current requesting or compaction status.
final class RuntimeStatusMessage extends SystemMessage {
  /// Creates a runtime status message.
  RuntimeStatusMessage({
    required super.data,
    required this.uuid,
    required this.sessionId,
    this.status,
    this.permissionMode,
    this.compactResult,
    this.compactError,
  }) : super(subtype: 'status');

  /// `compacting`, `requesting`, or `null`.
  final String? status;

  /// Active permission mode.
  final String? permissionMode;

  /// Compaction result.
  final String? compactResult;

  /// Compaction failure text.
  final String? compactError;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Approximate live thinking-token estimate.
final class ThinkingTokensMessage extends SystemMessage {
  /// Creates a thinking-token message.
  ThinkingTokensMessage({
    required super.data,
    required this.estimatedTokens,
    required this.estimatedTokenDelta,
    required this.uuid,
    required this.sessionId,
  }) : super(subtype: 'thinking_tokens');

  /// Running estimate for the thinking block.
  final int estimatedTokens;

  /// Estimate added by this event.
  final int estimatedTokenDelta;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Graceful worker shutdown notice.
final class WorkerShuttingDownMessage extends SystemMessage {
  /// Creates a worker-shutdown message.
  WorkerShuttingDownMessage({
    required super.data,
    required this.reason,
    required this.uuid,
    required this.sessionId,
  }) : super(subtype: 'worker_shutting_down');

  /// Host-defined shutdown reason.
  final String reason;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// A tool call deferred by a pre-tool hook.
final class DeferredToolUse {
  /// Creates a deferred tool call.
  DeferredToolUse({
    required this.id,
    required this.name,
    required JsonMap input,
  }) : input = immutableJsonMap(input);

  /// Tool invocation ID.
  final String id;

  /// Tool name.
  final String name;

  /// Tool input.
  final JsonMap input;
}

/// Usage and cost attributed to one model.
final class ModelUsage {
  /// Creates per-model usage.
  const ModelUsage({
    required this.inputTokens,
    required this.outputTokens,
    required this.cacheReadInputTokens,
    required this.cacheCreationInputTokens,
    required this.webSearchRequests,
    required this.costUsd,
    required this.contextWindow,
    required this.maxOutputTokens,
    this.canonicalModel,
    this.provider,
  });

  /// Input tokens.
  final int inputTokens;

  /// Output tokens.
  final int outputTokens;

  /// Input tokens read from cache.
  final int cacheReadInputTokens;

  /// Input tokens written to cache.
  final int cacheCreationInputTokens;

  /// Billable web search requests.
  final int webSearchRequests;

  /// Cost in US dollars.
  final double costUsd;

  /// Model context window.
  final int contextWindow;

  /// Maximum model output tokens.
  final int maxOutputTokens;

  /// Canonical model used for pricing.
  final String? canonicalModel;

  /// Serving provider.
  final String? provider;
}

/// Final result of one agent turn or run.
final class ResultMessage extends AgentMessage {
  /// Creates a result message.
  ResultMessage({
    required this.subtype,
    required this.duration,
    required this.apiDuration,
    required this.isError,
    required this.turns,
    required this.sessionId,
    this.stopReason,
    this.totalCostUsd,
    JsonMap? usage,
    this.result,
    JsonValue structuredOutput,
    Map<String, ModelUsage>? modelUsage,
    List<JsonValue>? permissionDenials,
    this.deferredToolUse,
    List<String>? errors,
    this.apiErrorStatus,
    this.uuid,
    this.terminalReason,
    this.timeToFirstToken,
    this.streamTimeToFirstToken,
    this.timeToRequest,
    this.userMessageId,
    this.requestSentAtMilliseconds,
    this.timeToRequestFromSpawn,
    this.warmSpareClaimed,
    this.timeOriginMilliseconds,
    this.fastModeState,
    this.fastModeDisabledReason,
    JsonMap? origin,
  }) : usage = usage == null ? null : immutableJsonMap(usage),
       structuredOutput = immutableJsonValue(structuredOutput),
       modelUsage = modelUsage == null
           ? null
           : Map<String, ModelUsage>.unmodifiable(modelUsage),
       permissionDenials = permissionDenials == null
           ? null
           : List<JsonValue>.unmodifiable(
               permissionDenials.map(immutableJsonValue),
             ),
       errors = errors == null ? null : List<String>.unmodifiable(errors),
       origin = origin == null ? null : immutableJsonMap(origin);

  /// Result subtype.
  final String subtype;

  /// Total wall-clock duration.
  final Duration duration;

  /// Time spent in API calls.
  final Duration apiDuration;

  /// Whether the run ended with an error result.
  final bool isError;

  /// Number of agent turns.
  final int turns;

  /// Session ID.
  final String sessionId;

  /// Provider stop reason.
  final String? stopReason;

  /// Total cost in US dollars.
  final double? totalCostUsd;

  /// Raw aggregate usage.
  final JsonMap? usage;

  /// Text result.
  final String? result;

  /// JSON Schema result, when configured.
  final JsonValue structuredOutput;

  /// Usage keyed by model string.
  final Map<String, ModelUsage>? modelUsage;

  /// Permission denials encountered during the run.
  final List<JsonValue>? permissionDenials;

  /// Tool call that stopped at a defer decision.
  final DeferredToolUse? deferredToolUse;

  /// Structured error messages.
  final List<String>? errors;

  /// Safe-to-log API HTTP status.
  final int? apiErrorStatus;

  /// Result event UUID.
  final String? uuid;

  /// Why the query loop terminated.
  final String? terminalReason;

  /// Time to the first response token.
  final Duration? timeToFirstToken;

  /// Streaming-path time to first token.
  final Duration? streamTimeToFirstToken;

  /// Delay before dispatching the provider request.
  final Duration? timeToRequest;

  /// User message correlated with this result.
  final String? userMessageId;

  /// Originating wall-clock request timestamp in milliseconds.
  final int? requestSentAtMilliseconds;

  /// Request delay measured from process spawn.
  final Duration? timeToRequestFromSpawn;

  /// Whether a warm spare process served the request.
  final bool? warmSpareClaimed;

  /// Runtime timing-origin timestamp in milliseconds.
  final int? timeOriginMilliseconds;

  /// Fast-mode state at completion.
  final String? fastModeState;

  /// Reason Fast mode was unavailable.
  final String? fastModeDisabledReason;

  /// Structured result origin/provenance.
  final JsonMap? origin;
}

/// Raw provider streaming event.
final class StreamEventMessage extends AgentMessage {
  /// Creates a streaming event.
  StreamEventMessage({
    required this.uuid,
    required this.sessionId,
    required JsonMap event,
    this.parentToolUseId,
    this.timeToFirstToken,
  }) : event = immutableJsonMap(event);

  /// Event UUID.
  final String uuid;

  /// Session ID.
  final String sessionId;

  /// Raw provider event.
  final JsonMap event;

  /// Provider event discriminator.
  String? get eventType => event['type'] as String?;

  /// Content-block index for delta events.
  int? get contentBlockIndex => event['index'] as int?;

  /// Delta object, when present.
  JsonMap? get delta => event['delta'] is Map<Object?, Object?>
      ? asJsonMap(event['delta'], 'stream event delta')
      : null;

  /// Delta discriminator, when present.
  String? get deltaType => delta?['type'] as String?;

  /// Text or thinking delta, when present.
  String? get textDelta =>
      delta?['text'] as String? ?? delta?['thinking'] as String?;

  /// Partial tool-input JSON, when present.
  String? get partialJson => delta?['partial_json'] as String?;

  /// Parent tool invocation.
  final String? parentToolUseId;

  /// Time to first token when reported on the stream frame.
  final Duration? timeToFirstToken;
}

/// Current account rate-limit state.
enum RateLimitStatus {
  /// Calls are allowed.
  allowed('allowed'),

  /// Calls are allowed but close to the limit.
  allowedWarning('allowed_warning'),

  /// Calls are rejected.
  rejected('rejected');

  const RateLimitStatus(this.wireValue);

  /// CLI value.
  final String wireValue;

  static RateLimitStatus _fromWire(String value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => throw FormatException('Unknown rate-limit status: $value'),
  );
}

/// Window to which a rate limit applies.
enum RateLimitType {
  /// Five-hour window.
  fiveHour('five_hour'),

  /// Seven-day aggregate window.
  sevenDay('seven_day'),

  /// Seven-day Opus window.
  sevenDayOpus('seven_day_opus'),

  /// Seven-day Sonnet window.
  sevenDaySonnet('seven_day_sonnet'),

  /// Seven-day window that includes overage.
  sevenDayOverageIncluded('seven_day_overage_included'),

  /// Overage/pay-as-you-go window.
  overage('overage');

  const RateLimitType(this.wireValue);

  /// CLI value.
  final String wireValue;

  static RateLimitType? _tryFromWire(Object? value) {
    if (value is! String) return null;
    for (final item in values) {
      if (item.wireValue == value) return item;
    }
    return null;
  }
}

/// Detailed rate-limit information.
final class RateLimitInfo {
  /// Creates rate-limit information.
  RateLimitInfo({
    required this.status,
    this.resetsAt,
    this.type,
    this.utilization,
    this.overageStatus,
    this.overageResetsAt,
    this.overageDisabledReason,
    this.isUsingOverage,
    this.overageInUse,
    this.surpassedThreshold,
    this.errorCode,
    this.canUserPurchaseCredits,
    this.hasChargeableSavedPaymentMethod,
    required JsonMap raw,
  }) : raw = immutableJsonMap(raw);

  /// Current status.
  final RateLimitStatus status;

  /// Unix time at which the window resets.
  final DateTime? resetsAt;

  /// Applicable window.
  final RateLimitType? type;

  /// Fraction of the window consumed.
  final double? utilization;

  /// Overage status.
  final RateLimitStatus? overageStatus;

  /// Overage reset time.
  final DateTime? overageResetsAt;

  /// Reason overage is unavailable.
  final String? overageDisabledReason;

  /// Whether current calls consume overage.
  final bool? isUsingOverage;

  /// Whether the account has used overage in this window.
  final bool? overageInUse;

  /// Utilization threshold that was crossed.
  final double? surpassedThreshold;

  /// Structured rate-limit error code.
  final String? errorCode;

  /// Whether the current user may buy credits.
  final bool? canUserPurchaseCredits;

  /// Whether the account has a chargeable saved payment method.
  final bool? hasChargeableSavedPaymentMethod;

  /// Complete raw rate-limit object.
  final JsonMap raw;
}

/// Emitted when rate-limit state changes.
final class RateLimitEventMessage extends AgentMessage {
  /// Creates a rate-limit event.
  const RateLimitEventMessage({
    required this.info,
    required this.uuid,
    required this.sessionId,
  });

  /// Current rate-limit information.
  final RateLimitInfo info;

  /// Event UUID.
  final String uuid;

  /// Session ID.
  final String sessionId;
}

/// Authentication progress emitted by interactive login flows.
final class AuthStatusMessage extends AgentMessage {
  /// Creates an authentication-status message.
  AuthStatusMessage({
    required this.isAuthenticating,
    required List<String> output,
    required this.uuid,
    required this.sessionId,
    this.error,
  }) : output = List<String>.unmodifiable(output);

  /// Whether authentication is still in progress.
  final bool isAuthenticating;

  /// Display lines produced by the authentication flow.
  final List<String> output;

  /// Failure text, when authentication failed.
  final String? error;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Periodic progress for a running tool call.
final class ToolProgressMessage extends AgentMessage {
  /// Creates a tool-progress message.
  ToolProgressMessage({
    required this.toolUseId,
    required this.toolName,
    required this.elapsed,
    required this.uuid,
    required this.sessionId,
    this.parentToolUseId,
    this.taskId,
    this.isHeartbeat = false,
    this.subagentType,
    JsonMap? subagentRetry,
  }) : subagentRetry = subagentRetry == null
           ? null
           : immutableJsonMap(subagentRetry);

  /// Tool invocation identifier.
  final String toolUseId;

  /// Tool name.
  final String toolName;

  /// Parent tool invocation for nested subagent work.
  final String? parentToolUseId;

  /// Elapsed execution time.
  final Duration elapsed;

  /// Associated background task.
  final String? taskId;

  /// Whether this is a heartbeat rather than new progress.
  final bool isHeartbeat;

  /// Subagent type, when this progress belongs to an agent.
  final String? subagentType;

  /// Structured API-retry information for the subagent.
  final JsonMap? subagentRetry;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Summary covering one or more preceding tool calls.
final class ToolUseSummaryMessage extends AgentMessage {
  /// Creates a tool-use summary.
  ToolUseSummaryMessage({
    required this.summary,
    required List<String> precedingToolUseIds,
    required this.uuid,
    required this.sessionId,
  }) : precedingToolUseIds = List<String>.unmodifiable(precedingToolUseIds);

  /// Summary text.
  final String summary;

  /// Tool invocations covered by the summary.
  final List<String> precedingToolUseIds;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Predicted next user prompt emitted after a completed turn.
final class PromptSuggestionMessage extends AgentMessage {
  /// Creates a prompt suggestion.
  const PromptSuggestionMessage({
    required this.suggestion,
    required this.uuid,
    required this.sessionId,
  });

  /// Suggested prompt.
  final String suggestion;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Announces a new runtime conversation identifier.
final class ConversationResetMessage extends AgentMessage {
  /// Creates a conversation-reset message.
  const ConversationResetMessage({
    required this.newConversationId,
    required this.uuid,
    required this.sessionId,
  });

  /// New conversation identifier.
  final String newConversationId;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Current goal state emitted by the goal hook.
final class ActiveGoalMessage extends AgentMessage {
  /// Creates an active-goal message.
  ActiveGoalMessage({
    required JsonMap? value,
    required this.uuid,
    required this.sessionId,
  }) : value = value == null ? null : immutableJsonMap(value);

  /// Goal state, or `null` when the goal was cleared.
  final JsonMap? value;

  /// Event UUID.
  final String uuid;

  /// Session identifier.
  final String sessionId;
}

/// Forward-compatible wrapper for a top-level message type introduced by a
/// newer Claude Code runtime.
final class UnknownAgentMessage extends AgentMessage {
  /// Creates an unknown message wrapper.
  UnknownAgentMessage({required this.type, required JsonMap raw})
    : raw = immutableJsonMap(raw);

  /// Runtime type discriminator.
  final String type;

  /// Complete runtime frame.
  final JsonMap raw;
}

/// Decodes a rate-limit status emitted by the CLI.
RateLimitStatus rateLimitStatusFromWire(String value) =>
    RateLimitStatus._fromWire(value);

/// Decodes an optional rate-limit window emitted by the CLI.
RateLimitType? rateLimitTypeFromWire(Object? value) =>
    RateLimitType._tryFromWire(value);
