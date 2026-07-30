import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

void main() {
  test('starts a ready typed client and closes idempotently', () async {
    final ClaudeAcpClient client = await ClaudeAcpClient.start(
      options: ClaudeAcpClientOptions(maximumQueuedPrompts: 8),
      environment: ClaudeAcpEnvironment(variables: const <String, String>{}),
    );

    expect(client.connection.lifecycle.isReady, isTrue);
    expect(client.agent, same(client.connection.agent));
    expect(client.adapter.sessionCount, 0);

    await client.close();
    await client.close();
    await client.closed;
  });
}
