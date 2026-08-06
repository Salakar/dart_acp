@TestOn('vm')
library;

import 'package:dart_acp_antigravity/dart_acp_antigravity.dart';
import 'package:test/test.dart';

void main() {
  group('AntigravityEvent.tryParse', () {
    test('decodes init events', () {
      final AntigravityEvent? event = AntigravityEvent.tryParse(
        '{"event":"init","conversation_id":"c-1","init":{"cwd":"/w",'
        '"tools":["list_dir","view_file"],"permission_mode":"request-review"}}',
      );
      expect(
        event,
        isA<AntigravityInitEvent>()
            .having((AntigravityInitEvent e) => e.conversationId, 'id', 'c-1')
            .having((AntigravityInitEvent e) => e.cwd, 'cwd', '/w')
            .having(
              (AntigravityInitEvent e) => e.permissionMode,
              'permissionMode',
              'request-review',
            )
            .having((AntigravityInitEvent e) => e.tools, 'tools', <String>[
              'list_dir',
              'view_file',
            ]),
      );
    });

    test('decodes text step updates', () {
      final AntigravityEvent? event = AntigravityEvent.tryParse(
        '{"event":"step_update","step_update":{"conversation_id":"c-1",'
        '"step_index":2,"state":"ACTIVE","step_type":"agent_response",'
        '"text_delta":"hello"}}',
      );
      expect(
        event,
        isA<AntigravityStepUpdateEvent>()
            .having((AntigravityStepUpdateEvent e) => e.stepIndex, 'index', 2)
            .having((AntigravityStepUpdateEvent e) => e.state, 's', 'ACTIVE')
            .having(
              (AntigravityStepUpdateEvent e) => e.textDelta,
              'delta',
              'hello',
            )
            .having(
              (AntigravityStepUpdateEvent e) => e.isFinished,
              'finished',
              isFalse,
            ),
      );
    });

    test('decodes tool step updates including errors', () {
      final AntigravityEvent? event = AntigravityEvent.tryParse(
        '{"event":"step_update","step_update":{"step_index":3,'
        '"state":"ERROR","step_type":"tool","tool_name":"list_dir",'
        '"tool_info":{"name":"list_dir","parameters":{"DirectoryPath":"/x"},'
        '"error":{"type":"TOOL_ERROR","message":"denied"}}}}',
      );
      expect(
        event,
        isA<AntigravityStepUpdateEvent>()
            .having(
              (AntigravityStepUpdateEvent e) => e.toolName,
              'tool',
              'list_dir',
            )
            .having(
              (AntigravityStepUpdateEvent e) => e.toolParameters,
              'parameters',
              <String, Object?>{'DirectoryPath': '/x'},
            )
            .having(
              (AntigravityStepUpdateEvent e) => e.toolErrorMessage,
              'error',
              'denied',
            )
            .having(
              (AntigravityStepUpdateEvent e) => e.isFinished,
              'finished',
              isTrue,
            ),
      );
    });

    test('decodes result events', () {
      final AntigravityEvent? event = AntigravityEvent.tryParse(
        '{"event":"result","result":{"conversation_id":"c-1",'
        '"status":"SUCCESS","response":"done"}}',
      );
      expect(
        event,
        isA<AntigravityResultEvent>()
            .having((AntigravityResultEvent e) => e.isSuccess, 'ok', isTrue)
            .having((AntigravityResultEvent e) => e.response, 'text', 'done'),
      );
    });

    test('returns null for unknown, malformed, and non-JSON lines', () {
      expect(AntigravityEvent.tryParse(''), isNull);
      expect(AntigravityEvent.tryParse('jetski: no output produced'), isNull);
      expect(AntigravityEvent.tryParse('{"event":"mystery"}'), isNull);
      expect(AntigravityEvent.tryParse('{"event":'), isNull);
      expect(AntigravityEvent.tryParse('[1,2,3]'), isNull);
    });

    test('tolerates missing envelope fields', () {
      expect(
        AntigravityEvent.tryParse('{"event":"init"}'),
        isA<AntigravityInitEvent>().having(
          (AntigravityInitEvent e) => e.conversationId,
          'id',
          isEmpty,
        ),
      );
      expect(
        AntigravityEvent.tryParse('{"event":"step_update"}'),
        isA<AntigravityStepUpdateEvent>().having(
          (AntigravityStepUpdateEvent e) => e.stepIndex,
          'index',
          -1,
        ),
      );
      expect(
        AntigravityEvent.tryParse('{"event":"result","result":{}}'),
        isA<AntigravityResultEvent>().having(
          (AntigravityResultEvent e) => e.isSuccess,
          'ok',
          isFalse,
        ),
      );
    });
  });
}
