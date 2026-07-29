part of 'application.dart';

/// Typed agent-side initialization metadata extraction.
final class AcpAgentInitialization<P, R>
    extends AcpAgentInitializationConfiguration {
  /// Creates an initialization adapter.
  const AcpAgentInitialization({
    required this.method,
    required this.peerCapabilities,
    this.peerImplementation,
    this.validateRequest,
  });

  /// The generated v1 initialize descriptor.
  final AcpMethodDescriptor<P, R> method;

  /// Extracts client capabilities from the request.
  final AcpPeerCapabilities Function(P request) peerCapabilities;

  /// Extracts optional client implementation information.
  final AcpJsonObject? Function(P request)? peerImplementation;

  /// Validates negotiated-version or application-specific request invariants.
  final void Function(P request)? validateRequest;

  @override
  String get methodName => method.name;

  @override
  P _validate(Object? rawParams) {
    final P request = method.paramsCodec.decode(rawParams);
    validateRequest?.call(request);
    return request;
  }

  @override
  void _establish(Object? rawParams, AcpConnectionLifecycle lifecycle) {
    final P request = _validate(rawParams);
    lifecycle._markReady(
      peerCapabilities: peerCapabilities(request),
      peerImplementation: peerImplementation?.call(request),
    );
  }
}

/// Typed client-side initialization request and metadata extraction.
final class AcpClientInitialization<P, R>
    extends AcpClientInitializationConfiguration {
  /// Creates an initialization adapter.
  const AcpClientInitialization({
    required this.method,
    required this.request,
    required this.peerCapabilities,
    this.peerImplementation,
    this.peerAuthMethods,
    this.validateResponse,
  });

  /// The generated v1 initialize descriptor.
  final AcpMethodDescriptor<P, R> method;

  /// The request sent immediately after the transport opens.
  final P request;

  /// Extracts agent capabilities from the response.
  final AcpPeerCapabilities Function(R response) peerCapabilities;

  /// Extracts optional agent implementation information.
  final AcpJsonObject? Function(R response)? peerImplementation;

  /// Extracts authentication methods advertised by the agent.
  final Iterable<v1.AuthMethod> Function(R response)? peerAuthMethods;

  /// Validates the negotiated response before the connection becomes ready.
  final void Function(R response)? validateResponse;

  @override
  String get methodName => method.name;

  @override
  Future<void> _start(
    AcpClientContext context,
    AcpConnectionLifecycle lifecycle,
  ) async {
    final R response = await context._request(
      method,
      request,
      duringInitialization: true,
    );
    validateResponse?.call(response);
    lifecycle._markReady(
      peerCapabilities: peerCapabilities(response),
      peerImplementation: peerImplementation?.call(response),
      peerAuthMethods: peerAuthMethods?.call(response),
    );
  }
}

/// Type-safe configuration accepted by [AcpAgentApp].
sealed class AcpAgentInitializationConfiguration {
  const AcpAgentInitializationConfiguration();

  /// Exact initialize method name.
  String get methodName;

  Object? _validate(Object? rawParams);

  void _establish(Object? rawParams, AcpConnectionLifecycle lifecycle);
}

/// Type-safe configuration accepted by [AcpClientApp].
sealed class AcpClientInitializationConfiguration {
  const AcpClientInitializationConfiguration();

  /// Exact initialize method name.
  String get methodName;

  Future<void> _start(
    AcpClientContext context,
    AcpConnectionLifecycle lifecycle,
  );
}

/// Current application-level connection state.
enum AcpConnectionState {
  /// Waiting for ACP initialization.
  initializing,

  /// Initialization succeeded and normal methods are available.
  ready,

  /// The transport has closed.
  closed,
}

/// Coordinates initialization, connect handlers, and close state.
final class AcpConnectionLifecycle {
  AcpConnectionLifecycle._({
    required JsonRpcConnection rawConnection,
    required bool requireInitialization,
  }) : _rawConnection = rawConnection,
       _state = requireInitialization
           ? AcpConnectionState.initializing
           : AcpConnectionState.ready {
    unawaited(
      rawConnection.done.whenComplete(() {
        _markClosed();
      }),
    );
    if (!requireInitialization) {
      _ready.complete();
    }
  }

  final JsonRpcConnection _rawConnection;
  final Completer<void> _ready = Completer<void>();
  AcpConnectionState _state;
  AcpPeerCapabilities _peerCapabilities = AcpPeerCapabilities.empty();
  AcpJsonObject? _peerImplementation;
  List<v1.AuthMethod> _peerAuthMethods = const <v1.AuthMethod>[];

  /// Current lifecycle state.
  AcpConnectionState get state => _state;

  /// Completes when initialization has succeeded.
  Future<void> get ready => _ready.future;

  /// Completes when the underlying connection closes.
  Future<void> get closed => _rawConnection.done;

  /// Cancels when the underlying connection closes.
  CancellationToken get cancellationToken => _rawConnection.cancellationToken;

  /// Capabilities supplied by the initialized peer.
  AcpPeerCapabilities get peerCapabilities => _peerCapabilities;

  /// Peer implementation information, when supplied by initialization.
  AcpJsonObject? get peerImplementation => _peerImplementation;

  /// Authentication methods advertised by the initialized v1 agent.
  List<v1.AuthMethod> get peerAuthMethods => _peerAuthMethods;

  /// Whether normal ACP methods can be sent or handled.
  bool get isReady => _state == AcpConnectionState.ready;

  void _markReady({
    required AcpPeerCapabilities peerCapabilities,
    AcpJsonObject? peerImplementation,
    Iterable<v1.AuthMethod>? peerAuthMethods,
  }) {
    if (_state == AcpConnectionState.closed) {
      throw StateError('Cannot initialize a closed ACP connection');
    }
    if (_state == AcpConnectionState.ready) {
      throw StateError('ACP connection is already initialized');
    }
    _peerCapabilities = peerCapabilities;
    _peerImplementation = peerImplementation;
    _peerAuthMethods = List<v1.AuthMethod>.unmodifiable(
      peerAuthMethods ?? const <v1.AuthMethod>[],
    );
    _state = AcpConnectionState.ready;
    _ready.complete();
  }

  void _ensureReady(String method) {
    if (!isReady) {
      throw AcpConnectionStateException(
        'ACP method $method is unavailable before initialization',
      );
    }
  }

  void _markClosed() {
    _state = AcpConnectionState.closed;
    if (!_ready.isCompleted) {
      _ready.completeError(
        StateError('ACP connection closed before initialization'),
      );
    }
  }
}

/// A local application lifecycle violation.
final class AcpConnectionStateException implements Exception {
  /// Creates a lifecycle exception.
  const AcpConnectionStateException(this.message);

  /// A concise description.
  final String message;

  @override
  String toString() => 'AcpConnectionStateException: $message';
}

/// Common active ACP connection behavior.
abstract interface class AcpConnection {
  /// Application lifecycle for this connection.
  AcpConnectionLifecycle get lifecycle;

  /// Completes when the connection closes.
  Future<void> get closed;

  /// Closes the connection idempotently.
  void close([Object? reason]);
}

/// An agent connection and its client-calling context.
final class AcpAgentConnection implements AcpConnection {
  AcpAgentConnection._({
    required JsonRpcConnection rawConnection,
    required this.lifecycle,
    required this.client,
  }) : _rawConnection = rawConnection;

  final JsonRpcConnection _rawConnection;
  void Function()? _startHandlers;
  bool _handlersStarted = false;

  @override
  final AcpConnectionLifecycle lifecycle;

  /// Context for calling methods handled by the client.
  final AcpAgentContext client;

  @override
  Future<void> get closed => _rawConnection.done;

  @override
  void close([Object? reason]) {
    _rawConnection.close(reason);
    lifecycle._markClosed();
  }

  /// Starts deferred connect handlers, exactly once.
  void startConnectHandlers() {
    if (_handlersStarted) {
      return;
    }
    _handlersStarted = true;
    _startHandlers?.call();
  }
}

/// A client connection and its agent-calling context.
final class AcpClientConnection implements AcpConnection {
  AcpClientConnection._({
    required JsonRpcConnection rawConnection,
    required this.lifecycle,
    required this.agent,
  }) : _rawConnection = rawConnection;

  final JsonRpcConnection _rawConnection;
  void Function()? _startHandlers;
  bool _handlersStarted = false;

  @override
  final AcpConnectionLifecycle lifecycle;

  /// Context for calling methods handled by the agent.
  final AcpClientContext agent;

  @override
  Future<void> get closed => _rawConnection.done;

  @override
  void close([Object? reason]) {
    _rawConnection.close(reason);
    lifecycle._markClosed();
  }

  /// Starts deferred connect handlers, exactly once.
  void startConnectHandlers() {
    if (_handlersStarted) {
      return;
    }
    _handlersStarted = true;
    _startHandlers?.call();
  }
}

/// Both sides of a direct in-process connection.
final class AcpDirectConnectionPair {
  /// Creates a direct pair around two active connections.
  const AcpDirectConnectionPair({
    required this.agent,
    required this.client,
    required AcpDuplexStream<Object?> agentTransport,
    required AcpDuplexStream<Object?> clientTransport,
  }) : _agentTransport = agentTransport,
       _clientTransport = clientTransport;

  /// The agent-side connection.
  final AcpAgentConnection agent;

  /// The client-side connection.
  final AcpClientConnection client;

  final AcpDuplexStream<Object?> _agentTransport;
  final AcpDuplexStream<Object?> _clientTransport;

  /// Closes both connections and in-memory writer halves.
  Future<void> close([Object? reason]) async {
    agent.close(reason);
    client.close(reason);
    await Future.wait<void>(<Future<void>>[
      _agentTransport.writable.close(),
      _clientTransport.writable.close(),
    ]);
  }
}
