import 'dart:async';

import 'package:dart_acp_sdk/src/remote/outbound_hub.dart';
import 'package:test/test.dart';

void main() {
  test('only the first subscriber consumes bounded replay', () async {
    final hub = AcpOutboundHub<int>(capacity: 2);
    hub
      ..add(1)
      ..add(2)
      ..add(3);

    final first = hub.subscribe();
    final second = hub.subscribe();

    expect(first.replay, <int>[2, 3]);
    expect(second.replay, isEmpty);
    await hub.close();
  });

  test('live subscribers receive independent values', () async {
    final hub = AcpOutboundHub<int>(capacity: 2);
    final first = hub.subscribe();
    final second = hub.subscribe();
    final firstValues = <int>[];
    final secondValues = <int>[];
    final firstSub = first.live.listen(firstValues.add);
    final secondSub = second.live.listen(secondValues.add);

    hub
      ..add(1)
      ..add(2);
    await Future<void>.delayed(Duration.zero);

    expect(firstValues, <int>[1, 2]);
    expect(secondValues, <int>[1, 2]);
    await firstSub.cancel();
    expect(hub.subscriberCount, 1);
    await secondSub.cancel();
    await hub.close();
  });

  test('paused queue drops oldest and reports per episode', () async {
    final overflows = <AcpOutboundOverflow>[];
    final hub = AcpOutboundHub<int>(capacity: 2, onOverflow: overflows.add);
    final outbound = hub.subscribe();
    final values = <int>[];
    final subscription = outbound.live.listen(values.add);
    subscription.pause();

    hub
      ..add(1)
      ..add(2)
      ..add(3)
      ..add(4);
    expect(overflows, hasLength(1));

    subscription.resume();
    await Future<void>.delayed(Duration.zero);
    expect(values, <int>[3, 4]);

    subscription.pause();
    hub
      ..add(5)
      ..add(6)
      ..add(7);
    expect(overflows, hasLength(2));

    await subscription.cancel();
    await hub.close();
  });

  test(
    'synchronous bursts become bounded as soon as a listener pauses',
    () async {
      final overflows = <AcpOutboundOverflow>[];
      final hub = AcpOutboundHub<int>(capacity: 2, onOverflow: overflows.add);
      final values = <int>[];
      late StreamSubscription<int> subscription;
      subscription = hub.subscribe().live.listen((int value) {
        values.add(value);
        if (value == 1) {
          subscription.pause();
        }
      });
      await Future<void>.delayed(Duration.zero);

      hub
        ..add(1)
        ..add(2)
        ..add(3)
        ..add(4);

      expect(values, <int>[1]);
      expect(overflows, hasLength(1));
      subscription.resume();
      await Future<void>.delayed(Duration.zero);
      expect(values, <int>[1, 3, 4]);

      await subscription.cancel();
      await hub.close();
    },
  );

  test('close is idempotent and later subscribers are done', () async {
    final hub = AcpOutboundHub<int>();
    final outbound = hub.subscribe();
    final done = Completer<void>();
    outbound.live.listen((int _) {}, onDone: done.complete);

    final closing = hub.close();
    expect(hub.close(), same(closing));
    await closing;
    await done.future;

    final after = hub.subscribe();
    expect(after.replay, isEmpty);
    expect(await after.live.toList(), isEmpty);
  });

  test('close does not wait for a paused downstream listener', () async {
    final hub = AcpOutboundHub<int>();
    final subscription = hub.subscribe().live.listen((int _) {})..pause();

    await hub.close();
    expect(hub.isClosed, isTrue);

    await subscription.cancel();
  });

  test('a throwing overflow diagnostic cannot interrupt queueing', () async {
    final hub = AcpOutboundHub<int>(
      capacity: 1,
      onOverflow: (_) => throw StateError('diagnostic failed'),
    );
    final values = <int>[];
    final subscription = hub.subscribe().live.listen(values.add)..pause();

    hub
      ..add(1)
      ..add(2);
    subscription.resume();
    await Future<void>.delayed(Duration.zero);

    expect(values, <int>[2]);
    await subscription.cancel();
    await hub.close();
  });

  test('rejects nonpositive capacity', () {
    expect(() => AcpOutboundHub<int>(capacity: 0), throwsArgumentError);
    expect(() => AcpOutboundHub<int>(capacity: -1), throwsArgumentError);
  });
}
