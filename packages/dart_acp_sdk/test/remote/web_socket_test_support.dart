import 'dart:async';

import 'package:dart_acp_sdk/experimental/web_socket.dart';

final class FakeWebSocketAdapter implements AcpWebSocketAdapter {
  final List<AcpWebSocketConnectRequest> requests =
      <AcpWebSocketConnectRequest>[];
  final Completer<AcpWebSocketChannel> connection =
      Completer<AcpWebSocketChannel>();
  int closeCount = 0;

  @override
  Future<AcpWebSocketChannel> connect(AcpWebSocketConnectRequest request) {
    requests.add(request);
    return connection.future;
  }

  @override
  Future<void> close() async {
    closeCount += 1;
  }
}

final class FakeWebSocketChannel implements AcpWebSocketChannel {
  FakeWebSocketChannel({
    this.responseHeaders = const AcpHttpHeaders(),
    this.sendGate,
  });

  final StreamController<AcpWebSocketFrame> frameController =
      StreamController<AcpWebSocketFrame>();
  final Completer<void> _closed = Completer<void>();
  final List<String> sent = <String>[];
  final Completer<void>? sendGate;
  int closeCount = 0;
  int? closeCode;
  String? closeReason;

  @override
  final AcpHttpHeaders responseHeaders;

  @override
  Stream<AcpWebSocketFrame> get frames => frameController.stream;

  @override
  Future<void> get closed => _closed.future;

  @override
  Future<void> sendText(String text) async {
    await sendGate?.future;
    sent.add(text);
  }

  @override
  Future<void> close({int? code, String? reason}) async {
    closeCount += 1;
    closeCode ??= code;
    closeReason ??= reason;
    if (!frameController.isClosed) {
      await frameController.close();
    }
    if (!_closed.isCompleted) {
      _closed.complete();
    }
  }

  Future<void> peerClose() async {
    if (!frameController.isClosed) {
      await frameController.close();
    }
    if (!_closed.isCompleted) {
      _closed.complete();
    }
  }
}

Future<void> pumpWebSocketUntil(bool Function() predicate) async {
  for (var attempt = 0; attempt < 100; attempt += 1) {
    if (predicate()) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  throw StateError('Condition was not reached');
}
