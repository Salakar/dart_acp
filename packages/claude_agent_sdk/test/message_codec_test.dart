import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:claude_agent_sdk/src/messages/message_codec.dart';
import 'package:test/test.dart';

void main() {
  const codec = MessageCodec();

  test('decodes text and structured user messages', () {
    final text = codec.decode({
      'type': 'user',
      'uuid': 'u1',
      'message': {'content': 'hello'},
    });
    final blocks = codec.decode({
      'type': 'user',
      'message': {
        'content': [
          {'type': 'text', 'text': 'hello'},
          {'type': 'tool_result', 'tool_use_id': 't1', 'content': 'done'},
        ],
      },
    });

    expect(text, isA<UserMessage>());
    expect((text! as UserMessage).text, 'hello');
    final blockMessage = blocks! as UserMessage;
    expect(blockMessage.blocks, hasLength(2));
    expect(blockMessage.blocks.last, isA<ToolResultBlock>());
  });

  test('decodes assistant content and preserves unknown blocks', () {
    final message = codec.decode({
      'type': 'assistant',
      'message': {
        'id': 'msg',
        'model': 'claude',
        'content': [
          {'type': 'thinking', 'thinking': 'hmm', 'signature': 'sig'},
          {
            'type': 'tool_use',
            'id': 'tool',
            'name': 'Read',
            'input': {'file_path': 'a'},
          },
          {'type': 'future_block', 'value': 42},
        ],
      },
    });

    final assistant = message! as AssistantMessage;
    expect(assistant.content[0], isA<ThinkingBlock>());
    expect(assistant.content[1], isA<ToolUseBlock>());
    expect(assistant.content[2], isA<UnknownContentBlock>());
    expect((assistant.content[2] as UnknownContentBlock).raw['value'], 42);
  });

  test('decodes task lifecycle models', () {
    final started = codec.decode({
      'type': 'system',
      'subtype': 'task_started',
      'task_id': 'task',
      'description': 'work',
      'uuid': 'event',
      'session_id': 'session',
      'task_type': 'local_agent',
    });
    final progress = codec.decode({
      'type': 'system',
      'subtype': 'task_progress',
      'task_id': 'task',
      'description': 'working',
      'usage': {'total_tokens': 4, 'tool_uses': 1, 'duration_ms': 20},
      'uuid': 'event-2',
      'session_id': 'session',
    });
    final completed = codec.decode({
      'type': 'system',
      'subtype': 'task_notification',
      'task_id': 'task',
      'status': 'completed',
      'output_file': '/tmp/output',
      'summary': 'done',
      'uuid': 'event-3',
      'session_id': 'session',
    });

    expect(started, isA<TaskStartedMessage>());
    expect((progress! as TaskProgressMessage).usage.totalTokens, 4);
    expect(
      (completed! as TaskNotificationMessage).status,
      TaskStatus.completed,
    );
  });

  test('decodes full result metadata', () {
    final result =
        codec.decode({
              'type': 'result',
              'subtype': 'success',
              'duration_ms': 100,
              'duration_api_ms': 80,
              'is_error': false,
              'num_turns': 2,
              'session_id': 'session',
              'total_cost_usd': 0.01,
              'structured_output': {'answer': 42},
              'permission_denials': [
                {'tool': 'Bash'},
              ],
              'modelUsage': {
                'claude': {
                  'inputTokens': 1,
                  'outputTokens': 2,
                  'cacheReadInputTokens': 3,
                  'cacheCreationInputTokens': 4,
                  'webSearchRequests': 0,
                  'costUSD': 0.01,
                  'contextWindow': 200000,
                  'maxOutputTokens': 32000,
                },
              },
            })!
            as ResultMessage;

    expect(result.duration, const Duration(milliseconds: 100));
    expect(result.structuredOutput, containsPair('answer', 42));
    expect(result.modelUsage!['claude']!.outputTokens, 2);
    expect(result.permissionDenials, hasLength(1));
  });

  test('decodes stream and rate-limit events', () {
    final stream = codec.decode({
      'type': 'stream_event',
      'uuid': 'event',
      'session_id': 'session',
      'event': {'type': 'content_block_delta'},
    });
    final rate = codec.decode({
      'type': 'rate_limit_event',
      'uuid': 'rate',
      'session_id': 'session',
      'rate_limit_info': {
        'status': 'allowed',
        'rateLimitType': 'five_hour',
        'utilization': 0.5,
        'resetsAt': 100,
      },
    });

    expect(stream, isA<StreamEventMessage>());
    final rateMessage = rate! as RateLimitEventMessage;
    expect(rateMessage.info.utilization, 0.5);
    expect(
      rateMessage.info.resetsAt,
      DateTime.fromMillisecondsSinceEpoch(100000, isUtc: true),
    );
  });

  test('returns null for unknown message types', () {
    expect(codec.decode({'type': 'future'}), isNull);
  });

  test('wraps malformed known messages with raw data', () {
    expect(
      () => codec.decode({'type': 'assistant', 'message': <String, Object?>{}}),
      throwsA(
        isA<MessageParseException>().having(
          (error) => error.data?['type'],
          'raw type',
          'assistant',
        ),
      ),
    );
  });
}
