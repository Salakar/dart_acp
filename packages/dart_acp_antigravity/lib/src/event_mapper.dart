import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import 'events.dart';

/// Stateful mapper from Antigravity stream-json step updates to ACP session
/// updates.
///
/// One mapper instance serves one ACP session. Tool-call identifiers derive
/// from the CLI's conversation-scoped step indexes, which stay unique across
/// resumed print-mode runs of the same conversation.
final class AntigravityEventMapper {
  /// Creates an event mapper.
  AntigravityEventMapper();

  final Set<int> _announcedTools = <int>{};

  /// Converts a step update to zero or more ACP session updates.
  List<SessionUpdate> map(AntigravityStepUpdateEvent event) {
    return switch (event.stepType) {
      'agent_response' => _text('agent_message_chunk', event.textDelta),
      'planner_response' => _text('agent_thought_chunk', event.textDelta),
      'tool' => _tool(event),
      _ => const <SessionUpdate>[],
    };
  }

  List<SessionUpdate> _text(String discriminator, String? delta) {
    if (delta == null || delta.isEmpty) {
      return const <SessionUpdate>[];
    }
    return <SessionUpdate>[
      SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': discriminator,
        'content': <String, Object?>{'type': 'text', 'text': delta},
      }),
    ];
  }

  List<SessionUpdate> _tool(AntigravityStepUpdateEvent event) {
    if (event.stepIndex < 0) {
      return const <SessionUpdate>[];
    }
    final String toolCallId = 'agy-step-${event.stepIndex}';
    final bool announced = !_announcedTools.add(event.stepIndex);
    final String status = switch (event.state) {
      'ERROR' => 'failed',
      'DONE' => 'completed',
      _ => 'in_progress',
    };
    final String? resultText = event.toolErrorMessage ?? event.toolOutput;
    if (announced) {
      return <SessionUpdate>[
        SessionUpdate.fromJson(<String, Object?>{
          'sessionUpdate': 'tool_call_update',
          'toolCallId': toolCallId,
          'status': status,
          if (resultText != null && resultText.isNotEmpty)
            'content': <Object?>[_textContent(resultText)],
          if (event.toolOutput != null)
            'rawOutput': <String, Object?>{'output': event.toolOutput},
        }),
      ];
    }
    return <SessionUpdate>[
      SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': 'tool_call',
        'toolCallId': toolCallId,
        'title': _title(event),
        'kind': _kind(event.toolName).value,
        'status': status,
        if (event.toolParameters case final Map<String, Object?> parameters)
          'rawInput': parameters,
        if (_locations(event.toolParameters) case final List<Object?> locations
            when locations.isNotEmpty)
          'locations': locations,
        if (resultText != null && resultText.isNotEmpty)
          'content': <Object?>[_textContent(resultText)],
      }),
    ];
  }

  Map<String, Object?> _textContent(String text) => <String, Object?>{
    'type': 'content',
    'content': <String, Object?>{'type': 'text', 'text': text},
  };

  String _title(AntigravityStepUpdateEvent event) {
    final String name = event.toolName ?? 'tool';
    if (name == 'run_command') {
      final Object? command =
          event.toolParameters?['CommandLine'] ??
          event.toolParameters?['Command'];
      if (command is String && command.isNotEmpty) {
        return command;
      }
    }
    return name;
  }

  ToolKind _kind(String? toolName) => switch (toolName) {
    'view_file' || 'read_resource' || 'list_resources' => ToolKind.read,
    'list_dir' || 'find_by_name' || 'grep_search' => ToolKind.search,
    'write_to_file' ||
    'replace_file_content' ||
    'multi_replace_file_content' ||
    'sed_file' ||
    'notebook_edit' => ToolKind.edit,
    'run_command' ||
    'send_command_input' ||
    'command_status' ||
    'notebook_execution' => ToolKind.execute,
    'search_web' ||
    'read_url_content' ||
    'open_browser_url' ||
    'read_browser_page' => ToolKind.fetch,
    'manage_task' => ToolKind.think,
    _ => ToolKind.other,
  };

  List<Object?> _locations(Map<String, Object?>? parameters) {
    if (parameters == null) {
      return const <Object?>[];
    }
    const List<String> pathKeys = <String>[
      'AbsolutePath',
      'DirectoryPath',
      'TargetFile',
      'FilePath',
      'SearchDirectory',
    ];
    return <Object?>[
      for (final String key in pathKeys)
        if (parameters[key] case final String path when path.isNotEmpty)
          <String, Object?>{'path': path},
    ];
  }
}
