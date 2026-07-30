import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../errors.dart';
import '../mcp.dart';
import '../options.dart';

/// Version reported to Claude Code by this Dart package.
const String packageVersion = '0.1.1';

/// Oldest Claude Code release supported by this package.
const String minimumCliVersion = '2.0.0';

final RegExp _unsafeWindowsValue = RegExp(r'''[&|<>^%!"\r\n]''');

/// Complete immutable CLI launch configuration.
final class CliLaunchPlan {
  /// Creates a launch plan.
  CliLaunchPlan({
    required this.executable,
    required List<String> arguments,
    required Map<String, String> environment,
    this.workingDirectory,
  }) : arguments = List<String>.unmodifiable(arguments),
       environment = Map<String, String>.unmodifiable(environment);

  /// CLI executable path.
  final String executable;

  /// CLI arguments.
  final List<String> arguments;

  /// Complete child environment.
  final Map<String, String> environment;

  /// Child working directory.
  final String? workingDirectory;
}

/// Resolves the executable, arguments, environment, and working directory.
Future<CliLaunchPlan> createCliLaunchPlan(
  ClaudeAgentOptions options, {
  Map<String, String>? parentEnvironment,
  bool? isWindows,
}) async {
  final environment = parentEnvironment ?? Platform.environment;
  final windows = isWindows ?? Platform.isWindows;
  final executable = options.cliPath ?? findCli(environment, windows: windows);
  rejectWindowsBatchCli(executable, windows: windows);
  final arguments = await buildCliArguments(options, windows: windows);
  final childEnvironment = <String, String>{
    for (final entry in environment.entries)
      if (entry.key != 'CLAUDECODE') entry.key: entry.value,
    'CLAUDE_CODE_ENTRYPOINT': 'sdk-dart',
    ...options.environment,
    'CLAUDE_AGENT_SDK_VERSION': packageVersion,
    if (options.enableFileCheckpointing)
      'CLAUDE_CODE_ENABLE_SDK_FILE_CHECKPOINTING': 'true',
    if (options.toolConfig?.questionPreviewFormat case final format?)
      'CLAUDE_CODE_QUESTION_PREVIEW_FORMAT': format.name,
    if (options.workingDirectory != null) 'PWD': options.workingDirectory!,
  };
  return CliLaunchPlan(
    executable: executable,
    arguments: arguments,
    environment: childEnvironment,
    workingDirectory: options.workingDirectory,
  );
}

/// Finds a Claude Code executable using [environment].
String findCli(Map<String, String> environment, {required bool windows}) {
  final pathValue = environment['PATH'] ?? '';
  final separator = windows ? ';' : ':';
  final names = windows
      ? const ['claude.exe', 'claude.com', 'claude.cmd', 'claude.bat']
      : const ['claude'];
  for (final directory in pathValue.split(separator)) {
    if (directory.isEmpty) continue;
    for (final name in names) {
      final candidate = p.join(directory, name);
      if (File(candidate).existsSync()) return candidate;
    }
  }
  final home = environment[windows ? 'USERPROFILE' : 'HOME'];
  if (home != null) {
    final candidates = windows
        ? [p.join(home, '.local', 'bin', 'claude.exe')]
        : [
            p.join(home, '.npm-global', 'bin', 'claude'),
            '/usr/local/bin/claude',
            p.join(home, '.local', 'bin', 'claude'),
            p.join(home, 'node_modules', '.bin', 'claude'),
            p.join(home, '.yarn', 'bin', 'claude'),
            p.join(home, '.claude', 'local', 'claude'),
          ];
    for (final candidate in candidates) {
      if (File(candidate).existsSync()) return candidate;
    }
  }
  throw CliNotFoundException(
    message: windows
        ? 'Claude Code CLI was not found. Install the native claude.exe or '
              'provide ClaudeAgentOptions(cliPath: ...)'
        : 'Claude Code CLI was not found. Install Claude Code or provide '
              'ClaudeAgentOptions(cliPath: ...)',
  );
}

/// Rejects `.cmd` and `.bat` launchers that can reinterpret arguments.
void rejectWindowsBatchCli(String executable, {required bool windows}) {
  if (!windows) return;
  final components = executable.replaceAll(r'\', '/').split('/');
  final isBatch = components.any(
    (component) => component.split(':').any((segment) {
      final normalized = segment
          .replaceFirst(RegExp(r'[. ]+$'), '')
          .toLowerCase();
      return normalized.endsWith('.cmd') || normalized.endsWith('.bat');
    }),
  );
  if (isBatch) {
    throw CliConnectionException(
      'Refusing to execute Windows batch script $executable because cmd.exe '
      'can reinterpret untrusted CLI arguments. Use a native claude.exe.',
    );
  }
}

/// Rejects values that are unsafe if interpreted by `cmd.exe`.
void validateWindowsCliValue(
  String option,
  String value, {
  required bool windows,
}) {
  if (windows && _unsafeWindowsValue.hasMatch(value)) {
    throw ArgumentError.value(
      value,
      option,
      'contains cmd.exe metacharacters or a newline',
    );
  }
}

/// Builds the Claude Code command-line argument vector.
Future<List<String>> buildCliArguments(
  ClaudeAgentOptions options, {
  required bool windows,
}) async {
  final arguments = <String>['--output-format', 'stream-json', '--verbose'];
  switch (options.systemPrompt) {
    case null:
      arguments.addAll(['--system-prompt', '']);
    case TextSystemPrompt(:final text):
      arguments.addAll(['--system-prompt', text]);
    case BlockSystemPrompt():
      // Block prompts travel in the initialize request so their cache
      // boundary remains structured.
      arguments.addAll(['--system-prompt', '']);
    case FileSystemPrompt(:final path):
      arguments.addAll(['--system-prompt-file', path]);
    case ClaudeCodeSystemPrompt(:final append):
      if (append != null) arguments.addAll(['--append-system-prompt', append]);
  }
  switch (options.tools) {
    case null:
      break;
    case ClaudeCodeTools():
      arguments.addAll(['--tools', 'default']);
    case ExplicitTools(:final tools):
      arguments.addAll(['--tools', tools.join(',')]);
  }

  final (allowedTools, settingSources) = effectiveSkillsOptions(options);
  if (allowedTools.isNotEmpty) {
    arguments.addAll(['--allowedTools', allowedTools.join(',')]);
  }
  if (options.maxTurns != null) {
    arguments.addAll(['--max-turns', '${options.maxTurns}']);
  }
  if (options.maxBudgetUsd != null) {
    arguments.addAll(['--max-budget-usd', '${options.maxBudgetUsd}']);
  }
  if (options.disallowedTools.isNotEmpty) {
    arguments.addAll(['--disallowedTools', options.disallowedTools.join(',')]);
  }
  if (options.taskBudget != null) {
    arguments.addAll(['--task-budget', '${options.taskBudget!.totalTokens}']);
  }
  if (options.model != null) arguments.addAll(['--model', options.model!]);
  if (options.agent != null) arguments.addAll(['--agent', options.agent!]);
  if (options.fallbackModel != null) {
    arguments.addAll(['--fallback-model', options.fallbackModel!]);
  }
  if (options.betas.isNotEmpty) {
    arguments.addAll([
      '--betas',
      options.betas.map((beta) => beta.wireValue).join(','),
    ]);
  }
  final permissionPromptTool = options.canUseTool == null
      ? options.permissionPromptToolName
      : 'stdio';
  if (permissionPromptTool != null) {
    arguments.addAll(['--permission-prompt-tool', permissionPromptTool]);
  }
  if (options.permissionMode != null) {
    arguments.addAll(['--permission-mode', options.permissionMode!.wireValue]);
  }
  if (options.allowDangerouslySkipPermissions) {
    arguments.add('--allow-dangerously-skip-permissions');
  }
  if (options.continueSession) arguments.add('--continue');
  if (options.resume != null) {
    validateWindowsCliValue('resume', options.resume!, windows: windows);
    arguments.add('--resume=${options.resume}');
  }
  if (options.resumeSessionAt != null) {
    validateWindowsCliValue(
      'resumeSessionAt',
      options.resumeSessionAt!,
      windows: windows,
    );
    arguments.add('--resume-session-at=${options.resumeSessionAt}');
  }
  if (options.sessionId != null) {
    validateWindowsCliValue('sessionId', options.sessionId!, windows: windows);
    arguments.add('--session-id=${options.sessionId}');
  }
  final settings = await buildSettingsValue(options);
  if (settings != null && settings.isNotEmpty) {
    arguments.addAll(['--settings', settings]);
  }
  if (options.managedSettings != null) {
    arguments.addAll([
      '--managed-settings',
      jsonEncode(options.managedSettings),
    ]);
  }
  for (final directory in options.addDirectories) {
    arguments.addAll(['--add-dir', directory]);
  }
  switch (options.mcp) {
    case null:
      break;
    case McpConfigSource(:final value):
      arguments.addAll(['--mcp-config', value]);
    case McpServers(:final servers):
      final processServers = servers.entries
          .where((entry) => entry.value is! SdkMcpServer)
          .toList(growable: false);
      if (processServers.isNotEmpty) {
        arguments.addAll([
          '--mcp-config',
          jsonEncode({
            'mcpServers': {
              for (final entry in processServers)
                entry.key: entry.value.toJson(),
            },
          }),
        ]);
      }
  }
  if (options.includePartialMessages) {
    arguments.add('--include-partial-messages');
  }
  if (options.includeHookEvents) arguments.add('--include-hook-events');
  if (options.strictMcpConfig) arguments.add('--strict-mcp-config');
  if (options.forkSession) arguments.add('--fork-session');
  if (!options.persistSession) arguments.add('--no-session-persistence');
  if (options.sessionStore != null) arguments.add('--session-mirror');
  if (settingSources != null) {
    arguments.add(
      '--setting-sources=${settingSources.map((source) => source.name).join(',')}',
    );
  }
  for (final plugin in options.plugins) {
    arguments.addAll([
      plugin.skipMcpDiscovery ? '--plugin-dir-no-mcp' : '--plugin-dir',
      plugin.path,
    ]);
  }
  if (options.debugFile != null) {
    arguments.addAll(['--debug-file', options.debugFile!]);
  } else if (options.debug) {
    arguments.add('--debug');
  }
  for (final entry in options.extraArguments.entries) {
    final flag = '--${entry.key}';
    final value = entry.value;
    if (value == null) {
      arguments.add(flag);
    } else if (value.startsWith('-')) {
      arguments.add('$flag=$value');
    } else {
      arguments.addAll([flag, value]);
    }
  }
  switch (options.thinking) {
    case null:
      break;
    case AdaptiveThinking(:final display):
      arguments.addAll(['--thinking', 'adaptive']);
      if (display != null) {
        arguments.addAll(['--thinking-display', display.name]);
      }
    case EnabledThinking(:final budget, :final display):
      arguments.addAll(['--max-thinking-tokens', '$budget']);
      if (display != null) {
        arguments.addAll(['--thinking-display', display.name]);
      }
    case DisabledThinking():
      arguments.addAll(['--thinking', 'disabled']);
  }
  if (options.effort != null) {
    arguments.addAll(['--effort', options.effort!.name]);
  }
  if (options.outputFormat != null) {
    arguments.addAll([
      '--json-schema',
      jsonEncode(options.outputFormat!.schema),
    ]);
  }
  arguments.addAll(['--input-format', 'stream-json']);
  return arguments;
}

/// Derives tool and setting-source flags from the skills configuration.
(List<String>, List<SettingSource>?) effectiveSkillsOptions(
  ClaudeAgentOptions options,
) {
  final allowed = [...options.allowedTools];
  var sources = options.settingSources == null
      ? null
      : [...options.settingSources!];
  switch (options.skills) {
    case null:
      break;
    case AllSkills():
      if (!allowed.contains('Skill')) allowed.add('Skill');
      sources ??= [SettingSource.user, SettingSource.project];
    case NamedSkills(:final names):
      for (final name in names) {
        final matcher = 'Skill($name)';
        if (!allowed.contains(matcher)) allowed.add(matcher);
      }
      sources ??= [SettingSource.user, SettingSource.project];
  }
  return (allowed, sources);
}

/// Merges explicit settings and SDK sandbox settings into one CLI value.
Future<String?> buildSettingsValue(ClaudeAgentOptions options) async {
  if (options.settings == null &&
      options.inlineSettings == null &&
      options.sandbox == null) {
    return null;
  }
  if (options.sandbox == null) {
    return options.inlineSettings == null
        ? options.settings
        : jsonEncode(options.inlineSettings);
  }
  var object = <String, Object?>{};
  if (options.inlineSettings != null) {
    object = <String, Object?>{...options.inlineSettings!};
  }
  final settings = options.settings?.trim();
  if (settings != null && settings.isNotEmpty) {
    try {
      if (settings.startsWith('{') && settings.endsWith('}')) {
        final decoded = jsonDecode(settings);
        if (decoded is Map<String, Object?>) object = {...decoded};
      } else {
        final file = File(settings);
        if (await file.exists()) {
          final decoded = jsonDecode(await file.readAsString());
          if (decoded is Map<String, Object?>) object = {...decoded};
        }
      }
    } on FormatException {
      final file = File(settings);
      if (await file.exists()) {
        final decoded = jsonDecode(await file.readAsString());
        if (decoded is Map<String, Object?>) object = {...decoded};
      }
    }
  }
  object['sandbox'] = options.sandbox!.toJson();
  return jsonEncode(object);
}
