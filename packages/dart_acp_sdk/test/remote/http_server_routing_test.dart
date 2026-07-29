import 'dart:convert';

import 'package:dart_acp_sdk/src/remote/http_adapter.dart';
import 'package:test/test.dart';

import 'http_server_test_support.dart';

void main() {
  late HttpServerHarness harness;
  late String connectionId;

  setUp(() async {
    harness = HttpServerHarness();
    final response = await harness.initialize();
    connectionId = response.headers.value('Acp-Connection-Id')!;
  });

  tearDown(() => harness.close());

  test('requires a session header for the exact scoped method set', () async {
    const methods = <String>[
      'session/cancel',
      'session/close',
      'session/load',
      'session/prompt',
      'session/resume',
      'session/set_config_option',
      'session/set_mode',
    ];
    for (var index = 0; index < methods.length; index += 1) {
      final response = await harness.request(
        'POST',
        headers: _connectedJson(connectionId),
        body: _request(
          index + 10,
          methods[index],
          sessionId: 'session-required',
        ),
      );
      expect(response.statusCode, 400, reason: methods[index]);
    }
  });

  test(
    'rejects mismatched routing headers and accepts matching ones',
    () async {
      final mismatched = await harness.request(
        'POST',
        headers: _connectedJson(connectionId, sessionId: 'header-session'),
        body: _request(2, 'session/prompt', sessionId: 'params-session'),
      );
      expect(mismatched.statusCode, 400);

      final accepted = await harness.request(
        'POST',
        headers: _connectedJson(connectionId, sessionId: 'same-session'),
        body: _request(3, 'session/prompt', sessionId: 'same-session'),
      );
      expect(accepted.statusCode, 202);
      expect(harness.connections.last.session('same-session'), isNotNull);
    },
  );

  test('fork may route from params without a session header', () async {
    final response = await harness.request(
      'POST',
      headers: _connectedJson(connectionId),
      body: _request(4, 'session/fork', sessionId: 'source-session'),
    );

    expect(response.statusCode, 202);
    expect(harness.connections.last.session('source-session'), isNotNull);
  });

  test(
    'SSE GET validates routing and emits one JSON value per event',
    () async {
      final unknown = await harness.request(
        'GET',
        headers: _sseHeaders('unknown'),
      );
      expect(unknown.statusCode, 404);

      final response = await harness.request(
        'GET',
        headers: _sseHeaders(connectionId),
      );
      expect(response.statusCode, 200);
      expect(response.headers.value('Content-Type'), 'text/event-stream');
      final first = response.body.map(utf8.decode).first;
      harness.emit(<String, Object?>{
        'jsonrpc': '2.0',
        'method': '_event',
        'params': <String, Object?>{'value': 1},
      });

      expect(await first, contains('"method":"_event"'));
    },
  );

  test(
    'load updates use session SSE but its result uses connection SSE',
    () async {
      const sessionId = 'load-session';
      final connectionResponse = await harness.request(
        'GET',
        headers: _sseHeaders(connectionId),
      );
      final sessionResponse = await harness.request(
        'GET',
        headers: _sseHeaders(connectionId, sessionId: sessionId),
      );
      final connectionEvent = connectionResponse.body.map(utf8.decode).first;
      final sessionEvent = sessionResponse.body.map(utf8.decode).first;

      final accepted = await harness.request(
        'POST',
        headers: _connectedJson(connectionId, sessionId: sessionId),
        body: _request(50, 'session/load', sessionId: sessionId),
      );
      expect(accepted.statusCode, 202);
      harness.emit(<String, Object?>{
        'jsonrpc': '2.0',
        'method': 'session/update',
        'params': <String, Object?>{
          'sessionId': sessionId,
          'update': 'history',
        },
      });
      harness.emit(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 50,
        'result': <String, Object?>{},
      });

      expect(await sessionEvent, contains('session/update'));
      expect(await connectionEvent, contains('"id":50'));
    },
  );

  test(
    'client responses must return through the agent request route',
    () async {
      const sessionId = 'permission-session';
      harness.emit(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 'permission',
        'method': 'session/request_permission',
        'params': <String, Object?>{'sessionId': sessionId},
      });
      final response = <String, Object?>{
        'jsonrpc': '2.0',
        'id': 'permission',
        'result': <String, Object?>{'outcome': 'cancelled'},
      };

      expect(
        (await harness.request(
          'POST',
          headers: _connectedJson(connectionId),
          body: response,
        )).statusCode,
        400,
      );
      expect(
        (await harness.request(
          'POST',
          headers: _connectedJson(connectionId, sessionId: 'wrong'),
          body: response,
        )).statusCode,
        400,
      );
      expect(
        (await harness.request(
          'POST',
          headers: _connectedJson(connectionId, sessionId: sessionId),
          body: response,
        )).statusCode,
        202,
      );
    },
  );
}

AcpHttpHeaders _connectedJson(String connectionId, {String? sessionId}) {
  var headers = jsonHeaders().withHeader('Acp-Connection-Id', connectionId);
  if (sessionId != null) {
    headers = headers.withHeader('Acp-Session-Id', sessionId);
  }
  return headers;
}

AcpHttpHeaders _sseHeaders(String connectionId, {String? sessionId}) {
  var headers = const AcpHttpHeaders()
      .withHeader('Accept', 'text/event-stream')
      .withHeader('Acp-Connection-Id', connectionId);
  if (sessionId != null) {
    headers = headers.withHeader('Acp-Session-Id', sessionId);
  }
  return headers;
}

Map<String, Object?> _request(
  Object id,
  String method, {
  required String sessionId,
}) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'method': method,
  'params': <String, Object?>{'sessionId': sessionId},
};
