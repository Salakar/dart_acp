part of 'application.dart';

const String _v2CustomDefinition = r'$v2Custom';

/// Creates a typed custom v2 request descriptor.
AcpMethodDescriptor<P, R> acpV2CustomRequestMethod<P, R>({
  required String name,
  required AcpMethodDirection direction,
  required AcpCodec<P> paramsCodec,
  required AcpCodec<R> resultCodec,
}) {
  _validateV2CustomName(name);
  return AcpMethodDescriptor<P, R>(
    name: name,
    dartName: name,
    protocol: AcpProtocolGeneration.v2,
    stability: AcpMethodStability.draft,
    direction: direction,
    kind: AcpMethodKind.request,
    paramsDefinition: _v2CustomDefinition,
    resultDefinition: _v2CustomDefinition,
    paramsCodec: paramsCodec,
    resultCodec: resultCodec,
  );
}

/// Creates a typed custom v2 notification descriptor.
AcpMethodDescriptor<P, AcpNoResult> acpV2CustomNotificationMethod<P>({
  required String name,
  required AcpMethodDirection direction,
  required AcpCodec<P> paramsCodec,
}) {
  _validateV2CustomName(name);
  return AcpMethodDescriptor<P, AcpNoResult>(
    name: name,
    dartName: name,
    protocol: AcpProtocolGeneration.v2,
    stability: AcpMethodStability.draft,
    direction: direction,
    kind: AcpMethodKind.notification,
    paramsDefinition: _v2CustomDefinition,
    paramsCodec: paramsCodec,
    resultCodec: acpNoResultCodec,
  );
}

void _validateV2CustomName(String name) {
  if (name.length <= 1 || !name.startsWith('_')) {
    throw ArgumentError.value(
      name,
      'name',
      'custom ACP v2 method names must start with "_"',
    );
  }
}

/// Shared descriptor-backed v2 call context.
sealed class AcpV2CallContext {
  AcpV2CallContext._({
    required JsonRpcConnection rawConnection,
    required this.lifecycle,
    required this.options,
    required AcpMethodDirection outgoingDirection,
  }) : _rawConnection = rawConnection,
       _outgoingDirection = outgoingDirection;

  final JsonRpcConnection _rawConnection;
  final AcpMethodDirection _outgoingDirection;

  /// Lifecycle of the containing connection.
  final AcpV2ConnectionLifecycle lifecycle;

  /// App behavior options.
  final AcpV2ApplicationOptions options;

  /// Sends a typed request.
  Future<R> request<P, R>(
    AcpMethodDescriptor<P, R> method,
    P params, {
    CancellationToken? cancellationToken,
  }) => _request(
    method,
    params,
    cancellationToken: cancellationToken,
    enforceCapability: false,
  );

  Future<R> _request<P, R>(
    AcpMethodDescriptor<P, R> method,
    P params, {
    CancellationToken? cancellationToken,
    bool duringInitialization = false,
    bool enforceCapability = true,
  }) {
    _validateMethod(method, AcpMethodKind.request);
    if (!duringInitialization) {
      lifecycle._ensureReady(method.name);
      if (enforceCapability) {
        lifecycle.peerCapabilities._require(method.capabilityPath, method.name);
      }
    }
    return _rawConnection.sendRequest<R>(
      method: method.name,
      params: JsonRpcParams.value(method.paramsCodec.encode(params)),
      decode: method.resultCodec.decode,
      cancellationToken: cancellationToken,
    );
  }

  /// Sends a typed notification.
  Future<void> notify<P>(AcpMethodDescriptor<P, AcpNoResult> method, P params) {
    _validateMethod(method, AcpMethodKind.notification);
    lifecycle._ensureReady(method.name);
    lifecycle.peerCapabilities._require(method.capabilityPath, method.name);
    return _rawConnection.sendNotification(
      method: method.name,
      params: JsonRpcParams.value(method.paramsCodec.encode(params)),
    );
  }

  /// Sends one non-empty heterogeneous v2 batch frame.
  Future<List<Object?>> sendBatch(AcpV2Batch batch) =>
      _sendBatchEntries(batch.entries);

  Future<List<Object?>> _sendBatchEntries(
    List<AcpV2BatchEntry<Object?>> entries,
  ) async {
    lifecycle._ensureReady('batch');
    const Set<String> lifecycleSensitive = <String>{
      'initialize',
      'auth/login',
      'session/new',
      'session/resume',
      'session/prompt',
    };
    for (final AcpV2BatchEntry<Object?> entry in entries) {
      _validateMethod(entry.method, entry.kind);
      lifecycle.peerCapabilities._require(
        entry.method.capabilityPath,
        entry.method.name,
      );
      if (lifecycleSensitive.contains(entry.method.name)) {
        throw ArgumentError.value(
          entry.method.name,
          'entries',
          'lifecycle-sensitive ACP v2 methods cannot use a high-level batch',
        );
      }
    }
    return _rawConnection.sendBatch(<JsonRpcBatchEntry>[
      for (final AcpV2BatchEntry<Object?> entry in entries) entry._wireEntry(),
    ]);
  }

  void _validateMethod(
    AcpMethodDescriptorBase method,
    AcpMethodKind expectedKind,
  ) {
    if (method.protocol != AcpProtocolGeneration.v2) {
      throw ArgumentError.value(
        method.name,
        'method',
        'must be an ACP v2 method',
      );
    }
    if (method.kind != expectedKind) {
      throw ArgumentError.value(method.name, 'method', 'has the wrong kind');
    }
    if (method.direction != _outgoingDirection &&
        method.direction != AcpMethodDirection.either) {
      throw ArgumentError.value(
        method.name,
        'method',
        'has the wrong direction',
      );
    }
    if (method.stability == AcpMethodStability.unstable &&
        !options.allowUnstableMethods) {
      throw AcpV2ConnectionStateException(
        'Unstable ACP v2 method ${method.name} is not enabled',
      );
    }
    if (method.paramsDefinition == _v2CustomDefinition) {
      _validateV2CustomName(method.name);
    }
  }
}

/// Agent-side context used to call the client.
final class AcpV2AgentContext extends AcpV2CallContext {
  AcpV2AgentContext._({
    required super.rawConnection,
    required super.lifecycle,
    required super.options,
  }) : super._(outgoingDirection: AcpMethodDirection.agentToClient);
}

/// Client-side context used to call the agent.
final class AcpV2ClientContext extends AcpV2CallContext {
  AcpV2ClientContext._({
    required super.rawConnection,
    required super.lifecycle,
    required super.options,
    required _AcpV2SessionRouter router,
  }) : super._(outgoingDirection: AcpMethodDirection.clientToAgent) {
    sessions = AcpV2Sessions._(this, router);
  }

  /// Session creation and resume helpers.
  late final AcpV2Sessions sessions;
}

/// Shared request handler data.
sealed class AcpV2RequestContext<P> {
  const AcpV2RequestContext({
    required this.params,
    required this.requestId,
    required this.cancellationToken,
  });

  /// Decoded params.
  final P params;

  /// JSON-RPC request id.
  final JsonRpcId requestId;

  /// Cooperative cancellation.
  final CancellationToken cancellationToken;
}

/// Agent request handler context.
final class AcpV2AgentRequestContext<P> extends AcpV2RequestContext<P> {
  /// Creates handler context.
  const AcpV2AgentRequestContext({
    required super.params,
    required super.requestId,
    required super.cancellationToken,
    required this.client,
  });

  /// Client-calling context.
  final AcpV2AgentContext client;
}

/// Client request handler context.
final class AcpV2ClientRequestContext<P> extends AcpV2RequestContext<P> {
  /// Creates handler context.
  const AcpV2ClientRequestContext({
    required super.params,
    required super.requestId,
    required super.cancellationToken,
    required this.agent,
  });

  /// Agent-calling context.
  final AcpV2ClientContext agent;
}

/// Agent notification handler context.
final class AcpV2AgentNotificationContext<P> {
  /// Creates handler context.
  const AcpV2AgentNotificationContext({
    required this.params,
    required this.cancellationToken,
    required this.client,
  });

  /// Decoded params.
  final P params;

  /// Cancels on connection close.
  final CancellationToken cancellationToken;

  /// Client-calling context.
  final AcpV2AgentContext client;
}

/// Client notification handler context.
final class AcpV2ClientNotificationContext<P> {
  /// Creates handler context.
  const AcpV2ClientNotificationContext({
    required this.params,
    required this.cancellationToken,
    required this.agent,
  });

  /// Decoded params.
  final P params;

  /// Cancels on connection close.
  final CancellationToken cancellationToken;

  /// Agent-calling context.
  final AcpV2ClientContext agent;
}
