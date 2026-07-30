import 'dart:async';
import 'dart:convert';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';

/// Deterministic Claude control/message transport used by the example.
final class ScriptedClaudeTransport implements Transport {
  final StreamController<JsonMap> _messages = StreamController<JsonMap>();

  /// Completes when the first prompt reaches the runtime.
  final Completer<void> promptStarted = Completer<void>();

  var _ready = false;
  var _userInputs = 0;

  @override
  bool get isReady => _ready;

  @override
  Stream<JsonMap> get messages => _messages.stream;

  @override
  Future<void> connect() async {
    _ready = true;
  }

  @override
  Future<void> write(String data) async {
    for (final line in data.split('\n')) {
      if (line.trim().isEmpty) continue;
      final value = jsonDecode(line);
      if (value is! Map<Object?, Object?>) continue;
      final frame = <String, Object?>{
        for (final entry in value.entries)
          if (entry.key is String) entry.key! as String: entry.value,
      };
      _handle(frame);
    }
  }

  void _handle(JsonMap frame) {
    if (frame['type'] == 'control_request') {
      final request = frame['request'];
      final subtype = request is Map<Object?, Object?>
          ? request['subtype']
          : null;
      _emitControlResponse(
        frame['request_id']! as String,
        subtype == 'initialize'
            ? <String, Object?>{
                'models': <Object?>[
                  <String, Object?>{
                    'value': 'example-model',
                    'displayName': 'Example model',
                    'description': 'Deterministic model',
                    'supportsEffort': true,
                    'supportedEffortLevels': <Object?>['low', 'high'],
                  },
                ],
                'commands': <Object?>[
                  <String, Object?>{
                    'name': 'review',
                    'description': 'Review a path',
                    'argumentHint': 'path',
                  },
                ],
                'agents': <Object?>[],
              }
            : <String, Object?>{},
      );
      return;
    }
    if (frame['type'] == 'user') {
      _userInputs += 1;
      if (_userInputs == 1 && !promptStarted.isCompleted) {
        promptStarted.complete();
      } else if (_userInputs == 2) {
        scheduleMicrotask(_startTurn);
      }
      return;
    }
    if (frame['type'] == 'control_response') {
      final response = frame['response'];
      if (response is Map<Object?, Object?> &&
          response['request_id'] == 'permission-1') {
        scheduleMicrotask(_finishTurn);
      }
    }
  }

  void _emitControlResponse(String id, JsonMap response) {
    scheduleMicrotask(() {
      _messages.add(<String, Object?>{
        'type': 'control_response',
        'response': <String, Object?>{
          'subtype': 'success',
          'request_id': id,
          'response': response,
        },
      });
    });
  }

  void _startTurn() {
    _messages
      ..add(<String, Object?>{
        'type': 'assistant',
        'uuid': 'assistant-1',
        'session_id': 'example-session',
        'message': <String, Object?>{
          'id': 'message-1',
          'model': 'example-model',
          'content': <Object?>[
            <String, Object?>{
              'type': 'thinking',
              'thinking': 'Checking the requested target.',
              'signature': 'example',
            },
            <String, Object?>{
              'type': 'text',
              'text': 'I will run the requested verification.',
            },
            <String, Object?>{
              'type': 'tool_use',
              'id': 'tool-1',
              'name': 'Bash',
              'input': <String, Object?>{'command': 'dart test'},
            },
          ],
        },
      })
      ..add(<String, Object?>{
        'type': 'control_request',
        'request_id': 'permission-1',
        'request': <String, Object?>{
          'subtype': 'can_use_tool',
          'tool_name': 'Bash',
          'tool_use_id': 'tool-1',
          'input': <String, Object?>{'command': 'dart test'},
          'title': 'Run the package tests?',
        },
      });
  }

  void _finishTurn() {
    _messages
      ..add(<String, Object?>{
        'type': 'user',
        'uuid': 'tool-result-1',
        'session_id': 'example-session',
        'message': <String, Object?>{
          'role': 'user',
          'content': <Object?>[
            <String, Object?>{
              'type': 'tool_result',
              'tool_use_id': 'tool-1',
              'content': 'All tests passed.',
            },
          ],
        },
      })
      ..add(<String, Object?>{
        'type': 'result',
        'subtype': 'success',
        'duration_ms': 12,
        'duration_api_ms': 9,
        'is_error': false,
        'num_turns': 1,
        'session_id': 'example-session',
        'result': 'Done',
        'total_cost_usd': 0.001,
        'usage': <String, Object?>{'input_tokens': 12, 'output_tokens': 8},
      });
  }

  @override
  Future<void> endInput() async {}

  @override
  Future<void> close() async {
    if (!_ready && _messages.isClosed) return;
    _ready = false;
    if (!_messages.isClosed) await _messages.close();
  }
}
