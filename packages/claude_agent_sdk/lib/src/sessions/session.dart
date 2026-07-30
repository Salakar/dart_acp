import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../errors.dart';
import '../json.dart';
import '../uuid.dart';
import 'session_store.dart';

/// Metadata for a persisted Claude Code session.
final class SessionInfo {
  /// Creates session metadata.
  const SessionInfo({
    required this.sessionId,
    required this.summary,
    required this.lastModified,
    this.fileSize,
    this.customTitle,
    this.firstPrompt,
    this.gitBranch,
    this.cwd,
    this.tag,
    this.createdAt,
  });

  /// Unique session identifier.
  final String sessionId;

  /// Best display title: custom title, summary, or first prompt.
  final String summary;

  /// Last transcript modification time.
  final DateTime lastModified;

  /// Local JSONL size in bytes, when known.
  final int? fileSize;

  /// User-set or generated title.
  final String? customTitle;

  /// First meaningful user prompt.
  final String? firstPrompt;

  /// Last recorded Git branch.
  final String? gitBranch;

  /// Session working directory.
  final String? cwd;

  /// User-set tag.
  final String? tag;

  /// Timestamp of the earliest timestamped entry.
  final DateTime? createdAt;
}

/// A historical top-level user or assistant message.
final class SessionMessage {
  /// Creates a session message.
  SessionMessage({
    required this.type,
    required this.uuid,
    required this.sessionId,
    required JsonValue message,
    this.parentToolUseId,
    this.parentAgentId,
  }) : message = immutableJsonValue(message);

  /// `user`, `assistant`, or `system`.
  final String type;

  /// Message identifier.
  final String uuid;

  /// Session identifier.
  final String sessionId;

  /// Raw Anthropic API message object.
  final JsonValue message;

  /// Parent tool invocation for a nested message.
  final String? parentToolUseId;

  /// Agent that spawned the subagent owning this message.
  final String? parentAgentId;
}

/// Result of a session fork.
final class ForkSessionResult {
  /// Creates a fork result.
  const ForkSessionResult(this.sessionId);

  /// New forked session UUID.
  final String sessionId;
}

/// Derives the transcript-store project key used by Claude Code.
String projectKeyForDirectory([String? directory]) {
  final canonical = _canonicalDirectory(directory ?? Directory.current.path);
  return _sanitizeProjectPath(canonical);
}

/// Lists local Claude Code sessions, newest first.
List<SessionInfo> listSessions({
  String? directory,
  int? limit,
  int offset = 0,
  bool includeWorktrees = true,
  String? claudeConfigDirectory,
}) {
  _validatePaging(limit, offset);
  final roots = <({Directory directory, String? projectPath})>[];
  if (directory != null) {
    final canonical = _canonicalDirectory(directory);
    final paths = includeWorktrees
        ? _worktreePaths(canonical)
        : <String>[canonical];
    for (final path in paths) {
      final project = _findProjectDirectory(
        path,
        claudeConfigDirectory: claudeConfigDirectory,
      );
      if (project != null) {
        roots.add((directory: project, projectPath: path));
      }
    }
  } else {
    final projects = _projectsDirectory(claudeConfigDirectory);
    if (projects.existsSync()) {
      for (final entity in projects.listSync()) {
        if (entity is Directory) {
          roots.add((directory: entity, projectPath: null));
        }
      }
    }
  }
  final byId = <String, SessionInfo>{};
  for (final root in roots) {
    for (final file in root.directory.listSync().whereType<File>()) {
      final name = p.basename(file.path);
      if (!name.endsWith('.jsonl')) continue;
      final sessionId = name.substring(0, name.length - 6);
      if (!isUuid(sessionId)) continue;
      final info = _sessionInfoFromFile(
        file,
        sessionId,
        projectPath: root.projectPath,
      );
      if (info == null) continue;
      final previous = byId[sessionId];
      if (previous == null ||
          info.lastModified.isAfter(previous.lastModified)) {
        byId[sessionId] = info;
      }
    }
  }
  final result = byId.values.toList()
    ..sort((left, right) => right.lastModified.compareTo(left.lastModified));
  return _page(result, limit, offset);
}

/// Looks up one local session.
SessionInfo? getSessionInfo(
  String sessionId, {
  String? directory,
  String? claudeConfigDirectory,
}) {
  if (!isUuid(sessionId)) return null;
  final file = _findSessionFile(
    sessionId,
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
  return file == null ? null : _sessionInfoFromFile(file, sessionId);
}

/// Reads the visible conversation chain from a local transcript.
List<SessionMessage> getSessionMessages(
  String sessionId, {
  String? directory,
  int? limit,
  int offset = 0,
  bool includeSystemMessages = false,
  String? claudeConfigDirectory,
}) {
  _validatePaging(limit, offset);
  if (!isUuid(sessionId)) return const [];
  final file = _findSessionFile(
    sessionId,
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
  if (file == null) return const [];
  return _messagesFromEntries(
    _readEntries(file),
    limit,
    offset,
    includeSystemMessages: includeSystemMessages,
  );
}

/// Lists nested subagent identifiers for a local session.
List<String> listSubagents(
  String sessionId, {
  String? directory,
  String? claudeConfigDirectory,
}) {
  if (!isUuid(sessionId)) return const [];
  final file = _findSessionFile(
    sessionId,
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
  if (file == null) return const [];
  final root = Directory(p.join(file.parent.path, sessionId, 'subagents'));
  if (!root.existsSync()) return const [];
  final result = <String>{};
  for (final entity in root.listSync(recursive: true).whereType<File>()) {
    final name = p.basename(entity.path);
    if (name.startsWith('agent-') && name.endsWith('.jsonl')) {
      result.add(name.substring(6, name.length - 6));
    }
  }
  final sorted = result.toList()..sort();
  return List<String>.unmodifiable(sorted);
}

/// Reads one local subagent conversation.
List<SessionMessage> getSubagentMessages(
  String sessionId,
  String agentId, {
  String? directory,
  int? limit,
  int offset = 0,
  String? claudeConfigDirectory,
}) {
  _validatePaging(limit, offset);
  if (!isUuid(sessionId) || agentId.isEmpty) return const [];
  final file = _findSessionFile(
    sessionId,
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
  if (file == null) return const [];
  final root = Directory(p.join(file.parent.path, sessionId, 'subagents'));
  if (!root.existsSync()) return const [];
  for (final candidate in root.listSync(recursive: true).whereType<File>()) {
    if (p.basename(candidate.path) == 'agent-$agentId.jsonl') {
      return _messagesFromEntries(
        _readEntries(candidate),
        limit,
        offset,
        allowSidechains: true,
      );
    }
  }
  return const [];
}

/// Renames a local session by appending a title record.
void renameSession(
  String sessionId,
  String title, {
  String? directory,
  String? claudeConfigDirectory,
}) {
  final trimmed = title.trim();
  if (trimmed.isEmpty) {
    throw ArgumentError.value(title, 'title', 'must not be empty');
  }
  _appendLocalMutation(
    sessionId,
    {'type': 'custom-title', 'customTitle': trimmed, 'sessionId': sessionId},
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
}

/// Sets a local session tag, or clears it when [tag] is `null`.
void tagSession(
  String sessionId,
  String? tag, {
  String? directory,
  String? claudeConfigDirectory,
}) {
  final sanitized = tag == null ? '' : _sanitizeTag(tag).trim();
  if (tag != null && sanitized.isEmpty) {
    throw ArgumentError.value(tag, 'tag', 'must not be empty');
  }
  _appendLocalMutation(
    sessionId,
    {'type': 'tag', 'tag': sanitized, 'sessionId': sessionId},
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
}

/// Permanently deletes a local session and its nested transcripts.
void deleteSession(
  String sessionId, {
  String? directory,
  String? claudeConfigDirectory,
}) {
  _requireUuid(sessionId);
  final file = _findSessionFile(
    sessionId,
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
  if (file == null) {
    throw SessionException('Session $sessionId was not found');
  }
  file.deleteSync();
  final nested = Directory(p.join(file.parent.path, sessionId));
  if (nested.existsSync()) nested.deleteSync(recursive: true);
}

/// Forks a local session with fresh message and session UUIDs.
ForkSessionResult forkSession(
  String sessionId, {
  String? directory,
  String? upToMessageId,
  String? title,
  String? claudeConfigDirectory,
}) {
  _requireUuid(sessionId);
  if (upToMessageId != null) _requireUuid(upToMessageId);
  final source = _findSessionFile(
    sessionId,
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
  if (source == null) {
    throw SessionException('Session $sessionId was not found');
  }
  final entries = _readEntries(source);
  final transformed = _forkEntries(
    entries,
    sessionId,
    upToMessageId: upToMessageId,
    title: title,
  );
  final newId = transformed.$1;
  final destination = File(p.join(source.parent.path, '$newId.jsonl'));
  if (destination.existsSync()) {
    throw SessionException('Fork destination already exists: $newId');
  }
  destination.writeAsStringSync(
    '${transformed.$2.map(jsonEncode).join('\n')}\n',
    flush: true,
  );
  return ForkSessionResult(newId);
}

/// Lists sessions from an external [SessionStore].
Future<List<SessionInfo>> listSessionsFromStore(
  SessionStore store, {
  String? directory,
  int? limit,
  int offset = 0,
}) async {
  _validatePaging(limit, offset);
  final projectKey = projectKeyForDirectory(directory);
  final summaries = store.supportsSummaries
      ? await store.listSessionSummaries(projectKey)
      : const <SessionSummaryEntry>[];
  if (!store.supportsListing && summaries.isEmpty) {
    throw const SessionException(
      'SessionStore does not support listing or summaries',
    );
  }
  if (!store.supportsListing) {
    final result =
        summaries.map(_infoFromSummary).whereType<SessionInfo>().toList()
          ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return _page(result, limit, offset);
  }
  final listed = await store.listSessions(projectKey);
  final summariesById = {
    for (final summary in summaries) summary.sessionId: summary,
  };
  final result = <SessionInfo>[];
  for (final item in listed) {
    final summary = summariesById.remove(item.sessionId);
    if (summary != null && !summary.modifiedAt.isBefore(item.modifiedAt)) {
      final info = _infoFromSummary(summary);
      if (info != null) result.add(info);
      continue;
    }
    final entries = await store.load(
      SessionKey(projectKey: projectKey, sessionId: item.sessionId),
    );
    if (entries == null) continue;
    final info = _sessionInfoFromEntries(
      item.sessionId,
      entries,
      lastModified: item.modifiedAt,
    );
    if (info != null) result.add(info);
  }
  result.addAll(
    summariesById.values.map(_infoFromSummary).whereType<SessionInfo>(),
  );
  result.sort((a, b) => b.lastModified.compareTo(a.lastModified));
  return _page(result, limit, offset);
}

/// Looks up session metadata from an external [SessionStore].
Future<SessionInfo?> getSessionInfoFromStore(
  SessionStore store,
  String sessionId, {
  String? directory,
}) async {
  if (!isUuid(sessionId)) return null;
  final projectKey = projectKeyForDirectory(directory);
  if (store.supportsSummaries) {
    for (final summary in await store.listSessionSummaries(projectKey)) {
      if (summary.sessionId == sessionId) return _infoFromSummary(summary);
    }
  }
  final entries = await store.load(
    SessionKey(projectKey: projectKey, sessionId: sessionId),
  );
  return entries == null
      ? null
      : _sessionInfoFromEntries(
          sessionId,
          entries,
          lastModified: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        );
}

/// Reads a visible conversation chain from an external [SessionStore].
Future<List<SessionMessage>> getSessionMessagesFromStore(
  SessionStore store,
  String sessionId, {
  String? directory,
  int? limit,
  int offset = 0,
  bool includeSystemMessages = false,
}) async {
  _validatePaging(limit, offset);
  if (!isUuid(sessionId)) return const [];
  final entries = await store.load(
    SessionKey(
      projectKey: projectKeyForDirectory(directory),
      sessionId: sessionId,
    ),
  );
  return entries == null
      ? const []
      : _messagesFromEntries(
          entries,
          limit,
          offset,
          includeSystemMessages: includeSystemMessages,
        );
}

/// Lists nested subagent IDs from an external [SessionStore].
Future<List<String>> listSubagentsFromStore(
  SessionStore store,
  String sessionId, {
  String? directory,
}) async {
  if (!isUuid(sessionId) || !store.supportsSubkeys) return const [];
  final subkeys = await store.listSubkeys(
    SessionKey(
      projectKey: projectKeyForDirectory(directory),
      sessionId: sessionId,
    ),
  );
  final result = <String>[];
  for (final subpath in subkeys) {
    final name = p.basename(subpath);
    if (name.startsWith('agent-')) {
      result.add(
        name.endsWith('.jsonl')
            ? name.substring(6, name.length - 6)
            : name.substring(6),
      );
    }
  }
  result.sort();
  return List<String>.unmodifiable(result);
}

/// Reads one subagent conversation from an external [SessionStore].
Future<List<SessionMessage>> getSubagentMessagesFromStore(
  SessionStore store,
  String sessionId,
  String agentId, {
  String? directory,
  int? limit,
  int offset = 0,
}) async {
  _validatePaging(limit, offset);
  if (!isUuid(sessionId) || agentId.isEmpty || !store.supportsSubkeys) {
    return const [];
  }
  final projectKey = projectKeyForDirectory(directory);
  final parent = SessionKey(projectKey: projectKey, sessionId: sessionId);
  for (final subpath in await store.listSubkeys(parent)) {
    final name = p.basename(subpath);
    if (name != 'agent-$agentId' && name != 'agent-$agentId.jsonl') continue;
    final entries = await store.load(
      SessionKey(
        projectKey: projectKey,
        sessionId: sessionId,
        subpath: subpath,
      ),
    );
    return entries == null
        ? const []
        : _messagesFromEntries(entries, limit, offset, allowSidechains: true);
  }
  return const [];
}

/// Appends a title record to an external [SessionStore].
Future<void> renameSessionInStore(
  SessionStore store,
  String sessionId,
  String title, {
  String? directory,
}) async {
  _requireUuid(sessionId);
  final trimmed = title.trim();
  if (trimmed.isEmpty) {
    throw ArgumentError.value(title, 'title', 'must not be empty');
  }
  await store.append(
    SessionKey(
      projectKey: projectKeyForDirectory(directory),
      sessionId: sessionId,
    ),
    [_mutationEntry(sessionId, 'custom-title', 'customTitle', trimmed)],
  );
}

/// Appends or clears a tag in an external [SessionStore].
Future<void> tagSessionInStore(
  SessionStore store,
  String sessionId,
  String? tag, {
  String? directory,
}) async {
  _requireUuid(sessionId);
  final sanitized = tag == null ? '' : _sanitizeTag(tag).trim();
  if (tag != null && sanitized.isEmpty) {
    throw ArgumentError.value(tag, 'tag', 'must not be empty');
  }
  await store.append(
    SessionKey(
      projectKey: projectKeyForDirectory(directory),
      sessionId: sessionId,
    ),
    [_mutationEntry(sessionId, 'tag', 'tag', sanitized)],
  );
}

/// Deletes a session from a store when deletion is supported.
Future<void> deleteSessionFromStore(
  SessionStore store,
  String sessionId, {
  String? directory,
}) async {
  _requireUuid(sessionId);
  if (!store.supportsDelete) return;
  await store.delete(
    SessionKey(
      projectKey: projectKeyForDirectory(directory),
      sessionId: sessionId,
    ),
  );
}

/// Forks a stored session with fresh message and session UUIDs.
Future<ForkSessionResult> forkSessionInStore(
  SessionStore store,
  String sessionId, {
  String? directory,
  String? upToMessageId,
  String? title,
}) async {
  _requireUuid(sessionId);
  if (upToMessageId != null) _requireUuid(upToMessageId);
  final projectKey = projectKeyForDirectory(directory);
  final entries = await store.load(
    SessionKey(projectKey: projectKey, sessionId: sessionId),
  );
  if (entries == null || entries.isEmpty) {
    throw SessionException('Session $sessionId was not found');
  }
  final transformed = _forkEntries(
    entries,
    sessionId,
    upToMessageId: upToMessageId,
    title: title,
  );
  await store.append(
    SessionKey(projectKey: projectKey, sessionId: transformed.$1),
    transformed.$2,
  );
  return ForkSessionResult(transformed.$1);
}

/// Imports a local session and all nested transcripts into [store].
Future<void> importSessionToStore(
  SessionStore store,
  String sessionId, {
  String? directory,
  String? claudeConfigDirectory,
}) async {
  _requireUuid(sessionId);
  final file = _findSessionFile(
    sessionId,
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
  if (file == null) {
    throw SessionException('Session $sessionId was not found');
  }
  final projectKey = projectKeyForDirectory(directory);
  await store.append(
    SessionKey(projectKey: projectKey, sessionId: sessionId),
    _readEntries(file),
  );
  final nested = Directory(p.join(file.parent.path, sessionId));
  if (!nested.existsSync()) return;
  for (final child in nested.listSync(recursive: true).whereType<File>()) {
    if (!child.path.endsWith('.jsonl')) continue;
    await store.append(
      SessionKey(
        projectKey: projectKey,
        sessionId: sessionId,
        subpath: p
            .relative(child.path, from: nested.path)
            .replaceFirst(RegExp(r'\.jsonl$'), '')
            .split(p.separator)
            .join('/'),
      ),
      _readEntries(child),
    );
  }
}

Directory _projectsDirectory(String? config) {
  final base =
      config ??
      Platform.environment['CLAUDE_CONFIG_DIR'] ??
      p.join(Platform.environment['HOME'] ?? Directory.current.path, '.claude');
  return Directory(p.join(base, 'projects'));
}

String _canonicalDirectory(String value) {
  final absolute = Directory(value).absolute;
  try {
    return absolute.resolveSymbolicLinksSync();
  } on FileSystemException {
    return p.normalize(absolute.path);
  }
}

String _sanitizeProjectPath(String value) {
  final sanitized = value.replaceAll(RegExp('[^a-zA-Z0-9]'), '-');
  if (sanitized.length <= 200) return sanitized;
  var hash = 0;
  for (final unit in value.codeUnits) {
    hash = ((hash << 5) - hash + unit) & 0xffffffff;
  }
  if (hash >= 0x80000000) hash -= 0x100000000;
  final suffix = hash.abs().toRadixString(36);
  return '${sanitized.substring(0, 200)}-$suffix';
}

Directory? _findProjectDirectory(
  String projectPath, {
  String? claudeConfigDirectory,
}) {
  final projects = _projectsDirectory(claudeConfigDirectory);
  final key = _sanitizeProjectPath(_canonicalDirectory(projectPath));
  final exact = Directory(p.join(projects.path, key));
  if (exact.existsSync()) return exact;
  if (key.length <= 200 || !projects.existsSync()) return null;
  final prefix = '${key.substring(0, 200)}-';
  for (final item in projects.listSync().whereType<Directory>()) {
    if (p.basename(item.path).startsWith(prefix)) return item;
  }
  return null;
}

List<String> _worktreePaths(String directory) {
  final result = <String>{directory};
  try {
    final process = Process.runSync(
      'git',
      const ['worktree', 'list', '--porcelain'],
      workingDirectory: directory,
      runInShell: false,
    );
    if (process.exitCode == 0) {
      for (final line in '${process.stdout}'.split('\n')) {
        if (line.startsWith('worktree ')) {
          result.add(_canonicalDirectory(line.substring(9)));
        }
      }
    }
  } on ProcessException {
    // A non-Git directory simply has no additional worktrees.
  }
  return result.toList(growable: false);
}

File? _findSessionFile(
  String sessionId, {
  String? directory,
  String? claudeConfigDirectory,
}) {
  if (directory != null) {
    for (final candidate in _worktreePaths(_canonicalDirectory(directory))) {
      final project = _findProjectDirectory(
        candidate,
        claudeConfigDirectory: claudeConfigDirectory,
      );
      if (project == null) continue;
      final file = File(p.join(project.path, '$sessionId.jsonl'));
      if (file.existsSync()) return file;
    }
    return null;
  }
  final projects = _projectsDirectory(claudeConfigDirectory);
  if (!projects.existsSync()) return null;
  for (final project in projects.listSync().whereType<Directory>()) {
    final file = File(p.join(project.path, '$sessionId.jsonl'));
    if (file.existsSync()) return file;
  }
  return null;
}

List<JsonMap> _readEntries(File file) {
  final result = <JsonMap>[];
  for (final line in file.readAsLinesSync()) {
    if (line.trim().isEmpty) continue;
    try {
      result.add(asJsonMap(jsonDecode(line), 'transcript entry'));
    } on FormatException {
      // Match the tolerant upstream readers: one corrupt line does not hide
      // the rest of a recoverable transcript.
    }
  }
  return result;
}

SessionInfo? _sessionInfoFromFile(
  File file,
  String sessionId, {
  String? projectPath,
}) {
  final stat = file.statSync();
  return _sessionInfoFromEntries(
    sessionId,
    _readEntries(file),
    lastModified: stat.modified.toUtc(),
    fileSize: stat.size,
    projectPath: projectPath,
  );
}

SessionInfo? _sessionInfoFromEntries(
  String sessionId,
  List<JsonMap> entries, {
  required DateTime lastModified,
  int? fileSize,
  String? projectPath,
}) {
  if (entries.isEmpty || entries.first['isSidechain'] == true) return null;
  String? customTitle;
  String? aiTitle;
  String? lastPrompt;
  String? summary;
  String? branch;
  String? cwd;
  String? tag;
  DateTime? createdAt;
  String? firstPrompt;
  for (final entry in entries) {
    customTitle = _lastNonEmpty(entry['customTitle'], customTitle);
    aiTitle = _lastNonEmpty(entry['aiTitle'], aiTitle);
    lastPrompt = _lastNonEmpty(entry['lastPrompt'], lastPrompt);
    summary = _lastNonEmpty(entry['summary'], summary);
    branch = _lastNonEmpty(entry['gitBranch'], branch);
    cwd ??= _nonEmpty(entry['cwd']);
    if (entry['type'] == 'tag') tag = _nonEmpty(entry['tag']);
    if (createdAt == null && entry['timestamp'] is String) {
      createdAt = DateTime.tryParse(entry['timestamp']! as String)?.toUtc();
    }
    firstPrompt ??= _firstPrompt(entry);
  }
  final title = customTitle ?? aiTitle;
  final display = title ?? lastPrompt ?? summary ?? firstPrompt;
  if (display == null) return null;
  return SessionInfo(
    sessionId: sessionId,
    summary: display,
    lastModified: lastModified,
    fileSize: fileSize,
    customTitle: title,
    firstPrompt: firstPrompt,
    gitBranch: branch,
    cwd: cwd ?? projectPath,
    tag: tag,
    createdAt: createdAt,
  );
}

SessionInfo? _infoFromSummary(SessionSummaryEntry summary) {
  if (summary.data['isSidechain'] == true) return null;
  final custom =
      _nonEmpty(summary.data['customTitle']) ??
      _nonEmpty(summary.data['aiTitle']);
  final first = _nonEmpty(summary.data['firstPrompt']);
  final display =
      custom ??
      _nonEmpty(summary.data['lastPrompt']) ??
      _nonEmpty(summary.data['summary']) ??
      first;
  if (display == null) return null;
  final created = summary.data['createdAt'];
  return SessionInfo(
    sessionId: summary.sessionId,
    summary: display,
    lastModified: summary.modifiedAt,
    customTitle: custom,
    firstPrompt: first,
    gitBranch: _nonEmpty(summary.data['gitBranch']),
    cwd: _nonEmpty(summary.data['cwd']),
    tag: _nonEmpty(summary.data['tag']),
    createdAt: created is int
        ? DateTime.fromMillisecondsSinceEpoch(created, isUtc: true)
        : null,
  );
}

String? _firstPrompt(JsonMap entry) {
  if (entry['type'] != 'user' ||
      entry['isMeta'] == true ||
      entry['isCompactSummary'] == true) {
    return null;
  }
  final message = entry['message'];
  if (message is! Map<Object?, Object?>) return null;
  final content = message['content'];
  final candidates = <String>[
    if (content is String) content,
    if (content is List<Object?>)
      for (final block in content.whereType<Map<Object?, Object?>>())
        if (block['type'] == 'text' && block['text'] is String)
          block['text']! as String,
  ];
  for (final candidate in candidates) {
    final cleaned = candidate.replaceAll('\n', ' ').trim();
    if (cleaned.isEmpty || cleaned.startsWith('<command-')) continue;
    return cleaned.length <= 200
        ? cleaned
        : '${cleaned.substring(0, 200).trimRight()}…';
  }
  return null;
}

List<SessionMessage> _messagesFromEntries(
  List<JsonMap> entries,
  int? limit,
  int offset, {
  bool allowSidechains = false,
  bool includeSystemMessages = false,
}) {
  final linked = entries
      .where((entry) {
        final type = entry['type'];
        return const {
              'user',
              'assistant',
              'progress',
              'system',
              'attachment',
            }.contains(type) &&
            entry['uuid'] is String;
      })
      .toList(growable: false);
  final byId = <String, JsonMap>{
    for (final entry in linked) entry['uuid']! as String: entry,
  };
  final positions = <String, int>{
    for (var index = 0; index < linked.length; index++)
      linked[index]['uuid']! as String: index,
  };
  final parents = linked
      .map((entry) => entry['parentUuid'])
      .whereType<String>()
      .toSet();
  final terminals = linked
      .where((entry) => !parents.contains(entry['uuid']))
      .toList(growable: false);
  JsonMap? best;
  var bestPosition = -1;
  for (final terminal in terminals) {
    JsonMap? current = terminal;
    final seen = <String>{};
    while (current != null) {
      final id = current['uuid']! as String;
      if (!seen.add(id)) break;
      if (current['type'] == 'user' || current['type'] == 'assistant') {
        final isMain =
            allowSidechains ||
            (current['isSidechain'] != true &&
                current['teamName'] == null &&
                current['isMeta'] != true);
        final candidate = includeSystemMessages ? terminal : current;
        final position = positions[candidate['uuid']] ?? -1;
        if (isMain && position > bestPosition) {
          best = candidate;
          bestPosition = position;
        }
        break;
      }
      current = current['parentUuid'] is String
          ? byId[current['parentUuid']]
          : null;
    }
  }
  if (best == null) return const [];
  final reversed = <JsonMap>[];
  JsonMap? current = best;
  final seen = <String>{};
  while (current != null) {
    final id = current['uuid']! as String;
    if (!seen.add(id)) break;
    reversed.add(current);
    current = current['parentUuid'] is String
        ? byId[current['parentUuid']]
        : null;
  }
  final visible = reversed.reversed
      .where(
        (entry) =>
            (entry['type'] == 'user' ||
                entry['type'] == 'assistant' ||
                (includeSystemMessages && entry['type'] == 'system')) &&
            entry['isMeta'] != true &&
            entry['interruptedByShutdown'] != true &&
            (allowSidechains || entry['isSidechain'] != true) &&
            (allowSidechains || entry['teamName'] == null),
      )
      .map(
        (entry) => SessionMessage(
          type: entry['type']! as String,
          uuid: entry['uuid']! as String,
          sessionId: entry['sessionId'] is String
              ? entry['sessionId']! as String
              : '',
          message: entry['message'],
          parentToolUseId: entry['parent_tool_use_id'] is String
              ? entry['parent_tool_use_id']! as String
              : entry['parentToolUseId'] is String
              ? entry['parentToolUseId']! as String
              : null,
          parentAgentId: entry['parent_agent_id'] is String
              ? entry['parent_agent_id']! as String
              : entry['parentAgentId'] is String
              ? entry['parentAgentId']! as String
              : null,
        ),
      )
      .toList(growable: false);
  return _page(visible, limit, offset);
}

void _appendLocalMutation(
  String sessionId,
  JsonMap entry, {
  String? directory,
  String? claudeConfigDirectory,
}) {
  _requireUuid(sessionId);
  final file = _findSessionFile(
    sessionId,
    directory: directory,
    claudeConfigDirectory: claudeConfigDirectory,
  );
  if (file == null) {
    throw SessionException('Session $sessionId was not found');
  }
  file.writeAsStringSync(
    '${jsonEncode(entry)}\n',
    mode: FileMode.append,
    flush: true,
  );
}

(String, List<JsonMap>) _forkEntries(
  List<JsonMap> entries,
  String sourceSessionId, {
  String? upToMessageId,
  String? title,
}) {
  const transcriptTypes = {
    'user',
    'assistant',
    'attachment',
    'system',
    'progress',
  };
  final transcript = entries
      .where(
        (entry) =>
            transcriptTypes.contains(entry['type']) &&
            entry['uuid'] is String &&
            entry['isSidechain'] != true,
      )
      .toList();
  if (transcript.isEmpty) {
    throw SessionException('Session $sourceSessionId has no messages to fork');
  }
  var end = transcript.length;
  if (upToMessageId != null) {
    final index = transcript.indexWhere(
      (entry) => entry['uuid'] == upToMessageId,
    );
    if (index < 0) {
      throw SessionException(
        'Message $upToMessageId was not found in session $sourceSessionId',
      );
    }
    end = index + 1;
  }
  final selected = transcript.take(end).toList(growable: false);
  final writable = selected
      .where((entry) => entry['type'] != 'progress')
      .toList(growable: false);
  if (writable.isEmpty) {
    throw SessionException('Session $sourceSessionId has no messages to fork');
  }
  final newSessionId = uuidV4();
  final remapped = <String, String>{
    for (final entry in selected) entry['uuid']! as String: uuidV4(),
  };
  final byId = <String, JsonMap>{
    for (final entry in selected) entry['uuid']! as String: entry,
  };
  final now = DateTime.now().toUtc().toIso8601String();
  final result = <JsonMap>[];
  for (var index = 0; index < writable.length; index++) {
    final entry = writable[index];
    final oldId = entry['uuid']! as String;
    String? parent = entry['parentUuid'] is String
        ? entry['parentUuid']! as String
        : null;
    while (parent != null) {
      final parentEntry = byId[parent];
      if (parentEntry == null) {
        parent = null;
        break;
      }
      if (parentEntry['type'] != 'progress') break;
      parent = parentEntry['parentUuid'] is String
          ? parentEntry['parentUuid']! as String
          : null;
    }
    final logicalParent = entry['logicalParentUuid'];
    final forked =
        <String, Object?>{
            ...entry,
            'uuid': remapped[oldId],
            'sessionId': newSessionId,
            'parentUuid': parent == null ? null : remapped[parent],
            'logicalParentUuid': logicalParent is String
                ? remapped[logicalParent]
                : logicalParent,
            'timestamp': index == writable.length - 1
                ? now
                : (entry['timestamp'] ?? now),
            'isSidechain': false,
            'forkedFrom': {'sessionId': sourceSessionId, 'messageUuid': oldId},
          }
          ..remove('teamName')
          ..remove('agentName')
          ..remove('slug')
          ..remove('sourceToolAssistantUUID');
    result.add(immutableJsonMap(forked));
  }
  final replacements = <Object?>[];
  for (final entry in entries) {
    if (entry['type'] == 'content-replacement' &&
        entry['sessionId'] == sourceSessionId &&
        entry['replacements'] is List<Object?>) {
      replacements.addAll(entry['replacements']! as List<Object?>);
    }
  }
  if (replacements.isNotEmpty) {
    result.add({
      'type': 'content-replacement',
      'sessionId': newSessionId,
      'replacements': List<Object?>.unmodifiable(
        replacements.map(immutableJsonValue),
      ),
      'uuid': uuidV4(),
      'timestamp': now,
    });
  }
  final derivedTitle = title?.trim().isNotEmpty == true
      ? title!.trim()
      : '${_deriveTitle(entries) ?? 'Forked session'} (fork)';
  result.add(
    _mutationEntry(newSessionId, 'custom-title', 'customTitle', derivedTitle),
  );
  return (newSessionId, List<JsonMap>.unmodifiable(result));
}

String? _deriveTitle(List<JsonMap> entries) {
  String? title;
  for (final entry in entries) {
    title =
        _lastNonEmpty(entry['customTitle'], title) ??
        _lastNonEmpty(entry['aiTitle'], title);
  }
  return title ?? entries.map(_firstPrompt).whereType<String>().firstOrNull;
}

JsonMap _mutationEntry(
  String sessionId,
  String type,
  String field,
  String value,
) => {
  'type': type,
  field: value,
  'sessionId': sessionId,
  'uuid': uuidV4(),
  'timestamp': DateTime.now().toUtc().toIso8601String(),
};

String _sanitizeTag(String value) => String.fromCharCodes(
  value.runes.where(
    (rune) =>
        !(rune >= 0x200b && rune <= 0x200f) &&
        !(rune >= 0x202a && rune <= 0x202e) &&
        !(rune >= 0x2060 && rune <= 0x206f) &&
        !(rune >= 0xe000 && rune <= 0xf8ff),
  ),
);

String? _nonEmpty(Object? value) =>
    value is String && value.isNotEmpty ? value : null;

String? _lastNonEmpty(Object? value, String? previous) =>
    _nonEmpty(value) ?? previous;

void _requireUuid(String value) {
  if (!isUuid(value)) {
    throw ArgumentError.value(value, 'sessionId', 'must be a UUID');
  }
}

void _validatePaging(int? limit, int offset) {
  if (limit != null && limit < 0) {
    throw ArgumentError.value(limit, 'limit', 'must not be negative');
  }
  if (offset < 0) {
    throw ArgumentError.value(offset, 'offset', 'must not be negative');
  }
}

List<T> _page<T>(List<T> values, int? limit, int offset) {
  if (offset >= values.length) return const [];
  final end = limit == null || limit == 0
      ? values.length
      : (offset + limit).clamp(0, values.length);
  return List<T>.unmodifiable(values.sublist(offset, end));
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
