import 'dart:io';

import 'src/chrome_test_runner.dart';

Future<void> main(List<String> arguments) async {
  try {
    exitCode = await runChromeTestSuite(arguments);
  } on Object catch (error, stackTrace) {
    stderr
      ..writeln('Chrome test runner failed: $error')
      ..writeln(stackTrace);
    exitCode = 1;
  }
}
