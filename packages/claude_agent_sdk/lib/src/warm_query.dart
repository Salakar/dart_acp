import 'dart:async';

import 'client.dart';
import 'errors.dart';
import 'input.dart';
import 'messages/message.dart';
import 'options.dart';
import 'transport/transport.dart';

/// Pre-warms a Claude Code process and completes its initialize handshake.
///
/// The returned handle accepts exactly one prompt. Supply [transport] only
/// for custom remote bridges or deterministic tests.
Future<ClaudeWarmQuery> startup({
  ClaudeAgentOptions? options,
  Duration? initializeTimeout,
  Transport? transport,
}) async {
  final client = ClaudeAgentClient(options: options, transport: transport);
  try {
    await client.connect(initializeTimeout: initializeTimeout);
    return ClaudeWarmQuery._(client);
  } catch (_) {
    await client.close();
    rethrow;
  }
}

/// A connected, initialized process reserved for one low-latency query.
final class ClaudeWarmQuery {
  ClaudeWarmQuery._(this._client);

  final ClaudeAgentClient _client;
  bool _claimed = false;
  bool _closed = false;

  /// Sends one text [prompt] to the pre-warmed process.
  Stream<AgentMessage> query(String prompt) =>
      queryStream(Stream<UserInput>.value(UserInput.text(prompt)));

  /// Sends one finite typed input stream to the pre-warmed process.
  Stream<AgentMessage> queryStream(Stream<UserInput> input) async* {
    if (_closed) {
      throw const CliConnectionException('Warm query is already closed');
    }
    if (_claimed) {
      throw StateError('A warm query can only be claimed once');
    }
    _claimed = true;
    try {
      unawaited(_client.sendStream(input));
      yield* _client.receiveResponse();
    } finally {
      await close();
    }
  }

  /// Discards the warm process or closes it after its query.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _client.close();
  }
}
