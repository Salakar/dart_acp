import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;

import '../application/runtime.dart';
import '../configuration/agent_options.dart';
import 'contracts.dart';

/// Package version printed by the executable.
const String dartAcpClaudeVersion = '0.1.2';

/// Runs a delegated native Claude command.
typedef ClaudeCliProcessRunner =
    Future<int> Function(
      List<String> arguments,
      claude.ClaudeAgentOptions options,
      Map<String, String> environment,
    );

/// Serves the adapter over stdio.
typedef ClaudeAcpStdioRunner =
    Future<int> Function(
      ClaudeAcpOptions options,
      ClaudeAcpEnvironment environment,
    );

/// Resolves managed policy before the ACP server starts.
typedef ClaudeManagedSettingsResolver =
    Future<claude.ClaudeResolvedSettings> Function(
      Map<String, String> environment,
    );

/// Runs the `dart_acp_claude` command and returns an exit code.
Future<int> runDartAcpClaude(
  List<String> arguments, {
  Map<String, String>? environment,
  ClaudeCliProcessRunner? processRunner,
  ClaudeAcpStdioRunner? stdioRunner,
  ClaudeManagedSettingsResolver? settingsResolver,
  void Function(String line)? writeOutput,
  void Function(String line)? writeError,
}) async {
  final variables = Map<String, String>.unmodifiable(
    environment ?? Platform.environment,
  );
  final void Function(String) output =
      writeOutput ?? (String line) => stdout.writeln(line);
  final void Function(String) errorOutput =
      writeError ?? (String line) => stderr.writeln(line);
  if (arguments case ['--version'] || ['-v']) {
    output(dartAcpClaudeVersion);
    return 0;
  }
  if (arguments case ['--help'] || ['-h']) {
    output(_usage);
    return 0;
  }
  if (arguments case ['--cli', ...final rest] || ['cli', ...final rest]) {
    final sdkOptions = claude.ClaudeAgentOptions(
      cliPath: variables['CLAUDE_CODE_EXECUTABLE'],
      environment: variables,
    );
    return (processRunner ?? _runCli)(rest, sdkOptions, variables);
  }
  if (arguments.isNotEmpty) {
    errorOutput('Unknown argument: ${arguments.first}\n\n$_usage');
    return 64;
  }
  late final Map<String, String> serviceVariables;
  try {
    final managed = await (settingsResolver ?? _resolveManaged)(variables);
    serviceVariables = Map<String, String>.unmodifiable(<String, String>{
      ...variables,
      ...managed.environment,
    });
  } on Object catch (error) {
    errorOutput('Could not resolve managed Claude settings: $error');
    return 78;
  }
  final options = ClaudeAcpOptions(
    cliPath: serviceVariables['CLAUDE_CODE_EXECUTABLE'],
    environment: serviceVariables,
  );
  final effectiveEnvironment = ClaudeAcpEnvironment(
    variables: serviceVariables,
  );
  return (stdioRunner ?? _serve)(options, effectiveEnvironment);
}

Future<claude.ClaudeResolvedSettings> _resolveManaged(
  Map<String, String> environment,
) async {
  final resolved = await claude.resolveSettings(
    settingSources: const <claude.SettingSource>[],
    environment: environment,
  );
  return claude.ClaudeResolvedSettings(
    claude.filterEscalatingDefaultMode(resolved),
    provenance: resolved.provenance,
    sources: resolved.sources,
  );
}

Future<int> _runCli(
  List<String> arguments,
  claude.ClaudeAgentOptions options,
  Map<String, String> environment,
) => claude.runClaudeCli(
  arguments,
  options: options,
  parentEnvironment: environment,
);

Future<int> _serve(
  ClaudeAcpOptions options,
  ClaudeAcpEnvironment environment,
) async {
  final result = runClaudeAcpStdio(options: options, environment: environment);
  try {
    await result.connection.closed;
    return 0;
  } on Object catch (error, stackTrace) {
    stderr
      ..writeln('ACP connection failed: $error')
      ..writeln(stackTrace);
    return 70;
  } finally {
    await result.agent.dispose();
  }
}

const String _usage = '''
Usage: dart_acp_claude [--version|--help|--cli [args...]]

With no arguments, serves the Claude ACP agent over stdio.
''';
