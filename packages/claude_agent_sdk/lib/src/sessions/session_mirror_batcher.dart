import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../json.dart';
import 'config_directory.dart';
import 'session_store.dart';

/// Converts an absolute mirrored transcript path to a portable store key.
SessionKey? filePathToSessionKey(String filePath, String projectsDirectory) {
  final relative = p.relative(filePath, from: projectsDirectory);
  if (p.isAbsolute(relative) ||
      relative == '..' ||
      relative.startsWith('${p.separator}..') ||
      relative.startsWith('..${p.separator}')) {
    return null;
  }
  final parts = p.split(relative);
  if (parts.length < 2) return null;
  final projectKey = parts.first;
  if (parts.length == 2 && parts[1].endsWith('.jsonl')) {
    return SessionKey(
      projectKey: projectKey,
      sessionId: parts[1].substring(0, parts[1].length - 6),
    );
  }
  if (parts.length >= 4) {
    final subpath = [...parts.skip(2)];
    final last = subpath.last;
    if (!last.endsWith('.jsonl')) return null;
    subpath[subpath.length - 1] = last.substring(0, last.length - 6);
    return SessionKey(
      projectKey: projectKey,
      sessionId: parts[1],
      subpath: p.posix.joinAll(subpath),
    );
  }
  return null;
}

/// Coalesces live transcript frames before appending them to a store.
final class SessionMirrorBatcher {
  /// Creates a transcript mirror batcher.
  SessionMirrorBatcher({
    required this.store,
    required this.projectsDirectory,
    required this.onError,
    this.maxPendingEntries = 500,
    this.maxPendingBytes = 1024 * 1024,
    this.sendTimeout = const Duration(seconds: 60),
  });

  /// Destination adapter.
  final SessionStore store;

  /// Effective Claude config `projects` directory.
  final String projectsDirectory;

  /// Receives final append failures.
  final Future<void> Function(SessionKey? key, String error) onError;

  /// Entry threshold that triggers an eager flush.
  final int maxPendingEntries;

  /// Approximate encoded-byte threshold that triggers an eager flush.
  final int maxPendingBytes;

  /// Timeout for one adapter call.
  final Duration sendTimeout;

  final List<({String path, List<SessionStoreEntry> entries, int bytes})>
  _pending = [];
  Future<void> _flushTail = Future<void>.value();
  int _pendingEntries = 0;
  int _pendingBytes = 0;
  bool _closed = false;

  /// Buffers one mirror frame without waiting on storage I/O.
  void enqueue(String filePath, List<SessionStoreEntry> entries) {
    if (_closed || entries.isEmpty) return;
    final copied = entries.map(immutableJsonMap).toList(growable: false);
    final bytes = utf8.encode(jsonEncode(copied)).length;
    _pending.add((path: filePath, entries: copied, bytes: bytes));
    _pendingEntries += copied.length;
    _pendingBytes += bytes;
    if (_pendingEntries > maxPendingEntries ||
        _pendingBytes > maxPendingBytes) {
      unawaited(flush());
    }
  }

  /// Flushes every entry enqueued before this call.
  Future<void> flush() {
    if (_pending.isEmpty) return _flushTail;
    final items = List.of(_pending);
    _pending.clear();
    _pendingEntries = 0;
    _pendingBytes = 0;
    _flushTail = _flushTail
        .catchError((Object _) {})
        .then((_) => _flushItems(items));
    return _flushTail;
  }

  Future<void> _flushItems(
    List<({String path, List<SessionStoreEntry> entries, int bytes})> items,
  ) async {
    final byPath = <String, List<SessionStoreEntry>>{};
    for (final item in items) {
      byPath.putIfAbsent(item.path, () => []).addAll(item.entries);
    }
    for (final entry in byPath.entries) {
      final key = filePathToSessionKey(entry.key, projectsDirectory);
      if (key == null) continue;
      Object? lastError;
      for (var attempt = 0; attempt < 3; attempt++) {
        if (attempt > 0) {
          await Future<void>.delayed(
            attempt == 1
                ? const Duration(milliseconds: 200)
                : const Duration(milliseconds: 800),
          );
        }
        try {
          await store.append(key, entry.value).timeout(sendTimeout);
          lastError = null;
          break;
        } on TimeoutException catch (error) {
          lastError = error;
          break;
        } catch (error) {
          lastError = error;
        }
      }
      if (lastError != null) {
        try {
          await onError(key, lastError.toString());
        } catch (_) {
          // Mirror diagnostics must never fail the agent session.
        }
      }
    }
  }

  /// Performs a final non-throwing flush.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    try {
      await flush();
    } catch (_) {
      // Store failures were already surfaced through onError.
    }
  }
}

/// Resolves the projects directory used for transcript mirror paths.
///
/// [environment] is the agent's own environment, so anything it sets for the
/// CLI (a configuration directory, a user profile) decides where the mirror
/// lands; the process environment answers whatever it leaves unset.
String projectsDirectoryForEnvironment(Map<String, String> environment) =>
    p.join(
      claudeConfigDirectory({...Platform.environment, ...environment}),
      'projects',
    );
