import 'dart:async';

import '../transport/duplex_stream.dart';
import 'batch.dart';
import 'cancellation.dart';
import 'codec.dart';
import 'error.dart';
import 'handler.dart';
import 'id.dart';
import 'message.dart';
import 'params.dart';

part 'connection_receive.dart';

const String _cancelRequestMethod = AcpJsonRpcCodec.cancelRequestMethod;
const int _maximumGeneratedRequestId = 0x1fffffffffffff;

/// The severity of a connection diagnostic.
enum JsonRpcDiagnosticLevel {
  /// Recoverable or suspicious peer input.
  warning,

  /// A handler or transport operation failed.
  error,
}

/// A structured, payload-safe connection diagnostic.
final class JsonRpcDiagnostic {
  /// Creates a diagnostic.
  const JsonRpcDiagnostic({
    required this.level,
    required this.message,
    this.error,
  });

  /// Diagnostic severity.
  final JsonRpcDiagnosticLevel level;

  /// A concise message.
  final String message;

  /// A payload-safe category and runtime type for an associated error.
  ///
  /// The original exception is deliberately never retained because protocol
  /// errors may contain request params, response bodies, or other user data.
  final JsonRpcDiagnosticError? error;
}

/// Payload-safe classification of an error associated with a diagnostic.
final class JsonRpcDiagnosticError {
  /// Creates a redacted error description.
  const JsonRpcDiagnosticError({required this.category, required this.type});

  /// Broad stable category such as `format`, `request`, or `runtime`.
  final String category;

  /// Sanitized runtime type name; never the exception's message or payload.
  final String type;

  @override
  String toString() => '$category:$type';
}

/// Receives connection diagnostics.
typedef JsonRpcDiagnosticHandler = void Function(JsonRpcDiagnostic diagnostic);

/// Limits and behavior for [JsonRpcConnection].
final class JsonRpcConnectionOptions {
  /// Creates connection options.
  const JsonRpcConnectionOptions({
    this.allowBatches = true,
    this.maximumBatchEntries = 1024,
    this.maximumPendingRequests = 4096,
    this.maximumIncomingRequests = 256,
    this.maximumRetryMessages = 1024,
    this.exposeInternalErrorDetails = false,
    this.onDiagnostic,
  });

  /// Whether batch frames may be sent and received.
  final bool allowBatches;

  /// Maximum entries accepted in one batch.
  final int maximumBatchEntries;

  /// Maximum locally initiated requests awaiting responses.
  final int maximumPendingRequests;

  /// Maximum peer requests that have not finished responding.
  final int maximumIncomingRequests;

  /// Maximum messages waiting for a future dynamic handler.
  final int maximumRetryMessages;

  /// Whether internal exception text is returned to the peer.
  final bool exposeInternalErrorDetails;

  /// Optional diagnostics receiver.
  final JsonRpcDiagnosticHandler? onDiagnostic;

  void _validate() {
    for (final (String, int) limit in <(String, int)>[
      ('maximumBatchEntries', maximumBatchEntries),
      ('maximumPendingRequests', maximumPendingRequests),
      ('maximumIncomingRequests', maximumIncomingRequests),
      ('maximumRetryMessages', maximumRetryMessages),
    ]) {
      if (limit.$2 <= 0) {
        throw ArgumentError.value(limit.$2, limit.$1, 'must be positive');
      }
    }
  }
}

/// A lower-level JSON-RPC connection over an [AcpDuplexStream].
final class JsonRpcConnection implements JsonRpcHandlerContext {
  /// Creates and starts a connection.
  JsonRpcConnection({
    required AcpDuplexStream<Object?> stream,
    Iterable<JsonRpcHandler> handlers = const <JsonRpcHandler>[],
    JsonRpcConnectionOptions options = const JsonRpcConnectionOptions(),
    JsonRpcCodec codec = const JsonRpcCodec(),
  }) : _stream = stream,
       _staticHandlers = List<JsonRpcHandler>.unmodifiable(handlers),
       _options = options,
       _codec = codec {
    options._validate();
    final StreamSubscription<Object?> subscription = _stream.readable.listen(
      _receive,
      onError: _receiveError,
      onDone: close,
    );
    _subscription = subscription;
    if (_isClosed) {
      unawaited(subscription.cancel());
    }
  }

  final AcpDuplexStream<Object?> _stream;
  final List<JsonRpcHandler> _staticHandlers;
  final JsonRpcConnectionOptions _options;
  final JsonRpcCodec _codec;
  final Map<JsonRpcId, _PendingResponse> _pendingResponses =
      <JsonRpcId, _PendingResponse>{};
  final Map<JsonRpcId, CancellationSource> _incomingRequests =
      <JsonRpcId, CancellationSource>{};
  final Set<JsonRpcHandler> _dynamicHandlers = <JsonRpcHandler>{};
  final List<IncomingJsonRpcMessage> _retryMessages =
      <IncomingJsonRpcMessage>[];
  final CancellationSource _connectionCancellation = CancellationSource();
  final Completer<void> _done = Completer<void>();
  Future<void> _writeTail = Future<void>.value();
  StreamSubscription<Object?>? _subscription;
  int _nextRequestId = 0;
  Object? _closeReason;
  bool _isClosed = false;

  /// Whether the connection has closed.
  bool get isClosed => _isClosed;

  @override
  CancellationToken get cancellationToken => _connectionCancellation.token;

  @override
  Future<void> get done => _done.future;

  @override
  Future<T> sendRequest<T>({
    required String method,
    JsonRpcParams params = const JsonRpcParams.absent(),
    T Function(Object? value)? decode,
    CancellationToken? cancellationToken,
  }) {
    if (_isClosed) {
      return Future<T>.error(_effectiveCloseReason);
    }
    final _PreparedRequest<T> request = _prepareRequest<T>(
      method: method,
      params: params,
      decode: decode,
      cancellationToken: cancellationToken,
    );
    final Future<void> sent = _sendWire(request.message.toJson());
    unawaited(sent.catchError((Object _) {}));
    if (cancellationToken?.isCancelled ?? false) {
      request.cancel();
    }
    return request.response;
  }

  @override
  Future<void> sendNotification({
    required String method,
    JsonRpcParams params = const JsonRpcParams.absent(),
  }) {
    if (_isClosed) {
      return Future<void>.error(_effectiveCloseReason);
    }
    _validateOutgoingMethod(method);
    return _sendWire(
      JsonRpcNotification(method: method, params: params).toJson(),
    );
  }

  @override
  Future<List<Object?>> sendBatch(List<JsonRpcBatchEntry> entries) async {
    if (_isClosed) {
      throw _effectiveCloseReason;
    }
    if (!_options.allowBatches) {
      throw StateError('JSON-RPC batches are not supported');
    }
    if (entries.isEmpty) {
      throw ArgumentError.value(entries, 'entries', 'must not be empty');
    }
    if (entries.length > _options.maximumBatchEntries) {
      throw StateError(
        'JSON-RPC batch exceeds ${_options.maximumBatchEntries} entries',
      );
    }
    for (final JsonRpcBatchEntry entry in entries) {
      switch (entry) {
        case JsonRpcBatchNotification():
          _validateOutgoingMethod(entry.method);
        case JsonRpcBatchRequest<Object?>():
          _validateOutgoingMethod(entry.method);
      }
    }

    final List<Object> messages = <Object>[];
    final List<Future<Object?>> outputs = <Future<Object?>>[];
    final List<_PreparedRequest<Object?>> requests =
        <_PreparedRequest<Object?>>[];
    for (final JsonRpcBatchEntry entry in entries) {
      switch (entry) {
        case JsonRpcBatchNotification():
          messages.add(
            JsonRpcNotification(
              method: entry.method,
              params: entry.params,
            ).toJson(),
          );
          outputs.add(Future<Object?>.value());
        case JsonRpcBatchRequest<Object?>():
          final _PreparedRequest<Object?> request = _prepareRequest<Object?>(
            method: entry.method,
            params: entry.params,
            decode: entry.decode,
            cancellationToken: entry.cancellationToken,
          );
          requests.add(request);
          messages.add(request.message.toJson());
          outputs.add(request.response);
      }
    }

    final Future<void> sent = _sendWire(List<Object>.unmodifiable(messages));
    for (final _PreparedRequest<Object?> request in requests) {
      if (request.cancellationToken?.isCancelled ?? false) {
        request.cancel();
      }
    }
    await sent;
    return Future.wait<Object?>(outputs);
  }

  @override
  Future<void> sendCancelRequest(JsonRpcId requestId) {
    return sendNotification(
      method: _cancelRequestMethod,
      params: JsonRpcParams.value(<String, Object?>{
        'requestId': requestId.toJson(),
      }),
    );
  }

  @override
  HandlerRegistration addHandler(JsonRpcHandler handler) {
    if (_isClosed) {
      throw StateError('Cannot add a handler to a closed connection');
    }
    _dynamicHandlers.add(handler);
    if (_retryMessages.isNotEmpty) {
      final List<IncomingJsonRpcMessage> retrying =
          List<IncomingJsonRpcMessage>.of(_retryMessages);
      _retryMessages.clear();
      for (final IncomingJsonRpcMessage message in retrying) {
        unawaited(_processIncoming(message));
      }
    }
    return HandlerRegistration.internal(() {
      _dynamicHandlers.remove(handler);
    });
  }

  /// Closes the connection and rejects pending requests.
  void close([Object? reason]) {
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    _closeReason = reason ?? StateError('JSON-RPC connection closed');
    _connectionCancellation.cancel(_closeReason);

    for (final _PendingResponse pending in _pendingResponses.values) {
      pending.dispose();
      pending.reject(_effectiveCloseReason);
    }
    _pendingResponses.clear();
    for (final CancellationSource source in _incomingRequests.values) {
      source.cancel(_effectiveCloseReason);
    }
    _incomingRequests.clear();
    _retryMessages.clear();

    unawaited(_subscription?.cancel().catchError((Object _) {}) ?? done);
    if (!_done.isCompleted) {
      _done.complete();
    }
  }

  /// Closes and waits for receive cancellation.
  Future<void> dispose([Object? reason]) async {
    close(reason);
    await done;
  }

  Object get _effectiveCloseReason =>
      _closeReason ?? StateError('JSON-RPC connection closed');

  _PreparedRequest<T> _prepareRequest<T>({
    required String method,
    required JsonRpcParams params,
    required T Function(Object? value)? decode,
    required CancellationToken? cancellationToken,
  }) {
    _validateOutgoingMethod(method);
    if (_pendingResponses.length >= _options.maximumPendingRequests) {
      throw StateError(
        'Maximum pending JSON-RPC requests reached '
        '(${_options.maximumPendingRequests})',
      );
    }
    final JsonRpcId id = JsonRpcId.number(_nextRequestId);
    if (_nextRequestId == _maximumGeneratedRequestId) {
      _nextRequestId = 0;
    } else {
      _nextRequestId += 1;
    }
    final Completer<T> completer = Completer<T>();
    bool cancellationSent = false;
    CancellationRegistration? cancellationRegistration;

    void cancel() {
      if (cancellationSent || !_pendingResponses.containsKey(id)) {
        return;
      }
      cancellationSent = true;
      cancellationRegistration?.dispose();
      unawaited(sendCancelRequest(id).catchError((Object _) {}));
    }

    final _PendingResponse pending = _PendingResponse(
      resolve: (Object? value) {
        try {
          final T result = decode == null ? value as T : decode(value);
          completer.complete(result);
        } on Object catch (error, stackTrace) {
          completer.completeError(error, stackTrace);
        }
      },
      reject: (Object error, [StackTrace? stackTrace]) {
        completer.completeError(error, stackTrace);
      },
      disposeCancellation: () {
        cancellationRegistration?.dispose();
      },
    );
    if (cancellationToken != null && !cancellationToken.isCancelled) {
      cancellationRegistration = cancellationToken.register((Object? _) {
        cancel();
      });
    }
    _pendingResponses[id] = pending;
    unawaited(
      completer.future.then<void>((_) {}, onError: (Object _, StackTrace _) {}),
    );
    return _PreparedRequest<T>(
      message: JsonRpcRequest(id: id, method: method, params: params),
      response: completer.future,
      cancellationToken: cancellationToken,
      cancel: cancel,
    );
  }

  Future<void> _sendWire(Object? message) {
    if (_isClosed) {
      return Future<void>.error(_effectiveCloseReason);
    }
    final Future<void> previous = _writeTail;
    final Future<void> operation = () async {
      await previous;
      if (_isClosed) {
        throw _effectiveCloseReason;
      }
      await _stream.writable.write(message);
    }();
    _writeTail = operation.then<void>(
      (_) {},
      onError: (Object error, StackTrace _) {
        close(error);
      },
    );
    return operation;
  }

  JsonRpcParams _params(Map<String, Object?> object) =>
      object.containsKey('params')
      ? JsonRpcParams.value(object['params'])
      : const JsonRpcParams.absent();

  void _diagnose(
    JsonRpcDiagnosticLevel level,
    String message, [
    Object? error,
  ]) {
    try {
      _options.onDiagnostic?.call(
        JsonRpcDiagnostic(
          level: level,
          message: message,
          error: error == null ? null : _redactDiagnosticError(error),
        ),
      );
    } on Object {
      // Diagnostics are observational and must not alter protocol lifecycle.
    }
  }

  JsonRpcDiagnosticError _redactDiagnosticError(Object error) {
    final String category = switch (error) {
      JsonRpcFormatException() => 'format',
      JsonRpcRequestException() => 'request',
      CancellationException() => 'cancellation',
      ArgumentError() => 'argument',
      StateError() => 'state',
      _ => 'runtime',
    };
    final String candidate = error.runtimeType.toString();
    final String type =
        RegExp(r'^[A-Za-z_$][A-Za-z0-9_$.<>]*$').hasMatch(candidate)
        ? candidate
        : 'Object';
    return JsonRpcDiagnosticError(category: category, type: type);
  }

  void _validateOutgoingMethod(String method) {
    if (_codec case final AcpJsonRpcCodec acpCodec) {
      acpCodec.validateMethod(method);
    }
  }
}

/// Builds a handler-based [JsonRpcConnection].
final class JsonRpcConnectionBuilder {
  final List<JsonRpcHandler> _handlers = <JsonRpcHandler>[];

  /// Adds a raw handler.
  JsonRpcConnectionBuilder addHandler(JsonRpcHandler handler) {
    _handlers.add(handler);
    return this;
  }

  /// Adds an observer that passes through by default.
  JsonRpcConnectionBuilder onMessage(JsonRpcHandler observer) {
    _handlers.add((
      IncomingJsonRpcMessage message,
      JsonRpcHandlerContext context,
    ) async {
      final JsonRpcHandleResult? result = await observer(message, context);
      return result ?? JsonRpcPass(message: message);
    });
    return this;
  }

  /// Adds a typed request handler for [method].
  JsonRpcConnectionBuilder onRequest<T>({
    required String method,
    required JsonRpcParamsParser<T> parse,
    required JsonRpcRequestHandler<T> handler,
  }) {
    _handlers.add((
      IncomingJsonRpcMessage message,
      JsonRpcHandlerContext context,
    ) async {
      if (message is! IncomingJsonRpcRequest || message.method != method) {
        return JsonRpcPass(message: message);
      }
      final T params;
      try {
        params = parse(message.params.value);
      } on Object {
        throw JsonRpcRequestException.invalidParams();
      }
      return handler(params, message.responder, context);
    });
    return this;
  }

  /// Adds a typed notification handler for [method].
  JsonRpcConnectionBuilder onNotification<T>({
    required String method,
    required JsonRpcParamsParser<T> parse,
    required JsonRpcNotificationHandler<T> handler,
  }) {
    _handlers.add((
      IncomingJsonRpcMessage message,
      JsonRpcHandlerContext context,
    ) async {
      if (message is! IncomingJsonRpcNotification || message.method != method) {
        return JsonRpcPass(message: message);
      }
      final T params;
      try {
        params = parse(message.params.value);
      } on Object {
        throw JsonRpcRequestException.invalidParams();
      }
      return handler(params, context);
    });
    return this;
  }

  /// Connects the configured handlers to [stream].
  JsonRpcConnection connect({
    required AcpDuplexStream<Object?> stream,
    JsonRpcConnectionOptions options = const JsonRpcConnectionOptions(),
    JsonRpcCodec codec = const JsonRpcCodec(),
  }) => JsonRpcConnection(
    stream: stream,
    handlers: _handlers,
    options: options,
    codec: codec,
  );
}

final class _PendingResponse {
  _PendingResponse({
    required this.resolve,
    required this.reject,
    required this.disposeCancellation,
  });

  final void Function(Object? value) resolve;
  final void Function(Object error, [StackTrace? stackTrace]) reject;
  final void Function() disposeCancellation;

  void dispose() {
    disposeCancellation();
  }
}

final class _PreparedRequest<T> {
  const _PreparedRequest({
    required this.message,
    required this.response,
    required this.cancellationToken,
    required this.cancel,
  });

  final JsonRpcRequest message;
  final Future<T> response;
  final CancellationToken? cancellationToken;
  final void Function() cancel;
}
