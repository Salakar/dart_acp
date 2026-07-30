import 'dart:async';

import 'json.dart';

/// A lifecycle point at which an SDK hook may run.
enum HookEvent {
  /// Before a tool starts.
  preToolUse('PreToolUse'),

  /// After a tool succeeds.
  postToolUse('PostToolUse'),

  /// After a tool fails.
  postToolUseFailure('PostToolUseFailure'),

  /// Before a user prompt enters the loop.
  userPromptSubmit('UserPromptSubmit'),

  /// When the main agent is stopping.
  stop('Stop'),

  /// When a subagent is stopping.
  subagentStop('SubagentStop'),

  /// Before context compaction.
  preCompact('PreCompact'),

  /// When the application emits a notification.
  notification('Notification'),

  /// When a subagent starts.
  subagentStart('SubagentStart'),

  /// When the application asks for permission.
  permissionRequest('PermissionRequest');

  const HookEvent(this.wireValue);

  /// CLI hook event name.
  final String wireValue;

  /// Decodes a CLI hook event.
  static HookEvent fromWire(String value) => values.firstWhere(
    (event) => event.wireValue == value,
    orElse: () => throw FormatException('Unknown hook event: $value'),
  );
}

/// Common context for a hook invocation.
sealed class HookInput {
  HookInput({
    required this.event,
    required this.sessionId,
    required this.transcriptPath,
    required this.cwd,
    required this.raw,
    this.permissionMode,
  });

  /// Hook discriminator.
  final HookEvent event;

  /// Session in which the hook fired.
  final String sessionId;

  /// Path of the active transcript.
  final String transcriptPath;

  /// Working directory of the session.
  final String cwd;

  /// Permission mode reported by the CLI.
  final String? permissionMode;

  /// Full forward-compatible hook payload.
  final JsonMap raw;

  /// Decodes a hook input.
  static HookInput fromJson(JsonMap json) {
    final event = HookEvent.fromWire(
      requiredString(json, 'hook_event_name', 'hook input'),
    );
    final common = (
      sessionId: requiredString(json, 'session_id', 'hook input'),
      transcriptPath: requiredString(json, 'transcript_path', 'hook input'),
      cwd: requiredString(json, 'cwd', 'hook input'),
      permissionMode: optionalString(json, 'permission_mode', 'hook input'),
    );
    return switch (event) {
      HookEvent.preToolUse => PreToolUseHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        toolName: requiredString(json, 'tool_name', 'PreToolUse'),
        toolInput: asJsonMap(json['tool_input'], 'PreToolUse.tool_input'),
        toolUseId: requiredString(json, 'tool_use_id', 'PreToolUse'),
        agentId: optionalString(json, 'agent_id', 'PreToolUse'),
        agentType: optionalString(json, 'agent_type', 'PreToolUse'),
        raw: immutableJsonMap(json),
      ),
      HookEvent.postToolUse => PostToolUseHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        toolName: requiredString(json, 'tool_name', 'PostToolUse'),
        toolInput: asJsonMap(json['tool_input'], 'PostToolUse.tool_input'),
        toolResponse: immutableJsonValue(json['tool_response']),
        toolUseId: requiredString(json, 'tool_use_id', 'PostToolUse'),
        agentId: optionalString(json, 'agent_id', 'PostToolUse'),
        agentType: optionalString(json, 'agent_type', 'PostToolUse'),
        raw: immutableJsonMap(json),
      ),
      HookEvent.postToolUseFailure => PostToolUseFailureHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        toolName: requiredString(json, 'tool_name', 'PostToolUseFailure'),
        toolInput: asJsonMap(
          json['tool_input'],
          'PostToolUseFailure.tool_input',
        ),
        toolUseId: requiredString(json, 'tool_use_id', 'PostToolUseFailure'),
        error: requiredString(json, 'error', 'PostToolUseFailure'),
        isInterrupt:
            optionalBool(json, 'is_interrupt', 'PostToolUseFailure') ?? false,
        agentId: optionalString(json, 'agent_id', 'PostToolUseFailure'),
        agentType: optionalString(json, 'agent_type', 'PostToolUseFailure'),
        raw: immutableJsonMap(json),
      ),
      HookEvent.userPromptSubmit => UserPromptSubmitHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        prompt: requiredString(json, 'prompt', 'UserPromptSubmit'),
        raw: immutableJsonMap(json),
      ),
      HookEvent.stop => StopHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        isStopHookActive: requiredBool(json, 'stop_hook_active', 'Stop'),
        raw: immutableJsonMap(json),
      ),
      HookEvent.subagentStop => SubagentStopHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        isStopHookActive: requiredBool(
          json,
          'stop_hook_active',
          'SubagentStop',
        ),
        agentId: requiredString(json, 'agent_id', 'SubagentStop'),
        agentTranscriptPath: requiredString(
          json,
          'agent_transcript_path',
          'SubagentStop',
        ),
        agentType: requiredString(json, 'agent_type', 'SubagentStop'),
        raw: immutableJsonMap(json),
      ),
      HookEvent.preCompact => PreCompactHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        trigger: requiredString(json, 'trigger', 'PreCompact'),
        customInstructions: optionalString(
          json,
          'custom_instructions',
          'PreCompact',
        ),
        raw: immutableJsonMap(json),
      ),
      HookEvent.notification => NotificationHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        message: requiredString(json, 'message', 'Notification'),
        title: optionalString(json, 'title', 'Notification'),
        notificationType: requiredString(
          json,
          'notification_type',
          'Notification',
        ),
        raw: immutableJsonMap(json),
      ),
      HookEvent.subagentStart => SubagentStartHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        agentId: requiredString(json, 'agent_id', 'SubagentStart'),
        agentType: requiredString(json, 'agent_type', 'SubagentStart'),
        raw: immutableJsonMap(json),
      ),
      HookEvent.permissionRequest => PermissionRequestHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        toolName: requiredString(json, 'tool_name', 'PermissionRequest'),
        toolInput: asJsonMap(
          json['tool_input'],
          'PermissionRequest.tool_input',
        ),
        permissionSuggestions: switch (json['permission_suggestions']) {
          final List<Object?> values => List<JsonValue>.unmodifiable(
            values.map(immutableJsonValue),
          ),
          _ => const [],
        },
        agentId: optionalString(json, 'agent_id', 'PermissionRequest'),
        agentType: optionalString(json, 'agent_type', 'PermissionRequest'),
        raw: immutableJsonMap(json),
      ),
    };
  }
}

/// Hook input for a tool about to run.
final class PreToolUseHookInput extends HookInput {
  /// Creates a pre-tool input.
  PreToolUseHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.toolName,
    required this.toolInput,
    required this.toolUseId,
    required super.raw,
    super.permissionMode,
    this.agentId,
    this.agentType,
  }) : super(event: HookEvent.preToolUse);

  /// Tool name.
  final String toolName;

  /// Tool arguments.
  final JsonMap toolInput;

  /// Tool invocation ID.
  final String toolUseId;

  /// Subagent ID, when applicable.
  final String? agentId;

  /// Subagent type, when applicable.
  final String? agentType;
}

/// Hook input after a tool succeeds.
final class PostToolUseHookInput extends HookInput {
  /// Creates a post-tool input.
  PostToolUseHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.toolName,
    required this.toolInput,
    required this.toolResponse,
    required this.toolUseId,
    required super.raw,
    super.permissionMode,
    this.agentId,
    this.agentType,
  }) : super(event: HookEvent.postToolUse);

  /// Tool name.
  final String toolName;

  /// Tool arguments.
  final JsonMap toolInput;

  /// Tool response.
  final JsonValue toolResponse;

  /// Tool invocation ID.
  final String toolUseId;

  /// Subagent ID, when applicable.
  final String? agentId;

  /// Subagent type, when applicable.
  final String? agentType;
}

/// Hook input after a tool fails.
final class PostToolUseFailureHookInput extends HookInput {
  /// Creates a failed-tool input.
  PostToolUseFailureHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.toolName,
    required this.toolInput,
    required this.toolUseId,
    required this.error,
    required this.isInterrupt,
    required super.raw,
    super.permissionMode,
    this.agentId,
    this.agentType,
  }) : super(event: HookEvent.postToolUseFailure);

  /// Tool name.
  final String toolName;

  /// Tool arguments.
  final JsonMap toolInput;

  /// Tool invocation ID.
  final String toolUseId;

  /// Failure text.
  final String error;

  /// Whether the failure was caused by interruption.
  final bool isInterrupt;

  /// Subagent ID, when applicable.
  final String? agentId;

  /// Subagent type, when applicable.
  final String? agentType;
}

/// Hook input for a submitted user prompt.
final class UserPromptSubmitHookInput extends HookInput {
  /// Creates a prompt input.
  UserPromptSubmitHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.prompt,
    required super.raw,
    super.permissionMode,
  }) : super(event: HookEvent.userPromptSubmit);

  /// Submitted prompt.
  final String prompt;
}

/// Hook input for main-agent shutdown.
final class StopHookInput extends HookInput {
  /// Creates a stop input.
  StopHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.isStopHookActive,
    required super.raw,
    super.permissionMode,
  }) : super(event: HookEvent.stop);

  /// Whether a stop hook is already active.
  final bool isStopHookActive;
}

/// Hook input for subagent shutdown.
final class SubagentStopHookInput extends HookInput {
  /// Creates a subagent-stop input.
  SubagentStopHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.isStopHookActive,
    required this.agentId,
    required this.agentTranscriptPath,
    required this.agentType,
    required super.raw,
    super.permissionMode,
  }) : super(event: HookEvent.subagentStop);

  /// Whether a stop hook is already active.
  final bool isStopHookActive;

  /// Subagent identifier.
  final String agentId;

  /// Subagent transcript path.
  final String agentTranscriptPath;

  /// Subagent type name.
  final String agentType;
}

/// Hook input before context compaction.
final class PreCompactHookInput extends HookInput {
  /// Creates a pre-compact input.
  PreCompactHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.trigger,
    required super.raw,
    super.permissionMode,
    this.customInstructions,
  }) : super(event: HookEvent.preCompact);

  /// `manual` or `auto`.
  final String trigger;

  /// Optional compaction instructions.
  final String? customInstructions;
}

/// Hook input for an application notification.
final class NotificationHookInput extends HookInput {
  /// Creates a notification input.
  NotificationHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.message,
    required this.notificationType,
    required super.raw,
    super.permissionMode,
    this.title,
  }) : super(event: HookEvent.notification);

  /// Notification body.
  final String message;

  /// Optional notification title.
  final String? title;

  /// Notification category.
  final String notificationType;
}

/// Hook input when a subagent starts.
final class SubagentStartHookInput extends HookInput {
  /// Creates a subagent-start input.
  SubagentStartHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.agentId,
    required this.agentType,
    required super.raw,
    super.permissionMode,
  }) : super(event: HookEvent.subagentStart);

  /// Subagent identifier.
  final String agentId;

  /// Subagent type name.
  final String agentType;
}

/// Hook input for an application-level permission request.
final class PermissionRequestHookInput extends HookInput {
  /// Creates a permission-request input.
  PermissionRequestHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required this.toolName,
    required this.toolInput,
    required this.permissionSuggestions,
    required super.raw,
    super.permissionMode,
    this.agentId,
    this.agentType,
  }) : super(event: HookEvent.permissionRequest);

  /// Tool name.
  final String toolName;

  /// Tool arguments.
  final JsonMap toolInput;

  /// Raw permission suggestions.
  final List<JsonValue> permissionSuggestions;

  /// Subagent ID, when applicable.
  final String? agentId;

  /// Subagent type, when applicable.
  final String? agentType;
}

/// Event-specific output returned by a hook.
sealed class HookSpecificOutput {
  const HookSpecificOutput();

  /// Encodes this output for the CLI.
  JsonMap toJson();
}

/// Controls a pre-tool-use decision.
final class PreToolUseHookOutput extends HookSpecificOutput {
  /// Creates a pre-tool output.
  PreToolUseHookOutput({
    this.permissionDecision,
    this.permissionDecisionReason,
    JsonMap? updatedInput,
    this.additionalContext,
  }) : updatedInput = updatedInput == null
           ? null
           : immutableJsonMap(updatedInput);

  /// One of `allow`, `deny`, `ask`, or `defer`.
  final String? permissionDecision;

  /// Human-readable decision reason.
  final String? permissionDecisionReason;

  /// Replacement tool input.
  final JsonMap? updatedInput;

  /// Context added before the tool runs.
  final String? additionalContext;

  @override
  JsonMap toJson() => {
    'hookEventName': HookEvent.preToolUse.wireValue,
    if (permissionDecision != null) 'permissionDecision': permissionDecision,
    if (permissionDecisionReason != null)
      'permissionDecisionReason': permissionDecisionReason,
    if (updatedInput != null) 'updatedInput': updatedInput,
    if (additionalContext != null) 'additionalContext': additionalContext,
  };
}

/// Replaces or augments a successful tool result.
final class PostToolUseHookOutput extends HookSpecificOutput {
  /// Creates a post-tool output.
  PostToolUseHookOutput({this.additionalContext, JsonValue updatedToolOutput})
    : updatedToolOutput = immutableJsonValue(updatedToolOutput);

  /// Context added after the tool runs.
  final String? additionalContext;

  /// Replacement output, when non-null.
  final JsonValue updatedToolOutput;

  @override
  JsonMap toJson() => {
    'hookEventName': HookEvent.postToolUse.wireValue,
    if (additionalContext != null) 'additionalContext': additionalContext,
    if (updatedToolOutput != null) 'updatedToolOutput': updatedToolOutput,
  };
}

/// Adds context for a hook event that has no other typed controls.
final class AdditionalContextHookOutput extends HookSpecificOutput {
  /// Creates an additional-context output for [event].
  const AdditionalContextHookOutput({
    required this.event,
    required this.additionalContext,
  });

  /// Event to which the context applies.
  final HookEvent event;

  /// Context delivered to the agent.
  final String additionalContext;

  @override
  JsonMap toJson() => {
    'hookEventName': event.wireValue,
    'additionalContext': additionalContext,
  };
}

/// Supplies the decision for a permission-request hook.
final class PermissionRequestHookOutput extends HookSpecificOutput {
  /// Creates a permission-request output.
  PermissionRequestHookOutput(JsonMap decision)
    : decision = immutableJsonMap(decision);

  /// CLI permission decision object.
  final JsonMap decision;

  @override
  JsonMap toJson() => {
    'hookEventName': HookEvent.permissionRequest.wireValue,
    'decision': decision,
  };
}

/// Output returned by a hook callback.
final class HookOutput {
  /// Creates a synchronous hook output.
  const HookOutput({
    this.shouldContinue,
    this.suppressOutput,
    this.stopReason,
    this.shouldBlock = false,
    this.systemMessage,
    this.reason,
    this.specific,
  }) : isAsync = false,
       asyncTimeout = null;

  /// Creates an asynchronous/deferred hook output.
  HookOutput.async({Duration? timeout})
    : isAsync = true,
      asyncTimeout = timeout,
      shouldContinue = null,
      suppressOutput = null,
      stopReason = null,
      shouldBlock = false,
      systemMessage = null,
      reason = null,
      specific = null {
    if (timeout != null && timeout <= Duration.zero) {
      throw ArgumentError.value(timeout, 'timeout', 'must be positive');
    }
  }

  /// Whether the CLI should defer completion.
  final bool isAsync;

  /// Optional deferred-operation timeout.
  final Duration? asyncTimeout;

  /// Whether the agent should continue.
  final bool? shouldContinue;

  /// Whether to hide output from transcript mode.
  final bool? suppressOutput;

  /// Reason shown when continuation is disabled.
  final String? stopReason;

  /// Whether this hook blocks the current action.
  final bool shouldBlock;

  /// Warning shown to the user.
  final String? systemMessage;

  /// Feedback delivered to the agent.
  final String? reason;

  /// Event-specific output.
  final HookSpecificOutput? specific;

  /// Encodes this output for the CLI.
  JsonMap toJson() {
    if (isAsync) {
      return {
        'async': true,
        if (asyncTimeout != null) 'asyncTimeout': asyncTimeout!.inMilliseconds,
      };
    }
    return {
      if (shouldContinue != null) 'continue': shouldContinue,
      if (suppressOutput != null) 'suppressOutput': suppressOutput,
      if (stopReason != null) 'stopReason': stopReason,
      if (shouldBlock) 'decision': 'block',
      if (systemMessage != null) 'systemMessage': systemMessage,
      if (reason != null) 'reason': reason,
      if (specific != null) 'hookSpecificOutput': specific!.toJson(),
    };
  }
}

/// Invokes a configured SDK hook.
typedef HookCallback =
    Future<HookOutput> Function(HookInput input, String? toolUseId);

/// Matches one CLI hook event to one or more callbacks.
final class HookMatcher {
  /// Creates a hook matcher.
  HookMatcher({required List<HookCallback> hooks, this.matcher, this.timeout})
    : hooks = List<HookCallback>.unmodifiable(hooks) {
    if (hooks.isEmpty) {
      throw ArgumentError.value(hooks, 'hooks', 'must not be empty');
    }
    if (timeout != null && timeout! <= Duration.zero) {
      throw ArgumentError.value(timeout, 'timeout', 'must be positive');
    }
  }

  /// CLI matcher expression, such as `Bash` or `Write|Edit`.
  final String? matcher;

  /// Independent callbacks registered for this matcher.
  final List<HookCallback> hooks;

  /// Timeout applied by the CLI to each callback.
  final Duration? timeout;
}
