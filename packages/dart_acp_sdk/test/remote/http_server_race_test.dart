import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:dart_acp_sdk/src/remote/http_adapter.dart';
import 'package:dart_acp_sdk/src/remote/http_server.dart';
import 'package:dart_acp_sdk/src/remote/server_connection.dart';
import 'package:dart_acp_sdk/src/remote/server_limits.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:test/test.dart';

import 'http_server_test_support.dart';

void main() {
  test('cancellation bounds a factory and closes its late result', () async {
    final factory = Completer<AcpServerConnectionState>();
    final cancellation = CancellationSource();
    final server = AcpHttpServer(createConnection: (_) => factory.future);

    final responseFuture = server.handle(_initialize(cancellation));
    await _pump();
    cancellation.cancel('client left');
    final response = await responseFuture;
    expect(response.statusCode, 499);

    final fixture = _Fixture('late');
    factory.complete(fixture.state);
    await fixture.state.closed;
    expect(server.connectionCount, 0);

    await fixture.outbound.close();
    await server.close();
  });

  test('initialize timeout includes the asynchronous factory', () async {
    final factory = Completer<AcpServerConnectionState>();
    final server = AcpHttpServer(
      createConnection: (_) => factory.future,
      limits: const AcpRemoteServerLimits(
        initializeTimeout: Duration(milliseconds: 10),
      ),
    );

    final response = await server.handle(_initialize(CancellationSource()));
    expect(response.statusCode, 500);

    final fixture = _Fixture('timed-out');
    factory.complete(fixture.state);
    await fixture.state.closed;
    expect(server.connectionCount, 0);

    await fixture.outbound.close();
    await server.close();
  });

  test('server close racing a factory cannot publish a connection', () async {
    final factoryStarted = Completer<String>();
    final factory = Completer<AcpServerConnectionState>();
    final server = AcpHttpServer(
      createConnection: (String id) {
        factoryStarted.complete(id);
        return factory.future;
      },
    );

    final responseFuture = server.handle(_initialize(CancellationSource()));
    final id = await factoryStarted.future;
    final closing = server.close();
    expect(server.close(), same(closing));
    await closing;

    final fixture = _Fixture(id);
    factory.complete(fixture.state);
    expect((await responseFuture).statusCode, 503);
    await fixture.state.closed;
    expect(server.connectionCount, 0);

    await fixture.outbound.close();
  });

  test('mismatched factory state is always closed', () async {
    late _Fixture fixture;
    final server = AcpHttpServer(
      createConnection: (_) {
        fixture = _Fixture('wrong-id');
        return fixture.state;
      },
    );

    expect(
      (await server.handle(_initialize(CancellationSource()))).statusCode,
      500,
    );
    await fixture.state.closed;
    expect(server.connectionCount, 0);

    await fixture.outbound.close();
    await server.close();
  });

  test('duplicate initialize notification is rejected with 400', () async {
    final harness = HttpServerHarness();
    final initialized = await harness.initialize();
    final id = initialized.headers.value('Acp-Connection-Id')!;
    final before = harness.inbound.length;

    final response = await harness.request(
      'POST',
      headers: jsonHeaders().withHeader('Acp-Connection-Id', id),
      body: <String, Object?>{'jsonrpc': '2.0', 'method': 'initialize'},
    );

    expect(response.statusCode, 400);
    expect(harness.inbound, hasLength(before));
    await harness.close();
  });

  test('session SSE limit is a bounded 429 response', () async {
    late _Fixture fixture;
    final server = AcpHttpServer(
      createConnection: (String id) {
        fixture = _Fixture(id, maximumSessions: 1);
        return fixture.state;
      },
      limits: const AcpRemoteServerLimits(maximumSessions: 1),
    );
    final initialized = await server.handle(_initialize(CancellationSource()));
    final id = initialized.headers.value('Acp-Connection-Id')!;

    expect((await server.handle(_sse(id, 'one'))).statusCode, 200);
    expect((await server.handle(_sse(id, 'two'))).statusCode, 429);

    await server.close();
    await fixture.outbound.close();
  });

  test('application StateError is a 500, not a routing 400', () async {
    late _Fixture fixture;
    final server = AcpHttpServer(
      createConnection: (String id) {
        fixture = _Fixture(id, failAfterInitialize: true);
        return fixture.state;
      },
    );
    final initialized = await server.handle(_initialize(CancellationSource()));
    final id = initialized.headers.value('Acp-Connection-Id')!;

    final response = await server.handle(
      AcpHttpRequest(
        uri: Uri.parse('http://localhost/acp'),
        method: 'POST',
        cancellationToken: CancellationSource().token,
        headers: jsonHeaders().withHeader('Acp-Connection-Id', id),
        body: utf8.encode(jsonEncode(notification('_fail'))),
      ),
    );

    expect(response.statusCode, 500);
    await server.close();
    await fixture.outbound.close();
  });

  test('close during an asynchronous policy returns 503', () async {
    final policy = Completer<bool>();
    final server = AcpHttpServer(
      createConnection: (_) => throw UnimplementedError(),
      requestPolicy: (_) => policy.future,
    );
    final response = server.handle(
      AcpHttpRequest(
        uri: Uri.parse('http://localhost/acp'),
        method: 'GET',
        cancellationToken: CancellationSource().token,
      ),
    );

    await _pump();
    await server.close();
    policy.complete(true);
    expect((await response).statusCode, 503);
  });
}

final class _Fixture {
  _Fixture(
    String id, {
    int maximumSessions = 10000,
    bool failAfterInitialize = false,
  }) : outbound = StreamController<Object?>(sync: true) {
    state = AcpServerConnectionState(
      connectionId: id,
      inbound: AcpWritable<Object?>(
        write: (Object? value) async {
          final object = value as Map<String, Object?>;
          if (object['method'] == 'initialize') {
            outbound.add(<String, Object?>{
              'jsonrpc': '2.0',
              'id': object['id'],
              'result': <String, Object?>{'protocolVersion': 1},
            });
          } else if (failAfterInitialize) {
            throw StateError('application write failed');
          }
        },
        close: () async {},
      ),
      outbound: outbound.stream,
      maximumSessions: maximumSessions,
    );
  }

  final StreamController<Object?> outbound;
  late final AcpServerConnectionState state;
}

AcpHttpRequest _initialize(CancellationSource cancellation) => AcpHttpRequest(
  uri: Uri.parse('http://localhost/acp'),
  method: 'POST',
  cancellationToken: cancellation.token,
  headers: jsonHeaders(),
  body: utf8.encode(jsonEncode(initializeMessage(1))),
);

AcpHttpRequest _sse(String connectionId, String sessionId) => AcpHttpRequest(
  uri: Uri.parse('http://localhost/acp'),
  method: 'GET',
  cancellationToken: CancellationSource().token,
  headers: const AcpHttpHeaders()
      .withHeader('Accept', 'text/event-stream')
      .withHeader('Acp-Connection-Id', connectionId)
      .withHeader('Acp-Session-Id', sessionId),
);

Future<void> _pump() => Future<void>.delayed(Duration.zero);
