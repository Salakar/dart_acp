@TestOn('vm')
library;

import 'dart:io';

import 'package:dart_acp_opencode/dart_acp_opencode.dart';
import 'package:test/test.dart';

void main() {
  test(
    'initializes the installed OpenCode ACP server',
    () async {
      final OpenCodeAcpClient client = await OpenCodeAcpClient.start(
        options: OpenCodeAcpClientOptions(
          workingDirectory: Directory.current.path,
        ),
      );
      try {
        expect(client.connection.lifecycle.isReady, isTrue);
        expect(client.arguments, const <String>['acp']);
        final AcpActiveSession session = await client.agent
            .newSession(cwd: AcpAbsolutePath(Directory.current.path))
            .start()
            .timeout(const Duration(seconds: 20));
        expect(session.sessionId.value, isNotEmpty);
        session.dispose();
      } finally {
        await client.close();
      }
    },
    skip: Platform.environment['DART_ACP_LIVE_TESTS'] == 'true'
        ? false
        : 'Set DART_ACP_LIVE_TESTS=true to use the installed OpenCode CLI.',
  );
}
