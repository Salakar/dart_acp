import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

void main() {
  test('tracks task tools including malformed, failed, and deleted tasks', () {
    final plans = ClaudePlanProjector();

    plans.start(
      claude.ToolUseBlock(
        id: 'create',
        name: 'TaskCreate',
        input: <String, Object?>{'subject': 'First task'},
      ),
    );
    final created = plans.finish(
      claude.ToolResultBlock(
        toolUseId: 'create',
        content: <Object?>[
          <String, Object?>{'type': 'text', 'text': '{"id":"task-1"}'},
        ],
      ),
    );
    expect(created, hasLength(1));

    plans.start(
      claude.ToolUseBlock(
        id: 'update',
        name: 'TaskUpdate',
        input: <String, Object?>{
          'task_id': 'task-1',
          'subject': 'Renamed task',
          'status': 'running',
        },
      ),
    );
    expect(
      plans
          .finish(
            claude.ToolResultBlock(toolUseId: 'update', content: 'updated'),
          )!
          .single
          .toJson()
          .toString(),
      allOf(contains('Renamed task'), contains('in_progress')),
    );

    plans.start(
      claude.ToolUseBlock(
        id: 'new-update',
        name: 'TaskUpdate',
        input: <String, Object?>{
          'taskId': 'task-2',
          'subject': 'Discovered task',
        },
      ),
    );
    expect(
      plans.finish(
        claude.ToolResultBlock(toolUseId: 'new-update', content: 'ok'),
      ),
      hasLength(1),
    );
    plans.start(
      claude.ToolUseBlock(
        id: 'keep-status',
        name: 'TaskUpdate',
        input: <String, Object?>{
          'taskId': 'task-2',
          'subject': 'Still discovered',
        },
      ),
    );
    expect(
      plans.finish(
        claude.ToolResultBlock(toolUseId: 'keep-status', content: 'ok'),
      ),
      hasLength(1),
    );

    plans.start(
      claude.ToolUseBlock(
        id: 'missing-update',
        name: 'TaskUpdate',
        input: <String, Object?>{'taskId': 'missing'},
      ),
    );
    expect(
      plans.finish(
        claude.ToolResultBlock(toolUseId: 'missing-update', content: 'ok'),
      ),
      isEmpty,
    );

    plans.start(
      claude.ToolUseBlock(
        id: 'delete',
        name: 'TaskUpdate',
        input: <String, Object?>{'taskId': 'task-1', 'status': 'deleted'},
      ),
    );
    expect(
      plans.finish(
        claude.ToolResultBlock(toolUseId: 'delete', content: 'deleted'),
      ),
      hasLength(1),
    );

    for (final name in <String>['TaskList', 'TaskGet']) {
      plans.start(
        claude.ToolUseBlock(
          id: name,
          name: name,
          input: const <String, Object?>{},
        ),
      );
      expect(
        plans.finish(
          claude.ToolResultBlock(toolUseId: name, content: 'ignored'),
        ),
        isEmpty,
      );
    }

    plans.start(
      claude.ToolUseBlock(
        id: 'failed',
        name: 'TaskCreate',
        input: <String, Object?>{'subject': 'Never added'},
      ),
    );
    expect(
      plans.finish(
        claude.ToolResultBlock(
          toolUseId: 'failed',
          content: 'failure',
          isError: true,
        ),
      ),
      isEmpty,
    );
    expect(
      plans.finish(
        claude.ToolResultBlock(toolUseId: 'unknown', content: 'result'),
      ),
      isNull,
    );
  });

  test('tracks background task lifecycle and every terminal status', () {
    final plans = ClaudePlanProjector();
    final started = plans.system(
      claude.TaskStartedMessage(
        data: const <String, Object?>{},
        taskId: 'background',
        description: 'Background work',
        uuid: 'uuid',
        sessionId: 'session',
      ),
    );
    expect(started?.toJson().toString(), contains('Background work'));

    final progress = plans.system(
      claude.TaskProgressMessage(
        data: const <String, Object?>{},
        taskId: 'background',
        description: '',
        usage: const claude.TaskUsage(
          totalTokens: 1,
          toolUses: 1,
          duration: Duration(milliseconds: 1),
        ),
        uuid: 'uuid',
        sessionId: 'session',
      ),
    );
    expect(progress?.toJson().toString(), contains('in_progress'));
    expect(
      plans
          .system(
            claude.TaskProgressMessage(
              data: const <String, Object?>{},
              taskId: 'background',
              description: 'Still working',
              usage: const claude.TaskUsage(
                totalTokens: 2,
                toolUses: 1,
                duration: Duration(milliseconds: 2),
              ),
              uuid: 'uuid-2',
              sessionId: 'session',
            ),
          )
          ?.toJson()
          .toString(),
      contains('Still working'),
    );

    for (final status in <String>[
      'pending',
      'running',
      'paused',
      'completed',
      'failed',
      'killed',
      'stopped',
    ]) {
      expect(
        plans.system(
          claude.TaskUpdatedMessage(
            data: const <String, Object?>{},
            taskId: 'background',
            patch: <String, Object?>{
              'status': status,
              'subject': 'Updated background',
            },
          ),
        ),
        isNotNull,
      );
    }

    expect(
      plans.system(
        claude.TaskNotificationMessage(
          data: const <String, Object?>{},
          taskId: 'background',
          status: claude.TaskStatus.completed,
          outputFile: '/tmp/output',
          summary: 'done',
          uuid: 'uuid',
          sessionId: 'session',
        ),
      ),
      isNotNull,
    );
    expect(
      plans.system(
        claude.TaskNotificationMessage(
          data: const <String, Object?>{},
          taskId: 'missing',
          status: claude.TaskStatus.completed,
          outputFile: '/tmp/output',
          summary: 'done',
          uuid: 'uuid',
          sessionId: 'session',
        ),
      ),
      isNull,
    );
    expect(
      plans.system(
        claude.SystemMessage(
          subtype: 'future',
          data: const <String, Object?>{},
        ),
      ),
      isNull,
    );
  });

  test('tracks task-created and task-completed lifecycle hooks', () {
    final plans = ClaudePlanProjector();
    claude.HookInput hook(String event) =>
        claude.HookInput.fromJson(<String, Object?>{
          'hook_event_name': event,
          'session_id': 'session',
          'transcript_path': '/tmp/session.jsonl',
          'cwd': '/workspace',
          'task_id': 'task-1',
          'task_subject': 'Review changes',
          'task_description': 'Inspect the diff',
        });

    expect(
      plans.hook(hook('TaskCreated'))?.toJson().toString(),
      allOf(contains('Review changes'), contains('pending')),
    );
    expect(plans.hook(hook('TaskCreated')), isNull);
    expect(
      plans.hook(hook('TaskCompleted'))?.toJson().toString(),
      contains('completed'),
    );
    expect(plans.hook(hook('TaskCompleted')), isNull);
  });
}
