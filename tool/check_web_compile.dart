import 'dart:io';

const String _defaultPackageRoot = 'packages/dart_acp_sdk';
const String _packageName = 'dart_acp_sdk';

/// Compiles every public stable and experimental library with dart2js.
void main(List<String> arguments) {
  final options = _WebCompileOptions.parse(arguments);
  if (options == null) {
    exitCode = 64;
    return;
  }
  if (options.showHelp) {
    _printUsage();
    return;
  }

  final packageRoot = Directory(options.packageRoot).absolute;
  final libraryRoot = Directory(
    '${packageRoot.path}${Platform.pathSeparator}lib',
  );
  if (!libraryRoot.existsSync()) {
    stderr.writeln(
      'Package library directory does not exist: ${libraryRoot.path}',
    );
    exitCode = 66;
    return;
  }

  final entrypoints = _findPublicEntrypoints(libraryRoot);
  if (entrypoints.isEmpty) {
    stderr.writeln('No public Dart libraries found under ${libraryRoot.path}.');
    exitCode = 66;
    return;
  }

  final dartTool = Directory(
    '${packageRoot.path}${Platform.pathSeparator}.dart_tool',
  );
  if (!dartTool.existsSync()) {
    stderr.writeln(
      'Package dependencies are not installed. Run melos bootstrap first.',
    );
    exitCode = 66;
    return;
  }

  final scratch = Directory(
    '${dartTool.path}${Platform.pathSeparator}'
    'web_compile_check_${pid}_${DateTime.now().microsecondsSinceEpoch}',
  )..createSync(recursive: true);
  try {
    final source = File('${scratch.path}${Platform.pathSeparator}main.dart');
    final output = File('${scratch.path}${Platform.pathSeparator}main.js');
    source.writeAsStringSync(_aggregateSource(entrypoints));

    final result = Process.runSync(Platform.resolvedExecutable, <String>[
      '--suppress-analytics',
      'compile',
      'js',
      '--no-minify',
      '--output=${output.path}',
      source.path,
    ], workingDirectory: packageRoot.path);
    if (result.stdout case final String outputText when outputText.isNotEmpty) {
      stdout.write(outputText);
    }
    if (result.stderr case final String errorText when errorText.isNotEmpty) {
      stderr.write(errorText);
    }
    if (result.exitCode != 0) {
      stderr.writeln(
        'Web compilation failed. Public libraries must not expose dart:io; '
        'native adapters require conditional imports and web stubs.',
      );
      exitCode = result.exitCode;
      return;
    }
  } finally {
    if (scratch.existsSync()) {
      scratch.deleteSync(recursive: true);
    }
  }

  stdout.writeln(
    'Web compile check passed for ${entrypoints.length} public libraries.',
  );
}

List<String> _findPublicEntrypoints(Directory libraryRoot) {
  final entrypoints = <String>[];
  for (final entry in libraryRoot.listSync(followLinks: false)) {
    if (entry is File && entry.path.endsWith('.dart')) {
      entrypoints.add(_basename(entry.path));
    }
  }

  final experimentalRoot = Directory(
    '${libraryRoot.path}${Platform.pathSeparator}experimental',
  );
  if (experimentalRoot.existsSync()) {
    for (final entry in experimentalRoot.listSync(followLinks: false)) {
      if (entry is File && entry.path.endsWith('.dart')) {
        entrypoints.add('experimental/${_basename(entry.path)}');
      }
    }
  }
  entrypoints.sort();
  return entrypoints;
}

String _aggregateSource(List<String> entrypoints) {
  final imports = <String>[];
  for (var index = 0; index < entrypoints.length; index += 1) {
    imports.add(
      "import 'package:$_packageName/${entrypoints[index]}' as surface$index;",
    );
  }
  return '${imports.join('\n')}\n\nvoid main() {}\n';
}

String _basename(String path) {
  return path.split(Platform.pathSeparator).last;
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run tool/check_web_compile.dart '
    '[--package-root=packages/dart_acp_sdk]',
  );
}

final class _WebCompileOptions {
  const _WebCompileOptions({required this.packageRoot, required this.showHelp});

  final String packageRoot;
  final bool showHelp;

  static _WebCompileOptions? parse(List<String> arguments) {
    var packageRoot = _defaultPackageRoot;
    var showHelp = false;
    for (final argument in arguments) {
      if (argument == '--help' || argument == '-h') {
        showHelp = true;
      } else if (argument.startsWith('--package-root=')) {
        packageRoot = argument.substring('--package-root='.length);
      } else {
        stderr.writeln('Unknown argument: $argument');
        _printUsage();
        return null;
      }
    }
    if (packageRoot.isEmpty) {
      stderr.writeln('Package root must not be empty.');
      return null;
    }
    return _WebCompileOptions(packageRoot: packageRoot, showHelp: showHelp);
  }
}
