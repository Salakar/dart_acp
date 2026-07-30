import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../runtime/diagnostics.dart';
import 'backend.dart';
import 'json_values.dart';
import 'notifications.dart';
import 'process_transport.dart';

/// JSON-RPC implementation of [CodexBackend].
final class CodexJsonRpcBackend implements CodexBackend {
  /// Connects to an app-server transport.
  CodexJsonRpcBackend.connect(
    AcpDuplexStream<Object?> stream, {
    JsonRpcConnectionOptions options = const JsonRpcConnectionOptions(),
    Future<void> Function()? onClose,
  }) : _onClose = onClose {
    _connection = JsonRpcConnection(
      stream: normalizedAppServerStream(stream),
      handlers: <JsonRpcHandler>[_handleIncoming],
      options: options,
    );
    unawaited(
      _connection.done.whenComplete(() async {
        await _closeControllers();
      }),
    );
  }

  late final JsonRpcConnection _connection;
  final Future<void> Function()? _onClose;
  final StreamController<CodexNotification> _notifications =
      StreamController<CodexNotification>.broadcast(sync: true);
  final StreamController<CodexPendingServerRequest> _requests =
      StreamController<CodexPendingServerRequest>.broadcast(sync: true);
  final Map<String, Set<String>> _staleTurns = <String, Set<String>>{};
  Future<void>? _closeFuture;
  bool _controllersClosed = false;

  @override
  Stream<CodexNotification> get notifications => _notifications.stream;

  @override
  Stream<CodexPendingServerRequest> get requests => _requests.stream;

  @override
  Future<CodexJsonObject> request(
    String method, {
    CodexJsonObject params = CodexJsonObject.empty,
  }) {
    if (method.trim().isEmpty) {
      throw ArgumentError.value(method, 'method', 'must not be empty');
    }
    return _connection.sendRequest<CodexJsonObject>(
      method: method,
      params: JsonRpcParams.value(params.toJson()),
      decode: _decodeResult,
    );
  }

  @override
  Future<void> notify(
    String method, {
    CodexJsonObject params = CodexJsonObject.empty,
  }) {
    if (method.trim().isEmpty) {
      throw ArgumentError.value(method, 'method', 'must not be empty');
    }
    return _connection.sendNotification(
      method: method,
      params: JsonRpcParams.value(params.toJson()),
    );
  }

  @override
  void markTurnStale(CodexThreadId threadId, CodexTurnId turnId) {
    _staleTurns.putIfAbsent(threadId.value, () => <String>{}).add(turnId.value);
  }

  Future<JsonRpcHandleResult?> _handleIncoming(
    IncomingJsonRpcMessage message,
    JsonRpcHandlerContext _,
  ) async {
    if (message is IncomingJsonRpcNotification) {
      final notification = decodeCodexNotification(
        message.method,
        message.params.value,
      );
      if (!_isStale(notification.threadId, notification.turnId) &&
          !_notifications.isClosed) {
        _notifications.add(notification);
      }
      return const JsonRpcHandled();
    }
    if (message is! IncomingJsonRpcRequest) {
      return const JsonRpcPass();
    }
    if (!isCodexServerRequestMethod(message.method)) {
      await message.responder.respondError(
        JsonRpcErrorObject(code: -32601, message: 'Method not found'),
      );
      return const JsonRpcHandled();
    }

    try {
      final request = decodeCodexServerRequest(
        message.method,
        message.params.value,
      );
      if (_isStale(request.threadId, request.turnId) ||
          !_requests.hasListener) {
        await message.responder.respond(_safeDefault(request).toJson());
        return const JsonRpcHandled();
      }
      final pending = CodexPendingServerRequest(
        request: request,
        respond: (result) => message.responder.respond(result.toJson()),
        reject: (code, errorMessage) => message.responder.respondError(
          JsonRpcErrorObject(code: code, message: errorMessage),
        ),
      );
      _requests.add(pending);
    } on CodexProtocolException {
      if (!message.responder.hasResponded) {
        await message.responder.respondError(
          JsonRpcErrorObject(code: -32602, message: 'Invalid params'),
        );
      }
    }
    return const JsonRpcHandled();
  }

  bool _isStale(CodexThreadId? threadId, CodexTurnId? turnId) {
    if (threadId == null || turnId == null) {
      return false;
    }
    return _staleTurns[threadId.value]?.contains(turnId.value) ?? false;
  }

  CodexJsonObject _safeDefault(CodexServerRequest request) {
    final value = switch (request) {
      CodexCommandApprovalRequest() || CodexFileChangeApprovalRequest() =>
        <Object?, Object?>{'decision': 'cancel'},
      CodexPermissionsRequest() => <Object?, Object?>{
        'permissions': <Object?, Object?>{},
        'scope': 'turn',
        'strictAutoReview': true,
      },
      CodexMcpElicitationRequest() => <Object?, Object?>{
        'action': 'cancel',
        'content': null,
        '_meta': null,
      },
      CodexUserInputRequest() => <Object?, Object?>{
        'answers': <Object?, Object?>{},
      },
    };
    return CodexJsonObject.from(value);
  }

  CodexJsonObject _decodeResult(Object? value) {
    if (value == null) {
      return CodexJsonObject.empty;
    }
    if (value is Map<Object?, Object?>) {
      return CodexJsonObject.from(value);
    }
    throw const CodexProtocolException(
      'App-server result must be an object or null.',
    );
  }

  @override
  Future<void> close() {
    return _closeFuture ??= _doClose();
  }

  Future<void> _doClose() async {
    await _connection.dispose();
    await _closeControllers();
    await _onClose?.call();
  }

  Future<void> _closeControllers() async {
    if (_controllersClosed) {
      return;
    }
    _controllersClosed = true;
    await _notifications.close();
    await _requests.close();
  }
}
