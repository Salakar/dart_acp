@TestOn('browser')
library;

import 'dart:convert';

import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:dart_acp_sdk/experimental/web_socket.dart';
import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:test/test.dart';

void main() {
  test('browser Fetch adapter reads a streaming data response', () async {
    final adapter = createPlatformHttpAdapter();
    final cancellation = CancellationSource();

    final response = await adapter.send(
      AcpHttpRequest(
        uri: Uri.parse('data:text/plain;charset=utf-8,hello%20browser'),
        method: 'GET',
        cancellationToken: cancellation.token,
      ),
    );
    final body = await response.body.expand((chunk) => chunk).toList();

    expect(response.statusCode, 200);
    expect(response.headers.value('content-type'), contains('text/plain'));
    expect(utf8.decode(body), 'hello browser');
    await adapter.close();
  });

  test('browser Fetch rejects caller-managed Cookie headers', () async {
    final adapter = createPlatformHttpAdapter();
    final cancellation = CancellationSource();

    await expectLater(
      adapter.send(
        AcpHttpRequest(
          uri: Uri.parse('data:text/plain,unused'),
          method: 'GET',
          headers: const AcpHttpHeaders().withHeader('Cookie', 'route=one'),
          cancellationToken: cancellation.token,
        ),
      ),
      throwsUnsupportedError,
    );
    await adapter.close();
  });

  test('browser WebSocket rejects custom handshake headers', () async {
    final adapter = createPlatformWebSocketAdapter();

    await expectLater(
      adapter.connect(
        AcpWebSocketConnectRequest(
          uri: Uri.parse('ws://127.0.0.1:1/acp'),
          headers: const AcpHttpHeaders().withHeader(
            'Authorization',
            'Bearer test',
          ),
        ),
      ),
      throwsUnsupportedError,
    );
    await adapter.close();
  });
}
