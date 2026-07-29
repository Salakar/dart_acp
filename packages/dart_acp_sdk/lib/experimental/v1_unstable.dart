/// Explicit opt-in surface for ACP v1 unstable schema methods and models.
///
/// Import this library with a prefix alongside the stable package entrypoint:
///
/// ```dart
/// import 'package:dart_acp_sdk/dart_acp_sdk.dart';
/// import 'package:dart_acp_sdk/experimental/v1_unstable.dart' as unstable;
/// ```
library;

import '../src/application/application.dart';
import '../src/protocol/v1/generated/unstable/method_descriptors.dart';

export '../src/protocol/v1/generated/unstable/protocol.dart';

/// Enables registration and sending of generated v1 unstable methods.
extension AcpV1UnstableAgentApp on AcpAgentApp {
  /// Returns an immutable app copy with the unstable registry and gate enabled.
  AcpAgentApp withV1UnstableMethods() => withOptions(
    options.copyWith(allowUnstableMethods: true),
  ).withProtocolDescriptors(v1UnstableMethodDescriptors);
}

/// Enables registration and sending of generated v1 unstable methods.
extension AcpV1UnstableClientApp on AcpClientApp {
  /// Returns an immutable app copy with the unstable registry and gate enabled.
  AcpClientApp withV1UnstableMethods() => withOptions(
    options.copyWith(allowUnstableMethods: true),
  ).withProtocolDescriptors(v1UnstableMethodDescriptors);
}
