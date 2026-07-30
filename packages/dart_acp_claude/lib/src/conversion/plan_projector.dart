import 'dart:convert';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

/// Stateful projection of Claude task tools onto the ACP execution plan.
final class ClaudePlanProjector {
  final Map<String, _PlanItem> _items = <String, _PlanItem>{};
  final Map<String, ToolUseBlock> _pendingTools = <String, ToolUseBlock>{};

  /// Whether [name] is represented by plan updates instead of a tool card.
  static bool isPlanTool(String name) =>
      name == 'TodoWrite' || _taskTools.contains(name);

  /// Records [block] and returns a plan update when it directly describes one.
  SessionUpdate? start(ToolUseBlock block) {
    _pendingTools[block.id] = block;
    if (block.name != 'TodoWrite') return null;
    _items.clear();
    final todos = block.input['todos'];
    if (todos is List<Object?>) {
      for (var index = 0; index < todos.length; index++) {
        final todo = todos[index];
        if (todo is! Map<Object?, Object?>) continue;
        final content = todo['content'];
        if (content is! String || content.trim().isEmpty) continue;
        final id = todo['id'] is String ? todo['id']! as String : 'todo-$index';
        _items[id] = _PlanItem(
          id: id,
          content: content,
          status: _status(todo['status']),
        );
      }
    }
    return _update();
  }

  /// Projects [block], returning `null` when normal tool-result handling applies.
  List<SessionUpdate>? finish(ToolResultBlock block) {
    final tool = _pendingTools.remove(block.toolUseId);
    if (tool == null) return null;
    if (tool.name == 'TodoWrite') return const <SessionUpdate>[];
    if (!_taskTools.contains(tool.name)) return null;
    if (block.isError == true) return const <SessionUpdate>[];
    switch (tool.name) {
      case 'TaskCreate':
        final id = _taskId(block.content);
        final subject = tool.input['subject'];
        if (id != null && subject is String && subject.trim().isNotEmpty) {
          _items[id] = _PlanItem(
            id: id,
            content: subject,
            status: PlanEntryStatus.pending,
          );
          return <SessionUpdate>[_update()];
        }
      case 'TaskUpdate':
        final id = tool.input['taskId'] ?? tool.input['task_id'];
        if (id is! String || id.isEmpty) return const <SessionUpdate>[];
        if (tool.input['status'] == 'deleted') {
          if (_items.remove(id) != null) return <SessionUpdate>[_update()];
          return const <SessionUpdate>[];
        }
        final existing = _items[id];
        final subject = tool.input['subject'];
        if (existing == null && subject is! String) {
          return const <SessionUpdate>[];
        }
        _items[id] = _PlanItem(
          id: id,
          content: subject is String ? subject : existing!.content,
          status: tool.input.containsKey('status')
              ? _status(tool.input['status'])
              : existing?.status ?? PlanEntryStatus.pending,
        );
        return <SessionUpdate>[_update()];
      case 'TaskList' || 'TaskGet':
        return const <SessionUpdate>[];
    }
    return const <SessionUpdate>[];
  }

  /// Projects background task lifecycle [message] onto the plan.
  SessionUpdate? system(SystemMessage message) {
    switch (message) {
      case TaskStartedMessage():
        _items.putIfAbsent(
          message.taskId,
          () => _PlanItem(
            id: message.taskId,
            content: message.description,
            status: PlanEntryStatus.inProgress,
          ),
        );
        return _update();
      case TaskProgressMessage():
        final existing = _items[message.taskId];
        _items[message.taskId] = _PlanItem(
          id: message.taskId,
          content: message.description.isEmpty
              ? existing?.content ?? 'Background task'
              : message.description,
          status: PlanEntryStatus.inProgress,
        );
        return _update();
      case TaskNotificationMessage():
        final existing = _items[message.taskId];
        if (existing == null) return null;
        _items[message.taskId] = _PlanItem(
          id: existing.id,
          content: existing.content,
          status: PlanEntryStatus.completed,
        );
        return _update();
      case TaskUpdatedMessage():
        final existing = _items[message.taskId];
        if (existing == null) return null;
        final subject = message.patch['subject'];
        _items[message.taskId] = _PlanItem(
          id: existing.id,
          content: subject is String ? subject : existing.content,
          status: _taskStatus(message.status) ?? existing.status,
        );
        return _update();
      default:
        return null;
    }
  }

  /// Projects task lifecycle hooks that precede or outlive tool-result frames.
  SessionUpdate? hook(HookInput input) {
    switch (input) {
      case TaskCreatedHookInput():
        if (_items.containsKey(input.taskId)) return null;
        _items[input.taskId] = _PlanItem(
          id: input.taskId,
          content: input.taskSubject,
          status: PlanEntryStatus.pending,
        );
        return _update();
      case TaskCompletedHookInput():
        final existing = _items[input.taskId];
        if (existing == null || existing.status == PlanEntryStatus.completed) {
          return null;
        }
        _items[input.taskId] = _PlanItem(
          id: existing.id,
          content: existing.content,
          status: PlanEntryStatus.completed,
        );
        return _update();
      default:
        return null;
    }
  }

  SessionUpdate _update() => SessionUpdate.fromJson(<String, Object?>{
    'sessionUpdate': 'plan',
    'entries': <Object?>[
      for (final item in _items.values)
        <String, Object?>{
          'content': item.content,
          'priority': 'medium',
          'status': item.status.value,
          '_meta': <String, Object?>{
            'claude': <String, Object?>{'taskId': item.id},
          },
        },
    ],
  });

  String? _taskId(Object? raw) {
    Object? value = raw;
    if (value is String) {
      try {
        value = jsonDecode(value);
      } on FormatException {
        return null;
      }
    }
    if (value is List<Object?>) {
      for (final block in value) {
        if (block is Map<Object?, Object?> && block['text'] is String) {
          final id = _taskId(block['text']);
          if (id != null) return id;
        }
      }
      return null;
    }
    if (value is! Map<Object?, Object?>) return null;
    final direct = value['id'] ?? value['taskId'] ?? value['task_id'];
    if (direct is String && direct.isNotEmpty) return direct;
    final task = value['task'];
    return task is Map<Object?, Object?> ? _taskId(task) : null;
  }

  PlanEntryStatus _status(Object? raw) => switch (raw) {
    'in_progress' || 'running' || 'active' => PlanEntryStatus.inProgress,
    'completed' || 'done' => PlanEntryStatus.completed,
    _ => PlanEntryStatus.pending,
  };

  PlanEntryStatus? _taskStatus(TaskStatus? status) => switch (status) {
    TaskStatus.pending => PlanEntryStatus.pending,
    TaskStatus.running || TaskStatus.paused => PlanEntryStatus.inProgress,
    TaskStatus.completed ||
    TaskStatus.failed ||
    TaskStatus.killed ||
    TaskStatus.stopped => PlanEntryStatus.completed,
    null => null,
  };
}

final class _PlanItem {
  const _PlanItem({
    required this.id,
    required this.content,
    required this.status,
  });

  final String id;
  final String content;
  final PlanEntryStatus status;
}

const Set<String> _taskTools = <String>{
  'TaskCreate',
  'TaskUpdate',
  'TaskList',
  'TaskGet',
};
