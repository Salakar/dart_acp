import '../json.dart';

/// Controls when live transcript mirror frames are flushed.
enum SessionStoreFlushMode {
  /// Coalesce until a result frame or memory threshold.
  batched,

  /// Schedule a background flush after every mirror frame.
  eager,
}

/// Identifies one main or subagent transcript in a [SessionStore].
final class SessionKey {
  /// Creates a session store key.
  const SessionKey({
    required this.projectKey,
    required this.sessionId,
    this.subpath,
  }) : assert(projectKey != ''),
       assert(sessionId != ''),
       assert(subpath == null || subpath != '');

  /// Caller-defined project scope.
  final String projectKey;

  /// Session identifier.
  final String sessionId;

  /// Opaque nested transcript path, omitted for the main transcript.
  final String? subpath;

  /// Encodes this key for diagnostics or storage adapters.
  JsonMap toJson() => {
    'project_key': projectKey,
    'session_id': sessionId,
    if (subpath != null) 'subpath': subpath,
  };

  @override
  bool operator ==(Object other) =>
      other is SessionKey &&
      other.projectKey == projectKey &&
      other.sessionId == sessionId &&
      other.subpath == subpath;

  @override
  int get hashCode => Object.hash(projectKey, sessionId, subpath);

  @override
  String toString() =>
      [projectKey, sessionId, if (subpath != null) subpath].join('/');
}

/// One opaque JSONL transcript entry.
typedef SessionStoreEntry = JsonMap;

/// One session returned by [SessionStore.listSessions].
final class SessionStoreListEntry {
  /// Creates a listing entry.
  const SessionStoreListEntry({
    required this.sessionId,
    required this.modifiedAt,
  });

  /// Session identifier.
  final String sessionId;

  /// Storage modification time.
  final DateTime modifiedAt;
}

/// Incrementally maintained session summary sidecar.
final class SessionSummaryEntry {
  /// Creates a summary entry.
  SessionSummaryEntry({
    required this.sessionId,
    required this.modifiedAt,
    required JsonMap data,
  }) : data = immutableJsonMap(data);

  /// Session identifier.
  final String sessionId;

  /// Storage modification time from the same clock as listing.
  final DateTime modifiedAt;

  /// Opaque SDK-owned fold state.
  final JsonMap data;
}

/// Adapter for external transcript persistence.
///
/// [append] and [load] are required. Optional methods have corresponding
/// capability getters so callers never have to probe method tear-offs.
abstract class SessionStore {
  /// Appends one ordered batch.
  Future<void> append(SessionKey key, List<SessionStoreEntry> entries);

  /// Loads the complete transcript, or `null` when absent.
  Future<List<SessionStoreEntry>?> load(SessionKey key);

  /// Whether [listSessions] is implemented.
  bool get supportsListing => false;

  /// Lists main transcripts for [projectKey].
  Future<List<SessionStoreListEntry>> listSessions(String projectKey) =>
      throw UnsupportedError('This session store does not support listing');

  /// Whether [listSessionSummaries] is implemented.
  bool get supportsSummaries => false;

  /// Loads incremental summary sidecars.
  Future<List<SessionSummaryEntry>> listSessionSummaries(String projectKey) =>
      throw UnsupportedError('This session store does not support summaries');

  /// Whether [delete] is implemented.
  bool get supportsDelete => false;

  /// Deletes a main or nested transcript.
  Future<void> delete(SessionKey key) =>
      throw UnsupportedError('This session store does not support deletion');

  /// Whether [listSubkeys] is implemented.
  bool get supportsSubkeys => false;

  /// Lists nested paths under one main transcript.
  Future<List<String>> listSubkeys(SessionKey key) =>
      throw UnsupportedError('This session store does not support subkeys');
}

/// In-memory reference session store for tests and development.
final class InMemorySessionStore extends SessionStore {
  final Map<SessionKey, List<SessionStoreEntry>> _entries = {};
  final Map<SessionKey, DateTime> _modified = {};
  final Map<(String, String), SessionSummaryEntry> _summaries = {};
  int _lastMillis = 0;

  DateTime _nextModified() {
    var now = DateTime.now().toUtc().millisecondsSinceEpoch;
    if (now <= _lastMillis) now = _lastMillis + 1;
    _lastMillis = now;
    return DateTime.fromMillisecondsSinceEpoch(now, isUtc: true);
  }

  @override
  Future<void> append(SessionKey key, List<SessionStoreEntry> entries) async {
    if (entries.isEmpty) return;
    final bucket = _entries.putIfAbsent(key, () => []);
    bucket.addAll(entries.map(immutableJsonMap));
    final modified = _nextModified();
    _modified[key] = modified;
    if (key.subpath == null) {
      final summaryKey = (key.projectKey, key.sessionId);
      final folded = foldSessionSummary(
        previous: _summaries[summaryKey],
        key: key,
        entries: entries,
        modifiedAt: modified,
      );
      _summaries[summaryKey] = folded;
    }
  }

  @override
  Future<List<SessionStoreEntry>?> load(SessionKey key) async {
    final values = _entries[key];
    return values == null
        ? null
        : List<SessionStoreEntry>.unmodifiable(values.map(immutableJsonMap));
  }

  @override
  bool get supportsListing => true;

  @override
  Future<List<SessionStoreListEntry>> listSessions(String projectKey) async =>
      _entries.keys
          .where((key) => key.projectKey == projectKey && key.subpath == null)
          .map(
            (key) => SessionStoreListEntry(
              sessionId: key.sessionId,
              modifiedAt:
                  _modified[key] ??
                  DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
            ),
          )
          .toList(growable: false);

  @override
  bool get supportsSummaries => true;

  @override
  Future<List<SessionSummaryEntry>> listSessionSummaries(
    String projectKey,
  ) async => _summaries.entries
      .where((entry) => entry.key.$1 == projectKey)
      .map((entry) => entry.value)
      .toList(growable: false);

  @override
  bool get supportsDelete => true;

  @override
  Future<void> delete(SessionKey key) async {
    _entries.remove(key);
    _modified.remove(key);
    if (key.subpath == null) {
      _summaries.remove((key.projectKey, key.sessionId));
      final nested = _entries.keys
          .where(
            (candidate) =>
                candidate.projectKey == key.projectKey &&
                candidate.sessionId == key.sessionId,
          )
          .toList(growable: false);
      for (final candidate in nested) {
        _entries.remove(candidate);
        _modified.remove(candidate);
      }
    }
  }

  @override
  bool get supportsSubkeys => true;

  @override
  Future<List<String>> listSubkeys(SessionKey key) async => _entries.keys
      .where(
        (candidate) =>
            candidate.projectKey == key.projectKey &&
            candidate.sessionId == key.sessionId &&
            candidate.subpath != null,
      )
      .map((candidate) => candidate.subpath!)
      .toList(growable: false);

  /// Returns a defensive copy of entries stored under [key].
  List<SessionStoreEntry> entriesFor(SessionKey key) =>
      List<SessionStoreEntry>.unmodifiable(
        (_entries[key] ?? const []).map(immutableJsonMap),
      );

  /// Number of main transcripts.
  int get length => _entries.keys.where((key) => key.subpath == null).length;

  /// Removes all stored data.
  void clear() {
    _entries.clear();
    _modified.clear();
    _summaries.clear();
    _lastMillis = 0;
  }
}

/// Folds transcript [entries] into an incremental summary sidecar.
SessionSummaryEntry foldSessionSummary({
  required SessionSummaryEntry? previous,
  required SessionKey key,
  required List<SessionStoreEntry> entries,
  required DateTime modifiedAt,
}) {
  final data = <String, Object?>{
    ...?previous?.data,
    'isSidechain': previous?.data['isSidechain'] ?? false,
  };
  for (final entry in entries) {
    if (entry['isSidechain'] == true) data['isSidechain'] = true;
    final customTitle = entry['customTitle'];
    if (customTitle is String && customTitle.isNotEmpty) {
      data['customTitle'] = customTitle;
    }
    final aiTitle = entry['aiTitle'];
    if (aiTitle is String && aiTitle.isNotEmpty) data['aiTitle'] = aiTitle;
    final lastPrompt = entry['lastPrompt'];
    if (lastPrompt is String && lastPrompt.isNotEmpty) {
      data['lastPrompt'] = lastPrompt;
    }
    final summary = entry['summary'];
    if (summary is String && summary.isNotEmpty) data['summary'] = summary;
    final branch = entry['gitBranch'];
    if (branch is String && branch.isNotEmpty) data['gitBranch'] = branch;
    final cwd = entry['cwd'];
    if (cwd is String && cwd.isNotEmpty) data['cwd'] ??= cwd;
    if (entry['type'] == 'tag') {
      final tag = entry['tag'];
      data['tag'] = tag is String && tag.isNotEmpty ? tag : null;
    }
    final timestamp = entry['timestamp'];
    if (data['createdAt'] == null && timestamp is String) {
      data['createdAt'] = DateTime.tryParse(timestamp)?.millisecondsSinceEpoch;
    }
    data['firstPrompt'] ??= _firstPrompt(entry);
  }
  return SessionSummaryEntry(
    sessionId: key.sessionId,
    modifiedAt: modifiedAt,
    data: data,
  );
}

String? _firstPrompt(SessionStoreEntry entry) {
  if (entry['type'] != 'user' ||
      entry['isMeta'] == true ||
      entry['isCompactSummary'] == true) {
    return null;
  }
  final message = entry['message'];
  if (message is! Map<Object?, Object?>) return null;
  final content = message['content'];
  final texts = <String>[
    if (content is String) content,
    if (content is List<Object?>)
      ...content.whereType<Map<Object?, Object?>>().whereMap((block) {
        final text = block['text'];
        return block['type'] == 'text' && text is String ? text : null;
      }),
  ];
  for (final text in texts) {
    final cleaned = text.replaceAll('\n', ' ').trim();
    if (cleaned.isEmpty || cleaned.startsWith('<command-')) continue;
    return cleaned.length <= 200
        ? cleaned
        : '${cleaned.substring(0, 200).trimRight()}…';
  }
  return null;
}

extension<T> on Iterable<T> {
  Iterable<R> whereMap<R>(R? Function(T) convert) sync* {
    for (final value in this) {
      final result = convert(value);
      if (result != null) yield result;
    }
  }
}
