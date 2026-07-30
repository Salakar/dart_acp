import 'dart:async';

import 'json_values.dart';

/// Strong thread identity.
extension type const CodexThreadId(String value) {}

/// Strong turn identity.
extension type const CodexTurnId(String value) {}

/// Strong item identity.
extension type const CodexItemId(String value) {}

/// A routed app-server notification.
final class CodexNotification {
  /// Creates a notification.
  const CodexNotification({
    required this.method,
    required this.params,
    this.threadId,
    this.turnId,
    this.itemId,
  });

  /// JSON-RPC method.
  final String method;

  /// Validated immutable parameters.
  final CodexJsonObject params;

  /// Associated thread, when present.
  final CodexThreadId? threadId;

  /// Associated turn, when present.
  final CodexTurnId? turnId;

  /// Associated item, when present.
  final CodexItemId? itemId;
}

/// A request initiated by the app server.
sealed class CodexServerRequest {
  const CodexServerRequest({
    required this.threadId,
    required this.turnId,
    required this.params,
  });

  /// Associated thread.
  final CodexThreadId threadId;

  /// Associated turn, when the app server can correlate one.
  final CodexTurnId? turnId;

  /// Validated immutable parameters.
  final CodexJsonObject params;
}

/// Command approval request.
final class CodexCommandApprovalRequest extends CodexServerRequest {
  /// Creates a command approval request.
  const CodexCommandApprovalRequest({
    required super.threadId,
    required super.turnId,
    required super.params,
  });
}

/// File-change approval request.
final class CodexFileChangeApprovalRequest extends CodexServerRequest {
  /// Creates a file-change approval request.
  const CodexFileChangeApprovalRequest({
    required super.threadId,
    required super.turnId,
    required super.params,
  });
}

/// Generalized permissions request.
final class CodexPermissionsRequest extends CodexServerRequest {
  /// Creates a permissions request.
  const CodexPermissionsRequest({
    required super.threadId,
    required super.turnId,
    required super.params,
  });
}

/// MCP elicitation request.
final class CodexMcpElicitationRequest extends CodexServerRequest {
  /// Creates an MCP elicitation request.
  const CodexMcpElicitationRequest({
    required super.threadId,
    required super.turnId,
    required super.params,
  });
}

/// User-input request.
final class CodexUserInputRequest extends CodexServerRequest {
  /// Creates a user-input request.
  const CodexUserInputRequest({
    required super.threadId,
    required super.turnId,
    required super.params,
  });
}

/// A response handle for a server-initiated request.
final class CodexPendingServerRequest {
  /// Creates a pending request.
  const CodexPendingServerRequest({
    required this.request,
    required this.respond,
    required this.reject,
  });

  /// Typed request.
  final CodexServerRequest request;

  /// Sends a successful JSON response.
  final Future<void> Function(CodexJsonObject result) respond;

  /// Sends a JSON-RPC error.
  final Future<void> Function(int code, String message) reject;
}

/// Typed app-server backend used by the ACP adapter.
abstract interface class CodexBackend {
  /// Notifications emitted by the app server.
  Stream<CodexNotification> get notifications;

  /// Requests initiated by the app server.
  Stream<CodexPendingServerRequest> get requests;

  /// Sends one app-server request.
  Future<CodexJsonObject> request(
    String method, {
    CodexJsonObject params = CodexJsonObject.empty,
  });

  /// Sends one app-server notification.
  Future<void> notify(
    String method, {
    CodexJsonObject params = CodexJsonObject.empty,
  });

  /// Marks a completed/interrupted turn stale for future routing.
  void markTurnStale(CodexThreadId threadId, CodexTurnId turnId);

  /// Closes the backend idempotently.
  Future<void> close();
}
