import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../app_server/backend.dart';
import '../app_server/json_values.dart';
import '../config/modes.dart';
import '../session/state.dart';

/// Result of attempting to execute an ACP slash command.
final class CodexCommandResult {
  /// Creates a result.
  const CodexCommandResult({
    required this.handled,
    this.updates = const <SessionUpdate>[],
  });

  /// Whether the prompt was consumed as a built-in command.
  final bool handled;

  /// Updates to publish before returning from the prompt.
  final List<SessionUpdate> updates;
}

/// Parses and executes adapter-level slash commands.
final class CodexCommands {
  /// Creates a command service.
  const CodexCommands(this.backend);

  /// App-server boundary.
  final CodexBackend backend;

  /// Publishes the commands available without querying the app server.
  SessionUpdate availableCommands({
    Iterable<String> skills = const <String>[],
  }) {
    return SessionUpdate.fromJson(<String, Object?>{
      'sessionUpdate': 'available_commands_update',
      'availableCommands': <Object?>[
        for (final command in _builtIns) command,
        for (final skill in skills)
          <String, Object?>{
            'name': skill,
            'description': 'Run the $skill skill.',
            'input': <String, Object?>{'hint': 'optional instructions'},
          },
      ],
    });
  }

  /// Executes a recognized built-in command from [prompt].
  Future<CodexCommandResult> execute(
    List<ContentBlock> prompt,
    CodexSessionState session,
  ) async {
    final parsed = _parse(prompt);
    if (parsed == null) {
      return const CodexCommandResult(handled: false);
    }
    final (name, input) = parsed;
    switch (name) {
      case 'status':
        return CodexCommandResult(
          handled: true,
          updates: <SessionUpdate>[_message(await _status(session))],
        );
      case 'mcp':
        final response = await backend.request(
          'mcpServerStatus/list',
          params: CodexJsonObject.empty,
        );
        return CodexCommandResult(
          handled: true,
          updates: <SessionUpdate>[_message(_formatMcp(response))],
        );
      case 'skills':
        final response = await backend.request(
          'skills/list',
          params: CodexJsonObject.from(<String, Object?>{
            'cwds': <Object?>[session.cwd, ...session.additionalDirectories],
            'forceReload': true,
          }),
        );
        return CodexCommandResult(
          handled: true,
          updates: <SessionUpdate>[
            availableCommands(skills: _skillNames(response)),
            _message(_formatSkills(response)),
          ],
        );
      case 'compact':
        await backend.request(
          'thread/compact/start',
          params: CodexJsonObject.from(<String, Object?>{
            'threadId': session.sessionId.value,
          }),
        );
        return CodexCommandResult(
          handled: true,
          updates: <SessionUpdate>[_message('Context compaction started.')],
        );
      case 'plan':
        final enable = input != 'off';
        session.collaborationMode = enable
            ? CodexCollaborationMode.plan
            : CodexCollaborationMode.standard;
        await backend.request(
          'thread/settings/update',
          params: CodexJsonObject.from(<String, Object?>{
            'threadId': session.sessionId.value,
            'collaborationMode': <String, Object?>{
              'mode': session.collaborationMode.id,
              'settings': <String, Object?>{'model': session.model},
            },
          }),
        );
        return CodexCommandResult(
          handled: true,
          updates: <SessionUpdate>[
            SessionUpdate.fromJson(<String, Object?>{
              'sessionUpdate': 'current_mode_update',
              'currentModeId': session.collaborationMode.id,
            }),
          ],
        );
      case 'review':
      case 'review-branch':
      case 'review-commit':
        await backend.request(
          'review/start',
          params: CodexJsonObject.from(<String, Object?>{
            'threadId': session.sessionId.value,
            'target': switch (name) {
              'review-branch' => <String, Object?>{
                'type': 'baseBranch',
                'branch': input.isEmpty ? null : input,
              },
              'review-commit' => <String, Object?>{
                'type': 'commit',
                'sha': input.isEmpty ? null : input,
              },
              _ => <String, Object?>{
                'type': 'uncommittedChanges',
                'instructions': input.isEmpty ? null : input,
              },
            },
          }),
        );
        return const CodexCommandResult(handled: true);
      case 'goal':
        return _goal(session, input);
      case 'logout':
        await backend.request('account/logout');
        return CodexCommandResult(
          handled: true,
          updates: <SessionUpdate>[_message('Logged out.')],
        );
      default:
        return const CodexCommandResult(handled: false);
    }
  }

  Future<CodexCommandResult> _goal(
    CodexSessionState session,
    String input,
  ) async {
    if (input == 'clear') {
      await backend.request(
        'thread/goal/clear',
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': session.sessionId.value,
        }),
      );
      return CodexCommandResult(
        handled: true,
        updates: <SessionUpdate>[_message('Goal cleared.')],
      );
    }
    if (input == 'pause' || input == 'resume') {
      await backend.request(
        'thread/goal/set',
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': session.sessionId.value,
          'status': input == 'pause' ? 'paused' : 'active',
        }),
      );
      return CodexCommandResult(
        handled: true,
        updates: <SessionUpdate>[
          _message(input == 'pause' ? 'Goal paused.' : 'Goal resumed.'),
        ],
      );
    }
    if (input.isNotEmpty) {
      await backend.request(
        'thread/goal/set',
        params: CodexJsonObject.from(<String, Object?>{
          'threadId': session.sessionId.value,
          'objective': input,
        }),
      );
      return CodexCommandResult(
        handled: true,
        updates: <SessionUpdate>[_message('Goal updated.')],
      );
    }
    final response = await backend.request(
      'thread/goal/get',
      params: CodexJsonObject.from(<String, Object?>{
        'threadId': session.sessionId.value,
      }),
    );
    return CodexCommandResult(
      handled: true,
      updates: <SessionUpdate>[_message(_formatGoal(response))],
    );
  }

  Future<String> _status(CodexSessionState session) async {
    final account = await backend.request(
      'account/read',
      params: CodexJsonObject.from(<String, Object?>{'refreshToken': false}),
    );
    final accountValue = account.optionalObject('account');
    final identity =
        accountValue?.optionalString('email') ??
        accountValue?.optionalString('type') ??
        'not authenticated';
    final lines = <String>[
      'Account: $identity',
      'Model: ${session.model}',
      'Reasoning: ${session.effort.id}',
      'Mode: ${session.agentMode.label}',
      'Fast mode: ${session.fastMode ? 'enabled' : 'disabled'}',
      'Working directory: ${session.cwd}',
      if (session.contextWindow case final size?)
        'Context: ${session.usedTokens ?? 0} / $size tokens',
      if (session.goalObjective case final objective?)
        'Goal: $objective (${session.goalStatus ?? 'active'})',
      ..._formatRateLimits(session.rateLimits),
    ];
    return lines.join('\n');
  }

  Iterable<String> _formatRateLimits(CodexJsonObject? snapshot) sync* {
    if (snapshot == null) {
      return;
    }
    final raw =
        snapshot['rateLimitsByLimitId'] ??
        snapshot['rateLimits'] ??
        snapshot['limits'];
    if (raw is! Map<Object?, Object?>) {
      return;
    }
    for (final entry in raw.entries) {
      if (entry.value is! Map<Object?, Object?>) {
        continue;
      }
      final limit = CodexJsonObject.from(entry.value! as Map<Object?, Object?>);
      for (final window in const <String>['primary', 'secondary']) {
        final used = limit
            .optionalObject(window)
            ?.optionalNumber('usedPercent');
        if (used != null) {
          yield 'Rate limit ${entry.key} $window: '
              '${(100 - used).clamp(0, 100).round()}% remaining';
        }
      }
    }
  }

  String _formatMcp(CodexJsonObject response) {
    final data = response['data'] ?? response['servers'];
    if (data is! List<Object?> || data.isEmpty) {
      return 'No MCP servers are configured.';
    }
    return <String>[
      'MCP servers:',
      for (final raw in data)
        if (raw is Map<Object?, Object?>)
          '- ${raw['name'] ?? raw['serverName'] ?? 'server'}: '
              '${raw['status'] ?? 'unknown'}',
    ].join('\n');
  }

  String _formatSkills(CodexJsonObject response) {
    final names = _skillNames(response);
    return names.isEmpty
        ? 'No skills are available.'
        : 'Available skills:\n${names.map((name) => '- $name').join('\n')}';
  }

  Iterable<String> _skillNames(CodexJsonObject response) sync* {
    final data = response['data'] ?? response['skills'];
    if (data is! List<Object?>) {
      return;
    }
    for (final raw in data) {
      if (raw is Map<Object?, Object?>) {
        final name = raw['name'];
        if (name is String && name.isNotEmpty) {
          yield name;
        }
      }
    }
  }

  String _formatGoal(CodexJsonObject response) {
    final goal = response.optionalObject('goal') ?? response;
    final objective = goal.optionalString('objective');
    if (objective == null || objective.isEmpty) {
      return 'No goal is active.';
    }
    return 'Goal: $objective\nStatus: ${goal.optionalString('status') ?? 'active'}';
  }

  (String, String)? _parse(List<ContentBlock> prompt) {
    if (prompt.length != 1 || prompt.single is! ContentBlockText) {
      return null;
    }
    final json = prompt.single.toJson();
    final text = json['text'];
    if (text is! String || !text.startsWith('/')) {
      return null;
    }
    final trimmed = text.substring(1).trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final space = trimmed.indexOf(RegExp(r'\s'));
    return space < 0
        ? (trimmed, '')
        : (trimmed.substring(0, space), trimmed.substring(space + 1).trim());
  }

  SessionUpdate _message(String text) =>
      SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': 'agent_message_chunk',
        'content': <String, Object?>{'type': 'text', 'text': text},
      });

  static const List<Map<String, Object?>> _builtIns = <Map<String, Object?>>[
    <String, Object?>{
      'name': 'status',
      'description': 'Show account and session status.',
    },
    <String, Object?>{'name': 'mcp', 'description': 'Show MCP server status.'},
    <String, Object?>{
      'name': 'skills',
      'description': 'Reload and list available skills.',
    },
    <String, Object?>{
      'name': 'review',
      'description': 'Review uncommitted changes.',
      'input': <String, Object?>{'hint': 'optional review instructions'},
    },
    <String, Object?>{
      'name': 'review-branch',
      'description': 'Review changes against a base branch.',
      'input': <String, Object?>{'hint': 'branch name'},
    },
    <String, Object?>{
      'name': 'review-commit',
      'description': 'Review a commit.',
      'input': <String, Object?>{'hint': 'commit sha'},
    },
    <String, Object?>{
      'name': 'compact',
      'description': 'Compact the session context.',
    },
    <String, Object?>{
      'name': 'plan',
      'description': 'Enable plan mode; use /plan off to disable.',
      'input': <String, Object?>{'hint': 'off'},
    },
    <String, Object?>{
      'name': 'goal',
      'description': 'Inspect or control the session goal.',
      'input': <String, Object?>{'hint': '<objective>|clear|pause|resume'},
    },
    <String, Object?>{'name': 'logout', 'description': 'Log out of Codex.'},
  ];
}
