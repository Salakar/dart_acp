part of 'application.dart';

const String _customDefinitionMarker = r'$custom';

/// Creates a typed custom ACP request descriptor.
///
/// Custom names must begin with `_` and cannot be empty after the prefix.
AcpMethodDescriptor<P, R> acpCustomRequestMethod<P, R>({
  required String name,
  required AcpMethodDirection direction,
  required AcpCodec<P> paramsCodec,
  required AcpCodec<R> resultCodec,
}) {
  _validateCustomMethodName(name);
  return AcpMethodDescriptor<P, R>(
    name: name,
    dartName: name,
    protocol: AcpProtocolGeneration.v1,
    stability: AcpMethodStability.stable,
    direction: direction,
    kind: AcpMethodKind.request,
    paramsDefinition: _customDefinitionMarker,
    resultDefinition: _customDefinitionMarker,
    paramsCodec: paramsCodec,
    resultCodec: resultCodec,
  );
}

/// Creates a typed custom ACP notification descriptor.
AcpMethodDescriptor<P, AcpNoResult> acpCustomNotificationMethod<P>({
  required String name,
  required AcpMethodDirection direction,
  required AcpCodec<P> paramsCodec,
}) {
  _validateCustomMethodName(name);
  return AcpMethodDescriptor<P, AcpNoResult>(
    name: name,
    dartName: name,
    protocol: AcpProtocolGeneration.v1,
    stability: AcpMethodStability.stable,
    direction: direction,
    kind: AcpMethodKind.notification,
    paramsDefinition: _customDefinitionMarker,
    paramsCodec: paramsCodec,
    resultCodec: acpNoResultCodec,
  );
}

void _validateCustomMethodName(String name) {
  if (name.length <= 1 || !name.startsWith('_')) {
    throw ArgumentError.value(
      name,
      'name',
      'custom ACP method names must start with "_"',
    );
  }
}

bool _isCustomDescriptor(AcpMethodDescriptorBase descriptor) =>
    descriptor.paramsDefinition == _customDefinitionMarker;

/// Shared context for descriptor-backed calls.
sealed class AcpCallContext {
  AcpCallContext._({
    required JsonRpcConnection rawConnection,
    required this.lifecycle,
    required this.options,
    required AcpMethodDirection outgoingDirection,
  }) : _rawConnection = rawConnection,
       _outgoingDirection = outgoingDirection;

  final JsonRpcConnection _rawConnection;
  final AcpMethodDirection _outgoingDirection;

  /// Lifecycle of the containing connection.
  final AcpConnectionLifecycle lifecycle;

  /// Application behavior options.
  final AcpApplicationOptions options;

  /// Sends a typed request after lifecycle and capability checks.
  Future<R> request<P, R>(
    AcpMethodDescriptor<P, R> method,
    P params, {
    CancellationToken? cancellationToken,
  }) => _request(
    method,
    params,
    cancellationToken: cancellationToken,
    duringInitialization: false,
    enforceCapability: false,
  );

  Future<R> _request<P, R>(
    AcpMethodDescriptor<P, R> method,
    P params, {
    CancellationToken? cancellationToken,
    required bool duringInitialization,
    bool enforceCapability = false,
  }) {
    _validateMethod(method, AcpMethodKind.request);
    if (!duringInitialization) {
      lifecycle._ensureReady(method.name);
      if (enforceCapability) {
        lifecycle.peerCapabilities.require(
          method.capabilityPath,
          method: method.name,
        );
      }
    }
    return _rawConnection.sendRequest<R>(
      method: method.name,
      params: JsonRpcParams.value(method.paramsCodec.encode(params)),
      decode: method.resultCodec.decode,
      cancellationToken: cancellationToken,
    );
  }

  Future<R> _requestKnown<P, R>(
    AcpMethodDescriptor<P, R> method,
    P params, {
    CancellationToken? cancellationToken,
  }) => _request(
    method,
    params,
    cancellationToken: cancellationToken,
    duringInitialization: false,
    enforceCapability: true,
  );

  /// Sends a typed notification after lifecycle and capability checks.
  Future<void> notify<P>(AcpMethodDescriptor<P, AcpNoResult> method, P params) {
    _validateMethod(method, AcpMethodKind.notification);
    lifecycle._ensureReady(method.name);
    return _rawConnection.sendNotification(
      method: method.name,
      params: JsonRpcParams.value(method.paramsCodec.encode(params)),
    );
  }

  Future<void> _notifyKnown<P>(
    AcpMethodDescriptor<P, AcpNoResult> method,
    P params,
  ) {
    _validateMethod(method, AcpMethodKind.notification);
    lifecycle._ensureReady(method.name);
    lifecycle.peerCapabilities.require(
      method.capabilityPath,
      method: method.name,
    );
    return _rawConnection.sendNotification(
      method: method.name,
      params: JsonRpcParams.value(method.paramsCodec.encode(params)),
    );
  }

  void _validateMethod(
    AcpMethodDescriptorBase method,
    AcpMethodKind expectedKind,
  ) {
    if (method.protocol != AcpProtocolGeneration.v1) {
      throw ArgumentError.value(
        method.name,
        'method',
        'must be an ACP v1 method',
      );
    }
    if (method.direction != _outgoingDirection &&
        method.direction != AcpMethodDirection.either) {
      throw ArgumentError.value(
        method.name,
        'method',
        'has the wrong ACP direction for this context',
      );
    }
    if (method.kind != expectedKind) {
      throw ArgumentError.value(
        method.name,
        'method',
        'has the wrong JSON-RPC method kind',
      );
    }
    if (method.stability == AcpMethodStability.unstable &&
        !options.allowUnstableMethods) {
      throw AcpConnectionStateException(
        'Unstable ACP method ${method.name} is not enabled',
      );
    }
    if (_isCustomDescriptor(method)) {
      _validateCustomMethodName(method.name);
    }
  }
}

/// Context used by an agent to call client-handled methods.
final class AcpAgentContext extends AcpCallContext {
  AcpAgentContext._({
    required super.rawConnection,
    required super.lifecycle,
    required super.options,
  }) : super._(outgoingDirection: AcpMethodDirection.agentToClient);
}

/// Context used by a client to call agent-handled methods.
final class AcpClientContext extends AcpCallContext {
  AcpClientContext._({
    required super.rawConnection,
    required super.lifecycle,
    required super.options,
    required _AcpSessionRouter sessions,
  }) : super._(outgoingDirection: AcpMethodDirection.clientToAgent) {
    this.sessions = AcpSessions._(this, sessions);
  }

  /// Creates session builders and performs stable session lifecycle calls.
  late final AcpSessions sessions;
}

/// Common fields supplied to a typed request handler.
sealed class AcpRequestContext<P> {
  const AcpRequestContext({
    required this.params,
    required this.requestId,
    required this.cancellationToken,
  });

  /// Decoded method parameters.
  final P params;

  /// JSON-RPC correlation ID.
  final JsonRpcId requestId;

  /// Cooperative request cancellation.
  final CancellationToken cancellationToken;
}

/// Request context for a method handled by an agent app.
final class AcpAgentRequestContext<P> extends AcpRequestContext<P> {
  /// Creates an agent request context.
  const AcpAgentRequestContext({
    required super.params,
    required super.requestId,
    required super.cancellationToken,
    required this.client,
  });

  /// Context for calling back into the client.
  final AcpAgentContext client;
}

/// Request context for a method handled by a client app.
final class AcpClientRequestContext<P> extends AcpRequestContext<P> {
  /// Creates a client request context.
  const AcpClientRequestContext({
    required super.params,
    required super.requestId,
    required super.cancellationToken,
    required this.agent,
  });

  /// Context for calling back into the agent.
  final AcpClientContext agent;
}

/// Common fields supplied to a typed notification handler.
sealed class AcpNotificationContext<P> {
  const AcpNotificationContext({
    required this.params,
    required this.cancellationToken,
  });

  /// Decoded notification parameters.
  final P params;

  /// Cancels when the connection closes.
  final CancellationToken cancellationToken;
}

/// Notification context for a method handled by an agent app.
final class AcpAgentNotificationContext<P> extends AcpNotificationContext<P> {
  /// Creates an agent notification context.
  const AcpAgentNotificationContext({
    required super.params,
    required super.cancellationToken,
    required this.client,
  });

  /// Context for calling the client.
  final AcpAgentContext client;
}

/// Notification context for a method handled by a client app.
final class AcpClientNotificationContext<P> extends AcpNotificationContext<P> {
  /// Creates a client notification context.
  const AcpClientNotificationContext({
    required super.params,
    required super.cancellationToken,
    required this.agent,
  });

  /// Context for calling the agent.
  final AcpClientContext agent;
}
