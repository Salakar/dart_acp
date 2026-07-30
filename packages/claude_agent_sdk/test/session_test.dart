import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:claude_agent_sdk/src/sessions/session_mirror_batcher.dart';
import 'package:claude_agent_sdk/src/sessions/session_resume.dart';
import 'package:claude_agent_sdk/testing.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const sessionId = '11111111-1111-4111-8111-111111111111';
const userId = '22222222-2222-4222-8222-222222222222';
const assistantId = '33333333-3333-4333-8333-333333333333';

List<JsonMap> transcriptEntries({String id = sessionId}) => [
  {
    'type': 'user',
    'uuid': userId,
    'parentUuid': null,
    'sessionId': id,
    'cwd': '/workspace',
    'gitBranch': 'main',
    'timestamp': '2026-01-01T00:00:00Z',
    'message': {'role': 'user', 'content': 'First prompt'},
  },
  {
    'type': 'assistant',
    'uuid': assistantId,
    'parentUuid': userId,
    'sessionId': id,
    'message': {
      'role': 'assistant',
      'content': [
        {'type': 'text', 'text': 'Response'},
      ],
    },
  },
];

void writeJsonl(File file, List<JsonMap> entries) {
  file.parent.createSync(recursive: true);
  file.writeAsStringSync('${entries.map(jsonEncode).join('\n')}\n');
}

void main() {
  group('local sessions', () {
    late Directory temporary;
    late Directory workspace;
    late Directory config;
    late File sessionFile;

    setUp(() {
      temporary = Directory.systemTemp.createTempSync('claude-sessions-');
      workspace = Directory(p.join(temporary.path, 'workspace'))..createSync();
      config = Directory(p.join(temporary.path, 'config'))..createSync();
      final project = Directory(
        p.join(config.path, 'projects', projectKeyForDirectory(workspace.path)),
      )..createSync(recursive: true);
      sessionFile = File(p.join(project.path, '$sessionId.jsonl'));
      writeJsonl(sessionFile, [
        ...transcriptEntries(),
        {
          'type': 'custom-title',
          'customTitle': 'Initial title',
          'sessionId': sessionId,
        },
      ]);
    });

    tearDown(() {
      if (temporary.existsSync()) temporary.deleteSync(recursive: true);
    });

    test('lists metadata and reconstructs the conversation chain', () {
      final sessions = listSessions(
        directory: workspace.path,
        claudeConfigDirectory: config.path,
      );
      final messages = getSessionMessages(
        sessionId,
        directory: workspace.path,
        claudeConfigDirectory: config.path,
      );

      expect(sessions, hasLength(1));
      expect(sessions.single.summary, 'Initial title');
      expect(sessions.single.firstPrompt, 'First prompt');
      expect(sessions.single.gitBranch, 'main');
      expect(sessions.single.createdAt, DateTime.utc(2026));
      expect(messages.map((message) => message.type), ['user', 'assistant']);
      expect((messages.last.message as Map)['content'], isA<List<Object?>>());
    });

    test('supports paging and direct lookup', () {
      expect(
        getSessionInfo(
          sessionId,
          directory: workspace.path,
          claudeConfigDirectory: config.path,
        )?.customTitle,
        'Initial title',
      );
      expect(
        getSessionMessages(
          sessionId,
          directory: workspace.path,
          limit: 1,
          offset: 1,
          claudeConfigDirectory: config.path,
        ).single.type,
        'assistant',
      );
      expect(getSessionInfo('invalid'), isNull);
    });

    test('optionally includes system history and nested-agent ancestry', () {
      const systemId = '44444444-4444-4444-8444-444444444444';
      writeJsonl(sessionFile, [
        ...transcriptEntries(),
        {
          'type': 'system',
          'uuid': systemId,
          'parentUuid': assistantId,
          'sessionId': sessionId,
          'parent_tool_use_id': 'agent-tool',
          'parent_agent_id': 'parent-agent',
          'message': {'subtype': 'compact_boundary'},
        },
      ]);

      expect(
        getSessionMessages(
          sessionId,
          directory: workspace.path,
          claudeConfigDirectory: config.path,
        ).map((message) => message.type),
        ['user', 'assistant'],
      );
      final messages = getSessionMessages(
        sessionId,
        directory: workspace.path,
        includeSystemMessages: true,
        claudeConfigDirectory: config.path,
      );
      expect(messages.map((message) => message.type), [
        'user',
        'assistant',
        'system',
      ]);
      expect(messages.last.parentToolUseId, 'agent-tool');
      expect(messages.last.parentAgentId, 'parent-agent');
    });

    test('omits shutdown interruption markers between real prompts', () {
      const interruptedId = '44444444-4444-4444-8444-444444444444';
      const secondUserId = '55555555-5555-4555-8555-555555555555';
      const secondAssistantId = '66666666-6666-4666-8666-666666666666';
      writeJsonl(sessionFile, [
        ...transcriptEntries(),
        {
          'type': 'user',
          'uuid': interruptedId,
          'parentUuid': assistantId,
          'sessionId': sessionId,
          'interruptedByShutdown': true,
          'message': {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': '[Request interrupted by user]'},
            ],
          },
        },
        {
          'type': 'user',
          'uuid': secondUserId,
          'parentUuid': interruptedId,
          'sessionId': sessionId,
          'message': {'role': 'user', 'content': 'Second prompt'},
        },
        {
          'type': 'assistant',
          'uuid': secondAssistantId,
          'parentUuid': secondUserId,
          'sessionId': sessionId,
          'message': {
            'role': 'assistant',
            'content': [
              {'type': 'text', 'text': 'Second response'},
            ],
          },
        },
      ]);

      final messages = getSessionMessages(
        sessionId,
        directory: workspace.path,
        claudeConfigDirectory: config.path,
      );

      expect(messages.map((message) => message.uuid), [
        userId,
        assistantId,
        secondUserId,
        secondAssistantId,
      ]);
      expect(
        messages
            .where((message) => message.type == 'user')
            .map((message) => (message.message as Map)['content']),
        ['First prompt', 'Second prompt'],
      );
    });

    test('renames, tags, forks, and deletes', () {
      renameSession(
        sessionId,
        'Renamed',
        directory: workspace.path,
        claudeConfigDirectory: config.path,
      );
      tagSession(
        sessionId,
        'experiment',
        directory: workspace.path,
        claudeConfigDirectory: config.path,
      );
      var info = getSessionInfo(
        sessionId,
        directory: workspace.path,
        claudeConfigDirectory: config.path,
      );
      expect(info?.customTitle, 'Renamed');
      expect(info?.tag, 'experiment');

      final fork = forkSession(
        sessionId,
        directory: workspace.path,
        upToMessageId: userId,
        claudeConfigDirectory: config.path,
      );
      expect(fork.sessionId, isNot(sessionId));
      expect(
        getSessionMessages(
          fork.sessionId,
          directory: workspace.path,
          claudeConfigDirectory: config.path,
        ),
        hasLength(1),
      );

      tagSession(
        sessionId,
        null,
        directory: workspace.path,
        claudeConfigDirectory: config.path,
      );
      info = getSessionInfo(
        sessionId,
        directory: workspace.path,
        claudeConfigDirectory: config.path,
      );
      expect(info?.tag, isNull);

      deleteSession(
        fork.sessionId,
        directory: workspace.path,
        claudeConfigDirectory: config.path,
      );
      expect(
        getSessionInfo(
          fork.sessionId,
          directory: workspace.path,
          claudeConfigDirectory: config.path,
        ),
        isNull,
      );
    });

    test('discovers nested subagent transcripts', () {
      final subagent = File(
        p.join(
          sessionFile.parent.path,
          sessionId,
          'subagents',
          'workflows',
          'run',
          'agent-worker.jsonl',
        ),
      );
      writeJsonl(subagent, transcriptEntries());
      File(
        subagent.path.replaceFirst(RegExp(r'\.jsonl$'), '.meta.json'),
      ).writeAsStringSync('{}');

      expect(
        listSubagents(
          sessionId,
          directory: workspace.path,
          claudeConfigDirectory: config.path,
        ),
        ['worker'],
      );
      expect(
        getSubagentMessages(
          sessionId,
          'worker',
          directory: workspace.path,
          claudeConfigDirectory: config.path,
        ),
        hasLength(2),
      );
    });
  });

  group('SessionStore', () {
    late Directory workspace;
    late InMemorySessionStore store;
    late String projectKey;

    setUp(() async {
      workspace = Directory.systemTemp.createTempSync('store-project-');
      store = InMemorySessionStore();
      projectKey = projectKeyForDirectory(workspace.path);
      await store.append(
        SessionKey(projectKey: projectKey, sessionId: sessionId),
        transcriptEntries(),
      );
    });

    tearDown(() => workspace.deleteSync(recursive: true));

    test('lists summaries and reads messages', () async {
      final sessions = await listSessionsFromStore(
        store,
        directory: workspace.path,
      );
      final info = await getSessionInfoFromStore(
        store,
        sessionId,
        directory: workspace.path,
      );
      final messages = await getSessionMessagesFromStore(
        store,
        sessionId,
        directory: workspace.path,
      );

      expect(sessions.single.summary, 'First prompt');
      expect(info?.createdAt, DateTime.utc(2026));
      expect(messages, hasLength(2));
    });

    test('mutates, forks, and deletes', () async {
      await renameSessionInStore(
        store,
        sessionId,
        'Stored title',
        directory: workspace.path,
      );
      await tagSessionInStore(
        store,
        sessionId,
        'stored',
        directory: workspace.path,
      );
      final info = await getSessionInfoFromStore(
        store,
        sessionId,
        directory: workspace.path,
      );
      expect(info?.customTitle, 'Stored title');
      expect(info?.tag, 'stored');

      final fork = await forkSessionInStore(
        store,
        sessionId,
        directory: workspace.path,
        upToMessageId: userId,
      );
      expect(
        await getSessionMessagesFromStore(
          store,
          fork.sessionId,
          directory: workspace.path,
        ),
        hasLength(1),
      );

      await deleteSessionFromStore(
        store,
        fork.sessionId,
        directory: workspace.path,
      );
      expect(
        await getSessionMessagesFromStore(
          store,
          fork.sessionId,
          directory: workspace.path,
        ),
        isEmpty,
      );
    });

    test('lists and reads subkeys', () async {
      await store.append(
        SessionKey(
          projectKey: projectKey,
          sessionId: sessionId,
          subpath: 'subagents/agent-worker',
        ),
        transcriptEntries(),
      );

      expect(
        await listSubagentsFromStore(
          store,
          sessionId,
          directory: workspace.path,
        ),
        ['worker'],
      );
      expect(
        await getSubagentMessagesFromStore(
          store,
          sessionId,
          'worker',
          directory: workspace.path,
        ),
        hasLength(2),
      );
    });

    test('gap-fills missing and stale summary sidecars', () async {
      const secondId = '44444444-4444-4444-8444-444444444444';
      final modified = DateTime.utc(2026, 2);
      final gapStore = _SummaryGapStore(
        projectKey: projectKey,
        modified: modified,
        entries: {
          sessionId: transcriptEntries(),
          secondId: transcriptEntries(id: secondId),
        },
        summaries: [
          SessionSummaryEntry(
            sessionId: sessionId,
            modifiedAt: DateTime.utc(2025),
            data: const {'customTitle': 'stale'},
          ),
        ],
      );

      final sessions = await listSessionsFromStore(
        gapStore,
        directory: workspace.path,
      );

      expect(sessions.map((session) => session.sessionId), {
        sessionId,
        secondId,
      });
      expect(
        sessions.map((session) => session.summary),
        isNot(contains('stale')),
      );
    });

    test('passes the reusable adapter conformance suite', () async {
      await verifySessionStoreConformance(() async => InMemorySessionStore());
    });
  });

  group('mirror and resume', () {
    test('maps mirror paths and coalesces append batches', () async {
      final root = Directory.systemTemp.createTempSync('mirror-');
      addTearDown(() => root.deleteSync(recursive: true));
      final projects = p.join(root.path, 'projects');
      final file = p.join(projects, 'project', '$sessionId.jsonl');
      final subagent = p.join(
        projects,
        'project',
        sessionId,
        'subagents',
        'agent-worker.jsonl',
      );
      expect(
        filePathToSessionKey(file, projects),
        const SessionKey(projectKey: 'project', sessionId: sessionId),
      );
      expect(
        filePathToSessionKey(subagent, projects)?.subpath,
        'subagents/agent-worker',
      );
      expect(
        filePathToSessionKey(p.join(root.path, 'outside.jsonl'), projects),
        isNull,
      );

      final store = InMemorySessionStore();
      final batcher = SessionMirrorBatcher(
        store: store,
        projectsDirectory: projects,
        onError: (_, _) async {},
      );
      batcher.enqueue(file, [transcriptEntries().first]);
      batcher.enqueue(file, [transcriptEntries().last]);
      await batcher.flush();

      expect(
        await store.load(
          const SessionKey(projectKey: 'project', sessionId: sessionId),
        ),
        hasLength(2),
      );
      await batcher.close();
    });

    test('materializes a stored resume tree and cleans it up', () async {
      final workspace = Directory.systemTemp.createTempSync('resume-project-');
      addTearDown(() {
        if (workspace.existsSync()) workspace.deleteSync(recursive: true);
      });
      final store = InMemorySessionStore();
      final key = SessionKey(
        projectKey: projectKeyForDirectory(workspace.path),
        sessionId: sessionId,
      );
      await store.append(key, transcriptEntries());
      await store.append(
        SessionKey(
          projectKey: key.projectKey,
          sessionId: sessionId,
          subpath: 'subagents/agent-worker',
        ),
        transcriptEntries(),
      );

      final materialized = await materializeResumeSession(
        ClaudeAgentOptions(
          workingDirectory: workspace.path,
          resume: sessionId,
          sessionStore: store,
          environment: const {'ANTHROPIC_API_KEY': 'test'},
        ),
      );
      expect(materialized, isNotNull);
      final main = File(
        p.join(
          materialized!.configDirectory,
          'projects',
          key.projectKey,
          '$sessionId.jsonl',
        ),
      );
      final subagent = File(
        p.join(
          materialized.configDirectory,
          'projects',
          key.projectKey,
          sessionId,
          'subagents',
          'agent-worker.jsonl',
        ),
      );
      expect(main.existsSync(), isTrue);
      expect(subagent.existsSync(), isTrue);
      await materialized.cleanup();
      expect(Directory(materialized.configDirectory).existsSync(), isFalse);
    });

    test('selects the newest valid session for continue', () async {
      final workspace = Directory.systemTemp.createTempSync('resume-latest-');
      addTearDown(() {
        if (workspace.existsSync()) workspace.deleteSync(recursive: true);
      });
      final store = InMemorySessionStore();
      final project = projectKeyForDirectory(workspace.path);
      await store.append(
        SessionKey(projectKey: project, sessionId: sessionId),
        [
          {...transcriptEntries().first, 'isSidechain': true},
        ],
      );
      const latest = '44444444-4444-4444-8444-444444444444';
      await store.append(
        SessionKey(projectKey: project, sessionId: latest),
        transcriptEntries(id: latest),
      );

      final materialized = await materializeResumeSession(
        ClaudeAgentOptions(
          workingDirectory: workspace.path,
          continueSession: true,
          sessionStore: store,
          environment: const {'ANTHROPIC_API_KEY': 'test'},
        ),
      );

      expect(materialized?.sessionId, latest);
      await materialized?.cleanup();
    });

    test('returns null for invalid or absent stored resume targets', () async {
      final workspace = Directory.systemTemp.createTempSync('resume-missing-');
      addTearDown(() => workspace.deleteSync(recursive: true));
      final store = InMemorySessionStore();

      expect(
        await materializeResumeSession(
          ClaudeAgentOptions(
            workingDirectory: workspace.path,
            resume: 'not-a-uuid',
            sessionStore: store,
          ),
        ),
        isNull,
      );
      expect(
        await materializeResumeSession(
          ClaudeAgentOptions(
            workingDirectory: workspace.path,
            resume: sessionId,
            sessionStore: store,
          ),
        ),
        isNull,
      );
    });

    test('wraps store failures and timeouts with operation context', () async {
      final workspace = Directory.systemTemp.createTempSync('resume-errors-');
      addTearDown(() => workspace.deleteSync(recursive: true));

      await expectLater(
        materializeResumeSession(
          ClaudeAgentOptions(
            workingDirectory: workspace.path,
            resume: sessionId,
            sessionStore: _FailingStore(),
          ),
        ),
        throwsA(
          isA<SessionException>().having(
            (error) => error.message,
            'message',
            contains('failed to load session'),
          ),
        ),
      );
      await expectLater(
        materializeResumeSession(
          ClaudeAgentOptions(
            workingDirectory: workspace.path,
            resume: sessionId,
            sessionStore: _HangingStore(),
            sessionLoadTimeout: const Duration(milliseconds: 1),
          ),
        ),
        throwsA(
          isA<SessionException>().having(
            (error) => error.message,
            'message',
            contains('timed out'),
          ),
        ),
      );
    });

    test('redacts copied credentials and ignores unsafe subpaths', () async {
      final root = Directory.systemTemp.createTempSync('resume-auth-');
      addTearDown(() {
        if (root.existsSync()) root.deleteSync(recursive: true);
      });
      final workspace = Directory(p.join(root.path, 'workspace'))..createSync();
      final sourceConfig = Directory(p.join(root.path, 'source-config'))
        ..createSync();
      File(p.join(sourceConfig.path, '.credentials.json')).writeAsStringSync(
        jsonEncode({
          'claudeAiOauth': {'accessToken': 'keep', 'refreshToken': 'remove'},
        }),
      );
      File(p.join(sourceConfig.path, '.claude.json')).writeAsStringSync('{}');
      final store = InMemorySessionStore();
      final project = projectKeyForDirectory(workspace.path);
      await store.append(
        SessionKey(projectKey: project, sessionId: sessionId),
        transcriptEntries(),
      );
      await store.append(
        SessionKey(
          projectKey: project,
          sessionId: sessionId,
          subpath: '../escape',
        ),
        transcriptEntries(),
      );
      await store.append(
        SessionKey(
          projectKey: project,
          sessionId: sessionId,
          subpath: 'subagents/agent-meta',
        ),
        [
          {'type': 'agent_metadata', 'agentType': 'reviewer'},
          transcriptEntries().first,
        ],
      );

      final materialized = await materializeResumeSession(
        ClaudeAgentOptions(
          workingDirectory: workspace.path,
          resume: sessionId,
          sessionStore: store,
          environment: {
            'CLAUDE_CONFIG_DIR': sourceConfig.path,
            'ANTHROPIC_API_KEY': 'test',
          },
        ),
      );
      final config = Directory(materialized!.configDirectory);
      final credentials =
          jsonDecode(
                File(
                  p.join(config.path, '.credentials.json'),
                ).readAsStringSync(),
              )
              as Map<String, Object?>;
      final oauth = credentials['claudeAiOauth']! as Map<String, Object?>;
      expect(oauth, containsPair('accessToken', 'keep'));
      expect(oauth, isNot(contains('refreshToken')));
      expect(File(p.join(config.path, '.claude.json')).existsSync(), isTrue);
      expect(File(p.join(config.path, 'escape.jsonl')).existsSync(), isFalse);
      final metadataFiles = config
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.meta.json'));
      expect(metadataFiles, hasLength(1));
      await materialized.cleanup();
    });

    test('validates unsupported store combinations', () {
      expect(
        () => validateSessionStoreOptions(
          ClaudeAgentOptions(
            continueSession: true,
            sessionStore: _MinimalStore(),
          ),
        ),
        throwsArgumentError,
      );
      expect(
        () => validateSessionStoreOptions(
          ClaudeAgentOptions(
            enableFileCheckpointing: true,
            sessionStore: InMemorySessionStore(),
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}

final class _MinimalStore extends SessionStore {
  @override
  Future<void> append(SessionKey key, List<SessionStoreEntry> entries) async {}

  @override
  Future<List<SessionStoreEntry>?> load(SessionKey key) async => null;
}

final class _FailingStore extends SessionStore {
  @override
  Future<void> append(SessionKey key, List<SessionStoreEntry> entries) async {}

  @override
  Future<List<SessionStoreEntry>?> load(SessionKey key) =>
      Future.error(StateError('storage unavailable'));
}

final class _HangingStore extends SessionStore {
  @override
  Future<void> append(SessionKey key, List<SessionStoreEntry> entries) async {}

  @override
  Future<List<SessionStoreEntry>?> load(SessionKey key) =>
      Completer<List<SessionStoreEntry>?>().future;
}

final class _SummaryGapStore extends SessionStore {
  _SummaryGapStore({
    required this.projectKey,
    required this.modified,
    required this.entries,
    required this.summaries,
  });

  final String projectKey;
  final DateTime modified;
  final Map<String, List<SessionStoreEntry>> entries;
  final List<SessionSummaryEntry> summaries;

  @override
  Future<void> append(SessionKey key, List<SessionStoreEntry> entries) async {}

  @override
  Future<List<SessionStoreEntry>?> load(SessionKey key) async =>
      entries[key.sessionId];

  @override
  bool get supportsListing => true;

  @override
  Future<List<SessionStoreListEntry>> listSessions(String projectKey) async {
    expect(projectKey, this.projectKey);
    return entries.keys
        .map(
          (sessionId) =>
              SessionStoreListEntry(sessionId: sessionId, modifiedAt: modified),
        )
        .toList();
  }

  @override
  bool get supportsSummaries => true;

  @override
  Future<List<SessionSummaryEntry>> listSessionSummaries(
    String projectKey,
  ) async {
    expect(projectKey, this.projectKey);
    return summaries;
  }
}
