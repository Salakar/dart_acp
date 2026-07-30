import 'dart:io';

import 'package:dart_acp_codex/src/runtime/cli.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await runCodexAdapter(arguments);
}
