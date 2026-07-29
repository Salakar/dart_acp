import 'dart:async';
import 'dart:convert';

import '../common/bounded_json.dart';
import '../json_rpc/batch.dart';
import '../json_rpc/cancellation.dart';
import '../json_rpc/codec.dart';
import '../json_rpc/id.dart';
import '../json_rpc/message.dart';
import '../json_rpc/params.dart';
import '../transport/duplex_stream.dart';
import 'affinity_cookie_store.dart';
import 'http_adapter.dart';
import 'http_adapter_factory.dart';
import 'sse.dart';

/// ACP connection-routing header.
const String acpConnectionIdHeader = 'Acp-Connection-Id';

/// ACP session-routing header.
const String acpSessionIdHeader = 'Acp-Session-Id';

/// JSON media type used by ACP HTTP requests.
const String acpJsonMediaType = 'application/json';

/// SSE media type used by ACP inbound streams.
const String acpSseMediaType = 'text/event-stream';

/// Bounded resource settings for [AcpHttpClientTransport].
final class AcpHttpClientLimits {
  /// Creates validated limits.
  const AcpHttpClientLimits({
    this.maximumBodyBytes = 16 * 1024 * 1024,
    this.maximumSseLineBytes = 16 * 1024 * 1024,
    this.maximumSseEventBytes = 16 * 1024 * 1024,
    this.maximumPendingSessionRequests = 1024,
    this.maximumJsonNestingDepth = 128,
  });

  /// Maximum non-streaming response body bytes.
  final int maximumBodyBytes;

  /// Maximum bytes in one SSE line.
  final int maximumSseLineBytes;

  /// Maximum combined bytes in one SSE event.
  final int maximumSseEventBytes;

  /// Maximum session-routed requests awaiting responses.
  final int maximumPendingSessionRequests;

  /// Maximum structural object/array nesting in inbound JSON.
  final int maximumJsonNestingDepth;

  /// Validates every limit even when Dart assertions are disabled.
  void validate() {
    for (final (name, value) in <(String, int)>[
      ('maximumBodyBytes', maximumBodyBytes),
      ('maximumSseLineBytes', maximumSseLineBytes),
      ('maximumSseEventBytes', maximumSseEventBytes),
      ('maximumPendingSessionRequests', maximumPendingSessionRequests),
      ('maximumJsonNestingDepth', maximumJsonNestingDepth),
    ]) {
      if (value <= 0) {
        throw ArgumentError.value(value, name, 'must be positive');
      }
    }
  }
}

/// Safe failure from the experimental HTTP/SSE transport.
final class AcpHttpTransportException implements Exception {
  /// Creates a transport exception.
  const AcpHttpTransportException(this.message, {this.statusCode});

  /// Redacted failure description.
  final String message;

  /// HTTP status when the failure came from a response.
  final int? statusCode;

  @override
  String toString() {
    final status = statusCode;
    return status == null
        ? 'AcpHttpTransportException: $message'
        : 'AcpHttpTransportException($status): $message';
  }
}

/// Experimental ACP client transport over POST plus SSE.
///
/// The first write must be an individual `initialize` request. Stable HTTP
/// transport deliberately rejects JSON-RPC batches. Connection SSE EOF is
/// fatal; an idle session SSE may be reopened by a later session-scoped write.
/// The transport never reconnects or replays messages automatically.
final class AcpHttpClientTransport {
  /// Creates a lazy transport for [endpoint].
  ///
  /// Supplying [adapter] or [cookieStore] keeps ownership with the caller.
  AcpHttpClientTransport(
    this.endpoint, {
    AcpHttpAdapter? adapter,
    AcpHttpHeaders headers = const AcpHttpHeaders(),
    AcpHttpCookiePolicy cookiePolicy = AcpHttpCookiePolicy.include,
    AcpAffinityCookieStore? cookieStore,
    AcpHttpClientLimits limits = const AcpHttpClientLimits(),
    JsonRpcCodec codec = const JsonRpcCodec(),
    AcpRemoteDiagnosticHandler? onDiagnostic,
  }) : _adapter = adapter ?? createPlatformHttpAdapter(),
       _ownsAdapter = adapter == null,
       _headers = headers,
       _cookiePolicy = cookiePolicy,
       _cookieStore = cookieStore ?? AcpAffinityCookieStore(),
       _ownsCookieStore = cookieStore == null,
       _limits = limits,
       _codec = codec,
       _onDiagnostic = onDiagnostic {
    if (endpoint.scheme != 'http' && endpoint.scheme != 'https') {
      throw ArgumentError.value(endpoint, 'endpoint', 'must use http or https');
    }
    limits.validate();
    // The controller is an owned field and is closed by [close] or [_fail].
    // ignore: close_sinks
    late final StreamController<JsonRpcWireMessage> incoming;
    incoming = StreamController<JsonRpcWireMessage>(onCancel: _cancelReadable);
    _incoming = incoming;
    stream = AcpDuplexStream<JsonRpcWireMessage>(
      readable: incoming.stream,
      writable: AcpWritable<JsonRpcWireMessage>(
        write: _enqueueWrite,
        close: close,
      ),
    );
  }

  /// Remote ACP endpoint.
  final Uri endpoint;

  /// Duplex JSON-RPC transport consumed by the connection layer.
  late final AcpDuplexStream<JsonRpcWireMessage> stream;

  final AcpHttpAdapter _adapter;
  final bool _ownsAdapter;
  final AcpHttpHeaders _headers;
  final AcpHttpCookiePolicy _cookiePolicy;
  final AcpAffinityCookieStore _cookieStore;
  final bool _ownsCookieStore;
  final AcpHttpClientLimits _limits;
  final JsonRpcCodec _codec;
  final AcpRemoteDiagnosticHandler? _onDiagnostic;
  final CancellationSource _abort = CancellationSource();
  final Map<String, Future<void>> _sessionSse = <String, Future<void>>{};
  final Map<JsonRpcId, String> _pendingSessionRequests = <JsonRpcId, String>{};
  final Map<JsonRpcId, String> _pendingResponseSessions = <JsonRpcId, String>{};
  final Completer<void> _done = Completer<void>();
  late final StreamController<JsonRpcWireMessage> _incoming;
  Future<void> _writeTail = Future<void>.value();
  Future<void>? _closeFuture;
  String? _connectionId;
  bool _closed = false;

  /// Current server-issued routing identifier after initialization.
  String? get connectionId => _connectionId;

  /// Whether the transport has stopped.
  bool get isClosed => _closed;

  /// Completes after all local resources have been released.
  Future<void> get done => _done.future;

  Future<void>? _cancelReadable() => _closed ? null : close();

  Future<void> _enqueueWrite(JsonRpcWireMessage message) {
    final operation = _writeTail.then((_) => _writeMessage(message));
    _writeTail = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return operation;
  }

  Future<void> _writeMessage(JsonRpcWireMessage message) async {
    if (_closed) {
      throw StateError('ACP HTTP transport is closed');
    }
    if (message is JsonRpcBatch) {
      throw UnsupportedError(
        'ACP HTTP transport does not support JSON-RPC batches',
      );
    }
    if (_connectionId == null) {
      await _initialize(message);
    } else {
      await _postConnected(message as JsonRpcMessage);
    }
  }

  Future<void> _initialize(JsonRpcWireMessage wireMessage) async {
    if (wireMessage is! JsonRpcRequest || wireMessage.method != 'initialize') {
      throw StateError('First ACP HTTP message must be initialize');
    }
    String? cleanupConnectionId;
    try {
      final response = await _request(
        method: 'POST',
        headers: const AcpHttpHeaders().withHeader(
          'Content-Type',
          acpJsonMediaType,
        ),
        body: _encode(wireMessage),
        cancellationToken: _abort.token,
      );
      _requireSuccess(response, 'Initialize request failed');
      cleanupConnectionId = response.headers.value(acpConnectionIdHeader);
      if (cleanupConnectionId == null || cleanupConnectionId.isEmpty) {
        throw const AcpHttpTransportException(
          'Initialize response is missing Acp-Connection-Id',
        );
      }
      _requireMediaType(response, acpJsonMediaType, 'initialize');
      final decoded = _codec.decodeMessage(
        await _decodeJsonBody(response.body),
      );
      if (decoded is! JsonRpcResponse || decoded.id != wireMessage.id) {
        throw const AcpHttpTransportException(
          'Initialize response is not the matching JSON-RPC response',
        );
      }
      if (_closed) {
        throw StateError('ACP HTTP transport is closed');
      }
      _connectionId = cleanupConnectionId;
      unawaited(_consumeSse());
      _emit(decoded);
    } catch (error, stackTrace) {
      if (cleanupConnectionId != null && _connectionId == null) {
        await _delete(cleanupConnectionId).catchError((Object _) {});
      }
      _fail(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _postConnected(JsonRpcMessage message) async {
    final connectionId = _connectionId;
    if (connectionId == null) {
      throw StateError('ACP HTTP transport is not initialized');
    }
    final sessionId = _sessionIdForOutbound(message);
    if (sessionId != null) {
      await _ensureSessionSse(sessionId);
    }

    if (message is JsonRpcRequest && sessionId != null) {
      if (_pendingSessionRequests.length >=
          _limits.maximumPendingSessionRequests) {
        throw const AcpHttpTransportException(
          'Too many pending session requests',
        );
      }
      _pendingSessionRequests[message.id] = sessionId;
    }

    try {
      var headers = const AcpHttpHeaders()
          .withHeader('Content-Type', acpJsonMediaType)
          .withHeader(acpConnectionIdHeader, connectionId);
      if (sessionId != null) {
        headers = headers.withHeader(acpSessionIdHeader, sessionId);
      }
      final response = await _request(
        method: 'POST',
        headers: headers,
        body: _encode(message),
        cancellationToken: _abort.token,
      );
      _requireSuccess(response, 'Connected POST failed');
      await _drainBounded(response.body);
      if (message is JsonRpcResponse) {
        _pendingResponseSessions.remove(message.id);
      }
    } catch (error, stackTrace) {
      if (message is JsonRpcRequest) {
        _pendingSessionRequests.remove(message.id);
      }
      _fail(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _consumeSse({String? sessionId, Completer<void>? ready}) async {
    try {
      final connectionId = _connectionId;
      if (connectionId == null) {
        throw StateError('ACP HTTP transport is not initialized');
      }
      var headers = const AcpHttpHeaders()
          .withHeader('Accept', acpSseMediaType)
          .withHeader(acpConnectionIdHeader, connectionId);
      if (sessionId != null) {
        headers = headers.withHeader(acpSessionIdHeader, sessionId);
      }
      final response = await _request(
        method: 'GET',
        headers: headers,
        cancellationToken: _abort.token,
      );
      _requireSuccess(response, 'SSE request failed');
      _requireMediaType(response, acpSseMediaType, 'SSE');
      if (ready != null && !ready.isCompleted) {
        ready.complete();
      }
      await for (final raw in decodeSseJson(
        response.body,
        limits: AcpSseLimits(
          maximumLineBytes: _limits.maximumSseLineBytes,
          maximumEventBytes: _limits.maximumSseEventBytes,
          maximumJsonNestingDepth: _limits.maximumJsonNestingDepth,
        ),
        onDiagnostic: _onDiagnostic,
      )) {
        if (_closed) {
          return;
        }
        if (raw is List<Object?>) {
          throw const AcpHttpTransportException(
            'ACP HTTP transport received a JSON-RPC batch',
          );
        }
        final JsonRpcMessage message;
        try {
          message = _codec.decodeMessage(raw);
        } on FormatException {
          _diagnose('Skipping invalid SSE JSON-RPC payload');
          continue;
        }
        _trackInbound(message, sessionId);
        _emit(message);
      }
      if (_closed) {
        return;
      }
      if (sessionId == null) {
        throw const AcpHttpTransportException('Connection SSE stream closed');
      }
      unawaited(_sessionSse.remove(sessionId));
      if (_pendingSessionRequests.containsValue(sessionId)) {
        throw const AcpHttpTransportException(
          'Session SSE stream closed with a pending request',
        );
      }
    } catch (error, stackTrace) {
      if (ready != null && !ready.isCompleted) {
        ready.completeError(error, stackTrace);
      }
      if (!_closed) {
        _fail(error, stackTrace);
      }
    }
  }

  Future<void> _ensureSessionSse(String sessionId) {
    final existing = _sessionSse[sessionId];
    if (existing != null) {
      return existing;
    }
    final ready = Completer<void>();
    final future = ready.future;
    future.ignore();
    _sessionSse[sessionId] = future;
    unawaited(_consumeSse(sessionId: sessionId, ready: ready));
    return future;
  }

  void _trackInbound(JsonRpcMessage message, String? streamSessionId) {
    if (message is JsonRpcRequest && streamSessionId != null) {
      _pendingResponseSessions[message.id] = streamSessionId;
    }
    if (message is JsonRpcResponse) {
      _pendingSessionRequests.remove(message.id);
      if (message is JsonRpcSuccessResponse) {
        final sessionId = _sessionIdFromValue(message.result);
        if (sessionId != null) {
          unawaited(_ensureSessionSse(sessionId));
        }
      }
    }
  }

  String? _sessionIdForOutbound(JsonRpcMessage message) {
    if (message is JsonRpcRequest) {
      return _sessionIdFromParams(message.params);
    }
    if (message is JsonRpcNotification) {
      return _sessionIdFromParams(message.params);
    }
    if (message is JsonRpcResponse) {
      return _pendingResponseSessions[message.id];
    }
    return null;
  }

  String? _sessionIdFromParams(JsonRpcParams params) =>
      params.isPresent ? _sessionIdFromValue(params.value) : null;

  String? _sessionIdFromValue(Object? value) {
    if (value is! Map<Object?, Object?>) {
      return null;
    }
    final sessionId = value['sessionId'];
    return sessionId is String && sessionId.isNotEmpty ? sessionId : null;
  }

  Future<AcpHttpResponse> _request({
    required String method,
    required AcpHttpHeaders headers,
    required CancellationToken cancellationToken,
    List<int>? body,
  }) async {
    var merged = _headers.overlay(headers);
    if (_cookiePolicy == AcpHttpCookiePolicy.include) {
      final cookie = _cookieStore.cookieHeader(
        endpoint,
        callerCookieHeader: merged.value('cookie'),
      );
      if (cookie != null) {
        merged = merged.withHeader('Cookie', cookie);
      }
    }
    final response = await _adapter.send(
      AcpHttpRequest(
        uri: endpoint,
        method: method,
        headers: merged,
        body: body,
        cookiePolicy: _cookiePolicy,
        cancellationToken: cancellationToken,
      ),
    );
    if (_cookiePolicy == AcpHttpCookiePolicy.include) {
      _cookieStore.store(endpoint, response.headers.values('set-cookie'));
    }
    return response;
  }

  void _diagnose(String message) {
    try {
      _onDiagnostic?.call(AcpRemoteDiagnostic(message));
    } on Object {
      // Diagnostics are observational and must not alter transport lifecycle.
    }
  }

  List<int> _encode(JsonRpcWireMessage message) =>
      utf8.encode(jsonEncode(message.toJson()));

  Future<Object?> _decodeJsonBody(Stream<List<int>> body) async {
    final bytes = await _collectBounded(body);
    try {
      return decodeBoundedJson(
        utf8.decode(bytes),
        maximumNestingDepth: _limits.maximumJsonNestingDepth,
      );
    } on FormatException {
      throw const AcpHttpTransportException('Response body is not valid JSON');
    }
  }

  Future<List<int>> _collectBounded(Stream<List<int>> body) async {
    final bytes = <int>[];
    await for (final chunk in body) {
      if (bytes.length + chunk.length > _limits.maximumBodyBytes) {
        throw const AcpHttpTransportException(
          'HTTP response body exceeds configured limit',
        );
      }
      bytes.addAll(chunk);
    }
    return bytes;
  }

  Future<void> _drainBounded(Stream<List<int>> body) async {
    await _collectBounded(body);
  }

  void _requireSuccess(AcpHttpResponse response, String operation) {
    if (!response.isSuccessful) {
      throw AcpHttpTransportException(
        operation,
        statusCode: response.statusCode,
      );
    }
  }

  void _requireMediaType(
    AcpHttpResponse response,
    String expected,
    String operation,
  ) {
    final value = response.headers.value('content-type');
    if (value == null ||
        value.split(';').first.trim().toLowerCase() != expected) {
      throw AcpHttpTransportException(
        '$operation response has an unexpected media type',
        statusCode: response.statusCode,
      );
    }
  }

  void _emit(JsonRpcWireMessage message) {
    if (!_closed && !_incoming.isClosed) {
      _incoming.add(message);
    }
  }

  void _fail(Object error, StackTrace stackTrace) {
    if (_closed) {
      return;
    }
    _closed = true;
    _abort.cancel(error);
    if (!_incoming.isClosed) {
      _incoming.addError(error, stackTrace);
    }
    _closeFuture ??= _cleanupAfterFailure(_connectionId);
    unawaited(_closeFuture);
  }

  Future<void> _cleanupAfterFailure(String? connectionId) async {
    if (connectionId != null) {
      await _delete(connectionId).catchError((Object _) {});
    }
    if (_ownsCookieStore) {
      _cookieStore.clear();
    }
    if (_ownsAdapter) {
      await _adapter.close();
    }
    await _closeIncoming();
    if (!_done.isCompleted) {
      _done.complete();
    }
  }

  Future<void> _closeIncoming() async {
    if (_incoming.isClosed) {
      return;
    }
    final hadListener = _incoming.hasListener;
    final closed = _incoming.close();
    if (hadListener) {
      await closed;
    }
  }

  Future<void> _delete(String connectionId) async {
    final cancellation = CancellationSource();
    final response = await _request(
      method: 'DELETE',
      headers: const AcpHttpHeaders().withHeader(
        acpConnectionIdHeader,
        connectionId,
      ),
      cancellationToken: cancellation.token,
    );
    _requireSuccess(response, 'DELETE failed');
    await _drainBounded(response.body);
  }

  /// Stops local streams, sends a best-effort DELETE, and releases resources.
  ///
  /// A DELETE failure is rethrown after local cleanup. Calls are idempotent.
  Future<void> close() => _closeFuture ??= _close();

  Future<void> _close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    _abort.cancel('transport closed');
    Object? deleteError;
    StackTrace? deleteStackTrace;
    try {
      final connectionId = _connectionId;
      if (connectionId != null) {
        await _delete(connectionId);
      }
    } catch (error, stackTrace) {
      deleteError = error;
      deleteStackTrace = stackTrace;
    } finally {
      if (_ownsCookieStore) {
        _cookieStore.clear();
      }
      if (_ownsAdapter) {
        await _adapter.close();
      }
      await _closeIncoming();
      if (!_done.isCompleted) {
        _done.complete();
      }
    }
    if (deleteError != null) {
      Error.throwWithStackTrace(deleteError, deleteStackTrace!);
    }
  }
}
