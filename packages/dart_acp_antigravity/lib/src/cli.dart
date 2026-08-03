import 'dart:async';
import 'dart:io';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import 'agent.dart';
import 'options.dart';

/// Serves a configured agent until its connection closes, returning an exit
/// code.
typedef AntigravityStdioRunner =
    Future<int> Function(AntigravityAcpOptions options);

/// Thrown when executable environment configuration is invalid.
final class AntigravityConfigurationException implements Exception {
  /// Creates a configuration error.
  const AntigravityConfigurationException(this.message);

  /// Actionable error description.
  final String message;

  @override
  String toString() => 'AntigravityConfigurationException: $message';
}

/// Runs the `dart_acp_antigravity` command and returns a process exit code.
///
/// With no arguments, the Antigravity adapter serves ACP NDJSON over stdio
/// until the peer disconnects. Diagnostics never touch the protocol stream.
/// Injected callbacks make argument and environment branches testable without
/// serving stdio.
Future<int> runAntigravityAdapter(
  List<String> arguments, {
  Map<String, String>? environment,
  AntigravityStdioRunner? stdioRunner,
  void Function(String line)? writeOutput,
  void Function(String line)? writeError,
}) async {
  final Map<String, String> env = Map<String, String>.unmodifiable(
    environment ?? Platform.environment,
  );
  final void Function(String) output =
      writeOutput ?? (String line) => stdout.writeln(line);
  final void Function(String) errorOutput =
      writeError ?? (String line) => stderr.writeln(line);
  if (arguments case ['--version'] || ['-v']) {
    output(dartAcpAntigravityVersion);
    return 0;
  }
  if (arguments case ['--help'] || ['-h']) {
    output(_usage);
    return 0;
  }
  if (arguments.isNotEmpty) {
    errorOutput('Unknown argument: ${arguments.first}\n\n$_usage');
    return 64;
  }

  final AntigravityAcpOptions options;
  try {
    options = antigravityOptionsFromEnvironment(env);
  } on AntigravityConfigurationException catch (error) {
    errorOutput(error.message);
    return 64;
  }
  return (stdioRunner ?? _serveStdio)(options);
}

/// Builds adapter options from executable environment variables.
AntigravityAcpOptions antigravityOptionsFromEnvironment(
  Map<String, String> environment,
) {
  final String? executable = _trimmed(environment['ANTIGRAVITY_EXECUTABLE']);
  final String? model = _trimmed(environment['ANTIGRAVITY_ACP_MODEL']);
  final String? agentName = _trimmed(environment['ANTIGRAVITY_ACP_AGENT']);
  final String? effortName = _trimmed(environment['ANTIGRAVITY_ACP_EFFORT']);
  final AntigravityReasoningEffort? effort = switch (effortName) {
    null => null,
    'low' => AntigravityReasoningEffort.low,
    'medium' => AntigravityReasoningEffort.medium,
    'high' => AntigravityReasoningEffort.high,
    _ => throw const AntigravityConfigurationException(
      'ANTIGRAVITY_ACP_EFFORT must be low, medium, or high.',
    ),
  };
  final String? policyName = _trimmed(
    environment['ANTIGRAVITY_ACP_PERMISSION_POLICY'],
  );
  final AntigravityPermissionPolicy policy = switch (policyName) {
    null || 'request-review' => AntigravityPermissionPolicy.requestReview,
    'accept-edits' => AntigravityPermissionPolicy.acceptEdits,
    'plan' => AntigravityPermissionPolicy.plan,
    'bypass-permissions' => AntigravityPermissionPolicy.bypassPermissions,
    _ => throw const AntigravityConfigurationException(
      'ANTIGRAVITY_ACP_PERMISSION_POLICY must be request-review, '
      'accept-edits, plan, or bypass-permissions.',
    ),
  };
  final int? promptTimeoutMs = _positiveInt(
    environment,
    'ANTIGRAVITY_ACP_PROMPT_TIMEOUT_MS',
  );
  final int shutdownTimeoutMs =
      _positiveInt(environment, 'ANTIGRAVITY_ACP_SHUTDOWN_TIMEOUT_MS') ?? 2000;
  final int stderrCharacters =
      _positiveInt(environment, 'ANTIGRAVITY_ACP_MAX_STDERR_CHARS') ?? 8192;
  return AntigravityAcpOptions(
    executable: executable,
    environment: environment,
    model: model,
    agentName: agentName,
    effort: effort,
    permissionPolicy: policy,
    promptTimeout: promptTimeoutMs == null
        ? null
        : Duration(milliseconds: promptTimeoutMs),
    shutdownTimeout: Duration(milliseconds: shutdownTimeoutMs),
    maximumStderrTailCharacters: stderrCharacters,
  );
}

Future<int> _serveStdio(AntigravityAcpOptions options) async {
  final AntigravityAcpAgent agent = AntigravityAcpAgent(options: options);
  try {
    final AcpAgentConnection connection = agent.app.connect(
      AcpStdioTransport.connect(),
    );
    await connection.closed;
    return 0;
  } finally {
    await agent.dispose();
  }
}

String? _trimmed(String? value) {
  final String? trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

int? _positiveInt(Map<String, String> environment, String name) {
  final String? raw = _trimmed(environment[name]);
  if (raw == null) {
    return null;
  }
  final int? value = int.tryParse(raw);
  if (value == null || value <= 0) {
    throw AntigravityConfigurationException(
      '$name must be a positive integer.',
    );
  }
  return value;
}

const String _usage = '''
Usage: dart run dart_acp_antigravity [--version | --help]

With no arguments, serves the Antigravity ACP agent over stdio.

Environment variables:
  ANTIGRAVITY_EXECUTABLE                Executable path; defaults to agy
  ANTIGRAVITY_ACP_MODEL                 Model forwarded with --model
  ANTIGRAVITY_ACP_AGENT                 Agent forwarded with --agent
  ANTIGRAVITY_ACP_EFFORT                low, medium, or high
  ANTIGRAVITY_ACP_PERMISSION_POLICY     request-review, accept-edits, plan,
                                        or bypass-permissions
  ANTIGRAVITY_ACP_PROMPT_TIMEOUT_MS     Positive --print-timeout override
  ANTIGRAVITY_ACP_SHUTDOWN_TIMEOUT_MS   Positive termination grace period
  ANTIGRAVITY_ACP_MAX_STDERR_CHARS      Positive retained stderr tail''';
