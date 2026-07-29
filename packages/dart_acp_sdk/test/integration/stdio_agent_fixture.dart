import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';
import 'package:dart_acp_sdk/src/transport/stdio.dart';

Future<void> main() async {
  final AcpAgentApp app =
      AcpAgentApp.v1(
        implementation: Implementation(name: 'stdio-agent', version: '1.0.0'),
        capabilities: AgentCapabilities.decode(<String, Object?>{}).value,
      ).onNewSession(
        (_) => NewSessionResponse(sessionId: SessionId('stdio-session')),
      );
  final AcpAgentConnection connection = app.connect(
    AcpStdioTransport.connect(),
  );
  await connection.closed;
}
