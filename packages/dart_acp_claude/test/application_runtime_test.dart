import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

void main() {
  test('builds and closes a reusable in-process application', () async {
    final agent = ClaudeAcpAgent(
      environment: ClaudeAcpEnvironment(variables: const <String, String>{}),
    );
    final app = buildClaudeAcpApp(agent);
    expect(app, same(agent.app));

    final client = AcpClientApp.v1(
      implementation: Implementation(name: 'runtime-test', version: '1'),
      capabilities: ClientCapabilities.fromJson(<String, Object?>{
        'fs': <String, Object?>{'readTextFile': false, 'writeTextFile': false},
        'terminal': false,
      }),
    );
    final pair = await client.connectWith(app);
    final result = ClaudeAcpRunResult(connection: pair.agent, agent: agent);

    await result.close();
    await pair.client.closed;
    await pair.close();
  });
}
