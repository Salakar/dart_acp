import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:dart_acp_sdk/src/json_rpc/batch.dart';
import 'package:dart_acp_sdk/src/json_rpc/id.dart';
import 'package:dart_acp_sdk/src/json_rpc/message.dart';
import 'package:test/test.dart';

import 'http_test_support.dart';

void main() {
  test(
    'rejects invalid initialize media and deletes the late connection',
    () async {
      late final FakeHttpAdapter adapter;
      adapter = FakeHttpAdapter((request) {
        if (request.method == 'DELETE') {
          return emptyResponse();
        }
        return jsonResponse(
          <String, Object?>{'jsonrpc': '2.0', 'id': 'init', 'result': null},
          connectionId: 'late-connection',
          contentType: 'text/plain',
        );
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

      await expectLater(
        transport.stream.writable.write(
          const JsonRpcRequest(
            id: JsonRpcId.string('init'),
            method: 'initialize',
          ),
        ),
        throwsA(isA<AcpHttpTransportException>()),
      );
      await transport.done;

      expect(adapter.requests.map((request) => request.method), <String>[
        'POST',
        'DELETE',
      ]);
      expect(errors.single, isA<AcpHttpTransportException>());
      await subscription.cancel();
    },
  );

  test('skips malformed payloads but rejects an inbound batch', () async {
    final connectionBody = StreamController<List<int>>();
    late final FakeHttpAdapter adapter;
    adapter = FakeHttpAdapter((request) {
      if (request.method == 'POST' &&
          !request.headers.contains(acpConnectionIdHeader)) {
        return jsonResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 'init',
          'result': null,
        }, connectionId: 'connection-1');
      }
      if (request.method == 'GET') {
        return sseResponse(connectionBody.stream);
      }
      return emptyResponse();
    });
    final diagnostics = <AcpRemoteDiagnostic>[];
    final messages = <JsonRpcWireMessage>[];
    final errors = <Object>[];
    final transport = AcpHttpClientTransport(
      Uri.parse('https://agent.example/acp'),
      adapter: adapter,
      onDiagnostic: diagnostics.add,
    );
    final subscription = transport.stream.readable.listen(
      messages.add,
      onError: (Object error) => errors.add(error),
    );
    await transport.stream.writable.write(
      const JsonRpcRequest(id: JsonRpcId.string('init'), method: 'initialize'),
    );
    connectionBody.add(
      utf8.encode(
        'data: {not-json}\n\n'
        'data: {"hello":"world"}\n\n'
        'data: {"jsonrpc":"2.0","method":"_vendor/event"}\n\n',
      ),
    );
    await pumpUntil(() => messages.length == 2);
    expect(diagnostics, hasLength(2));

    connectionBody.add(
      utf8.encode('data: [{"jsonrpc":"2.0","id":1,"result":null}]\n\n'),
    );
    await transport.done;

    expect(errors.single, isA<AcpHttpTransportException>());
    expect(adapter.requests.last.method, 'DELETE');
    await subscription.cancel();
    await connectionBody.close();
  });

  test('rejects outbound batches without another request', () async {
    final connectionBody = StreamController<List<int>>();
    late final FakeHttpAdapter adapter;
    adapter = FakeHttpAdapter((request) {
      if (request.method == 'POST' &&
          !request.headers.contains(acpConnectionIdHeader)) {
        return jsonResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 'init',
          'result': null,
        }, connectionId: 'connection-1');
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
    final subscription = transport.stream.readable.listen((_) {});
    await transport.stream.writable.write(
      const JsonRpcRequest(id: JsonRpcId.string('init'), method: 'initialize'),
    );
    await pumpUntil(() => adapter.requests.length == 2);
    final before = adapter.requests.length;

    await expectLater(
      transport.stream.writable.write(
        JsonRpcBatch(<JsonRpcMessage>[
          const JsonRpcNotification(method: '_vendor/event'),
        ]),
      ),
      throwsUnsupportedError,
    );

    expect(adapter.requests, hasLength(before));
    expect(transport.isClosed, isFalse);
    await transport.close();
    await subscription.cancel();
    await connectionBody.close();
  });

  test('connection EOF is fatal and triggers best-effort DELETE', () async {
    final connectionBody = StreamController<List<int>>();
    late final FakeHttpAdapter adapter;
    adapter = FakeHttpAdapter((request) {
      if (request.method == 'POST' &&
          !request.headers.contains(acpConnectionIdHeader)) {
        return jsonResponse(<String, Object?>{
          'jsonrpc': '2.0',
          'id': 'init',
          'result': null,
        }, connectionId: 'connection-1');
      }
      if (request.method == 'GET') {
        return sseResponse(connectionBody.stream);
      }
      return emptyResponse();
    });
    final errors = <Object>[];
    final transport = AcpHttpClientTransport(
      Uri.parse('https://agent.example/acp'),
      adapter: adapter,
    );
    final subscription = transport.stream.readable.listen(
      (_) {},
      onError: (Object error) => errors.add(error),
    );
    await transport.stream.writable.write(
      const JsonRpcRequest(id: JsonRpcId.string('init'), method: 'initialize'),
    );

    await connectionBody.close();
    await transport.done;

    expect(errors.single, isA<AcpHttpTransportException>());
    expect(adapter.requests.last.method, 'DELETE');
    await subscription.cancel();
  });

  test(
    'readable cancel reports DELETE failure and preserves caller cookies',
    () async {
      final connectionBody = StreamController<List<int>>();
      final cookieStore = AcpAffinityCookieStore()
        ..store(Uri.parse('https://agent.example/acp'), <String>['route=one']);
      late final FakeHttpAdapter adapter;
      adapter = FakeHttpAdapter((request) {
        if (request.method == 'POST') {
          return jsonResponse(<String, Object?>{
            'jsonrpc': '2.0',
            'id': 'init',
            'result': null,
          }, connectionId: 'connection-1');
        }
        if (request.method == 'GET') {
          return sseResponse(connectionBody.stream);
        }
        return emptyResponse(statusCode: 503);
      });
      final transport = AcpHttpClientTransport(
        Uri.parse('https://agent.example/acp'),
        adapter: adapter,
        cookieStore: cookieStore,
      );
      final subscription = transport.stream.readable.listen((_) {});
      await transport.stream.writable.write(
        const JsonRpcRequest(
          id: JsonRpcId.string('init'),
          method: 'initialize',
        ),
      );

      await expectLater(
        subscription.cancel(),
        throwsA(isA<AcpHttpTransportException>()),
      );
      final firstClose = transport.close();
      expect(identical(firstClose, transport.close()), isTrue);
      await expectLater(firstClose, throwsA(isA<AcpHttpTransportException>()));

      expect(cookieStore.length, 1);
      expect(adapter.closeCount, 0);
      await connectionBody.close();
    },
  );
}
