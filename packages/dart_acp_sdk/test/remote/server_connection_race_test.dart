import 'dart:async';

import 'package:dart_acp_sdk/src/json_rpc/id.dart';
import 'package:dart_acp_sdk/src/remote/server_connection.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:test/test.dart';

void main() {
  test('batch route validation is atomic', () async {
    final outbound = StreamController<Object?>(sync: true);
    final inbound = <Object?>[];
    final state = AcpServerConnectionState(
      connectionId: 'atomic',
      inbound: AcpWritable<Object?>(
        write: (Object? value) async => inbound.add(value),
        close: () async {},
      ),
      outbound: outbound.stream,
      allowBatches: true,
      maximumPendingRoutes: 2,
    );
    final request = _request('same', sessionId: 'not-created');

    await expectLater(
      state.writeInbound(<Object?>[request, request]),
      throwsA(isA<AcpServerRouteError>()),
    );

    expect(state.session('not-created'), isNull);
    await state.writeInbound(request);
    expect(inbound, <Object?>[request]);
    await state.close();
    await outbound.close();
  });

  test('close rejects queued writes and waits for the active write', () async {
    final firstStarted = Completer<void>();
    final releaseFirst = Completer<void>();
    final closeCalled = Completer<void>();
    final inbound = <Object?>[];
    final outbound = StreamController<Object?>();
    final state = AcpServerConnectionState(
      connectionId: 'write-close',
      inbound: AcpWritable<Object?>(
        write: (Object? value) async {
          inbound.add(value);
          if (!firstStarted.isCompleted) {
            firstStarted.complete();
            await releaseFirst.future;
          }
        },
        close: () async {
          closeCalled.complete();
        },
      ),
      outbound: outbound.stream,
    );

    final first = state.writeInbound(_request(1));
    final second = state.writeInbound(_request(2));
    await firstStarted.future;
    final closing = state.close('closed during writes');
    await closeCalled.future;
    expect(inbound, hasLength(1));

    releaseFirst.complete();
    await first;
    await expectLater(second, throwsA('closed during writes'));
    await closing;

    expect(inbound, hasLength(1));
    expect(() => state.ensureSession('late'), throwsStateError);
    await outbound.close();
  });

  test(
    'failed response rollback cannot overwrite a newer agent route',
    () async {
      final writeStarted = Completer<void>();
      final failWrite = Completer<void>();
      var writes = 0;
      final outbound = StreamController<Object?>(sync: true);
      final state = AcpServerConnectionState(
        connectionId: 'rollback-race',
        inbound: AcpWritable<Object?>(
          write: (Object? _) async {
            if (writes++ == 0) {
              writeStarted.complete();
              await failWrite.future;
              throw StateError('first response failed');
            }
          },
          close: () async {},
        ),
        outbound: outbound.stream,
      );
      const id = JsonRpcId.string('permission');
      outbound.add(_agentRequest(id.toJson(), 'old-session'));
      final firstResponse = state.writeInbound(
        _response(id.toJson()),
        route: const AcpSessionRoute('old-session'),
      );
      await writeStarted.future;

      outbound.add(_agentRequest(id.toJson(), 'new-session'));
      failWrite.complete();
      await expectLater(firstResponse, throwsStateError);

      expect(
        state.expectedClientResponseRoute(id),
        const AcpSessionRoute('new-session'),
      );
      await state.writeInbound(
        _response(id.toJson()),
        route: const AcpSessionRoute('new-session'),
      );
      expect(state.expectedClientResponseRoute(id), isNull);

      await state.close();
      await outbound.close();
    },
  );

  test(
    'outbound route-limit failures close instead of escaping the zone',
    () async {
      final outbound = StreamController<Object?>(sync: true);
      final state = AcpServerConnectionState(
        connectionId: 'outbound-limit',
        inbound: AcpWritable<Object?>(
          write: (Object? _) async {},
          close: () async {},
        ),
        outbound: outbound.stream,
        maximumSessions: 1,
      );

      outbound
        ..add(_notification('one'))
        ..add(_notification('two'));
      await state.closed;

      expect(state.closeReason, isA<StateError>());
      expect(state.sessionCount, 0);
      await outbound.close();
    },
  );

  test('malformed response-shaped values release client routes', () async {
    final outbound = StreamController<Object?>(sync: true);
    final state = AcpServerConnectionState(
      connectionId: 'malformed-response',
      inbound: AcpWritable<Object?>(
        write: (Object? _) async {},
        close: () async {},
      ),
      outbound: outbound.stream,
    );
    const id = JsonRpcId.string('malformed');
    outbound.add(_agentRequest(id.toJson(), 'session'));

    await state.writeInbound(<String, Object?>{
      'jsonrpc': '2.0',
      'id': id.toJson(),
      'result': <String, Object?>{},
      'error': <String, Object?>{
        'code': -32603,
        'message': 'invalid duplicate payload',
      },
    }, route: const AcpSessionRoute('session'));

    expect(state.expectedClientResponseRoute(id), isNull);
    await state.close();
    await outbound.close();
  });
}

Map<String, Object?> _request(
  Object? id, {
  String? sessionId,
}) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'method': '_request',
  if (sessionId != null) 'params': <String, Object?>{'sessionId': sessionId},
};

Map<String, Object?> _agentRequest(Object? id, String sessionId) =>
    <String, Object?>{
      'jsonrpc': '2.0',
      'id': id,
      'method': 'session/request_permission',
      'params': <String, Object?>{'sessionId': sessionId},
    };

Map<String, Object?> _notification(String sessionId) => <String, Object?>{
  'jsonrpc': '2.0',
  'method': 'session/update',
  'params': <String, Object?>{'sessionId': sessionId},
};

Map<String, Object?> _response(Object? id) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'result': <String, Object?>{},
};
