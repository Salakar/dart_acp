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
      'initialize' => <String, Object?>{'commands': <Object?>[]},
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
