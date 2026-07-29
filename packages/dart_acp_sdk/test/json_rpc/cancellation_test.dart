import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:test/test.dart';

void main() {
  test('cancellation callbacks are synchronous and idempotent', () async {
    final CancellationSource source = CancellationSource();
    final List<Object?> reasons = <Object?>[];
    source.token.register(reasons.add);

    source.cancel('first');
    source.cancel('second');

    expect(reasons, <Object?>['first']);
    expect(source.token.isCancelled, isTrue);
    expect(await source.token.whenCancelled, 'first');
    expect(
      source.token.throwIfCancelled,
      throwsA(isA<CancellationException>()),
    );
  });

  test(
    'registrations can be removed and late registrations run immediately',
    () {
      final CancellationSource source = CancellationSource();
      final List<Object?> reasons = <Object?>[];
      final CancellationRegistration registration = source.token.register(
        reasons.add,
      );
      registration.dispose();

      source.cancel(42);
      source.token.register(reasons.add);

      expect(reasons, <Object?>[42]);
    },
  );
}
