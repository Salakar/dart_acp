import 'package:dart_acp_codex/dart_acp_codex.dart';
import 'package:dart_acp_codex/src/bridge/event_mapper.dart';
import 'package:dart_acp_codex/src/bridge/history_mapper.dart';
import 'package:dart_acp_codex/src/bridge/mcp_mapper.dart';
import 'package:dart_acp_codex/src/bridge/prompt_mapper.dart';
import 'package:dart_acp_codex/src/bridge/tool_mapper.dart';
import 'package:test/test.dart';

ContentBlock _block(Map<String, Object?> json) => ContentBlock.fromJson(json);

CodexNotification _event(
  String method,
  Map<Object?, Object?> params, {
  String? itemId,
}) => CodexNotification(
  method: method,
  params: CodexJsonObject.from(params),
  itemId: itemId == null ? null : CodexItemId(itemId),
);

Map<String, Object?> _singleJson(List<SessionUpdate> updates) {
  expect(updates, hasLength(1));
  return updates.single.toJson();
}

void main() {
  group('prompt mapping', () {
    const mapper = CodexPromptMapper();

    test('maps text, image, links, resources, and omits audio', () {
      final mapped = mapper.map(<ContentBlock>[
        _block(<String, Object?>{'type': 'text', 'text': 'hello'}),
        _block(<String, Object?>{
          'type': 'image',
          'mimeType': 'image/png',
          'data': 'cG5n',
          'uri': 'https://example.test/image.png',
        }),
        _block(<String, Object?>{
          'type': 'image',
          'mimeType': 'image/png',
          'data': 'ZmFsbGJhY2s=',
          'uri': 'file:///tmp/image.png',
        }),
        _block(<String, Object?>{
          'type': 'audio',
          'mimeType': 'audio/wav',
          'data': 'd2F2',
        }),
        _block(<String, Object?>{
          'type': 'resource_link',
          'name': 'guide',
          'uri': 'file:///workspace/guide.md',
        }),
        _block(<String, Object?>{
          'type': 'resource',
          'resource': <String, Object?>{
            'uri': 'file:///workspace/context.txt',
            'mimeType': 'text/plain',
            'text': 'context',
          },
        }),
        _block(<String, Object?>{
          'type': 'resource',
          'resource': <String, Object?>{
            'uri': 'memory://binary',
            'mimeType': 'application/octet-stream',
            'blob': 'AAEC',
          },
        }),
        _block(<String, Object?>{
          'type': 'resource',
          'resource': <String, Object?>{
            'uri': 'memory://image',
            'mimeType': 'image/jpeg',
            'blob': 'anBn',
          },
        }),
      ]);

      expect(mapped, hasLength(7));
      expect(mapped[0], containsPair('text', 'hello'));
      expect(mapped[1], containsPair('url', 'https://example.test/image.png'));
      expect(
        mapped[2],
        containsPair('url', 'data:image/png;base64,ZmFsbGJhY2s='),
      );
      expect(mapped[3]['text'], contains('[@guide]'));
      expect(mapped[4]['text'], contains('<context'));
      expect(mapped[5]['text'], contains('encoding="base64"'));
      expect(mapped[6]['url'], 'data:image/jpeg;base64,anBn');
    });

    test('derives file names for unnamed file links', () {
      final link = mapper.map(<ContentBlock>[
        _block(<String, Object?>{
          'type': 'resource_link',
          'uri': 'file:///workspace/readme.md',
          'name': '',
        }),
      ]);
      expect(link.single['text'], '[@readme.md](file:///workspace/readme.md)');
    });
  });

  group('MCP mapping', () {
    const mapper = CodexMcpMapper();

    test('maps stdio and HTTP servers', () {
      final mapped = mapper.map(<McpServer>[
        McpServer.fromJson(<String, Object?>{
          'name': 'local',
          'command': 'dart',
          'args': <Object?>['run', 'server.dart'],
          'env': <Object?>[
            <String, Object?>{'name': 'MODE', 'value': 'test'},
          ],
        }),
        McpServer.fromJson(<String, Object?>{
          'type': 'http',
          'name': 'remote',
          'url': 'https://mcp.example.test',
          'headers': <Object?>[
            <String, Object?>{'name': 'X-Test', 'value': 'yes'},
          ],
        }),
      ]);

      expect(mapped['local'], <String, Object?>{
        'command': 'dart',
        'args': <Object?>['run', 'server.dart'],
        'env': <String, Object?>{'MODE': 'test'},
      });
      expect(mapped['remote'], <String, Object?>{
        'url': 'https://mcp.example.test',
        'http_headers': <String, Object?>{'X-Test': 'yes'},
      });
    });

    test('uses last duplicate and rejects SSE', () {
      final mapped = mapper.map(<McpServer>[
        McpServer.fromJson(<String, Object?>{
          'name': 'same',
          'command': 'first',
          'args': <Object?>[],
          'env': <Object?>[],
        }),
        McpServer.fromJson(<String, Object?>{
          'name': 'same',
          'command': 'second',
          'args': <Object?>[],
          'env': <Object?>[],
        }),
      ]);
      expect((mapped['same']! as Map<String, Object?>)['command'], 'second');

      expect(
        () => mapper.map(<McpServer>[
          McpServer.fromJson(<String, Object?>{
            'type': 'sse',
            'name': 'old',
            'url': 'https://mcp.example.test/sse',
            'headers': <Object?>[],
          }),
        ]),
        throwsA(isA<CodexConfigurationException>()),
      );
    });
  });

  group('event mapping', () {
    late CodexEventMapper mapper;

    setUp(() {
      mapper = CodexEventMapper();
    });

    test('maps message, reasoning, and plan streams', () {
      expect(
        _singleJson(
          mapper.map(
            _event('item/agentMessage/delta', <String, Object?>{
              'delta': 'hello',
            }, itemId: 'message-1'),
          ),
        ),
        containsPair('messageId', 'message-1'),
      );

      final thought = _singleJson(
        mapper.map(
          _event('item/reasoning/textDelta', <String, Object?>{
            'delta': 'thinking',
          }, itemId: 'reason-1'),
        ),
      );
      expect(thought['sessionUpdate'], 'agent_thought_chunk');
      expect(
        mapper.map(
          _event('item/completed', <String, Object?>{
            'item': <String, Object?>{
              'id': 'reason-1',
              'type': 'reasoning',
              'text': 'duplicate',
            },
          }, itemId: 'reason-1'),
        ),
        isEmpty,
      );

      expect(
        _singleJson(
          mapper.map(
            _event(
              'item/reasoning/summaryPartAdded',
              const <String, Object?>{},
              itemId: 'reason-2',
            ),
          ),
        )['sessionUpdate'],
        'agent_thought_chunk',
      );

      expect(
        mapper.map(
          _event('item/plan/delta', <String, Object?>{
            'delta': 'Step one',
          }, itemId: 'plan-1'),
        ),
        isEmpty,
      );
      final planText = _singleJson(
        mapper.map(
          _event('item/completed', <String, Object?>{
            'item': <String, Object?>{'id': 'plan-1', 'type': 'plan'},
          }, itemId: 'plan-1'),
        ),
      );
      expect(
        (planText['content']! as Map<String, Object?>)['text'],
        'Step one',
      );
    });

    test('maps checklist, session info, usage, warnings, and errors', () {
      final plan = _singleJson(
        mapper.map(
          _event('turn/plan/updated', <String, Object?>{
            'plan': <Object?>[
              <String, Object?>{'step': 'First', 'status': 'completed'},
              <String, Object?>{'step': 'Second', 'status': 'inProgress'},
              <String, Object?>{'bad': true},
            ],
          }),
        ),
      );
      expect(plan['entries'], hasLength(2));

      expect(
        _singleJson(
          mapper.map(
            _event('thread/name/updated', <String, Object?>{'name': 'Title'}),
          ),
        )['title'],
        'Title',
      );
      final usage = _singleJson(
        mapper.map(
          _event('thread/tokenUsage/updated', <String, Object?>{
            'tokenUsage': <String, Object?>{
              'totalTokens': 200,
              'modelContextWindow': 100,
            },
          }),
        ),
      );
      expect(usage, containsPair('used', 100));
      expect(
        mapper.map(
          _event('thread/tokenUsage/updated', <String, Object?>{
            'totalTokens': 1,
          }),
        ),
        isEmpty,
      );

      for (final method in <String>[
        'warning',
        'configWarning',
        'model/rerouted',
        'thread/compacted',
        'error',
      ]) {
        expect(
          mapper.map(
            _event(method, <String, Object?>{'message': '$method message'}),
          ),
          hasLength(1),
        );
      }
      expect(
        mapper.map(_event('guardianWarning', const <String, Object?>{})),
        isEmpty,
      );
      expect(mapper.map(_event('unknown', const <String, Object?>{})), isEmpty);
    });

    test('maps current metadata, search, review, and terminal events', () {
      for (final entry in <(String, Object?)>[
        ('thread/status/changed', 'active'),
        ('thread/archived', true),
        ('thread/unarchived', false),
        ('thread/closed', true),
        ('thread/goal/updated', <String, Object?>{'objective': 'Ship'}),
        ('thread/goal/cleared', null),
      ]) {
        final update = _singleJson(
          mapper.map(
            _event(entry.$1, <String, Object?>{
              if (entry.$1 == 'thread/status/changed') 'status': entry.$2,
              if (entry.$1 == 'thread/goal/updated') 'goal': entry.$2,
            }),
          ),
        );
        expect(update['sessionUpdate'], 'session_info_update');
        expect(update['_meta'], isNotNull);
      }
      final goalEvent = _event('thread/goal/updated', <String, Object?>{
        'goal': <String, Object?>{'objective': 'Ship'},
      });
      expect(mapper.map(goalEvent), hasLength(1));
      expect(mapper.map(goalEvent), isEmpty);
      expect(
        mapper.map(_event('thread/goal/cleared', const <String, Object?>{})),
        hasLength(1),
      );
      expect(
        mapper.map(_event('thread/goal/cleared', const <String, Object?>{})),
        isEmpty,
      );

      final searchStart = _singleJson(
        mapper.map(
          _event('fuzzyFileSearch/sessionUpdated', <String, Object?>{
            'sessionId': 'search-1',
            'query': 'widget',
            'files': <Object?>[
              <String, Object?>{'root': '/workspace', 'path': 'lib/a.dart'},
            ],
          }),
        ),
      );
      expect(searchStart['sessionUpdate'], 'tool_call');
      expect(searchStart['locations'], hasLength(1));
      expect(
        _singleJson(
          mapper.map(
            _event('fuzzyFileSearch/sessionUpdated', <String, Object?>{
              'sessionId': 'search-1',
              'query': 'widget',
              'files': <Object?>[],
            }),
          ),
        )['sessionUpdate'],
        'tool_call_update',
      );
      expect(
        _singleJson(
          mapper.map(
            _event('fuzzyFileSearch/sessionCompleted', <String, Object?>{
              'sessionId': 'search-1',
            }),
          ),
        )['status'],
        'completed',
      );

      final review = <String, Object?>{
        'reviewId': 'review-1',
        'review': <String, Object?>{
          'status': 'inProgress',
          'riskLevel': 'medium',
          'rationale': 'Check command',
        },
      };
      expect(
        _singleJson(
          mapper.map(_event('item/autoApprovalReview/started', review)),
        )['sessionUpdate'],
        'tool_call',
      );
      review['review'] = <String, Object?>{'status': 'approved'};
      expect(
        _singleJson(
          mapper.map(_event('item/autoApprovalReview/completed', review)),
        )['sessionUpdate'],
        'tool_call_update',
      );

      final terminal = _singleJson(
        mapper.map(
          _event('item/commandExecution/terminalInteraction', <String, Object?>{
            'itemId': 'cmd',
            'stdin': 'yes',
          }),
        ),
      );
      expect(
        terminal['_meta'],
        containsPair('terminal_output_delta', <String, Object?>{
          'data': '\nyes\n',
          'terminal_id': 'cmd',
        }),
      );
    });

    test('tracks message phases and tool completion ordering', () {
      expect(
        mapper.map(
          _event('item/started', <String, Object?>{
            'item': <String, Object?>{
              'id': 'message-2',
              'type': 'agentMessage',
              'phase': 'commentary',
            },
          }, itemId: 'message-2'),
        ),
        isEmpty,
      );
      expect(
        _singleJson(
          mapper.map(
            _event('item/agentMessage/delta', <String, Object?>{
              'delta': 'working',
            }, itemId: 'message-2'),
          ),
        )['_meta'],
        <String, Object?>{
          'codex': <String, Object?>{'phase': 'commentary'},
        },
      );

      final image = <String, Object?>{
        'id': 'image-1',
        'type': 'imageView',
        'path': '/tmp/image.png',
        'status': 'completed',
      };
      expect(
        mapper.map(_event('item/started', <String, Object?>{'item': image})),
        hasLength(1),
      );
      expect(
        mapper.map(_event('item/completed', <String, Object?>{'item': image})),
        isEmpty,
      );

      final generated = <String, Object?>{
        'id': 'generated-1',
        'type': 'imageGeneration',
        'status': 'completed',
        'revisedPrompt': 'A square',
        'result': 'aGVsbG8=',
      };
      expect(
        _singleJson(
          mapper.map(
            _event('item/completed', <String, Object?>{'item': generated}),
          ),
        )['sessionUpdate'],
        'tool_call',
      );
    });

    test('maps completion-only and defensive event variants', () {
      expect(
        mapper.map(
          _event('item/completed', <String, Object?>{
            'item': <String, Object?>{
              'id': 'message-complete',
              'type': 'agentMessage',
              'phase': 'final_answer',
            },
          }),
        ),
        isEmpty,
      );
      expect(
        _singleJson(
          mapper.map(
            _event('item/completed', <String, Object?>{
              'item': <String, Object?>{
                'id': 'reason-complete',
                'type': 'reasoning',
                'summary': <Object?>[
                  'one',
                  <String, Object?>{'text': 'two'},
                ],
              },
            }, itemId: 'reason-complete'),
          ),
        )['sessionUpdate'],
        'agent_thought_chunk',
      );
      expect(
        _singleJson(
          mapper.map(
            _event('item/completed', <String, Object?>{
              'item': <String, Object?>{
                'id': 'review-exit',
                'type': 'exitedReviewMode',
                'review': '  Review complete  ',
              },
            }),
          ),
        )['sessionUpdate'],
        'agent_message_chunk',
      );

      final generation = <String, Object?>{
        'id': 'generation-active',
        'type': 'imageGeneration',
        'status': 'generating',
      };
      expect(
        mapper.map(
          _event('item/started', <String, Object?>{'item': generation}),
        ),
        hasLength(1),
      );
      generation['status'] = 'completed';
      expect(
        _singleJson(
          mapper.map(
            _event('item/completed', <String, Object?>{'item': generation}),
          ),
        )['sessionUpdate'],
        'tool_call_update',
      );

      final subagent = <String, Object?>{
        'id': 'subagent-active',
        'type': 'subAgentActivity',
        'agentPath': '/root/worker',
        'kind': 'started',
      };
      expect(
        mapper.map(_event('item/started', <String, Object?>{'item': subagent})),
        hasLength(1),
      );
      expect(
        _singleJson(
          mapper.map(
            _event('item/completed', <String, Object?>{'item': subagent}),
          ),
        )['sessionUpdate'],
        'tool_call_update',
      );

      final config = _singleJson(
        mapper.map(
          _event('configWarning', <String, Object?>{
            'summary': 'Invalid value',
            'details': 'Using the default.',
          }),
        ),
      );
      expect(config.toString(), contains('Using the default'));
      final rerouted = _singleJson(
        mapper.map(
          _event('model/rerouted', <String, Object?>{
            'fromModel': 'a',
            'toModel': 'b',
            'reason': 'capacity',
          }),
        ),
      );
      expect(rerouted.toString(), contains('capacity'));
      expect(
        _singleJson(
          mapper.map(
            _event('error', <String, Object?>{
              'error': <String, Object?>{'message': 'nested'},
            }),
          ),
        ).toString(),
        contains('nested'),
      );
      expect(
        _singleJson(
          mapper.map(_event('error', const <String, Object?>{})),
        ).toString(),
        contains('reported an error'),
      );

      expect(
        mapper.map(
          _event(
            'item/commandExecution/terminalInteraction',
            const <String, Object?>{},
          ),
        ),
        isEmpty,
      );
      expect(
        mapper.map(
          _event('fuzzyFileSearch/sessionUpdated', const <String, Object?>{}),
        ),
        isEmpty,
      );
      expect(
        mapper.map(
          _event('item/autoApprovalReview/started', const <String, Object?>{}),
        ),
        isEmpty,
      );
    });
  });

  group('tool and history mapping', () {
    const tools = CodexToolCallMapper();

    test('maps tool kinds, progress, completion, and locations', () {
      final cases = <Map<String, Object?>>[
        <String, Object?>{
          'id': 'cmd',
          'type': 'commandExecution',
          'command': 'rg TODO',
        },
        <String, Object?>{
          'id': 'files',
          'type': 'fileChange',
          'changes': <Object?>[
            <String, Object?>{'path': '/workspace/a.dart'},
          ],
        },
        <String, Object?>{
          'id': 'mcp',
          'type': 'mcpToolCall',
          'server': 'demo',
          'tool': 'lookup',
        },
        <String, Object?>{
          'id': 'web',
          'type': 'webSearch',
          'action': <String, Object?>{'type': 'openPage'},
        },
        <String, Object?>{'id': 'image', 'type': 'imageGeneration'},
        <String, Object?>{'id': 'collab', 'type': 'collabAgentToolCall'},
        <String, Object?>{'id': 'compact', 'type': 'contextCompaction'},
      ];
      for (final item in cases) {
        expect(
          tools.started(CodexJsonObject.from(<String, Object?>{'item': item})),
          isNotNull,
        );
      }
      final fileStart = tools
          .started(CodexJsonObject.from(<String, Object?>{'item': cases[1]}))!
          .toJson();
      expect(fileStart['locations'], hasLength(1));

      final progress = tools.progress(
        CodexJsonObject.from(<String, Object?>{
          'itemId': 'cmd',
          'delta': 'output',
        }),
      );
      expect(
        progress?.toJson()['_meta'],
        containsPair('terminal_output_delta', <String, Object?>{
          'data': 'output',
          'terminal_id': 'cmd',
        }),
      );

      final completed = tools.completed(
        CodexJsonObject.from(<String, Object?>{
          'item': <String, Object?>{
            'id': 'cmd',
            'type': 'commandExecution',
            'status': 'failed',
            'aggregatedOutput': 'failure',
          },
        }),
      );
      expect(completed?.toJson()['status'], 'failed');
      expect(
        tools.started(
          CodexJsonObject.from(<String, Object?>{
            'item': <String, Object?>{'id': 'text', 'type': 'agentMessage'},
          }),
        ),
        isNull,
      );
    });

    test('replays messages, reasoning, plans, and tools in order', () {
      final updates = CodexHistoryMapper().map(
        CodexJsonObject.from(<String, Object?>{
          'turns': <Object?>[
            <String, Object?>{
              'id': 'turn-1',
              'items': <Object?>[
                <String, Object?>{
                  'id': 'user',
                  'type': 'userMessage',
                  'content': <Object?>[
                    <String, Object?>{'text': 'question'},
                  ],
                },
                <String, Object?>{
                  'id': 'agent',
                  'type': 'agentMessage',
                  'text': 'answer',
                },
                <String, Object?>{
                  'id': 'reason',
                  'type': 'reasoning',
                  'summary': <Object?>['thought'],
                },
                <String, Object?>{
                  'id': 'cmd',
                  'type': 'commandExecution',
                  'status': 'completed',
                  'output': 'done',
                },
              ],
            },
          ],
        }),
      );

      expect(updates, hasLength(4));
      expect(updates.first.toJson()['sessionUpdate'], 'user_message_chunk');
      expect(updates.last.toJson()['sessionUpdate'], 'tool_call_update');
      expect(CodexHistoryMapper().map(CodexJsonObject.empty), isEmpty);
    });
  });
}
