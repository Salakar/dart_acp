import 'package:dart_acp_codex/dart_acp_codex.dart';
import 'package:test/test.dart';

import 'helpers/fake_backend.dart';

void main() {
  test('starts a ready typed client and closes idempotently', () async {
    final FakeCodexBackend backend = FakeCodexBackend();
    final CodexAcpClient client = await CodexAcpClient.start(
      backend: backend,
      options: CodexAcpClientOptions(environment: const <String, String>{}),
    );

    expect(client.connection.lifecycle.isReady, isTrue);
    expect(client.agent, same(client.connection.agent));
    expect(client.adapter, isA<CodexAgent>());
    expect(client.runtime.options.environment, isEmpty);
    expect(backend.count('initialize'), 1);
    expect(backend.count('model/list'), 1);

    await client.close();
    await client.close();
    await client.closed;
    expect(backend.isClosed, isTrue);
    expect(await client.exitCode, 0);
  });
}
