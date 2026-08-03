@TestOn('vm')
library;

import 'dart:io';

import 'package:dart_acp_antigravity/dart_acp_antigravity.dart';
import 'package:test/test.dart';

void main() {
  test(
    'prompts the installed Antigravity CLI',
    () async {
      final AntigravityAcpClient client = await AntigravityAcpClient.start();
      try {
        expect(client.connection.lifecycle.isReady, isTrue);
        final AcpActiveSession session = await client.agent
            .newSession(cwd: AcpAbsolutePath(Directory.current.path))
            .start()
            .timeout(const Duration(seconds: 20));
        final AcpCollectedText result = await session
            .prompt(
              content: <ContentBlock>[
                ContentBlockText(
                  TextContent(text: 'Say exactly: hello. Nothing else.'),
                ),
              ],
            )
            .collectText()
            .timeout(const Duration(minutes: 3));
        expect(result.text.toLowerCase(), contains('hello'));
        expect(result.response.stopReason, StopReason.endTurn);
        session.dispose();
      } finally {
        await client.close();
      }
    },
    skip: Platform.environment['DART_ACP_LIVE_TESTS'] == 'true'
        ? false
        : 'Set DART_ACP_LIVE_TESTS=true to use the installed Antigravity CLI.',
  );
}
