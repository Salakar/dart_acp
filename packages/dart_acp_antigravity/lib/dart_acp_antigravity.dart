/// A Dart ACP adapter for the Antigravity CLI (`agy`).
///
/// The adapter exposes headless Antigravity print-mode conversations as an
/// Agent Client Protocol agent. Use [AntigravityAcpClient] for the quickest
/// path to a connected client, or embed [AntigravityAcpAgent] behind a custom
/// ACP transport.
library;

export 'package:dart_acp_sdk/dart_acp_sdk.dart';

export 'src/agent.dart';
export 'src/cli.dart';
export 'src/client.dart';
export 'src/event_mapper.dart';
export 'src/events.dart';
export 'src/executable.dart';
export 'src/options.dart';
