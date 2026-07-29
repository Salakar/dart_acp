import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:dart_acp_sdk/experimental/http.dart';

import 'remote_example_support.dart';

/// Runs the stable-v1 example conversation over HTTP/SSE.
Future<String> runHttpExampleClient(
  Uri endpoint, {
  void Function(String event)? trace,
}) async {
  final transport = AcpHttpClientTransport(
    endpoint,
    onDiagnostic: (diagnostic) =>
        trace?.call('client diagnostic: ${diagnostic.message}'),
  );
  final typed = transport.stream;
  final traced = AcpDuplexStream<JsonRpcWireMessage>(
    readable: typed.readable.map((message) {
      trace?.call('client received ${message.runtimeType} ${message.toJson()}');
      return message;
    }),
    writable: typed.writable,
  );
  return runRemoteExamplePrompt(acpApplicationStream(traced));
}

Future<void> main(List<String> arguments) async {
  if (arguments case <String>['--smoke']) {
    return;
  }
  if (arguments.length != 1) {
    throw ArgumentError(
      'Usage: dart run example/http_client.dart http://127.0.0.1:PORT/acp',
    );
  }
  final endpoint = Uri.parse(arguments.single);
  final output = await runHttpExampleClient(endpoint);
  // ignore: avoid_print
  print(output);
}
