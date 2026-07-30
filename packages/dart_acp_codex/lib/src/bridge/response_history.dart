import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../app_server/json_values.dart';

/// Bounded reader for legacy response-item rollout history.
final class CodexResponseHistory {
  /// Creates a history reader.
  const CodexResponseHistory({
    this.maximumFileBytes = 32 * 1024 * 1024,
    this.maximumLineBytes = 1024 * 1024,
    this.maximumRecords = 100000,
  });

  /// Maximum rollout size accepted by [recover].
  final int maximumFileBytes;

  /// Maximum individual JSONL record size.
  final int maximumLineBytes;

  /// Maximum number of lines inspected.
  final int maximumRecords;

  /// Recovers history only when the structured thread omitted tool calls.
  Future<List<SessionUpdate>?> recover(CodexJsonObject thread) async {
    final path = thread.optionalString('path');
    if (path == null || path.isEmpty) {
      return null;
    }
    try {
      final file = File(path);
      final size = await file.length();
      if (size <= 0 || size > maximumFileBytes) {
        return null;
      }
      final contents = await file.readAsString();
      return parse(contents, existingToolCallIds: toolCallIds(thread));
    } on FileSystemException {
      return null;
    } on FormatException {
      return null;
    }
  }

  /// Parses response-item JSONL with deterministic bounds and de-duplication.
  List<SessionUpdate>? parse(
    String contents, {
    Set<String> existingToolCallIds = const <String>{},
  }) {
    final updates = <SessionUpdate>[];
    final emittedToolCalls = <String>{};
    final skippedToolCalls = <String>{};
    final terminalToolCalls = <String>{};
    String? lastKey;
    var recoveredTool = false;
    var recordCount = 0;

    void add(SessionUpdate update) {
      final key = _historyUpdateKey(update);
      if (key != null && key == lastKey) {
        return;
      }
      updates.add(update);
      lastKey = key;
    }

    for (final line in const LineSplitter().convert(contents)) {
      recordCount += 1;
      if (recordCount > maximumRecords ||
          utf8.encode(line).length > maximumLineBytes) {
        continue;
      }
      final record = _record(line);
      if (record == null) {
        continue;
      }
      final event = _eventUpdates(record);
      if (event != null) {
        for (final update in event) {
          add(update);
        }
        continue;
      }
      final item = _responseItem(record);
      if (item == null) {
        continue;
      }
      switch (item.optionalString('type')) {
        case 'message':
          for (final update in _messageUpdates(item)) {
            add(update);
          }
        case 'reasoning':
          for (final update in _reasoningUpdates(item)) {
            add(update);
          }
        case 'function_call':
          final id = item.optionalString('call_id');
          if (id == null ||
              id.isEmpty ||
              existingToolCallIds.contains(id) ||
              emittedToolCalls.contains(id)) {
            if (id != null && existingToolCallIds.contains(id)) {
              skippedToolCalls.add(id);
            }
            continue;
          }
          final update = _functionCall(item);
          if (update == null) {
            continue;
          }
          recoveredTool = true;
          emittedToolCalls.add(id);
          if (item.optionalString('name') == 'exec_command') {
            terminalToolCalls.add(id);
          }
          add(update);
        case 'function_call_output':
          final id = item.optionalString('call_id');
          if (id == null ||
              skippedToolCalls.contains(id) ||
              !emittedToolCalls.contains(id)) {
            continue;
          }
          add(_functionOutput(item, terminal: terminalToolCalls.contains(id)));
      }
    }
    return recoveredTool ? updates : null;
  }

  /// Merges fallback and structured streams while preserving chronology.
  List<SessionUpdate> merge(
    List<SessionUpdate> fallback,
    List<SessionUpdate> structured,
  ) {
    final merged = <SessionUpdate>[];
    final seen = <String>{};
    var fallbackIndex = 0;

    void add(SessionUpdate update) {
      final key = _historyUpdateKey(update);
      if (key != null && !seen.add(key)) {
        return;
      }
      merged.add(update);
    }

    for (final update in structured) {
      final exact = _historyUpdateKey(update);
      final content = _contentKey(update);
      var matching = -1;
      for (var index = fallbackIndex; index < fallback.length; index += 1) {
        if ((exact != null && _historyUpdateKey(fallback[index]) == exact) ||
            (content != null && _contentKey(fallback[index]) == content)) {
          matching = index;
          break;
        }
      }
      if (matching >= 0) {
        while (fallbackIndex < matching) {
          add(fallback[fallbackIndex]);
          fallbackIndex += 1;
        }
        fallbackIndex += 1;
      }
      add(update);
    }
    while (fallbackIndex < fallback.length) {
      add(fallback[fallbackIndex]);
      fallbackIndex += 1;
    }
    return merged;
  }

  /// Collects structured tool ids so fallback never duplicates them.
  Set<String> toolCallIds(CodexJsonObject thread) {
    final result = <String>{};
    final turns = thread['turns'];
    if (turns is! List<Object?>) {
      return result;
    }
    for (final rawTurn in turns) {
      if (rawTurn is! Map<Object?, Object?>) {
        continue;
      }
      final items = rawTurn['items'];
      if (items is! List<Object?>) {
        continue;
      }
      for (final rawItem in items) {
        if (rawItem is! Map<Object?, Object?>) {
          continue;
        }
        final item = CodexJsonObject.from(rawItem);
        final id = item.optionalString('id');
        if (_toolTypes.contains(item.optionalString('type')) && id != null) {
          result.add(id);
        }
      }
    }
    return result;
  }

  CodexJsonObject? _record(String line) {
    if (line.trim().isEmpty) {
      return null;
    }
    try {
      final value = jsonDecode(line);
      return value is Map<Object?, Object?>
          ? CodexJsonObject.from(value)
          : null;
    } on FormatException {
      return null;
    }
  }

  CodexJsonObject? _responseItem(CodexJsonObject record) {
    if (record.optionalString('type') == 'response_item') {
      return record.optionalObject('payload');
    }
    return _legacyTypes.contains(record.optionalString('type')) ? record : null;
  }

  List<SessionUpdate>? _eventUpdates(CodexJsonObject record) {
    if (record.optionalString('type') != 'event_msg') {
      return null;
    }
    final payload = record.optionalObject('payload');
    if (payload == null) {
      return const <SessionUpdate>[];
    }
    if (payload.optionalString('type') == 'agent_reasoning') {
      final text = payload.optionalString('text');
      return text == null || text.isEmpty
          ? const <SessionUpdate>[]
          : <SessionUpdate>[_text('agent_thought_chunk', text)];
    }
    if (payload.optionalString('type') != 'user_message') {
      return const <SessionUpdate>[];
    }
    final content = <String>[];
    final message = payload.optionalString('message');
    if (message != null && message.isNotEmpty) {
      content.add(message);
    }
    for (final key in const <String>['images', 'local_images']) {
      final images = payload[key];
      if (images is! List<Object?>) {
        continue;
      }
      for (final image in images) {
        final path = switch (image) {
          final String value => value,
          final Map<Object?, Object?> value =>
            value['path'] as String? ?? value['url'] as String?,
          _ => null,
        };
        if (path != null) {
          content.add('[@image]($path)');
        }
      }
    }
    return <SessionUpdate>[
      for (final text in content) _text('user_message_chunk', text),
    ];
  }

  List<SessionUpdate> _messageUpdates(CodexJsonObject item) {
    if (item.optionalString('role') != 'assistant') {
      return const <SessionUpdate>[];
    }
    final phase = item.optionalString('phase');
    final meta = phase == null
        ? null
        : <String, Object?>{
            'codex': <String, Object?>{'phase': phase},
          };
    return <SessionUpdate>[
      for (final text in _contentText(item['content']))
        _text('agent_message_chunk', text, meta: meta),
    ];
  }

  List<SessionUpdate> _reasoningUpdates(CodexJsonObject item) {
    final summary = _contentText(item['summary']);
    final texts = summary.isEmpty ? _contentText(item['content']) : summary;
    return <SessionUpdate>[
      for (final text in texts) _text('agent_thought_chunk', text),
    ];
  }

  SessionUpdate? _functionCall(CodexJsonObject item) {
    final id = item.optionalString('call_id');
    final name = item.optionalString('name');
    if (id == null || name == null) {
      return null;
    }
    final arguments = _arguments(item['arguments']);
    final args = arguments is Map<Object?, Object?>
        ? CodexJsonObject.from(arguments)
        : null;
    final command =
        args?.optionalString('cmd') ?? args?.optionalString('command');
    final cwd =
        args?.optionalString('workdir') ?? args?.optionalString('cwd') ?? '';
    final terminal = name == 'exec_command';
    return SessionUpdate.fromJson(<String, Object?>{
      'sessionUpdate': 'tool_call',
      'toolCallId': id,
      'kind': switch (name) {
        'exec_command' || 'multi_tool_use.parallel' => 'execute',
        'apply_patch' => 'edit',
        'view_image' => 'read',
        _ => 'other',
      },
      'title': switch (name) {
        'exec_command' => command ?? 'Run command',
        'apply_patch' => 'Apply patch',
        'multi_tool_use.parallel' => 'Run tools in parallel',
        'view_image' => 'View image',
        _ => name,
      },
      'status': 'in_progress',
      if (terminal)
        'content': <Object?>[
          <String, Object?>{'type': 'terminal', 'terminalId': id},
        ],
      'rawInput': name == 'exec_command'
          ? <String, Object?>{
              'command': command,
              'cwd': cwd,
              'arguments': arguments,
            }
          : <String, Object?>{'name': name, 'arguments': arguments},
      if (terminal)
        '_meta': <String, Object?>{
          'terminal_info': <String, Object?>{'cwd': cwd, 'terminal_id': id},
        },
    });
  }

  SessionUpdate _functionOutput(
    CodexJsonObject item, {
    required bool terminal,
  }) {
    final id = item.requireString('call_id');
    final output = _outputText(item['output']);
    final exitCode = _exitCode(item['output'], output);
    final failed = exitCode != null
        ? exitCode != 0
        : RegExp(
            r'\b(error|failed|failure)\b',
            caseSensitive: false,
          ).hasMatch(output);
    return SessionUpdate.fromJson(<String, Object?>{
      'sessionUpdate': 'tool_call_update',
      'toolCallId': id,
      'status': failed ? 'failed' : 'completed',
      'rawOutput': terminal
          ? <String, Object?>{'formatted_output': output, 'exit_code': exitCode}
          : <String, Object?>{'output': item['output']},
      if (terminal)
        '_meta': <String, Object?>{
          if (output.isNotEmpty)
            'terminal_output_delta': <String, Object?>{
              'data': output,
              'terminal_id': id,
            },
          'terminal_exit': <String, Object?>{
            'exit_code': exitCode,
            'signal': null,
            'terminal_id': id,
          },
        },
    });
  }

  Object? _arguments(Object? value) {
    if (value is! String) {
      return value;
    }
    try {
      return jsonDecode(value);
    } on FormatException {
      return value;
    }
  }

  List<String> _contentText(Object? value) {
    if (value is! List<Object?>) {
      return const <String>[];
    }
    return <String>[
      for (final entry in value)
        if (entry is String && entry.isNotEmpty)
          entry
        else if (entry is Map<Object?, Object?>)
          if (entry['text'] case final String text when text.isNotEmpty)
            text
          else if (entry['image_url'] case final String url when url.isNotEmpty)
            '[@image]($url)',
    ];
  }

  String _outputText(Object? value) {
    if (value is String) {
      return value;
    }
    if (value is List<Object?>) {
      return value.map(_outputText).where((text) => text.isNotEmpty).join('\n');
    }
    if (value is Map<Object?, Object?>) {
      for (final key in const <String>['output', 'text', 'content']) {
        if (value.containsKey(key)) {
          return _outputText(value[key]);
        }
      }
      return jsonEncode(value);
    }
    return value?.toString() ?? '';
  }

  int? _exitCode(Object? raw, String output) {
    if (raw is Map<Object?, Object?>) {
      final direct = raw['exit_code'] ?? raw['exitCode'];
      if (direct is int) {
        return direct;
      }
    }
    final match = RegExp(
      r'(?:exit(?:ed)?(?: with)?(?: code)?|Process exited with code)\s*[:=]?\s*(-?\d+)',
      caseSensitive: false,
    ).firstMatch(output);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  SessionUpdate _text(
    String discriminator,
    String text, {
    Map<String, Object?>? meta,
  }) => SessionUpdate.fromJson(<String, Object?>{
    'sessionUpdate': discriminator,
    'content': <String, Object?>{'type': 'text', 'text': text},
    '_meta': ?meta,
  });

  String? _historyUpdateKey(SessionUpdate update) {
    final json = update.toJson();
    return switch (update.discriminator) {
      'user_message_chunk' || 'agent_message_chunk' || 'agent_thought_chunk' =>
        '${update.discriminator}:${json['messageId'] ?? ''}:'
            '${jsonEncode(json['content'])}',
      'tool_call' => 'tool_call:${json['toolCallId']}:start',
      'tool_call_update' => 'tool_call:${json['toolCallId']}:update',
      _ => null,
    };
  }

  String? _contentKey(SessionUpdate update) {
    final json = update.toJson();
    return switch (update.discriminator) {
      'user_message_chunk' || 'agent_message_chunk' || 'agent_thought_chunk' =>
        '${update.discriminator}:${jsonEncode(json['content'])}',
      _ => _historyUpdateKey(update),
    };
  }

  static const Set<String?> _legacyTypes = <String?>{
    'message',
    'reasoning',
    'function_call',
    'function_call_output',
  };

  static const Set<String?> _toolTypes = <String?>{
    'commandExecution',
    'fileChange',
    'mcpToolCall',
    'dynamicToolCall',
    'collabAgentToolCall',
    'webSearch',
    'imageView',
    'imageGeneration',
    'contextCompaction',
  };
}
