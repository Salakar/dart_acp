@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_sdk/src/remote/http_server_adapter_factory.dart';
import 'package:test/test.dart';

import 'http_server_test_support.dart';

void main() {
  test('native adapter flushes and streams a connection SSE event', () async {
    final harness = HttpServerHarness();
    final binding = await createPlatformAcpHttpServerAdapter().serve(
      harness.server,
    );
    final client = HttpClient();
    addTearDown(() async {
      client.close(force: true);
      await binding.close();
      await harness.close();
    });

    final initialize = await client.postUrl(binding.endpoint);
    initialize.headers.contentType = ContentType.json;
    initialize.write(jsonEncode(initializeMessage(1)));
    final initialized = await initialize.close();
    final connectionId = initialized.headers.value('Acp-Connection-Id');
    await initialized.drain<void>();

    final request = await client.getUrl(binding.endpoint);
    request.headers
      ..set('Accept', 'text/event-stream')
      ..set('Acp-Connection-Id', connectionId!);
    final response = await request.close().timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw TimeoutException('SSE headers not received'),
    );
    expect(response.statusCode, 200);
    expect(harness.connections.single.connectionOutbound.subscriberCount, 1);
    harness.emit(notification('_native_sse'));
    expect(
      await utf8.decoder
          .bind(response)
          .firstWhere((chunk) => chunk.contains('_native_sse'))
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException('SSE event not received'),
          ),
      contains('_native_sse'),
    );
  });
}
