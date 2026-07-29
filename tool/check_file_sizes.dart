import 'dart:io';

const int _defaultSourceGuideline = 750;
const int _defaultTestGuideline = 250;
const String _generatedCodeMarker = '// GENERATED CODE - DO NOT MODIFY BY HAND';
const Set<String> _ignoredDirectories = <String>{
  '.dart_tool',
  '.git',
  '.melos_tool',
  'build',
  'coverage',
};

/// Reports repository Dart files that exceed the documented size guidelines.
void main(List<String> arguments) {
  final options = _FileSizeOptions.parse(arguments);
  if (options == null) {
    exitCode = 64;
    return;
  }
  if (options.showHelp) {
    _printUsage();
    return;
  }

  final root = Directory(options.root).absolute;
  if (!root.existsSync()) {
    stderr.writeln('Repository root does not exist: ${root.path}');
    exitCode = 66;
    return;
  }

  final checkedFiles = _collectCheckedFiles(root);
  final advisories = <_SizeAdvisory>[];
  var enforcedFileCount = 0;
  for (final file in checkedFiles) {
    final relativePath = _relativePath(root, file);
    final contents = file.readAsStringSync();
    if (_isMachineGenerated(contents)) {
      continue;
    }
    enforcedFileCount += 1;
    final isTest = _isTestFile(relativePath);
    final guideline = isTest ? options.testGuideline : options.sourceGuideline;
    final lineCount = _countLines(contents);
    if (lineCount > guideline) {
      advisories.add(
        _SizeAdvisory(
          relativePath: relativePath,
          lineCount: lineCount,
          guideline: guideline,
          category: isTest ? 'test' : 'source',
        ),
      );
    }
  }

  if (advisories.isNotEmpty) {
    stdout.writeln('Dart file-size guidance advisories:');
    for (final advisory in advisories) {
      stdout.writeln(
        '  ${advisory.relativePath}: ${advisory.lineCount} lines '
        '(${advisory.category} guideline: ${advisory.guideline})',
      );
    }
  }

  stdout.writeln(
    'File-size guidance checked for $enforcedFileCount handwritten Dart files '
    '(suggested source <= ${options.sourceGuideline}, '
    'tests <= ${options.testGuideline}; generated files exempt; '
    '${advisories.length} advisory overage(s)).',
  );
}

List<File> _collectCheckedFiles(Directory root) {
  final files = <File>[];
  final pending = <Directory>[root];
  while (pending.isNotEmpty) {
    final directory = pending.removeLast();
    final entries = directory.listSync(followLinks: false)
      ..sort((left, right) => left.path.compareTo(right.path));
    for (final entry in entries) {
      if (entry is Directory) {
        final name = _basename(entry.path);
        final isIgnoredClone =
            directory.path == root.path && name.endsWith('_clone');
        if (!_ignoredDirectories.contains(name) && !isIgnoredClone) {
          pending.add(entry);
        }
        continue;
      }
      if (entry is! File || !entry.path.endsWith('.dart')) {
        continue;
      }
      final relativePath = _relativePath(root, entry);
      if (_isCheckedPath(relativePath)) {
        files.add(entry);
      }
    }
  }
  files.sort((left, right) => left.path.compareTo(right.path));
  return files;
}

bool _isCheckedPath(String path) {
  final segments = path.split('/');
  return segments.contains('lib') ||
      segments.contains('test') ||
      segments.contains('tool') ||
      segments.contains('example') ||
      segments.contains('benchmark');
}

bool _isTestFile(String path) {
  final segments = path.split('/');
  return segments.contains('test') || path.endsWith('_test.dart');
}

bool _isMachineGenerated(String contents) =>
    contents.startsWith(_generatedCodeMarker);

int _countLines(String contents) {
  if (contents.isEmpty) {
    return 0;
  }
  final newlineCount = '\n'.allMatches(contents).length;
  return contents.endsWith('\n') ? newlineCount : newlineCount + 1;
}

String _relativePath(Directory root, FileSystemEntity entity) {
  final offset = root.path.endsWith(Platform.pathSeparator)
      ? root.path.length
      : root.path.length + 1;
  return entity.path.substring(offset).replaceAll(Platform.pathSeparator, '/');
}

String _basename(String path) {
  final normalized = path.endsWith(Platform.pathSeparator)
      ? path.substring(0, path.length - 1)
      : path;
  return normalized.split(Platform.pathSeparator).last;
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run tool/check_file_sizes.dart '
    '[--root=<directory>] [--source-limit=750] [--test-limit=250]',
  );
}

final class _FileSizeOptions {
  const _FileSizeOptions({
    required this.root,
    required this.sourceGuideline,
    required this.testGuideline,
    required this.showHelp,
  });

  final String root;
  final int sourceGuideline;
  final int testGuideline;
  final bool showHelp;

  static _FileSizeOptions? parse(List<String> arguments) {
    var root = '.';
    var sourceGuideline = _defaultSourceGuideline;
    var testGuideline = _defaultTestGuideline;
    var showHelp = false;

    for (final argument in arguments) {
      if (argument == '--help' || argument == '-h') {
        showHelp = true;
      } else if (argument.startsWith('--root=')) {
        root = argument.substring('--root='.length);
      } else if (argument.startsWith('--source-limit=')) {
        final value = argument.substring('--source-limit='.length);
        sourceGuideline = int.tryParse(value) ?? -1;
      } else if (argument.startsWith('--test-limit=')) {
        final value = argument.substring('--test-limit='.length);
        testGuideline = int.tryParse(value) ?? -1;
      } else {
        stderr.writeln('Unknown argument: $argument');
        _printUsage();
        return null;
      }
    }

    if (sourceGuideline < 1 || testGuideline < 1) {
      stderr.writeln('File-size guidelines must be positive integers.');
      return null;
    }
    return _FileSizeOptions(
      root: root,
      sourceGuideline: sourceGuideline,
      testGuideline: testGuideline,
      showHelp: showHelp,
    );
  }
}

final class _SizeAdvisory {
  const _SizeAdvisory({
    required this.relativePath,
    required this.lineCount,
    required this.guideline,
    required this.category,
  });

  final String relativePath;
  final int lineCount;
  final int guideline;
  final String category;
}
