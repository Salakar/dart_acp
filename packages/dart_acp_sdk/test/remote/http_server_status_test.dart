import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:dart_acp_sdk/src/remote/http_adapter.dart';
import 'package:dart_acp_sdk/src/remote/http_server.dart';
import 'package:dart_acp_sdk/src/remote/server_limits.dart';
import 'package:test/test.dart';

import 'http_server_test_support.dart';

void main() {
  late HttpServerHarness harness;

  setUp(() {
    harness = HttpServerHarness();
  });

  tearDown(() => harness.close());

  test(
    'enforces the method, media, JSON, and connection status table',
    () async {
      expect((await harness.request('PUT')).statusCode, 405);
      expect((await harness.request('POST')).statusCode, 415);
      expect(
        (await harness.request(
          'POST',
          headers: jsonHeaders(),
          rawBody: <int>[0xff],
        )).statusCode,
        400,
      );
      expect(
        (await harness.request(
          'POST',
          headers: jsonHeaders(),
          body: 1,
        )).statusCode,
        400,
      );
      expect(
        (await harness.request(
          'POST',
          headers: jsonHeaders(),
          body: <Object?>[],
        )).statusCode,
        501,
      );
      expect(
        (await harness.request(
          'POST',
          headers: jsonHeaders(),
          body: notification('custom/ping'),
        )).statusCode,
        400,
      );
      expect(
        (await harness.request(
          'POST',
          headers: jsonHeaders().withHeader('Acp-Connection-Id', 'unknown'),
          body: notification('custom/ping'),
        )).statusCode,
        404,
      );
      expect(
        (await harness.request(
          'GET',
          headers: const AcpHttpHeaders().withHeader('Upgrade', 'websocket'),
        )).statusCode,
        426,
      );
      expect((await harness.request('GET')).statusCode, 406);
      expect(
        (await harness.request(
          'GET',
          headers: const AcpHttpHeaders().withHeader(
            'Accept',
            'text/event-stream',
          ),
        )).statusCode,
        400,
      );
      expect((await harness.request('DELETE')).statusCode, 400);
    },
  );

  test(
    'initialize returns a connection ID and preserves application errors',
    () async {
      final success = await harness.initialize();
      expect(success.statusCode, 200);
      expect(success.headers.value('Acp-Connection-Id'), isNotEmpty);
      expect(harness.server.connectionCount, 1);

      final connectionId = success.headers.value('Acp-Connection-Id')!;
      final duplicate = await harness.request(
        'POST',
        headers: jsonHeaders().withHeader('Acp-Connection-Id', connectionId),
        body: initializeMessage(2),
      );
      expect(duplicate.statusCode, 400);

      harness.initializeError = true;
      final error = await harness.initialize(id: 'error-id');
      expect(error.statusCode, 200);
      expect((await jsonBody(error))['error'], isA<Map<Object?, Object?>>());
    },
  );

  test(
    'initialize validates IDs and returns safe construction failures',
    () async {
      final missing = await harness.request(
        'POST',
        headers: jsonHeaders(),
        body: <String, Object?>{'jsonrpc': '2.0', 'method': 'initialize'},
      );
      expect(missing.statusCode, 400);
      final nullId = await harness.request(
        'POST',
        headers: jsonHeaders(),
        body: initializeMessage(null),
      );
      expect(nullId.statusCode, 400);

      harness.failFactory = true;
      final failed = await harness.initialize(id: 71);
      expect(failed.statusCode, 500);
      final body = await jsonBody(failed);
      expect(body['id'], 71);
      expect(body.toString(), isNot(contains('factory secret')));
    },
  );

  test('initialize observes request cancellation as status 499', () async {
    final cancellation = CancellationSource()..cancel('gone');
    final response = await harness.request(
      'POST',
      headers: jsonHeaders(),
      body: initializeMessage(1),
      cancellation: cancellation,
    );

    expect(response.statusCode, 499);
    expect(harness.server.connectionCount, 0);
  });

  test('HTTP request policy fails closed', () async {
    await harness.close();
    harness = HttpServerHarness(policy: (_) => false);
    expect((await harness.request('GET')).statusCode, 403);

    await harness.close();
    harness = HttpServerHarness(
      policy: (_) => throw StateError('authorization secret'),
    );
    final response = await harness.request('GET');
    expect(response.statusCode, 403);
    expect(response.toString(), isNot(contains('authorization secret')));
  });

  test(
    'connected messages are accepted and DELETE closes the connection',
    () async {
      final initialized = await harness.initialize();
      final connectionId = initialized.headers.value('Acp-Connection-Id')!;
      final accepted = await harness.request(
        'POST',
        headers: jsonHeaders().withHeader('Acp-Connection-Id', connectionId),
        body: notification('_ping'),
      );
      expect(accepted.statusCode, 202);
      expect(harness.inbound.last, notification('_ping'));

      final deleted = await harness.request(
        'DELETE',
        headers: const AcpHttpHeaders().withHeader(
          'Acp-Connection-Id',
          connectionId,
        ),
      );
      expect(deleted.statusCode, 202);
      await Future<void>.delayed(Duration.zero);
      expect(harness.server.connectionCount, 0);
    },
  );

  test('all limits are validated without relying on assertions', () {
    final invalid = <AcpRemoteServerLimits>[
      const AcpRemoteServerLimits(maximumBodyBytes: 0),
      const AcpRemoteServerLimits(maximumSessions: 0),
      const AcpRemoteServerLimits(maximumPendingRoutes: 0),
      const AcpRemoteServerLimits(outboundQueueCapacity: 0),
      const AcpRemoteServerLimits(maximumWebSocketFrameBytes: 0),
      const AcpRemoteServerLimits(maximumJsonNestingDepth: 0),
      const AcpRemoteServerLimits(initializeTimeout: Duration.zero),
      const AcpRemoteServerLimits(sseKeepAliveInterval: Duration.zero),
    ];

    for (final limits in invalid) {
      expect(
        () => AcpHttpServer(
          createConnection: (_) => throw UnimplementedError(),
          limits: limits,
        ),
        throwsArgumentError,
      );
    }
  });
}
