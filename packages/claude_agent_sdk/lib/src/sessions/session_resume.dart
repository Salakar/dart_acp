import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../errors.dart';
import '../options.dart';
import '../uuid.dart';
import 'session.dart';
import 'session_store.dart';

/// Temporary on-disk session tree used by a resumed subprocess.
final class MaterializedSession {
  /// Creates a materialized session handle.
  const MaterializedSession({
    required this.configDirectory,
    required this.sessionId,
  });

  /// Temporary Claude configuration directory.
  final String configDirectory;

  /// Concrete session selected for resume.
  final String sessionId;

  /// Removes the temporary tree.
  Future<void> cleanup() => _deleteWithRetry(Directory(configDirectory));
}

/// Validates option combinations that involve a [SessionStore].
void validateSessionStoreOptions(ClaudeAgentOptions options) {
  final store = options.sessionStore;
  if (store == null) return;
  if (options.continueSession &&
      options.resume == null &&
      !store.supportsListing) {
    throw ArgumentError(
      'continueSession with sessionStore requires listing support',
    );
  }
  if (options.enableFileCheckpointing) {
    throw ArgumentError(
      'sessionStore cannot be combined with file checkpointing',
    );
  }
}

/// Materializes a stored resume target for a local CLI subprocess.
Future<MaterializedSession?> materializeResumeSession(
  ClaudeAgentOptions options,
) async {
  final store = options.sessionStore;
  if (store == null || (options.resume == null && !options.continueSession)) {
    return null;
  }
  final projectKey = projectKeyForDirectory(options.workingDirectory);
  String? sessionId;
  List<SessionStoreEntry>? entries;
  if (options.resume != null) {
    if (!isUuid(options.resume!)) return null;
    sessionId = options.resume;
    entries = await _storeCall(
      store.load(SessionKey(projectKey: projectKey, sessionId: sessionId!)),
      options.sessionLoadTimeout,
      'load session $sessionId',
    );
  } else {
    final listed = await _storeCall(
      store.listSessions(projectKey),
      options.sessionLoadTimeout,
      'list sessions',
    );
    final candidates = [...listed]
      ..sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    for (final candidate in candidates) {
      if (!isUuid(candidate.sessionId)) continue;
      final loaded = await _storeCall(
        store.load(
          SessionKey(projectKey: projectKey, sessionId: candidate.sessionId),
        ),
        options.sessionLoadTimeout,
        'load session ${candidate.sessionId}',
      );
      if (loaded == null ||
          loaded.isEmpty ||
          loaded.first['isSidechain'] == true) {
        continue;
      }
      sessionId = candidate.sessionId;
      entries = loaded;
      break;
    }
  }
  if (sessionId == null || entries == null || entries.isEmpty) return null;

  final temporary = await Directory.systemTemp.createTemp('claude-resume-');
  try {
    final projectDirectory = Directory(
      p.join(temporary.path, 'projects', projectKey),
    )..createSync(recursive: true);
    _writeJsonl(
      File(p.join(projectDirectory.path, '$sessionId.jsonl')),
      entries,
    );
    await _copyAuthentication(options, temporary);
    if (store.supportsSubkeys) {
      await _materializeSubkeys(
        store,
        projectKey,
        sessionId,
        projectDirectory,
        options.sessionLoadTimeout,
      );
    }
    return MaterializedSession(
      configDirectory: temporary.path,
      sessionId: sessionId,
    );
  } catch (_) {
    await _deleteWithRetry(temporary);
    rethrow;
  }
}

Future<T> _storeCall<T>(
  Future<T> operation,
  Duration timeout,
  String description,
) async {
  try {
    return await operation.timeout(timeout);
  } on TimeoutException catch (error) {
    throw SessionException(
      'SessionStore $description timed out after '
      '${timeout.inMilliseconds}ms: $error',
    );
  } catch (error) {
    throw SessionException('SessionStore failed to $description: $error');
  }
}

void _writeJsonl(File file, List<SessionStoreEntry> entries) {
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    '${entries.map(jsonEncode).join('\n')}\n',
    flush: true,
  );
  _restrictFilePermissions(file);
}

void _restrictFilePermissions(File file) {
  if (!Platform.isWindows) {
    try {
      Process.runSync('chmod', ['600', file.path], runInShell: false);
    } on ProcessException {
      // Permissions are a best effort on platforms without chmod.
    }
  }
}

Future<void> _copyAuthentication(
  ClaudeAgentOptions options,
  Directory destination,
) async {
  final customConfig =
      options.environment['CLAUDE_CONFIG_DIR'] ??
      Platform.environment['CLAUDE_CONFIG_DIR'];
  final home =
      Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ??
      Directory.current.path;
  final sourceConfig = customConfig ?? p.join(home, '.claude');
  String? credentials;
  final credentialsFile = File(p.join(sourceConfig, '.credentials.json'));
  if (credentialsFile.existsSync()) {
    credentials = credentialsFile.readAsStringSync();
  }
  final usesEnvironmentToken =
      options.environment['ANTHROPIC_API_KEY'] != null ||
      Platform.environment['ANTHROPIC_API_KEY'] != null ||
      options.environment['CLAUDE_CODE_OAUTH_TOKEN'] != null ||
      Platform.environment['CLAUDE_CODE_OAUTH_TOKEN'] != null;
  if (Platform.isMacOS && customConfig == null && !usesEnvironmentToken) {
    credentials = await _readMacOsKeychainCredentials() ?? credentials;
  }
  if (credentials != null) {
    final destinationFile = File(p.join(destination.path, '.credentials.json'))
      ..writeAsStringSync(_redactRefreshToken(credentials), flush: true);
    _restrictFilePermissions(destinationFile);
  }
  final claudeJsonSource = File(
    customConfig == null
        ? p.join(home, '.claude.json')
        : p.join(customConfig, '.claude.json'),
  );
  if (claudeJsonSource.existsSync()) {
    final copied = claudeJsonSource.copySync(
      p.join(destination.path, '.claude.json'),
    );
    _restrictFilePermissions(copied);
  }
}

Future<String?> _readMacOsKeychainCredentials() async {
  try {
    final user =
        Platform.environment['USER'] ??
        Platform.environment['LOGNAME'] ??
        'claude-code-user';
    final result = await Process.run('security', [
      'find-generic-password',
      '-a',
      user,
      '-w',
      '-s',
      'Claude Code-credentials',
    ], runInShell: false).timeout(const Duration(seconds: 5));
    if (result.exitCode != 0) return null;
    final value = '${result.stdout}'.trim();
    return value.isEmpty ? null : value;
  } catch (_) {
    return null;
  }
}

String _redactRefreshToken(String value) {
  try {
    final decoded = jsonDecode(value);
    if (decoded is Map<Object?, Object?>) {
      final copied = <String, Object?>{
        for (final entry in decoded.entries)
          if (entry.key is String) entry.key! as String: entry.value,
      };
      final oauth = copied['claudeAiOauth'];
      if (oauth is Map<Object?, Object?>) {
        copied['claudeAiOauth'] = <String, Object?>{
          for (final entry in oauth.entries)
            if (entry.key is String && entry.key != 'refreshToken')
              entry.key! as String: entry.value,
        };
      }
      return jsonEncode(copied);
    }
  } on FormatException {
    // Preserve invalid content so the CLI reports the same parse error.
  }
  return value;
}

Future<void> _materializeSubkeys(
  SessionStore store,
  String projectKey,
  String sessionId,
  Directory projectDirectory,
  Duration timeout,
) async {
  final parent = SessionKey(projectKey: projectKey, sessionId: sessionId);
  final subkeys = await _storeCall(
    store.listSubkeys(parent),
    timeout,
    'list subkeys for $sessionId',
  );
  final sessionDirectory = Directory(p.join(projectDirectory.path, sessionId));
  for (final subpath in subkeys) {
    if (!_isSafeSubpath(subpath)) continue;
    final entries = await _storeCall(
      store.load(
        SessionKey(
          projectKey: projectKey,
          sessionId: sessionId,
          subpath: subpath,
        ),
      ),
      timeout,
      'load subkey $subpath',
    );
    if (entries == null || entries.isEmpty) continue;
    final metadata = entries
        .where((entry) => entry['type'] == 'agent_metadata')
        .toList();
    final transcript = entries
        .where((entry) => entry['type'] != 'agent_metadata')
        .toList();
    final relative = subpath.split('/').join(p.separator);
    final transcriptFile = File(
      p.join(sessionDirectory.path, '$relative.jsonl'),
    );
    if (transcript.isNotEmpty) _writeJsonl(transcriptFile, transcript);
    if (metadata.isNotEmpty) {
      final last = {...metadata.last}..remove('type');
      final metadataFile = File(
        p.join(sessionDirectory.path, '$relative.meta.json'),
      );
      metadataFile.parent.createSync(recursive: true);
      metadataFile.writeAsStringSync(jsonEncode(last), flush: true);
      _restrictFilePermissions(metadataFile);
    }
  }
}

bool _isSafeSubpath(String subpath) {
  if (subpath.isEmpty ||
      subpath.contains('\x00') ||
      subpath.startsWith('/') ||
      subpath.startsWith(r'\') ||
      RegExp(r'^[a-zA-Z]:').hasMatch(subpath)) {
    return false;
  }
  return subpath
      .split(RegExp(r'[/\\]'))
      .every((component) => component.isNotEmpty && component != '..');
}

Future<void> _deleteWithRetry(Directory directory) async {
  for (var attempt = 0; attempt < 5; attempt++) {
    try {
      if (directory.existsSync()) directory.deleteSync(recursive: true);
      return;
    } on FileSystemException {
      if (attempt == 4) return;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
}
