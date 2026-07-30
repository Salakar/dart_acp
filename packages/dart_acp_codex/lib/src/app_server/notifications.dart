import '../runtime/diagnostics.dart';
import 'backend.dart';
import 'json_values.dart';

/// Decodes an app-server notification and its routing identities.
CodexNotification decodeCodexNotification(String method, Object? rawParams) {
  final params = _objectParams(rawParams, method);
  return CodexNotification(
    method: method,
    params: params,
    threadId: _threadId(params),
    turnId: _turnId(params),
    itemId: _itemId(params),
  );
}

/// Decodes one supported server-initiated request.
CodexServerRequest decodeCodexServerRequest(String method, Object? rawParams) {
  final params = _objectParams(rawParams, method);
  final thread = _requiredNestedString(params, 'threadId', method);
  final threadId = CodexThreadId(thread);
  return switch (method) {
    'item/commandExecution/requestApproval' => CodexCommandApprovalRequest(
      threadId: threadId,
      turnId: CodexTurnId(_requiredNestedString(params, 'turnId', method)),
      params: params,
    ),
    'item/fileChange/requestApproval' => CodexFileChangeApprovalRequest(
      threadId: threadId,
      turnId: CodexTurnId(_requiredNestedString(params, 'turnId', method)),
      params: params,
    ),
    'item/permissions/requestApproval' => CodexPermissionsRequest(
      threadId: threadId,
      turnId: CodexTurnId(_requiredNestedString(params, 'turnId', method)),
      params: params,
    ),
    'mcpServer/elicitation/request' => CodexMcpElicitationRequest(
      threadId: threadId,
      turnId: _optionalTurnId(params),
      params: params,
    ),
    'item/tool/requestUserInput' => CodexUserInputRequest(
      threadId: threadId,
      turnId: CodexTurnId(_requiredNestedString(params, 'turnId', method)),
      params: params,
    ),
    _ => throw CodexProtocolException(
      'Unsupported app-server request method $method.',
    ),
  };
}

/// Whether [method] is a supported app-server initiated request.
bool isCodexServerRequestMethod(String method) => switch (method) {
  'item/commandExecution/requestApproval' ||
  'item/fileChange/requestApproval' ||
  'item/permissions/requestApproval' ||
  'mcpServer/elicitation/request' ||
  'item/tool/requestUserInput' => true,
  _ => false,
};

CodexTurnId? _optionalTurnId(CodexJsonObject params) {
  final id = params.optionalString('turnId');
  return id == null ? null : CodexTurnId(id);
}

CodexJsonObject _objectParams(Object? value, String method) {
  if (value == null) {
    return CodexJsonObject.empty;
  }
  if (value is Map<Object?, Object?>) {
    return CodexJsonObject.from(value);
  }
  throw CodexProtocolException('$method params must be an object.');
}

CodexThreadId? _threadId(CodexJsonObject params) {
  final value = _firstString(params, const <String>[
    'threadId',
    'conversationId',
  ]);
  return value == null ? null : CodexThreadId(value);
}

CodexTurnId? _turnId(CodexJsonObject params) {
  final direct = _firstString(params, const <String>['turnId']);
  if (direct != null) {
    return CodexTurnId(direct);
  }
  final turn = params.optionalObject('turn');
  final nested = turn?.optionalString('id');
  return nested == null ? null : CodexTurnId(nested);
}

CodexItemId? _itemId(CodexJsonObject params) {
  final direct = _firstString(params, const <String>['itemId']);
  if (direct != null) {
    return CodexItemId(direct);
  }
  final item = params.optionalObject('item');
  final nested = item?.optionalString('id');
  return nested == null ? null : CodexItemId(nested);
}

String? _firstString(CodexJsonObject params, List<String> keys) {
  for (final key in keys) {
    if (params.containsKey(key)) {
      return params.optionalString(key);
    }
  }
  return null;
}

String _requiredNestedString(
  CodexJsonObject params,
  String key,
  String method,
) {
  final value = params.optionalString(key);
  if (value == null || value.isEmpty) {
    throw CodexProtocolException('$method requires a non-empty $key.');
  }
  return value;
}
