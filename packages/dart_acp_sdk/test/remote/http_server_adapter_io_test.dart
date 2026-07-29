@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_sdk/src/remote/http_server_adapter.dart';
import 'package:dart_acp_sdk/src/remote/http_server_adapter_factory.dart';
import 'package:dart_acp_sdk/src/remote/web_socket_server.dart';
import 'package:test/test.dart';

import 'http_server_test_support.dart';

void main() {
  late HttpServerHarness harness;
  late AcpHttpServerBinding binding;
  late HttpClient client;

  setUp(() async {
    harness = HttpServerHarness();
    client = HttpClient();
    binding = await createPlatformAcpHttpServerAdapter().serve(harness.server);
  });

  tearDown(() async {
    client.close(force: true);
    await binding.close();
    await harness.close();
  });

  test(
    'native adapter serves initialize and connected POST requests',
    () async {
      final initialize = await client.postUrl(binding.endpoint);
      initialize.headers.contentType = ContentType.json;
      initialize.write(jsonEncode(initializeMessage(1)));
      final initialized = await initialize.close();
      final connectionId = initialized.headers.value('Acp-Connection-Id');

      expect(initialized.statusCode, 200);
      expect(connectionId, isNotEmpty);
      expect(await utf8.decoder.bind(initialized).join(), contains('"id":1'));

      final connected = await client.postUrl(binding.endpoint);
      connected.headers
        ..contentType = ContentType.json
        ..set('Acp-Connection-Id', connectionId!);
      connected.write(jsonEncode(notification('_native')));
      final accepted = await connected.close();

      expect(accepted.statusCode, 202);
      expect(harness.inbound.last, notification('_native'));
    },
  );

  test('native adapter rejects a wrong path and conflicting lengths', () async {
    final wrongPath = await client.getUrl(
      binding.endpoint.replace(path: '/wrong'),
    );
    expect((await wrongPath.close()).statusCode, 404);

    final raw = await Socket.connect(
      binding.endpoint.host,
      binding.endpoint.port,
    );
    raw.write(
      'POST ${binding.endpoint.path} HTTP/1.1\r\n'
      'Host: localhost\r\n'
      'Connection: close\r\n'
      'Content-Type: application/json\r\n'
      'Content-Length: 2\r\n'
      'Transfer-Encoding: chunked\r\n'
      '\r\n'
      '0\r\n\r\n',
    );
    final response = await utf8.decoder.bind(raw).join();
    expect(response, anyOf(contains('400'), contains('Bad Request')));
    await raw.close();
  });

  test('native adapter upgrades and runs a real WebSocket session', () async {
    await binding.close();
    final webSocketServer = AcpWebSocketServer(
      createConnection: harness.createConnection,
    );
    binding = await createPlatformAcpHttpServerAdapter().serve(
      harness.server,
      webSocketServer: webSocketServer,
    );
    final endpoint = binding.endpoint.replace(scheme: 'ws');
    final socket = await WebSocket.connect(endpoint.toString());
    final messages = StreamIterator<Object?>(socket);
    socket.add(
      jsonEncode(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 9,
        'method': 'initialize',
        'params': <String, Object?>{'protocolVersion': 1},
      }),
    );

    expect(await messages.moveNext(), isTrue);
    final response = jsonDecode(messages.current! as String);
    expect(response, containsPair('id', 9));

    harness.emit(<String, Object?>{
      'jsonrpc': '2.0',
      'method': '_native_event',
    });
    expect(await messages.moveNext(), isTrue);
    final event = jsonDecode(messages.current! as String);
    expect(event, containsPair('method', '_native_event'));

    await messages.cancel();
    await socket.close();
  });

  test('binding close is shared and drains an in-flight handler', () async {
    await binding.close();
    await harness.close();
    final policyStarted = Completer<void>();
    final releasePolicy = Completer<bool>();
    harness = HttpServerHarness(
      policy: (_) {
        policyStarted.complete();
        return releasePolicy.future;
      },
    );
    binding = await createPlatformAcpHttpServerAdapter().serve(harness.server);
    final request = await client.getUrl(binding.endpoint);
    final response = request.close().then<Object?>(
      (HttpClientResponse value) => value,
      onError: (Object _) => null,
    );
    await policyStarted.future;

    var finished = false;
    final closing = binding.close();
    unawaited(closing.whenComplete(() => finished = true));
    expect(binding.close(), same(closing));
    await Future<void>.delayed(Duration.zero);
    expect(finished, isFalse);

    releasePolicy.complete(true);
    await closing;
    await response;
    expect(finished, isTrue);
  });
}
