import 'dart:async';
import 'dart:convert';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';

final class FakeTransport implements Transport {
  final StreamController<JsonMap> _controller = StreamController<JsonMap>();
  final StreamController<JsonMap> _writes =
      StreamController<JsonMap>.broadcast();
  bool _ready = false;

  final List<JsonMap> written = [];
  bool inputEnded = false;
  bool closed = false;

  void Function(JsonMap message)? onWrite;

  @override
  bool get isReady => _ready;

  @override
  Stream<JsonMap> get messages => _controller.stream;

  Stream<JsonMap> get writeEvents => _writes.stream;

  @override
  Future<void> connect() async {
    _ready = true;
  }

  @override
  Future<void> write(String data) async {
    if (!_ready) throw StateError('not ready');
    for (final line in data.split('\n')) {
      if (line.trim().isEmpty) continue;
      final decoded = jsonDecode(line);
      if (decoded is! Map<Object?, Object?>) throw StateError('not an object');
      final value = <String, Object?>{
        for (final entry in decoded.entries)
          if (entry.key is String) entry.key! as String: entry.value,
      };
      written.add(value);
      _writes.add(value);
      onWrite?.call(value);
    }
  }

  void emit(JsonMap message) {
    if (!_controller.isClosed) _controller.add(message);
  }

  void emitError(Object error) {
    if (!_controller.isClosed) _controller.addError(error);
  }

  void respondToControl(JsonMap request, [JsonMap response = const {}]) {
    emit({
      'type': 'control_response',
      'response': {
        'subtype': 'success',
        'request_id': request['request_id'],
        'response': response,
      },
    });
  }

  void autoRespondToControl(JsonMap message) {
    if (message['type'] != 'control_request') return;
    final request = message['request'];
    final subtype = request is Map<Object?, Object?>
        ? request['subtype']
        : null;
    final response = switch (subtype) {
      'initialize' => <String, Object?>{
        'models': <Object?>[
          <String, Object?>{
            'value': 'test-model',
            'displayName': 'Test Model',
            'description': 'For tests',
            'supportsAutoMode': true,
            'supportsEffort': true,
            'supportedEffortLevels': <Object?>['low', 'high'],
          },
        ],
        'commands': <Object?>[
          <String, Object?>{
            'name': 'review',
            'description': 'Review changes',
            'argumentHint': <Object?>['path', 'focus'],
          },
        ],
        'agents': <Object?>[
          <String, Object?>{'name': 'reviewer', 'description': 'Reviews code'},
        ],
        'account': <String, Object?>{
          'email': 'sdk@example.com',
          'apiProvider': 'firstParty',
        },
        'output_style': 'default',
        'available_output_styles': <Object?>['default'],
      },
      'supported_commands' => <String, Object?>{
        'commands': <Object?>[
          <String, Object?>{
            'name': 'review',
            'description': 'Review changes',
            'argumentHint': <Object?>['path', 'focus'],
          },
        ],
      },
      'supported_agents' => <String, Object?>{
        'agents': <Object?>[
          <String, Object?>{'name': 'reviewer', 'description': 'Reviews code'},
        ],
      },
      'interrupt' => <String, Object?>{
        'still_queued': <Object?>['queued-id'],
      },
      'rewind_files' => <String, Object?>{
        'canRewind': true,
        'filesChanged': <Object?>[],
      },
      'set_mcp_permission_mode_override' => <String, Object?>{
        'warning': 'test warning',
      },
      'mcp_set_servers' => <String, Object?>{
        'added': <Object?>['dynamic'],
        'removed': <Object?>[],
        'errors': <String, Object?>{},
      },
      'background_tasks' => <String, Object?>{'backgrounded': true},
      'get_usage' => <String, Object?>{
        'session': <String, Object?>{'total_cost_usd': 0.1},
        'subscription_type': 'pro',
        'rate_limits_available': true,
        'rate_limits': <String, Object?>{},
      },
      'read_file' => <String, Object?>{
        'contents': 'aGVsbG8=',
        'absPath': '/tmp/example.png',
        'encoding': 'base64',
      },
      'reload_plugins' => <String, Object?>{
        'commands': <Object?>[],
        'agents': <Object?>[],
        'plugins': <Object?>[
          <String, Object?>{
            'name': 'test',
            'path': '/tmp/plugin',
            'version': '1.2.3',
          },
        ],
        'mcpServers': <Object?>[],
        'error_count': 0,
      },
      'reload_skills' => <String, Object?>{
        'skills': <Object?>[
          <String, Object?>{'name': 'review', 'description': 'Review'},
        ],
      },
      'mcp_status' => <String, Object?>{'mcpServers': <Object?>[]},
      'get_context_usage' => <String, Object?>{
        'categories': <Object?>[],
        'totalTokens': 10,
        'maxTokens': 100,
        'percentage': 10,
        'model': 'test-model',
      },
      _ => <String, Object?>{},
    };
    scheduleMicrotask(() => respondToControl(message, response));
  }

  Future<JsonMap> nextWriteWhere(bool Function(JsonMap) predicate) async {
    for (final value in written) {
      if (predicate(value)) return value;
    }
    return writeEvents
        .firstWhere(predicate)
        .timeout(const Duration(seconds: 2));
  }

  @override
  Future<void> endInput() async {
    inputEnded = true;
    _ready = false;
    if (!_controller.isClosed) await _controller.close();
  }

  @override
  Future<void> close() async {
    if (closed) return;
    closed = true;
    _ready = false;
    if (!_controller.isClosed) await _controller.close();
    await _writes.close();
  }
}
