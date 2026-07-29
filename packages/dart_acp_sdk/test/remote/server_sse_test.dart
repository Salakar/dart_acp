import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/src/remote/outbound_hub.dart';
import 'package:dart_acp_sdk/src/remote/server_sse.dart';
import 'package:test/test.dart';

void main() {
  test('emits replay and live JSON as separate SSE chunks', () async {
    final hub = AcpOutboundHub<Object?>();
    hub.add(<String, Object?>{'before': true});
    final body = createAcpServerSseBody(
      hub.subscribe(),
      timerFactory: _FakeScheduler().create,
    );
    final chunks = <String>[];
    final subscription = body.map(utf8.decode).listen(chunks.add);

    hub.add(<String, Object?>{'after': true});
    await Future<void>.delayed(Duration.zero);

    expect(chunks, <String>[
      'data: {"before":true}\n\n',
      'data: {"after":true}\n\n',
    ]);
    await subscription.cancel();
    await hub.close();
  });

  test('emits live value queued before response body is listened', () async {
    final hub = AcpOutboundHub<Object?>();
    final outbound = hub.subscribe();
    hub.add(<String, Object?>{'queued': true});
    final body = createAcpServerSseBody(
      outbound,
      timerFactory: _FakeScheduler().create,
    );

    expect(await body.map(utf8.decode).first, 'data: {"queued":true}\n\n');
    await hub.close();
  });

  test('keepalive runs only while downstream has demand', () async {
    final scheduler = _FakeScheduler();
    final hub = AcpOutboundHub<Object?>();
    final chunks = <String>[];
    final subscription = createAcpServerSseBody(
      hub.subscribe(),
      timerFactory: scheduler.create,
    ).map(utf8.decode).listen(chunks.add);

    scheduler.tick();
    expect(chunks, <String>[':\n\n']);

    subscription.pause();
    expect(scheduler.activeCount, 0);
    scheduler.tick();
    expect(chunks, hasLength(1));

    subscription.resume();
    expect(scheduler.activeCount, 1);
    scheduler.tick();
    expect(chunks, <String>[':\n\n', ':\n\n']);

    await subscription.cancel();
    expect(scheduler.activeCount, 0);
    await hub.close();
  });

  test('pause delegates buffering to the bounded outbound hub', () async {
    final overflows = <AcpOutboundOverflow>[];
    final hub = AcpOutboundHub<Object?>(capacity: 2, onOverflow: overflows.add);
    final chunks = <String>[];
    final subscription = createAcpServerSseBody(
      hub.subscribe(),
      timerFactory: _FakeScheduler().create,
    ).map(utf8.decode).listen(chunks.add);
    subscription.pause();

    hub
      ..add(1)
      ..add(2)
      ..add(3);
    expect(overflows, hasLength(1));

    subscription.resume();
    await Future<void>.delayed(Duration.zero);
    expect(chunks, <String>['data: 2\n\n', 'data: 3\n\n']);

    await subscription.cancel();
    await hub.close();
  });

  test('hub close closes the response and cancels its timer', () async {
    final scheduler = _FakeScheduler();
    final hub = AcpOutboundHub<Object?>();
    final done = Completer<void>();
    createAcpServerSseBody(
      hub.subscribe(),
      timerFactory: scheduler.create,
    ).listen((_) {}, onDone: done.complete);

    await hub.close();
    await done.future;

    expect(scheduler.activeCount, 0);
  });

  test('encoding failure closes the response and releases the hub', () async {
    final scheduler = _FakeScheduler();
    final hub = AcpOutboundHub<Object?>();
    final cyclic = <Object?>[];
    cyclic.add(cyclic);
    hub.add(cyclic);
    final errors = <Object>[];
    final done = Completer<void>();

    createAcpServerSseBody(
      hub.subscribe(),
      timerFactory: scheduler.create,
    ).listen((_) {}, onError: errors.add, onDone: done.complete);
    await done.future;

    expect(errors, hasLength(1));
    expect(hub.subscriberCount, 0);
    expect(scheduler.activeCount, 0);
    await hub.close();
  });

  test('rejects nonpositive keepalive intervals', () {
    final hub = AcpOutboundHub<Object?>();

    expect(
      () => createAcpServerSseBody(
        hub.subscribe(),
        keepAliveInterval: Duration.zero,
      ),
      throwsArgumentError,
    );
  });
}

final class _FakeScheduler {
  final List<_FakeTimer> _timers = <_FakeTimer>[];

  int get activeCount =>
      _timers.where((_FakeTimer timer) => timer.isActive).length;

  AcpSsePeriodicTimer create(Duration _, void Function() onTick) {
    final timer = _FakeTimer(onTick);
    _timers.add(timer);
    return timer;
  }

  void tick() {
    for (final timer in _timers.toList()) {
      timer.tick();
    }
  }
}

final class _FakeTimer implements AcpSsePeriodicTimer {
  _FakeTimer(this._onTick);

  final void Function() _onTick;

  @override
  bool isActive = true;

  void tick() {
    if (isActive) {
      _onTick();
    }
  }

  @override
  void cancel() {
    isActive = false;
  }
}
