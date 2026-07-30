import '../sessions/session_store.dart';
import '../uuid.dart';

/// Creates a fresh empty session store for one conformance run.
typedef SessionStoreFactory = Future<SessionStore> Function();

/// Runs reusable behavioral checks against a custom [SessionStore].
///
/// The factory must return a new empty store. A failing contract throws
/// [StateError] with the violated behavior. Adapter test suites can call this
/// function from their own test framework without adding a dependency on the
/// SDK's chosen test package.
Future<void> verifySessionStoreConformance(SessionStoreFactory factory) async {
  final store = await factory();
  final projectKey = 'conformance-${uuidV4()}';
  final sessionId = uuidV4();
  final key = SessionKey(projectKey: projectKey, sessionId: sessionId);
  final first = <String, Object?>{
    'type': 'user',
    'uuid': uuidV4(),
    'sessionId': sessionId,
    'message': {'role': 'user', 'content': 'first'},
  };
  final second = <String, Object?>{
    'type': 'assistant',
    'uuid': uuidV4(),
    'sessionId': sessionId,
    'message': {'role': 'assistant', 'content': 'second'},
  };

  await store.append(key, [first]);
  first['lateMutation'] = true;
  await store.append(key, [second]);
  await store.append(key, const []);
  final loaded = await store.load(key);
  _check(loaded != null && loaded.length == 2, 'append order or load failed');
  _check(
    loaded!.first['lateMutation'] == null,
    'append must defensively copy entries',
  );
  try {
    loaded.first['mutation'] = true;
  } on UnsupportedError {
    // An immutable result is also a valid defensive result.
  }
  final reloaded = await store.load(key);
  _check(
    reloaded?.first['mutation'] == null,
    'load result mutation leaked into the store',
  );

  if (store.supportsListing) {
    final listed = await store.listSessions(projectKey);
    _check(
      listed.any((entry) => entry.sessionId == sessionId),
      'listing omitted an existing main transcript',
    );
  }
  if (store.supportsSubkeys) {
    final subkey = SessionKey(
      projectKey: projectKey,
      sessionId: sessionId,
      subpath: 'subagents/agent-${uuidV4()}',
    );
    await store.append(subkey, [second]);
    final subkeys = await store.listSubkeys(key);
    _check(
      subkeys.contains(subkey.subpath),
      'subkey listing omitted an existing nested transcript',
    );
  }
  if (store.supportsDelete) {
    await store.delete(key);
    _check(
      await store.load(key) == null,
      'delete retained the main transcript',
    );
  }
}

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError('SessionStore conformance failure: $message');
  }
}
