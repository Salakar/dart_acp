import 'dart:async';

import 'batch.dart';
import 'cancellation.dart';
import 'error.dart';
import 'id.dart';
import 'message.dart';
import 'params.dart';

/// The connection operations available to a JSON-RPC handler.
abstract interface class JsonRpcHandlerContext {
  /// Sends a request and decodes its successful result.
  Future<T> sendRequest<T>({
    required String method,
    JsonRpcParams params = const JsonRpcParams.absent(),
    T Function(Object? value)? decode,
    CancellationToken? cancellationToken,
  });

  /// Sends a notification.
  Future<void> sendNotification({
    required String method,
    JsonRpcParams params = const JsonRpcParams.absent(),
  });

  /// Sends a non-empty call batch in one transport frame.
  Future<List<Object?>> sendBatch(List<JsonRpcBatchEntry> entries);

  /// Sends the protocol cancellation notification.
  Future<void> sendCancelRequest(JsonRpcId requestId);

  /// Adds a handler that can be removed independently.
  HandlerRegistration addHandler(JsonRpcHandler handler);

  /// Cancels when the connection closes.
  CancellationToken get cancellationToken;

  /// Completes when the connection closes.
  Future<void> get done;
}

/// An incoming JSON-RPC request or notification.
sealed class IncomingJsonRpcMessage {
  const IncomingJsonRpcMessage({
    required this.method,
    required this.params,
    required this.raw,
  });

  /// The method name.
  final String method;

  /// Optional params.
  final JsonRpcParams params;

  /// A defensive copy of the raw wire object.
  final Map<String, Object?> raw;
}

/// An incoming request passed to handlers.
final class IncomingJsonRpcRequest extends IncomingJsonRpcMessage {
  /// Creates an incoming request.
  const IncomingJsonRpcRequest({
    required this.id,
    required this.responder,
    required super.method,
    required super.params,
    required super.raw,
  });

  /// The request ID.
  final JsonRpcId id;

  /// Completes this request.
  final JsonRpcRequestResponder responder;

  /// Cancels when the peer requests cancellation or the connection closes.
  CancellationToken get cancellationToken => responder.cancellationToken;
}

/// An incoming notification passed to handlers.
final class IncomingJsonRpcNotification extends IncomingJsonRpcMessage {
  /// Creates an incoming notification.
  const IncomingJsonRpcNotification({
    required super.method,
    required super.params,
    required super.raw,
  });
}

/// A handler-chain disposition.
sealed class JsonRpcHandleResult {
  const JsonRpcHandleResult();
}

/// Stops dispatch because the message was handled.
final class JsonRpcHandled extends JsonRpcHandleResult {
  /// Creates a handled disposition.
  const JsonRpcHandled();
}

/// Passes a message to later handlers.
final class JsonRpcPass extends JsonRpcHandleResult {
  /// Creates a pass-through disposition.
  const JsonRpcPass({this.message, this.retry = false});

  /// An optional replacement message.
  final IncomingJsonRpcMessage? message;

  /// Whether an otherwise unhandled message should wait for a future handler.
  final bool retry;
}

/// A lower-level JSON-RPC handler.
typedef JsonRpcHandler =
    FutureOr<JsonRpcHandleResult?> Function(
      IncomingJsonRpcMessage message,
      JsonRpcHandlerContext context,
    );

/// Parses raw params into a typed value.
typedef JsonRpcParamsParser<T> = T Function(Object? params);

/// Handles a typed request.
typedef JsonRpcRequestHandler<T> =
    FutureOr<JsonRpcHandleResult?> Function(
      T params,
      JsonRpcRequestResponder responder,
      JsonRpcHandlerContext context,
    );

/// Handles a typed notification.
typedef JsonRpcNotificationHandler<T> =
    FutureOr<JsonRpcHandleResult?> Function(
      T params,
      JsonRpcHandlerContext context,
    );

/// Completes one incoming request exactly once.
final class JsonRpcRequestResponder {
  JsonRpcRequestResponder._({
    required this.id,
    required this.cancellationToken,
    required Future<void> Function(JsonRpcResponse response) send,
    required void Function() finish,
  }) : _send = send,
       _finish = finish;

  /// Creates a responder for connection internals.
  factory JsonRpcRequestResponder.internal({
    required JsonRpcId id,
    required CancellationToken cancellationToken,
    required Future<void> Function(JsonRpcResponse response) send,
    required void Function() finish,
  }) => JsonRpcRequestResponder._(
    id: id,
    cancellationToken: cancellationToken,
    send: send,
    finish: finish,
  );

  /// The request ID.
  final JsonRpcId id;

  /// The request cancellation token.
  final CancellationToken cancellationToken;

  final Future<void> Function(JsonRpcResponse response) _send;
  final void Function() _finish;
  bool _hasResponded = false;

  /// Whether a response has already been initiated.
  bool get hasResponded => _hasResponded;

  /// Sends a successful result, including JSON `null`.
  Future<void> respond(Object? result) {
    return _respond(JsonRpcSuccessResponse(id: id, result: result));
  }

  /// Sends a failed result.
  Future<void> respondError(JsonRpcErrorObject error) {
    return _respond(JsonRpcErrorResponse(id: id, error: error));
  }

  /// Sends a failed result from [exception].
  Future<void> respondException(JsonRpcRequestException exception) {
    return respondError(exception.error);
  }

  Future<void> _respond(JsonRpcResponse response) {
    if (_hasResponded) {
      return Future<void>.error(
        StateError('JSON-RPC request already responded'),
      );
    }
    _hasResponded = true;
    return _send(response).whenComplete(_finish);
  }
}

/// An idempotent dynamic-handler registration.
final class HandlerRegistration {
  HandlerRegistration._(this._dispose);

  /// Creates a registration for connection internals.
  factory HandlerRegistration.internal(void Function() dispose) =>
      HandlerRegistration._(dispose);

  void Function()? _dispose;

  /// Removes the associated handler.
  void dispose() {
    final void Function()? dispose = _dispose;
    _dispose = null;
    dispose?.call();
  }
}
