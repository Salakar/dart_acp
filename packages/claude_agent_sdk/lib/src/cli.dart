import 'dart:io';

import 'options.dart';
import 'transport/cli_command.dart';

/// Resolves the Claude Code executable used for [options].
String resolveClaudeCli(
  ClaudeAgentOptions options, {
  Map<String, String>? parentEnvironment,
  bool? isWindows,
}) {
  final environment = parentEnvironment ?? Platform.environment;
  final windows = isWindows ?? Platform.isWindows;
  return options.cliPath ?? findCli(environment, windows: windows);
}

/// Runs the native Claude CLI with inherited standard streams.
Future<int> runClaudeCli(
  List<String> arguments, {
  ClaudeAgentOptions? options,
  Map<String, String>? parentEnvironment,
  ProcessStartMode mode = ProcessStartMode.inheritStdio,
}) async {
  final resolved = options ?? ClaudeAgentOptions();
  final plan = await createCliLaunchPlan(
    resolved,
    parentEnvironment: parentEnvironment,
  );
  final process = await Process.start(
    plan.executable,
    arguments,
    workingDirectory: plan.workingDirectory,
    environment: plan.environment,
    runInShell: Platform.isWindows,
    mode: mode,
  );
  return process.exitCode;
}

/// Clears credentials stored by the native Claude CLI.
Future<int> logoutClaude({
  ClaudeAgentOptions? options,
  Map<String, String>? parentEnvironment,
}) => runClaudeCli(
  const <String>['auth', 'logout'],
  options: options,
  parentEnvironment: parentEnvironment,
);
