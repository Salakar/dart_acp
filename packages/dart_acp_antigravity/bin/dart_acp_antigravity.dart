import 'dart:io';

import 'package:dart_acp_antigravity/src/cli.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await runAntigravityAdapter(arguments);
}
