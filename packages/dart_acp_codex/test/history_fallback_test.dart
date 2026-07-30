import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_codex/src/app_server/json_values.dart';
import 'package:dart_acp_codex/src/bridge/response_history.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

void main() {
  const history = CodexResponseHistory(
    maximumFileBytes: 4096,
    maximumLineBytes: 512,
    maximumRecords: 20,
  );

  test('recovers missing tools, phases, reasoning, and terminal status', () {
    final contents = <Map<String, Object?>>[
      <String, Object?>{
        'type': 'event_msg',
        'payload': <String, Object?>{
          'type': 'user_message',
          'message': 'hello',
          'images': <Object?>['/tmp/a.png'],
        },
      },
      <String, Object?>{
        'type': 'response_item',
        'payload': <String, Object?>{
          'type': 'message',
          'role': 'assistant',
          'phase': 'final_answer',
          'content': <Object?>[
            <String, Object?>{'text': 'answer'},
          ],
        },
      },
      <String, Object?>{
        'type': 'reasoning',
        'summary': <Object?>[
          <String, Object?>{'text': 'thought'},
        ],
      },
      <String, Object?>{
        'type': 'function_call',
        'call_id': 'call-1',
        'name': 'exec_command',
        'arguments': jsonEncode(<String, Object?>{
          'cmd': 'dart test',
          'workdir': '/workspace',
        }),
      },
      <String, Object?>{
        'type': 'function_call_output',
        'call_id': 'call-1',
        'output': 'Process exited with code 1\nfailure',
      },
    ].map(jsonEncode).join('\n');

    final updates = history.parse(contents)!;

    expect(updates.map((update) => update.discriminator), <String>[
      'user_message_chunk',
      'user_message_chunk',
      'agent_message_chunk',
      'agent_thought_chunk',
      'tool_call',
      'tool_call_update',
    ]);
    expect(updates[2].toJson()['_meta'], <String, Object?>{
      'codex': <String, Object?>{'phase': 'final_answer'},
    });
    expect(updates[4].toJson()['content'], <Object?>[
      <String, Object?>{'type': 'terminal', 'terminalId': 'call-1'},
    ]);
    expect(updates[5].toJson()['status'], 'failed');
  });

  test('skips duplicate, malformed, oversized, and existing tool records', () {
    final duplicate = jsonEncode(<String, Object?>{
      'type': 'event_msg',
      'payload': <String, Object?>{'type': 'agent_reasoning', 'text': 'same'},
    });
    final existing = jsonEncode(<String, Object?>{
      'type': 'function_call',
      'call_id': 'already',
      'name': 'view_image',
      'arguments': <String, Object?>{},
    });
    final newTool = jsonEncode(<String, Object?>{
      'type': 'function_call',
      'call_id': 'new',
      'name': 'apply_patch',
      'arguments': 'not-json',
    });
    final contents = <String>[
      '{invalid',
      'x' * 600,
      duplicate,
      duplicate,
      existing,
      newTool,
      jsonEncode(<String, Object?>{
        'type': 'function_call_output',
        'call_id': 'already',
        'output': 'ignored',
      }),
    ].join('\n');

    final updates = history.parse(
      contents,
      existingToolCallIds: <String>{'already'},
    )!;

    expect(updates, hasLength(2));
    expect(updates.first.discriminator, 'agent_thought_chunk');
    expect(updates.last.toJson()['toolCallId'], 'new');
  });

  test('merges fallback chronology around structured duplicates', () {
    SessionUpdate text(String value) =>
        SessionUpdate.fromJson(<String, Object?>{
          'sessionUpdate': 'agent_message_chunk',
          'content': <String, Object?>{'type': 'text', 'text': value},
        });
    final fallback = <SessionUpdate>[
      text('before'),
      text('shared'),
      text('after'),
    ];
    final structured = <SessionUpdate>[text('shared')];

    expect(
      history
          .merge(fallback, structured)
          .map((update) => update.toJson()['content'])
          .toList(),
      <Object?>[
        <String, Object?>{'type': 'text', 'text': 'before'},
        <String, Object?>{'type': 'text', 'text': 'shared'},
        <String, Object?>{'type': 'text', 'text': 'after'},
      ],
    );
  });

  test(
    'reads only bounded rollout files and tolerates missing paths',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'dart_acp_codex_history_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final valid = File('${directory.path}/valid.jsonl');
      await valid.writeAsString(
        jsonEncode(<String, Object?>{
          'type': 'function_call',
          'call_id': 'file-call',
          'name': 'view_image',
          'arguments': <String, Object?>{},
        }),
      );
      final oversized = File('${directory.path}/oversized.jsonl');
      await oversized.writeAsString('x' * 5000);

      expect(
        await history.recover(
          CodexJsonObject.from(<String, Object?>{
            'path': valid.path,
            'turns': <Object?>[],
          }),
        ),
        hasLength(1),
      );
      expect(
        await history.recover(
          CodexJsonObject.from(<String, Object?>{
            'path': oversized.path,
            'turns': <Object?>[],
          }),
        ),
        isNull,
      );
      expect(
        await history.recover(
          CodexJsonObject.from(<String, Object?>{
            'path': '${directory.path}/missing',
          }),
        ),
        isNull,
      );
    },
  );

  test('covers mixed legacy records and non-terminal outputs', () {
    final contents = <Object?>[
      <String, Object?>{'type': 'event_msg', 'payload': null},
      <String, Object?>{
        'type': 'event_msg',
        'payload': <String, Object?>{'type': 'other'},
      },
      <String, Object?>{
        'type': 'event_msg',
        'payload': <String, Object?>{
          'type': 'user_message',
          'local_images': <Object?>[
            <String, Object?>{'path': '/tmp/local.png'},
            <String, Object?>{'url': 'https://example.test/image.png'},
            <String, Object?>{'other': true},
          ],
        },
      },
      <String, Object?>{
        'type': 'message',
        'role': 'user',
        'content': <Object?>[
          <String, Object?>{'text': 'bootstrap'},
        ],
      },
      <String, Object?>{
        'type': 'message',
        'role': 'assistant',
        'content': <Object?>[
          'plain',
          <String, Object?>{'image_url': 'https://example.test/a.png'},
          <String, Object?>{'text': ''},
        ],
      },
      <String, Object?>{
        'type': 'reasoning',
        'content': <Object?>['fallback thought'],
      },
      <String, Object?>{
        'type': 'function_call',
        'call_id': 'tool',
        'name': 'view_image',
        'arguments': <String, Object?>{'path': '/tmp/a.png'},
      },
      <String, Object?>{
        'type': 'function_call_output',
        'call_id': 'tool',
        'output': <Object?>[
          <String, Object?>{'text': 'first'},
          <String, Object?>{'content': 'second'},
        ],
      },
      <String, Object?>{
        'type': 'function_call',
        'call_id': '',
        'name': 'missing',
      },
      <String, Object?>{'type': 'function_call', 'call_id': 'missing-name'},
    ].map(jsonEncode).join('\n');

    final updates = history.parse(contents)!;
    expect(
      updates.map((update) => update.discriminator),
      containsAll(<String>[
        'user_message_chunk',
        'agent_message_chunk',
        'agent_thought_chunk',
        'tool_call',
        'tool_call_update',
      ]),
    );
    expect(updates.last.toJson()['status'], 'completed');
    expect(
      history.parse(jsonEncode(<String, Object?>{'type': 'other'})),
      isNull,
    );
  });

  test('collects only structured tool ids from valid turn items', () {
    expect(
      history.toolCallIds(
        CodexJsonObject.from(<String, Object?>{
          'turns': <Object?>[
            'bad-turn',
            <String, Object?>{'items': 'bad-items'},
            <String, Object?>{
              'items': <Object?>[
                'bad-item',
                <String, Object?>{'id': 'command', 'type': 'commandExecution'},
                <String, Object?>{'id': 'message', 'type': 'agentMessage'},
                <String, Object?>{'type': 'mcpToolCall'},
              ],
            },
          ],
        }),
      ),
      <String>{'command'},
    );
    expect(history.toolCallIds(CodexJsonObject.empty), isEmpty);
  });

  test(
    'handles direct exit codes, arbitrary output, and invalid UTF-8',
    () async {
      final direct = <Object?>[
        <String, Object?>{
          'type': 'function_call',
          'call_id': 'exec',
          'name': 'exec_command',
          'arguments': <String, Object?>{'command': 'true'},
        },
        <String, Object?>{
          'type': 'function_call_output',
          'call_id': 'exec',
          'output': <String, Object?>{'exit_code': 0, 'value': true},
        },
      ].map(jsonEncode).join('\n');
      expect(history.parse(direct)!.last.toJson()['status'], 'completed');

      final directory = await Directory.systemTemp.createTemp(
        'dart_acp_codex_invalid_history_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final invalid = File('${directory.path}/invalid.jsonl');
      await invalid.writeAsBytes(<int>[0xff, 0xfe]);
      expect(
        await history.recover(
          CodexJsonObject.from(<String, Object?>{'path': invalid.path}),
        ),
        isNull,
      );
    },
  );
}
