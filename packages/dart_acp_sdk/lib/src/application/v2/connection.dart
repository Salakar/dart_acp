part of 'application.dart';

/// Application behavior switches for draft ACP v2.
final class AcpV2ApplicationOptions {
  /// Creates immutable options.
  const AcpV2ApplicationOptions({
    this.allowUnstableMethods = false,
    this.requireInitialization = true,
    this.jsonRpcOptions = const JsonRpcConnectionOptions(allowBatches: true),
  });

  /// Whether unstable-overlay descriptors may be registered and sent.
  final bool allowUnstableMethods;

  /// Whether normal traffic requires successful initialization.
  final bool requireInitialization;

  /// JSON-RPC concurrency, queue, batch, and diagnostic configuration.
  ///
  /// Draft-v2 enables batches by default. Numeric limits are validated when a
  /// connection opens.
  final JsonRpcConnectionOptions jsonRpcOptions;

  /// Returns a modified copy.
  AcpV2ApplicationOptions copyWith({
    bool? allowUnstableMethods,
    bool? requireInitialization,
    JsonRpcConnectionOptions? jsonRpcOptions,
  }) => AcpV2ApplicationOptions(
    allowUnstableMethods: allowUnstableMethods ?? this.allowUnstableMethods,
    requireInitialization: requireInitialization ?? this.requireInitialization,
    jsonRpcOptions: jsonRpcOptions ?? this.jsonRpcOptions,
  );
}

/// Per-connection startup behavior.
final class AcpV2ConnectOptions {
  /// Creates startup options.
  const AcpV2ConnectOptions({this.deferConnectHandlers = false});

  /// Whether connect handlers are started manually.
  final bool deferConnectHandlers;
}

/// Current draft-v2 application lifecycle state.
enum AcpV2ConnectionState {
  /// Waiting for `initialize`.
  initializing,

  /// Initialization succeeded.
  ready,

  /// The transport closed.
  closed,
}

/// Immutable peer capabilities negotiated during v2 initialization.
final class AcpV2PeerCapabilities {
  /// Creates a capability view.
  const AcpV2PeerCapabilities(this.value);

  /// Creates an empty view.
  factory AcpV2PeerCapabilities.empty() =>
      AcpV2PeerCapabilities(AcpJsonObject(const <String, AcpJsonValue>{}));

  /// Wire capability fields negotiated during initialization.
  ///
  /// Draft ACP v2 places each peer's advertised capabilities beneath
  /// `capabilities`. An agent's non-empty `authMethods` list is retained at
  /// its wire name because it advertises the authentication method surface.
  final AcpJsonObject value;

  /// Whether a dotted capability path is present and non-null.
  bool supports(String? path) {
    if (path == null || path.isEmpty) {
      return true;
    }
    AcpJsonValue current = value;
    for (final String segment in path.split('.')) {
      if (current is! AcpJsonObject) {
        return false;
      }
      final AcpJsonValue? next = current[segment];
      if (next == null) {
        return false;
      }
      current = next;
    }
    return current is! AcpJsonNull;
  }

  void _require(String? path, String method) {
    if (!supports(path)) {
      throw AcpV2CapabilityUnavailableException(
        method: method,
        capabilityPath: path!,
      );
    }
  }
}

/// A local call was blocked by capability negotiation.
final class AcpV2CapabilityUnavailableException implements Exception {
  /// Creates a capability error.
  const AcpV2CapabilityUnavailableException({
    required this.method,
    required this.capabilityPath,
  });

  /// Method that was not sent.
  final String method;

  /// Missing dotted capability path.
  final String capabilityPath;

  @override
  String toString() =>
      'AcpV2CapabilityUnavailableException: $method requires '
      '$capabilityPath';
}

/// A local draft-v2 lifecycle rule was violated.
final class AcpV2ConnectionStateException implements Exception {
  /// Creates a state error.
  const AcpV2ConnectionStateException(this.message);

  /// Concise diagnostic.
  final String message;

  @override
  String toString() => 'AcpV2ConnectionStateException: $message';
}

/// Coordinates v2 initialization and connection state.
final class AcpV2ConnectionLifecycle {
  AcpV2ConnectionLifecycle._(
    this._rawConnection, {
    required bool requireInitialization,
  }) : _state = requireInitialization
           ? AcpV2ConnectionState.initializing
           : AcpV2ConnectionState.ready {
    if (!requireInitialization) {
      _ready.complete();
    }
    unawaited(_rawConnection.done.whenComplete(_markClosed));
  }

  final JsonRpcConnection _rawConnection;
  final Completer<void> _ready = Completer<void>();
  AcpV2ConnectionState _state;
  AcpV2PeerCapabilities _peerCapabilities = AcpV2PeerCapabilities.empty();
  AcpJsonObject? _peerImplementation;
  List<v2.AuthMethod> _peerAuthMethods = const <v2.AuthMethod>[];

  /// Current state.
  AcpV2ConnectionState get state => _state;

  /// Completes after initialization.
  Future<void> get ready => _ready.future;

  /// Completes when transport processing stops.
  Future<void> get closed => _rawConnection.done;

  /// Cancels on connection close.
  CancellationToken get cancellationToken => _rawConnection.cancellationToken;

  /// Capabilities advertised by the peer.
  AcpV2PeerCapabilities get peerCapabilities => _peerCapabilities;

  /// Peer implementation info.
  AcpJsonObject? get peerImplementation => _peerImplementation;

  /// Authentication methods advertised by the initialized v2 agent.
  List<v2.AuthMethod> get peerAuthMethods => _peerAuthMethods;

  /// Whether normal methods may be used.
  bool get isReady => _state == AcpV2ConnectionState.ready;

  void _markReady({
    required AcpV2PeerCapabilities peerCapabilities,
    required AcpJsonObject peerImplementation,
    Iterable<v2.AuthMethod>? peerAuthMethods,
  }) {
    if (_state != AcpV2ConnectionState.initializing) {
      throw StateError('ACP v2 connection cannot initialize from $_state');
    }
    _peerCapabilities = peerCapabilities;
    _peerImplementation = peerImplementation;
    _peerAuthMethods = List<v2.AuthMethod>.unmodifiable(
      peerAuthMethods ?? const <v2.AuthMethod>[],
    );
    _state = AcpV2ConnectionState.ready;
    _ready.complete();
  }

  void _ensureReady(String method) {
    if (!isReady) {
      throw AcpV2ConnectionStateException(
        'ACP v2 method $method is unavailable before initialization',
      );
    }
  }

  void _markClosed() {
    if (_state == AcpV2ConnectionState.closed) {
      return;
    }
    _state = AcpV2ConnectionState.closed;
    if (!_ready.isCompleted) {
      _ready.completeError(
        StateError('ACP v2 connection closed before initialization'),
      );
    }
  }
}

/// Shared behavior for a draft-v2 connection.
abstract interface class AcpV2Connection {
  /// Application lifecycle.
  AcpV2ConnectionLifecycle get lifecycle;

  /// Completes when closed.
  Future<void> get closed;

  /// Closes idempotently.
  void close([Object? reason]);

  /// Starts deferred connect handlers exactly once.
  void startConnectHandlers();
}

/// Agent connection and client-calling context.
final class AcpV2AgentConnection implements AcpV2Connection {
  AcpV2AgentConnection._(this._rawConnection, this.lifecycle, this.client);

  final JsonRpcConnection _rawConnection;
  void Function()? _startHandlers;
  bool _handlersStarted = false;

  @override
  final AcpV2ConnectionLifecycle lifecycle;

  /// Context for client-handled calls.
  final AcpV2AgentContext client;

  @override
  Future<void> get closed => _rawConnection.done;

  @override
  void close([Object? reason]) => _rawConnection.close(reason);

  @override
  void startConnectHandlers() {
    if (_handlersStarted) {
      return;
    }
    _handlersStarted = true;
    _startHandlers?.call();
  }
}

/// Client connection and agent-calling context.
final class AcpV2ClientConnection implements AcpV2Connection {
  AcpV2ClientConnection._(this._rawConnection, this.lifecycle, this.agent);

  final JsonRpcConnection _rawConnection;
  void Function()? _startHandlers;
  bool _handlersStarted = false;

  @override
  final AcpV2ConnectionLifecycle lifecycle;

  /// Context for agent-handled calls and sessions.
  final AcpV2ClientContext agent;

  @override
  Future<void> get closed => _rawConnection.done;

  @override
  void close([Object? reason]) => _rawConnection.close(reason);

  @override
  void startConnectHandlers() {
    if (_handlersStarted) {
      return;
    }
    _handlersStarted = true;
    _startHandlers?.call();
  }
}

/// Both sides of a bounded direct v2 connection.
final class AcpV2DirectConnectionPair {
  AcpV2DirectConnectionPair._(
    this.agent,
    this.client,
    this._agentTransport,
    this._clientTransport,
  );

  /// Agent side.
  final AcpV2AgentConnection agent;

  /// Client side.
  final AcpV2ClientConnection client;

  final AcpDuplexStream<Object?> _agentTransport;
  final AcpDuplexStream<Object?> _clientTransport;

  /// Closes both sides and writer halves.
  Future<void> close([Object? reason]) async {
    agent.close(reason);
    client.close(reason);
    await Future.wait<void>(<Future<void>>[
      _agentTransport.writable.close(),
      _clientTransport.writable.close(),
    ]);
  }
}
