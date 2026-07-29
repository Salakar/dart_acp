import 'dart:async';

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
      connectionId: 'connection-1',
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

  test('routes connection and session messages independently', () {
    outbound.add(<String, Object?>{
      'jsonrpc': '2.0',
      'method': 'connection/note',
    });
    outbound.add(<String, Object?>{
      'jsonrpc': '2.0',
      'method': 'session/update',
      'params': <String, Object?>{'sessionId': 'session-1'},
    });

    expect(state.connectionOutbound.subscribe().replay, hasLength(1));
    expect(state.session('session-1')!.subscribe().replay, hasLength(1));
    expect(state.sessionCount, 1);
  });

  test('successful session result interns a session route', () async {
    await state.writeInbound(<String, Object?>{
      'jsonrpc': '2.0',
      'id': 1,
      'method': 'session/new',
    });
    outbound.add(<String, Object?>{
      'jsonrpc': '2.0',
      'id': 1,
      'result': <String, Object?>{'sessionId': 'session-created'},
    });

    expect(state.session('session-created'), isNotNull);
    expect(state.connectionOutbound.subscribe().replay, hasLength(1));
  });

  test('repeated ensureSession returns the same bounded session hub', () {
    final first = state.ensureSession('session-reused');

    expect(state.ensureSession('session-reused'), same(first));
    expect(state.session('session-reused'), same(first));
    expect(state.sessionCount, 1);
  });

  test('preserves batches while routing individual entries', () {
    state.enableBatches();
    final batch = <Object?>[
      <String, Object?>{'jsonrpc': '2.0', 'method': 'connection/note'},
      <String, Object?>{
        'jsonrpc': '2.0',
        'method': 'session/update',
        'params': <String, Object?>{'sessionId': 'session-batch'},
      },
    ];
    outbound.add(batch);

    expect(state.allOutbound.subscribe().replay, <Object?>[batch]);
    expect(state.connectionOutbound.subscribe().replay, hasLength(1));
    expect(state.session('session-batch')!.subscribe().replay, hasLength(1));
  });

  test('rejects batches until explicitly enabled', () async {
    await expectLater(
      state.writeInbound(<Object?>[]),
      throwsA(isA<StateError>()),
    );
    outbound.add(<Object?>[]);
    await state.closed;
    expect(state.closeReason, isA<StateError>());
  });

  test('serializes writes and lets later writes follow a failure', () async {
    var writes = 0;
    final localOutbound = StreamController<Object?>();
    final localState = AcpServerConnectionState(
      connectionId: 'write-order',
      inbound: AcpWritable<Object?>(
        write: (Object? value) async {
          if (writes++ == 0) {
            throw StateError('first failed');
          }
          inbound.add(value);
        },
        close: () async {},
      ),
      outbound: localOutbound.stream,
    );

    final first = localState.writeInbound(<String, Object?>{'first': true});
    final second = localState.writeInbound(<String, Object?>{'second': true});
    await expectLater(first, throwsA(isA<StateError>()));
    await second;

    expect(inbound, <Object?>[
      <String, Object?>{'second': true},
    ]);
    await localState.close();
    await localOutbound.close();
  });

  test('close clears routes and is idempotent', () async {
    state.ensureSession('session-close');
    final closing = state.close('finished');
    expect(state.close('ignored'), same(closing));
    await closing;

    expect(state.isClosed, isTrue);
    expect(state.closeReason, 'finished');
    expect(state.sessionCount, 0);
    await expectLater(
      state.writeInbound(<String, Object?>{}),
      throwsA('finished'),
    );
  });
}
