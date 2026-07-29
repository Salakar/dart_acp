import 'dart:async';
import 'dart:convert';

import '../common/bounded_json.dart';
import '../json_rpc/cancellation.dart';
import '../json_rpc/codec.dart';
import '../json_rpc/id.dart';
import 'http_adapter.dart';
import 'outbound_hub.dart';
import 'server_connection.dart';
import 'server_limits.dart';
import 'server_registry.dart';
import 'server_sse.dart';

/// Decides whether an HTTP request may reach the ACP routing core.
typedef AcpHttpRequestPolicy = FutureOr<bool> Function(AcpHttpRequest request);

/// Adapter-neutral experimental ACP HTTP/SSE server.
///
/// Adapters translate their platform request into [AcpHttpRequest] and stream
/// the returned [AcpHttpResponse] with backpressure. Connection and session IDs
/// are routing values only; authentication and authorization belong in the
/// host adapter or application.
final class AcpHttpServer {
  /// Creates an HTTP server around [createConnection].
  AcpHttpServer({
    required AcpServerConnectionFactory createConnection,
    AcpServerConnectionRegistry? registry,
    AcpRemoteServerLimits limits = const AcpRemoteServerLimits(),
    JsonRpcCodec codec = const JsonRpcCodec(),
    AcpSsePeriodicTimerFactory? sseTimerFactory,
    AcpHttpRequestPolicy? requestPolicy,
  }) : _createConnection = createConnection,
       _registry = registry ?? AcpServerConnectionRegistry(),
       _limits = limits,
       _codec = codec,
       _sseTimerFactory = sseTimerFactory,
       _requestPolicy = requestPolicy {
    limits.validate();
  }

  static const String _connectionHeader = 'Acp-Connection-Id';
  static const String _sessionHeader = 'Acp-Session-Id';
  static const String _jsonMediaType = 'application/json';
  static const String _sseMediaType = 'text/event-stream';
  static const Set<String> _headerScopedMethods = <String>{
    'session/cancel',
    'session/close',
    'session/load',
    'session/prompt',
    'session/resume',
    'session/set_config_option',
    'session/set_mode',
  };

  final AcpServerConnectionFactory _createConnection;
  final AcpServerConnectionRegistry _registry;
  final AcpRemoteServerLimits _limits;
  final JsonRpcCodec _codec;
  final AcpSsePeriodicTimerFactory? _sseTimerFactory;
  final AcpHttpRequestPolicy? _requestPolicy;
  final Set<Future<void>> _backgroundCleanup = <Future<void>>{};
  Future<void>? _closeFuture;
  bool _isClosed = false;

  /// Number of initialized connections currently registered.
  int get connectionCount => _registry.activeCount;

  /// Whether [close] has begun.
  bool get isClosed => _isClosed;

  /// Limits adapters must enforce while streaming requests.
  AcpRemoteServerLimits get limits => _limits;

  /// Handles one already-bounded platform-neutral HTTP request.
  Future<AcpHttpResponse> handle(AcpHttpRequest request) async {
    if (_isClosed) {
      return _text('ACP server is closed', 503);
    }
    final AcpHttpRequestPolicy? policy = _requestPolicy;
    if (policy != null) {
      final Future<bool> decision = Future<bool>.sync(() => policy(request));
      decision.ignore();
      try {
        final bool allowed = await _raceCancellation(
          decision,
          request.cancellationToken,
        ).timeout(_limits.initializeTimeout);
        if (!allowed) {
          return _text('Forbidden', 403);
        }
      } on _RequestAborted {
        return _text('Request aborted', 499);
      } on Object {
        return _text('Forbidden', 403);
      }
    }
    if (_isClosed) {
      return _text('ACP server is closed', 503);
    }
    return switch (request.method.toUpperCase()) {
      'POST' => _handlePost(request),
      'GET' => _handleGet(request),
      'DELETE' => _handleDelete(request),
      _ => _text('Method Not Allowed', 405),
    };
  }

  Future<AcpHttpResponse> _handlePost(AcpHttpRequest request) async {
    if (!_isJsonContentType(request.headers.value('content-type'))) {
      return _text('Unsupported Media Type', 415);
    }
    final List<int>? bytes = request.body;
    if (bytes == null || bytes.length > _limits.maximumBodyBytes) {
      return bytes == null
          ? _text('Invalid JSON', 400)
          : _text('Payload Too Large', 413);
    }
    if (request.cancellationToken.isCancelled) {
      return _text('Request aborted', 499);
    }

    final Object? decoded;
    try {
      decoded = decodeBoundedJson(
        utf8.decode(bytes),
        maximumNestingDepth: _limits.maximumJsonNestingDepth,
      );
    } on Object {
      return _text('Invalid JSON', 400);
    }
    if (decoded is List<Object?>) {
      return _text('Batch JSON-RPC requests are not implemented', 501);
    }
    final Map<String, Object?>? message = _codec.asJsonObject(decoded);
    if (message == null) {
      return _text('Invalid JSON-RPC message', 400);
    }

    final _HeaderValue connectionHeader = _readRoutingHeader(
      request.headers,
      _connectionHeader,
    );
    if (connectionHeader.isMalformed) {
      return _text('Invalid Acp-Connection-Id', 400);
    }
    if (_isInitialize(message)) {
      if (connectionHeader.value != null) {
        return _text('Initialize not allowed on existing connection', 400);
      }
      return _handleInitialize(message, request.cancellationToken);
    }
    final String? connectionId = connectionHeader.value;
    if (connectionId == null) {
      return _text('Missing Acp-Connection-Id', 400);
    }
    final AcpServerConnectionState? connection = _registry.lookup(connectionId);
    if (connection == null) {
      return _text('Unknown Acp-Connection-Id', 404);
    }
    return _forwardConnected(connection, message, request.headers);
  }

  Future<AcpHttpResponse> _handleInitialize(
    Map<String, Object?> message,
    CancellationToken cancellationToken,
  ) async {
    if (!message.containsKey('id') || message['id'] == null) {
      return _text('Initialize request must include a non-null ID', 400);
    }
    final JsonRpcId id;
    try {
      id = JsonRpcId.fromJson(message['id']);
    } on FormatException {
      return _text('Initialize request has an invalid ID', 400);
    }
    if (cancellationToken.isCancelled) {
      return _text('Request aborted', 499);
    }

    AcpServerConnectionState? connection;
    String? connectionId;
    Future<AcpServerConnectionState>? factoryFuture;
    var isRegistered = false;
    final stopwatch = Stopwatch()..start();
    try {
      if (_isClosed) {
        throw const _ServerClosed();
      }
      connectionId = _registry.reserveConnectionId();
      factoryFuture = Future<AcpServerConnectionState>.sync(
        () => _createConnection(connectionId!),
      );
      final AcpServerConnectionState created = await _waitForInitialize(
        factoryFuture,
        cancellationToken,
        stopwatch,
      );
      connection = created;
      if (created.connectionId != connectionId) {
        throw StateError('Connection factory returned a mismatched ID');
      }
      if (_isClosed) {
        throw const _ServerClosed();
      }
      _registry.addReservedPending(created);
      isRegistered = true;
      final Future<Object?> responseFuture = created.receiveResponse(id);
      responseFuture.ignore();
      final Future<Object?> exchange = () async {
        try {
          await created.writeInbound(message);
        } on Object {
          created.cancelResponseWaiter(id);
          rethrow;
        }
        return responseFuture;
      }();
      exchange.ignore();
      final Object? response = await _waitForInitialize(
        exchange,
        cancellationToken,
        stopwatch,
      );
      if (cancellationToken.isCancelled) {
        throw const _RequestAborted();
      }
      if (_isClosed) {
        throw const _ServerClosed();
      }
      final Map<String, Object?>? responseObject = _codec.asJsonObject(
        response,
      );
      if (responseObject == null ||
          !_codec.isResponse(responseObject) ||
          _codec.tryDecodeId(responseObject['id']) != id) {
        throw StateError('Initialize produced an invalid response');
      }
      _registry.activate(connectionId);
      return _json(
        responseObject,
        200,
      ).withHeader(_connectionHeader, connectionId);
    } on _RequestAborted {
      await _cleanupInitialize(
        connectionId: connectionId,
        connection: connection,
        factoryFuture: factoryFuture,
        isRegistered: isRegistered,
        reason: 'initialize aborted',
      );
      return _text('Request aborted', 499);
    } on CancellationException {
      await _cleanupInitialize(
        connectionId: connectionId,
        connection: connection,
        factoryFuture: factoryFuture,
        isRegistered: isRegistered,
        reason: 'initialize aborted',
      );
      return _text('Request aborted', 499);
    } on _ServerClosed {
      await _cleanupInitialize(
        connectionId: connectionId,
        connection: connection,
        factoryFuture: factoryFuture,
        isRegistered: isRegistered,
        reason: 'server closed',
      );
      return _text('ACP server is closed', 503);
    } on Object {
      await _cleanupInitialize(
        connectionId: connectionId,
        connection: connection,
        factoryFuture: factoryFuture,
        isRegistered: isRegistered,
        reason: 'initialize failed',
      );
      return _json(<String, Object?>{
        'jsonrpc': '2.0',
        'id': id.toJson(),
        'error': <String, Object?>{
          'code': -32603,
          'message': 'Initialize failed',
        },
      }, 500);
    } finally {
      stopwatch.stop();
    }
  }

  Future<void> _cleanupInitialize({
    required String? connectionId,
    required AcpServerConnectionState? connection,
    required Future<AcpServerConnectionState>? factoryFuture,
    required bool isRegistered,
    required Object reason,
  }) async {
    if (connectionId != null) {
      _registry.releaseConnectionId(connectionId);
    }
    if (connection != null) {
      if (isRegistered && connectionId != null) {
        await _registry.discard(connectionId, reason);
      }
      await connection.close(reason);
      return;
    }
    if (factoryFuture != null) {
      unawaited(
        factoryFuture.then<void>(
          (AcpServerConnectionState lateConnection) =>
              lateConnection.close(reason),
          onError: (Object _, StackTrace _) {},
        ),
      );
    }
  }

  Future<T> _waitForInitialize<T>(
    Future<T> operation,
    CancellationToken token,
    Stopwatch stopwatch,
  ) {
    final Duration remaining = _limits.initializeTimeout - stopwatch.elapsed;
    if (remaining <= Duration.zero) {
      return Future<T>.error(TimeoutException('ACP initialize timed out'));
    }
    return _raceCancellation(operation, token).timeout(remaining);
  }

  Future<AcpHttpResponse> _forwardConnected(
    AcpServerConnectionState connection,
    Map<String, Object?> message,
    AcpHttpHeaders headers,
  ) async {
    final _HeaderValue sessionHeader = _readRoutingHeader(
      headers,
      _sessionHeader,
    );
    if (sessionHeader.isMalformed) {
      return _text('Invalid Acp-Session-Id', 400);
    }
    final String? headerSessionId = sessionHeader.value;

    if (_codec.isResponse(message) || _codec.isResponseShaped(message)) {
      final JsonRpcId? id = message.containsKey('id')
          ? _codec.tryDecodeId(message['id'])
          : null;
      final AcpServerRoute? expected = id == null
          ? null
          : connection.expectedClientResponseRoute(id);
      if (expected case AcpSessionRoute(sessionId: final sessionId)) {
        if (headerSessionId == null) {
          return _text('Missing Acp-Session-Id', 400);
        }
        if (headerSessionId != sessionId) {
          return _text('Mismatched Acp-Session-Id', 400);
        }
      }
      final AcpServerRoute route = headerSessionId == null
          ? const AcpConnectionRoute()
          : AcpSessionRoute(headerSessionId);
      return _writeAccepted(connection, message, route);
    }

    final Object? rawMethod = message['method'];
    final String? method = rawMethod is String ? rawMethod : null;
    final String? paramsSessionId = _sessionId(message['params']);
    if (method != null &&
        _headerScopedMethods.contains(method) &&
        headerSessionId == null) {
      return _text('Missing Acp-Session-Id', 400);
    }
    if (headerSessionId != null &&
        paramsSessionId != null &&
        headerSessionId != paramsSessionId) {
      return _text('Mismatched Acp-Session-Id', 400);
    }
    final String? sessionId = headerSessionId ?? paramsSessionId;
    if (sessionId != null) {
      try {
        connection.ensureSession(sessionId);
      } on Object {
        return _text('ACP session route limit exceeded', 429);
      }
    }
    final AcpServerRoute responseRoute =
        method == 'session/load' || sessionId == null
        ? const AcpConnectionRoute()
        : AcpSessionRoute(sessionId);
    return _writeAccepted(
      connection,
      message,
      responseRoute,
      inferSessionRoute: false,
    );
  }

  Future<AcpHttpResponse> _writeAccepted(
    AcpServerConnectionState connection,
    Map<String, Object?> message,
    AcpServerRoute route, {
    bool inferSessionRoute = true,
  }) async {
    try {
      await connection.writeInbound(
        message,
        route: route,
        inferSessionRoute: inferSessionRoute,
      );
      return _empty(202);
    } on AcpServerRouteError {
      return _text('Invalid ACP message route', 400);
    } on Object {
      return _text('ACP connection write failed', 500);
    }
  }

  AcpHttpResponse _handleGet(AcpHttpRequest request) {
    final String? upgrade = request.headers.value('upgrade');
    if (upgrade != null &&
        upgrade
            .split(',')
            .any((String value) => value.trim().toLowerCase() == 'websocket')) {
      return _text('WebSocket upgrade required', 426);
    }
    final String? accept = request.headers.value('accept')?.toLowerCase();
    if (accept == null || !accept.contains(_sseMediaType)) {
      return _text('Not Acceptable', 406);
    }
    final _HeaderValue connectionHeader = _readRoutingHeader(
      request.headers,
      _connectionHeader,
    );
    if (connectionHeader.isMalformed || connectionHeader.value == null) {
      return _text('Missing Acp-Connection-Id', 400);
    }
    final AcpServerConnectionState? connection = _registry.lookup(
      connectionHeader.value!,
    );
    if (connection == null) {
      return _text('Unknown Acp-Connection-Id', 404);
    }
    final _HeaderValue sessionHeader = _readRoutingHeader(
      request.headers,
      _sessionHeader,
    );
    if (sessionHeader.isMalformed) {
      return _text('Invalid Acp-Session-Id', 400);
    }
    final AcpOutboundSubscription<Object?> outbound;
    try {
      outbound = sessionHeader.value == null
          ? connection.connectionOutbound.subscribe()
          : connection.ensureSession(sessionHeader.value!).subscribe();
    } on StateError {
      return _text('ACP session route limit exceeded', 429);
    }
    final Stream<List<int>> body = _sseTimerFactory == null
        ? createAcpServerSseBody(
            outbound,
            keepAliveInterval: _limits.sseKeepAliveInterval,
          )
        : createAcpServerSseBody(
            outbound,
            keepAliveInterval: _limits.sseKeepAliveInterval,
            timerFactory: _sseTimerFactory,
          );
    return AcpHttpResponse(
      statusCode: 200,
      headers: const AcpHttpHeaders()
          .withHeader('Content-Type', _sseMediaType)
          .withHeader('Cache-Control', 'no-cache')
          .withHeader('Connection', 'keep-alive'),
      body: body,
    );
  }

  AcpHttpResponse _handleDelete(AcpHttpRequest request) {
    final _HeaderValue connectionHeader = _readRoutingHeader(
      request.headers,
      _connectionHeader,
    );
    if (connectionHeader.isMalformed || connectionHeader.value == null) {
      return _text('Missing Acp-Connection-Id', 400);
    }
    if (_registry.lookup(connectionHeader.value!) == null) {
      return _text('Unknown Acp-Connection-Id', 404);
    }
    _trackCleanup(
      _registry
          .remove(connectionHeader.value!, 'remote DELETE')
          .then<void>((_) {}),
    );
    return _empty(202);
  }

  void _trackCleanup(Future<void> operation) {
    late final Future<void> tracked;
    tracked = operation
        .catchError((Object _, StackTrace _) {})
        .whenComplete(() => _backgroundCleanup.remove(tracked));
    _backgroundCleanup.add(tracked);
  }

  Future<void> _runClose() async {
    await _registry.closeAll('server closed');
    while (_backgroundCleanup.isNotEmpty) {
      await Future.wait<void>(_backgroundCleanup.toList());
    }
  }

  /// Stops accepting requests and closes active and pending connections.
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

  bool _isInitialize(Map<String, Object?> message) =>
      message['jsonrpc'] == '2.0' && message['method'] == 'initialize';

  String? _sessionId(Object? value) {
    final Map<String, Object?>? object = _codec.asJsonObject(value);
    final Object? sessionId = object?['sessionId'];
    return sessionId is String && sessionId.isNotEmpty ? sessionId : null;
  }

  bool _isJsonContentType(String? value) =>
      value?.split(';').first.trim().toLowerCase() == _jsonMediaType;

  _HeaderValue _readRoutingHeader(AcpHttpHeaders headers, String name) {
    final List<String> values = headers.values(name);
    if (values.isEmpty) {
      return const _HeaderValue(null, false);
    }
    if (values.length != 1 || values.single.trim().isEmpty) {
      return const _HeaderValue(null, true);
    }
    return _HeaderValue(values.single, false);
  }

  Future<T> _raceCancellation<T>(Future<T> operation, CancellationToken token) {
    if (token.isCancelled) {
      return Future<T>.error(const _RequestAborted());
    }
    return Future.any<T>(<Future<T>>[
      operation,
      token.whenCancelled.then<T>((_) => throw const _RequestAborted()),
    ]);
  }

  AcpHttpResponse _json(Object? value, int status) => AcpHttpResponse(
    statusCode: status,
    headers: const AcpHttpHeaders().withHeader('Content-Type', _jsonMediaType),
    body: Stream<List<int>>.value(utf8.encode(jsonEncode(value))),
  );

  AcpHttpResponse _text(String value, int status) => AcpHttpResponse(
    statusCode: status,
    headers: const AcpHttpHeaders().withHeader('Content-Type', 'text/plain'),
    body: Stream<List<int>>.value(utf8.encode(value)),
  );

  AcpHttpResponse _empty(int status) => AcpHttpResponse(
    statusCode: status,
    headers: const AcpHttpHeaders(),
    body: const Stream<List<int>>.empty(),
  );
}

extension on AcpHttpResponse {
  AcpHttpResponse withHeader(String name, String value) => AcpHttpResponse(
    statusCode: statusCode,
    reasonPhrase: reasonPhrase,
    headers: headers.withHeader(name, value),
    body: body,
  );
}

final class _HeaderValue {
  const _HeaderValue(this.value, this.isMalformed);

  final String? value;
  final bool isMalformed;
}

final class _RequestAborted implements Exception {
  const _RequestAborted();
}

final class _ServerClosed implements Exception {
  const _ServerClosed();
}
