/// Explicit opt-in surface for ACP v2 unstable-overlay models and methods.
///
/// Import this library with a prefix alongside `experimental/v2.dart`, then
/// call `withV2UnstableMethods()` on each app that uses overlay descriptors.
library;

import '../src/application/v2/application.dart';
import '../src/protocol/v2/generated/unstable/method_descriptors.dart';

export '../src/protocol/v2/generated/unstable/protocol.dart';

/// Enables registration and sending of generated v2 unstable methods.
extension AcpV2UnstableAgentApp on AcpV2AgentApp {
  /// Returns an immutable app with overlay descriptors and the runtime gate.
  AcpV2AgentApp withV2UnstableMethods() => withOptions(
    options.copyWith(allowUnstableMethods: true),
  ).withProtocolDescriptors(v2UnstableMethodDescriptors);
}

/// Enables registration and sending of generated v2 unstable methods.
extension AcpV2UnstableClientApp on AcpV2ClientApp {
  /// Returns an immutable app with overlay descriptors and the runtime gate.
  AcpV2ClientApp withV2UnstableMethods() => withOptions(
    options.copyWith(allowUnstableMethods: true),
  ).withProtocolDescriptors(v2UnstableMethodDescriptors);
}
