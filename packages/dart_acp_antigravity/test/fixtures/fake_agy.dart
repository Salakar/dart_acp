import 'dart:convert';
import 'dart:io';

/// Scripted Antigravity CLI stand-in for adapter tests.
///
/// Emits canned `--output-format stream-json` lines. Prompt keywords select
/// failure modes: `FAIL` exits non-zero, `HANG` never finishes, `MISMATCH`
/// announces an unexpected conversation id, and `NO_RESULT` exits before the
/// result event.
Future<void> main(List<String> arguments) async {
  String? prompt;
  String? conversation;
  String? outputFormat;
  for (int i = 0; i < arguments.length - 1; i++) {
    switch (arguments[i]) {
      case '--print':
        prompt = arguments[i + 1];
      case '--conversation':
        conversation = arguments[i + 1];
      case '--output-format':
        outputFormat = arguments[i + 1];
    }
  }
  if (prompt == null || outputFormat != 'stream-json') {
    stderr.writeln('fake agy: unsupported invocation: $arguments');
    exitCode = 64;
    return;
  }

  final String conversationId = prompt.contains('MISMATCH')
      ? 'unexpected-conversation'
      : conversation ?? 'fake-conv-1';
  void emit(Map<String, Object?> event) => stdout.writeln(jsonEncode(event));
  Map<String, Object?> step(
    int index,
    String state,
    String type,
    Map<String, Object?> extra,
  ) => <String, Object?>{
    'event': 'step_update',
    'step_update': <String, Object?>{
      'conversation_id': conversationId,
      'step_index': index,
      'state': state,
      'step_type': type,
      ...extra,
    },
  };

  emit(<String, Object?>{
    'event': 'init',
    'conversation_id': conversationId,
    'init': <String, Object?>{
      'cwd': Directory.current.path,
      'tools': <Object?>['list_dir', 'view_file', 'run_command'],
      'permission_mode': 'request-review',
    },
  });
  await stdout.flush();

  if (prompt.contains('FAIL')) {
    stderr.writeln('fake agy failure detail');
    exitCode = 3;
    return;
  }
  if (prompt.contains('HANG') || prompt.contains('MISMATCH')) {
    await Future<void>.delayed(const Duration(days: 1));
    return;
  }
  if (prompt.contains('NO_RESULT')) {
    return;
  }

  final int base = conversation == null ? 0 : 20;
  emit(step(base, 'DONE', 'user_input', const <String, Object?>{}));
  emit(
    step(base + 1, 'ACTIVE', 'agent_response', const <String, Object?>{
      'text_delta': 'Hello ',
    }),
  );
  emit(
    step(base + 1, 'DONE', 'agent_response', const <String, Object?>{
      'text_delta': 'world.',
    }),
  );
  emit(
    step(base + 2, 'ACTIVE', 'tool', const <String, Object?>{
      'tool_name': 'list_dir',
      'tool_info': <String, Object?>{
        'name': 'list_dir',
        'parameters': <String, Object?>{'DirectoryPath': '/workspace'},
      },
    }),
  );
  stdout.writeln('jetski: interleaved diagnostics that must be ignored');
  emit(
    step(base + 2, 'DONE', 'tool', const <String, Object?>{
      'tool_name': 'list_dir',
      'tool_info': <String, Object?>{
        'name': 'list_dir',
        'parameters': <String, Object?>{'DirectoryPath': '/workspace'},
        'output': 'a.txt\nb.txt',
      },
    }),
  );
  emit(step(base + 3, 'DONE', 'checkpoint', const <String, Object?>{}));
  emit(
    step(base + 4, 'DONE', 'agent_response', <String, Object?>{
      'text_delta': ' ARGS:${jsonEncode(arguments)}',
    }),
  );
  emit(<String, Object?>{
    'event': 'result',
    'result': <String, Object?>{
      'conversation_id': conversationId,
      'status': 'SUCCESS',
      'response': 'Hello world.',
      'num_turns': 1,
    },
  });
  await stdout.flush();
}
