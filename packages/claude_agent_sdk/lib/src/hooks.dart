import 'dart:async';

import 'elicitation.dart';
import 'json.dart';

/// A lifecycle point at which an SDK hook may run.
enum HookEvent {
  /// Before a tool starts.
  preToolUse('PreToolUse'),

  /// After a tool succeeds.
  postToolUse('PostToolUse'),

  /// After a tool fails.
  postToolUseFailure('PostToolUseFailure'),

  /// After every tool in a parallel batch settles.
  postToolBatch('PostToolBatch'),

  /// Before a user prompt enters the loop.
  userPromptSubmit('UserPromptSubmit'),

  /// After the runtime expands or transforms a user prompt.
  userPromptExpansion('UserPromptExpansion'),

  /// When a session starts.
  sessionStart('SessionStart'),

  /// When a session ends.
  sessionEnd('SessionEnd'),

  /// When the main agent is stopping.
  stop('Stop'),

  /// When the main agent fails while stopping.
  stopFailure('StopFailure'),

  /// When a subagent is stopping.
  subagentStop('SubagentStop'),

  /// Before context compaction.
  preCompact('PreCompact'),

  /// After context compaction.
  postCompact('PostCompact'),

  /// When the application emits a notification.
  notification('Notification'),

  /// When a subagent starts.
  subagentStart('SubagentStart'),

  /// When the application asks for permission.
  permissionRequest('PermissionRequest'),

  /// After a permission request is denied.
  permissionDenied('PermissionDenied'),

  /// During session setup.
  setup('Setup'),

  /// When an agent-team peer becomes idle.
  teammateIdle('TeammateIdle'),

  /// When a delegated task is created.
  taskCreated('TaskCreated'),

  /// When a delegated task completes.
  taskCompleted('TaskCompleted'),

  /// When MCP elicitation begins.
  elicitation('Elicitation'),

  /// After MCP elicitation completes.
  elicitationResult('ElicitationResult'),

  /// When effective configuration changes.
  configChange('ConfigChange'),

  /// When a worktree is created.
  worktreeCreate('WorktreeCreate'),

  /// When a worktree is removed.
  worktreeRemove('WorktreeRemove'),

  /// When instruction files are loaded.
  instructionsLoaded('InstructionsLoaded'),

  /// When the working directory changes.
  cwdChanged('CwdChanged'),

  /// When a watched file changes.
  fileChanged('FileChanged'),

  /// When a working-directory root is added.
  directoryAdded('DirectoryAdded'),

  /// While completed assistant lines are prepared for display.
  messageDisplay('MessageDisplay');

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

  /// Prompt-grain correlation identifier, when a prompt is active.
  String? get promptId => raw['prompt_id'] as String?;

  /// Subagent identifier, when this hook fired in a nested agent.
  String? get agentId => raw['agent_id'] as String?;

  /// Agent type on a subagent or `--agent` main thread.
  String? get agentType => raw['agent_type'] as String?;

  /// Forward-compatible active effort descriptor.
  JsonMap? get effort => raw['effort'] is Map<Object?, Object?>
      ? asJsonMap(raw['effort'], 'hook effort')
      : null;

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
      HookEvent.postToolBatch => PostToolBatchHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.userPromptExpansion => UserPromptExpansionHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.sessionStart => SessionStartHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.sessionEnd => SessionEndHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.stopFailure => StopFailureHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.postCompact => PostCompactHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.permissionDenied => PermissionDeniedHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.setup => SetupHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.teammateIdle => TeammateIdleHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.taskCreated => TaskCreatedHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.taskCompleted => TaskCompletedHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.elicitation => ElicitationHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.elicitationResult => ElicitationResultHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.configChange => ConfigChangeHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.worktreeCreate => WorktreeCreateHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.worktreeRemove => WorktreeRemoveHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.instructionsLoaded => InstructionsLoadedHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.cwdChanged => CwdChangedHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.fileChanged => FileChangedHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.directoryAdded => DirectoryAddedHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
      HookEvent.messageDisplay => MessageDisplayHookInput(
        sessionId: common.sessionId,
        transcriptPath: common.transcriptPath,
        cwd: common.cwd,
        permissionMode: common.permissionMode,
        raw: immutableJsonMap(json),
      ),
    };
  }
}

/// Forward-compatible typed wrapper for hook events without a specialized
/// Dart model.
final class GenericHookInput extends HookInput {
  /// Creates a generic hook input.
  GenericHookInput({
    required super.event,
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  });
}

/// Base for current hook events whose fields are read from their preserved
/// forward-compatible payload.
abstract base class StructuredHookInput extends HookInput {
  /// Creates a structured input and validates its required scalar fields.
  StructuredHookInput({
    required super.event,
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
    List<String> requiredStrings = const <String>[],
    List<String> requiredIntegers = const <String>[],
    List<String> requiredBooleans = const <String>[],
    List<String> requiredMaps = const <String>[],
    List<String> requiredLists = const <String>[],
  }) {
    for (final key in requiredStrings) {
      requiredString(raw, key, event.wireValue);
    }
    for (final key in requiredIntegers) {
      requiredInt(raw, key, event.wireValue);
    }
    for (final key in requiredBooleans) {
      requiredBool(raw, key, event.wireValue);
    }
    for (final key in requiredMaps) {
      asJsonMap(raw[key], '${event.wireValue}.$key');
    }
    for (final key in requiredLists) {
      if (raw[key] is! List<Object?>) {
        throw FormatException('${event.wireValue}.$key must be an array');
      }
    }
  }

  /// Reads an optional string field.
  String? string(String key) => optionalString(raw, key, event.wireValue);

  /// Reads a required string field validated by the constructor.
  String requiredStringField(String key) => raw[key]! as String;

  /// Reads an optional integer field.
  int? integer(String key) => optionalInt(raw, key, event.wireValue);

  /// Reads a required integer field validated by the constructor.
  int requiredIntegerField(String key) => raw[key]! as int;

  /// Reads an optional Boolean field.
  bool? boolean(String key) => optionalBool(raw, key, event.wireValue);

  /// Reads a required Boolean field validated by the constructor.
  bool requiredBooleanField(String key) => raw[key]! as bool;

  /// Reads an optional JSON object field.
  JsonMap? map(String key) => optionalMap(raw, key, event.wireValue);

  /// Reads a JSON-safe list field.
  List<JsonValue> list(String key) {
    final value = raw[key];
    if (value == null) return const <JsonValue>[];
    if (value is! List<Object?>) {
      throw FormatException('${event.wireValue}.$key must be an array');
    }
    return List<JsonValue>.unmodifiable(value.map(immutableJsonValue));
  }
}

/// Hook input after every tool in a parallel batch has settled.
final class PostToolBatchHookInput extends StructuredHookInput {
  /// Creates a post-tool-batch input.
  PostToolBatchHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.postToolBatch,
         requiredLists: const <String>['tool_calls'],
       );

  /// Completed tool calls in the batch.
  List<JsonValue> get toolCalls => list('tool_calls');
}

/// Hook input after a slash command or MCP prompt expands user input.
final class UserPromptExpansionHookInput extends StructuredHookInput {
  /// Creates a user-prompt-expansion input.
  UserPromptExpansionHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.userPromptExpansion,
         requiredStrings: const <String>[
           'expansion_type',
           'command_name',
           'command_args',
           'prompt',
         ],
       );

  /// Expansion kind (`slash_command` or `mcp_prompt`).
  String get expansionType => requiredStringField('expansion_type');

  /// Expanded command name.
  String get commandName => requiredStringField('command_name');

  /// Command arguments.
  String get commandArguments => requiredStringField('command_args');

  /// Optional command source.
  String? get commandSource => string('command_source');

  /// Expanded prompt.
  String get prompt => requiredStringField('prompt');
}

/// Hook input when a session starts.
final class SessionStartHookInput extends StructuredHookInput {
  /// Creates a session-start input.
  SessionStartHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.sessionStart,
         requiredStrings: const <String>['source'],
       );

  /// Startup source.
  String get source => requiredStringField('source');

  /// Main-thread agent type.
  @override
  String? get agentType => string('agent_type');

  /// Active model.
  String? get model => string('model');

  /// Current session title.
  String? get sessionTitle => string('session_title');
}

/// Hook input when a session ends.
final class SessionEndHookInput extends StructuredHookInput {
  /// Creates a session-end input.
  SessionEndHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.sessionEnd,
         requiredStrings: const <String>['reason'],
       );

  /// Open-set exit reason.
  String get reason => requiredStringField('reason');
}

/// Hook input when the main agent fails while stopping.
final class StopFailureHookInput extends StructuredHookInput {
  /// Creates a stop-failure input.
  StopFailureHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.stopFailure,
         requiredStrings: const <String>['error'],
       );

  /// Runtime error category.
  String get error => requiredStringField('error');

  /// Optional error details.
  String? get errorDetails => string('error_details');

  /// Last assistant text.
  String? get lastAssistantMessage => string('last_assistant_message');
}

/// Hook input after context compaction.
final class PostCompactHookInput extends StructuredHookInput {
  /// Creates a post-compact input.
  PostCompactHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.postCompact,
         requiredStrings: const <String>['trigger', 'compact_summary'],
       );

  /// Compaction trigger.
  String get trigger => requiredStringField('trigger');

  /// Conversation summary produced by compaction.
  String get compactSummary => requiredStringField('compact_summary');
}

/// Hook input after a tool permission is denied.
final class PermissionDeniedHookInput extends StructuredHookInput {
  /// Creates a permission-denied input.
  PermissionDeniedHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.permissionDenied,
         requiredStrings: const <String>['tool_name', 'tool_use_id', 'reason'],
       );

  /// Denied tool name.
  String get toolName => requiredStringField('tool_name');

  /// Unconstrained tool input.
  JsonValue get toolInput => immutableJsonValue(raw['tool_input']);

  /// Tool invocation ID.
  String get toolUseId => requiredStringField('tool_use_id');

  /// Denial reason.
  String get reason => requiredStringField('reason');
}

/// Hook input during session setup.
final class SetupHookInput extends StructuredHookInput {
  /// Creates a setup input.
  SetupHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.setup,
         requiredStrings: const <String>['trigger'],
       );

  /// Setup trigger (`init` or `maintenance`).
  String get trigger => requiredStringField('trigger');
}

/// Hook input when an agent-team peer becomes idle.
final class TeammateIdleHookInput extends StructuredHookInput {
  /// Creates a teammate-idle input.
  TeammateIdleHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.teammateIdle,
         requiredStrings: const <String>['teammate_name', 'team_name'],
       );

  /// Teammate display name.
  String get teammateName => requiredStringField('teammate_name');

  /// Legacy session-derived team name.
  String get teamName => requiredStringField('team_name');
}

/// Shared typed fields for task-created and task-completed hooks.
sealed class TaskHookInput extends StructuredHookInput {
  TaskHookInput({
    required super.event,
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(requiredStrings: const <String>['task_id', 'task_subject']);

  /// Task identifier.
  String get taskId => requiredStringField('task_id');

  /// Task subject.
  String get taskSubject => requiredStringField('task_subject');

  /// Optional task description.
  String? get taskDescription => string('task_description');

  /// Assigned teammate.
  String? get teammateName => string('teammate_name');

  /// Legacy session-derived team name.
  String? get teamName => string('team_name');
}

/// Hook input when a delegated task is created.
final class TaskCreatedHookInput extends TaskHookInput {
  /// Creates a task-created input.
  TaskCreatedHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(event: HookEvent.taskCreated);
}

/// Hook input when a delegated task completes.
final class TaskCompletedHookInput extends TaskHookInput {
  /// Creates a task-completed input.
  TaskCompletedHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(event: HookEvent.taskCompleted);
}

/// Hook input when an MCP server requests user input.
final class ElicitationHookInput extends StructuredHookInput {
  /// Creates an elicitation input.
  ElicitationHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.elicitation,
         requiredStrings: const <String>['mcp_server_name', 'message'],
       );

  /// Requesting MCP server.
  String get serverName => requiredStringField('mcp_server_name');

  /// User-facing request.
  String get message => requiredStringField('message');

  /// Request mode.
  String? get mode => string('mode');

  /// URL for a URL elicitation.
  String? get url => string('url');

  /// Correlation ID.
  String? get elicitationId => string('elicitation_id');

  /// Requested form schema.
  JsonMap? get requestedSchema => map('requested_schema');
}

/// Hook input after an MCP elicitation has been answered.
final class ElicitationResultHookInput extends StructuredHookInput {
  /// Creates an elicitation-result input.
  ElicitationResultHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.elicitationResult,
         requiredStrings: const <String>['mcp_server_name', 'action'],
       );

  /// Requesting MCP server.
  String get serverName => requiredStringField('mcp_server_name');

  /// Correlation ID.
  String? get elicitationId => string('elicitation_id');

  /// Request mode.
  String? get mode => string('mode');

  /// Final action.
  String get action => requiredStringField('action');

  /// Submitted form content.
  JsonMap? get content => map('content');
}

/// Hook input when effective configuration changes.
final class ConfigChangeHookInput extends StructuredHookInput {
  /// Creates a config-change input.
  ConfigChangeHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.configChange,
         requiredStrings: const <String>['source'],
       );

  /// Settings tier that changed.
  String get source => requiredStringField('source');

  /// Changed file, when filesystem-backed.
  String? get filePath => string('file_path');
}

/// Hook input before a worktree is created.
final class WorktreeCreateHookInput extends StructuredHookInput {
  /// Creates a worktree-create input.
  WorktreeCreateHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.worktreeCreate,
         requiredStrings: const <String>['name'],
       );

  /// Requested worktree name.
  String get name => requiredStringField('name');
}

/// Hook input before a worktree is removed.
final class WorktreeRemoveHookInput extends StructuredHookInput {
  /// Creates a worktree-remove input.
  WorktreeRemoveHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.worktreeRemove,
         requiredStrings: const <String>['worktree_path'],
       );

  /// Absolute worktree path.
  String get worktreePath => requiredStringField('worktree_path');
}

/// Hook input when an instruction or memory file is loaded.
final class InstructionsLoadedHookInput extends StructuredHookInput {
  /// Creates an instructions-loaded input.
  InstructionsLoadedHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.instructionsLoaded,
         requiredStrings: const <String>[
           'file_path',
           'memory_type',
           'load_reason',
         ],
       );

  /// Loaded file path.
  String get filePath => requiredStringField('file_path');

  /// Memory tier.
  String get memoryType => requiredStringField('memory_type');

  /// Load reason.
  String get loadReason => requiredStringField('load_reason');

  /// Matching globs.
  List<String> get globs =>
      list('globs').whereType<String>().toList(growable: false);

  /// File that triggered nested loading.
  String? get triggerFilePath => string('trigger_file_path');

  /// Parent instruction file.
  String? get parentFilePath => string('parent_file_path');
}

/// Hook input when the session working directory changes.
final class CwdChangedHookInput extends StructuredHookInput {
  /// Creates a cwd-changed input.
  CwdChangedHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.cwdChanged,
         requiredStrings: const <String>['old_cwd', 'new_cwd'],
       );

  /// Previous directory.
  String get oldCwd => requiredStringField('old_cwd');

  /// New directory.
  String get newCwd => requiredStringField('new_cwd');
}

/// Hook input when a watched file changes.
final class FileChangedHookInput extends StructuredHookInput {
  /// Creates a file-changed input.
  FileChangedHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.fileChanged,
         requiredStrings: const <String>['file_path', 'event'],
       );

  /// Changed file.
  String get filePath => requiredStringField('file_path');

  /// Change kind (`change`, `add`, or `unlink`).
  String get change => requiredStringField('event');
}

/// Hook input when a working-directory root is added.
final class DirectoryAddedHookInput extends StructuredHookInput {
  /// Creates a directory-added input.
  DirectoryAddedHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.directoryAdded,
         requiredStrings: const <String>['directory', 'source'],
       );

  /// Absolute added directory.
  String get directory => requiredStringField('directory');

  /// Addition source.
  String get source => requiredStringField('source');
}

/// Hook input for one display-only assistant text delta.
final class MessageDisplayHookInput extends StructuredHookInput {
  /// Creates a message-display input.
  MessageDisplayHookInput({
    required super.sessionId,
    required super.transcriptPath,
    required super.cwd,
    required super.raw,
    super.permissionMode,
  }) : super(
         event: HookEvent.messageDisplay,
         requiredStrings: const <String>['turn_id', 'message_id', 'delta'],
         requiredIntegers: const <String>['index'],
         requiredBooleans: const <String>['final'],
       );

  /// Turn identifier.
  String get turnId => requiredStringField('turn_id');

  /// Stable assistant message identifier.
  String get messageId => requiredStringField('message_id');

  /// Zero-based delta index.
  int get index => requiredIntegerField('index');

  /// Whether this is the last flush.
  bool get isFinal => requiredBooleanField('final');

  /// Newly completed display lines.
  String get delta => requiredStringField('delta');
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
  @override
  final String? agentId;

  /// Subagent type, when applicable.
  @override
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

  /// Tool execution time, excluding permission and hook latency.
  Duration? get duration => raw['duration_ms'] is num
      ? Duration(
          microseconds: ((raw['duration_ms']! as num).toDouble() * 1000)
              .round(),
        )
      : null;

  /// Subagent ID, when applicable.
  @override
  final String? agentId;

  /// Subagent type, when applicable.
  @override
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

  /// Tool execution time, excluding permission and hook latency.
  Duration? get duration => raw['duration_ms'] is num
      ? Duration(
          microseconds: ((raw['duration_ms']! as num).toDouble() * 1000)
              .round(),
        )
      : null;

  /// Subagent ID, when applicable.
  @override
  final String? agentId;

  /// Subagent type, when applicable.
  @override
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

  /// Experimental prompt source.
  String? get source => optionalString(raw, 'source', 'UserPromptSubmit');

  /// Session title visible when the prompt was submitted.
  String? get sessionTitle =>
      optionalString(raw, 'session_title', 'UserPromptSubmit');
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

  /// Last assistant text.
  String? get lastAssistantMessage =>
      optionalString(raw, 'last_assistant_message', 'Stop');

  /// In-flight background task descriptors.
  List<JsonMap> get backgroundTasks =>
      _jsonMapList(raw['background_tasks'], 'Stop.background_tasks');

  /// Session-scoped cron task descriptors.
  List<JsonMap> get sessionCrons =>
      _jsonMapList(raw['session_crons'], 'Stop.session_crons');
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
  @override
  final String agentId;

  /// Subagent transcript path.
  final String agentTranscriptPath;

  /// Subagent type name.
  @override
  final String agentType;

  /// Last assistant text from the subagent.
  String? get lastAssistantMessage =>
      optionalString(raw, 'last_assistant_message', 'SubagentStop');

  /// In-flight background task descriptors.
  List<JsonMap> get backgroundTasks =>
      _jsonMapList(raw['background_tasks'], 'SubagentStop.background_tasks');

  /// Session-scoped cron task descriptors.
  List<JsonMap> get sessionCrons =>
      _jsonMapList(raw['session_crons'], 'SubagentStop.session_crons');
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
  @override
  final String agentId;

  /// Subagent type name.
  @override
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
  @override
  final String? agentId;

  /// Subagent type, when applicable.
  @override
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
  PostToolUseHookOutput({
    this.additionalContext,
    JsonValue updatedToolOutput,
    JsonValue updatedMcpToolOutput,
  }) : updatedToolOutput = immutableJsonValue(updatedToolOutput),
       updatedMcpToolOutput = immutableJsonValue(updatedMcpToolOutput);

  /// Context added after the tool runs.
  final String? additionalContext;

  /// Replacement output, when non-null.
  final JsonValue updatedToolOutput;

  /// Legacy MCP-only replacement output.
  final JsonValue updatedMcpToolOutput;

  @override
  JsonMap toJson() => {
    'hookEventName': HookEvent.postToolUse.wireValue,
    if (additionalContext != null) 'additionalContext': additionalContext,
    if (updatedToolOutput != null) 'updatedToolOutput': updatedToolOutput,
    if (updatedMcpToolOutput != null)
      'updatedMCPToolOutput': updatedMcpToolOutput,
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

/// Overrides or observes an MCP elicitation hook result.
final class ElicitationHookOutput extends HookSpecificOutput {
  /// Creates an elicitation output for an elicitation event or result.
  ElicitationHookOutput({required this.event, this.action, JsonMap? content})
    : content = content == null ? null : immutableJsonMap(content) {
    if (event != HookEvent.elicitation &&
        event != HookEvent.elicitationResult) {
      throw ArgumentError.value(
        event,
        'event',
        'must be elicitation or elicitationResult',
      );
    }
    if (action != null &&
        action != 'accept' &&
        action != 'decline' &&
        action != 'cancel') {
      throw ArgumentError.value(action, 'action', 'is unsupported');
    }
  }

  /// Hook event to answer.
  final HookEvent event;

  /// Optional replacement action.
  final String? action;

  /// Optional accepted form content.
  final JsonMap? content;

  @override
  JsonMap toJson() => {
    'hookEventName': event.wireValue,
    if (action != null) 'action': action,
    if (content != null) 'content': content,
  };
}

/// Replaces the set of watched paths after a cwd/file change hook.
final class WatchPathsHookOutput extends HookSpecificOutput {
  /// Creates a watch-path output.
  WatchPathsHookOutput({required this.event, required List<String> watchPaths})
    : watchPaths = List<String>.unmodifiable(watchPaths) {
    if (event != HookEvent.cwdChanged && event != HookEvent.fileChanged) {
      throw ArgumentError.value(
        event,
        'event',
        'must be cwdChanged or fileChanged',
      );
    }
  }

  /// Hook event to answer.
  final HookEvent event;

  /// Replacement paths to watch.
  final List<String> watchPaths;

  @override
  JsonMap toJson() => {
    'hookEventName': event.wireValue,
    'watchPaths': watchPaths,
  };
}

/// Replaces one display-only assistant text delta.
final class MessageDisplayHookOutput extends HookSpecificOutput {
  /// Creates a display replacement.
  const MessageDisplayHookOutput({this.displayContent});

  /// Replacement display text.
  final String? displayContent;

  @override
  JsonMap toJson() => {
    'hookEventName': HookEvent.messageDisplay.wireValue,
    if (displayContent != null) 'displayContent': displayContent,
  };
}

/// Requests one retry after a denied permission hook.
final class PermissionDeniedHookOutput extends HookSpecificOutput {
  /// Creates a permission-denied output.
  const PermissionDeniedHookOutput({this.retry});

  /// Whether the runtime should retry the permission decision.
  final bool? retry;

  @override
  JsonMap toJson() => {
    'hookEventName': HookEvent.permissionDenied.wireValue,
    if (retry != null) 'retry': retry,
  };
}

/// Controls the initial state returned by a session-start hook.
final class SessionStartHookOutput extends HookSpecificOutput {
  /// Creates a session-start output.
  SessionStartHookOutput({
    this.additionalContext,
    this.initialUserMessage,
    this.sessionTitle,
    List<String> watchPaths = const <String>[],
    this.reloadSkills,
  }) : watchPaths = List<String>.unmodifiable(watchPaths);

  /// Context added to the session.
  final String? additionalContext;

  /// User message injected when the session starts.
  final String? initialUserMessage;

  /// Replacement session title.
  final String? sessionTitle;

  /// Paths registered for file-change hooks.
  final List<String> watchPaths;

  /// Whether skills and commands should be rescanned.
  final bool? reloadSkills;

  @override
  JsonMap toJson() => {
    'hookEventName': HookEvent.sessionStart.wireValue,
    if (additionalContext != null) 'additionalContext': additionalContext,
    if (initialUserMessage != null) 'initialUserMessage': initialUserMessage,
    if (sessionTitle != null) 'sessionTitle': sessionTitle,
    if (watchPaths.isNotEmpty) 'watchPaths': watchPaths,
    if (reloadSkills != null) 'reloadSkills': reloadSkills,
  };
}

/// Controls prompt-submit continuation and title behavior.
final class UserPromptSubmitHookOutput extends HookSpecificOutput {
  /// Creates a prompt-submit output.
  const UserPromptSubmitHookOutput({
    this.additionalContext,
    this.sessionTitle,
    this.suppressOriginalPrompt,
  });

  /// Context appended to the prompt.
  final String? additionalContext;

  /// Replacement session title.
  final String? sessionTitle;

  /// Whether a blocked response omits the original prompt.
  final bool? suppressOriginalPrompt;

  @override
  JsonMap toJson() => {
    'hookEventName': HookEvent.userPromptSubmit.wireValue,
    if (additionalContext != null) 'additionalContext': additionalContext,
    if (sessionTitle != null) 'sessionTitle': sessionTitle,
    if (suppressOriginalPrompt != null)
      'suppressOriginalPrompt': suppressOriginalPrompt,
  };
}

/// Supplies the absolute path created by a worktree-create hook.
final class WorktreeCreateHookOutput extends HookSpecificOutput {
  /// Creates a worktree-create output.
  const WorktreeCreateHookOutput({required this.worktreePath});

  /// Absolute created worktree path.
  final String worktreePath;

  @override
  JsonMap toJson() => {
    'hookEventName': HookEvent.worktreeCreate.wireValue,
    'worktreePath': worktreePath,
  };
}

/// Top-level synchronous hook decision.
enum HookDecision {
  /// Approve the current action.
  approve,

  /// Block the current action.
  block,
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
    this.decision,
    this.terminalSequence,
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
      specific = null,
      decision = null,
      terminalSequence = null {
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

  /// Explicit top-level approval/block decision.
  final HookDecision? decision;

  /// Safe notification/title terminal escape sequence.
  final String? terminalSequence;

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
      if (decision != null)
        'decision': decision!.name
      else if (shouldBlock)
        'decision': 'block',
      if (systemMessage != null) 'systemMessage': systemMessage,
      if (terminalSequence != null) 'terminalSequence': terminalSequence,
      if (reason != null) 'reason': reason,
      if (specific != null) 'hookSpecificOutput': specific!.toJson(),
    };
  }
}

/// Invokes a configured SDK hook.
typedef HookCallback =
    Future<HookOutput> Function(
      HookInput input,
      String? toolUseId,
      ControlCallbackContext context,
    );

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

List<JsonMap> _jsonMapList(Object? value, String context) {
  if (value == null) return const <JsonMap>[];
  if (value is! List<Object?>) {
    throw FormatException('$context must be an array');
  }
  return List<JsonMap>.unmodifiable(
    value.map((item) => asJsonMap(item, context)),
  );
}
