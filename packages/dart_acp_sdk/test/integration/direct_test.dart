import 'dart:async';

import 'package:dart_acp_sdk/src/transport/in_process.dart';
import 'package:test/test.dart';

void main() {
  test(
    'in-process transport preserves order and bounds queued writes',
    () async {
      final AcpInProcessTransportPair<int> pair =
          acpInProcessTransportPair<int>(maximumBufferedMessages: 2);
      final Future<void> first = pair.left.writable.write(1);
      final Future<void> second = pair.left.writable.write(2);

      await expectLater(pair.left.writable.write(3), throwsStateError);
      final List<int> received = <int>[];
      final StreamSubscription<int> subscription = pair.right.readable.listen(
        received.add,
      );
      final Future<void> done = subscription.asFuture<void>();
      await Future.wait<void>(<Future<void>>[first, second]);
      await Future<void>.delayed(Duration.zero);

      expect(received, <int>[1, 2]);
      await pair.left.writable.close();
      await done;
      await subscription.cancel();
      await pair.right.writable.close();
    },
  );

  test('closing an unused endpoint is deterministic', () async {
    final AcpInProcessTransportPair<Object?> pair =
        acpInProcessTransportPair<Object?>();
    await pair.left.writable.close().timeout(const Duration(seconds: 1));
    await pair.right.writable.close().timeout(const Duration(seconds: 1));
  });
}
