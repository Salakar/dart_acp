import 'dart:async';
import 'dart:io';

import 'http_adapter.dart';
import 'web_socket_adapter.dart';

/// Creates the `dart:io` WebSocket adapter.
AcpWebSocketAdapter createPlatformWebSocketAdapter() => _IoWebSocketAdapter();

final class _IoWebSocketAdapter implements AcpWebSocketAdapter {
  final HttpClient _client = HttpClient();
  final Set<_IoWebSocketChannel> _channels = <_IoWebSocketChannel>{};
  bool _closed = false;

  @override
  Future<AcpWebSocketChannel> connect(
    AcpWebSocketConnectRequest request,
  ) async {
    if (_closed) {
      throw StateError('WebSocket adapter is closed');
    }
    final headers = <String, Object>{};
    request.headers.forEach((name, value) {
      final existing = headers[name];
      if (existing == null) {
        headers[name] = value;
      } else if (existing is List<String>) {
        existing.add(value);
      } else {
        headers[name] = <String>[existing as String, value];
      }
    });
    // Ownership transfers to the returned channel, which closes the socket.
    // ignore: close_sinks
    final socket = await WebSocket.connect(
      request.uri.toString(),
      protocols: request.protocols,
      headers: headers,
      customClient: _client,
    );
    if (_closed) {
      await socket.close();
      throw StateError('WebSocket adapter is closed');
    }
    final channel = _IoWebSocketChannel(socket);
    _channels.add(channel);
    unawaited(channel.closed.whenComplete(() => _channels.remove(channel)));
    return channel;
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    _client.close(force: true);
    await Future.wait<void>(_channels.map((channel) => channel.close()));
    _channels.clear();
  }
}

final class _IoWebSocketChannel implements AcpWebSocketChannel {
  _IoWebSocketChannel(this._socket);

  final WebSocket _socket;

  @override
  AcpHttpHeaders get responseHeaders => const AcpHttpHeaders();

  @override
  Stream<AcpWebSocketFrame> get frames => _socket.map((event) {
    if (event is String) {
      return AcpWebSocketTextFrame(event);
    }
    if (event is List<int>) {
      return AcpWebSocketBinaryFrame(event);
    }
    return AcpWebSocketBinaryFrame(const <int>[]);
  });

  @override
  Future<void> get closed => _socket.done.then<void>((_) {});

  @override
  Future<void> sendText(String text) async {
    if (_socket.readyState != WebSocket.open) {
      throw StateError('WebSocket is not open');
    }
    _socket.add(text);
  }

  @override
  Future<void> close({int? code, String? reason}) =>
      _socket.close(code, reason);
}
