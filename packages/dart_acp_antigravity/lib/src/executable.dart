import 'dart:io';

/// Thrown when an Antigravity CLI executable cannot be discovered.
final class AntigravityExecutableNotFoundException implements Exception {
  /// Creates an executable discovery error.
  const AntigravityExecutableNotFoundException(this.message);

  /// Actionable error description.
  final String message;

  @override
  String toString() => 'AntigravityExecutableNotFoundException: $message';
}

/// Finds an Antigravity CLI (`agy`) executable on Windows, macOS, or Linux.
///
/// Resolution checks `ANTIGRAVITY_EXECUTABLE`, `PATH`, the official installer
/// location (`~/.local/bin`), and common system package-manager locations, in
/// that order. The optional [fileExists] hook supports virtual file systems
/// and tests.
String findAntigravityExecutable({
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
    'ANTIGRAVITY_EXECUTABLE',
    windows: isWindows,
  );
  if (configured != null && configured.trim().isNotEmpty) {
    final String candidate = _unquote(configured.trim());
    if (exists(candidate)) {
      return candidate;
    }
  }

  final List<String> names = isWindows
      ? const <String>['agy.exe', 'agy.com', 'agy.cmd', 'agy.bat']
      : const <String>['agy'];
  for (final String candidate in _executableCandidates(
    values,
    names: names,
    windows: isWindows,
  )) {
    if (exists(candidate)) {
      return candidate;
    }
  }

  throw const AntigravityExecutableNotFoundException(
    'Antigravity CLI was not found. Install the Antigravity CLI, add agy to '
    'PATH, set ANTIGRAVITY_EXECUTABLE, or pass '
    'AntigravityAcpOptions(executable: ...).',
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
  if (windows) {
    final String? localAppData = _environmentValue(
      environment,
      'LOCALAPPDATA',
      windows: true,
    );
    if (localAppData != null) {
      yield _join(
        _join(localAppData, 'Programs', windows: true),
        'agy',
        windows: true,
      );
    }
    if (home != null) {
      yield _join(_join(home, '.local', windows: true), 'bin', windows: true);
    }
    return;
  }

  if (home != null) {
    // The official installer places agy in ~/.local/bin.
    yield _join(_join(home, '.local', windows: false), 'bin', windows: false);
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
