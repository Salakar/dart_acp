import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

void main() {
  const tools = ClaudeToolProjector();

  test('covers alternate tool-card content and kind mappings', () {
    SessionUpdate start(String name, Map<String, Object?> input) => tools.start(
      claude.ToolUseBlock(id: name, name: name, input: input),
      cwd: '/workspace',
    );

    expect(
      start('Write', <String, Object?>{'content': 'body'}).toJson().toString(),
      contains('body'),
    );
    expect(
      start('Edit', <String, Object?>{
        'new_string': 'replacement',
      }).toJson()['content'],
      isEmpty,
    );
    expect(
      start('Edit', <String, Object?>{
        'file_path': 'lib/a.dart',
        'old_string': 'before',
        'new_string': 'after',
      }).toJson().toString(),
      allOf(contains('before'), contains('after')),
    );
    expect(
      start('Bash', <String, Object?>{
        'description': 'Run checks',
      }).toJson().toString(),
      contains('Run checks'),
    );
    expect(
      start('ExitPlanMode', <String, Object?>{
        'plan': 'Implement it',
      }).toJson().toString(),
      contains('Implement it'),
    );
    expect(
      start('AskUserQuestion', const <String, Object?>{}).toJson()['content'],
      isEmpty,
    );
    expect(
      start('WebFetch', <String, Object?>{
        'url': 'https://example.test',
      }).toJson(),
      containsPair('kind', 'fetch'),
    );
    expect(
      start('WebFetch', <String, Object?>{
        'url': 'https://example.test',
        'prompt': 'Summarize',
      }).toJson().toString(),
      contains('Summarize'),
    );
    expect(
      start('ExitPlanMode', const <String, Object?>{}).toJson(),
      containsPair('kind', 'switch_mode'),
    );
    expect(
      start('EnterPlanMode', const <String, Object?>{}).toJson(),
      allOf(
        containsPair('kind', 'switch_mode'),
        containsPair('title', 'Enter Plan Mode'),
      ),
    );
    expect(
      start('TodoWrite', const <String, Object?>{}).toJson(),
      containsPair('kind', 'think'),
    );
  });

  test('normalizes scalar, unknown, empty, and nested image results', () {
    String finish(Object? content) => tools
        .finish(claude.ToolResultBlock(toolUseId: 'tool', content: content))
        .toJson()
        .toString();

    expect(finish(null), contains('content: []'));
    expect(finish(42), contains('42'));
    expect(
      finish(<Object?>[
        <String, Object?>{'type': 'future', 'value': 42},
        <String, Object?>{
          'type': 'image',
          'source': <String, Object?>{'mediaType': 'image/png', 'data': 'YWJj'},
        },
      ]),
      allOf(contains('future'), contains('image/png')),
    );
    expect(
      finish(<Object?>[
        <String, Object?>{
          'type': 'image',
          'mime_type': 'image/jpeg',
          'data': 'ZA==',
        },
      ]),
      contains('image/jpeg'),
    );
  });

  test('uses terminal fallbacks and successful edit suppression', () {
    final bash = claude.ToolUseBlock(
      id: 'bash',
      name: 'Bash',
      input: <String, Object?>{'command': 'run'},
    );
    final fromSidecar = tools.finish(
      claude.ToolResultBlock(toolUseId: 'bash', content: 'raw'),
      tool: bash,
      supportsTerminalOutput: true,
      toolUseResult: <String, Object?>{
        'output': 'sidecar output',
        'returnCode': 3,
      },
    );
    expect(
      fromSidecar.toJson().toString(),
      allOf(contains('sidecar output'), contains('exit_code: 3')),
    );

    final failed = tools.finish(
      claude.ToolResultBlock(
        toolUseId: 'bash',
        content: <Object?>[
          <String, Object?>{'type': 'text', 'text': 'array output'},
        ],
        isError: true,
      ),
      tool: bash,
      supportsTerminalOutput: true,
    );
    expect(
      failed.toJson().toString(),
      allOf(contains('array output'), contains('exit_code: 1')),
    );

    final edit = tools.finish(
      claude.ToolResultBlock(toolUseId: 'edit', content: 'updated'),
      tool: claude.ToolUseBlock(
        id: 'edit',
        name: 'Edit',
        input: const <String, Object?>{},
      ),
    );
    expect(edit.toJson()['content'], isEmpty);
    expect(
      tools
          .finish(
            claude.ToolResultBlock(toolUseId: 'plan', content: 'done'),
            tool: claude.ToolUseBlock(
              id: 'plan',
              name: 'EnterPlanMode',
              input: const <String, Object?>{},
            ),
          )
          .toJson(),
      containsPair('title', 'Entered Plan Mode'),
    );
  });

  test('uses current structured read, Bash, Agent, and web search outputs', () {
    final read = tools.finish(
      claude.ToolResultBlock(
        toolUseId: 'read',
        content: 'model-facing reminder',
      ),
      tool: claude.ToolUseBlock(
        id: 'read',
        name: 'Read',
        input: <String, Object?>{'file_path': 'a.dart', 'offset': 4},
      ),
      toolUseResult: <String, Object?>{
        'type': 'text',
        'file': <String, Object?>{
          'content': 'first\nsecond\n',
          'startLine': 4,
          'numLines': 2,
          'totalLines': 20,
          'truncatedByTokenCap': true,
        },
      },
    );
    expect(
      read.toJson()['content'].toString(),
      allOf(
        contains('4\tfirst'),
        contains('5\tsecond'),
        contains('showing 2 of 20 lines'),
        isNot(contains('model-facing reminder')),
      ),
    );

    final offsetRead = tools.finish(
      claude.ToolResultBlock(toolUseId: 'offset-read', content: 'fallback'),
      tool: claude.ToolUseBlock(
        id: 'offset-read',
        name: 'Read',
        input: <String, Object?>{'file_path': 'b.dart', 'offset': 9},
      ),
      toolUseResult: <String, Object?>{
        'type': 'text',
        'file': <String, Object?>{'content': 'ninth line'},
      },
    );
    expect(offsetRead.toJson().toString(), contains('9\tninth line'));

    final bash = tools.finish(
      claude.ToolResultBlock(toolUseId: 'bash', content: 'raw suffix'),
      tool: claude.ToolUseBlock(
        id: 'bash',
        name: 'Bash',
        input: <String, Object?>{'command': 'dart test'},
      ),
      toolUseResult: <String, Object?>{
        'stdout': 'tests passed',
        'stderr': '',
        'interrupted': true,
        'persistedOutputPath': '/tmp/full.log',
        'persistedOutputSize': 50000,
      },
    );
    expect(
      bash.toJson().toString(),
      allOf(
        contains('```console'),
        contains('tests passed'),
        contains('aborted'),
        contains('/tmp/full.log'),
      ),
    );

    final agent = tools.finish(
      claude.ToolResultBlock(
        toolUseId: 'agent',
        content: 'raw\n<usage>x</usage>',
      ),
      tool: claude.ToolUseBlock(
        id: 'agent',
        name: 'Agent',
        input: const <String, Object?>{},
      ),
      toolUseResult: <String, Object?>{
        'status': 'completed',
        'content': <Object?>[
          <String, Object?>{'type': 'text', 'text': 'structured report'},
        ],
      },
    );
    expect(
      agent.toJson()['content'].toString(),
      allOf(contains('structured report'), isNot(contains('<usage>'))),
    );

    final search = tools.finish(
      claude.ToolResultBlock(toolUseId: 'search', content: 'raw links'),
      tool: claude.ToolUseBlock(
        id: 'search',
        name: 'WebSearch',
        input: const <String, Object?>{},
      ),
      toolUseResult: <String, Object?>{
        'results': <Object?>[
          'commentary',
          <String, Object?>{
            'content': <Object?>[
              <String, Object?>{'title': 'Dart', 'url': 'https://dart.dev'},
            ],
          },
        ],
      },
    );
    expect(
      search.toJson().toString(),
      allOf(contains('commentary'), contains('Dart (https://dart.dev)')),
    );
  });

  test('builds detailed current tool cards', () {
    SessionUpdate start(String name, Map<String, Object?> input) => tools.start(
      claude.ToolUseBlock(id: name, name: name, input: input),
      cwd: '/workspace',
    );

    expect(
      start('Agent', <String, Object?>{
        'description': 'Review',
        'prompt': 'Inspect the implementation',
      }).toJson(),
      allOf(containsPair('title', 'Review'), containsPair('kind', 'think')),
    );
    expect(
      start('Read', <String, Object?>{
        'file_path': '/workspace/lib/a.dart',
        'offset': 3,
        'limit': 4,
      }).toJson(),
      containsPair('title', 'Read lib/a.dart (3 - 6)'),
    );
    expect(
      start('ReportFindings', <String, Object?>{
        'findings': <Object?>[
          <String, Object?>{'file': 'a.dart', 'line': 7, 'summary': 'Issue'},
        ],
      }).toJson().toString(),
      allOf(contains('Report 1 finding'), contains('a.dart:7')),
    );
  });
}
