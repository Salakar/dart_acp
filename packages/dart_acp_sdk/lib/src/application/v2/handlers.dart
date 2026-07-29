part of 'application.dart';

/// Handles a typed request received by a v2 agent.
typedef AcpV2AgentRequestHandler<P, R> =
    FutureOr<R> Function(AcpV2AgentRequestContext<P> context);

/// Handles a typed notification received by a v2 agent.
typedef AcpV2AgentNotificationHandler<P> =
    FutureOr<void> Function(AcpV2AgentNotificationContext<P> context);

/// Handles a typed request received by a v2 client.
typedef AcpV2ClientRequestHandler<P, R> =
    FutureOr<R> Function(AcpV2ClientRequestContext<P> context);

/// Handles a typed notification received by a v2 client.
typedef AcpV2ClientNotificationHandler<P> =
    FutureOr<void> Function(AcpV2ClientNotificationContext<P> context);

/// Runs after an agent connection becomes ready.
typedef AcpV2AgentConnectHandler =
    FutureOr<void> Function(AcpV2AgentConnection connection);

/// Runs after a client connection becomes ready.
typedef AcpV2ClientConnectHandler =
    FutureOr<void> Function(AcpV2ClientConnection connection);

abstract interface class _AcpV2Binding {
  AcpMethodDescriptorBase get descriptor;
}

abstract interface class _AcpV2AgentBinding implements _AcpV2Binding {
  JsonRpcHandler build(AcpV2AgentContext context);
}

abstract interface class _AcpV2ClientBinding implements _AcpV2Binding {
  JsonRpcHandler build(AcpV2ClientContext context);
}

final class _AcpV2AgentRequestBinding<P, R> implements _AcpV2AgentBinding {
  const _AcpV2AgentRequestBinding(this.descriptor, this.handler);

  @override
  final AcpMethodDescriptor<P, R> descriptor;
  final AcpV2AgentRequestHandler<P, R> handler;

  @override
  JsonRpcHandler build(AcpV2AgentContext context) =>
      (IncomingJsonRpcMessage message, JsonRpcHandlerContext _) async {
        if (message is! IncomingJsonRpcRequest ||
            message.method != descriptor.name) {
          return JsonRpcPass(message: message);
        }
        final P params = _decodeV2Params(
          descriptor.paramsCodec,
          message.params,
        );
        final R result = await handler(
          AcpV2AgentRequestContext<P>(
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

final class _AcpV2AgentNotificationBinding<P> implements _AcpV2AgentBinding {
  const _AcpV2AgentNotificationBinding(this.descriptor, this.handler);

  @override
  final AcpMethodDescriptor<P, AcpNoResult> descriptor;
  final AcpV2AgentNotificationHandler<P> handler;

  @override
  JsonRpcHandler build(AcpV2AgentContext context) =>
      (IncomingJsonRpcMessage message, JsonRpcHandlerContext raw) async {
        if (message is! IncomingJsonRpcNotification ||
            message.method != descriptor.name) {
          return JsonRpcPass(message: message);
        }
        await handler(
          AcpV2AgentNotificationContext<P>(
            params: _decodeV2Params(descriptor.paramsCodec, message.params),
            cancellationToken: raw.cancellationToken,
            client: context,
          ),
        );
        return const JsonRpcHandled();
      };
}

final class _AcpV2ClientRequestBinding<P, R> implements _AcpV2ClientBinding {
  const _AcpV2ClientRequestBinding(this.descriptor, this.handler);

  @override
  final AcpMethodDescriptor<P, R> descriptor;
  final AcpV2ClientRequestHandler<P, R> handler;

  @override
  JsonRpcHandler build(AcpV2ClientContext context) =>
      (IncomingJsonRpcMessage message, JsonRpcHandlerContext _) async {
        if (message is! IncomingJsonRpcRequest ||
            message.method != descriptor.name) {
          return JsonRpcPass(message: message);
        }
        final P params = _decodeV2Params(
          descriptor.paramsCodec,
          message.params,
        );
        final R result = await handler(
          AcpV2ClientRequestContext<P>(
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

final class _AcpV2ClientNotificationBinding<P> implements _AcpV2ClientBinding {
  const _AcpV2ClientNotificationBinding(this.descriptor, this.handler);

  @override
  final AcpMethodDescriptor<P, AcpNoResult> descriptor;
  final AcpV2ClientNotificationHandler<P> handler;

  @override
  JsonRpcHandler build(AcpV2ClientContext context) =>
      (IncomingJsonRpcMessage message, JsonRpcHandlerContext raw) async {
        if (message is! IncomingJsonRpcNotification ||
            message.method != descriptor.name) {
          return JsonRpcPass(message: message);
        }
        await handler(
          AcpV2ClientNotificationContext<P>(
            params: _decodeV2Params(descriptor.paramsCodec, message.params),
            cancellationToken: raw.cancellationToken,
            agent: context,
          ),
        );
        return const JsonRpcHandled();
      };
}

P _decodeV2Params<P>(AcpCodec<P> codec, JsonRpcParams params) {
  try {
    return codec.decode(params.value);
  } on JsonRpcRequestException {
    rethrow;
  } on Object {
    throw JsonRpcRequestException.invalidParams();
  }
}

void _validateV2Registration(
  AcpMethodDescriptorBase descriptor, {
  required AcpMethodDirection direction,
  required AcpMethodKind kind,
  required AcpV2ApplicationOptions options,
}) {
  if (descriptor.protocol != AcpProtocolGeneration.v2 ||
      descriptor.kind != kind ||
      (descriptor.direction != direction &&
          descriptor.direction != AcpMethodDirection.either)) {
    throw ArgumentError.value(
      descriptor.name,
      'method',
      'descriptor does not match this ACP v2 handler side',
    );
  }
  if (descriptor.stability == AcpMethodStability.unstable &&
      !options.allowUnstableMethods) {
    throw AcpV2ConnectionStateException(
      'Unstable ACP v2 method ${descriptor.name} is not enabled',
    );
  }
  if (descriptor.paramsDefinition == _v2CustomDefinition) {
    _validateV2CustomName(descriptor.name);
  }
}

void _validateV2NoDuplicate(
  Iterable<_AcpV2Binding> bindings,
  AcpMethodDescriptorBase descriptor,
) {
  if (bindings.any(
    (_AcpV2Binding item) => item.descriptor.key == descriptor.key,
  )) {
    throw StateError('Duplicate ACP v2 handler: ${descriptor.key}');
  }
}

Set<String> _v2ProtocolNames(
  Iterable<AcpMethodDescriptorBase> descriptors,
  Iterable<_AcpV2Binding> bindings,
) => <String>{
  for (final AcpMethodDescriptorBase descriptor in descriptors) descriptor.name,
  for (final _AcpV2Binding binding in bindings) binding.descriptor.name,
};

JsonRpcHandler _v2InitializationGuard(
  AcpV2ConnectionLifecycle Function() lifecycle,
) => (IncomingJsonRpcMessage message, JsonRpcHandlerContext _) async {
  final bool isInitialize = message.method == v2_methods.initializeMethod.name;
  if (lifecycle().isReady &&
      isInitialize &&
      message is IncomingJsonRpcRequest) {
    await message.responder.respondException(
      JsonRpcRequestException.invalidRequest(
        data: 'ACP v2 connection is already initialized',
      ),
    );
    return const JsonRpcHandled();
  }
  if (!lifecycle().isReady && !isInitialize) {
    if (message is IncomingJsonRpcRequest) {
      await message.responder.respondException(
        JsonRpcRequestException.invalidRequest(
          data: 'initialize must be the first ACP v2 request',
        ),
      );
    }
    return const JsonRpcHandled();
  }
  return JsonRpcPass(message: message);
};

void _runV2ConnectHandlers<C extends AcpV2Connection>(
  C connection,
  Iterable<FutureOr<void> Function(C)> handlers,
) {
  for (final FutureOr<void> Function(C) handler in handlers) {
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
