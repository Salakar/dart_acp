import 'dart:async';
import 'dart:convert';

import '../common/bounded_json.dart';
import '../json_rpc/codec.dart';
import '../json_rpc/id.dart';
import 'http_adapter.dart';
import 'outbound_hub.dart';
import 'server_connection.dart';
import 'server_limits.dart';
import 'server_registry.dart';
import 'web_socket_adapter.dart';

/// Context passed to a WebSocket origin/authentication preflight.
final class AcpWebSocketUpgradeContext {
  /// Creates an immutable upgrade context.
  const AcpWebSocketUpgradeContext({
    required this.uri,
    this.headers = const AcpHttpHeaders(),
  });

  /// Requested endpoint.
  final Uri uri;

  /// Sanitized upgrade request headers.
  final AcpHttpHeaders headers;
}

/// Decides whether a WebSocket upgrade may create an ACP connection.
typedef AcpWebSocketUpgradePolicy =
    FutureOr<bool> Function(AcpWebSocketUpgradeContext context);

/// Safe rejection from an ACP WebSocket preflight.
final class AcpWebSocketUpgradeRejected implements Exception {
  /// Creates a rejection with a non-sensitive [message].
  const AcpWebSocketUpgradeRejected([
    this.message = 'WebSocket upgrade rejected',
  ]);

  /// Redacted explanation suitable for a local diagnostic.
  final String message;

  @override
  String toString() => 'AcpWebSocketUpgradeRejected: $message';
}

/// A connection reserved before an HTTP adapter accepts its upgrade.
final class AcpPreparedWebSocketUpgrade {
  AcpPreparedWebSocketUpgrade._({
    required this.connectionId,
    required AcpServerConnectionState connection,
    required AcpWebSocketServer owner,
    required Duration timeout,
  }) : _connection = connection,
       _owner = owner {
    _expiryTimer = Timer(timeout, _expire);
  }

  /// Opaque routing identifier to attach to the 101 response.
  final String connectionId;

  final AcpServerConnectionState _connection;
  final AcpWebSocketServer _owner;
  late final Timer _expiryTimer;
  bool _settled = false;

  /// Attaches the accepted [channel] and starts protocol initialization.
  AcpWebSocketServerSession accept(AcpWebSocketChannel channel) {
    if (_settled) {
      _owner._trackCleanup(_owner._closeRejectedChannel(channel));
      throw StateError('ACP WebSocket upgrade has already been settled');
    }
    _settled = true;
    _expiryTimer.cancel();
    _owner._prepared.remove(this);
    return _owner._accept(channel, _connection);
  }

  /// Releases a reserved connection after the HTTP upgrade is rejected.
  Future<void> reject() async {
    if (_settled) {
      return;
    }
    _settled = true;
    _expiryTimer.cancel();
    _owner._prepared.remove(this);
    await _owner._registry.discard(connectionId, 'upgrade rejected');
  }

  void _expire() {
    if (_settled) {
      return;
    }
    _settled = true;
    _owner._prepared.remove(this);
    _owner._trackCleanup(
      _owner._registry.discard(connectionId, 'upgrade preparation timed out'),
    );
  }
}

/// Adapter-neutral experimental ACP WebSocket server.
final class AcpWebSocketServer {
  /// Creates a WebSocket server around [createConnection].
  AcpWebSocketServer({
    required AcpServerConnectionFactory createConnection,
    AcpServerConnectionRegistry? registry,
    AcpRemoteServerLimits limits = const AcpRemoteServerLimits(),
    JsonRpcCodec codec = const JsonRpcCodec(),
    AcpWebSocketUpgradePolicy? upgradePolicy,
  }) : _createConnection = createConnection,
       _registry = registry ?? AcpServerConnectionRegistry(),
       _limits = limits,
       _codec = codec,
       _upgradePolicy = upgradePolicy {
    limits.validate();
  }

  final AcpServerConnectionFactory _createConnection;
  final AcpServerConnectionRegistry _registry;
  final AcpRemoteServerLimits _limits;
  final JsonRpcCodec _codec;
  final AcpWebSocketUpgradePolicy? _upgradePolicy;
  final Set<AcpWebSocketServerSession> _sessions =
      <AcpWebSocketServerSession>{};
  final Set<AcpPreparedWebSocketUpgrade> _prepared =
      <AcpPreparedWebSocketUpgrade>{};
  final Set<Future<void>> _backgroundCleanup = <Future<void>>{};
  Future<void>? _closeFuture;
  bool _isClosed = false;

  /// Number of accepted sockets that have not closed.
  int get socketCount => _sessions.length;

  /// Runs policy and reserves one pending connection.
  Future<AcpPreparedWebSocketUpgrade> prepare(
    AcpWebSocketUpgradeContext context,
  ) async {
    if (_isClosed) {
      throw StateError('ACP WebSocket server is closed');
    }
    final stopwatch = Stopwatch()..start();
    final AcpWebSocketUpgradePolicy? policy = _upgradePolicy;
    if (policy != null) {
      bool allowed;
      try {
        allowed = await Future<bool>.sync(
          () => policy(context),
        ).timeout(_remaining(stopwatch));
      } on Object {
        throw const AcpWebSocketUpgradeRejected();
      }
      if (!allowed) {
        throw const AcpWebSocketUpgradeRejected();
      }
    }

    if (_isClosed) {
      throw StateError('ACP WebSocket server is closed');
    }
    final String connectionId = _registry.reserveConnectionId();
    final Future<AcpServerConnectionState> factoryFuture =
        Future<AcpServerConnectionState>.sync(
          () => _createConnection(connectionId),
        );
    AcpServerConnectionState? connection;
    try {
      connection = await factoryFuture.timeout(_remaining(stopwatch));
    } on Object {
      _registry.releaseConnectionId(connectionId);
      unawaited(
        factoryFuture.then<void>(
          (AcpServerConnectionState lateConnection) =>
              lateConnection.close('upgrade preparation failed'),
          onError: (Object _, StackTrace _) {},
        ),
      );
      rethrow;
    }
    if (connection.connectionId != connectionId) {
      _registry.releaseConnectionId(connectionId);
      await connection.close('mismatched connection ID');
      throw StateError('Connection factory returned a mismatched ID');
    }
    if (_isClosed) {
      _registry.releaseConnectionId(connectionId);
      await connection.close('server closed');
      throw StateError('ACP WebSocket server is closed');
    }
    try {
      _registry.addReservedPending(connection);
    } on Object {
      _registry.releaseConnectionId(connectionId);
      await connection.close('upgrade preparation failed');
      rethrow;
    }
    final prepared = AcpPreparedWebSocketUpgrade._(
      connectionId: connectionId,
      connection: connection,
      owner: this,
      timeout: _limits.initializeTimeout,
    );
    _prepared.add(prepared);
    return prepared;
  }

  Duration _remaining(Stopwatch stopwatch) {
    final Duration remaining = _limits.initializeTimeout - stopwatch.elapsed;
    if (remaining <= Duration.zero) {
      throw TimeoutException('ACP WebSocket preparation timed out');
    }
    return remaining;
  }

  AcpWebSocketServerSession _accept(
    AcpWebSocketChannel channel,
    AcpServerConnectionState connection,
  ) {
    if (_isClosed || connection.isClosed) {
      _trackCleanup(_rejectAcceptedChannel(channel, connection));
      throw StateError('Cannot accept a closed ACP WebSocket connection');
    }
    final session = AcpWebSocketServerSession._(
      channel: channel,
      connection: connection,
      registry: _registry,
      limits: _limits,
      codec: _codec,
    );
    _sessions.add(session);
    unawaited(session.closed.whenComplete(() => _sessions.remove(session)));
    session._start();
    return session;
  }

  Future<void> _rejectAcceptedChannel(
    AcpWebSocketChannel channel,
    AcpServerConnectionState connection,
  ) async {
    await _registry.discard(connection.connectionId, 'server closed');
    await connection.close('server closed');
    await _closeRejectedChannel(channel);
  }

  Future<void> _closeRejectedChannel(AcpWebSocketChannel channel) async {
    try {
      await channel.close(code: 1001, reason: 'Server shutting down');
    } on Object {
      // The adapter may already have observed peer closure.
    }
  }

  void _trackCleanup(Future<void> operation) {
    late final Future<void> tracked;
    tracked = operation
        .catchError((Object _, StackTrace _) {})
        .whenComplete(() => _backgroundCleanup.remove(tracked));
    _backgroundCleanup.add(tracked);
  }

  /// Closes sockets with code 1001 and releases every connection.
  Future<void> close() {
    final Future<void>? existing = _closeFuture;
    if (existing != null) {
      return existing;
    }
    _isClosed = true;
    final completer = Completer<void>();
    _closeFuture = completer.future;
    unawaited(
      Future<void>.sync(_runClose).then<void>(
        (_) => completer.complete(),
        onError: (Object error, StackTrace stackTrace) =>
            completer.completeError(error, stackTrace),
      ),
    );
    return completer.future;
  }

  Future<void> _runClose() async {
    final List<AcpPreparedWebSocketUpgrade> prepared = _prepared.toList();
    final List<AcpWebSocketServerSession> sessions = _sessions.toList();
    await Future.wait<void>(<Future<void>>[
      for (final AcpPreparedWebSocketUpgrade upgrade in prepared)
        _settle(upgrade.reject),
      for (final AcpWebSocketServerSession session in sessions)
        _settle(
          () => session.close(code: 1001, reason: 'Server shutting down'),
        ),
    ]);
    _prepared.clear();
    _sessions.clear();
    await _registry.closeAll('server closed');
    while (_backgroundCleanup.isNotEmpty) {
      await Future.wait<void>(_backgroundCleanup.toList());
    }
  }

  Future<void> _settle(FutureOr<void> Function() operation) async {
    try {
      await operation();
    } on Object {
      // One failed socket must not prevent the remaining server cleanup.
    }
  }
}

/// Lifecycle handle for one accepted ACP WebSocket.
final class AcpWebSocketServerSession {
  AcpWebSocketServerSession._({
    required AcpWebSocketChannel channel,
    required AcpServerConnectionState connection,
    required AcpServerConnectionRegistry registry,
    required AcpRemoteServerLimits limits,
    required JsonRpcCodec codec,
  }) : _channel = channel,
       _connection = connection,
       _registry = registry,
       _limits = limits,
       _codec = codec;

  final AcpWebSocketChannel _channel;
  final AcpServerConnectionState _connection;
  final AcpServerConnectionRegistry _registry;
  final AcpRemoteServerLimits _limits;
  final JsonRpcCodec _codec;
  final Completer<void> _closed = Completer<void>();
  StreamIterator<AcpWebSocketFrame>? _inboundIterator;
  StreamIterator<Object?>? _outboundIterator;
  Future<void> _sendTail = Future<void>.value();
  Timer? _initializeTimer;
  bool _initialized = false;
  bool _batchesEnabled = false;
  bool _isClosed = false;

  /// Completes after the socket, subscriptions, and connection are released.
  Future<void> get closed => _closed.future;

  /// Whether initialization completed.
  bool get isInitialized => _initialized;

  void _start() {
    _initializeTimer = Timer(
      _limits.initializeTimeout,
      () => unawaited(_shutdown(code: 1008, reason: 'Initialize timed out')),
    );
    final iterator = StreamIterator<AcpWebSocketFrame>(_channel.frames);
    _inboundIterator = iterator;
    unawaited(_pumpInbound(iterator));
    unawaited(
      _channel.closed.then<void>(
        (_) => _shutdown(closeSocket: false),
        onError: (Object _, StackTrace _) =>
            _shutdown(closeSocket: false, reason: 'WebSocket error'),
      ),
    );
  }

  Future<void> _pumpInbound(StreamIterator<AcpWebSocketFrame> iterator) async {
    try {
      while (!_isClosed && await iterator.moveNext()) {
        await _handleFrame(iterator.current);
      }
      if (!_isClosed) {
        await _shutdown(closeSocket: false);
      }
    } on Object {
      if (!_isClosed) {
        await _shutdown(code: 1011, reason: 'Message handling failed');
      }
    } finally {
      if (identical(_inboundIterator, iterator)) {
        _inboundIterator = null;
      }
      await _settle(iterator.cancel);
    }
  }

  Future<void> _handleFrame(AcpWebSocketFrame frame) async {
    if (_isClosed) {
      return;
    }
    if (frame.length > _limits.maximumWebSocketFrameBytes) {
      await _shutdown(code: 1009, reason: 'Frame too large');
      return;
    }
    if (frame is AcpWebSocketBinaryFrame) {
      await _shutdown(code: 1003, reason: 'Binary frames are unsupported');
      return;
    }
    final Object? decoded;
    try {
      decoded = decodeBoundedJson(
        (frame as AcpWebSocketTextFrame).text,
        maximumNestingDepth: _limits.maximumJsonNestingDepth,
      );
    } on FormatException {
      if (!_initialized) {
        await _shutdown(code: 1007, reason: 'Malformed JSON');
      }
      return;
    }
    if (decoded is! Map<Object?, Object?> && decoded is! List<Object?>) {
      if (!_initialized) {
        await _shutdown(code: 1002, reason: 'Invalid JSON-RPC message');
      }
      return;
    }
    if (!_initialized) {
      await _initialize(decoded);
      return;
    }
    await _forward(decoded);
  }

  Future<void> _initialize(Object? decoded) async {
    _initializeTimer?.cancel();
    _initializeTimer = null;
    var batched = false;
    Object? value = decoded;
    if (decoded is List<Object?>) {
      if (decoded.length != 1) {
        await _shutdown(code: 1002, reason: 'First message must initialize');
        return;
      }
      batched = true;
      value = decoded.single;
    }
    final Map<String, Object?>? message = _codec.asJsonObject(value);
    if (message == null ||
        !_codec.isRequest(message) ||
        message['method'] != 'initialize' ||
        message['id'] == null) {
      await _shutdown(code: 1002, reason: 'First message must initialize');
      return;
    }
    final JsonRpcId id = JsonRpcId.fromJson(message['id']);
    try {
      final Future<Object?> responseFuture = _connection.receiveResponse(id);
      responseFuture.ignore();
      try {
        await _connection.writeInbound(message);
      } on Object {
        _connection.cancelResponseWaiter(id);
        rethrow;
      }
      final Object? response = await responseFuture.timeout(
        _limits.initializeTimeout,
      );
      final Map<String, Object?>? responseObject = _codec.asJsonObject(
        response,
      );
      if (responseObject == null ||
          !_codec.isResponse(responseObject) ||
          _codec.tryDecodeId(responseObject['id']) != id) {
        throw StateError('Initialize produced an invalid response');
      }
      if (_protocolVersion(responseObject) == 2) {
        _batchesEnabled = true;
        _connection.enableBatches();
      }
      _registry.activate(_connection.connectionId);
      _initialized = true;
      await _send(batched ? <Object?>[responseObject] : responseObject);
      await _startOutbound();
    } on Object {
      final error = <String, Object?>{
        'jsonrpc': '2.0',
        'id': id.toJson(),
        'error': <String, Object?>{
          'code': -32603,
          'message': 'Initialize failed',
        },
      };
      try {
        await _send(batched ? <Object?>[error] : error);
      } on Object {
        // The 1011 close below remains the observable failure.
      }
      await _shutdown(code: 1011, reason: 'Initialize failed');
    }
  }

  Future<void> _forward(Object? decoded) async {
    if (decoded is List<Object?>) {
      if (!_batchesEnabled) {
        await _shutdown(code: 1002, reason: 'Batches require ACP v2');
        return;
      }
      if (decoded.isEmpty) {
        await _send(_invalidRequest(null, 'Empty batch'));
        return;
      }
      if (decoded.any(_isInitializeRequest)) {
        await _shutdown(code: 1002, reason: 'Initialize already completed');
        return;
      }
      try {
        await _connection.writeInbound(
          decoded,
          validateClientResponseRoute: false,
        );
      } on Object {
        await _shutdown(code: 1011, reason: 'Message handling failed');
      }
      return;
    }

    final Map<String, Object?>? message = _codec.asJsonObject(decoded);
    if (message == null) {
      return;
    }
    if (_isInitializeRequest(message)) {
      await _send(
        _invalidRequest(message['id'], 'Initialize already completed'),
      );
      return;
    }
    try {
      await _connection.writeInbound(
        message,
        validateClientResponseRoute: false,
      );
    } on Object {
      await _shutdown(code: 1011, reason: 'Message handling failed');
    }
  }

  Future<void> _startOutbound() async {
    final AcpOutboundSubscription<Object?> outbound = _connection.allOutbound
        .subscribe();
    for (final Object? value in outbound.replay) {
      await _send(value);
    }
    final iterator = StreamIterator<Object?>(outbound.live);
    _outboundIterator = iterator;
    unawaited(_pumpOutbound(iterator));
  }

  Future<void> _pumpOutbound(StreamIterator<Object?> iterator) async {
    try {
      while (!_isClosed && await iterator.moveNext()) {
        await _send(iterator.current);
      }
      if (!_isClosed) {
        await _shutdown();
      }
    } on Object {
      if (!_isClosed) {
        await _shutdown(code: 1011, reason: 'Outbound stream failed');
      }
    } finally {
      if (identical(_outboundIterator, iterator)) {
        _outboundIterator = null;
      }
      await iterator.cancel();
    }
  }

  Future<void> _send(Object? value) {
    if (_isClosed) {
      return Future<void>.error(StateError('ACP WebSocket session is closed'));
    }
    final String text = jsonEncode(value);
    if (utf8.encode(text).length > _limits.maximumWebSocketFrameBytes) {
      return Future<void>.error(StateError('Outbound frame is too large'));
    }
    final operation = _sendTail.then((_) {
      if (_isClosed) {
        throw StateError('ACP WebSocket session is closed');
      }
      return _channel.sendText(text);
    });
    _sendTail = operation.catchError((Object _, StackTrace _) {});
    return operation;
  }

  bool _isInitializeRequest(Object? value) {
    final Map<String, Object?>? message = _codec.asJsonObject(value);
    return message != null &&
        _codec.isRequest(message) &&
        message['method'] == 'initialize';
  }

  int? _protocolVersion(Map<String, Object?> response) {
    final Map<String, Object?>? result = _codec.asJsonObject(
      response['result'],
    );
    final Object? version = result?['protocolVersion'];
    return version is num && version.isFinite && version == version.truncate()
        ? version.toInt()
        : null;
  }

  Map<String, Object?> _invalidRequest(Object? id, String message) =>
      <String, Object?>{
        'jsonrpc': '2.0',
        'id': id,
        'error': <String, Object?>{'code': -32600, 'message': message},
      };

  /// Closes this socket. Server-initiated shutdown defaults to code 1001.
  Future<void> close({
    int code = 1001,
    String reason = 'Server shutting down',
  }) => _shutdown(code: code, reason: reason);

  Future<void> _shutdown({int? code, String? reason, bool closeSocket = true}) {
    if (_isClosed) {
      return closed;
    }
    _isClosed = true;
    unawaited(
      _runShutdown(code: code, reason: reason, closeSocket: closeSocket),
    );
    return closed;
  }

  Future<void> _runShutdown({
    required int? code,
    required String? reason,
    required bool closeSocket,
  }) async {
    _initializeTimer?.cancel();
    _initializeTimer = null;
    try {
      await Future.wait<void>(<Future<void>>[
        if (_inboundIterator case final iterator?) _settle(iterator.cancel),
        if (_outboundIterator case final iterator?) _settle(iterator.cancel),
        _settle(() => _registry.discard(_connection.connectionId, reason)),
        if (closeSocket)
          _settle(() => _channel.close(code: code, reason: reason)),
      ]);
      await _settle(() => _sendTail);
    } finally {
      if (!_closed.isCompleted) {
        _closed.complete();
      }
    }
  }

  Future<void> _settle(FutureOr<void> Function() operation) async {
    try {
      await operation();
    } on Object {
      // Local lifecycle cleanup continues after any single resource failure.
    }
  }
}
