import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../app_server/json_values.dart';
import 'diff_reconstructor.dart';

/// Maps Codex item lifecycle events to ACP tool-call updates.
final class CodexToolCallMapper {
  /// Creates a mapper.
  const CodexToolCallMapper({
    CodexDiffReconstructor diffs = const CodexDiffReconstructor(),
    this.terminalOutput = false,
  }) : _diffs = diffs;

  final CodexDiffReconstructor _diffs;

  /// Whether the client accepts the richer `terminal_output` metadata.
  final bool terminalOutput;

  /// Maps an `item/started` payload.
  SessionUpdate? started(CodexJsonObject params) {
    final item = params.optionalObject('item');
    if (item == null || !_isTool(item.optionalString('type'))) {
      return null;
    }
    final id = item.optionalString('id');
    if (id == null || id.isEmpty) {
      return null;
    }
    final type = item.optionalString('type')!;
    final content = <Object?>[
      ..._content(type, item),
      if (type == 'imageGeneration' &&
          item.optionalString('status') == 'completed')
        ..._completedContent(type, item),
    ];
    return _update(<String, Object?>{
      'sessionUpdate': 'tool_call',
      'toolCallId': id,
      'title': _title(type, item),
      'kind': _kind(type, item),
      'status': _status(item.optionalString('status'), started: true),
      if (content.isNotEmpty) 'content': content,
      'rawInput': _rawInput(type, item),
      if (type == 'imageGeneration' &&
          item.optionalString('status') == 'completed')
        'rawOutput': _rawOutput(type, item),
      if (_locations(type, item).isNotEmpty)
        'locations': _locations(type, item),
      if (type == 'commandExecution' && _usesTerminal(item))
        '_meta': <String, Object?>{
          'terminal_info': <String, Object?>{
            'cwd': item.optionalString('cwd') ?? '',
            'terminal_id': id,
          },
        },
      if (type == 'mcpToolCall')
        '_meta': <String, Object?>{'is_mcp_tool_call': true},
      if (type == 'collabAgentToolCall' || type == 'subAgentActivity')
        '_meta': _collaborationMeta(type, item),
    });
  }

  /// Maps an `item/completed` payload.
  SessionUpdate? completed(CodexJsonObject params) {
    final item = params.optionalObject('item');
    if (item == null || !_isTool(item.optionalString('type'))) {
      return null;
    }
    final id = item.optionalString('id');
    if (id == null || id.isEmpty) {
      return null;
    }
    final type = item.optionalString('type')!;
    if (type == 'imageView') {
      return started(params);
    }
    final status = item.optionalString('status');
    final content = _completedContent(type, item);
    return _update(<String, Object?>{
      'sessionUpdate': 'tool_call_update',
      'toolCallId': id,
      if (type == 'collabAgentToolCall') 'title': _title(type, item),
      'status': _status(status),
      if (content.isNotEmpty) 'content': content,
      'rawInput': _rawInput(type, item),
      'rawOutput': _rawOutput(type, item),
      if (type == 'commandExecution' && _usesTerminal(item))
        '_meta': <String, Object?>{
          if (_outputText(item) case final output?)
            terminalOutput ? 'terminal_output' : 'terminal_output_delta':
                <String, Object?>{'data': output, 'terminal_id': id},
          'terminal_exit': <String, Object?>{
            'exit_code': item['exitCode'],
            'signal': null,
            'terminal_id': id,
          },
        },
      if (type == 'collabAgentToolCall' || type == 'subAgentActivity')
        '_meta': _collaborationMeta(type, item),
    });
  }

  /// Maps command and MCP progress output.
  SessionUpdate? progress(CodexJsonObject params) {
    final itemId =
        params.optionalString('itemId') ??
        params.optionalObject('item')?.optionalString('id');
    if (itemId == null || itemId.isEmpty) {
      return null;
    }
    final delta =
        params.optionalString('delta') ??
        params.optionalString('message') ??
        params.optionalString('output');
    if (delta == null || delta.isEmpty) {
      return null;
    }
    return _update(<String, Object?>{
      'sessionUpdate': 'tool_call_update',
      'toolCallId': itemId,
      'content': <Object?>[
        <String, Object?>{
          'type': 'content',
          'content': <String, Object?>{'type': 'text', 'text': delta},
        },
      ],
      '_meta': <String, Object?>{
        if (params.optionalString('message') != null)
          'mcp_output_delta': <String, Object?>{'data': delta}
        else
          terminalOutput ? 'terminal_output' : 'terminal_output_delta':
              <String, Object?>{'data': delta, 'terminal_id': itemId},
      },
    });
  }

  SessionUpdate _update(Map<String, Object?> value) =>
      SessionUpdate.fromJson(value);

  bool _isTool(String? type) => switch (type) {
    'commandExecution' ||
    'fileChange' ||
    'mcpToolCall' ||
    'dynamicToolCall' ||
    'webSearch' ||
    'imageView' ||
    'imageGeneration' ||
    'collabAgentToolCall' ||
    'subAgentActivity' ||
    'contextCompaction' => true,
    _ => false,
  };

  String _title(String type, CodexJsonObject item) => switch (type) {
    'commandExecution' => _commandTitle(item),
    'fileChange' => 'Editing files',
    'mcpToolCall' =>
      'mcp.${item.optionalString('server') ?? 'server'}.'
          '${item.optionalString('tool') ?? 'tool'}',
    'dynamicToolCall' => item.optionalString('tool') ?? 'Run tool',
    'webSearch' => _webTitle(item),
    'imageView' => 'View Image ${item.optionalString('path') ?? ''}'.trim(),
    'imageGeneration' => 'Image generation',
    'collabAgentToolCall' => item.optionalString('tool') ?? 'Coordinate agents',
    'subAgentActivity' => _subAgentTitle(item),
    'contextCompaction' => 'Context compacting',
    _ => 'Use tool',
  };

  String _kind(String type, CodexJsonObject item) => switch (type) {
    'commandExecution' => _commandKind(item),
    'fileChange' => 'edit',
    'webSearch' => 'search',
    'imageView' => 'read',
    'contextCompaction' => 'think',
    _ => 'other',
  };

  String _commandKind(CodexJsonObject item) {
    final action = _singleCommandAction(item);
    final actionType = action?.optionalString('type');
    if (actionType == 'read' || actionType == 'listFiles') {
      return 'read';
    }
    if (actionType == 'search') {
      return 'search';
    }
    final command = _commandText(item);
    final first = command.trim().split(RegExp(r'\s+')).firstOrNull;
    return switch (first) {
      'cat' || 'head' || 'tail' || 'sed' => 'read',
      'find' || 'grep' || 'rg' => 'search',
      'ls' || 'tree' => 'read',
      _ => 'execute',
    };
  }

  String _commandTitle(CodexJsonObject item) {
    final action = _singleCommandAction(item);
    if (action != null) {
      final type = action.optionalString('type');
      final path = action.optionalString('path');
      final query = action.optionalString('query');
      if (type == 'read' && path != null) {
        return "Read file '$path'";
      }
      if (type == 'listFiles') {
        return path == null ? 'List files' : "List files in '$path'";
      }
      if (type == 'search') {
        return _searchTitle(query, path);
      }
    }
    final command = _commandText(item);
    return command.isEmpty ? 'Run command' : command;
  }

  String _webTitle(CodexJsonObject item) {
    final action = item.optionalObject('action');
    final type = action?.optionalString('type');
    final actionQuery = action?.optionalString('query');
    final actionUrl = action?.optionalString('url');
    final pattern = action?.optionalString('pattern');
    final query = item.optionalString('query');
    return switch (type) {
      'search' => 'Web search: ${actionQuery ?? query ?? ''}',
      'openPage' => 'Open page: ${actionUrl ?? ''}',
      'findInPage' =>
        'Find in page'
            '${pattern == null ? '' : " for '$pattern'"}'
            '${actionUrl == null ? '' : ' in $actionUrl'}',
      _ => query == null ? 'Web search' : 'Web search: $query',
    };
  }

  List<Map<String, Object?>> _locations(String type, CodexJsonObject item) {
    final imagePath = item.optionalString('path');
    if (type == 'imageView' && imagePath != null) {
      return <Map<String, Object?>>[
        <String, Object?>{'path': imagePath},
      ];
    }
    if (type == 'commandExecution') {
      final path = _singleCommandAction(item)?.optionalString('path');
      if (path != null) {
        return <Map<String, Object?>>[
          <String, Object?>{'path': path},
        ];
      }
    }
    if (type != 'fileChange') {
      return const <Map<String, Object?>>[];
    }
    final changes = item['changes'];
    if (changes is! List<Object?>) {
      return const <Map<String, Object?>>[];
    }
    return <Map<String, Object?>>[
      for (final change in changes)
        if (change is Map<Object?, Object?> && change['path'] is String)
          <String, Object?>{'path': change['path']},
    ];
  }

  String? _outputText(CodexJsonObject item) {
    for (final key in const <String>[
      'aggregatedOutput',
      'output',
      'result',
      'message',
    ]) {
      final value = item[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  List<String> _stringList(Object? value) {
    if (value is! List<Object?>) {
      return const <String>[];
    }
    return <String>[
      for (final item in value)
        if (item is String) item,
    ];
  }

  String _commandText(CodexJsonObject item) => switch (item['command']) {
    final String command => command,
    final List<Object?> command => _stringList(command).join(' '),
    _ => '',
  };

  String _status(String? status, {bool started = false}) => switch (status) {
    'failed' || 'declined' || 'denied' || 'aborted' || 'timedOut' => 'failed',
    'completed' || 'approved' => 'completed',
    _ => started ? 'in_progress' : 'completed',
  };

  Object _rawInput(String type, CodexJsonObject item) => switch (type) {
    'commandExecution' => <String, Object?>{
      'command': _commandText(item),
      'cwd': item.optionalString('cwd') ?? '',
    },
    'mcpToolCall' => <String, Object?>{
      'server': item.optionalString('server'),
      'tool': item.optionalString('tool'),
      'arguments': item['arguments'],
    },
    'dynamicToolCall' => <String, Object?>{'arguments': item['arguments']},
    'webSearch' => <String, Object?>{
      'type': type,
      'id': item.optionalString('id'),
      'query': item.optionalString('query'),
      'action': item['action'],
    },
    'imageView' => <String, Object?>{'path': item.optionalString('path')},
    'imageGeneration' => <String, Object?>{'id': item.optionalString('id')},
    'collabAgentToolCall' => <String, Object?>{
      'prompt': item.optionalString('prompt'),
      'senderThreadId': item.optionalString('senderThreadId'),
      'receiverThreadIds': item['receiverThreadIds'],
      'agentsStates': item['agentsStates'],
      'model': item['model'],
      'reasoningEffort': item['reasoningEffort'],
      'status': item.optionalString('status'),
    },
    'subAgentActivity' => <String, Object?>{
      'agentThreadId': item.optionalString('agentThreadId'),
      'agentPath': item.optionalString('agentPath'),
      'activityKind': item.optionalString('kind'),
    },
    _ => item.toJson(),
  };

  Object _rawOutput(String type, CodexJsonObject item) => switch (type) {
    'commandExecution' => <String, Object?>{
      'formatted_output': item.optionalString('aggregatedOutput') ?? '',
      'exit_code': item['exitCode'],
    },
    'mcpToolCall' => <String, Object?>{
      'result': item['result'],
      'error': item['error'],
    },
    'imageGeneration' => <String, Object?>{
      'status': item.optionalString('status'),
      'revisedPrompt': item.optionalString('revisedPrompt'),
      'result': item.optionalString('result'),
      if (item.containsKey('savedPath')) 'savedPath': item['savedPath'],
    },
    _ => item.toJson(),
  };

  List<Object?> _content(String type, CodexJsonObject item) {
    if (type == 'commandExecution' && _usesTerminal(item)) {
      return <Object?>[
        <String, Object?>{
          'type': 'terminal',
          'terminalId': item.optionalString('id'),
        },
      ];
    }
    if (type == 'fileChange') {
      final changes = item['changes'];
      if (changes is! List<Object?>) {
        return const <Object?>[];
      }
      final content = <Object?>[];
      for (final change in changes) {
        if (change is Map<Object?, Object?>) {
          final diff = _diffs.reconstruct(CodexJsonObject.from(change));
          if (diff != null) {
            content.add(diff);
          }
        }
      }
      return content;
    }
    final imagePath = item.optionalString('path');
    if (type == 'imageView' && imagePath != null) {
      return <Object?>[
        <String, Object?>{
          'type': 'content',
          'content': <String, Object?>{
            'type': 'resource_link',
            'name': imagePath,
            'uri': imagePath,
          },
        },
      ];
    }
    return const <Object?>[];
  }

  List<Object?> _completedContent(String type, CodexJsonObject item) {
    if (type == 'imageGeneration') {
      final prompt = item.optionalString('revisedPrompt');
      final data = item.optionalString('result');
      final savedPath = item.optionalString('savedPath');
      return <Object?>[
        if (prompt != null && prompt.trim().isNotEmpty)
          <String, Object?>{
            'type': 'content',
            'content': <String, Object?>{
              'type': 'text',
              'text': 'Revised prompt: $prompt',
            },
          },
        if (data != null && data.trim().isNotEmpty)
          <String, Object?>{
            'type': 'content',
            'content': <String, Object?>{
              'type': 'image',
              'data': data,
              'mimeType': 'image/png',
              'uri': ?savedPath,
            },
          },
      ];
    }
    final output = _outputText(item);
    if (type != 'commandExecution' && output != null && output.isNotEmpty) {
      return <Object?>[
        <String, Object?>{
          'type': 'content',
          'content': <String, Object?>{'type': 'text', 'text': output},
        },
      ];
    }
    return const <Object?>[];
  }

  bool _usesTerminal(CodexJsonObject item) {
    final action = _singleCommandAction(item);
    return action == null || action.optionalString('type') == 'unknown';
  }

  CodexJsonObject? _singleCommandAction(CodexJsonObject item) {
    final actions = item['commandActions'];
    if (actions is! List<Object?> || actions.length != 1) {
      return null;
    }
    final action = actions.single;
    return action is Map<Object?, Object?>
        ? CodexJsonObject.from(action)
        : null;
  }

  String _searchTitle(String? query, String? path) {
    if (query != null && path != null) {
      return "Search for '$query' in $path";
    }
    if (query != null) {
      return "Search for '$query'";
    }
    return path == null ? 'Search' : "Search in '$path'";
  }

  String _subAgentTitle(CodexJsonObject item) {
    final path = item.optionalString('agentPath') ?? '';
    final name =
        path.split('/').where((part) => part.isNotEmpty).lastOrNull ??
        'subagent';
    return switch (item.optionalString('kind')) {
      'started' => 'Start subagent $name',
      'interacted' => 'Interact with subagent $name',
      'interrupted' => 'Interrupt subagent $name',
      _ => 'Subagent activity',
    };
  }

  Map<String, Object?> _collaborationMeta(String type, CodexJsonObject item) =>
      type == 'collabAgentToolCall'
      ? <String, Object?>{
          'codex': <String, Object?>{
            'collaboration': <String, Object?>{
              'tool': item.optionalString('tool'),
              'senderThreadId': item.optionalString('senderThreadId'),
              'receiverThreadIds': item['receiverThreadIds'],
            },
          },
        }
      : <String, Object?>{
          'codex': <String, Object?>{
            'subagent': <String, Object?>{
              'threadId': item.optionalString('agentThreadId'),
              'path': item.optionalString('agentPath'),
              'activity': item.optionalString('kind'),
            },
          },
        };
}
