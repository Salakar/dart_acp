import 'dart:io';
import 'dart:math';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';

/// Creates a connected or connectable Claude client for [options].
typedef ClaudeAgentClientFactory =
    Future<ClaudeAgentClient> Function(ClaudeAgentOptions options);

/// Returns the current wall-clock time.
typedef ClaudeAcpClock = DateTime Function();

/// Returns a fresh session identifier.
typedef ClaudeAcpIdGenerator = String Function();

/// Looks up persisted metadata for one Claude session.
typedef ClaudeSessionInfoLookup =
    SessionInfo? Function(String sessionId, {String? directory});

/// Deletes one persisted Claude session.
typedef ClaudeSessionDelete =
    void Function(String sessionId, {String? directory});

/// Resolves settings for a working directory and process environment.
typedef ClaudeSettingsResolver =
    Future<ClaudeResolvedSettings> Function(
      String workingDirectory,
      Map<String, String> environment,
    );

/// Clears credentials owned by the native Claude runtime.
typedef ClaudeLogoutRunner =
    Future<int> Function(
      ClaudeAgentOptions options,
      Map<String, String> environment,
    );

/// Receives diagnostic messages without contaminating ACP output.
abstract interface class ClaudeAcpLogger {
  /// Records an informational [message].
  void log(String message);

  /// Records a failure [message], optionally with its [error] and [stackTrace].
  void error(String message, {Object? error, StackTrace? stackTrace});
}

/// A logger that writes diagnostics to process stderr.
final class ClaudeAcpStderrLogger implements ClaudeAcpLogger {
  /// Creates a stderr logger.
  const ClaudeAcpStderrLogger();

  @override
  void log(String message) => stderr.writeln(message);

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    stderr.writeln(message);
    if (error != null) stderr.writeln(error);
    if (stackTrace != null) stderr.writeln(stackTrace);
  }
}

/// A logger that discards all diagnostics.
final class ClaudeAcpNullLogger implements ClaudeAcpLogger {
  /// Creates a no-op logger.
  const ClaudeAcpNullLogger();

  @override
  void log(String message) {}

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}
}

/// Read-only process environment used while configuring Claude sessions.
final class ClaudeAcpEnvironment {
  /// Creates an immutable environment snapshot.
  ClaudeAcpEnvironment({
    Map<String, String>? variables,
    this.remote = false,
    this.hideAuthentication = false,
  }) : variables = Map<String, String>.unmodifiable(
         variables ?? Platform.environment,
       );

  /// Environment variables forwarded to SDK-owned processes.
  final Map<String, String> variables;

  /// Whether the adapter is serving a remote client.
  final bool remote;

  /// Whether interactive authentication methods should be hidden.
  final bool hideAuthentication;

  /// Whether launching an interactive browser is allowed.
  bool get browserAllowed =>
      !isRemote && !hideAuthentication && !variables.containsKey('NO_BROWSER');

  /// Whether browser redirects to this process are unlikely to be reachable.
  bool get isRemote =>
      remote ||
      variables.containsKey('NO_BROWSER') ||
      variables.containsKey('SSH_CONNECTION') ||
      variables.containsKey('SSH_CLIENT') ||
      variables.containsKey('SSH_TTY') ||
      variables.containsKey('CLAUDE_CODE_REMOTE');
}

/// Filesystem boundary used for session working-directory validation.
abstract interface class ClaudeAcpFileSystem {
  /// Whether [path] is absolute.
  bool isAbsolute(String path);

  /// Whether [path] names an existing directory.
  Future<bool> isDirectory(String path);
}

/// Filesystem implementation backed by `dart:io`.
final class LocalClaudeAcpFileSystem implements ClaudeAcpFileSystem {
  /// Creates a local filesystem boundary.
  const LocalClaudeAcpFileSystem();

  @override
  bool isAbsolute(String path) => Directory(path).isAbsolute;

  @override
  Future<bool> isDirectory(String path) async =>
      await FileSystemEntity.type(path) == FileSystemEntityType.directory;
}

/// Creates UUID-compatible random identifiers without global mutable state.
final class ClaudeAcpRandomIdGenerator {
  /// Creates a generator backed by [random].
  ClaudeAcpRandomIdGenerator([Random? random])
    : _random = random ?? Random.secure();

  final Random _random;

  /// Returns a lowercase UUID v4 string.
  String call() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
