import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../agent/claude_acp_agent.dart';
import '../configuration/agent_options.dart';
import '../runtime/contracts.dart';

/// Handles returned after starting the stdio ACP application.
final class ClaudeAcpRunResult {
  /// Creates a run result.
  const ClaudeAcpRunResult({required this.connection, required this.agent});

  /// Live ACP connection.
  final AcpAgentConnection connection;

  /// Agent that owns session resources.
  final ClaudeAcpAgent agent;

  /// Closes the connection and all sessions.
  Future<void> close() async {
    connection.close();
    await agent.dispose();
  }
}

/// Builds a reusable ACP app and returns its owning [agent] through the caller.
AcpAgentApp buildClaudeAcpApp(ClaudeAcpAgent agent) => agent.app;

/// Starts a Claude ACP agent on process stdio.
ClaudeAcpRunResult runClaudeAcpStdio({
  ClaudeAgentClientFactory? clientFactory,
  ClaudeAcpOptions? options,
  ClaudeAcpEnvironment? environment,
  ClaudeAcpLogger logger = const ClaudeAcpStderrLogger(),
}) {
  final agent = ClaudeAcpAgent(
    clientFactory: clientFactory,
    options: options,
    environment: environment,
    logger: logger,
  );
  final connection = agent.app.connect(AcpStdioTransport.connect());
  unawaited(connection.closed.whenComplete(agent.dispose));
  return ClaudeAcpRunResult(connection: connection, agent: agent);
}
