import 'dart:async';

import 'json.dart';

/// Cancellation signal for an incoming control callback.
final class ControlCallbackCancellation {
  /// Creates an uncancelled callback signal.
  ControlCallbackCancellation({this.requestId});

  /// Incoming control request identifier.
  final String? requestId;

  final Completer<void> _cancelled = Completer<void>();

  /// Whether cancellation was requested by the runtime.
  bool get isCancelled => _cancelled.isCompleted;

  /// Completes when cancellation is requested.
  Future<void> get whenCancelled => _cancelled.future;

  /// Requests cancellation idempotently.
  void cancel() {
    if (!_cancelled.isCompleted) _cancelled.complete();
  }
}

/// Context shared by interactive control callbacks.
final class ControlCallbackContext {
  /// Creates a callback context.
  const ControlCallbackContext({required this.cancellation});

  /// Cooperative cancellation signal.
  final ControlCallbackCancellation cancellation;
}

/// MCP elicitation mode.
enum ClaudeElicitationMode {
  /// Structured form input.
  form,

  /// Browser-based URL flow.
  url;

  static ClaudeElicitationMode _fromWire(String value) => switch (value) {
    'form' => form,
    'url' => url,
    _ => throw FormatException('Unknown elicitation mode: $value'),
  };
}

/// Interactive request raised by an MCP server.
final class ClaudeElicitationRequest {
  /// Decodes a control-protocol elicitation.
  ClaudeElicitationRequest.fromJson(JsonMap json)
    : mode = ClaudeElicitationMode._fromWire(
        optionalString(json, 'mode', 'elicitation') ?? 'form',
      ),
      serverName = optionalString(json, 'mcp_server_name', 'elicitation'),
      message = requiredString(json, 'message', 'elicitation'),
      elicitationId = optionalString(json, 'elicitation_id', 'elicitation'),
      url = optionalString(json, 'url', 'elicitation'),
      schema = (json['requested_schema'] ?? json['requestedSchema']) == null
          ? null
          : immutableJsonMap(
              asJsonMap(
                json['requested_schema'] ?? json['requestedSchema'],
                'elicitation schema',
              ),
            ),
      title = optionalString(json, 'title', 'elicitation'),
      displayName = optionalString(json, 'display_name', 'elicitation'),
      description = optionalString(json, 'description', 'elicitation'),
      raw = immutableJsonMap(json);

  /// Requested interaction mode.
  final ClaudeElicitationMode mode;

  /// MCP server that raised the request.
  final String? serverName;

  /// Human-readable request text.
  final String message;

  /// Request identifier, when provided.
  final String? elicitationId;

  /// URL to open for URL mode.
  final String? url;

  /// Form JSON Schema for form mode.
  final JsonMap? schema;

  /// Permission-style display title supplied by the server.
  final String? title;

  /// Compact server/tool display label.
  final String? displayName;

  /// Permission-style display description.
  final String? description;

  /// Complete forward-compatible payload.
  final JsonMap raw;
}

/// Elicitation decision.
enum ClaudeElicitationAction {
  /// User supplied data.
  accept,

  /// User explicitly declined.
  decline,

  /// Interaction was abandoned.
  cancel,
}

/// Result returned by [OnClaudeElicitation].
final class ClaudeElicitationResult {
  /// Creates an elicitation result.
  ClaudeElicitationResult({required this.action, JsonMap? content})
    : content = content == null ? null : immutableJsonMap(content);

  /// Accepts with structured [content].
  ClaudeElicitationResult.accept(JsonMap content)
    : this(action: ClaudeElicitationAction.accept, content: content);

  /// Declines an elicitation.
  const ClaudeElicitationResult.decline()
    : action = ClaudeElicitationAction.decline,
      content = null;

  /// Cancels an elicitation.
  const ClaudeElicitationResult.cancel()
    : action = ClaudeElicitationAction.cancel,
      content = null;

  /// Decision.
  final ClaudeElicitationAction action;

  /// Accepted form data.
  final JsonMap? content;

  /// Encodes the control response.
  JsonMap toJson() => <String, Object?>{
    'action': action.name,
    if (content != null) 'content': content,
  };
}

/// Handles one MCP elicitation.
typedef OnClaudeElicitation =
    Future<ClaudeElicitationResult> Function(
      ClaudeElicitationRequest request,
      ControlCallbackContext context,
    );

/// Non-tool dialog raised by the runtime.
final class ClaudeUserDialogRequest {
  /// Decodes a user dialog.
  ClaudeUserDialogRequest.fromJson(JsonMap json)
    : dialogKind = _dialogKind(json),
      title = optionalString(json, 'title', 'user dialog'),
      message = optionalString(json, 'message', 'user dialog'),
      payload = json['payload'] == null
          ? const <String, Object?>{}
          : immutableJsonMap(asJsonMap(json['payload'], 'user dialog payload')),
      raw = immutableJsonMap(json);

  /// Declared dialog kind.
  final String dialogKind;

  /// Optional display title.
  final String? title;

  /// Optional display message.
  final String? message;

  /// Kind-specific typed boundary payload.
  final JsonMap payload;

  /// Complete forward-compatible request.
  final JsonMap raw;
}

String _dialogKind(JsonMap json) {
  for (final key in const <String>['dialog_kind', 'dialogKind', 'kind']) {
    final value = json[key];
    if (value is String && value.isNotEmpty) return value;
  }
  throw const FormatException('user dialog requires a dialog kind');
}

/// Result returned by [OnClaudeUserDialog].
final class ClaudeUserDialogResult {
  /// Completes a dialog with its kind-specific wire [result].
  const ClaudeUserDialogResult.completed(this.result) : behavior = 'completed';

  /// Cancels a dialog so the runtime applies its safe default.
  const ClaudeUserDialogResult.cancelled()
    : behavior = 'cancelled',
      result = null;

  /// Response behavior (`completed` or `cancelled`).
  final String behavior;

  /// Kind-specific result for a completed dialog.
  final String? result;

  /// Encodes the control response.
  JsonMap toJson() => <String, Object?>{
    'behavior': behavior,
    if (result != null) 'result': result,
  };
}

/// Handles a declared non-tool dialog.
typedef OnClaudeUserDialog =
    Future<ClaudeUserDialogResult> Function(
      ClaudeUserDialogRequest request,
      ControlCallbackContext context,
    );
