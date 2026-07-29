part of 'connection.dart';

extension _JsonRpcConnectionReceive on JsonRpcConnection {
  void _receive(Object? value) {
    if (_isClosed) {
      return;
    }
    unawaited(
      _receiveWire(value).catchError((Object error, StackTrace stackTrace) {
        _diagnose(
          JsonRpcDiagnosticLevel.error,
          'Unhandled receive failure',
          error,
        );
        close(error);
      }),
    );
  }

  void _receiveError(Object error, StackTrace stackTrace) {
    _diagnose(
      JsonRpcDiagnosticLevel.error,
      'JSON-RPC input stream failed',
      error,
    );
    close(error);
  }

  Future<void> _receiveWire(Object? value) async {
    if (value is List<Object?>) {
      if (!_options.allowBatches) {
        close(StateError('JSON-RPC batches are not supported'));
        return;
      }
      await _receiveBatch(value);
      return;
    }
    final Map<String, Object?>? object = _codec.asJsonObject(value);
    if (object == null) {
      _diagnose(
        JsonRpcDiagnosticLevel.warning,
        'Ignoring non-object JSON-RPC input',
      );
      return;
    }
    await _receiveObject(object);
  }

  Future<void> _receiveObject(Map<String, Object?> object) async {
    final Object? method = object['method'];
    if (method is String) {
      if (_codec case final AcpJsonRpcCodec acpCodec
          when !acpCodec.isAllowedMethod(method)) {
        if (object.containsKey('id')) {
          final JsonRpcId? id = _codec.tryDecodeId(object['id']);
          await _sendResponse(
            JsonRpcErrorResponse(
              id: id ?? const JsonRpcId.nullValue(),
              error: id == null
                  ? JsonRpcRequestException.invalidRequest(
                      data: 'Invalid request id',
                    ).error
                  : JsonRpcRequestException.methodNotFound(method).error,
            ),
          );
        } else {
          _diagnose(
            JsonRpcDiagnosticLevel.warning,
            'Ignoring an unregistered non-extension ACP notification',
          );
        }
        return;
      }
      if (object.containsKey('id')) {
        final JsonRpcId? id = _codec.tryDecodeId(object['id']);
        if (id == null) {
          await _sendResponse(
            JsonRpcErrorResponse(
              id: const JsonRpcId.nullValue(),
              error: JsonRpcRequestException.invalidRequest(
                data: 'Invalid request id',
              ).error,
            ),
          );
          return;
        }
        _startRequest(
          id: id,
          method: method,
          params: _params(object),
          raw: object,
        );
        return;
      }
      _handleProtocolNotification(method, object['params']);
      unawaited(
        _processIncoming(
          IncomingJsonRpcNotification(
            method: method,
            params: _params(object),
            raw: Map<String, Object?>.unmodifiable(object),
          ),
        ),
      );
      return;
    }
    if (object.containsKey('id') || _codec.isResponseShaped(object)) {
      _handleResponse(object);
      return;
    }
    _diagnose(
      JsonRpcDiagnosticLevel.warning,
      'Ignoring malformed JSON-RPC object',
    );
  }

  Future<void> _receiveBatch(List<Object?> batch) async {
    if (batch.isEmpty) {
      await _sendResponse(
        JsonRpcErrorResponse(
          id: const JsonRpcId.nullValue(),
          error: JsonRpcRequestException.invalidRequest(data: batch).error,
        ),
      );
      return;
    }
    if (batch.length > _options.maximumBatchEntries) {
      await _sendResponse(
        JsonRpcErrorResponse(
          id: const JsonRpcId.nullValue(),
          error: JsonRpcRequestException.invalidRequest(
            data: 'Batch exceeds ${_options.maximumBatchEntries} entries',
          ).error,
        ),
      );
      return;
    }
    if (_codec.isResponseBatch(batch)) {
      for (final Object? item in batch) {
        if (_codec.isResponseShaped(item)) {
          final Map<String, Object?>? object = _codec.asJsonObject(item);
          if (object != null) {
            _handleResponse(object);
          }
        }
      }
      return;
    }
    _startCallBatch(batch);
  }

  void _startCallBatch(List<Object?> batch) {
    int remainingResponses = batch
        .where((Object? item) => !_codec.isNotification(item))
        .length;
    int remainingNotifications = batch.where(_codec.isNotification).length;
    final List<JsonRpcResponse> responses = <JsonRpcResponse>[];
    final Completer<void> batchSent = Completer<void>();
    bool sendStarted = false;

    void sendIfReady() {
      if (sendStarted ||
          remainingResponses != 0 ||
          remainingNotifications != 0) {
        return;
      }
      sendStarted = true;
      if (responses.isEmpty) {
        batchSent.complete();
        return;
      }
      final Future<void> sending = _sendWire(
        List<Object>.unmodifiable(
          responses.map((JsonRpcResponse response) => response.toJson()),
        ),
      );
      sending.then<void>(
        (_) => batchSent.complete(),
        onError: (Object error, StackTrace stackTrace) {
          batchSent.completeError(error, stackTrace);
        },
      );
    }

    Future<void> collect(JsonRpcResponse response) {
      responses.add(response);
      remainingResponses -= 1;
      sendIfReady();
      return batchSent.future;
    }

    for (final Object? item in batch) {
      if (_codec.isRequest(item)) {
        final JsonRpcRequest request =
            _codec.decodeMessage(item) as JsonRpcRequest;
        final Map<String, Object?> object = _codec.asJsonObject(item)!;
        _startRequest(
          id: request.id,
          method: request.method,
          params: request.params,
          raw: object,
          sendResponse: collect,
        );
        continue;
      }
      if (_codec.isNotification(item)) {
        final JsonRpcNotification notification =
            _codec.decodeMessage(item) as JsonRpcNotification;
        final Map<String, Object?> object = _codec.asJsonObject(item)!;
        _handleProtocolNotification(
          notification.method,
          notification.params.value,
        );
        final Future<void> processing = _processIncoming(
          IncomingJsonRpcNotification(
            method: notification.method,
            params: notification.params,
            raw: Map<String, Object?>.unmodifiable(object),
          ),
        );
        unawaited(
          processing.whenComplete(() {
            remainingNotifications -= 1;
            sendIfReady();
          }),
        );
        continue;
      }
      responses.add(
        JsonRpcErrorResponse(
          id: const JsonRpcId.nullValue(),
          error: JsonRpcRequestException.invalidRequest(data: item).error,
        ),
      );
      remainingResponses -= 1;
    }
    sendIfReady();
    unawaited(batchSent.future.catchError((Object _) {}));
  }

  void _startRequest({
    required JsonRpcId id,
    required String method,
    required JsonRpcParams params,
    required Map<String, Object?> raw,
    Future<void> Function(JsonRpcResponse response)? sendResponse,
  }) {
    if (_incomingRequests.containsKey(id)) {
      unawaited(
        (sendResponse ?? _sendResponse)(
          JsonRpcErrorResponse(
            id: id,
            error: JsonRpcRequestException.invalidRequest(
              data: 'Duplicate active request id',
            ).error,
          ),
        ),
      );
      return;
    }
    if (_incomingRequests.length >= _options.maximumIncomingRequests) {
      unawaited(
        (sendResponse ?? _sendResponse)(
          JsonRpcErrorResponse(
            id: id,
            error: JsonRpcRequestException.internalError(
              data: 'Too many active requests',
            ).error,
          ),
        ),
      );
      return;
    }
    final CancellationSource source = CancellationSource();
    _incomingRequests[id] = source;
    void finish() {
      if (identical(_incomingRequests[id], source)) {
        _incomingRequests.remove(id);
      }
    }

    final JsonRpcRequestResponder responder = JsonRpcRequestResponder.internal(
      id: id,
      cancellationToken: source.token,
      send: sendResponse ?? _sendResponse,
      finish: finish,
    );
    unawaited(
      _processIncoming(
        IncomingJsonRpcRequest(
          id: id,
          method: method,
          params: params,
          raw: Map<String, Object?>.unmodifiable(raw),
          responder: responder,
        ),
      ),
    );
  }

  Future<void> _sendResponse(JsonRpcResponse response) =>
      _sendWire(response.toJson());

  void _handleResponse(Map<String, Object?> raw) {
    final JsonRpcId? id = _codec.tryDecodeId(raw['id']);
    if (id == null) {
      _diagnose(
        JsonRpcDiagnosticLevel.warning,
        'Ignoring response with invalid id',
      );
      return;
    }
    final _PendingResponse? pending = _pendingResponses.remove(id);
    if (pending == null) {
      _diagnose(
        JsonRpcDiagnosticLevel.warning,
        'Ignoring response to an unknown request',
      );
      return;
    }
    pending.dispose();
    try {
      final JsonRpcMessage message = _codec.decodeMessage(raw);
      if (message is! JsonRpcResponse) {
        throw JsonRpcFormatException('Expected JSON-RPC response', raw);
      }
      switch (message) {
        case JsonRpcSuccessResponse():
          pending.resolve(message.result);
        case JsonRpcErrorResponse():
          pending.reject(JsonRpcRequestException(message.error));
      }
    } on JsonRpcFormatException catch (error, stackTrace) {
      pending.reject(
        JsonRpcRequestException.invalidRequest(data: raw),
        stackTrace,
      );
      _diagnose(
        JsonRpcDiagnosticLevel.warning,
        'Rejected a malformed matching response',
        error,
      );
    }
  }

  void _handleProtocolNotification(String method, Object? rawParams) {
    if (method != _cancelRequestMethod) {
      return;
    }
    final Map<String, Object?>? params = _codec.asJsonObject(rawParams);
    if (params == null || !params.containsKey('requestId')) {
      return;
    }
    final JsonRpcId? id = _codec.tryDecodeId(params['requestId']);
    if (id == null) {
      return;
    }
    _incomingRequests[id]?.cancel(
      JsonRpcRequestException.requestCancelled(
        data: <String, Object?>{'requestId': id.toJson()},
      ),
    );
  }

  Future<void> _processIncoming(IncomingJsonRpcMessage message) async {
    if (_isClosed) {
      return;
    }
    IncomingJsonRpcMessage current = message;
    bool shouldRetry = false;
    try {
      final List<JsonRpcHandler> handlers = <JsonRpcHandler>[
        ..._staticHandlers,
        ..._dynamicHandlers,
      ];
      for (final JsonRpcHandler handler in handlers) {
        if (_isClosed) {
          return;
        }
        final JsonRpcHandleResult? result = await handler(current, this);
        if (result == null || result is JsonRpcHandled) {
          return;
        }
        final JsonRpcPass pass = result as JsonRpcPass;
        current = pass.message ?? current;
        shouldRetry = shouldRetry || pass.retry;
      }

      if (shouldRetry) {
        if (_retryMessages.length >= _options.maximumRetryMessages) {
          if (current case IncomingJsonRpcRequest(:final responder)) {
            await responder.respondException(
              JsonRpcRequestException.internalError(
                data: 'Handler retry queue is full',
              ),
            );
          }
          return;
        }
        _retryMessages.add(current);
        return;
      }
      if (current case IncomingJsonRpcRequest(
        :final String method,
        :final JsonRpcRequestResponder responder,
      )) {
        await responder.respondException(
          JsonRpcRequestException.methodNotFound(method),
        );
      }
    } on Object catch (error) {
      if (_isClosed) {
        return;
      }
      if (current case IncomingJsonRpcRequest(
        :final responder,
      ) when !responder.hasResponded) {
        await responder.respondException(_mapHandlerError(error));
        return;
      }
      _diagnose(
        JsonRpcDiagnosticLevel.error,
        'JSON-RPC handler failed after response or during notification',
        error,
      );
      if (_options.exposeInternalErrorDetails) {
        _diagnose(
          JsonRpcDiagnosticLevel.error,
          'JSON-RPC handler stack trace suppressed from diagnostics',
        );
      }
    }
  }

  JsonRpcRequestException _mapHandlerError(Object error) {
    if (error is JsonRpcRequestException) {
      return error;
    }
    if (error is CancellationException) {
      final Object? reason = error.reason;
      if (reason is JsonRpcRequestException && reason.code == -32800) {
        return reason;
      }
      return JsonRpcRequestException.requestCancelled(
        data: _options.exposeInternalErrorDetails ? reason?.toString() : null,
      );
    }
    return JsonRpcRequestException.internalError(
      data: _options.exposeInternalErrorDetails
          ? <String, Object?>{'details': error.toString()}
          : null,
    );
  }
}
