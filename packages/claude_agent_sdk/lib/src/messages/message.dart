import '../json.dart';
import '../sessions/session_store.dart';
import 'content_block.dart';

/// A typed message emitted by an agent session.
sealed class AgentMessage {
  const AgentMessage();
}

/// A replayed or streamed user message.
final class UserMessage extends AgentMessage {
  /// Creates a textual user message.
  const UserMessage.text(
    String text, {
    this.uuid,
    this.parentToolUseId,
    this.toolUseResult,
  }) : content = text;

  /// Creates a structured user message.
  UserMessage.blocks(
    List<ContentBlock> blocks, {
    this.uuid,
    this.parentToolUseId,
    JsonMap? toolUseResult,
  }) : content = List<ContentBlock>.unmodifiable(blocks),
       toolUseResult = toolUseResult == null
           ? null
           : immutableJsonMap(toolUseResult);

  /// A `String` or immutable `List<ContentBlock>`.
  final Object content;

  /// Transcript UUID, when replayed.
  final String? uuid;

  /// Parent tool invocation for subagent/tool sidechains.
  final String? parentToolUseId;

  /// Raw tool result metadata emitted alongside some replayed messages.
  final JsonMap? toolUseResult;

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
  }) : content = List<ContentBlock>.unmodifiable(content),
       usage = usage == null ? null : immutableJsonMap(usage);

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
}

/// Error category attached to an assistant message.
enum AssistantMessageError {
  /// Authentication failed.
  authenticationFailed('authentication_failed'),

  /// Billing configuration or balance failed.
  billingError('billing_error'),

  /// A rate limit prevented the request.
  rateLimit('rate_limit'),

  /// The API rejected the request shape.
  invalidRequest('invalid_request'),

  /// The API failed internally.
  serverError('server_error'),

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
  MirrorErrorMessage({required super.data, this.key, required this.error})
    : super(subtype: 'mirror_error');

  /// Transcript key that failed.
  final SessionKey? key;

  /// Adapter failure text.
  final String error;
}

/// Hook lifecycle event included in the message stream.
final class HookEventMessage extends SystemMessage {
  /// Creates a hook event message.
  HookEventMessage({
    required super.subtype,
    required super.data,
    required this.hookEventName,
    this.sessionId,
    this.uuid,
  });

  /// Hook event name.
  final String hookEventName;

  /// Session ID.
  final String? sessionId;

  /// Event UUID.
  final String? uuid;
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
       errors = errors == null ? null : List<String>.unmodifiable(errors);

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
}

/// Raw provider streaming event.
final class StreamEventMessage extends AgentMessage {
  /// Creates a streaming event.
  StreamEventMessage({
    required this.uuid,
    required this.sessionId,
    required JsonMap event,
    this.parentToolUseId,
  }) : event = immutableJsonMap(event);

  /// Event UUID.
  final String uuid;

  /// Session ID.
  final String sessionId;

  /// Raw provider event.
  final JsonMap event;

  /// Parent tool invocation.
  final String? parentToolUseId;
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

/// Decodes a rate-limit status emitted by the CLI.
RateLimitStatus rateLimitStatusFromWire(String value) =>
    RateLimitStatus._fromWire(value);

/// Decodes an optional rate-limit window emitted by the CLI.
RateLimitType? rateLimitTypeFromWire(Object? value) =>
    RateLimitType._tryFromWire(value);
