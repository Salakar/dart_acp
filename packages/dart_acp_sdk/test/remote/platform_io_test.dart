@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:dart_acp_sdk/experimental/web_socket.dart';
import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:test/test.dart';

void main() {
  test('dart:io HTTP adapter preserves headers and streams bytes', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final received = Completer<HttpRequest>();
    final serverTask = server.forEach((request) {
      received.complete(request);
      request.response
        ..headers.contentType = ContentType.text
        ..headers.add('Set-Cookie', 'first=1; Path=/')
        ..headers.add('Set-Cookie', 'second=2; Path=/')
        ..write('hello')
        ..close();
    });
    final adapter = createPlatformHttpAdapter();
    final cancellation = CancellationSource();
    final response = await adapter.send(
      AcpHttpRequest(
        uri: Uri.parse('http://127.0.0.1:${server.port}/acp'),
        method: 'GET',
        headers: const AcpHttpHeaders()
            .withHeader('X-Test', 'yes')
            .withHeader('Cookie', 'route=one'),
        cancellationToken: cancellation.token,
      ),
    );
    final body = await response.body.expand((chunk) => chunk).toList();
    final request = await received.future;

    expect(response.statusCode, 200);
    expect(response.headers.values('set-cookie'), hasLength(2));
    expect(utf8.decode(body), 'hello');
    expect(request.headers.value('x-test'), 'yes');
    expect(request.headers.value('cookie'), 'route=one');

    await adapter.close();
    await server.close(force: true);
    await serverTask;
  });

  test('dart:io HTTP adapter aborts an in-flight request', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final received = Completer<HttpRequest>();
    final serverTask = server.forEach((request) {
      received.complete(request);
    });
    final adapter = createPlatformHttpAdapter();
    final cancellation = CancellationSource();
    final response = adapter.send(
      AcpHttpRequest(
        uri: Uri.parse('http://127.0.0.1:${server.port}/blocked'),
        method: 'GET',
        cancellationToken: cancellation.token,
      ),
    );
    await received.future;
    cancellation.cancel('test');

    await expectLater(response, throwsA(anything));

    await adapter.close();
    await server.close(force: true);
    await serverTask;
  });

  test('dart:io WebSocket adapter sends headers and text frames', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final requestHeaders = Completer<HttpHeaders>();
    final serverTask = () async {
      await for (final request in server) {
        requestHeaders.complete(request.headers);
        final socket = await WebSocketTransformer.upgrade(request);
        await for (final message in socket) {
          socket.add(message);
          break;
        }
        await socket.close();
      }
    }();
    final adapter = createPlatformWebSocketAdapter();
    final channel = await adapter.connect(
      AcpWebSocketConnectRequest(
        uri: Uri.parse('ws://127.0.0.1:${server.port}/acp'),
        protocols: const <String>[],
        headers: const AcpHttpHeaders()
            .withHeader('Authorization', 'Bearer test')
            .withHeader('Cookie', 'route=one'),
      ),
    );
    final nextFrame = channel.frames.first;
    await channel.sendText('hello');

    expect(await nextFrame, isA<AcpWebSocketTextFrame>());
    final headers = await requestHeaders.future;
    expect(headers.value('authorization'), 'Bearer test');
    expect(headers.value('cookie'), 'route=one');

    await channel.close();
    await adapter.close();
    await server.close(force: true);
    await serverTask;
  });
}
