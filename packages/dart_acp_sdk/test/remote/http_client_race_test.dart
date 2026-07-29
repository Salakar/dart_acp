import 'dart:async';

import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:dart_acp_sdk/src/json_rpc/id.dart';
import 'package:dart_acp_sdk/src/json_rpc/message.dart';
import 'package:test/test.dart';

import 'http_test_support.dart';

void main() {
  test('close aborts initialize and deletes one late connection', () async {
    final initializeResponse = Completer<AcpHttpResponse>();
    late final FakeHttpAdapter adapter;
    adapter = FakeHttpAdapter((request) {
      if (request.method == 'POST') {
        return initializeResponse.future;
      }
      return emptyResponse();
    });
    final transport = AcpHttpClientTransport(
      Uri.parse('https://agent.example/acp'),
      adapter: adapter,
    );
    final subscription = transport.stream.readable.listen((_) {});
    final write = transport.stream.writable.write(
      const JsonRpcRequest(id: JsonRpcId.string('init'), method: 'initialize'),
    );
    final writeFailure = expectLater(write, throwsStateError);
    await pumpUntil(() => adapter.requests.isNotEmpty);

    await transport.close();
    expect(adapter.requests.single.cancellationToken.isCancelled, isTrue);
    initializeResponse.complete(
      jsonResponse(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 'init',
        'result': null,
      }, connectionId: 'late-connection'),
    );
    await writeFailure;
    await pumpUntil(() => adapter.requests.length == 2);

    expect(adapter.requests.map((request) => request.method), <String>[
      'POST',
      'DELETE',
    ]);
    await subscription.cancel();
  });

  test('close cancels an in-flight connected POST before DELETE', () async {
    final connectionBody = StreamController<List<int>>();
    final connectedPost = Completer<AcpHttpResponse>();
    final postCancelled = Completer<void>();
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
      if (request.method == 'POST') {
        request.cancellationToken.register((reason) {
          if (!postCancelled.isCompleted) {
            postCancelled.complete();
          }
          if (!connectedPost.isCompleted) {
            connectedPost.completeError(CancellationException(reason));
          }
        });
        return connectedPost.future;
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
    final write = transport.stream.writable.write(
      const JsonRpcNotification(method: '_vendor/connected'),
    );
    final writeFailure = expectLater(
      write,
      throwsA(isA<CancellationException>()),
    );
    await pumpUntil(
      () =>
          adapter.requests
              .where((request) => request.method == 'POST')
              .length ==
          2,
    );

    await transport.close();
    await writeFailure;

    expect(postCancelled.isCompleted, isTrue);
    expect(adapter.requests.last.method, 'DELETE');
    await subscription.cancel();
    await connectionBody.close();
  });
}
