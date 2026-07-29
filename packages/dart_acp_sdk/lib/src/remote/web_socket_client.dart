import 'dart:async';
import 'dart:convert';

import '../common/bounded_json.dart';
import '../json_rpc/codec.dart';
import '../json_rpc/message.dart';
import '../transport/duplex_stream.dart';
import 'affinity_cookie_store.dart';
import 'http_adapter.dart';
import 'sse.dart';
import 'web_socket_adapter.dart';
import 'web_socket_adapter_factory.dart';

/// Safe failure from the experimental WebSocket transport.
final class AcpWebSocketTransportException implements Exception {
  /// Creates a transport exception.
  const AcpWebSocketTransportException(this.message);

  /// Redacted failure description.
  final String message;

  @override
  String toString() => 'AcpWebSocketTransportException: $message';
}

/// Experimental ACP client transport over WebSocket text frames.
///
/// Writes queue behind the platform connection future, so callers can write
/// immediately after construction. Individual messages and JSON-RPC batches
/// retain one-frame framing. Binary, malformed, primitive, and oversized
/// input is never dispatched. The transport does not reconnect automatically.
final class AcpWebSocketClientTransport {
  /// Starts connecting to [endpoint].
  ///
  /// Native adapters support custom [headers] and caller-managed affinity
  /// cookies. Browser adapters use the browser cookie jar and reject custom
  /// handshake headers. [originValidator] is an application policy hook, not
  /// a replacement for server-side origin validation.
  AcpWebSocketClientTransport(
    this.endpoint, {
    AcpWebSocketAdapter? adapter,
    List<String> protocols = const <String>[],
    AcpHttpHeaders headers = const AcpHttpHeaders(),
    AcpHttpCookiePolicy cookiePolicy = AcpHttpCookiePolicy.include,
    AcpAffinityCookieStore? cookieStore,
    int maximumFrameBytes = 16 * 1024 * 1024,
    int maximumJsonNestingDepth = 128,
    JsonRpcCodec codec = const JsonRpcCodec(),
    bool Function(Uri endpoint)? originValidator,
    AcpRemoteDiagnosticHandler? onDiagnostic,
  }) : _adapter = adapter ?? createPlatformWebSocketAdapter(),
       _ownsAdapter = adapter == null,
       _protocols = List<String>.unmodifiable(protocols),
       _headers = headers,
       _cookiePolicy = cookiePolicy,
       _cookieStore = cookieStore ?? AcpAffinityCookieStore(),
       _ownsCookieStore = cookieStore == null,
       _maximumFrameBytes = maximumFrameBytes,
       _maximumJsonNestingDepth = maximumJsonNestingDepth,
       _codec = codec,
       _onDiagnostic = onDiagnostic {
    if (endpoint.scheme != 'ws' && endpoint.scheme != 'wss') {
      throw ArgumentError.value(endpoint, 'endpoint', 'must use ws or wss');
    }
    if (maximumFrameBytes <= 0) {
      throw RangeError.value(
        maximumFrameBytes,
        'maximumFrameBytes',
        'must be positive',
      );
    }
    if (maximumJsonNestingDepth <= 0) {
      throw RangeError.value(
        maximumJsonNestingDepth,
        'maximumJsonNestingDepth',
        'must be positive',
      );
    }
    if (originValidator != null && !originValidator(endpoint)) {
      throw ArgumentError.value(
        endpoint,
        'endpoint',
        'rejected by origin policy',
      );
    }
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
    _channelFuture = _connect();
    _channelFuture.ignore();
  }

  /// Remote WebSocket endpoint.
  final Uri endpoint;

  /// Duplex JSON-RPC transport consumed by the connection layer.
  late final AcpDuplexStream<JsonRpcWireMessage> stream;

  final AcpWebSocketAdapter _adapter;
  final bool _ownsAdapter;
  final List<String> _protocols;
  final AcpHttpHeaders _headers;
  final AcpHttpCookiePolicy _cookiePolicy;
  final AcpAffinityCookieStore _cookieStore;
  final bool _ownsCookieStore;
  final int _maximumFrameBytes;
  final int _maximumJsonNestingDepth;
  final JsonRpcCodec _codec;
  final AcpRemoteDiagnosticHandler? _onDiagnostic;
  final Completer<void> _done = Completer<void>();
  final Completer<void> _stopped = Completer<void>();
  late final StreamController<JsonRpcWireMessage> _incoming;
  late final Future<AcpWebSocketChannel> _channelFuture;
  AcpWebSocketChannel? _channel;
  StreamSubscription<AcpWebSocketFrame>? _subscription;
  Future<void> _writeTail = Future<void>.value();
  Future<void>? _closeFuture;
  bool _closed = false;

  /// Whether this transport has stopped.
  bool get isClosed => _closed;

  /// Completes when the channel and owned adapter are released.
  Future<void> get done => _done.future;

  Future<void>? _cancelReadable() => _closed ? null : close();

  Future<AcpWebSocketChannel> _connect() async {
    try {
      var headers = _headers;
      if (_cookiePolicy == AcpHttpCookiePolicy.include) {
        final cookie = _cookieStore.cookieHeader(
          endpoint,
          callerCookieHeader: headers.value('cookie'),
        );
        if (cookie != null) {
          headers = headers.withHeader('Cookie', cookie);
        }
      }
      final channel = await _adapter.connect(
        AcpWebSocketConnectRequest(
          uri: endpoint,
          protocols: _protocols,
          headers: headers,
        ),
      );
      if (_cookiePolicy == AcpHttpCookiePolicy.include) {
        _cookieStore.store(
          endpoint,
          channel.responseHeaders.values('set-cookie'),
        );
      }
      if (_closed) {
        await channel.close();
        throw StateError('ACP WebSocket transport is closed');
      }
      _channel = channel;
      _subscription = channel.frames.listen(
        _handleFrame,
        onError: (Object error, StackTrace stackTrace) {
          _fail(error, stackTrace);
        },
        onDone: () {
          if (!_closed) {
            _finish();
          }
        },
      );
      unawaited(
        channel.closed.catchError((Object error, StackTrace stackTrace) {
          _fail(error, stackTrace);
        }),
      );
      return channel;
    } catch (error, stackTrace) {
      _fail(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _enqueueWrite(JsonRpcWireMessage message) {
    final operation = _writeTail.then((_) => _send(message));
    _writeTail = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return operation;
  }

  Future<void> _send(JsonRpcWireMessage message) async {
    if (_closed) {
      throw StateError('ACP WebSocket transport is closed');
    }
    final text = jsonEncode(message.toJson());
    final byteLength = utf8.encode(text).length;
    if (byteLength > _maximumFrameBytes) {
      throw AcpWebSocketTransportException(
        'Outgoing frame exceeds $_maximumFrameBytes bytes',
      );
    }
    final channel = await Future.any<AcpWebSocketChannel?>(
      <Future<AcpWebSocketChannel?>>[
        _channelFuture,
        _stopped.future.then<AcpWebSocketChannel?>((_) => null),
      ],
    );
    if (_closed || channel == null) {
      throw StateError('ACP WebSocket transport is closed');
    }
    await channel.sendText(text);
  }

  void _handleFrame(AcpWebSocketFrame frame) {
    if (_closed) {
      return;
    }
    if (frame is AcpWebSocketBinaryFrame) {
      _fail(
        const AcpWebSocketTransportException('Binary frames are unsupported'),
        StackTrace.current,
        closeCode: 1003,
        closeReason: 'Binary frames are unsupported',
      );
      return;
    }
    final text = (frame as AcpWebSocketTextFrame).text;
    if (utf8.encode(text).length > _maximumFrameBytes) {
      _fail(
        const AcpWebSocketTransportException('Frame exceeds configured limit'),
        StackTrace.current,
        closeCode: 1009,
        closeReason: 'Frame exceeds configured limit',
      );
      return;
    }
    final Object? decoded;
    try {
      decoded = decodeBoundedJson(
        text,
        maximumNestingDepth: _maximumJsonNestingDepth,
      );
    } on FormatException {
      _diagnose('Skipping malformed WebSocket JSON frame');
      return;
    }
    if (decoded is! Map<Object?, Object?> && decoded is! List<Object?>) {
      _diagnose('Skipping primitive WebSocket JSON frame');
      return;
    }
    try {
      _incoming.add(_codec.decodeWireMessage(decoded));
    } on FormatException {
      _diagnose('Skipping invalid WebSocket JSON-RPC frame');
    }
  }

  void _diagnose(String message) {
    try {
      _onDiagnostic?.call(AcpRemoteDiagnostic(message));
    } on Object {
      // Diagnostics are observational and must not alter transport lifecycle.
    }
  }

  void _finish() {
    if (_closed) {
      return;
    }
    _closed = true;
    if (!_stopped.isCompleted) {
      _stopped.complete();
    }
    _closeFuture ??= _cleanupAfterStop(closeChannel: false);
    unawaited(_closeFuture);
  }

  void _fail(
    Object error,
    StackTrace stackTrace, {
    int? closeCode,
    String? closeReason,
  }) {
    if (_closed) {
      return;
    }
    _closed = true;
    if (!_stopped.isCompleted) {
      _stopped.complete();
    }
    if (!_incoming.isClosed) {
      _incoming.addError(error, stackTrace);
    }
    _closeFuture ??= _cleanupAfterStop(
      closeChannel: true,
      closeCode: closeCode,
      closeReason: closeReason,
    );
    unawaited(_closeFuture);
  }

  Future<void> _cleanupAfterStop({
    required bool closeChannel,
    int? closeCode,
    String? closeReason,
  }) async {
    await _subscription?.cancel();
    if (closeChannel) {
      try {
        await _channel?.close(code: closeCode, reason: closeReason);
      } catch (_) {
        // The original transport failure remains the reported error.
      }
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

  /// Closes the socket and local resources without reconnecting.
  Future<void> close() => _closeFuture ??= _close();

  Future<void> _close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    if (!_stopped.isCompleted) {
      _stopped.complete();
    }
    try {
      await _channel?.close(code: 1000, reason: 'Client closing');
    } catch (_) {
      // Local cleanup remains deterministic when connect/close fails.
    } finally {
      await _subscription?.cancel();
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
  }
}
