import 'dart:io';

/// Thrown when an OpenCode executable cannot be discovered.
final class OpenCodeExecutableNotFoundException implements Exception {
  /// Creates an executable discovery error.
  const OpenCodeExecutableNotFoundException(this.message);

  /// Actionable error description.
  final String message;

  @override
  String toString() => 'OpenCodeExecutableNotFoundException: $message';
}

/// Finds an OpenCode executable on Windows, macOS, or Linux.
///
/// Resolution checks `OPENCODE_EXECUTABLE`, `PATH`, documented OpenCode
/// install directories, and common package-manager locations, in that order.
/// The optional [fileExists] hook supports virtual file systems and tests.
String findOpenCodeExecutable({
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
    'OPENCODE_EXECUTABLE',
    windows: isWindows,
  );
  if (configured != null && configured.trim().isNotEmpty) {
    final String candidate = _unquote(configured.trim());
    if (exists(candidate)) {
      return candidate;
    }
  }

  final List<String> names = isWindows
      ? const <String>[
          'opencode.exe',
          'opencode.com',
          'opencode.cmd',
          'opencode.bat',
        ]
      : const <String>['opencode'];
  for (final String candidate in _executableCandidates(
    values,
    names: names,
    windows: isWindows,
  )) {
    if (exists(candidate)) {
      return candidate;
    }
  }

  throw const OpenCodeExecutableNotFoundException(
    'OpenCode was not found. Install the OpenCode CLI, add it to PATH, set '
    'OPENCODE_EXECUTABLE, or pass OpenCodeAcpClientOptions(executable: ...).',
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
  final String? installDirectory = _environmentValue(
    environment,
    'OPENCODE_INSTALL_DIR',
    windows: windows,
  );
  final String? xdgBinDirectory = _environmentValue(
    environment,
    'XDG_BIN_DIR',
    windows: windows,
  );
  if (installDirectory != null && installDirectory.trim().isNotEmpty) {
    yield _unquote(installDirectory.trim());
  }
  if (xdgBinDirectory != null && xdgBinDirectory.trim().isNotEmpty) {
    yield _unquote(xdgBinDirectory.trim());
  }

  if (windows) {
    final String? appData = _environmentValue(
      environment,
      'APPDATA',
      windows: true,
    );
    final String? localAppData = _environmentValue(
      environment,
      'LOCALAPPDATA',
      windows: true,
    );
    final String? scoop = _environmentValue(
      environment,
      'SCOOP',
      windows: true,
    );
    final String? chocolatey = _environmentValue(
      environment,
      'ChocolateyInstall',
      windows: true,
    );
    if (scoop != null) {
      yield _join(scoop, 'shims', windows: true);
    }
    if (home != null) {
      yield _join(_join(home, 'scoop', windows: true), 'shims', windows: true);
      yield _join(
        _join(home, '.opencode', windows: true),
        'bin',
        windows: true,
      );
    }
    if (localAppData != null) {
      yield _join(
        _join(
          _join(localAppData, 'Microsoft', windows: true),
          'WinGet',
          windows: true,
        ),
        'Links',
        windows: true,
      );
    }
    if (chocolatey != null) {
      yield _join(chocolatey, 'bin', windows: true);
    }
    if (appData != null) {
      yield _join(appData, 'npm', windows: true);
    }
    return;
  }

  if (home != null) {
    yield _join(home, 'bin', windows: false);
    yield _join(
      _join(home, '.opencode', windows: false),
      'bin',
      windows: false,
    );
    yield _join(_join(home, '.local', windows: false), 'bin', windows: false);
    yield _join(
      _join(home, '.npm-global', windows: false),
      'bin',
      windows: false,
    );
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
