import 'dart:async';
import 'dart:js_interop';

import 'http_adapter.dart';
import 'web_socket_adapter.dart';

/// Creates the browser WebSocket adapter.
AcpWebSocketAdapter createPlatformWebSocketAdapter() => _WebWebSocketAdapter();

final class _WebWebSocketAdapter implements AcpWebSocketAdapter {
  final Set<_WebWebSocketChannel> _channels = <_WebWebSocketChannel>{};
  bool _closed = false;

  @override
  Future<AcpWebSocketChannel> connect(
    AcpWebSocketConnectRequest request,
  ) async {
    if (_closed) {
      throw StateError('WebSocket adapter is closed');
    }
    if (!request.headers.isEmpty) {
      throw UnsupportedError(
        'Browser WebSocket does not support custom handshake headers or '
        'caller-managed Cookie headers.',
      );
    }
    final protocols = request.protocols
        .map((value) => value.toJS)
        .toList()
        .toJS;
    final url = request.uri.toString().toJS;
    final socket = request.protocols.isEmpty
        ? _JsWebSocket(url)
        : _JsWebSocket(url, protocols);
    final channel = _WebWebSocketChannel(socket);
    _channels.add(channel);
    try {
      await channel.opened;
    } catch (_) {
      _channels.remove(channel);
      rethrow;
    }
    unawaited(channel.closed.whenComplete(() => _channels.remove(channel)));
    return channel;
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    await Future.wait<void>(_channels.map((channel) => channel.close()));
    _channels.clear();
  }
}

final class _WebWebSocketChannel implements AcpWebSocketChannel {
  _WebWebSocketChannel(this._socket) {
    _socket.onopen = ((JSAny? _) {
      if (!_opened.isCompleted) {
        _opened.complete();
      }
    }).toJS;
    _socket.onmessage = ((JSAny? rawEvent) {
      if (_frames.isClosed || rawEvent == null) {
        return;
      }
      final event = _JsMessageEvent(rawEvent as JSObject);
      final data = event.data;
      if (data != null && data.isA<JSString>()) {
        _frames.add(AcpWebSocketTextFrame((data as JSString).toDart));
      } else {
        _frames.add(AcpWebSocketBinaryFrame(const <int>[]));
      }
    }).toJS;
    _socket.onerror = ((JSAny? _) {
      final error = StateError('Browser WebSocket failed');
      if (!_opened.isCompleted) {
        _opened.completeError(error);
      }
      if (!_frames.isClosed) {
        _frames.addError(error);
      }
    }).toJS;
    _socket.onclose = ((JSAny? _) {
      if (!_opened.isCompleted) {
        _opened.completeError(
          StateError('Browser WebSocket closed before opening'),
        );
      }
      if (!_frames.isClosed) {
        unawaited(_frames.close());
      }
      if (!_closed.isCompleted) {
        _closed.complete();
      }
    }).toJS;
  }

  final _JsWebSocket _socket;
  final Completer<void> _opened = Completer<void>();
  final Completer<void> _closed = Completer<void>();
  final StreamController<AcpWebSocketFrame> _frames =
      StreamController<AcpWebSocketFrame>();

  Future<void> get opened => _opened.future;

  @override
  AcpHttpHeaders get responseHeaders => const AcpHttpHeaders();

  @override
  Stream<AcpWebSocketFrame> get frames => _frames.stream;

  @override
  Future<void> get closed => _closed.future;

  @override
  Future<void> sendText(String text) async {
    if (_socket.readyState.toDartInt != 1) {
      throw StateError('WebSocket is not open');
    }
    _socket.send(text.toJS);
  }

  @override
  Future<void> close({int? code, String? reason}) async {
    if (_closed.isCompleted) {
      return;
    }
    if (code == null) {
      _socket.close();
    } else {
      _socket.close(code.toJS, reason?.toJS);
    }
    await _closed.future;
  }
}

@JS('WebSocket')
extension type _JsWebSocket._(JSObject _) implements JSObject {
  external factory _JsWebSocket(JSString url, [JSArray<JSString>? protocols]);

  external JSNumber get readyState;

  external set onopen(JSFunction? listener);

  external set onmessage(JSFunction? listener);

  external set onerror(JSFunction? listener);

  external set onclose(JSFunction? listener);

  external void send(JSString data);

  external void close([JSNumber? code, JSString? reason]);
}

@JS()
extension type _JsMessageEvent(JSObject _) implements JSObject {
  external JSAny? get data;
}
