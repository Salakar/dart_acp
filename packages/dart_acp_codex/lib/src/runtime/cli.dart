import 'dart:async';
import 'dart:io';

import 'diagnostics.dart';
import 'options.dart';
import 'runtime.dart';

/// Package version printed by the executable.
const String dartAcpCodexVersion = '0.1.0';

/// Runs a child command for the `login` and `cli` executable modes.
typedef CodexCliProcessRunner =
    Future<int> Function(
      String executable,
      List<String> arguments,
      Map<String, String> environment,
    );

/// Starts an adapter runtime for the default stdio mode.
typedef CodexRuntimeStarter =
    Future<CodexRuntime> Function(CodexAdapterOptions options);

/// Runs the default stdio mode without requiring a concrete runtime.
typedef CodexStdioRunner = Future<int> Function(CodexAdapterOptions options);

/// Runs the `dart_acp_codex` command and returns a process exit code.
///
/// Injected callbacks make every argument and environment branch testable
/// without launching a local executable.
Future<int> runCodexAdapter(
  List<String> arguments, {
  Map<String, String>? environment,
  CodexCliProcessRunner? processRunner,
  CodexRuntimeStarter? runtimeStarter,
  CodexStdioRunner? stdioRunner,
  void Function(String line)? writeOutput,
  void Function(String line)? writeError,
  Iterable<Stream<ProcessSignal>>? shutdownSignals,
}) async {
  final env = Map<String, String>.unmodifiable(
    environment ?? Platform.environment,
  );
  final void Function(String) output =
      writeOutput ?? (String line) => stdout.writeln(line);
  final void Function(String) errorOutput =
      writeError ?? (String line) => stderr.writeln(line);
  if (arguments case ['--version'] || ['-v']) {
    output(dartAcpCodexVersion);
    return 0;
  }
  if (arguments case ['--help'] || ['-h']) {
    output(_usage);
    return 0;
  }
  if (arguments case ['login', ...final rest]) {
    return (processRunner ?? _runChild)(
      env['CODEX_EXECUTABLE'] ?? 'codex',
      <String>['login', ...rest],
      env,
    );
  }
  if (arguments case ['cli', ...final rest]) {
    return (processRunner ?? _runChild)(
      env['CODEX_EXECUTABLE'] ?? 'codex',
      rest,
      env,
    );
  }
  if (arguments.isNotEmpty) {
    errorOutput('Unknown argument: ${arguments.first}\n\n$_usage');
    return 64;
  }

  final CodexAdapterOptions options;
  try {
    options = _optionsFromEnvironment(env);
  } on CodexConfigurationException catch (error) {
    errorOutput(error.message);
    return 64;
  }
  if (stdioRunner != null) {
    return stdioRunner(options);
  }

  CodexRuntime? runtime;
  final subscriptions = <StreamSubscription<ProcessSignal>>[];
  try {
    runtime = await (runtimeStarter ?? _startRuntime)(options);
    for (final signal in shutdownSignals ?? _defaultShutdownSignals()) {
      subscriptions.add(
        signal.listen((_) {
          unawaited(runtime?.close());
        }),
      );
    }
    await runtime.serveStdio();
    return await runtime.exitCode;
  } on CodexProcessException catch (error) {
    errorOutput(error.message);
    return 69;
  } finally {
    for (final subscription in subscriptions) {
      await subscription.cancel();
    }
    await runtime?.close();
  }
}

CodexAdapterOptions _optionsFromEnvironment(Map<String, String> environment) {
  final timeoutMs = _positiveInt(
    environment,
    'CODEX_ACP_SHUTDOWN_TIMEOUT_MS',
    2000,
  );
  final stderrCharacters = _positiveInt(
    environment,
    'CODEX_ACP_MAX_STDERR_CHARS',
    2048,
  );
  final executable = environment['CODEX_EXECUTABLE']?.trim();
  final provider = environment['CODEX_ACP_MODEL_PROVIDER']?.trim();
  return CodexAdapterOptions(
    executable: executable == null || executable.isEmpty ? null : executable,
    modelProvider: provider == null || provider.isEmpty ? null : provider,
    environment: environment,
    shutdownTimeout: Duration(milliseconds: timeoutMs),
    maximumStderrTailCharacters: stderrCharacters,
  );
}

int _positiveInt(Map<String, String> environment, String name, int fallback) {
  final raw = environment[name];
  if (raw == null) {
    return fallback;
  }
  final value = int.tryParse(raw);
  if (value == null || value <= 0) {
    throw CodexConfigurationException('$name must be a positive integer.');
  }
  return value;
}

Future<CodexRuntime> _startRuntime(CodexAdapterOptions options) =>
    CodexRuntime.start(options: options);

Future<int> _runChild(
  String executable,
  List<String> arguments,
  Map<String, String> environment,
) async {
  final Process process;
  try {
    process = await Process.start(
      executable,
      arguments,
      environment: environment,
      runInShell: Platform.isWindows,
    );
  } on Object {
    return 69;
  }
  final stdoutDone = stdout.addStream(process.stdout);
  final stderrDone = stderr.addStream(process.stderr);
  final code = await process.exitCode;
  await Future.wait<void>(<Future<void>>[stdoutDone, stderrDone]);
  return code;
}

Iterable<Stream<ProcessSignal>> _defaultShutdownSignals() sync* {
  yield ProcessSignal.sigint.watch();
  if (!Platform.isWindows) {
    yield ProcessSignal.sigterm.watch();
  }
}

const String _usage = '''
Usage: dart_acp_codex [--version|--help|login [args...]|cli [args...]]

With no arguments, serves the Codex ACP agent over stdio.
''';
