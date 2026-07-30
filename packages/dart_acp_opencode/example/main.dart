import 'dart:io';

import 'package:dart_acp_opencode/dart_acp_opencode.dart';

Future<void> main() async {
  final OpenCodeAcpClient client = await OpenCodeAcpClient.start();
  try {
    final AcpActiveSession session = await client.agent
        .newSession(cwd: AcpAbsolutePath(Directory.current.path))
        .start();
    try {
      final AcpCollectedText result = await session
          .prompt(
            content: <ContentBlock>[
              ContentBlockText(
                TextContent(text: 'Briefly describe this project.'),
              ),
            ],
          )
          .collectText();
      stdout.writeln(result.text);
    } finally {
      session.dispose();
    }
  } finally {
    await client.close();
  }
}
