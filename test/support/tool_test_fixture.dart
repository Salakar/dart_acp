import 'dart:io';

/// Creates one isolated filesystem fixture for a tool-process test.
Directory temporaryDirectory() =>
    Directory.systemTemp.createTempSync('dart_acp_sdk_tools_');

/// Writes [count] placeholder lines at [relativePath].
File writeLines(Directory root, String relativePath, int count) {
  final file = fixtureFile(root, relativePath);
  file.writeAsStringSync(List<String>.filled(count, 'line').join('\n'));
  return file;
}

/// Writes exact [contents] at [relativePath].
File writeSource(Directory root, String relativePath, String contents) {
  final file = fixtureFile(root, relativePath);
  file.writeAsStringSync(contents);
  return file;
}

/// Writes a single-source LCOV report for [source].
File writeLcov(
  Directory root, {
  required File source,
  required List<int> lineHits,
  String name = 'lcov.info',
}) {
  final lcov = fixtureFile(root, 'coverage/$name');
  final records = <String>['SF:${source.path}'];
  for (var index = 0; index < lineHits.length; index += 1) {
    records.add('DA:${index + 1},${lineHits[index]}');
  }
  records.add('end_of_record');
  lcov.writeAsStringSync('${records.join('\n')}\n');
  return lcov;
}

/// Resolves and creates the parent directory for a fixture file.
File fixtureFile(Directory root, String relativePath) {
  final file = File(
    '${root.path}${Platform.pathSeparator}'
    '${relativePath.replaceAll('/', Platform.pathSeparator)}',
  );
  file.parent.createSync(recursive: true);
  return file;
}
