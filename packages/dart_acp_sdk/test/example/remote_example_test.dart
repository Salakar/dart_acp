@TestOn('vm')
library;

import 'package:test/test.dart';

import '../../example/http_client.dart' as http_client;
import '../../example/http_server.dart';
import '../../example/web_socket_client.dart' as web_socket_client;

void main() {
  test(
    'HTTP/SSE example completes a real loopback prompt turn',
    () async {
      final trace = <String>[];
      final clock = Stopwatch()..start();
      void record(String event) =>
          trace.add('${clock.elapsedMilliseconds}ms $event');
      final server = await startRemoteExampleServer(trace: record);
      addTearDown(server.close);

      late final String httpOutput;
      try {
        httpOutput = await http_client.runHttpExampleClient(
          server.httpEndpoint,
          trace: record,
        );
      } on Object catch (error) {
        fail('$error; trace: ${trace.join(', ')}');
      }

      expect(httpOutput, 'end_turn: Hello over a remote ACP transport.');
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'WebSocket example completes a real loopback prompt turn',
    () async {
      final server = await startRemoteExampleServer();
      addTearDown(server.close);

      final webSocketOutput = await web_socket_client.runWebSocketExampleClient(
        server.webSocketEndpoint,
      );

      expect(webSocketOutput, 'end_turn: Hello over a remote ACP transport.');
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test('server rejects accidental non-loopback binding before I/O', () async {
    await expectLater(
      startRemoteExampleServer(host: '0.0.0.0'),
      throwsArgumentError,
    );
  });
}
