/// Dual-version first-initialize router for ACP agent applications.
library;

import 'dart:async';

import '../../application/application.dart';
import '../../application/v2/application.dart';
import '../../json_rpc/codec.dart';
import '../../json_rpc/error.dart';
import '../../transport/duplex_stream.dart';
import '../v1/generated/unstable/models.dart' as v1;
import '../v2/generated/unstable/models.dart' as v2;

part 'lifecycle.dart';
part 'rewrite.dart';
part 'routing.dart';

/// Routes an incoming transport to the requested or latest configured agent.
final class AcpProtocolRouter {
  /// Creates a router with optional protocol implementations.
  AcpProtocolRouter({AcpAgentApp? v1, AcpV2AgentApp? v2}) : _v1 = v1, _v2 = v2;

  AcpAgentApp? _v1;
  AcpV2AgentApp? _v2;

  /// Configures the stable-v1 agent.
  AcpProtocolRouter withV1(AcpAgentApp agent) {
    _v1 = agent;
    return this;
  }

  /// Configures the draft-v2 agent.
  AcpProtocolRouter withV2(AcpV2AgentApp agent) {
    _v2 = agent;
    return this;
  }

  /// Routes one transport after consuming and validating its first frame.
  AcpRoutedAgentConnection connect(
    AcpDuplexStream<Object?> stream, {
    AcpProtocolRouterConnectOptions options =
        const AcpProtocolRouterConnectOptions(),
  }) {
    final connection = AcpRoutedAgentConnection._(
      startRequested: !options.deferConnectHandlers,
      closeDestination: stream.writable.close,
    );
    unawaited(
      _route(stream, connection).catchError((Object error, StackTrace _) async {
        await connection._closeOutput();
        connection._finish();
      }),
    );
    return connection;
  }

  int? _negotiatedVersion(int requested) {
    if (_v2 != null && requested == 2) {
      return 2;
    }
    if (_v1 != null && requested == 1) {
      return 1;
    }
    if (_v2 != null) {
      return 2;
    }
    if (_v1 != null) {
      return 1;
    }
    return null;
  }

  String _supportedDescription() {
    if (_v1 != null && _v2 != null) {
      return 'ACP protocol versions 1 and 2';
    }
    if (_v1 != null) {
      return 'ACP protocol version 1';
    }
    if (_v2 != null) {
      return 'ACP protocol version 2';
    }
    return 'no ACP protocol versions';
  }
}

/// Creates an empty dual-version agent router.
AcpProtocolRouter acpProtocolRouter() => AcpProtocolRouter();
