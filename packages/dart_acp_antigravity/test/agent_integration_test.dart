@TestOn('vm')
library;

import 'dart:io';

import 'package:dart_acp_antigravity/dart_acp_antigravity.dart';
import 'package:test/test.dart';

late Directory _fixtureDirectory;
late String _fakeExecutable;

Future<AntigravityAcpClient> _startClient() => AntigravityAcpClient.start(
  options: AntigravityAcpOptions(executable: _fakeExecutable),
);

Future<AcpActiveSession> _newSession(AntigravityAcpClient client) => client
    .agent
    .newSession(cwd: AcpAbsolutePath(Directory.current.path))
    .start();

List<ContentBlock> _text(String text) => <ContentBlock>[
  ContentBlockText(TextContent(text: text)),
];

void main() {
  setUpAll(() async {
    _fixtureDirectory = await Directory.systemTemp.createTemp(
      'dart-acp-antigravity-',
    );
    _fakeExecutable = '${_fixtureDirectory.path}/fake_agy';
    final ProcessResult result =
        await Process.run(Platform.resolvedExecutable, <String>[
          'compile',
          'exe',
          File('test/fixtures/fake_agy.dart').absolute.path,
          '-o',
          _fakeExecutable,
        ]);
    if (result.exitCode != 0) {
      throw StateError('Unable to compile fake agy: ${result.stderr}');
    }
  });

  tearDownAll(() async {
    await _fixtureDirectory.delete(recursive: true);
  });

  test(
    'streams message chunks and tool calls, then completes the turn',
    () async {
      final AntigravityAcpClient client = await _startClient();
      try {
        final AcpActiveSession session = await _newSession(client);
        final List<AcpActiveSessionEvent> events = await session
            .prompt(content: _text('Hi'))
            .events
            .toList();
        final List<Map<String, Object?>> updates = <Map<String, Object?>>[
          for (final AcpActiveSessionEvent event in events)
            if (event is AcpSessionUpdateEvent) event.update.toJson(),
        ];
        expect(
          updates.where(
            (Map<String, Object?> u) =>
                u['sessionUpdate'] == 'agent_message_chunk',
          ),
          isNotEmpty,
        );
        final Map<String, Object?> toolCall = updates.singleWhere(
          (Map<String, Object?> u) => u['sessionUpdate'] == 'tool_call',
        );
        expect(toolCall['title'], 'list_dir');
        expect(toolCall['kind'], 'search');
        final Map<String, Object?> toolUpdate = updates.singleWhere(
          (Map<String, Object?> u) => u['sessionUpdate'] == 'tool_call_update',
        );
        expect(toolUpdate['status'], 'completed');
        expect(
          events.whereType<AcpPromptCompletedEvent>().single.stopReason,
          StopReason.endTurn,
        );
        session.dispose();
      } finally {
        await client.close();
      }
    },
  );

  test('resumes the bound conversation on later prompts', () async {
    final AntigravityAcpClient client = await _startClient();
    try {
      final AcpActiveSession session = await _newSession(client);
      final AcpCollectedText first = await session
          .prompt(content: _text('Hi'))
          .collectText();
      expect(first.text, isNot(contains('--conversation')));
      final AcpCollectedText second = await session
          .prompt(content: _text('And again'))
          .collectText();
      expect(second.text, contains('--conversation'));
      expect(second.text, contains('fake-conv-1'));
      session.dispose();
    } finally {
      await client.close();
    }
  });

  test('forwards configured launch flags to the CLI', () async {
    final AntigravityAcpClient client = await AntigravityAcpClient.start(
      options: AntigravityAcpOptions(
        executable: _fakeExecutable,
        model: 'gemini-3-pro',
        effort: AntigravityReasoningEffort.high,
        permissionPolicy: AntigravityPermissionPolicy.bypassPermissions,
        additionalDirectories: <String>['/extra'],
        promptTimeout: const Duration(minutes: 2),
      ),
    );
    try {
      final AcpActiveSession session = await _newSession(client);
      final AcpCollectedText result = await session
          .prompt(content: _text('Hi'))
          .collectText();
      expect(result.text, contains('--model'));
      expect(result.text, contains('gemini-3-pro'));
      expect(result.text, contains('--effort'));
      expect(result.text, contains('--dangerously-skip-permissions'));
      expect(result.text, contains('/extra'));
      expect(result.text, contains('120s'));
      session.dispose();
    } finally {
      await client.close();
    }
  });

  test('surfaces CLI failures as request errors', () async {
    final AntigravityAcpClient client = await _startClient();
    try {
      final AcpActiveSession session = await _newSession(client);
      await expectLater(
        session.prompt(content: _text('Please FAIL')).collectText(),
        throwsA(isA<JsonRpcRequestException>()),
      );
      session.dispose();
    } finally {
      await client.close();
    }
  });

  test('surfaces missing results as request errors', () async {
    final AntigravityAcpClient client = await _startClient();
    try {
      final AcpActiveSession session = await _newSession(client);
      await expectLater(
        session.prompt(content: _text('NO_RESULT please')).collectText(),
        throwsA(isA<JsonRpcRequestException>()),
      );
      session.dispose();
    } finally {
      await client.close();
    }
  });

  test('rejects prompts without CLI-compatible content', () async {
    final AntigravityAcpClient client = await _startClient();
    try {
      final AcpActiveSession session = await _newSession(client);
      await expectLater(
        session.prompt(content: const <ContentBlock>[]).collectText(),
        throwsA(isA<JsonRpcRequestException>()),
      );
      session.dispose();
    } finally {
      await client.close();
    }
  });

  test('cancel stops the running CLI and reports cancelled', () async {
    final AntigravityAcpClient client = await _startClient();
    try {
      final AcpActiveSession session = await _newSession(client);
      final AcpPromptTurn turn = session.prompt(content: _text('HANG now'));
      final Future<AcpCollectedText> collected = turn.collectText();
      await Future<void>.delayed(const Duration(milliseconds: 400));
      await session.cancel();
      final AcpCollectedText result = await collected;
      expect(result.response.stopReason, StopReason.cancelled);
      session.dispose();
    } finally {
      await client.close();
    }
  });

  test('reports resume mismatches instead of losing history', () async {
    final AntigravityAcpClient client = await _startClient();
    try {
      final AcpActiveSession session = await _newSession(client);
      await session.prompt(content: _text('Hi')).collectText();
      await expectLater(
        session.prompt(content: _text('MISMATCH please')).collectText(),
        throwsA(isA<JsonRpcRequestException>()),
      );
      session.dispose();
    } finally {
      await client.close();
    }
  });

  test('rejects concurrent prompts on one session', () async {
    final AntigravityAcpClient client = await _startClient();
    try {
      final AcpActiveSession session = await _newSession(client);
      final AcpPromptTurn running = session.prompt(content: _text('HANG now'));
      final Future<List<AcpActiveSessionEvent>> collected = running.events
          .toList();
      await Future<void>.delayed(const Duration(milliseconds: 400));
      await expectLater(
        session.prompt(content: _text('Hi')).collectText(),
        throwsA(isA<JsonRpcRequestException>()),
      );
      await session.cancel();
      final List<AcpActiveSessionEvent> events = await collected;
      expect(
        events.whereType<AcpPromptCompletedEvent>().single.stopReason,
        StopReason.cancelled,
      );
      session.dispose();
    } finally {
      await client.close();
    }
  });
}
