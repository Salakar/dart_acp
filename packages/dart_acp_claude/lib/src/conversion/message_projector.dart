import 'dart:convert';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import 'local_command_filter.dart';
import 'plan_projector.dart';
import 'tool_projector.dart';

/// Incremental state used while projecting one streamed assistant message.
final class ClaudeMessageProjectionState {
  final Map<int, _StreamedText> _text = <int, _StreamedText>{};
  final Map<int, _StreamedTool> _tools = <int, _StreamedTool>{};
  final Map<String, ToolUseBlock> _toolUses = <String, ToolUseBlock>{};
  final Set<String> _surfacedToolIds = <String>{};
  String? _messageId;
  bool _emittedAgentText = false;
  int _inputTokens = 0;
  int _outputTokens = 0;
  int _cacheReadTokens = 0;
  int _cacheWriteTokens = 0;
  int _lastStreamUsage = -1;
  int _defaultContextWindow = 200000;
  int _contextWindow = 200000;
  bool _compactionInProgress = false;

  /// Execution-plan state retained across turns in one ACP session.
  final ClaudePlanProjector plan = ClaudePlanProjector();

  /// Resets the transient projection state for a new user turn.
  void beginTurn() {
    _reset(null);
    _emittedAgentText = false;
    _inputTokens = 0;
    _outputTokens = 0;
    _cacheReadTokens = 0;
    _cacheWriteTokens = 0;
    _lastStreamUsage = -1;
    _contextWindow = _defaultContextWindow;
  }

  /// Seeds the context window used by usage updates in this and later turns.
  void seedContextWindow(int size) {
    if (size <= 0) return;
    _defaultContextWindow = size;
    _contextWindow = size;
  }

  /// Context window currently reported to ACP usage updates.
  int get contextWindowSize => _contextWindow;

  /// Whether [toolUseId] has already been sent to the ACP client.
  bool hasSurfacedTool(String toolUseId) =>
      _surfacedToolIds.contains(toolUseId);

  /// Marks [toolUseId] as already sent to the ACP client.
  void surfaceTool(String toolUseId) => _surfacedToolIds.add(toolUseId);

  /// Retains [block] until its matching tool result arrives.
  void recordTool(ToolUseBlock block) => _toolUses[block.id] = block;

  void _reset(String? messageId) {
    _text.clear();
    _tools.clear();
    _messageId = messageId;
  }

  void _clear() => _reset(null);
}

/// Converts typed Claude messages to typed ACP session updates.
final class ClaudeMessageProjector {
  /// Creates a message projector.
  const ClaudeMessageProjector({this.tools = const ClaudeToolProjector()});

  /// Tool conversion policy.
  final ClaudeToolProjector tools;

  /// Projects [message] into zero or more updates.
  List<SessionUpdate> project(
    AgentMessage message, {
    required String cwd,
    bool supportsTerminalOutput = false,
    bool supportsSubagentTranscript = true,
    ClaudeMessageProjectionState? state,
  }) {
    return switch (message) {
      AssistantMessage() => _assistant(
        message,
        cwd,
        supportsTerminalOutput,
        supportsSubagentTranscript,
        state,
      ),
      UserMessage() => _user(
        message,
        state,
        supportsTerminalOutput,
        supportsSubagentTranscript,
      ),
      ResultMessage() => _result(message, state),
      SystemMessage() => _system(message, state),
      StreamEventMessage() => _stream(
        message,
        state,
        cwd: cwd,
        supportsTerminalOutput: supportsTerminalOutput,
      ),
      ToolProgressMessage() => _toolProgress(message, state),
      RateLimitEventMessage() => _rateLimit(message, state),
      _ => const <SessionUpdate>[],
    };
  }

  List<SessionUpdate> _assistant(
    AssistantMessage message,
    String cwd,
    bool supportsTerminalOutput,
    bool supportsSubagentTranscript,
    ClaudeMessageProjectionState? state,
  ) {
    final updates = <SessionUpdate>[];
    for (final indexed in message.content.indexed) {
      final (index, block) = indexed;
      switch (block) {
        case TextBlock(:final text) when text.isNotEmpty:
          if (message.parentToolUseId != null && !supportsSubagentTranscript) {
            break;
          }
          final suffix = _unstreamed(text, state?._text[index]?.value);
          if (suffix.isNotEmpty) {
            state?._emittedAgentText = true;
            updates.add(_chunk('agent_message_chunk', suffix, message));
          }
        case ThinkingBlock(:final thinking) when thinking.isNotEmpty:
          if (message.parentToolUseId != null && !supportsSubagentTranscript) {
            break;
          }
          final suffix = _unstreamed(thinking, state?._text[index]?.value);
          if (suffix.isNotEmpty) {
            updates.add(_chunk('agent_thought_chunk', suffix, message));
          }
        case ToolUseBlock():
          state?.recordTool(block);
          final surfaced = state?.hasSurfacedTool(block.id) ?? false;
          final streamedPlan =
              _planOnlyTools.contains(block.name) &&
              (state?._tools[index]?.stopped ?? false);
          final plan = surfaced || streamedPlan
              ? null
              : state?.plan.start(block);
          if (plan != null) {
            updates.add(_withAssistantMetadata(plan, message));
          } else if (!surfaced &&
              !_planOnlyTools.contains(block.name) &&
              (state == null || !state._tools.containsKey(index))) {
            updates.add(
              _withAssistantMetadata(
                tools.start(
                  block,
                  cwd: cwd,
                  supportsTerminalOutput: supportsTerminalOutput,
                ),
                message,
              ),
            );
            state?.surfaceTool(block.id);
          } else if (surfaced &&
              !_planOnlyTools.contains(block.name) &&
              !(state?._tools[index]?.stopped ?? false)) {
            // Streaming surfaced this call from `content_block_start`, where
            // `input` is still empty, and the completed input exists only here.
            // The CLI sends this assistant message BEFORE the matching
            // `content_block_stop`, and this method clears the streamed state
            // on its way out — so the stop handler that would have carried the
            // input never sees the tool, and a client is left with a tool call
            // it cannot describe. Send the input as an update instead.
            updates.add(
              _withAssistantMetadata(
                SessionUpdate.fromJson(<String, Object?>{
                  ...tools
                      .start(
                        block,
                        cwd: cwd,
                        supportsTerminalOutput: supportsTerminalOutput,
                      )
                      .toJson(),
                  'sessionUpdate': 'tool_call_update',
                  'toolCallId': block.id,
                  'status': 'in_progress',
                  'rawInput': block.input,
                }),
                message,
              ),
            );
          }
        case UnknownContentBlock(:final raw):
          if (message.parentToolUseId != null && !supportsSubagentTranscript) {
            break;
          }
          if (raw['type'] == 'image') {
            updates.add(
              SessionUpdate.fromJson(<String, Object?>{
                'sessionUpdate': 'agent_message_chunk',
                'content': raw,
                'messageId': ?_messageId(message),
                '_meta': ?_assistantMetadata(message),
              }),
            );
          }
        case ImageBlock(:final source):
          if (message.parentToolUseId != null && !supportsSubagentTranscript) {
            break;
          }
          final mimeType =
              source['media_type'] as String? ?? source['mediaType'] as String?;
          final data = source['data'];
          final url = source['url'];
          if (mimeType is String && data is String) {
            updates.add(
              SessionUpdate.fromJson(<String, Object?>{
                'sessionUpdate': 'agent_message_chunk',
                'content': <String, Object?>{
                  'type': 'image',
                  'mimeType': mimeType,
                  'data': data,
                },
                'messageId': ?_messageId(message),
                '_meta': ?_assistantMetadata(message),
              }),
            );
          } else if (url is String) {
            updates.add(
              SessionUpdate.fromJson(<String, Object?>{
                'sessionUpdate': 'agent_message_chunk',
                'content': <String, Object?>{
                  'type': 'text',
                  'text': '![Image]($url)',
                },
                'messageId': ?_messageId(message),
                '_meta': ?_assistantMetadata(message),
              }),
            );
          }
        case ToolResultBlock() ||
            ServerToolUseBlock() ||
            ServerToolResultBlock():
          break;
        default:
          break;
      }
    }
    state?._clear();
    return updates;
  }

  List<SessionUpdate> _stream(
    StreamEventMessage message,
    ClaudeMessageProjectionState? state, {
    required String cwd,
    required bool supportsTerminalOutput,
  }) {
    if (state == null) return const <SessionUpdate>[];
    final event = message.event;
    switch (message.eventType) {
      case 'message_start':
        final rawMessage = event['message'];
        final messageJson = rawMessage is Map<Object?, Object?>
            ? rawMessage
            : const <Object?, Object?>{};
        final messageId = messageJson['id'] as String?;
        state._reset(
          messageId == null || messageId.isEmpty ? message.uuid : messageId,
        );
        return _streamUsage(
          messageJson['usage'],
          state,
          reset: true,
          model: messageJson['model'],
          include: message.parentToolUseId == null,
        );
      case 'message_delta':
        return _streamUsage(
          event['usage'],
          state,
          include: message.parentToolUseId == null,
        );
      case 'content_block_start':
        return _streamStart(message, state);
      case 'content_block_delta':
        return _streamDelta(message, state);
      case 'content_block_stop':
        return _streamStop(
          message,
          state,
          cwd: cwd,
          supportsTerminalOutput: supportsTerminalOutput,
        );
      default:
        return const <SessionUpdate>[];
    }
  }

  List<SessionUpdate> _streamStart(
    StreamEventMessage message,
    ClaudeMessageProjectionState state,
  ) {
    final index = message.contentBlockIndex;
    final rawBlock = message.event['content_block'];
    if (index == null || rawBlock is! Map<Object?, Object?>) {
      return const <SessionUpdate>[];
    }
    final type = rawBlock['type'];
    if (type == 'text' || type == 'thinking') {
      final initial =
          (rawBlock['text'] ?? rawBlock['thinking']) as String? ?? '';
      state._text[index] = _StreamedText(type == 'thinking', initial);
      if (initial.isEmpty) return const <SessionUpdate>[];
      if (type == 'text') state._emittedAgentText = true;
      return <SessionUpdate>[
        _streamChunk(
          type == 'thinking' ? 'agent_thought_chunk' : 'agent_message_chunk',
          initial,
          message,
          state,
        ),
      ];
    }
    if (type != 'tool_use') return const <SessionUpdate>[];
    final id = rawBlock['id'] as String?;
    final name = rawBlock['name'] as String?;
    if (id == null || id.isEmpty || name == null || name.isEmpty) {
      return const <SessionUpdate>[];
    }
    final tool = _StreamedTool(id: id, name: name);
    state._tools[index] = tool;
    if (_planOnlyTools.contains(name)) return const <SessionUpdate>[];
    if (state.hasSurfacedTool(id)) return const <SessionUpdate>[];
    state.surfaceTool(id);
    return <SessionUpdate>[
      SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': 'tool_call',
        'toolCallId': id,
        'title': name,
        'kind': 'other',
        'status': 'pending',
        'rawInput': <String, Object?>{
          if (rawBlock['input'] case final Map<Object?, Object?> input)
            for (final entry in input.entries)
              if (entry.key is String) entry.key! as String: entry.value,
        },
        'messageId': ?state._messageId,
      }),
    ];
  }

  List<SessionUpdate> _streamDelta(
    StreamEventMessage message,
    ClaudeMessageProjectionState state,
  ) {
    final index = message.contentBlockIndex;
    if (index == null) return const <SessionUpdate>[];
    final deltaType = message.deltaType;
    if (deltaType == 'text_delta' || deltaType == 'thinking_delta') {
      final text = message.textDelta;
      if (text == null || text.isEmpty) return const <SessionUpdate>[];
      final streamed = state._text.putIfAbsent(
        index,
        () => _StreamedText(deltaType == 'thinking_delta', ''),
      );
      streamed.value += text;
      if (!streamed.thinking) state._emittedAgentText = true;
      return <SessionUpdate>[
        _streamChunk(
          streamed.thinking ? 'agent_thought_chunk' : 'agent_message_chunk',
          text,
          message,
          state,
        ),
      ];
    }
    if (deltaType == 'input_json_delta') {
      final partial = message.partialJson;
      if (partial != null && partial.isNotEmpty) {
        state._tools[index]?.input.write(partial);
      }
    }
    return const <SessionUpdate>[];
  }

  List<SessionUpdate> _streamStop(
    StreamEventMessage message,
    ClaudeMessageProjectionState state, {
    required String cwd,
    required bool supportsTerminalOutput,
  }) {
    final index = message.contentBlockIndex;
    final tool = index == null ? null : state._tools[index];
    if (tool == null || tool.stopped || tool.input.isEmpty) {
      return const <SessionUpdate>[];
    }
    tool.stopped = true;
    try {
      final decoded = jsonDecode(tool.input.toString());
      if (decoded is! Map<Object?, Object?>) return const <SessionUpdate>[];
      final input = <String, Object?>{
        for (final entry in decoded.entries)
          if (entry.key is String) entry.key! as String: entry.value,
      };
      final block = ToolUseBlock(id: tool.id, name: tool.name, input: input);
      state.recordTool(block);
      if (_planOnlyTools.contains(tool.name)) {
        final plan = state.plan.start(block);
        if (plan == null) return const <SessionUpdate>[];
        final json = plan.toJson();
        return <SessionUpdate>[
          SessionUpdate.fromJson(<String, Object?>{
            ...json,
            'messageId': ?state._messageId,
            if (message.parentToolUseId case final parent?)
              '_meta': <String, Object?>{
                'claude': <String, Object?>{'parentToolUseId': parent},
              },
          }),
        ];
      }
      final start = tools
          .start(
            block,
            cwd: cwd,
            supportsTerminalOutput: supportsTerminalOutput,
          )
          .toJson();
      return <SessionUpdate>[
        SessionUpdate.fromJson(<String, Object?>{
          ...start,
          'sessionUpdate': 'tool_call_update',
          'toolCallId': tool.id,
          'status': 'in_progress',
          'rawInput': input,
          'messageId': ?state._messageId,
          if (message.parentToolUseId case final parent?)
            '_meta': <String, Object?>{
              'claude': <String, Object?>{'parentToolUseId': parent},
            },
        }),
      ];
    } on FormatException {
      return const <SessionUpdate>[];
    }
  }

  List<SessionUpdate> _streamUsage(
    Object? rawUsage,
    ClaudeMessageProjectionState state, {
    bool reset = false,
    Object? model,
    required bool include,
  }) {
    if (!include || rawUsage is! Map<Object?, Object?>) {
      return const <SessionUpdate>[];
    }
    if (reset) {
      state
        .._inputTokens = 0
        .._outputTokens = 0
        .._cacheReadTokens = 0
        .._cacheWriteTokens = 0
        .._lastStreamUsage = -1;
    }
    if (rawUsage['input_tokens'] is int) {
      state._inputTokens = rawUsage['input_tokens']! as int;
    }
    if (rawUsage['output_tokens'] is int) {
      state._outputTokens = rawUsage['output_tokens']! as int;
    }
    if (rawUsage['cache_read_input_tokens'] is int) {
      state._cacheReadTokens = rawUsage['cache_read_input_tokens']! as int;
    }
    if (rawUsage['cache_creation_input_tokens'] is int) {
      state._cacheWriteTokens = rawUsage['cache_creation_input_tokens']! as int;
    }
    if (model is String && model.toLowerCase().contains('1m')) {
      state.seedContextWindow(1000000);
    }
    final used =
        state._inputTokens +
        state._outputTokens +
        state._cacheReadTokens +
        state._cacheWriteTokens;
    if (used == 0 || used == state._lastStreamUsage) {
      return const <SessionUpdate>[];
    }
    state._lastStreamUsage = used;
    return <SessionUpdate>[
      SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': 'usage_update',
        'used': used,
        'size': state._contextWindow,
      }),
    ];
  }

  SessionUpdate _streamChunk(
    String type,
    String text,
    StreamEventMessage message,
    ClaudeMessageProjectionState state,
  ) => SessionUpdate.fromJson(<String, Object?>{
    'sessionUpdate': type,
    'content': <String, Object?>{'type': 'text', 'text': text},
    'messageId': ?state._messageId,
    if (message.parentToolUseId case final parent?)
      '_meta': <String, Object?>{
        'claude': <String, Object?>{'parentToolUseId': parent},
      },
  });

  List<SessionUpdate> _user(
    UserMessage message,
    ClaudeMessageProjectionState? state,
    bool supportsTerminalOutput,
    bool supportsSubagentTranscript,
  ) {
    final visibleText = stripClaudeLocalCommandMetadata(message.text);
    final updates = <SessionUpdate>[
      if (supportsSubagentTranscript || message.parentToolUseId == null)
        if (visibleText case final String text)
          if (text.isNotEmpty)
            SessionUpdate.fromJson(<String, Object?>{
              'sessionUpdate': 'user_message_chunk',
              'content': <String, Object?>{'type': 'text', 'text': text},
              'messageId': ?message.uuid,
              '_meta': ?_userMetadata(message),
            }),
    ];
    final toolResultCount = message.blocks.whereType<ToolResultBlock>().length;
    final resultMetadata = <String, ToolResultMetadata>{
      for (final metadata in message.toolResultMetadata)
        metadata.toolUseId: metadata,
    };
    for (final block in message.blocks) {
      if (block is ToolResultBlock) {
        final wasSurfaced = state?.hasSurfacedTool(block.toolUseId) ?? false;
        state?._surfacedToolIds.remove(block.toolUseId);
        final tool = state?._toolUses.remove(block.toolUseId);
        final plan = state?.plan.finish(block);
        if (plan == null) {
          updates.add(
            tools.finish(
              block,
              tool: tool,
              supportsTerminalOutput: supportsTerminalOutput,
              toolUseResult: toolResultCount == 1
                  ? message.toolUseResult
                  : null,
              resultMetadata: resultMetadata[block.toolUseId],
            ),
          );
        } else {
          if (wasSurfaced && tool != null) {
            updates.add(
              tools.finish(
                block,
                tool: tool,
                supportsTerminalOutput: supportsTerminalOutput,
                toolUseResult: toolResultCount == 1
                    ? message.toolUseResult
                    : null,
                resultMetadata: resultMetadata[block.toolUseId],
              ),
            );
          }
          updates.addAll(plan);
        }
      } else if (block is TextBlock &&
          block.text.isNotEmpty &&
          (supportsSubagentTranscript || message.parentToolUseId == null)) {
        final visible = stripClaudeLocalCommandMetadata(block.text);
        if (visible is! String || visible.isEmpty) continue;
        updates.add(
          SessionUpdate.fromJson(<String, Object?>{
            'sessionUpdate': 'user_message_chunk',
            'content': <String, Object?>{'type': 'text', 'text': visible},
            'messageId': ?message.uuid,
            '_meta': ?_userMetadata(message),
          }),
        );
      }
    }
    return updates;
  }

  List<SessionUpdate> _result(
    ResultMessage message,
    ClaudeMessageProjectionState? state,
  ) {
    final updates = <SessionUpdate>[];
    if (message.result case final result?) {
      if (result.isNotEmpty && !(state?._emittedAgentText ?? false)) {
        updates.add(
          SessionUpdate.fromJson(<String, Object?>{
            'sessionUpdate': 'agent_message_chunk',
            'content': <String, Object?>{'type': 'text', 'text': result},
            'messageId': ?message.uuid,
          }),
        );
        state?._emittedAgentText = true;
      }
    }
    final usage = message.usage;
    final input =
        _int(usage?['input_tokens']) +
        _int(usage?['cache_read_input_tokens']) +
        _int(usage?['cache_creation_input_tokens']);
    final output = _int(usage?['output_tokens']);
    final context = message.modelUsage?.values
        .map((value) => value.contextWindow)
        .fold<int>(0, (left, right) => left > right ? left : right);
    if (input == 0 && output == 0 && (context ?? 0) == 0) {
      return updates;
    }
    final size = context == null || context == 0
        ? state?._contextWindow ?? 200000
        : context;
    if (state != null &&
        state._lastStreamUsage == input + output &&
        state._contextWindow == size &&
        message.totalCostUsd == null) {
      return updates;
    }
    updates.add(
      SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': 'usage_update',
        'used': input + output,
        'size': size,
        if (message.totalCostUsd case final cost?)
          'cost': <String, Object?>{'amount': cost, 'currency': 'USD'},
        if (message.origin case final origin?)
          '_meta': <String, Object?>{
            'claude': <String, Object?>{'origin': origin},
          },
      }),
    );
    if (context != null && context > 0) state?.seedContextWindow(context);
    return updates;
  }

  List<SessionUpdate> _system(
    SystemMessage message,
    ClaudeMessageProjectionState? state,
  ) {
    final plan = state?.plan.system(message);
    if (plan != null) return <SessionUpdate>[plan];
    if (message is CommandsChangedMessage) {
      return <SessionUpdate>[
        SessionUpdate.fromJson(<String, Object?>{
          'sessionUpdate': 'available_commands_update',
          'availableCommands': <Object?>[
            for (final command in message.commands)
              <String, Object?>{
                'name': command.name,
                'description': command.description,
                if (command.argumentHint case final hint?)
                  'input': <String, Object?>{'hint': hint},
              },
          ],
        }),
      ];
    }
    if (message is InformationalMessage && message.content.isNotEmpty) {
      state?._emittedAgentText = true;
      final text = message.level == 'info'
          ? message.content
          : '**${_title(message.level)}:** ${message.content}';
      return <SessionUpdate>[
        _systemText(text, message.uuid, <String, Object?>{
          'subtype': message.subtype,
          'level': message.level,
          if (message.preventsContinuation) 'preventsContinuation': true,
        }),
      ];
    }
    if (message is LocalCommandOutputMessage && message.content.isNotEmpty) {
      state?._emittedAgentText = true;
      return <SessionUpdate>[
        _systemText(message.content, message.uuid, <String, Object?>{
          'subtype': message.subtype,
        }),
      ];
    }
    if (message is RuntimeStatusMessage) {
      if (message.status == 'compacting') {
        if (state?._compactionInProgress ?? false) {
          return const <SessionUpdate>[];
        }
        state?._compactionInProgress = true;
        return <SessionUpdate>[
          _systemText('Compacting...', message.uuid, <String, Object?>{
            'subtype': message.subtype,
          }),
        ];
      }
      if ((state?._compactionInProgress ?? false) &&
          message.compactResult == 'success') {
        state?._compactionInProgress = false;
        return <SessionUpdate>[
          _systemText(
            '\n\nCompacting completed.',
            message.uuid,
            <String, Object?>{'subtype': message.subtype},
          ),
        ];
      }
      if ((state?._compactionInProgress ?? false) &&
          message.compactResult == 'failed') {
        state?._compactionInProgress = false;
        final suffix = message.compactError == null
            ? '.'
            : ': ${message.compactError}';
        return <SessionUpdate>[
          _systemText(
            '\n\nCompacting failed$suffix',
            message.uuid,
            <String, Object?>{'subtype': message.subtype},
          ),
        ];
      }
    }
    if (message is ModelRefusalFallbackMessage) {
      state?._emittedAgentText = true;
      final explanation = message.explanation;
      return <SessionUpdate>[
        _systemText(
          explanation == null || explanation.isEmpty
              ? message.content
              : '${message.content}\n\n$explanation',
          message.uuid,
          <String, Object?>{
            'subtype': message.subtype,
            'originalModel': message.originalModel,
            'fallbackModel': message.fallbackModel,
            'direction': message.direction,
          },
        ),
      ];
    }
    if (message is ModelRefusalNoFallbackMessage) {
      state?._emittedAgentText = true;
      final explanation = message.explanation;
      return <SessionUpdate>[
        _systemText(
          explanation == null || explanation.isEmpty
              ? message.content
              : '${message.content}\n\n$explanation',
          message.uuid,
          <String, Object?>{
            'subtype': message.subtype,
            'originalModel': message.originalModel,
          },
        ),
      ];
    }
    if (message is MemoryRecallMessage) {
      final count = message.memories.length;
      final content = <Object?>[
        for (final memory in message.memories)
          if (memory.content case final text?)
            <String, Object?>{
              'type': 'content',
              'content': <String, Object?>{'type': 'text', 'text': text},
            },
      ];
      return <SessionUpdate>[
        SessionUpdate.fromJson(<String, Object?>{
          'sessionUpdate': 'tool_call',
          'toolCallId': message.uuid,
          'title': 'Recalled $count ${count == 1 ? 'memory' : 'memories'}',
          'kind': 'read',
          'status': 'completed',
          'content': content,
          'locations': <Object?>[
            for (final memory in message.memories)
              if (!memory.path.startsWith('<') &&
                  !memory.path.startsWith('http://') &&
                  !memory.path.startsWith('https://'))
                <String, Object?>{'path': memory.path},
          ],
          '_meta': <String, Object?>{
            'claude': <String, Object?>{
              'subtype': message.subtype,
              'mode': message.mode,
            },
          },
        }),
      ];
    }
    if (message is PermissionDeniedMessage) {
      return <SessionUpdate>[
        SessionUpdate.fromJson(<String, Object?>{
          'sessionUpdate': 'tool_call_update',
          'toolCallId': message.toolUseId,
          'status': 'failed',
          'content': <Object?>[
            <String, Object?>{
              'type': 'content',
              'content': <String, Object?>{
                'type': 'text',
                'text':
                    'Permission denied: '
                    '${message.decisionReason ?? message.message}',
              },
            },
          ],
          '_meta': <String, Object?>{
            'claude': <String, Object?>{
              'tool': message.toolName,
              'decisionReasonType': ?message.decisionReasonType,
              'decisionReason': ?message.decisionReason,
              'agentId': ?message.agentId,
            },
          },
        }),
      ];
    }
    return const <SessionUpdate>[];
  }

  List<SessionUpdate> _toolProgress(
    ToolProgressMessage message,
    ClaudeMessageProjectionState? state,
  ) {
    if (state == null) return const <SessionUpdate>[];
    final toolCallId = state.hasSurfacedTool(message.toolUseId)
        ? message.toolUseId
        : message.parentToolUseId;
    if (toolCallId == null || !state.hasSurfacedTool(toolCallId)) {
      return const <SessionUpdate>[];
    }
    return <SessionUpdate>[
      SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': 'tool_call_update',
        'toolCallId': toolCallId,
        'status': 'in_progress',
        '_meta': <String, Object?>{
          'claudeCode': <String, Object?>{
            'toolName': message.toolName,
            'toolResponse': <String, Object?>{
              'elapsedTimeSeconds': message.elapsed.inMilliseconds / 1000,
              'subagentType': ?message.subagentType,
              'subagentRetry': ?message.subagentRetry,
            },
          },
        },
      }),
    ];
  }

  List<SessionUpdate> _rateLimit(
    RateLimitEventMessage message,
    ClaudeMessageProjectionState? state,
  ) {
    if (state == null || state._lastStreamUsage < 0) {
      return const <SessionUpdate>[];
    }
    return <SessionUpdate>[
      SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': 'usage_update',
        'used': state._lastStreamUsage,
        'size': state._contextWindow,
        '_meta': <String, Object?>{'_claude/rateLimit': message.info.raw},
      }),
    ];
  }

  SessionUpdate _systemText(
    String text,
    String? messageId,
    Map<String, Object?> claude,
  ) => SessionUpdate.fromJson(<String, Object?>{
    'sessionUpdate': 'agent_message_chunk',
    'content': <String, Object?>{'type': 'text', 'text': text},
    'messageId': ?messageId,
    '_meta': <String, Object?>{'claude': claude},
  });

  SessionUpdate _chunk(String type, String text, AssistantMessage message) =>
      SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': type,
        'content': <String, Object?>{'type': 'text', 'text': text},
        'messageId': ?_messageId(message),
        '_meta': ?_assistantMetadata(message),
      });

  SessionUpdate _withAssistantMetadata(
    SessionUpdate update,
    AssistantMessage message,
  ) {
    final metadata = _assistantMetadata(message);
    if (metadata == null) return update;
    final json = update.toJson();
    final existing = json['_meta'];
    final existingMetadata = existing is Map<Object?, Object?>
        ? <String, Object?>{
            for (final entry in existing.entries)
              if (entry.key is String) entry.key! as String: entry.value,
          }
        : <String, Object?>{};
    final existingClaude = existingMetadata['claude'];
    final claude = existingClaude is Map<Object?, Object?>
        ? <String, Object?>{
            for (final entry in existingClaude.entries)
              if (entry.key is String) entry.key! as String: entry.value,
          }
        : <String, Object?>{};
    claude.addAll(metadata['claude']! as Map<String, Object?>);
    return SessionUpdate.fromJson(<String, Object?>{
      ...json,
      '_meta': <String, Object?>{...existingMetadata, 'claude': claude},
    });
  }

  Map<String, Object?>? _assistantMetadata(AssistantMessage message) {
    final claude = <String, Object?>{
      'parentToolUseId': ?message.parentToolUseId,
      'subagentType': ?message.subagentType,
      'taskDescription': ?message.taskDescription,
    };
    return claude.isEmpty ? null : <String, Object?>{'claude': claude};
  }

  Map<String, Object?>? _userMetadata(UserMessage message) {
    final claude = <String, Object?>{
      'parentToolUseId': ?message.parentToolUseId,
      'subagentType': ?message.subagentType,
      'taskDescription': ?message.taskDescription,
    };
    return claude.isEmpty ? null : <String, Object?>{'claude': claude};
  }

  String? _messageId(AssistantMessage message) {
    final id = message.messageId;
    if (id != null && id.isNotEmpty) return id;
    final uuid = message.uuid;
    return uuid == null || uuid.isEmpty ? null : uuid;
  }

  String _unstreamed(String complete, String? streamed) {
    if (streamed == null || streamed.isEmpty) return complete;
    return complete.startsWith(streamed)
        ? complete.substring(streamed.length)
        : complete;
  }

  int _int(Object? value) => value is int ? value : 0;

  String _title(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}

const Set<String> _planOnlyTools = <String>{
  'TodoWrite',
  'TaskCreate',
  'TaskUpdate',
  'TaskList',
  'TaskGet',
};

final class _StreamedText {
  _StreamedText(this.thinking, this.value);

  final bool thinking;
  String value;
}

final class _StreamedTool {
  _StreamedTool({required this.id, required this.name});

  final String id;
  final String name;
  final StringBuffer input = StringBuffer();
  bool stopped = false;
}
