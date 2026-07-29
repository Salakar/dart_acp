import 'dart:async';

import 'package:dart_acp_sdk/src/remote/server_connection.dart';
import 'package:dart_acp_sdk/src/remote/server_registry.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:test/test.dart';

void main() {
  AcpServerConnectionState state(String id) {
    return AcpServerConnectionState(
      connectionId: id,
      inbound: AcpWritable<Object?>(
        write: (Object? _) async {},
        close: () async {},
      ),
      outbound: const Stream<Object?>.empty(),
    );
  }

  test('pending connections are hidden until activation', () async {
    final registry = AcpServerConnectionRegistry();
    final connection = state('one');
    registry.addPending(connection);

    expect(registry.pendingCount, 1);
    expect(registry.lookup('one'), isNull);

    expect(registry.activate('one'), same(connection));
    expect(registry.pendingCount, 0);
    expect(registry.lookup('one'), same(connection));

    await registry.closeAll();
  });

  test('duplicate and closed registrations fail', () async {
    final registry = AcpServerConnectionRegistry();
    final first = state('duplicate');
    final second = state('duplicate');
    registry.addPending(first);

    expect(() => registry.addPending(second), throwsStateError);
    await second.close();
    expect(() => registry.addPending(second), throwsStateError);

    await registry.closeAll();
  });

  test('remove sees active while discard sees pending too', () async {
    final registry = AcpServerConnectionRegistry();
    final pending = state('pending');
    final active = state('active');
    registry
      ..addPending(pending)
      ..addPending(active)
      ..activate('active');

    expect(await registry.remove('pending'), isFalse);
    expect(await registry.discard('pending'), isTrue);
    expect(await registry.remove('active'), isTrue);
    expect(registry.activeCount, 0);
    expect(registry.pendingCount, 0);
  });

  test('closed entries remove themselves', () async {
    final registry = AcpServerConnectionRegistry();
    final connection = state('self-removing');
    registry.addPending(connection);

    await connection.close();
    await Future<void>.delayed(Duration.zero);

    expect(registry.pendingCount, 0);
    expect(() => registry.activate('self-removing'), throwsStateError);
  });

  test('closeAll clears maps before waiting for closure', () async {
    final closeGate = Completer<void>();
    final registry = AcpServerConnectionRegistry();
    final slow = AcpServerConnectionState(
      connectionId: 'slow',
      inbound: AcpWritable<Object?>(
        write: (Object? _) async {},
        close: () => closeGate.future,
      ),
      outbound: const Stream<Object?>.empty(),
    );
    registry
      ..addPending(slow)
      ..activate('slow');

    final closing = registry.closeAll();
    expect(registry.closeAll(), same(closing));
    expect(registry.activeCount, 0);
    expect(registry.pendingCount, 0);
    expect(() => registry.addPending(state('late')), throwsStateError);
    closeGate.complete();
    await closing;
  });

  test('connection IDs are unique UUIDv4 values', () {
    final registry = AcpServerConnectionRegistry();
    final ids = <String>{
      for (int index = 0; index < 100; index += 1) registry.nextConnectionId(),
    };

    expect(ids, hasLength(100));
    expect(
      ids,
      everyElement(
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-'
            r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      ),
    );
  });

  test('rejects repeated generated IDs after bounded attempts', () async {
    final registry = AcpServerConnectionRegistry(
      createConnectionId: () => 'same',
    );
    final existing = state('same');
    registry.addPending(existing);

    expect(registry.nextConnectionId, throwsStateError);
    await registry.closeAll();
  });

  test('reserves IDs across asynchronous factory gaps', () async {
    final registry = AcpServerConnectionRegistry(
      createConnectionId: () => 'reserved',
    );
    final id = registry.reserveConnectionId();

    expect(id, 'reserved');
    expect(registry.reserveConnectionId, throwsStateError);
    expect(() => registry.addPending(state(id)), throwsStateError);

    final connection = state(id);
    registry.addReservedPending(connection);
    expect(registry.pendingCount, 1);
    await registry.closeAll();
  });

  test('closeAll invalidates outstanding reservations', () async {
    final registry = AcpServerConnectionRegistry(
      createConnectionId: () => 'late',
    );
    final id = registry.reserveConnectionId();

    await registry.closeAll();

    final connection = state(id);
    expect(() => registry.addReservedPending(connection), throwsStateError);
    await connection.close();
  });
}
