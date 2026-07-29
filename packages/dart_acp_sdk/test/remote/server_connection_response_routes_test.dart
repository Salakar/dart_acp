import 'dart:async';

import 'package:dart_acp_sdk/src/json_rpc/id.dart';
import 'package:dart_acp_sdk/src/remote/server_connection.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:test/test.dart';

void main() {
  late StreamController<Object?> outbound;
  late List<Object?> inbound;
  late AcpServerConnectionState state;

  setUp(() {
    outbound = StreamController<Object?>(sync: true);
    inbound = <Object?>[];
    state = AcpServerConnectionState(
      connectionId: 'routes',
      inbound: AcpWritable<Object?>(
        write: (Object? value) async => inbound.add(value),
        close: () async {},
      ),
      outbound: outbound.stream,
    );
  });

  tearDown(() async {
    await state.close();
    await outbound.close();
  });

  test('a response waiter consumes only its typed response ID', () async {
    final numeric = state.receiveResponse(JsonRpcId.number(1));
    final string = state.receiveResponse(const JsonRpcId.string('1'));
    await state.writeInbound(_request(1, 'initialize'));
    await state.writeInbound(_request('1', 'initialize'));
    final numericResponse = _response(1);
    final stringResponse = _response('1');

    outbound
      ..add(stringResponse)
      ..add(numericResponse);

    expect(await numeric, numericResponse);
    expect(await string, stringResponse);
    expect(state.connectionOutbound.subscribe().replay, isEmpty);
  });

  test('checks client responses return through the request route', () async {
    outbound.add(<String, Object?>{
      'jsonrpc': '2.0',
      'id': 'agent-request',
      'method': 'session/request_permission',
      'params': <String, Object?>{'sessionId': 'session-2'},
    });
    final response = _response('agent-request');

    await expectLater(state.writeInbound(response), throwsA(isA<StateError>()));
    await state.writeInbound(
      response,
      route: const AcpSessionRoute('session-2'),
    );

    expect(inbound, <Object?>[response]);
  });

  test('infers a request route and rejects a mismatched route', () async {
    final request = _request(
      'session-call',
      'session/prompt',
      sessionId: 'session-inferred',
    );
    await state.writeInbound(request);
    outbound.add(_response('session-call'));

    expect(state.session('session-inferred')!.subscribe().replay, hasLength(1));
    await expectLater(
      state.writeInbound(<String, Object?>{
        ...request,
        'id': 'wrong-route',
      }, route: const AcpSessionRoute('another-session')),
      throwsA(isA<StateError>()),
    );
  });

  test('allows an explicit connection-scoped load response', () async {
    await state.writeInbound(
      _request('load', 'session/load', sessionId: 'session-load'),
      inferSessionRoute: false,
    );
    outbound.add(_response('load'));

    expect(state.connectionOutbound.subscribe().replay, hasLength(1));
    expect(state.session('session-load'), isNotNull);
  });

  test('rolls back routes when an inbound write fails', () async {
    var writes = 0;
    final localOutbound = StreamController<Object?>(sync: true);
    final localInbound = <Object?>[];
    final localState = AcpServerConnectionState(
      connectionId: 'rollback',
      inbound: AcpWritable<Object?>(
        write: (Object? value) async {
          if (writes++ == 0) {
            throw StateError('transport failed');
          }
          localInbound.add(value);
        },
        close: () async {},
      ),
      outbound: localOutbound.stream,
    );
    final request = _request('reusable', 'initialize');

    await expectLater(
      localState.writeInbound(request),
      throwsA(isA<StateError>()),
    );
    await localState.writeInbound(request);
    expect(localInbound, <Object?>[request]);

    await localState.close();
    await localOutbound.close();
  });

  test('bounds pending routes and releases them on response', () async {
    final localOutbound = StreamController<Object?>(sync: true);
    final localState = AcpServerConnectionState(
      connectionId: 'limit',
      inbound: AcpWritable<Object?>(
        write: (Object? value) async {},
        close: () async {},
      ),
      outbound: localOutbound.stream,
      maximumPendingRoutes: 1,
    );

    await localState.writeInbound(_request(1, 'initialize'));
    await expectLater(
      localState.writeInbound(_request(2, 'initialize')),
      throwsA(isA<StateError>()),
    );
    localOutbound.add(_response(1));
    await localState.writeInbound(_request(2, 'initialize'));

    await localState.close();
    await localOutbound.close();
  });

  test('closes on duplicate agent request IDs', () async {
    final request = _request('duplicate', 'session/request_permission');
    outbound
      ..add(request)
      ..add(request);

    await state.closed;
    expect(state.closeReason, isA<StateError>());
  });
}

Map<String, Object?> _request(
  Object id,
  String method, {
  String? sessionId,
}) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'method': method,
  if (sessionId != null) 'params': <String, Object?>{'sessionId': sessionId},
};

Map<String, Object?> _response(Object id) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'result': <String, Object?>{},
};
