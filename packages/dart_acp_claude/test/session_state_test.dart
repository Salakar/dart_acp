import 'dart:async';

import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/src/agent/session_state.dart';
import 'package:dart_acp_claude/src/configuration/agent_options.dart';
import 'package:dart_acp_claude/src/configuration/session_configuration.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

import 'helpers/fake_transport.dart';

void main() {
  test(
    'serializes operations, bounds the queue, and survives failures',
    () async {
      final transport = FakeClaudeTransport()..onWrite = (_) {};
      transport.onWrite = transport.autoRespond;
      final client = claude.ClaudeAgentClient(transport: transport);
      await client.connect();
      addTearDown(client.close);
      final session = ClaudeAcpSession(
        id: SessionId('11111111-2222-4333-8444-555555555555'),
        cwd: '/workspace',
        additionalDirectories: const <String>[],
        client: client,
        configuration: ClaudeSessionConfiguration(
          initialization: client.initializationResult,
        ),
        maximumPending: 2,
        fingerprint: 1,
      );

      final gate = Completer<void>();
      final order = <String>[];
      final first = session.enqueue(() async {
        order.add('first-start');
        await gate.future;
        order.add('first-end');
        return 1;
      });
      final second = session.enqueue(() async {
        order.add('second');
        throw StateError('expected');
      });
      await Future<void>.delayed(Duration.zero);
      expect(session.isActive, isTrue);
      expect(session.pendingCount, 2);
      await expectLater(
        session.enqueue(() async => 3),
        throwsA(isA<StateError>()),
      );
      gate.complete();
      expect(await first, 1);
      await expectLater(second, throwsStateError);
      expect(order, <String>['first-start', 'first-end', 'second']);

      expect(await session.enqueue(() async => 4), 4);
      expect(session.pendingCount, 0);
    },
  );

  test('close interrupts active work and rejects later operations', () async {
    final transport = FakeClaudeTransport()..onWrite = (_) {};
    transport.onWrite = transport.autoRespond;
    final client = claude.ClaudeAgentClient(transport: transport);
    await client.connect();
    final session = ClaudeAcpSession(
      id: SessionId('11111111-2222-4333-8444-555555555555'),
      cwd: '/workspace',
      additionalDirectories: const <String>[],
      client: client,
      configuration: ClaudeSessionConfiguration(
        initialization: client.initializationResult,
      ),
      maximumPending: 1,
      fingerprint: 1,
    );
    final gate = Completer<void>();
    final active = session.enqueue(() => gate.future);
    await Future<void>.delayed(Duration.zero);
    await session.close();
    await session.close();
    gate.complete();
    await active;
    await expectLater(session.enqueue(() async {}), throwsA(isA<StateError>()));
    expect(transport.isReady, isFalse);
  });

  test(
    'settles only user results and preserves assistant error detail',
    () async {
      final transport = FakeClaudeTransport()..onWrite = (_) {};
      transport.onWrite = transport.autoRespond;
      final client = claude.ClaudeAgentClient(transport: transport);
      await client.connect();
      addTearDown(client.close);
      final session = ClaudeAcpSession(
        id: SessionId('11111111-2222-4333-8444-555555555555'),
        cwd: '/workspace',
        additionalDirectories: const <String>[],
        client: client,
        configuration: ClaudeSessionConfiguration(
          initialization: client.initializationResult,
        ),
        maximumPending: 1,
        fingerprint: 1,
      );
      final outcome = session.beginTurn();
      session.observe(
        claude.ClaudeMessageEnvelope(
          message: claude.AssistantMessage(
            content: const <claude.ContentBlock>[],
            model: 'model',
            error: claude.AssistantMessageError.rateLimit,
          ),
          raw: const <String, Object?>{'type': 'assistant'},
        ),
      );
      final background = claude.ClaudeMessageEnvelope(
        message: claude.ResultMessage(
          subtype: 'success',
          duration: Duration.zero,
          apiDuration: Duration.zero,
          isError: false,
          turns: 1,
          sessionId: 'session',
        ),
        raw: const <String, Object?>{
          'type': 'result',
          'origin': <String, Object?>{'kind': 'task_notification'},
        },
      );
      expect(session.isBackgroundResult(background), isTrue);
      session.observe(background);
      var completed = false;
      unawaited(outcome.then((_) => completed = true));
      await Future<void>.delayed(Duration.zero);
      expect(completed, isFalse);

      session.observe(
        claude.ClaudeMessageEnvelope(
          message: claude.ResultMessage(
            subtype: 'success',
            duration: Duration.zero,
            apiDuration: Duration.zero,
            isError: false,
            turns: 1,
            sessionId: 'session',
          ),
          raw: const <String, Object?>{
            'type': 'result',
            'origin': <String, Object?>{'kind': 'human'},
          },
        ),
      );
      expect(
        (await outcome).assistantError,
        claude.AssistantMessageError.rateLimit,
      );
    },
  );

  test('holds a user result until its background subagent followup', () async {
    final transport = FakeClaudeTransport()..onWrite = (_) {};
    transport.onWrite = transport.autoRespond;
    final client = claude.ClaudeAgentClient(transport: transport);
    await client.connect();
    addTearDown(client.close);
    final session = ClaudeAcpSession(
      id: SessionId('11111111-2222-4333-8444-555555555555'),
      cwd: '/workspace',
      additionalDirectories: const <String>[],
      client: client,
      configuration: ClaudeSessionConfiguration(
        initialization: client.initializationResult,
      ),
      maximumPending: 1,
      fingerprint: 1,
    );
    final outcome = session.beginTurn();
    session.observe(
      claude.ClaudeMessageEnvelope(
        message: claude.TaskStartedMessage(
          data: const <String, Object?>{},
          taskId: 'task',
          description: 'Test',
          uuid: 'started',
          sessionId: 'session',
          taskType: 'local_agent',
          subagentType: 'test-runner',
        ),
        raw: const <String, Object?>{'type': 'system'},
      ),
    );
    session.observe(
      claude.ClaudeMessageEnvelope(
        message: claude.ResultMessage(
          subtype: 'success',
          duration: Duration.zero,
          apiDuration: Duration.zero,
          isError: false,
          turns: 1,
          sessionId: 'session',
          result: 'initial',
        ),
        raw: const <String, Object?>{
          'type': 'result',
          'origin': <String, Object?>{'kind': 'human'},
        },
      ),
    );
    var completed = false;
    unawaited(outcome.then((_) => completed = true));
    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);

    session.observe(
      claude.ClaudeMessageEnvelope(
        message: claude.TaskNotificationMessage(
          data: const <String, Object?>{},
          taskId: 'task',
          status: claude.TaskStatus.completed,
          outputFile: '/tmp/task',
          summary: 'done',
          uuid: 'finished',
          sessionId: 'session',
        ),
        raw: const <String, Object?>{'type': 'system'},
      ),
    );
    session.observe(
      claude.ClaudeMessageEnvelope(
        message: claude.ResultMessage(
          subtype: 'success',
          duration: Duration.zero,
          apiDuration: Duration.zero,
          isError: false,
          turns: 1,
          sessionId: 'session',
          result: 'followup',
        ),
        raw: const <String, Object?>{
          'type': 'result',
          'origin': <String, Object?>{'kind': 'task-notification'},
        },
      ),
    );

    expect((await outcome).result.result, 'initial');
  });

  test('force-settles a wedged interrupted turn as cancelled', () async {
    final transport = FakeClaudeTransport()..onWrite = (_) {};
    transport.onWrite = transport.autoRespond;
    final client = claude.ClaudeAgentClient(transport: transport);
    await client.connect();
    final session = ClaudeAcpSession(
      id: SessionId('11111111-2222-4333-8444-555555555555'),
      cwd: '/workspace',
      additionalDirectories: const <String>[],
      client: client,
      configuration: ClaudeSessionConfiguration(
        initialization: client.initializationResult,
      ),
      maximumPending: 1,
      fingerprint: 1,
    );
    addTearDown(session.close);

    final outcome = session.beginTurn();
    var forced = false;
    await session.cancel(
      grace: const Duration(milliseconds: 5),
      onForced: () => forced = true,
    );

    final settled = await outcome.timeout(const Duration(seconds: 1));
    expect(forced, isTrue);
    expect(settled.result.terminalReason, 'aborted_streaming');
  });

  test('matches raw SDK selections and validates background origins', () async {
    final transport = FakeClaudeTransport()..onWrite = (_) {};
    transport.onWrite = transport.autoRespond;
    final client = claude.ClaudeAgentClient(transport: transport);
    await client.connect();
    addTearDown(client.close);
    final session = ClaudeAcpSession(
      id: SessionId('11111111-2222-4333-8444-555555555555'),
      cwd: '/workspace',
      additionalDirectories: const <String>[],
      client: client,
      configuration: ClaudeSessionConfiguration(
        initialization: client.initializationResult,
      ),
      maximumPending: 1,
      fingerprint: 1,
      rawSdkMessages: const <ClaudeSdkMessageFilter>[
        ClaudeSdkMessageFilter(type: 'system', subtype: 'task_started'),
      ],
    );

    expect(
      session.shouldForwardSdkMessage(const <String, Object?>{
        'type': 'system',
        'subtype': 'task_started',
      }),
      isTrue,
    );
    expect(session.shouldForwardSdkMessage(const <String, Object?>{}), isFalse);
    expect(
      session.isBackgroundResult(
        claude.ClaudeMessageEnvelope(
          message: const claude.UserMessage.text('not a result'),
          raw: const <String, Object?>{},
        ),
      ),
      isFalse,
    );
    final result = claude.ResultMessage(
      subtype: 'success',
      duration: Duration.zero,
      apiDuration: Duration.zero,
      isError: false,
      turns: 1,
      sessionId: 'session',
    );
    expect(
      session.isBackgroundResult(
        claude.ClaudeMessageEnvelope(message: result, raw: const {}),
      ),
      isFalse,
    );
    expect(
      session.isBackgroundResult(
        claude.ClaudeMessageEnvelope(
          message: result,
          raw: const <String, Object?>{'origin': 'observer'},
        ),
      ),
      isFalse,
    );
    expect(
      session.isBackgroundResult(
        claude.ClaudeMessageEnvelope(
          message: result,
          raw: const <String, Object?>{
            'origin': <String, Object?>{'kind': 7},
          },
        ),
      ),
      isFalse,
    );
  });

  test(
    'tracks parent tools and replacement background task snapshots',
    () async {
      final transport = FakeClaudeTransport()..onWrite = (_) {};
      transport.onWrite = transport.autoRespond;
      final client = claude.ClaudeAgentClient(transport: transport);
      await client.connect();
      addTearDown(client.close);
      final session = ClaudeAcpSession(
        id: SessionId('11111111-2222-4333-8444-555555555555'),
        cwd: '/workspace',
        additionalDirectories: const <String>[],
        client: client,
        configuration: ClaudeSessionConfiguration(
          initialization: client.initializationResult,
        ),
        maximumPending: 1,
        fingerprint: 1,
      );
      void observe(claude.AgentMessage message) => session.observe(
        claude.ClaudeMessageEnvelope(
          message: message,
          raw: const <String, Object?>{},
        ),
      );

      observe(
        claude.TaskStartedMessage(
          data: const <String, Object?>{},
          taskId: 'task',
          description: 'Inspect',
          uuid: 'start',
          sessionId: 'session',
          toolUseId: 'parent',
        ),
      );
      expect(session.parentToolUseIdForAgent('task'), 'parent');
      observe(
        claude.BackgroundTasksChangedMessage(
          data: const <String, Object?>{},
          tasks: const <claude.BackgroundTaskSummary>[
            claude.BackgroundTaskSummary(
              taskId: 'other',
              taskType: 'shell',
              description: 'Run',
            ),
          ],
          uuid: 'snapshot',
          sessionId: 'session',
        ),
      );
      expect(session.parentToolUseIdForAgent('task'), isNull);
      observe(
        claude.TaskUpdatedMessage(
          data: const <String, Object?>{},
          taskId: 'other',
          patch: const <String, Object?>{'status': 'completed'},
        ),
      );
    },
  );

  test('settles deferred results after trailing idle events', () async {
    final transport = FakeClaudeTransport()..onWrite = (_) {};
    transport.onWrite = transport.autoRespond;
    final client = claude.ClaudeAgentClient(transport: transport);
    await client.connect();
    addTearDown(client.close);
    final session = ClaudeAcpSession(
      id: SessionId('11111111-2222-4333-8444-555555555555'),
      cwd: '/workspace',
      additionalDirectories: const <String>[],
      client: client,
      configuration: ClaudeSessionConfiguration(
        initialization: client.initializationResult,
      ),
      maximumPending: 1,
      fingerprint: 1,
    );
    void observe(claude.AgentMessage message) => session.observe(
      claude.ClaudeMessageEnvelope(
        message: message,
        raw: const <String, Object?>{},
      ),
    );

    final outcome = session.beginTurn();
    expect(() => session.beginTurn(), throwsStateError);
    observe(
      claude.TaskStartedMessage(
        data: const <String, Object?>{},
        taskId: 'task',
        description: 'Inspect',
        uuid: 'start',
        sessionId: 'session',
        taskType: 'local_agent',
      ),
    );
    observe(
      claude.ResultMessage(
        subtype: 'success',
        duration: Duration.zero,
        apiDuration: Duration.zero,
        isError: false,
        turns: 1,
        sessionId: 'session',
        result: 'deferred',
      ),
    );
    observe(
      claude.TaskNotificationMessage(
        data: const <String, Object?>{},
        taskId: 'task',
        status: claude.TaskStatus.completed,
        outputFile: '/tmp/task',
        summary: 'done',
        uuid: 'done',
        sessionId: 'session',
      ),
    );
    observe(
      claude.SessionStateChangedMessage(
        data: const <String, Object?>{},
        state: 'idle',
        uuid: 'idle-1',
        sessionId: 'session',
      ),
    );
    observe(
      claude.SessionStateChangedMessage(
        data: const <String, Object?>{},
        state: 'idle',
        uuid: 'idle-2',
        sessionId: 'session',
      ),
    );
    expect((await outcome).result.result, 'deferred');
  });

  test('fails an idle result-less turn and explicit active turn', () async {
    final transport = FakeClaudeTransport()..onWrite = (_) {};
    transport.onWrite = transport.autoRespond;
    final client = claude.ClaudeAgentClient(transport: transport);
    await client.connect();
    addTearDown(client.close);
    final session = ClaudeAcpSession(
      id: SessionId('11111111-2222-4333-8444-555555555555'),
      cwd: '/workspace',
      additionalDirectories: const <String>[],
      client: client,
      configuration: ClaudeSessionConfiguration(
        initialization: client.initializationResult,
      ),
      maximumPending: 1,
      fingerprint: 1,
    );

    final idle = session.beginTurn();
    session.observe(
      claude.ClaudeMessageEnvelope(
        message: claude.SessionStateChangedMessage(
          data: const <String, Object?>{},
          state: 'idle',
          uuid: 'idle',
          sessionId: 'session',
        ),
        raw: const <String, Object?>{},
      ),
    );
    await expectLater(idle, throwsStateError);

    final explicit = session.beginTurn();
    session.failTurn(const FormatException('expected'));
    await expectLater(explicit, throwsFormatException);
    session.failTurn(StateError('no active turn'));
  });

  test('queued work notices closure before it starts', () async {
    final transport = FakeClaudeTransport()..onWrite = (_) {};
    transport.onWrite = transport.autoRespond;
    final client = claude.ClaudeAgentClient(transport: transport);
    await client.connect();
    final session = ClaudeAcpSession(
      id: SessionId('11111111-2222-4333-8444-555555555555'),
      cwd: '/workspace',
      additionalDirectories: const <String>[],
      client: client,
      configuration: ClaudeSessionConfiguration(
        initialization: client.initializationResult,
      ),
      maximumPending: 2,
      fingerprint: 1,
    );
    final gate = Completer<void>();
    final first = session.enqueue(() => gate.future);
    final second = session.enqueue(() async => 2);
    await Future<void>.delayed(Duration.zero);
    await session.interrupt();
    await session.close();
    gate.complete();
    await first;
    await expectLater(second, throwsStateError);
  });

  test(
    'forced cancellation retains a deferred result accounting snapshot',
    () async {
      final transport = FakeClaudeTransport()..onWrite = (_) {};
      transport.onWrite = transport.autoRespond;
      final client = claude.ClaudeAgentClient(transport: transport);
      await client.connect();
      final session = ClaudeAcpSession(
        id: SessionId('11111111-2222-4333-8444-555555555555'),
        cwd: '/workspace',
        additionalDirectories: const <String>[],
        client: client,
        configuration: ClaudeSessionConfiguration(
          initialization: client.initializationResult,
        ),
        maximumPending: 1,
        fingerprint: 1,
      );
      addTearDown(session.close);
      void observe(claude.AgentMessage message) => session.observe(
        claude.ClaudeMessageEnvelope(
          message: message,
          raw: const <String, Object?>{},
        ),
      );

      final outcome = session.beginTurn();
      observe(
        claude.TaskStartedMessage(
          data: const <String, Object?>{},
          taskId: 'task',
          description: 'Inspect',
          uuid: 'start',
          sessionId: 'session',
          taskType: 'local_agent',
        ),
      );
      observe(
        claude.ResultMessage(
          subtype: 'success',
          duration: const Duration(milliseconds: 3),
          apiDuration: const Duration(milliseconds: 2),
          isError: false,
          turns: 4,
          sessionId: 'session',
          usage: const <String, Object?>{'input_tokens': 5},
          totalCostUsd: 0.01,
          modelUsage: const <String, claude.ModelUsage>{},
        ),
      );
      await session.cancel(grace: const Duration(milliseconds: 5));
      final forced = await outcome.timeout(const Duration(seconds: 1));
      expect(forced.result.duration, const Duration(milliseconds: 3));
      expect(forced.result.apiDuration, const Duration(milliseconds: 2));
      expect(forced.result.turns, 4);
      expect(forced.result.usage, containsPair('input_tokens', 5));
      expect(forced.result.totalCostUsd, 0.01);
      expect(forced.result.modelUsage, isEmpty);
    },
  );
}
