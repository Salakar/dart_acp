import 'package:dart_acp_codex/dart_acp_codex.dart';
import 'package:dart_acp_codex/src/bridge/tool_mapper.dart';
import 'package:test/test.dart';

void main() {
  const mapper = CodexToolCallMapper();

  CodexJsonObject params(Map<String, Object?> item) =>
      CodexJsonObject.from(<String, Object?>{'item': item});

  test('maps command actions and command fallbacks', () {
    final actions = <Map<String, Object?>>[
      <String, Object?>{'type': 'read', 'path': '/workspace/a.dart'},
      <String, Object?>{'type': 'listFiles'},
      <String, Object?>{'type': 'listFiles', 'path': '/workspace'},
      <String, Object?>{
        'type': 'search',
        'query': 'TODO',
        'path': '/workspace',
      },
      <String, Object?>{'type': 'search', 'query': 'TODO'},
      <String, Object?>{'type': 'search', 'path': '/workspace'},
      <String, Object?>{'type': 'unknown'},
    ];
    for (var index = 0; index < actions.length; index += 1) {
      final json = mapper
          .started(
            params(<String, Object?>{
              'id': 'action-$index',
              'type': 'commandExecution',
              'status': 'inProgress',
              'command': 'tool command',
              'cwd': '/workspace',
              'commandActions': <Object?>[actions[index]],
            }),
          )!
          .toJson();
      expect(json['title'], isA<String>());
      expect(json['kind'], isA<String>());
    }

    for (final entry in <(Object?, String)>[
      (<Object?>['cat', 'a.dart'], 'read'),
      (<Object?>['rg', 'TODO'], 'search'),
      (<Object?>['ls'], 'read'),
      (<Object?>[], 'execute'),
    ]) {
      expect(
        mapper
            .started(
              params(<String, Object?>{
                'id': 'fallback-${entry.$2}-${entry.$1.hashCode}',
                'type': 'commandExecution',
                'command': entry.$1,
              }),
            )!
            .toJson()['kind'],
        entry.$2,
      );
    }
  });

  test('maps web, image, collaboration, and subagent variants', () {
    for (final action in <Map<String, Object?>?>[
      <String, Object?>{'type': 'search', 'query': 'Dart ACP'},
      <String, Object?>{'type': 'openPage', 'url': 'https://example.test'},
      <String, Object?>{
        'type': 'findInPage',
        'pattern': 'agent',
        'url': 'https://example.test',
      },
      null,
    ]) {
      final update = mapper.started(
        params(<String, Object?>{
          'id': 'web-${action.hashCode}',
          'type': 'webSearch',
          'query': 'fallback',
          'action': action,
        }),
      );
      expect(update?.toJson()['title'], isA<String>());
    }

    final image = mapper
        .started(
          params(<String, Object?>{
            'id': 'image',
            'type': 'imageView',
            'path': '/tmp/a.png',
            'status': 'completed',
          }),
        )!
        .toJson();
    expect(image['locations'], hasLength(1));
    expect(image['content'], hasLength(1));
    expect(
      mapper.completed(
        params(<String, Object?>{
          'id': 'image',
          'type': 'imageView',
          'path': '/tmp/a.png',
        }),
      ),
      isNotNull,
    );

    final collaboration = <String, Object?>{
      'id': 'collab',
      'type': 'collabAgentToolCall',
      'tool': 'spawnAgent',
      'prompt': 'Research',
      'senderThreadId': 'main',
      'receiverThreadIds': <Object?>['child'],
      'agentsStates': <String, Object?>{},
      'status': 'completed',
    };
    expect(mapper.started(params(collaboration)), isNotNull);
    expect(mapper.completed(params(collaboration)), isNotNull);

    for (final kind in <String>[
      'started',
      'interacted',
      'interrupted',
      'unknown',
    ]) {
      final activity = <String, Object?>{
        'id': 'activity-$kind',
        'type': 'subAgentActivity',
        'agentThreadId': 'child',
        'agentPath': kind == 'unknown' ? '' : '/root/research',
        'kind': kind,
        'status': 'completed',
      };
      expect(
        mapper.started(params(activity))?.toJson()['title'],
        isA<String>(),
      );
      expect(mapper.completed(params(activity)), isNotNull);
    }
  });

  test('maps completion output and progress metadata variants', () {
    final terminal = mapper
        .completed(
          params(<String, Object?>{
            'id': 'command',
            'type': 'commandExecution',
            'status': 'failed',
            'command': 'false',
            'aggregatedOutput': 'failed',
            'exitCode': 1,
          }),
        )!
        .toJson();
    expect(terminal['status'], 'failed');
    expect(
      terminal['_meta'],
      containsPair('terminal_exit', isA<Map<String, Object?>>()),
    );

    final mcp = mapper
        .completed(
          params(<String, Object?>{
            'id': 'mcp',
            'type': 'mcpToolCall',
            'server': 'demo',
            'tool': 'read',
            'status': 'declined',
            'arguments': <String, Object?>{},
            'error': <String, Object?>{'message': 'no'},
            'message': 'log',
          }),
        )!
        .toJson();
    expect(mcp['status'], 'failed');
    expect(mcp['content'], hasLength(1));

    final generated = mapper
        .completed(
          params(<String, Object?>{
            'id': 'generated',
            'type': 'imageGeneration',
            'status': 'completed',
            'revisedPrompt': 'Square',
            'result': 'aGVsbG8=',
            'savedPath': '/tmp/square.png',
          }),
        )!
        .toJson();
    expect(generated['content'], hasLength(2));

    expect(
      mapper.progress(
        CodexJsonObject.from(<String, Object?>{
          'item': <String, Object?>{'id': 'nested'},
          'output': 'nested output',
        }),
      ),
      isNotNull,
    );
    expect(
      mapper
          .progress(
            CodexJsonObject.from(<String, Object?>{
              'itemId': 'mcp',
              'message': 'progress',
            }),
          )!
          .toJson()['_meta'],
      containsPair('mcp_output_delta', isA<Map<String, Object?>>()),
    );
    expect(mapper.progress(CodexJsonObject.empty), isNull);
    expect(
      mapper.progress(
        CodexJsonObject.from(<String, Object?>{'itemId': 'empty'}),
      ),
      isNull,
    );
    expect(mapper.started(CodexJsonObject.empty), isNull);
    expect(mapper.completed(CodexJsonObject.empty), isNull);

    const richTerminal = CodexToolCallMapper(terminalOutput: true);
    expect(
      richTerminal
          .progress(
            CodexJsonObject.from(<String, Object?>{
              'itemId': 'rich',
              'delta': 'output',
            }),
          )!
          .toJson()['_meta'],
      containsPair('terminal_output', isA<Map<String, Object?>>()),
    );
  });
}
