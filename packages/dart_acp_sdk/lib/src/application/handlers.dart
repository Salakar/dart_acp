part of 'application.dart';

/// Handles a typed request received by an agent app.
typedef AcpAgentRequestHandler<P, R> =
    FutureOr<R> Function(AcpAgentRequestContext<P> context);

/// Handles a typed notification received by an agent app.
typedef AcpAgentNotificationHandler<P> =
    FutureOr<void> Function(AcpAgentNotificationContext<P> context);

/// Handles a typed request received by a client app.
typedef AcpClientRequestHandler<P, R> =
    FutureOr<R> Function(AcpClientRequestContext<P> context);

/// Handles a typed notification received by a client app.
typedef AcpClientNotificationHandler<P> =
    FutureOr<void> Function(AcpClientNotificationContext<P> context);

/// Runs when an agent connection becomes ready.
typedef AcpAgentConnectHandler =
    FutureOr<void> Function(AcpAgentConnection connection);

/// Runs when a client connection becomes ready.
typedef AcpClientConnectHandler =
    FutureOr<void> Function(AcpClientConnection connection);

/// A typed incoming message exposed to application middleware.
sealed class AcpIncomingMessage {
  const AcpIncomingMessage({required this.method, required this.params});

  /// Exact wire method name.
  final String method;

  /// Presence-aware raw parameters.
  final JsonRpcParams params;
}

/// An incoming request exposed to middleware.
final class AcpIncomingRequest extends AcpIncomingMessage {
  AcpIncomingRequest._({
    required super.method,
    required super.params,
    required this.requestId,
    required JsonRpcRequestResponder responder,
  }) : _responder = responder;

  /// Correlation ID.
  final JsonRpcId requestId;

  final JsonRpcRequestResponder _responder;

  /// Cooperative request cancellation.
  CancellationToken get cancellationToken => _responder.cancellationToken;

  /// Whether middleware has initiated a response.
  bool get hasResponded => _responder.hasResponded;

  /// Responds using a concrete result codec.
  Future<void> respond<R>(AcpCodec<R> codec, R result) =>
      _responder.respond(codec.encode(result));

  /// Responds with a JSON-RPC error.
  Future<void> respondError(JsonRpcErrorObject error) =>
      _responder.respondError(error);
}

/// An incoming notification exposed to middleware.
final class AcpIncomingNotification extends AcpIncomingMessage {
  /// Creates an incoming notification view.
  const AcpIncomingNotification({required super.method, required super.params});
}

/// Explicit middleware dispatch control.
enum AcpMiddlewareResult {
  /// Continue through later middleware and typed handlers.
  pass,

  /// Stop dispatch. Request middleware must have responded first.
  handled,
}

/// Observes or handles an incoming message.
typedef AcpMiddleware =
    FutureOr<AcpMiddlewareResult> Function(
      AcpIncomingMessage message,
      AcpCallContext peer,
    );

abstract interface class _AcpBinding {
  AcpMethodDescriptorBase get descriptor;
}

abstract interface class _AcpAgentBinding implements _AcpBinding {
  JsonRpcHandler build(
    AcpAgentContext context,
    AcpConnectionLifecycle lifecycle,
  );
}

abstract interface class _AcpClientBinding implements _AcpBinding {
  JsonRpcHandler build(
    AcpClientContext context,
    AcpConnectionLifecycle lifecycle,
  );
}

final class _AcpAgentRequestBinding<P, R> implements _AcpAgentBinding {
  const _AcpAgentRequestBinding(this.descriptor, this.handler);

  @override
  final AcpMethodDescriptor<P, R> descriptor;
  final AcpAgentRequestHandler<P, R> handler;

  @override
  JsonRpcHandler build(
    AcpAgentContext context,
    AcpConnectionLifecycle lifecycle,
  ) => (IncomingJsonRpcMessage message, JsonRpcHandlerContext _) async {
    if (message is! IncomingJsonRpcRequest ||
        message.method != descriptor.name) {
      return JsonRpcPass(message: message);
    }
    final P params = _decodeParams(descriptor.paramsCodec, message.params);
    final R result = await handler(
      AcpAgentRequestContext<P>(
        params: params,
        requestId: message.id,
        cancellationToken: message.cancellationToken,
        client: context,
      ),
    );
    await message.responder.respond(descriptor.resultCodec.encode(result));
    return const JsonRpcHandled();
  };
}

final class _AcpAgentNotificationBinding<P> implements _AcpAgentBinding {
  const _AcpAgentNotificationBinding(this.descriptor, this.handler);

  @override
  final AcpMethodDescriptor<P, AcpNoResult> descriptor;
  final AcpAgentNotificationHandler<P> handler;

  @override
  JsonRpcHandler build(
    AcpAgentContext context,
    AcpConnectionLifecycle lifecycle,
  ) =>
      (IncomingJsonRpcMessage message, JsonRpcHandlerContext rawContext) async {
        if (message is! IncomingJsonRpcNotification ||
            message.method != descriptor.name) {
          return JsonRpcPass(message: message);
        }
        final P params = _decodeParams(descriptor.paramsCodec, message.params);
        await handler(
          AcpAgentNotificationContext<P>(
            params: params,
            cancellationToken: rawContext.cancellationToken,
            client: context,
          ),
        );
        return const JsonRpcHandled();
      };
}

final class _AcpClientRequestBinding<P, R> implements _AcpClientBinding {
  const _AcpClientRequestBinding(this.descriptor, this.handler);

  @override
  final AcpMethodDescriptor<P, R> descriptor;
  final AcpClientRequestHandler<P, R> handler;

  @override
  JsonRpcHandler build(
    AcpClientContext context,
    AcpConnectionLifecycle lifecycle,
  ) => (IncomingJsonRpcMessage message, JsonRpcHandlerContext _) async {
    if (message is! IncomingJsonRpcRequest ||
        message.method != descriptor.name) {
      return JsonRpcPass(message: message);
    }
    final P params = _decodeParams(descriptor.paramsCodec, message.params);
    final R result = await handler(
      AcpClientRequestContext<P>(
        params: params,
        requestId: message.id,
        cancellationToken: message.cancellationToken,
        agent: context,
      ),
    );
    await message.responder.respond(descriptor.resultCodec.encode(result));
    return const JsonRpcHandled();
  };
}

final class _AcpClientNotificationBinding<P> implements _AcpClientBinding {
  const _AcpClientNotificationBinding(this.descriptor, this.handler);

  @override
  final AcpMethodDescriptor<P, AcpNoResult> descriptor;
  final AcpClientNotificationHandler<P> handler;

  @override
  JsonRpcHandler build(
    AcpClientContext context,
    AcpConnectionLifecycle lifecycle,
  ) =>
      (IncomingJsonRpcMessage message, JsonRpcHandlerContext rawContext) async {
        if (message is! IncomingJsonRpcNotification ||
            message.method != descriptor.name) {
          return JsonRpcPass(message: message);
        }
        final P params = _decodeParams(descriptor.paramsCodec, message.params);
        await handler(
          AcpClientNotificationContext<P>(
            params: params,
            cancellationToken: rawContext.cancellationToken,
            agent: context,
          ),
        );
        return const JsonRpcHandled();
      };
}

P _decodeParams<P>(AcpCodec<P> codec, JsonRpcParams params) {
  try {
    return codec.decode(params.value);
  } on JsonRpcRequestException {
    rethrow;
  } on Object {
    throw JsonRpcRequestException.invalidParams();
  }
}

JsonRpcHandler _middlewareHandler(
  AcpMiddleware middleware,
  AcpCallContext context,
) => (IncomingJsonRpcMessage message, JsonRpcHandlerContext _) async {
  final AcpIncomingMessage incoming = switch (message) {
    IncomingJsonRpcRequest() => AcpIncomingRequest._(
      method: message.method,
      params: message.params,
      requestId: message.id,
      responder: message.responder,
    ),
    IncomingJsonRpcNotification() => AcpIncomingNotification(
      method: message.method,
      params: message.params,
    ),
  };
  final AcpMiddlewareResult result = await middleware(incoming, context);
  if (result == AcpMiddlewareResult.handled) {
    if (incoming is AcpIncomingRequest && !incoming.hasResponded) {
      throw StateError('Handled request middleware must send a response');
    }
    return const JsonRpcHandled();
  }
  return JsonRpcPass(message: message);
};

void _validateNoDuplicate(
  Iterable<_AcpBinding> existing,
  AcpMethodDescriptorBase descriptor,
) {
  if (existing.any(
    (_AcpBinding binding) => binding.descriptor.key == descriptor.key,
  )) {
    throw StateError('Duplicate ACP handler: ${descriptor.key}');
  }
}

void _validateRegistration(
  AcpMethodDescriptorBase descriptor, {
  required AcpMethodDirection direction,
  required AcpMethodKind kind,
  required AcpApplicationOptions options,
}) {
  if (descriptor.protocol != AcpProtocolGeneration.v1) {
    throw ArgumentError.value(
      descriptor.name,
      'method',
      'application only accepts ACP v1 descriptors',
    );
  }
  if ((descriptor.direction != direction &&
          descriptor.direction != AcpMethodDirection.either) ||
      descriptor.kind != kind) {
    throw ArgumentError.value(
      descriptor.name,
      'method',
      'descriptor direction or kind does not match this handler',
    );
  }
  if (descriptor.stability == AcpMethodStability.unstable &&
      !options.allowUnstableMethods) {
    throw AcpConnectionStateException(
      'Unstable ACP method ${descriptor.name} is not enabled',
    );
  }
  if (_isCustomDescriptor(descriptor)) {
    _validateCustomMethodName(descriptor.name);
  }
}

JsonRpcHandler _initializationGuard(
  AcpConnectionLifecycle Function() lifecycle,
  String initializeMethod,
) => (IncomingJsonRpcMessage message, JsonRpcHandlerContext _) async {
  final AcpConnectionLifecycle current = lifecycle();
  if (message.method == initializeMethod) {
    if (message is! IncomingJsonRpcRequest) {
      current._rawConnection.close(
        const AcpConnectionStateException(
          'ACP initialize must be an individual request',
        ),
      );
      return const JsonRpcHandled();
    }
    if (current.isReady) {
      await message.responder.respondException(
        JsonRpcRequestException.invalidRequest(
          data: 'ACP connection is already initialized',
        ),
      );
      return const JsonRpcHandled();
    }
    return JsonRpcPass(message: message);
  }
  if (current.isReady) {
    return JsonRpcPass(message: message);
  }
  if (message is IncomingJsonRpcRequest) {
    await message.responder.respondException(
      JsonRpcRequestException.invalidRequest(
        data: 'ACP initialize must be the first request',
      ),
    );
  }
  current._rawConnection.close(
    AcpConnectionStateException(
      'ACP initialize must precede ${message.method}',
    ),
  );
  return const JsonRpcHandled();
};

AcpDuplexStream<Object?> _asynchronousInput(AcpDuplexStream<Object?> stream) =>
    AcpDuplexStream<Object?>(
      readable: stream.readable.asyncMap<Object?>(
        (Object? value) async => value,
      ),
      writable: stream.writable,
    );

Set<String> _protocolMethodNames(
  Iterable<AcpMethodDescriptorBase> protocolDescriptors,
  Iterable<_AcpBinding> bindings,
) => <String>{
  for (final AcpMethodDescriptorBase descriptor in protocolDescriptors)
    descriptor.name,
  for (final _AcpBinding binding in bindings) binding.descriptor.name,
};

void _runAgentConnectHandlers(
  AcpAgentConnection connection,
  Iterable<AcpAgentConnectHandler> handlers,
) {
  for (final AcpAgentConnectHandler handler in handlers) {
    try {
      final FutureOr<void> result = handler(connection);
      if (result is Future<void>) {
        unawaited(result.catchError((Object error) => connection.close(error)));
      }
    } on Object catch (error) {
      connection.close(error);
      rethrow;
    }
  }
}

void _runClientConnectHandlers(
  AcpClientConnection connection,
  Iterable<AcpClientConnectHandler> handlers,
) {
  for (final AcpClientConnectHandler handler in handlers) {
    try {
      final FutureOr<void> result = handler(connection);
      if (result is Future<void>) {
        unawaited(result.catchError((Object error) => connection.close(error)));
      }
    } on Object catch (error) {
      connection.close(error);
      rethrow;
    }
  }
}
