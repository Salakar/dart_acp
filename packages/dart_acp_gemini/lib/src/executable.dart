import 'dart:io';

/// Thrown when a Gemini CLI executable cannot be discovered.
final class GeminiExecutableNotFoundException implements Exception {
  /// Creates an executable discovery error.
  const GeminiExecutableNotFoundException(this.message);

  /// Actionable error description.
  final String message;

  @override
  String toString() => 'GeminiExecutableNotFoundException: $message';
}

/// Finds a Gemini CLI executable on Windows, macOS, or Linux.
///
/// Resolution checks `GEMINI_EXECUTABLE`, `PATH`, common npm locations, and
/// common system package-manager locations, in that order. The optional
/// [fileExists] hook supports virtual file systems and tests.
String findGeminiExecutable({
  Map<String, String>? environment,
  bool? windows,
  bool Function(String path)? fileExists,
}) {
  final Map<String, String> values = environment ?? Platform.environment;
  final bool isWindows = windows ?? Platform.isWindows;
  final bool Function(String path) exists =
      fileExists ?? (String path) => File(path).existsSync();
  final String? configured = _environmentValue(
    values,
    'GEMINI_EXECUTABLE',
    windows: isWindows,
  );
  if (configured != null && configured.trim().isNotEmpty) {
    final String candidate = _unquote(configured.trim());
    if (exists(candidate)) {
      return candidate;
    }
  }

  final List<String> names = isWindows
      ? const <String>['gemini.exe', 'gemini.com', 'gemini.cmd', 'gemini.bat']
      : const <String>['gemini'];
  for (final String candidate in _executableCandidates(
    values,
    names: names,
    windows: isWindows,
  )) {
    if (exists(candidate)) {
      return candidate;
    }
  }

  throw const GeminiExecutableNotFoundException(
    'Gemini CLI was not found. Install Gemini CLI, add it to PATH, set '
    'GEMINI_EXECUTABLE, or pass GeminiAcpClientOptions(executable: ...).',
  );
}

Iterable<String> _executableCandidates(
  Map<String, String> environment, {
  required List<String> names,
  required bool windows,
}) sync* {
  final Set<String> seen = <String>{};
  final String separator = windows ? ';' : ':';
  final String? path = _environmentValue(environment, 'PATH', windows: windows);
  final List<String> directories = <String>[
    if (path != null)
      for (final String value in path.split(separator))
        if (_unquote(value.trim()).isNotEmpty) _unquote(value.trim()),
    ..._fallbackDirectories(environment, windows: windows),
  ];
  for (final String directory in directories) {
    for (final String name in names) {
      final String candidate = _join(directory, name, windows: windows);
      final String key = windows ? candidate.toLowerCase() : candidate;
      if (seen.add(key)) {
        yield candidate;
      }
    }
  }
}

Iterable<String> _fallbackDirectories(
  Map<String, String> environment, {
  required bool windows,
}) sync* {
  final String? home = _environmentValue(
    environment,
    windows ? 'USERPROFILE' : 'HOME',
    windows: windows,
  );
  final String? npmPrefix = _environmentValue(
    environment,
    'NPM_CONFIG_PREFIX',
    windows: windows,
  );
  if (npmPrefix != null && npmPrefix.trim().isNotEmpty) {
    yield windows
        ? _unquote(npmPrefix.trim())
        : _join(_unquote(npmPrefix.trim()), 'bin', windows: false);
  }

  if (windows) {
    final String? appData = _environmentValue(
      environment,
      'APPDATA',
      windows: true,
    );
    final String? nvmHome = _environmentValue(
      environment,
      'NVM_HOME',
      windows: true,
    );
    final String? scoop = _environmentValue(
      environment,
      'SCOOP',
      windows: true,
    );
    if (appData != null) {
      yield _join(appData, 'npm', windows: true);
    }
    if (nvmHome != null) {
      yield nvmHome;
    }
    if (scoop != null) {
      yield _join(scoop, 'shims', windows: true);
    }
    if (home != null) {
      yield _join(_join(home, 'scoop', windows: true), 'shims', windows: true);
    }
    return;
  }

  if (home != null) {
    yield _join(
      _join(home, '.npm-global', windows: false),
      'bin',
      windows: false,
    );
    yield _join(_join(home, '.local', windows: false), 'bin', windows: false);
    yield _join(
      _join(
        _join(home, 'node_modules', windows: false),
        '.bin',
        windows: false,
      ),
      '',
      windows: false,
    );
    yield _join(_join(home, '.yarn', windows: false), 'bin', windows: false);
  }
  yield '/opt/homebrew/bin';
  yield '/usr/local/bin';
  yield '/usr/bin';
  yield '/opt/local/bin';
}

String? _environmentValue(
  Map<String, String> environment,
  String key, {
  required bool windows,
}) {
  if (!windows) {
    return environment[key];
  }
  final String normalized = key.toLowerCase();
  for (final MapEntry<String, String> entry in environment.entries) {
    if (entry.key.toLowerCase() == normalized) {
      return entry.value;
    }
  }
  return null;
}

String _unquote(String value) {
  if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
    return value.substring(1, value.length - 1);
  }
  return value;
}

String _join(String parent, String child, {required bool windows}) {
  if (child.isEmpty) {
    return parent;
  }
  final String separator = windows ? r'\' : '/';
  if (parent.endsWith('/') || parent.endsWith(r'\')) {
    return '$parent$child';
  }
  return '$parent$separator$child';
}
