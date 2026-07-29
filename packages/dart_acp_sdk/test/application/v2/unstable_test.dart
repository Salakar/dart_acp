import 'package:dart_acp_sdk/experimental/v2.dart' as v2;
import 'package:dart_acp_sdk/experimental/v2_unstable.dart' as unstable;
import 'package:test/test.dart';

void main() {
  test('unstable descriptors require both overlay import and app gate', () {
    final base = v2.AcpV2AgentApp(
      implementation: v2.Implementation(name: 'agent', version: '1'),
      capabilities: v2.AgentCapabilities(),
    );
    expect(
      () => base.onNotification(unstable.documentDidOpenMethod, (_) {}),
      throwsA(isA<v2.AcpV2ConnectionStateException>()),
    );

    final enabled = base.withV2UnstableMethods().onNotification(
      unstable.documentDidOpenMethod,
      (_) {},
    );
    expect(enabled.options.allowUnstableMethods, isTrue);
  });
}
