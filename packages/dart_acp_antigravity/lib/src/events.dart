import 'dart:convert';

/// One decoded line of Antigravity CLI `--output-format stream-json` output.
///
/// The stream is newline-delimited JSON. Every known line is one of
/// [AntigravityInitEvent], [AntigravityStepUpdateEvent], or
/// [AntigravityResultEvent]. Unknown or malformed lines decode to `null` so
/// callers can skip diagnostics the CLI interleaves with the stream.
sealed class AntigravityEvent {
  const AntigravityEvent();

  /// Decodes one stream line, or returns `null` when the line is not a known
  /// stream-json event.
  static AntigravityEvent? tryParse(String line) {
    final String trimmed = line.trim();
    if (trimmed.isEmpty || !trimmed.startsWith('{')) {
      return null;
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(trimmed);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, Object?>) {
      return null;
    }
    return switch (decoded['event']) {
      'init' => AntigravityInitEvent._fromJson(
        decoded,
        _object(decoded['init']),
      ),
      'step_update' => AntigravityStepUpdateEvent._fromJson(
        _object(decoded['step_update']),
      ),
      'result' => AntigravityResultEvent._fromJson(_object(decoded['result'])),
      _ => null,
    };
  }

  static Map<String, Object?> _object(Object? value) =>
      value is Map<String, Object?> ? value : const <String, Object?>{};

  static String? _string(Object? value) => value is String ? value : null;
}

/// First event of every print-mode run, announcing the conversation.
final class AntigravityInitEvent extends AntigravityEvent {
  /// Creates an init event.
  const AntigravityInitEvent({
    required this.conversationId,
    this.cwd,
    this.permissionMode,
    this.tools = const <String>[],
  });

  factory AntigravityInitEvent._fromJson(
    Map<String, Object?> envelope,
    Map<String, Object?> init,
  ) {
    final Object? tools = init['tools'];
    return AntigravityInitEvent(
      conversationId:
          AntigravityEvent._string(envelope['conversation_id']) ?? '',
      cwd: AntigravityEvent._string(init['cwd']),
      permissionMode: AntigravityEvent._string(init['permission_mode']),
      tools: tools is List<Object?>
          ? List<String>.unmodifiable(tools.whereType<String>())
          : const <String>[],
    );
  }

  /// Identifier of the conversation this run appends to.
  final String conversationId;

  /// Working directory the CLI resolved for the run.
  final String? cwd;

  /// Effective permission mode, for example `request-review`.
  final String? permissionMode;

  /// Names of the tools available to the agent.
  final List<String> tools;
}

/// Progress update for one step of the running turn.
final class AntigravityStepUpdateEvent extends AntigravityEvent {
  /// Creates a step update.
  const AntigravityStepUpdateEvent({
    required this.stepIndex,
    required this.state,
    required this.stepType,
    this.conversationId,
    this.textDelta,
    this.toolName,
    this.toolParameters,
    this.toolOutput,
    this.toolErrorMessage,
  });

  factory AntigravityStepUpdateEvent._fromJson(Map<String, Object?> step) {
    final Map<String, Object?> toolInfo = AntigravityEvent._object(
      step['tool_info'],
    );
    final Map<String, Object?> error = AntigravityEvent._object(
      toolInfo['error'],
    );
    final Object? parameters = toolInfo['parameters'];
    return AntigravityStepUpdateEvent(
      conversationId: AntigravityEvent._string(step['conversation_id']),
      stepIndex: step['step_index'] is int ? step['step_index']! as int : -1,
      state: AntigravityEvent._string(step['state']) ?? '',
      stepType: AntigravityEvent._string(step['step_type']) ?? '',
      textDelta: AntigravityEvent._string(step['text_delta']),
      toolName:
          AntigravityEvent._string(step['tool_name']) ??
          AntigravityEvent._string(toolInfo['name']),
      toolParameters: parameters is Map<String, Object?>
          ? Map<String, Object?>.unmodifiable(parameters)
          : null,
      toolOutput: AntigravityEvent._string(toolInfo['output']),
      toolErrorMessage: AntigravityEvent._string(error['message']),
    );
  }

  /// Identifier of the conversation this step belongs to.
  final String? conversationId;

  /// Monotonic step position within the conversation, or `-1` when absent.
  final int stepIndex;

  /// Step lifecycle state: `ACTIVE`, `DONE`, or `ERROR`.
  final String state;

  /// Step category, for example `agent_response` or `tool`.
  final String stepType;

  /// Incremental agent text produced by this update, when any.
  final String? textDelta;

  /// Name of the tool a `tool` step invokes.
  final String? toolName;

  /// Arguments of the tool invocation, when reported.
  final Map<String, Object?>? toolParameters;

  /// Output of the completed tool invocation, when reported.
  final String? toolOutput;

  /// Failure message of an `ERROR` tool step, when reported.
  final String? toolErrorMessage;

  /// Whether this update reports a terminal step state.
  bool get isFinished => state == 'DONE' || state == 'ERROR';
}

/// Terminal event summarizing the completed print-mode run.
final class AntigravityResultEvent extends AntigravityEvent {
  /// Creates a result event.
  const AntigravityResultEvent({
    required this.status,
    this.conversationId,
    this.response,
  });

  factory AntigravityResultEvent._fromJson(Map<String, Object?> result) =>
      AntigravityResultEvent(
        conversationId: AntigravityEvent._string(result['conversation_id']),
        status: AntigravityEvent._string(result['status']) ?? '',
        response: AntigravityEvent._string(result['response']),
      );

  /// Identifier of the conversation the run appended to.
  final String? conversationId;

  /// Run outcome reported by the CLI, `SUCCESS` on a completed turn.
  final String status;

  /// Final response text of the turn.
  final String? response;

  /// Whether the CLI reported a successful turn.
  bool get isSuccess => status == 'SUCCESS';
}
