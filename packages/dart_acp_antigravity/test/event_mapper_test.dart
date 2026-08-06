@TestOn('vm')
library;

import 'package:dart_acp_antigravity/dart_acp_antigravity.dart';
import 'package:test/test.dart';

AntigravityStepUpdateEvent _step(String json) =>
    AntigravityEvent.tryParse(json)! as AntigravityStepUpdateEvent;

void main() {
  group('AntigravityEventMapper', () {
    test('maps agent response deltas to message chunks', () {
      final List<SessionUpdate> updates = AntigravityEventMapper().map(
        _step(
          '{"event":"step_update","step_update":{"step_index":1,'
          '"state":"ACTIVE","step_type":"agent_response",'
          '"text_delta":"hi"}}',
        ),
      );
      expect(updates, hasLength(1));
      expect(updates.single.toJson(), <String, Object?>{
        'sessionUpdate': 'agent_message_chunk',
        'content': <String, Object?>{'type': 'text', 'text': 'hi'},
      });
    });

    test('maps planner deltas to thought chunks', () {
      final List<SessionUpdate> updates = AntigravityEventMapper().map(
        _step(
          '{"event":"step_update","step_update":{"step_index":1,'
          '"state":"ACTIVE","step_type":"planner_response",'
          '"text_delta":"thinking"}}',
        ),
      );
      expect(updates.single.toJson()['sessionUpdate'], 'agent_thought_chunk');
    });

    test('emits nothing for empty deltas and ignored step types', () {
      final AntigravityEventMapper mapper = AntigravityEventMapper();
      expect(
        mapper.map(
          _step(
            '{"event":"step_update","step_update":{"step_index":1,'
            '"state":"DONE","step_type":"agent_response"}}',
          ),
        ),
        isEmpty,
      );
      for (final String type in <String>[
        'user_input',
        'checkpoint',
        'system_message',
        'unknown',
      ]) {
        expect(
          mapper.map(
            _step(
              '{"event":"step_update","step_update":{"step_index":9,'
              '"state":"DONE","step_type":"$type","text_delta":"x"}}',
            ),
          ),
          isEmpty,
          reason: type,
        );
      }
    });

    test('announces a tool call once and then updates it', () {
      final AntigravityEventMapper mapper = AntigravityEventMapper();
      final List<SessionUpdate> started = mapper.map(
        _step(
          '{"event":"step_update","step_update":{"step_index":4,'
          '"state":"ACTIVE","step_type":"tool","tool_name":"list_dir",'
          '"tool_info":{"name":"list_dir",'
          '"parameters":{"DirectoryPath":"/w"}}}}',
        ),
      );
      expect(started.single.toJson(), <String, Object?>{
        'sessionUpdate': 'tool_call',
        'toolCallId': 'agy-step-4',
        'title': 'list_dir',
        'kind': 'search',
        'status': 'in_progress',
        'content': <Object?>[],
        'rawInput': <String, Object?>{'DirectoryPath': '/w'},
        'locations': <Object?>[
          <String, Object?>{'path': '/w'},
        ],
      });

      final List<SessionUpdate> finished = mapper.map(
        _step(
          '{"event":"step_update","step_update":{"step_index":4,'
          '"state":"DONE","step_type":"tool","tool_name":"list_dir",'
          '"tool_info":{"name":"list_dir",'
          '"parameters":{"DirectoryPath":"/w"},"output":"a.txt"}}}',
        ),
      );
      expect(finished.single.toJson(), <String, Object?>{
        'sessionUpdate': 'tool_call_update',
        'toolCallId': 'agy-step-4',
        'status': 'completed',
        'content': <Object?>[
          <String, Object?>{
            'type': 'content',
            'content': <String, Object?>{'type': 'text', 'text': 'a.txt'},
          },
        ],
        'rawOutput': <String, Object?>{'output': 'a.txt'},
      });
    });

    test('announces completed and failed tools seen only once', () {
      final AntigravityEventMapper mapper = AntigravityEventMapper();
      final List<SessionUpdate> completed = mapper.map(
        _step(
          '{"event":"step_update","step_update":{"step_index":6,'
          '"state":"DONE","step_type":"tool","tool_name":"view_file",'
          '"tool_info":{"name":"view_file",'
          '"parameters":{"AbsolutePath":"/w/a.txt"},"output":"5 lines"}}}',
        ),
      );
      final Map<String, Object?> announced = completed.single.toJson();
      expect(announced['sessionUpdate'], 'tool_call');
      expect(announced['kind'], 'read');
      expect(announced['status'], 'completed');

      final List<SessionUpdate> failed = mapper.map(
        _step(
          '{"event":"step_update","step_update":{"step_index":7,'
          '"state":"ERROR","step_type":"tool","tool_name":"list_dir",'
          '"tool_info":{"name":"list_dir","parameters":{},'
          '"error":{"type":"TOOL_ERROR","message":"denied"}}}}',
        ),
      );
      final Map<String, Object?> failure = failed.single.toJson();
      expect(failure['sessionUpdate'], 'tool_call');
      expect(failure['status'], 'failed');
      expect(failure['content'], <Object?>[
        <String, Object?>{
          'type': 'content',
          'content': <String, Object?>{'type': 'text', 'text': 'denied'},
        },
      ]);
    });

    test('titles run_command calls with the command line', () {
      final List<SessionUpdate> updates = AntigravityEventMapper().map(
        _step(
          '{"event":"step_update","step_update":{"step_index":8,'
          '"state":"ACTIVE","step_type":"tool","tool_name":"run_command",'
          '"tool_info":{"name":"run_command",'
          '"parameters":{"CommandLine":"ls -la"}}}}',
        ),
      );
      final Map<String, Object?> json = updates.single.toJson();
      expect(json['title'], 'ls -la');
      expect(json['kind'], 'execute');
    });

    test('maps tool names to ACP kinds with a safe default', () {
      final AntigravityEventMapper mapper = AntigravityEventMapper();
      const Map<String, String> expectations = <String, String>{
        'write_to_file': 'edit',
        'search_web': 'fetch',
        'manage_task': 'think',
        'browser_click_element': 'other',
      };
      int index = 10;
      expectations.forEach((String tool, String kind) {
        final List<SessionUpdate> updates = mapper.map(
          _step(
            '{"event":"step_update","step_update":{"step_index":${index++},'
            '"state":"ACTIVE","step_type":"tool","tool_name":"$tool",'
            '"tool_info":{"name":"$tool"}}}',
          ),
        );
        expect(updates.single.toJson()['kind'], kind, reason: tool);
      });
    });

    test('drops tool updates without a step index', () {
      expect(
        AntigravityEventMapper().map(
          _step(
            '{"event":"step_update","step_update":{'
            '"state":"ACTIVE","step_type":"tool","tool_name":"list_dir"}}',
          ),
        ),
        isEmpty,
      );
    });
  });
}
