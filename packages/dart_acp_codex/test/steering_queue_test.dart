import 'dart:async';

import 'package:dart_acp_codex/src/session/steering_queue.dart';
import 'package:test/test.dart';

void main() {
  test('steering queue serializes and isolates failures', () async {
    var running = 0;
    var maximumRunning = 0;
    final order = <int>[];
    final queue = CodexSteeringQueue<int>((value) async {
      running += 1;
      maximumRunning = maximumRunning < running ? running : maximumRunning;
      order.add(value);
      await Future<void>.delayed(Duration.zero);
      running -= 1;
      if (value == 2) {
        throw StateError('expected');
      }
      return const CodexSteeringInjected();
    });

    expect(queue.isIdle, isTrue);
    final first = queue.enqueue(1);
    final failed = queue.enqueue(2);
    final third = queue.enqueue(3);
    expect(queue.isIdle, isFalse);

    expect(await first, isA<CodexSteeringInjected>());
    await expectLater(failed, throwsStateError);
    expect(await third, isA<CodexSteeringInjected>());
    expect(order, <int>[1, 2, 3]);
    expect(maximumRunning, 1);
    expect(queue.isIdle, isTrue);
  });
}
