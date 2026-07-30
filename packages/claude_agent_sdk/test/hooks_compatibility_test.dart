import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('expanded hook names are real enum values on Dart 3.10', () {
    expect(HookEvent.fromWire('PermissionDenied'), HookEvent.permissionDenied);
    expect(HookEvent.fromWire('PostToolBatch'), HookEvent.postToolBatch);
  });

  test('new hook events decode into concrete current input types', () {
    final input = HookInput.fromJson(<String, Object?>{
      'hook_event_name': 'PostToolBatch',
      'session_id': 'session-1',
      'transcript_path': '/tmp/transcript.jsonl',
      'cwd': '/workspace',
      'tool_calls': <Object?>[
        <String, Object?>{
          'tool_name': 'Read',
          'tool_input': <String, Object?>{'file_path': 'README.md'},
          'tool_use_id': 'tool',
        },
      ],
    });

    expect(input, isA<PostToolBatchHookInput>());
    expect(input.event, HookEvent.postToolBatch);
    expect(input.sessionId, 'session-1');
    expect((input as PostToolBatchHookInput).toolCalls, hasLength(1));
  });

  test('published hook inputs expose current event-specific fields', () {
    JsonMap payload(String event, JsonMap fields) => <String, Object?>{
      'hook_event_name': event,
      'session_id': 'session',
      'transcript_path': '/tmp/transcript.jsonl',
      'cwd': '/workspace',
      ...fields,
    };

    final values = <HookInput>[
      HookInput.fromJson(
        payload('SessionStart', <String, Object?>{
          'source': 'startup',
          'agent_type': 'coordinator',
        }),
      ),
      HookInput.fromJson(
        payload('PostCompact', <String, Object?>{
          'trigger': 'auto',
          'compact_summary': 'summary',
        }),
      ),
      HookInput.fromJson(
        payload('Elicitation', <String, Object?>{
          'mcp_server_name': 'server',
          'message': 'Choose',
          'requested_schema': <String, Object?>{'type': 'object'},
        }),
      ),
      HookInput.fromJson(
        payload('MessageDisplay', <String, Object?>{
          'turn_id': 'turn',
          'message_id': 'message',
          'index': 1,
          'final': true,
          'delta': 'done',
        }),
      ),
      HookInput.fromJson(
        payload('TaskCreated', <String, Object?>{
          'task_id': 'task',
          'task_subject': 'Review',
        }),
      ),
      HookInput.fromJson(
        payload('CwdChanged', <String, Object?>{
          'old_cwd': '/old',
          'new_cwd': '/new',
        }),
      ),
    ];

    expect(values[0], isA<SessionStartHookInput>());
    expect((values[0] as SessionStartHookInput).agentType, 'coordinator');
    expect((values[1] as PostCompactHookInput).compactSummary, 'summary');
    expect(
      (values[2] as ElicitationHookInput).requestedSchema,
      containsPair('type', 'object'),
    );
    expect((values[3] as MessageDisplayHookInput).isFinal, isTrue);
    expect((values[4] as TaskCreatedHookInput).taskSubject, 'Review');
    expect((values[5] as CwdChangedHookInput).newCwd, '/new');
  });

  test('published hook-specific output controls encode exactly', () {
    final outputs = <HookSpecificOutput>[
      ElicitationHookOutput(
        event: HookEvent.elicitation,
        action: 'accept',
        content: const <String, Object?>{'choice': 'yes'},
      ),
      WatchPathsHookOutput(
        event: HookEvent.fileChanged,
        watchPaths: const <String>['/workspace/lib'],
      ),
      const MessageDisplayHookOutput(displayContent: 'redacted'),
      const PermissionDeniedHookOutput(retry: true),
      SessionStartHookOutput(
        initialUserMessage: 'Start',
        watchPaths: const <String>['/workspace'],
        reloadSkills: true,
      ),
      const UserPromptSubmitHookOutput(
        sessionTitle: 'Review',
        suppressOriginalPrompt: true,
      ),
      const WorktreeCreateHookOutput(worktreePath: '/workspace/wt'),
    ];

    expect(
      outputs.map((output) => output.toJson()),
      everyElement(contains('hookEventName')),
    );
    expect(
      const HookOutput(
        decision: HookDecision.approve,
        terminalSequence: '\u001b]9;done\u0007',
      ).toJson(),
      containsPair('decision', 'approve'),
    );
  });
}
