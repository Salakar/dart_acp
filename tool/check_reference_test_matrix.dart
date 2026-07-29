import 'dart:io';

import 'src/reference_test_matrix.dart';

void main(List<String> arguments) {
  var repositoryRoot = Directory.current;
  File? matrixFile;
  for (final argument in arguments) {
    if (argument.startsWith('--root=')) {
      repositoryRoot = Directory(argument.substring('--root='.length));
    } else if (argument.startsWith('--matrix=')) {
      matrixFile = File(argument.substring('--matrix='.length));
    } else {
      stderr.writeln('Unknown argument: $argument');
      exitCode = 64;
      return;
    }
  }

  final result = verifyReferenceTestMatrix(
    repositoryRoot: repositoryRoot.absolute,
    matrixFile: matrixFile,
  );
  if (!result.isValid) {
    for (final error in result.errors) {
      stderr.writeln(error);
    }
    exitCode = 1;
    return;
  }
  final counts = result.dispositionCounts.entries
      .map((entry) => '${entry.key}=${entry.value}')
      .join(', ');
  stdout.writeln(
    'Reference test matrix verified: $referenceTestCaseCount direct cases, '
    '$referenceParameterizedDeclarationCount parameterized declarations, '
    '${result.targetCount} Dart targets ($counts).',
  );
}
