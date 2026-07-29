import 'dart:async';

import '../json_rpc/codec.dart';
import '../json_rpc/id.dart';
import '../transport/duplex_stream.dart';
import 'outbound_hub.dart';

/// Creates the transport state for one accepted remote ACP connection.
typedef AcpServerConnectionFactory =
    FutureOr<AcpServerConnectionState> Function(String connectionId);

/// A destination for messages leaving a remotely hosted ACP connection.
sealed class AcpServerRoute {
  const AcpServerRoute();
}

/// The connection-level response/event stream.
final class AcpConnectionRoute extends AcpServerRoute {
  /// Creates the singleton connection route.
  const AcpConnectionRoute();

  @override
  bool operator ==(Object other) => other is AcpConnectionRoute;

  @override
  int get hashCode => Object.hash(AcpConnectionRoute, 0);

  @override
  String toString() => 'connection';
}

/// A session-specific response/event stream.
final class AcpSessionRoute extends AcpServerRoute {
  /// Creates a session route.
  const AcpSessionRoute(this.sessionId);

  /// The exact session identifier.
  final String sessionId;

  @override
  bool operator ==(Object other) =>
      other is AcpSessionRoute && other.sessionId == sessionId;

  @override
  int get hashCode => Object.hash(AcpSessionRoute, sessionId);

  @override
  String toString() => 'session:$sessionId';
}

/// A client-supplied route cannot be applied safely.
final class AcpServerRouteError extends StateError {
  /// Creates a routing failure with a safe diagnostic [message].
  AcpServerRouteError(super.message);
}

/// Internal state for one remotely transported ACP connection.
///
/// Incoming HTTP/WebSocket messages are serialized into [inbound]. Messages
/// produced by the connected application are routed to connection and session
/// hubs while [allOutbound] retains original batch framing.
final class AcpServerConnectionState {
  /// Creates and starts a server connection state.
  AcpServerConnectionState({
    required this.connectionId,
    required AcpWritable<Object?> inbound,
    required Stream<Object?> outbound,
    this.outboundCapacity = 1024,
    this.maximumSessions = 10000,
    this.maximumPendingRoutes = 4096,
    bool allowBatches = false,
    AcpOutboundOverflowHandler? onOverflow,
  }) : _inbound = inbound,
       _allowBatches = allowBatches,
       allOutbound = AcpOutboundHub<Object?>(
         capacity: outboundCapacity,
         onOverflow: onOverflow,
       ),
       connectionOutbound = AcpOutboundHub<Object?>(
         capacity: outboundCapacity,
         onOverflow: onOverflow,
       ),
       _onOverflow = onOverflow {
    if (connectionId.isEmpty) {
      throw ArgumentError.value(
        connectionId,
        'connectionId',
        'must not be empty',
      );
    }
    if (maximumSessions <= 0) {
      throw ArgumentError.value(
        maximumSessions,
        'maximumSessions',
        'must be positive',
      );
    }
    if (maximumPendingRoutes <= 0) {
      throw ArgumentError.value(
        maximumPendingRoutes,
        'maximumPendingRoutes',
        'must be positive',
      );
    }
    // The state owns this subscription and cancels it in close().
    // ignore: cancel_subscriptions
    final StreamSubscription<Object?> subscription = outbound.listen(
      (Object? frame) {
        try {
          _routeOutbound(frame);
        } on Object catch (error) {
          unawaited(close(error));
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        unawaited(close(error));
      },
      onDone: close,
    );
    _outboundSubscription = subscription;
  }

  /// Opaque routing identifier. This is not an authentication credential.
  final String connectionId;

  /// Maximum values retained by each outbound hub.
  final int outboundCapacity;

  /// Maximum session routes retained by this connection.
  final int maximumSessions;

  /// Maximum request/response routes retained while calls are pending.
  final int maximumPendingRoutes;

  /// Original frames emitted by the application.
  final AcpOutboundHub<Object?> allOutbound;

  /// Connection-scoped individual messages.
  final AcpOutboundHub<Object?> connectionOutbound;

  final AcpWritable<Object?> _inbound;
  final AcpOutboundOverflowHandler? _onOverflow;
  final JsonRpcCodec _codec = const JsonRpcCodec();
  final Map<String, AcpOutboundHub<Object?>> _sessionHubs =
      <String, AcpOutboundHub<Object?>>{};
  final Map<JsonRpcId, AcpServerRoute> _pendingRoutes =
      <JsonRpcId, AcpServerRoute>{};
  final Map<JsonRpcId, AcpServerRoute> _clientResponseRoutes =
      <JsonRpcId, AcpServerRoute>{};
  final Map<JsonRpcId, int> _pendingRouteVersions = <JsonRpcId, int>{};
  final Map<JsonRpcId, int> _clientResponseRouteVersions = <JsonRpcId, int>{};
  final Map<JsonRpcId, Completer<Object?>> _responseWaiters =
      <JsonRpcId, Completer<Object?>>{};
  final Completer<void> _closed = Completer<void>();
  Future<void> _writeTail = Future<void>.value();
  StreamSubscription<Object?>? _outboundSubscription;
  bool _allowBatches;
  bool _isClosed = false;
  Object? _closeReason;
  int _nextRouteVersion = 0;

  /// Whether the state has closed.
  bool get isClosed => _isClosed;

  /// Reason supplied to [close], when any.
  Object? get closeReason => _closeReason;

  /// Completes after every owned transport/hub has settled.
  Future<void> get closed => _closed.future;

  /// Number of active session routes.
  int get sessionCount => _sessionHubs.length;

  /// Waits for and consumes one outbound response with [id].
  ///
  /// Server handshakes use this before writing the matching initialize request
  /// so the response cannot race subscription setup. A consumed response is
  /// not also published to an SSE or WebSocket route.
  Future<Object?> receiveResponse(JsonRpcId id) {
    if (_isClosed) {
      return Future<Object?>.error(
        _closeReason ?? StateError('ACP server connection is closed'),
      );
    }
    if (_responseWaiters.containsKey(id)) {
      return Future<Object?>.error(
        StateError('A response waiter already exists for $id'),
      );
    }
    if (_responseWaiters.length >= maximumPendingRoutes) {
      return Future<Object?>.error(
        StateError('ACP response waiter limit exceeded'),
      );
    }
    final completer = Completer<Object?>();
    _responseWaiters[id] = completer;
    return completer.future;
  }

  /// Cancels a response waiter registered by [receiveResponse].
  bool cancelResponseWaiter(JsonRpcId id, [Object? reason]) {
    final Completer<Object?>? waiter = _responseWaiters.remove(id);
    if (waiter == null) {
      return false;
    }
    waiter.completeError(reason ?? StateError('ACP response wait cancelled'));
    return true;
  }

  /// Returns the expected route for a response to an agent request.
  AcpServerRoute? expectedClientResponseRoute(JsonRpcId id) =>
      _clientResponseRoutes[id];

  /// Enables JSON-RPC batch frames after protocol-v2 negotiation.
  void enableBatches() {
    if (_isClosed) {
      throw StateError('Cannot enable batches on a closed connection');
    }
    _allowBatches = true;
  }

  /// Returns the interned hub for [sessionId].
  AcpOutboundHub<Object?> ensureSession(String sessionId) {
    if (_isClosed) {
      throw StateError('Cannot create a session route on a closed connection');
    }
    if (sessionId.isEmpty) {
      throw ArgumentError.value(sessionId, 'sessionId', 'must not be empty');
    }
    final AcpOutboundHub<Object?>? existing = _sessionHubs[sessionId];
    if (existing != null) {
      return existing;
    }
    if (_sessionHubs.length >= maximumSessions) {
      throw StateError('ACP session route limit exceeded');
    }
    final hub = AcpOutboundHub<Object?>(
      capacity: outboundCapacity,
      onOverflow: _onOverflow,
    );
    _sessionHubs[sessionId] = hub;
    return hub;
  }

  /// Looks up a session hub without creating it.
  AcpOutboundHub<Object?>? session(String sessionId) => _sessionHubs[sessionId];

  /// Serializes one incoming transport frame into the application.
  ///
  /// [route] records where a later response should be emitted. A client
  /// response must return through the same route as the agent request. By
  /// default a top-level `params.sessionId` refines a connection route; set
  /// [inferSessionRoute] to false when the transport contract deliberately
  /// routes a response elsewhere, such as an HTTP `session/load` response.
  /// Headerless transports may set [validateClientResponseRoute] to false
  /// after establishing that every response arrived over the same connection.
  Future<void> writeInbound(
    Object? frame, {
    AcpServerRoute route = const AcpConnectionRoute(),
    bool inferSessionRoute = true,
    bool validateClientResponseRoute = true,
  }) {
    if (_isClosed) {
      return Future<void>.error(
        _closeReason ?? StateError('ACP server connection is closed'),
      );
    }
    if (frame is List<Object?> && !_allowBatches) {
      return Future<void>.error(
        StateError('JSON-RPC batches are not enabled for this connection'),
      );
    }
    final _InboundRouteChanges changes;
    try {
      changes = _recordInboundRoutes(
        frame,
        route,
        inferSessionRoute,
        validateClientResponseRoute,
      );
    } on Object catch (error, stackTrace) {
      return Future<void>.error(error, stackTrace);
    }

    final completer = Completer<void>();
    final Future<void> previous = _writeTail;
    _writeTail = () async {
      try {
        await previous;
      } on Object {
        // An individual failed write must not poison later serialized writes.
      }
      try {
        if (_isClosed) {
          changes.rollback(this);
          completer.completeError(
            _closeReason ?? StateError('ACP server connection is closed'),
          );
          return;
        }
        await _inbound.write(frame);
        changes.commit(this);
        completer.complete();
      } on Object catch (error, stackTrace) {
        changes.rollback(this);
        completer.completeError(error, stackTrace);
      }
    }();
    return completer.future;
  }

  _InboundRouteChanges _recordInboundRoutes(
    Object? frame,
    AcpServerRoute route,
    bool inferSessionRoute,
    bool validateClientResponseRoute,
  ) {
    final changes = _InboundRouteChanges();
    final Set<JsonRpcId> pendingIds = _pendingRoutes.keys.toSet();
    final Map<JsonRpcId, AcpServerRoute> clientRoutes =
        Map<JsonRpcId, AcpServerRoute>.of(_clientResponseRoutes);
    final Set<String> sessions = _sessionHubs.keys.toSet();
    final Iterable<Object?> entries = frame is List<Object?>
        ? frame
        : <Object?>[frame];
    for (final Object? entry in entries) {
      final Map<String, Object?>? object = _codec.asJsonObject(entry);
      if (object == null) {
        continue;
      }
      if (_codec.isRequest(object)) {
        final JsonRpcId id = JsonRpcId.fromJson(object['id']);
        if (pendingIds.contains(id)) {
          throw AcpServerRouteError('Duplicate pending request ID: $id');
        }
        if (pendingIds.length >= maximumPendingRoutes) {
          throw AcpServerRouteError(
            'ACP pending response route limit exceeded',
          );
        }
        final String? sessionId = _sessionIdFromValue(object['params']);
        if (route case AcpSessionRoute(
          sessionId: final expected,
        ) when sessionId != null && sessionId != expected) {
          throw AcpServerRouteError(
            'Request session $sessionId does not match route $expected',
          );
        }
        final AcpServerRoute effectiveRoute = object['method'] == 'session/load'
            ? const AcpConnectionRoute()
            : inferSessionRoute && sessionId != null
            ? AcpSessionRoute(sessionId)
            : route;
        if (sessionId != null) {
          _recordSession(sessions, changes.sessionsToEnsure, sessionId);
        }
        pendingIds.add(id);
        changes.pendingToAdd[id] = effectiveRoute;
        continue;
      }
      if (_codec.isNotification(object)) {
        final String? sessionId = _sessionIdFromValue(object['params']);
        if (sessionId != null) {
          _recordSession(sessions, changes.sessionsToEnsure, sessionId);
        }
        continue;
      }
      if (_codec.isResponse(object) || _codec.isResponseShaped(object)) {
        final JsonRpcId? id = object.containsKey('id')
            ? _codec.tryDecodeId(object['id'])
            : null;
        if (id == null) {
          continue;
        }
        final AcpServerRoute? expected = clientRoutes[id];
        if (validateClientResponseRoute &&
            expected != null &&
            expected != route) {
          throw AcpServerRouteError(
            'Response $id returned on $route instead of $expected',
          );
        }
        clientRoutes.remove(id);
        if (expected != null) {
          changes.removedClientRoutes[id] = expected;
        }
      }
    }

    for (final String sessionId in changes.sessionsToEnsure) {
      ensureSession(sessionId);
    }
    for (final MapEntry<JsonRpcId, AcpServerRoute> entry
        in changes.pendingToAdd.entries) {
      final int version = _newRouteVersion();
      _pendingRoutes[entry.key] = entry.value;
      _pendingRouteVersions[entry.key] = version;
      changes.addedPendingVersions[entry.key] = version;
    }
    for (final MapEntry<JsonRpcId, AcpServerRoute> entry
        in changes.removedClientRoutes.entries) {
      _clientResponseRoutes.remove(entry.key);
      final int mutation = _newRouteVersion();
      _clientResponseRouteVersions[entry.key] = mutation;
      changes.removedClientRouteMutations[entry.key] = mutation;
    }
    return changes;
  }

  void _recordSession(
    Set<String> sessions,
    Set<String> additions,
    String sessionId,
  ) {
    if (sessions.contains(sessionId)) {
      return;
    }
    if (sessions.length >= maximumSessions) {
      throw AcpServerRouteError('ACP session route limit exceeded');
    }
    sessions.add(sessionId);
    additions.add(sessionId);
  }

  int _newRouteVersion() => _nextRouteVersion += 1;

  void _routeOutbound(Object? frame) {
    if (_isClosed) {
      return;
    }
    if (frame is List<Object?>) {
      if (!_allowBatches) {
        unawaited(
          close(StateError('Received a batch before batches were enabled')),
        );
        return;
      }
      final List<Object?> routed = <Object?>[
        for (final Object? entry in frame)
          if (!_consumeResponseWaiter(entry)) entry,
      ];
      if (routed.isEmpty) {
        return;
      }
      allOutbound.add(routed.length == frame.length ? frame : routed);
      for (final Object? entry in routed) {
        _routeOutboundEntry(entry);
      }
      return;
    }
    if (_consumeResponseWaiter(frame)) {
      return;
    }
    allOutbound.add(frame);
    _routeOutboundEntry(frame);
  }

  bool _consumeResponseWaiter(Object? entry) {
    final Map<String, Object?>? object = _codec.asJsonObject(entry);
    if (object == null ||
        (!_codec.isResponse(object) && !_codec.isResponseShaped(object)) ||
        !object.containsKey('id')) {
      return false;
    }
    final JsonRpcId? id = _codec.tryDecodeId(object['id']);
    final Completer<Object?>? waiter = id == null
        ? null
        : _responseWaiters.remove(id);
    if (waiter == null) {
      return false;
    }
    _pendingRoutes.remove(id);
    _pendingRouteVersions.remove(id);
    waiter.complete(entry);
    if (_codec.isResponse(object) && object.containsKey('result')) {
      final String? sessionId = _sessionIdFromValue(object['result']);
      if (sessionId != null) {
        ensureSession(sessionId);
      }
    }
    return true;
  }

  void _routeOutboundEntry(Object? entry) {
    final Map<String, Object?>? object = _codec.asJsonObject(entry);
    if (object == null) {
      return;
    }

    if (_codec.isResponse(object) || _codec.isResponseShaped(object)) {
      final JsonRpcId? id = object.containsKey('id')
          ? _codec.tryDecodeId(object['id'])
          : null;
      final AcpServerRoute route = id == null
          ? const AcpConnectionRoute()
          : (_removePendingRoute(id) ?? const AcpConnectionRoute());
      _hubFor(route).add(entry);
      if (_codec.isResponse(object) && object.containsKey('result')) {
        final String? sessionId = _sessionIdFromValue(object['result']);
        if (sessionId != null) {
          ensureSession(sessionId);
        }
      }
      return;
    }

    if (object['method'] is! String) {
      return;
    }
    final String? sessionId = _sessionIdFromValue(object['params']);
    final AcpServerRoute route = sessionId == null
        ? const AcpConnectionRoute()
        : AcpSessionRoute(sessionId);
    if (sessionId != null) {
      ensureSession(sessionId);
    }
    if (_codec.isRequest(object)) {
      final JsonRpcId id = JsonRpcId.fromJson(object['id']);
      if (_clientResponseRoutes.containsKey(id)) {
        unawaited(close(StateError('Duplicate agent request ID: $id')));
        return;
      }
      if (_clientResponseRoutes.length >= maximumPendingRoutes) {
        unawaited(
          close(StateError('ACP client response route limit exceeded')),
        );
        return;
      }
      _clientResponseRoutes[id] = route;
      _clientResponseRouteVersions[id] = _newRouteVersion();
    }
    _hubFor(route).add(entry);
  }

  String? _sessionIdFromValue(Object? value) {
    final Map<String, Object?>? object = _codec.asJsonObject(value);
    final Object? sessionId = object?['sessionId'];
    return sessionId is String && sessionId.isNotEmpty ? sessionId : null;
  }

  AcpOutboundHub<Object?> _hubFor(AcpServerRoute route) => switch (route) {
    AcpConnectionRoute() => connectionOutbound,
    AcpSessionRoute(:final sessionId) => ensureSession(sessionId),
  };

  AcpServerRoute? _removePendingRoute(JsonRpcId id) {
    _pendingRouteVersions.remove(id);
    return _pendingRoutes.remove(id);
  }

  /// Closes the state and all owned resources. Repeated calls are harmless.
  Future<void> close([Object? reason]) {
    if (_isClosed) {
      return closed;
    }
    _isClosed = true;
    _closeReason = reason;
    _pendingRoutes.clear();
    _pendingRouteVersions.clear();
    _clientResponseRoutes.clear();
    _clientResponseRouteVersions.clear();
    final Object waiterError =
        reason ?? StateError('ACP server connection closed');
    for (final Completer<Object?> waiter in _responseWaiters.values) {
      waiter.completeError(waiterError);
    }
    _responseWaiters.clear();

    final List<AcpOutboundHub<Object?>> sessionHubs = _sessionHubs.values
        .toList();
    _sessionHubs.clear();
    final StreamSubscription<Object?>? outboundSubscription =
        _outboundSubscription;
    _outboundSubscription = null;
    final Future<void> writeTail = _writeTail;
    unawaited(_finishClose(sessionHubs, outboundSubscription, writeTail));
    return closed;
  }

  Future<void> _finishClose(
    List<AcpOutboundHub<Object?>> sessionHubs,
    StreamSubscription<Object?>? outboundSubscription,
    Future<void> writeTail,
  ) async {
    final List<Future<void>> operations = <Future<void>>[
      _settle(allOutbound.close),
      _settle(connectionOutbound.close),
      for (final AcpOutboundHub<Object?> hub in sessionHubs) _settle(hub.close),
      if (outboundSubscription case final subscription?)
        _settle(subscription.cancel),
      _settle(_inbound.close),
      _settle(() => writeTail),
    ];
    try {
      await Future.wait<void>(operations);
    } finally {
      if (!_closed.isCompleted) {
        _closed.complete();
      }
    }
  }

  @override
  String toString() => 'AcpServerConnectionState($connectionId)';

  Future<void> _settle(FutureOr<void> Function() operation) async {
    try {
      await operation();
    } on Object {
      // Lifecycle completion is guaranteed even when one owned resource fails.
    }
  }
}

final class _InboundRouteChanges {
  final Map<JsonRpcId, AcpServerRoute> pendingToAdd =
      <JsonRpcId, AcpServerRoute>{};
  final Map<JsonRpcId, int> addedPendingVersions = <JsonRpcId, int>{};
  final Map<JsonRpcId, AcpServerRoute> removedClientRoutes =
      <JsonRpcId, AcpServerRoute>{};
  final Map<JsonRpcId, int> removedClientRouteMutations = <JsonRpcId, int>{};
  final Set<String> sessionsToEnsure = <String>{};

  void commit(AcpServerConnectionState state) {
    for (final MapEntry<JsonRpcId, int> entry
        in removedClientRouteMutations.entries) {
      if (!state._clientResponseRoutes.containsKey(entry.key) &&
          state._clientResponseRouteVersions[entry.key] == entry.value) {
        state._clientResponseRouteVersions.remove(entry.key);
      }
    }
  }

  void rollback(AcpServerConnectionState state) {
    if (state._isClosed) {
      return;
    }
    for (final MapEntry<JsonRpcId, int> entry in addedPendingVersions.entries) {
      if (state._pendingRouteVersions[entry.key] == entry.value) {
        state._pendingRoutes.remove(entry.key);
        state._pendingRouteVersions.remove(entry.key);
      }
    }
    for (final MapEntry<JsonRpcId, AcpServerRoute> entry
        in removedClientRoutes.entries) {
      final int? mutation = removedClientRouteMutations[entry.key];
      if (!state._clientResponseRoutes.containsKey(entry.key) &&
          state._clientResponseRouteVersions[entry.key] == mutation) {
        state._clientResponseRoutes[entry.key] = entry.value;
        state._clientResponseRouteVersions[entry.key] = state
            ._newRouteVersion();
      }
    }
  }
}
