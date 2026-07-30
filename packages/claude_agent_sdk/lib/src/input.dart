import 'json.dart';

/// One user input frame accepted by [queryStream] and [ClaudeAgentClient].
final class UserInput {
  /// Creates a user input frame.
  UserInput({
    required JsonValue content,
    this.sessionId = 'default',
    this.parentToolUseId,
    this.uuid,
    this.priority,
  }) : content = immutableJsonValue(content) {
    if (content is! String && content is! List<Object?>) {
      throw ArgumentError.value(
        content,
        'content',
        'must be text or a JSON content-block list',
      );
    }
  }

  /// Creates a plain-text input.
  UserInput.text(
    String text, {
    String sessionId = 'default',
    String? parentToolUseId,
    String? uuid,
    String? priority,
  }) : this(
         content: text,
         sessionId: sessionId,
         parentToolUseId: parentToolUseId,
         uuid: uuid,
         priority: priority,
       );

  /// Text or JSON content blocks.
  final JsonValue content;

  /// Conversation session identifier.
  final String sessionId;

  /// Parent tool invocation for a subagent message.
  final String? parentToolUseId;

  /// Client-generated turn identifier echoed by interactive runtimes.
  final String? uuid;

  /// Open-set delivery priority such as `now` for steering input.
  final String? priority;

  /// Encodes this input for the CLI.
  JsonMap toJson() => {
    'type': 'user',
    'message': {'role': 'user', 'content': content},
    'parent_tool_use_id': parentToolUseId,
    'session_id': sessionId,
    if (uuid != null) 'uuid': uuid,
    if (priority != null) 'priority': priority,
  };
}
