@TestOn('vm')
library;

import 'dart:io';

import 'package:dart_acp_gemini/dart_acp_gemini.dart';
import 'package:test/test.dart';

void main() {
  test(
    'initializes the installed Gemini ACP server',
    () async {
      final GeminiAcpClient client = await GeminiAcpClient.start(
        options: GeminiAcpClientOptions(
          workingDirectory: Directory.current.path,
        ),
      );
      try {
        expect(client.connection.lifecycle.isReady, isTrue);
        expect(
          client.arguments,
          anyOf(
            equals(const <String>['--acp']),
            equals(const <String>['--experimental-acp']),
          ),
        );
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
        : 'Set DART_ACP_LIVE_TESTS=true to use the installed Gemini CLI.',
  );
}
