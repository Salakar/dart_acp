import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/src/remote/http_adapter.dart';
import 'package:dart_acp_sdk/src/remote/server_connection.dart';
import 'package:dart_acp_sdk/src/remote/server_limits.dart';
import 'package:dart_acp_sdk/src/remote/web_socket_server.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:test/test.dart';

import 'web_socket_server_test_support.dart';

void main() {
  test('preparation timeout closes a late factory result', () async {
    final factory = Completer<AcpServerConnectionState>();
    final server = AcpWebSocketServer(
      createConnection: (_) => factory.future,
      limits: _shortLimits,
    );

    await expectLater(_prepare(server), throwsA(isA<TimeoutException>()));

    final fixture = _Fixture('late');
    factory.complete(fixture.state);
    await fixture.state.closed;

    await server.close();
    await fixture.outbound.close();
  });

  test('server close racing a factory cannot leave a pending state', () async {
    final started = Completer<String>();
    final factory = Completer<AcpServerConnectionState>();
    final server = AcpWebSocketServer(
      createConnection: (String id) {
        started.complete(id);
        return factory.future;
      },
    );
    final preparing = _prepare(server);
    final id = await started.future;

    final closing = server.close();
    expect(server.close(), same(closing));
    await closing;

    final fixture = _Fixture(id);
    factory.complete(fixture.state);
    await expectLater(preparing, throwsStateError);
    await fixture.state.closed;
    await fixture.outbound.close();
  });

  test(
    'an unaccepted prepared upgrade expires and closes later sockets',
    () async {
      late _Fixture fixture;
      final server = AcpWebSocketServer(
        createConnection: (String id) {
          fixture = _Fixture(id);
          return fixture.state;
        },
        limits: _shortLimits,
      );
      final prepared = await _prepare(server);

      await fixture.state.closed.timeout(const Duration(seconds: 1));
      final socket = FakeServerWebSocket();
      expect(() => prepared.accept(socket), throwsStateError);
      await waitFor(() => socket.closeCode != null);
      expect(socket.closeCode, 1001);

      await server.close();
      await fixture.outbound.close();
    },
  );

  test('an accepted socket that never initializes closes with 1008', () async {
    late _Fixture fixture;
    final server = AcpWebSocketServer(
      createConnection: (String id) {
        fixture = _Fixture(id);
        return fixture.state;
      },
      limits: _shortLimits,
    );
    final socket = FakeServerWebSocket();
    final session = (await _prepare(server)).accept(socket);

    await session.closed.timeout(const Duration(seconds: 1));
    expect(socket.closeCode, 1008);
    await fixture.state.closed;

    await server.close();
    await fixture.outbound.close();
  });

  test(
    'inbound work pauses the frame stream while an agent write blocks',
    () async {
      late _Fixture fixture;
      final writeStarted = Completer<void>();
      final releaseWrite = Completer<void>();
      final server = AcpWebSocketServer(
        createConnection: (String id) {
          fixture = _Fixture(
            id,
            onConnectedWrite: (Object? _) async {
              if (!writeStarted.isCompleted) {
                writeStarted.complete();
                await releaseWrite.future;
              }
            },
          );
          return fixture.state;
        },
      );
      final socket = FakeServerWebSocket();
      (await _prepare(server)).accept(socket);
      socket.receiveText(jsonEncode(_initializeMessage));
      await waitFor(() => socket.sent.isNotEmpty);
      final pausesBefore = socket.pauseCount;

      socket.receiveText(jsonEncode(_notification('_first')));
      await writeStarted.future;
      expect(socket.isInputPaused, isTrue);
      expect(socket.pauseCount, greaterThan(pausesBefore));

      socket.receiveText(jsonEncode(_notification('_second')));
      await Future<void>.delayed(Duration.zero);
      expect(fixture.connectedWrites, hasLength(1));

      releaseWrite.complete();
      await waitFor(() => fixture.connectedWrites.length == 2);
      await server.close();
      await fixture.outbound.close();
    },
  );

  test('shutdown closes the channel before awaiting a blocked send', () async {
    late _Fixture fixture;
    final server = AcpWebSocketServer(
      createConnection: (String id) {
        fixture = _Fixture(id);
        return fixture.state;
      },
    );
    final socket = FakeServerWebSocket();
    (await _prepare(server)).accept(socket);
    socket.receiveText(jsonEncode(_initializeMessage));
    await waitFor(() => socket.sent.isNotEmpty);

    socket.sendGate = Completer<void>();
    fixture.outbound.add(_notification('_blocked_send'));
    await waitFor(() => socket.sent.length == 2);

    final closing = server.close();
    await closing.timeout(const Duration(seconds: 1));
    expect(socket.closeCode, 1001);

    await fixture.outbound.close();
  });

  test('WebSocket construction validates every configured limit', () {
    expect(
      () => AcpWebSocketServer(
        createConnection: (_) => throw UnimplementedError(),
        limits: const AcpRemoteServerLimits(maximumBodyBytes: 0),
      ),
      throwsArgumentError,
    );
  });
}

const _shortLimits = AcpRemoteServerLimits(
  initializeTimeout: Duration(milliseconds: 10),
);

final class _Fixture {
  _Fixture(String id, {this.onConnectedWrite})
    : outbound = StreamController<Object?>(sync: true) {
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
            return;
          }
          connectedWrites.add(value);
          await onConnectedWrite?.call(value);
        },
        close: () async {},
      ),
      outbound: outbound.stream,
    );
  }

  final Future<void> Function(Object? value)? onConnectedWrite;
  final StreamController<Object?> outbound;
  final List<Object?> connectedWrites = <Object?>[];
  late final AcpServerConnectionState state;
}

Future<AcpPreparedWebSocketUpgrade> _prepare(AcpWebSocketServer server) =>
    server.prepare(
      AcpWebSocketUpgradeContext(
        uri: Uri.parse('ws://localhost/acp'),
        headers: const AcpHttpHeaders(),
      ),
    );

const _initializeMessage = <String, Object?>{
  'jsonrpc': '2.0',
  'id': 1,
  'method': 'initialize',
  'params': <String, Object?>{'protocolVersion': 1},
};

Map<String, Object?> _notification(String method) => <String, Object?>{
  'jsonrpc': '2.0',
  'method': method,
};
