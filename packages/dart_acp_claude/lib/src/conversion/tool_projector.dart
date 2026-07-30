import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:path/path.dart' as path;

/// Projects Claude tool lifecycle blocks into ACP session updates.
final class ClaudeToolProjector {
  /// Creates a tool projector.
  const ClaudeToolProjector();

  /// Creates the initial ACP tool call for [block].
  SessionUpdate start(
    ToolUseBlock block, {
    required String cwd,
    bool supportsTerminalOutput = false,
  }) {
    final title = _title(block, cwd);
    final description = block.input['description'];
    return SessionUpdate.fromJson(<String, Object?>{
      'sessionUpdate': 'tool_call',
      'toolCallId': block.id,
      'title': title,
      'kind': _kind(block.name),
      'status': 'pending',
      'rawInput': block.input,
      'content': _startContent(
        block,
        cwd: cwd,
        supportsTerminalOutput: supportsTerminalOutput,
      ),
      if (_location(block, cwd) case final location?) 'locations': [location],
      '_meta': <String, Object?>{
        'claudeCode': <String, Object?>{
          'toolName': block.name,
          if (block.name == 'Bash' &&
              description is String &&
              description.isNotEmpty)
            'title': description,
          if (block.name == 'Agent' || block.name == 'Task') 'subagent': true,
        },
        if (block.name == 'Bash' && supportsTerminalOutput)
          'terminal_info': <String, Object?>{'terminal_id': block.id},
      },
    });
  }

  /// Completes the ACP tool call represented by [block].
  SessionUpdate finish(
    ToolResultBlock block, {
    ToolUseBlock? tool,
    bool supportsTerminalOutput = false,
    JsonMap? toolUseResult,
    ToolResultMetadata? resultMetadata,
  }) {
    final raw = block.content;
    final failed = block.isError == true;
    final terminal =
        supportsTerminalOutput &&
        tool?.name == 'Bash' &&
        block.toolUseId.isNotEmpty;
    final text = terminal ? _bashText(raw, toolUseResult) : null;
    final exitCode = _exitCode(toolUseResult, failed);
    final content = switch (tool?.name) {
      'Edit' || 'Write' when !failed => const <Object?>[],
      'Read' => _readResultContent(raw, toolUseResult, tool!.input),
      'Bash' when !terminal => _bashResultContent(raw, toolUseResult),
      'Agent' || 'Task' => _agentResultContent(raw, toolUseResult),
      'WebSearch' => _webSearchResultContent(raw, toolUseResult),
      _ => _resultContent(raw),
    };
    return SessionUpdate.fromJson(<String, Object?>{
      'sessionUpdate': 'tool_call_update',
      'toolCallId': block.toolUseId,
      'status': failed ? 'failed' : 'completed',
      if (tool?.name == 'ExitPlanMode' && !failed) 'title': 'Exited Plan Mode',
      if (tool?.name == 'EnterPlanMode' && !failed)
        'title': 'Entered Plan Mode',
      'content': terminal && !_containsImage(raw) ? const <Object?>[] : content,
      'rawOutput': raw,
      if (terminal || tool != null || resultMetadata != null)
        '_meta': <String, Object?>{
          if (text != null && text.isNotEmpty)
            'terminal_output': <String, Object?>{
              'terminal_id': block.toolUseId,
              'data': text,
            },
          if (terminal)
            'terminal_exit': <String, Object?>{
              'terminal_id': block.toolUseId,
              'exit_code': exitCode,
              'signal': null,
            },
          if (tool != null)
            'claudeCode': <String, Object?>{
              'toolName': tool.name,
              if (resultMetadata != null) ...<String, Object?>{
                'nonExecutionKind': resultMetadata.nonExecutionKind,
                'userFeedback': ?resultMetadata.userFeedback,
              },
              if (tool.name == 'Agent' || tool.name == 'Task') 'subagent': true,
            },
        },
    });
  }

  List<Object?> _startContent(
    ToolUseBlock block, {
    required String cwd,
    required bool supportsTerminalOutput,
  }) {
    final input = block.input;
    final path = input['file_path'] ?? input['path'];
    final absolutePath = path is String && path.isNotEmpty
        ? (path.startsWith('/') ? path : '$cwd/$path')
        : null;
    return switch (block.name) {
      'Write' when input['content'] is String => <Object?>[
        if (absolutePath != null)
          <String, Object?>{
            'type': 'diff',
            'path': absolutePath,
            'oldText': null,
            'newText': input['content'],
          }
        else
          _textContent(input['content']! as String),
      ],
      'Edit'
          when input['old_string'] is String || input['new_string'] is String =>
        <Object?>[
          if (absolutePath != null)
            <String, Object?>{
              'type': 'diff',
              'path': absolutePath,
              'oldText': input['old_string'] as String?,
              'newText': input['new_string'] as String? ?? '',
            },
        ],
      'Bash' when supportsTerminalOutput => <Object?>[
        <String, Object?>{'type': 'terminal', 'terminalId': block.id},
      ],
      'Bash' when input['description'] is String => <Object?>[
        _textContent(input['description']! as String),
      ],
      'Agent' || 'Task' when input['prompt'] is String => <Object?>[
        _textContent(input['prompt']! as String),
      ],
      'WebFetch' when input['prompt'] is String => <Object?>[
        _textContent(input['prompt']! as String),
      ],
      'ExitPlanMode' when input['plan'] is String => <Object?>[
        _textContent(input['plan']! as String),
      ],
      'AskUserQuestion' => <Object?>[
        for (final question in _questions(input)) _textContent(question),
      ],
      'ReportFindings' => <Object?>[
        for (final finding in _findings(input)) _textContent(finding),
      ],
      _ when !_knownTools.contains(block.name) => <Object?>[
        _textContent(_jsonDisplay(input)),
      ],
      _ => const <Object?>[],
    };
  }

  List<Object?> _resultContent(Object? raw) {
    if (raw is String) {
      final text = _stripTrailer(raw);
      return text.isEmpty ? const <Object?>[] : <Object?>[_textContent(text)];
    }
    if (raw is! List<Object?>) {
      if (raw == null) return const <Object?>[];
      return <Object?>[_textContent('$raw')];
    }
    final result = <Object?>[];
    for (final item in raw) {
      if (item is! Map<Object?, Object?>) continue;
      final type = item['type'];
      if (type == 'text' && item['text'] is String) {
        final text = _stripTrailer(item['text']! as String);
        if (text.isNotEmpty) result.add(_textContent(text));
      } else if (type == 'image') {
        final source = item['source'];
        result.add(<String, Object?>{
          'type': 'content',
          'content': <String, Object?>{
            'type': 'image',
            if (source is Map<Object?, Object?>) ...<String, Object?>{
              if (source['media_type'] is String)
                'mimeType': source['media_type'],
              if (source['mediaType'] is String)
                'mimeType': source['mediaType'],
              if (source['data'] is String) 'data': source['data'],
              if (source['url'] is String) 'uri': source['url'],
            } else ...<String, Object?>{
              if (item['mime_type'] is String) 'mimeType': item['mime_type'],
              if (item['mimeType'] is String) 'mimeType': item['mimeType'],
              if (item['data'] is String) 'data': item['data'],
              if (item['url'] is String) 'uri': item['url'],
            },
          },
        });
      } else {
        result.add(_textContent(_jsonDisplayMap(item)));
      }
    }
    return result;
  }

  List<Object?> _readResultContent(
    Object? raw,
    JsonMap? sidecar,
    JsonMap input,
  ) {
    if (sidecar?['type'] != 'text') return _resultContent(raw);
    final file = sidecar?['file'];
    if (file is! Map<Object?, Object?>) return _resultContent(raw);
    final content = file['content'];
    if (content is! String || content.isEmpty) return _resultContent(raw);
    final startLine = file['startLine'] is int
        ? file['startLine']! as int
        : input['offset'] is int
        ? input['offset']! as int
        : 1;
    final lines = content.endsWith('\n')
        ? content.substring(0, content.length - 1).split('\n')
        : content.split('\n');
    var text = <String>[
      for (var index = 0; index < lines.length; index++)
        '${startLine + index}\t${lines[index]}',
    ].join('\n');
    if (file['truncatedByTokenCap'] == true) {
      final shown = file['numLines'];
      final total = file['totalLines'];
      final detail = shown is int && total is int
          ? ': showing $shown of $total lines'
          : '';
      text = '$text\n[File truncated$detail]';
    }
    return <Object?>[_textContent(text)];
  }

  List<Object?> _bashResultContent(Object? raw, JsonMap? sidecar) {
    final text = _bashText(raw, sidecar);
    if (text == null || text.trim().isEmpty) return const <Object?>[];
    return <Object?>[_textContent('```console\n${text.trimRight()}\n```')];
  }

  List<Object?> _agentResultContent(Object? raw, JsonMap? sidecar) {
    if (sidecar?['status'] == 'completed') {
      final content = sidecar?['content'];
      if (content is List<Object?> && content.isNotEmpty) {
        return _resultContent(content);
      }
    }
    return _resultContent(raw);
  }

  List<Object?> _webSearchResultContent(Object? raw, JsonMap? sidecar) {
    final values = sidecar?['results'];
    if (values is! List<Object?>) return _resultContent(raw);
    final lines = <String>[];
    for (final value in values) {
      if (value is String) {
        lines.add(value);
        continue;
      }
      if (value is! Map<Object?, Object?>) continue;
      final content = value['content'];
      if (content is! List<Object?>) continue;
      for (final hit in content) {
        if (hit is! Map<Object?, Object?>) continue;
        final title = hit['title'];
        final url = hit['url'];
        if (title is String && url is String) lines.add('$title ($url)');
      }
    }
    return lines.isEmpty
        ? _resultContent(raw)
        : <Object?>[_textContent(lines.join('\n'))];
  }

  Map<String, Object?> _textContent(String text) => <String, Object?>{
    'type': 'content',
    'content': <String, Object?>{'type': 'text', 'text': text},
  };

  String _kind(String name) => switch (name) {
    'Read' => 'read',
    'Write' || 'Edit' || 'NotebookEdit' => 'edit',
    'Glob' || 'Grep' || 'WebSearch' => 'search',
    'WebFetch' => 'fetch',
    'Bash' || 'TaskOutput' => 'execute',
    'Task' || 'Agent' => 'think',
    'EnterPlanMode' || 'ExitPlanMode' => 'switch_mode',
    'TodoWrite' ||
    'TaskCreate' ||
    'TaskUpdate' ||
    'TaskList' ||
    'TaskGet' => 'think',
    _ => 'other',
  };

  String _title(ToolUseBlock block, String cwd) {
    final input = block.input;
    return switch (block.name) {
      'Read' => _readTitle(input, cwd),
      'Write' =>
        'Write ${_displayPath(input['file_path'] ?? input['path'], cwd, 'file')}',
      'Edit' =>
        'Edit ${_displayPath(input['file_path'] ?? input['path'], cwd, 'file')}',
      'Glob' => _globTitle(input),
      'Grep' => _grepTitle(input),
      'WebFetch' => 'Fetch ${input['url'] ?? 'URL'}',
      'WebSearch' => _webSearchTitle(input),
      'Bash' => _commandTitle(input['command'], input['description']),
      'Agent' || 'Task' => '${input['description'] ?? 'Task'}',
      'TodoWrite' => _todoTitle(input),
      'TaskCreate' => 'Create task',
      'TaskUpdate' => 'Update task',
      'TaskList' => 'List tasks',
      'TaskGet' => 'Inspect task',
      'AskUserQuestion' => 'Ask user',
      'EnterPlanMode' => 'Enter Plan Mode',
      'ExitPlanMode' => 'Ready to code?',
      'ReportFindings' => _findingsTitle(input),
      _ => block.name.isEmpty ? 'Use tool' : block.name,
    };
  }

  List<String> _questions(JsonMap input) {
    final values = input['questions'];
    if (values is! List<Object?>) return const <String>[];
    return <String>[
      for (final value in values)
        if (value is Map<Object?, Object?> && value['question'] is String)
          value['question']! as String,
    ];
  }

  List<String> _findings(JsonMap input) {
    final values = input['findings'];
    if (values is! List<Object?>) return const <String>[];
    return <String>[
      for (final value in values)
        if (value is Map<Object?, Object?> &&
            value['file'] is String &&
            value['summary'] is String)
          '**${value['file']}${value['line'] is int ? ':${value['line']}' : ''}**'
              ' — ${value['summary']}',
    ];
  }

  String _readTitle(JsonMap input, String cwd) {
    final display = _displayPath(
      input['file_path'] ?? input['path'],
      cwd,
      'File',
    );
    final offset = input['offset'];
    final limit = input['limit'];
    if (offset is int && limit is int && limit > 0) {
      return 'Read $display ($offset - ${offset + limit - 1})';
    }
    if (limit is int && limit > 0) return 'Read $display (1 - $limit)';
    if (offset is int) return 'Read $display (from line $offset)';
    return 'Read $display';
  }

  String _displayPath(Object? value, String cwd, String fallback) {
    if (value is! String || value.isEmpty) return fallback;
    if (!path.isAbsolute(value)) return value;
    final normalizedCwd = path.normalize(cwd);
    final normalizedValue = path.normalize(value);
    if (normalizedValue == normalizedCwd ||
        path.isWithin(normalizedCwd, normalizedValue)) {
      final relative = path.relative(normalizedValue, from: normalizedCwd);
      return relative == '.' ? path.basename(normalizedValue) : relative;
    }
    return value;
  }

  String _globTitle(JsonMap input) {
    final parts = <String>['Find'];
    if (input['path'] case final String path) parts.add('`$path`');
    if (input['pattern'] case final String pattern) parts.add('`$pattern`');
    return parts.join(' ');
  }

  String _grepTitle(JsonMap input) {
    final parts = <String>['grep'];
    if (input['-i'] == true) parts.add('-i');
    if (input['-n'] == true) parts.add('-n');
    for (final flag in const <String>['-A', '-B', '-C']) {
      if (input[flag] != null) parts.add('$flag ${input[flag]}');
    }
    if (input['output_mode'] == 'files_with_matches') parts.add('-l');
    if (input['output_mode'] == 'count') parts.add('-c');
    if (input['head_limit'] != null) {
      parts.add('| head -${input['head_limit']}');
    }
    if (input['glob'] case final String glob) {
      parts.add('--include="$glob"');
    }
    if (input['type'] case final String type) parts.add('--type=$type');
    if (input['multiline'] == true) parts.add('-P');
    if (input['pattern'] case final String pattern) parts.add('"$pattern"');
    if (input['path'] case final String path) parts.add(path);
    return parts.join(' ');
  }

  String _webSearchTitle(JsonMap input) {
    var title = input['query'] is String ? '"${input['query']}"' : 'Web search';
    final allowed = _stringValues(input['allowed_domains']);
    final blocked = _stringValues(input['blocked_domains']);
    if (allowed.isNotEmpty) title += ' (allowed: ${allowed.join(', ')})';
    if (blocked.isNotEmpty) title += ' (blocked: ${blocked.join(', ')})';
    return title;
  }

  String _todoTitle(JsonMap input) {
    final values = input['todos'];
    if (values is! List<Object?>) return 'Update TODOs';
    final labels = <String>[
      for (final value in values)
        if (value is Map<Object?, Object?> && value['content'] is String)
          value['content']! as String,
    ];
    return labels.isEmpty
        ? 'Update TODOs'
        : 'Update TODOs: ${labels.join(', ')}';
  }

  String _findingsTitle(JsonMap input) {
    final values = input['findings'];
    final count = values is List<Object?> ? values.length : 0;
    return count == 0
        ? 'Report findings: none found'
        : 'Report $count finding${count == 1 ? '' : 's'}';
  }

  List<String> _stringValues(Object? value) => value is List<Object?>
      ? <String>[
          for (final item in value)
            if (item is String) item,
        ]
      : const <String>[];

  String _jsonDisplay(JsonMap input) {
    final entries = input.entries
        .map((entry) => '  "${entry.key}": "${entry.value}"')
        .join(',\n');
    return '```json\n{\n$entries\n}\n```';
  }

  String _jsonDisplayMap(Map<Object?, Object?> value) {
    final input = <String, Object?>{
      for (final entry in value.entries)
        if (entry.key is String) entry.key! as String: entry.value,
    };
    return _jsonDisplay(input);
  }

  String? _bashText(Object? raw, JsonMap? sidecar) {
    final stdout = sidecar?['stdout'];
    final stderr = sidecar?['stderr'];
    if (stdout is String &&
        stderr is String &&
        sidecar?['isImage'] != true &&
        sidecar?['backgroundTaskId'] == null) {
      final values = <String>[
        if (stdout.isNotEmpty) stdout,
        if (stderr.isNotEmpty) stderr,
      ];
      if (sidecar?['interrupted'] == true) {
        values.add('[Command was aborted before completion]');
      }
      if (sidecar?['persistedOutputPath'] case final String path) {
        final size = sidecar?['persistedOutputSize'];
        values.add(
          '[Output truncated${size is num ? ' ($size bytes total)' : ''}: '
          'full output saved to $path]',
        );
      }
      return values.join('\n');
    }
    final output = sidecar?['output'];
    if (output is String) return output;
    if (output is Map<Object?, Object?>) {
      final stdout = output['stdout'];
      final stderr = output['stderr'];
      final values = <String>[
        if (stdout is String && stdout.isNotEmpty) stdout,
        if (stderr is String && stderr.isNotEmpty) stderr,
      ];
      if (values.isNotEmpty) return values.join('\n');
    }
    if (raw is String) return raw;
    if (raw is List<Object?>) {
      final text = <String>[
        for (final item in raw)
          if (item is Map<Object?, Object?> && item['text'] is String)
            item['text']! as String,
      ];
      if (text.isNotEmpty) return text.join('\n');
    }
    return null;
  }

  int _exitCode(JsonMap? sidecar, bool failed) {
    final output = sidecar?['output'];
    final direct = sidecar?['return_code'] ?? sidecar?['returnCode'];
    final nested = output is Map<Object?, Object?>
        ? output['return_code'] ?? output['returnCode']
        : null;
    final code = direct ?? nested;
    if (code is int) return code;
    if (sidecar?['interrupted'] == true) return 1;
    return failed ? 1 : 0;
  }

  bool _containsImage(Object? raw) =>
      raw is List<Object?> &&
      raw.any(
        (item) => item is Map<Object?, Object?> && item['type'] == 'image',
      );

  String _commandTitle(Object? command, Object? description) {
    if (command is String && command.trim().isNotEmpty) {
      return command;
    }
    if (description is String && description.trim().isNotEmpty) {
      return description;
    }
    return 'Terminal';
  }

  Map<String, Object?>? _location(ToolUseBlock block, String cwd) {
    final input = block.input;
    final raw = input['file_path'] ?? input['path'];
    if (raw is! String || raw.isEmpty) return null;
    final path = raw.startsWith('/') ? raw : '$cwd/$raw';
    final line = input['line'] ?? input['line_number'] ?? input['offset'];
    return <String, Object?>{
      'path': path,
      if (line is int && line >= 0) 'line': line,
    };
  }

  String _stripTrailer(String value) {
    var body = value.trimRight();
    body = _stripAgentIdLine(body);
    if (body.endsWith('</usage>')) {
      final start = body.lastIndexOf('<usage>');
      if (start >= 0) {
        body = body.substring(
          0,
          start > 0 && body[start - 1] == '\n' ? start - 1 : start,
        );
      }
    }
    return _stripAgentIdLine(body);
  }

  String _stripAgentIdLine(String body) {
    final lineStart = body.lastIndexOf('\n') + 1;
    final line = body.substring(lineStart);
    if (RegExp(r'^agentId: [\w-]+ \([^)]*\)$').hasMatch(line)) {
      return body.substring(0, lineStart > 0 ? lineStart - 1 : 0).trimRight();
    }
    return body;
  }
}

const Set<String> _knownTools = <String>{
  'Agent',
  'AskUserQuestion',
  'Bash',
  'Edit',
  'EnterPlanMode',
  'ExitPlanMode',
  'Glob',
  'Grep',
  'NotebookEdit',
  'Read',
  'ReportFindings',
  'Task',
  'TaskCreate',
  'TaskGet',
  'TaskList',
  'TaskOutput',
  'TaskUpdate',
  'TodoWrite',
  'WebFetch',
  'WebSearch',
  'Write',
};
