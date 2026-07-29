import 'dart:async';
import 'dart:io';

import '../json_rpc/cancellation.dart';
import 'http_adapter.dart';
import 'http_server.dart';
import 'http_server_adapter.dart';
import 'web_socket_adapter.dart';
import 'web_socket_server.dart';

/// Creates the `dart:io` ACP HTTP/WebSocket server adapter.
AcpHttpServerAdapter createPlatformAcpHttpServerAdapter() =>
    const _IoHttpServerAdapter();

final class _IoHttpServerAdapter implements AcpHttpServerAdapter {
  const _IoHttpServerAdapter();

  @override
  bool get isSupported => true;

  @override
  Future<AcpHttpServerBinding> serve(
    AcpHttpServer server, {
    String host = '127.0.0.1',
    int port = 0,
    String path = '/acp',
    bool shared = false,
    AcpWebSocketServer? webSocketServer,
  }) async {
    if (!path.startsWith('/') || path.contains('\r') || path.contains('\n')) {
      throw ArgumentError.value(path, 'path', 'must be an absolute safe path');
    }
    final HttpServer listener = await HttpServer.bind(
      host,
      port,
      shared: shared,
    );
    final binding = _IoHttpServerBinding(
      listener: listener,
      server: server,
      webSocketServer: webSocketServer,
      path: path,
    );
    binding.start();
    return binding;
  }
}

final class _IoHttpServerBinding implements AcpHttpServerBinding {
  _IoHttpServerBinding({
    required HttpServer listener,
    required AcpHttpServer server,
    required AcpWebSocketServer? webSocketServer,
    required String path,
  }) : _listener = listener,
       _server = server,
       _webSocketServer = webSocketServer,
       _path = path,
       endpoint = Uri(
         scheme: 'http',
         host: listener.address.address,
         port: listener.port,
         path: path,
       );

  final HttpServer _listener;
  final AcpHttpServer _server;
  final AcpWebSocketServer? _webSocketServer;
  final String _path;
  final Set<Future<void>> _inFlight = <Future<void>>{};
  StreamSubscription<HttpRequest>? _subscription;
  Future<void>? _closeFuture;
  bool _isClosed = false;

  @override
  final Uri endpoint;

  @override
  bool get isClosed => _isClosed;

  void start() {
    // The binding owns and cancels this listener subscription in close().
    // ignore: cancel_subscriptions
    final subscription = _listener.listen(
      (HttpRequest request) {
        late final Future<void> operation;
        operation = _handleSafely(
          request,
        ).whenComplete(() => _inFlight.remove(operation));
        _inFlight.add(operation);
      },
      onError: (Object _, StackTrace _) {
        unawaited(close());
      },
      onDone: () {
        unawaited(close());
      },
      cancelOnError: false,
    );
    _subscription = subscription;
  }

  Future<void> _handleSafely(HttpRequest request) async {
    try {
      await _handle(request);
    } on Object {
      try {
        await _writeText(request.response, 500, 'Internal Server Error');
      } on Object {
        try {
          await request.response.close();
        } on Object {
          // The peer or an upgraded socket already owns the response.
        }
      }
    }
  }

  Future<void> _handle(HttpRequest request) async {
    if (_isClosed) {
      await _writeText(request.response, 503, 'ACP server is closed');
      return;
    }
    if (request.uri.path != _path) {
      await _writeText(request.response, 404, 'Not Found');
      return;
    }
    final AcpHttpHeaders headers;
    try {
      headers = _headers(request.headers);
    } on ArgumentError {
      await _writeText(request.response, 400, 'Invalid request headers');
      return;
    }

    if (_webSocketServer != null &&
        WebSocketTransformer.isUpgradeRequest(request)) {
      await _upgradeWebSocket(request, headers);
      return;
    }

    final List<int>? body = await _readBody(request);
    if (body == null) {
      return;
    }
    final cancellation = CancellationSource();
    unawaited(
      request.response.done.catchError((Object error, StackTrace stackTrace) {
        cancellation.cancel('client disconnected');
      }),
    );
    final AcpHttpResponse response = await _server.handle(
      AcpHttpRequest(
        uri: request.uri,
        method: request.method,
        headers: headers,
        body: body,
        cancellationToken: cancellation.token,
      ),
    );
    await _writeResponse(request.response, response, cancellation);
  }

  Future<List<int>?> _readBody(HttpRequest request) async {
    final int maximum = _server.limits.maximumBodyBytes;
    final List<String> lengths =
        request.headers[HttpHeaders.contentLengthHeader] ?? const <String>[];
    final String? transferEncoding = request.headers.value(
      HttpHeaders.transferEncodingHeader,
    );
    if (lengths.length > 1 ||
        (lengths.isNotEmpty &&
            (int.tryParse(lengths.single) == null ||
                int.parse(lengths.single) < 0)) ||
        (lengths.isNotEmpty && transferEncoding != null)) {
      await _writeText(request.response, 400, 'Invalid request length');
      return null;
    }
    if (request.contentLength > maximum) {
      await _writeText(request.response, 413, 'Payload Too Large');
      return null;
    }

    final chunks = <int>[];
    final iterator = StreamIterator<List<int>>(request);
    try {
      while (await iterator.moveNext()) {
        final List<int> chunk = iterator.current;
        if (chunks.length + chunk.length > maximum) {
          await iterator.cancel();
          await _writeText(request.response, 413, 'Payload Too Large');
          return null;
        }
        chunks.addAll(chunk);
      }
      return chunks;
    } on Object {
      await _writeText(request.response, 400, 'Invalid request body');
      return null;
    } finally {
      await iterator.cancel();
    }
  }

  Future<void> _upgradeWebSocket(
    HttpRequest request,
    AcpHttpHeaders headers,
  ) async {
    AcpPreparedWebSocketUpgrade? prepared;
    WebSocket? socket;
    try {
      prepared = await _webSocketServer!.prepare(
        AcpWebSocketUpgradeContext(uri: request.uri, headers: headers),
      );
      request.response.headers.set(
        'Acp-Connection-Id',
        prepared.connectionId,
        preserveHeaderCase: true,
      );
      // Ownership transfers to the accepted server session.
      // ignore: close_sinks
      socket = await WebSocketTransformer.upgrade(request);
      prepared.accept(_IoServerWebSocket(socket));
    } on AcpWebSocketUpgradeRejected {
      await prepared?.reject();
      await _writeText(request.response, 403, 'Forbidden');
    } on Object {
      await prepared?.reject();
      if (socket != null) {
        try {
          await socket.close(1011, 'WebSocket upgrade failed');
        } on Object {
          // The upgraded peer may already be gone.
        }
        return;
      }
      try {
        await _writeText(request.response, 500, 'WebSocket upgrade failed');
      } on Object {
        // The socket may already own the upgraded response.
      }
    }
  }

  AcpHttpHeaders _headers(HttpHeaders source) {
    var result = const AcpHttpHeaders();
    source.forEach((String name, List<String> values) {
      for (final String value in values) {
        result = result.withAddedHeader(name, value);
      }
    });
    return result;
  }

  Future<void> _writeResponse(
    HttpResponse target,
    AcpHttpResponse source,
    CancellationSource cancellation,
  ) async {
    try {
      target.statusCode = source.statusCode;
      source.headers.forEach((String name, String value) {
        target.headers.add(name, value, preserveHeaderCase: true);
      });
      final contentType = source.headers.value('content-type');
      if (contentType != null &&
          contentType.split(';').first.trim().toLowerCase() ==
              'text/event-stream') {
        target.bufferOutput = false;
        // A valid comment prelude commits headers immediately. An empty flush
        // alone may remain buffered until the first periodic keepalive, which
        // deadlocks clients that open a session stream before sending work.
        target.add(const <int>[0x3a, 0x0a, 0x0a]);
        await target.flush();
      }
      await target.addStream(source.body);
      await target.close();
    } on Object {
      cancellation.cancel('client disconnected');
      try {
        await target.close();
      } on Object {
        // The peer has already disconnected.
      }
    }
  }

  Future<void> _writeText(
    HttpResponse response,
    int status,
    String text,
  ) async {
    response.statusCode = status;
    response.headers.contentType = ContentType.text;
    response.write(text);
    await response.close();
  }

  @override
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
    await _settle(() async {
      await _subscription?.cancel();
    });
    await _settle(() => _listener.close(force: true));
    final List<Future<void>> servers = <Future<void>>[
      if (_webSocketServer case final server?) _settle(server.close),
      _settle(_server.close),
    ];
    while (_inFlight.isNotEmpty) {
      await Future.wait<void>(_inFlight.toList());
    }
    await Future.wait<void>(servers);
  }

  Future<void> _settle(FutureOr<void> Function() operation) async {
    try {
      await operation();
    } on Object {
      // Binding shutdown drains every remaining resource independently.
    }
  }
}

final class _IoServerWebSocket implements AcpWebSocketChannel {
  _IoServerWebSocket(this._socket);

  final WebSocket _socket;

  @override
  Future<void> get closed => _socket.done.then<void>((_) {});

  @override
  Stream<AcpWebSocketFrame> get frames => _socket.map((Object? value) {
    if (value is String) {
      return AcpWebSocketTextFrame(value);
    }
    return AcpWebSocketBinaryFrame(value is List<int> ? value : const <int>[]);
  });

  @override
  AcpHttpHeaders get responseHeaders => const AcpHttpHeaders();

  @override
  Future<void> sendText(String text) async {
    if (_socket.readyState != WebSocket.open) {
      throw StateError('WebSocket is not open');
    }
    await _socket.addStream(Stream<Object>.value(text));
  }

  @override
  Future<void> close({int? code, String? reason}) =>
      _socket.close(code, reason);
}
