import 'dart:async';
import 'dart:io';

const String _readyPrefix = 'ACP_BROWSER_WEBSOCKET_ECHO_READY ';

Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 47321);
  stdout.writeln('${_readyPrefix}ws://127.0.0.1:${server.port}/echo');
  await stdout.flush();

  final serving = _serve(server);
  try {
    await Future.any<void>(<Future<void>>[serving, stdin.drain<void>()]);
  } finally {
    await server.close(force: true);
  }
  await serving;
}

Future<void> _serve(HttpServer server) async {
  await for (final request in server) {
    if (!WebSocketTransformer.isUpgradeRequest(request)) {
      request.response.statusCode = HttpStatus.upgradeRequired;
      await request.response.close();
      continue;
    }
    final socket = await WebSocketTransformer.upgrade(
      request,
      protocolSelector: (protocols) => protocols.contains('acp') ? 'acp' : null,
    );
    socket.listen(
      (message) {
        if (message == 'send-binary') {
          socket.add(const <int>[1, 2, 3]);
        } else {
          socket.add(message);
        }
      },
      onError: (Object _) {
        unawaited(socket.close());
      },
      onDone: () {
        unawaited(socket.close());
      },
    );
  }
}
