import 'package:dart_acp_sdk/experimental/web_socket.dart';

import 'remote_example_support.dart';

/// Runs the stable-v1 example conversation over WebSocket.
Future<String> runWebSocketExampleClient(Uri endpoint) async {
  final transport = AcpWebSocketClientTransport(
    endpoint,
    originValidator: (uri) =>
        uri.host == '127.0.0.1' || uri.host == '::1' || uri.host == 'localhost',
  );
  return runRemoteExamplePrompt(acpApplicationStream(transport.stream));
}

Future<void> main(List<String> arguments) async {
  if (arguments case <String>['--smoke']) {
    return;
  }
  if (arguments.length != 1) {
    throw ArgumentError(
      'Usage: dart run example/web_socket_client.dart '
      'ws://127.0.0.1:PORT/acp',
    );
  }
  final endpoint = Uri.parse(arguments.single);
  final output = await runWebSocketExampleClient(endpoint);
  // ignore: avoid_print
  print(output);
}
