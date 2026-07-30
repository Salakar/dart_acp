import 'dart:async';
import 'dart:convert';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';

final class FakeClaudeTransport implements Transport {
  final StreamController<JsonMap> _messages = StreamController<JsonMap>();
  final StreamController<JsonMap> _writes =
      StreamController<JsonMap>.broadcast();

  /// Frames written by the SDK.
  final List<JsonMap> written = <JsonMap>[];

  /// Callback invoked for each decoded write.
  void Function(JsonMap message)? onWrite;

  bool _ready = false;

  @override
  bool get isReady => _ready;

  @override
  Stream<JsonMap> get messages => _messages.stream;

  /// Emits a CLI frame.
  void emit(JsonMap value) => _messages.add(value);

  /// Waits for the next written frame satisfying [predicate].
  Future<JsonMap> nextWriteWhere(bool Function(JsonMap value) predicate) {
    for (final value in written) {
      if (predicate(value)) return Future<JsonMap>.value(value);
    }
    return _writes.stream.firstWhere(predicate);
  }

  @override
  Future<void> connect() async {
    _ready = true;
  }

  @override
  Future<void> write(String data) async {
    if (!_ready) throw StateError('Transport is closed');
    for (final line in data.split('\n')) {
      if (line.trim().isEmpty) continue;
      final decoded = jsonDecode(line);
      if (decoded is! Map<Object?, Object?>) {
        throw StateError('Expected an object');
      }
      final value = <String, Object?>{
        for (final entry in decoded.entries)
          if (entry.key is String) entry.key! as String: entry.value,
      };
      written.add(value);
      _writes.add(value);
      onWrite?.call(value);
    }
  }

  /// Responds to SDK control requests with deterministic metadata.
  void autoRespond(JsonMap frame) {
    if (frame['type'] != 'control_request') return;
    final request = frame['request'];
    final subtype = request is Map<Object?, Object?>
        ? request['subtype']
        : null;
    final response = switch (subtype) {
      'initialize' => <String, Object?>{
        'models': <Object?>[
          <String, Object?>{
            'value': 'claude-test',
            'displayName': 'Claude Test',
            'description': 'Deterministic model',
            'supportsAutoMode': true,
            'supportsEffort': true,
            'supportsFastMode': true,
            'supportedEffortLevels': <Object?>['low', 'high'],
          },
        ],
        'commands': <Object?>[
          <String, Object?>{
            'name': 'review',
            'description': 'Review code',
            'argumentHint': 'path',
          },
        ],
        'agents': <Object?>[],
        'fast_mode_state': 'off',
      },
      'interrupt' => <String, Object?>{'still_queued': <Object?>[]},
      'get_context_usage' => <String, Object?>{
        'categories': <Object?>[],
        'totalTokens': 0,
        'maxTokens': 190000,
        'rawMaxTokens': 200000,
        'percentage': 0,
        'model': 'claude-test',
      },
      _ => <String, Object?>{},
    };
    scheduleMicrotask(() {
      emit(<String, Object?>{
        'type': 'control_response',
        'response': <String, Object?>{
          'subtype': 'success',
          'request_id': frame['request_id'],
          'response': response,
        },
      });
    });
  }

  /// Emits one successful assistant turn.
  void emitSuccessfulTurn() {
    scheduleMicrotask(() {
      emit(<String, Object?>{
        'type': 'assistant',
        'uuid': 'assistant-uuid',
        'session_id': 'default',
        'message': <String, Object?>{
          'id': 'message-1',
          'model': 'claude-test',
          'content': <Object?>[
            <String, Object?>{'type': 'text', 'text': 'hello'},
            <String, Object?>{
              'type': 'tool_use',
              'id': 'tool-1',
              'name': 'Read',
              'input': <String, Object?>{'file_path': 'README.md'},
            },
          ],
        },
      });
      emit(<String, Object?>{
        'type': 'user',
        'uuid': 'result-uuid',
        'session_id': 'default',
        'message': <String, Object?>{
          'role': 'user',
          'content': <Object?>[
            <String, Object?>{
              'type': 'tool_result',
              'tool_use_id': 'tool-1',
              'content': 'contents',
            },
          ],
        },
      });
      emit(<String, Object?>{
        'type': 'system',
        'subtype': 'elicitation_complete',
        'elicitation_id': 'elicitation-1',
        'session_id': 'default',
      });
      emit(<String, Object?>{
        'type': 'result',
        'subtype': 'success',
        'duration_ms': 10,
        'duration_api_ms': 8,
        'is_error': false,
        'num_turns': 1,
        'session_id': 'default',
        'result': 'hello',
        'total_cost_usd': 0.01,
        'usage': <String, Object?>{
          'input_tokens': 8,
          'output_tokens': 2,
          'cache_read_input_tokens': 0,
          'cache_creation_input_tokens': 0,
        },
      });
    });
  }

  @override
  Future<void> endInput() => close();

  @override
  Future<void> close() async {
    if (!_ready && _messages.isClosed) return;
    _ready = false;
    if (!_messages.isClosed) await _messages.close();
    if (!_writes.isClosed) await _writes.close();
  }
}
