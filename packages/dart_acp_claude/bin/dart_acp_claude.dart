import 'dart:io';

import 'package:dart_acp_claude/src/runtime/cli.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await runDartAcpClaude(arguments);
}
