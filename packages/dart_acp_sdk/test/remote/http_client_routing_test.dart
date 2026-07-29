import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:dart_acp_sdk/src/json_rpc/id.dart';
import 'package:dart_acp_sdk/src/json_rpc/message.dart';
import 'package:dart_acp_sdk/src/json_rpc/params.dart';
import 'package:test/test.dart';

import 'http_test_support.dart';

void main() {
  test('initializes, opens SSE, and routes session traffic exactly', () async {
    final connectionBody = StreamController<List<int>>();
    final sessionBody = StreamController<List<int>>();
    late final FakeHttpAdapter adapter;
    adapter = FakeHttpAdapter((request) {
      final sessionId = request.headers.value(acpSessionIdHeader);
      if (request.method == 'POST' &&
          !request.headers.contains(acpConnectionIdHeader)) {
        return jsonResponse(
          <String, Object?>{
            'jsonrpc': '2.0',
            'id': 'initialize',
            'result': <String, Object?>{'protocolVersion': 1},
          },
          connectionId: 'connection-1',
          setCookies: const <String>['route=managed; Path=/'],
        );
      }
      if (request.method == 'GET' && sessionId == null) {
        return sseResponse(connectionBody.stream);
      }
      if (request.method == 'GET' && sessionId == 'session-1') {
        return sseResponse(sessionBody.stream);
      }
      return emptyResponse();
    });
    final transport = AcpHttpClientTransport(
      Uri.parse('https://agent.example/acp'),
      adapter: adapter,
      headers: const AcpHttpHeaders()
          .withHeader('Authorization', 'Bearer token')
          .withHeader('Cookie', 'caller=custom'),
    );
    final messages = <JsonRpcWireMessage>[];
    final subscription = transport.stream.readable.listen(messages.add);

    await transport.stream.writable.write(
      const JsonRpcRequest(
        id: JsonRpcId.string('initialize'),
        method: 'initialize',
      ),
    );
    await pumpUntil(() => adapter.requests.length >= 2);

    expect(transport.connectionId, 'connection-1');
    expect(messages.single, isA<JsonRpcSuccessResponse>());
    final initialize = adapter.requests.first;
    expect(initialize.method, 'POST');
    expect(initialize.headers.value('authorization'), 'Bearer token');
    expect(initialize.headers.value('content-type'), acpJsonMediaType);
    expect(requestBody(initialize), contains('"method":"initialize"'));
    final connectionGet = adapter.requests[1];
    expect(connectionGet.method, 'GET');
    expect(connectionGet.headers.value('accept'), acpSseMediaType);
    expect(connectionGet.headers.value(acpConnectionIdHeader), 'connection-1');
    expect(
      connectionGet.headers.value('cookie'),
      'route=managed; caller=custom',
    );

    await transport.stream.writable.write(
      const JsonRpcRequest(id: JsonRpcId.string('new'), method: 'session/new'),
    );
    connectionBody.add(
      utf8.encode(
        'data: {"jsonrpc":"2.0","id":"new",'
        '"result":{"sessionId":"session-1"}}\n\n',
      ),
    );
    await pumpUntil(
      () => adapter.requests.any(
        (request) =>
            request.method == 'GET' &&
            request.headers.value(acpSessionIdHeader) == 'session-1',
      ),
    );

    await transport.stream.writable.write(
      const JsonRpcRequest(
        id: JsonRpcId.string('prompt'),
        method: 'session/prompt',
        params: JsonRpcParams.value(<String, Object?>{
          'sessionId': 'session-1',
        }),
      ),
    );
    final promptPost = adapter.requests.last;
    expect(promptPost.method, 'POST');
    expect(promptPost.headers.value(acpSessionIdHeader), 'session-1');

    sessionBody.add(
      utf8.encode(
        'data: {"jsonrpc":"2.0","id":"server-call",'
        '"method":"session/request_permission"}\n\n',
      ),
    );
    await pumpUntil(() => messages.length >= 3);
    await transport.stream.writable.write(
      const JsonRpcSuccessResponse(
        id: JsonRpcId.string('server-call'),
        result: <String, Object?>{'outcome': 'cancelled'},
      ),
    );
    expect(
      adapter.requests.last.headers.value(acpSessionIdHeader),
      'session-1',
    );

    await transport.close();
    await subscription.cancel();
    await connectionBody.close();
    await sessionBody.close();
    expect(adapter.requests.last.method, 'DELETE');
    expect(adapter.closeCount, 0);
  });

  test('reopens idle session SSE and fails pending requests on EOF', () async {
    final connectionBody = StreamController<List<int>>();
    final sessionBodies = <StreamController<List<int>>>[];
    late final FakeHttpAdapter adapter;
    adapter = FakeHttpAdapter((request) {
      if (request.method == 'POST' &&
          !request.headers.contains(acpConnectionIdHeader)) {
        return jsonResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 0,
          'result': null,
        }, connectionId: 'connection-1');
      }
      if (request.method == 'GET' &&
          request.headers.contains(acpSessionIdHeader)) {
        final body = StreamController<List<int>>();
        sessionBodies.add(body);
        return sseResponse(body.stream);
      }
      if (request.method == 'GET') {
        return sseResponse(connectionBody.stream);
      }
      return emptyResponse();
    });
    final transport = AcpHttpClientTransport(
      Uri.parse('https://agent.example/acp'),
      adapter: adapter,
    );
    final errors = <Object>[];
    final subscription = transport.stream.readable.listen(
      (_) {},
      onError: (Object error) => errors.add(error),
    );
    await transport.stream.writable.write(
      JsonRpcRequest(id: JsonRpcId.number(0), method: 'initialize'),
    );
    connectionBody.add(
      utf8.encode(
        'data: {"jsonrpc":"2.0","id":1,'
        '"result":{"sessionId":"session-1"}}\n\n',
      ),
    );
    await pumpUntil(() => sessionBodies.length == 1);

    await sessionBodies.single.close();
    await Future<void>.delayed(Duration.zero);
    expect(transport.isClosed, isFalse);
    await transport.stream.writable.write(
      JsonRpcRequest(
        id: JsonRpcId.number(2),
        method: 'session/prompt',
        params: JsonRpcParams.value(<String, Object?>{
          'sessionId': 'session-1',
        }),
      ),
    );
    await pumpUntil(() => sessionBodies.length == 2);
    await sessionBodies.last.close();
    await transport.done;

    expect(errors.single, isA<AcpHttpTransportException>());
    expect(transport.isClosed, isTrue);
    expect(adapter.requests.last.method, 'DELETE');
    await subscription.cancel();
    await connectionBody.close();
  });
}
