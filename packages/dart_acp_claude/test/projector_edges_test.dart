import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

void main() {
  const messages = ClaudeMessageProjector();

  test('projects image variants, commands, and filtered user text', () {
    final imageUpdates = messages.project(
      claude.AssistantMessage(
        content: <claude.ContentBlock>[
          claude.ImageBlock(
            source: <String, Object?>{
              'media_type': 'image/png',
              'data': 'YWJj',
            },
          ),
          claude.ImageBlock(
            source: <String, Object?>{'url': 'https://example.test/image.png'},
          ),
          claude.UnknownContentBlock(<String, Object?>{
            'type': 'image',
            'mimeType': 'image/jpeg',
            'data': 'ZA==',
          }),
          claude.UnknownContentBlock(<String, Object?>{'type': 'future'}),
        ],
        model: 'model',
        uuid: 'assistant-uuid',
      ),
      cwd: '/workspace',
    );
    expect(imageUpdates, hasLength(3));
    expect(
      imageUpdates.map((update) => update.discriminator),
      everyElement('agent_message_chunk'),
    );

    final commands = messages.project(
      claude.CommandsChangedMessage(
        data: const <String, Object?>{},
        commands: <claude.ClaudeCommandInfo>[
          claude.ClaudeCommandInfo.fromJson(<String, Object?>{
            'name': 'review',
            'description': 'Review files',
            'argumentHint': 'path',
          }),
        ],
      ),
      cwd: '/workspace',
    );
    expect(commands.single.toJson().toString(), contains('hint: path'));

    expect(
      messages.project(
        const claude.UserMessage.text(
          '<command-name>/model</command-name>',
          uuid: 'user',
        ),
        cwd: '/workspace',
      ),
      isEmpty,
    );
    final visible = messages.project(
      claude.UserMessage.blocks(<claude.ContentBlock>[
        const claude.TextBlock('<command-args>opus</command-args>visible'),
        const claude.TextBlock(''),
        claude.ImageBlock(
          source: <String, Object?>{'media_type': 'image/png', 'data': 'YWJj'},
        ),
      ], uuid: 'user'),
      cwd: '/workspace',
    );
    expect(visible.single.toJson().toString(), contains('visible'));
  });

  test('covers streaming thought, invalid tool input, and unknown events', () {
    final state = ClaudeMessageProjectionState()..beginTurn();
    claude.StreamEventMessage stream(
      String type, {
      int? index,
      Map<String, Object?>? block,
      Map<String, Object?>? delta,
      String? parent,
    }) => claude.StreamEventMessage(
      uuid: 'event',
      sessionId: 'session',
      parentToolUseId: parent,
      event: <String, Object?>{
        'type': type,
        'index': ?index,
        'content_block': ?block,
        'delta': ?delta,
      },
    );

    expect(
      messages.project(stream('future_event'), cwd: '/workspace', state: state),
      isEmpty,
    );
    expect(
      messages
          .project(
            stream(
              'content_block_start',
              index: 0,
              block: <String, Object?>{
                'type': 'thinking',
                'thinking': 'initial thought',
              },
              parent: 'parent',
            ),
            cwd: '/workspace',
            state: state,
          )
          .single
          .toJson()
          .toString(),
      allOf(contains('initial thought'), contains('parentToolUseId')),
    );
    expect(
      messages
          .project(
            stream(
              'content_block_delta',
              index: 0,
              delta: <String, Object?>{
                'type': 'thinking_delta',
                'thinking': ' more',
              },
            ),
            cwd: '/workspace',
            state: state,
          )
          .single
          .discriminator,
      'agent_thought_chunk',
    );
    expect(
      messages.project(
        stream(
          'content_block_start',
          index: 1,
          block: <String, Object?>{'type': 'tool_use'},
        ),
        cwd: '/workspace',
        state: state,
      ),
      isEmpty,
    );
    messages.project(
      stream(
        'content_block_start',
        index: 2,
        block: <String, Object?>{
          'type': 'tool_use',
          'id': 'invalid-json',
          'name': 'Read',
        },
      ),
      cwd: '/workspace',
      state: state,
    );
    messages.project(
      stream(
        'content_block_delta',
        index: 2,
        delta: <String, Object?>{
          'type': 'input_json_delta',
          'partial_json': '{',
        },
      ),
      cwd: '/workspace',
      state: state,
    );
    expect(
      messages.project(
        stream('content_block_stop', index: 2),
        cwd: '/workspace',
        state: state,
      ),
      isEmpty,
    );
    expect(
      messages.project(
        stream('content_block_stop', index: 2),
        cwd: '/workspace',
        state: state,
      ),
      isEmpty,
    );
    expect(
      messages.project(
        stream('content_block_stop', index: 99),
        cwd: '/workspace',
        state: state,
      ),
      isEmpty,
    );
    expect(
      messages.project(
        stream(
          'message_delta',
          delta: <String, Object?>{'type': 'message_delta'},
        ),
        cwd: '/workspace',
      ),
      isEmpty,
    );
  });

  test('patches, deduplicates, and scopes streaming usage snapshots', () {
    final state = ClaudeMessageProjectionState()..beginTurn();
    List<SessionUpdate> project(
      String type,
      Map<String, Object?> payload, {
      String? parent,
    }) => messages.project(
      claude.StreamEventMessage(
        uuid: 'event',
        sessionId: 'session',
        parentToolUseId: parent,
        event: <String, Object?>{'type': type, ...payload},
      ),
      cwd: '/workspace',
      state: state,
    );

    final start = project('message_start', <String, Object?>{
      'message': <String, Object?>{
        'id': 'message',
        'model': 'claude-model-1m',
        'usage': <String, Object?>{
          'input_tokens': 10,
          'cache_read_input_tokens': 2,
        },
      },
    }).single.toJson();
    expect(start, containsPair('used', 12));
    expect(start, containsPair('size', 1000000));

    expect(
      project('message_delta', <String, Object?>{
        'usage': <String, Object?>{'output_tokens': 3},
      }).single.toJson(),
      containsPair('used', 15),
    );
    expect(
      project('message_delta', <String, Object?>{
        'usage': <String, Object?>{'output_tokens': 3},
      }),
      isEmpty,
    );
    expect(
      project('message_delta', <String, Object?>{
        'usage': <String, Object?>{'output_tokens': 4},
      }, parent: 'subagent'),
      isEmpty,
    );
  });

  test('uses model context, UUID fallback, and handles unrelated systems', () {
    final state = ClaudeMessageProjectionState()..beginTurn();
    final result = messages.project(
      claude.ResultMessage(
        subtype: 'success',
        duration: Duration.zero,
        apiDuration: Duration.zero,
        isError: false,
        turns: 1,
        sessionId: 'session',
        totalCostUsd: 1.25,
        usage: <String, Object?>{
          'input_tokens': 1,
          'cache_read_input_tokens': 2,
          'cache_creation_input_tokens': 3,
          'output_tokens': 4,
        },
        modelUsage: const <String, claude.ModelUsage>{
          'model': claude.ModelUsage(
            inputTokens: 1,
            outputTokens: 4,
            cacheReadInputTokens: 2,
            cacheCreationInputTokens: 3,
            webSearchRequests: 0,
            costUsd: 1.25,
            contextWindow: 1000000,
            maxOutputTokens: 8192,
          ),
        },
      ),
      cwd: '/workspace',
      state: state,
    );
    expect(result.single.toJson(), containsPair('size', 1000000));
    expect(result.single.toJson().toString(), contains('USD'));

    state.beginTurn();
    final nextTurnUsage = messages.project(
      claude.StreamEventMessage(
        uuid: 'next-turn',
        sessionId: 'session',
        event: <String, Object?>{
          'type': 'message_start',
          'message': <String, Object?>{
            'model': 'opaque-provider-model',
            'usage': <String, Object?>{'input_tokens': 1},
          },
        },
      ),
      cwd: '/workspace',
      state: state,
    );
    expect(nextTurnUsage.single.toJson(), containsPair('size', 1000000));

    final text = messages.project(
      claude.AssistantMessage(
        content: const <claude.ContentBlock>[claude.TextBlock('text')],
        model: 'model',
        uuid: 'fallback-uuid',
      ),
      cwd: '/workspace',
    );
    expect(text.single.toJson(), containsPair('messageId', 'fallback-uuid'));
    expect(
      messages.project(
        claude.SystemMessage(
          subtype: 'unrelated',
          data: const <String, Object?>{},
        ),
        cwd: '/workspace',
      ),
      isEmpty,
    );
  });

  test('maps URL images and embedded binary resources', () {
    const prompts = ClaudePromptMapper();
    final input = prompts.map(<ContentBlock>[
      ContentBlockImage(
        ImageContent(
          data: '',
          mimeType: 'image/png',
          uri: 'https://example.test/image.png',
        ),
      ),
      ContentBlockResource(
        EmbeddedResource(
          resource: EmbeddedResourceResourceBlobResourceContents(
            BlobResourceContents(
              uri: 'file:///image',
              blob: 'YWJj',
              mimeType: 'image/png',
            ),
          ),
        ),
      ),
      ContentBlockResource(
        EmbeddedResource(
          resource: EmbeddedResourceResourceBlobResourceContents(
            BlobResourceContents(
              uri: 'file:///binary',
              blob: 'AA==',
              mimeType: 'application/octet-stream',
            ),
          ),
        ),
      ),
      ContentBlockResourceLink(
        ResourceLink(name: '', uri: 'file:///tmp/readme.md'),
      ),
      ContentBlockResourceLink(
        ResourceLink(name: '', uri: 'https://example.test/resource'),
      ),
      ContentBlockText(TextContent(text: '/mcp:review')),
    ]);
    expect(input.content.toString(), contains('example.test/image.png'));
    expect(input.content.toString(), contains('encoding="base64"'));
    expect(input.content.toString(), contains('[@readme.md]'));
    expect(input.content.toString(), contains('/review (MCP)'));
  });

  test(
    'projects current informational, refusal, memory, and denial events',
    () {
      final state = ClaudeMessageProjectionState()..beginTurn();
      final informational = messages.project(
        claude.InformationalMessage(
          data: const <String, Object?>{},
          content: 'Hook blocked the prompt.',
          level: 'warning',
          uuid: 'info',
          sessionId: 'session',
        ),
        cwd: '/workspace',
        state: state,
      );
      final refusal = messages.project(
        claude.ModelRefusalFallbackMessage(
          data: const <String, Object?>{},
          direction: 'retry',
          originalModel: 'opus',
          fallbackModel: 'sonnet',
          content: 'Retrying with a fallback model.',
          explanation: 'The first model refused.',
          uuid: 'refusal',
          sessionId: 'session',
        ),
        cwd: '/workspace',
        state: state,
      );
      final memory = messages.project(
        claude.MemoryRecallMessage(
          data: const <String, Object?>{},
          mode: 'select',
          memories: const <claude.RecalledMemory>[
            claude.RecalledMemory(
              path: '/workspace/MEMORY.md',
              scope: 'project',
            ),
          ],
          uuid: 'memory',
          sessionId: 'session',
        ),
        cwd: '/workspace',
      );
      final denied = messages.project(
        claude.PermissionDeniedMessage(
          data: const <String, Object?>{},
          toolName: 'Bash',
          toolUseId: 'tool',
          message: 'Denied by policy.',
          uuid: 'denied',
          sessionId: 'session',
          decisionReasonType: 'rule',
          decisionReason: 'Command is blocked.',
        ),
        cwd: '/workspace',
      );

      expect(informational.single.toJson().toString(), contains('warning'));
      expect(refusal.single.toJson().toString(), contains('fallback model'));
      expect(memory.single.toJson().toString(), contains('MEMORY.md'));
      expect(
        denied.single.toJson().toString(),
        contains('Permission denied: Command is blocked.'),
      );
    },
  );

  test('projects tool progress, rate limits, and runtime notices', () {
    final state = ClaudeMessageProjectionState()..beginTurn();
    state.surfaceTool('agent');
    final progress = messages.project(
      claude.ToolProgressMessage(
        toolUseId: 'synthetic-heartbeat',
        toolName: 'Agent',
        elapsed: const Duration(milliseconds: 2500),
        uuid: 'progress',
        sessionId: 'session',
        parentToolUseId: 'agent',
        subagentType: 'reviewer',
        subagentRetry: const <String, Object?>{'attempt': 2},
      ),
      cwd: '/workspace',
      state: state,
    );
    expect(
      progress.single.toJson().toString(),
      allOf(
        contains('toolCallId: agent'),
        contains('elapsedTimeSeconds: 2.5'),
        contains('reviewer'),
        contains('attempt: 2'),
      ),
    );

    messages.project(
      claude.StreamEventMessage(
        uuid: 'start',
        sessionId: 'session',
        event: <String, Object?>{
          'type': 'message_start',
          'message': <String, Object?>{
            'usage': <String, Object?>{'input_tokens': 15},
          },
        },
      ),
      cwd: '/workspace',
      state: state,
    );
    final rateLimit = messages.project(
      claude.RateLimitEventMessage(
        info: claude.RateLimitInfo(
          status: claude.RateLimitStatus.allowedWarning,
          raw: const <String, Object?>{
            'status': 'allowed_warning',
            'utilization': 0.9,
          },
        ),
        uuid: 'limit',
        sessionId: 'session',
      ),
      cwd: '/workspace',
      state: state,
    );
    expect(
      rateLimit.single.toJson().toString(),
      allOf(contains('used: 15'), contains('_claude/rateLimit')),
    );

    final compacting = messages.project(
      claude.RuntimeStatusMessage(
        data: const <String, Object?>{},
        uuid: 'status',
        sessionId: 'session',
        status: 'compacting',
      ),
      cwd: '/workspace',
      state: state,
    );
    final compacted = messages.project(
      claude.RuntimeStatusMessage(
        data: const <String, Object?>{},
        uuid: 'status',
        sessionId: 'session',
        compactResult: 'success',
      ),
      cwd: '/workspace',
      state: state,
    );
    final local = messages.project(
      claude.LocalCommandOutputMessage(
        data: const <String, Object?>{},
        content: 'Local output',
        uuid: 'local',
        sessionId: 'session',
      ),
      cwd: '/workspace',
      state: state,
    );
    expect(compacting.single.toJson().toString(), contains('Compacting...'));
    expect(compacted.single.toJson().toString(), contains('completed'));
    expect(local.single.toJson().toString(), contains('Local output'));
  });
}
