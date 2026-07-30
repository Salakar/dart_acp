import 'package:claude_agent_sdk/claude_agent_sdk.dart';
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

  test('decodes image, server result, commands, and stream helpers', () {
    final assistant =
        codec.decode({
              'type': 'assistant',
              'message': {
                'model': 'claude',
                'content': [
                  {
                    'type': 'image',
                    'source': {
                      'type': 'base64',
                      'media_type': 'image/png',
                      'data': 'AA==',
                    },
                  },
                  {
                    'type': 'web_search_tool_result',
                    'tool_use_id': 'search',
                    'content': [
                      {'title': 'Result'},
                    ],
                  },
                ],
              },
            })!
            as AssistantMessage;
    expect((assistant.content.first as ImageBlock).mediaType, 'image/png');
    expect(
      (assistant.content.last as ServerToolResultBlock).type,
      'web_search_tool_result',
    );

    final commands =
        codec.decode({
              'type': 'system',
              'subtype': 'commands_changed',
              'commands': [
                {
                  'name': 'review',
                  'description': 'Review code',
                  'argumentHint': ['path', 'focus'],
                },
              ],
            })!
            as CommandsChangedMessage;
    expect(commands.commands.single.argumentHint, 'path focus');

    final stream =
        codec.decode({
              'type': 'stream_event',
              'uuid': 'event',
              'session_id': 'session',
              'event': {
                'type': 'content_block_delta',
                'index': 2,
                'delta': {
                  'type': 'input_json_delta',
                  'partial_json': '{"path":',
                },
              },
            })!
            as StreamEventMessage;
    expect(stream.contentBlockIndex, 2);
    expect(stream.deltaType, 'input_json_delta');
    expect(stream.partialJson, '{"path":');
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
              'ttft_ms': 12,
              'ttft_stream_ms': 7,
              'time_to_request_ms': 3,
              'user_message_uuid': 'user-1',
              'request_sent_wall_ms': 1234,
              'time_to_request_from_spawn_ms': 5,
              'warm_spare_claimed': true,
              'time_origin_ms': 1200,
              'fast_mode_state': 'on',
              'origin': {'kind': 'human'},
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
    expect(result.timeToFirstToken, const Duration(milliseconds: 12));
    expect(result.streamTimeToFirstToken, const Duration(milliseconds: 7));
    expect(result.timeToRequest, const Duration(milliseconds: 3));
    expect(result.timeToRequestFromSpawn, const Duration(milliseconds: 5));
    expect(result.userMessageId, 'user-1');
    expect(result.warmSpareClaimed, isTrue);
    expect(result.fastModeState, 'on');
    expect(result.origin, containsPair('kind', 'human'));
  });

  test('decodes current replay, initialization, and hook metadata', () {
    final replay =
        codec.decode({
              'type': 'user',
              'message': {'content': 'restored'},
              'parent_tool_use_id': null,
              'uuid': 'user',
              'session_id': 'session',
              'isReplay': true,
              'file_attachments': [
                {'name': 'notes.txt'},
              ],
            })!
            as UserMessage;
    final initialization =
        codec.decode({
              'type': 'system',
              'subtype': 'init',
              'apiKeySource': 'environment',
              'claude_code_version': '2.1.0',
              'cwd': '/workspace',
              'tools': ['Read', 'Agent'],
              'mcp_servers': [
                {'name': 'local', 'status': 'connected'},
              ],
              'model': 'claude',
              'permissionMode': 'default',
              'slash_commands': ['compact'],
              'output_style': 'default',
              'skills': ['review'],
              'plugins': [
                {'name': 'tools', 'path': '/plugins/tools', 'version': '1.0.0'},
              ],
              'agents': ['test-runner'],
              'betas': ['context-1m-2025-08-07'],
              'capabilities': ['interrupt_receipt_v1'],
              'uuid': 'init',
              'session_id': 'session',
            })!
            as RuntimeInitializationMessage;
    final hook =
        codec.decode({
              'type': 'system',
              'subtype': 'hook_response',
              'hook_id': 'hook-1',
              'hook_name': 'audit',
              'hook_event': 'PostToolUse',
              'output': 'ok',
              'stdout': 'out',
              'stderr': '',
              'exit_code': 0,
              'outcome': 'success',
              'uuid': 'hook',
              'session_id': 'session',
            })!
            as HookEventMessage;

    expect(replay.isReplay, isTrue);
    expect(replay.fileAttachments.single, containsPair('name', 'notes.txt'));
    expect(initialization.agents, ['test-runner']);
    expect(initialization.mcpServers.single.name, 'local');
    expect(initialization.plugins.single.version, '1.0.0');
    expect(hook.hookId, 'hook-1');
    expect(hook.exitCode, 0);
    expect(hook.outcome, 'success');
  });

  test('decodes valid tool-result metadata and skips malformed entries', () {
    final user =
        codec.decode(<String, Object?>{
              'type': 'user',
              'message': <String, Object?>{
                'content': <Object?>[
                  <String, Object?>{
                    'type': 'tool_result',
                    'tool_use_id': 'tool-1',
                    'is_error': true,
                    'content': 'Permission denied',
                  },
                ],
              },
              'parent_tool_use_id': null,
              'tool_result_meta': <Object?>[
                <String, Object?>{
                  'id': 'tool-1',
                  'non_execution_kind': 'user-rejected',
                  'user_feedback': 'Use the package API',
                },
                <String, Object?>{'id': 'missing-kind'},
                'malformed',
              ],
            })!
            as UserMessage;

    expect(user.toolResultMetadata, hasLength(1));
    expect(user.toolResultMetadata.single.toolUseId, 'tool-1');
    expect(user.toolResultMetadata.single.nonExecutionKind, 'user-rejected');
    expect(user.toolResultMetadata.single.userFeedback, 'Use the package API');
  });

  test('decodes stream and rate-limit events', () {
    final stream = codec.decode({
      'type': 'stream_event',
      'uuid': 'event',
      'session_id': 'session',
      'event': {'type': 'content_block_delta'},
      'ttft_ms': 9,
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
    expect(
      (stream! as StreamEventMessage).timeToFirstToken,
      const Duration(milliseconds: 9),
    );
    final rateMessage = rate! as RateLimitEventMessage;
    expect(rateMessage.info.utilization, 0.5);
    expect(
      rateMessage.info.resetsAt,
      DateTime.fromMillisecondsSinceEpoch(100000, isUtc: true),
    );
  });

  test('preserves unknown message types for forward compatibility', () {
    final message = codec.decode({'type': 'future', 'new_field': 'kept'});

    expect(message, isA<UnknownAgentMessage>());
    final unknown = message as UnknownAgentMessage;
    expect(unknown.type, 'future');
    expect(unknown.raw['new_field'], 'kept');
  });

  test('decodes current subagent and top-level progress messages', () {
    final assistant =
        codec.decode({
              'type': 'assistant',
              'uuid': 'assistant-1',
              'session_id': 'session',
              'request_id': 'request-1',
              'aborted': true,
              'subagent_type': 'reviewer',
              'task_description': 'Review code',
              'timestamp': '2026-07-30T12:00:00Z',
              'supersedes': <Object?>['old-message'],
              'message': <String, Object?>{
                'model': 'claude',
                'content': <Object?>[],
              },
            })!
            as AssistantMessage;
    expect(assistant.subagentType, 'reviewer');
    expect(assistant.isAborted, isTrue);
    expect(assistant.supersedes, ['old-message']);

    final progress =
        codec.decode({
              'type': 'tool_progress',
              'tool_use_id': 'tool-1',
              'tool_name': 'Agent',
              'parent_tool_use_id': null,
              'elapsed_time_seconds': 1.5,
              'subagent_type': 'reviewer',
              'subagent_retry': <String, Object?>{'attempt': 2},
              'uuid': 'progress-1',
              'session_id': 'session',
            })!
            as ToolProgressMessage;
    expect(progress.elapsed, const Duration(milliseconds: 1500));
    expect(progress.subagentRetry, containsPair('attempt', 2));

    expect(
      codec.decode({
        'type': 'prompt_suggestion',
        'suggestion': 'Run the tests',
        'uuid': 'suggestion-1',
        'session_id': 'session',
      }),
      isA<PromptSuggestionMessage>(),
    );
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
