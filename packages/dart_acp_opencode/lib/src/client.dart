import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import 'executable.dart';

/// Version reported by the default OpenCode client application.
const String dartAcpOpenCodeVersion = '0.1.0';

/// Receives one decoded chunk from the OpenCode process's stderr stream.
typedef OpenCodeAcpStderrHandler = void Function(String chunk);

/// Configuration for [OpenCodeAcpClient.start].
final class OpenCodeAcpClientOptions {
  /// Creates validated process and lifecycle options.
  OpenCodeAcpClientOptions({
    this.executable,
    this.workingDirectory,
    Map<String, String>? environment,
    this.includeParentEnvironment = true,
    this.initializationTimeout = const Duration(seconds: 15),
    this.shutdownTimeout = const Duration(seconds: 2),
    this.maximumStderrTailCharacters = 8192,
    this.onStderr,
  }) : environment = environment == null
           ? null
           : UnmodifiableMapView<String, String>(
               Map<String, String>.of(environment),
             ) {
    if (executable case final String value when value.trim().isEmpty) {
      throw ArgumentError.value(executable, 'executable', 'must not be empty');
    }
    if (workingDirectory case final String value when value.trim().isEmpty) {
      throw ArgumentError.value(
        workingDirectory,
        'workingDirectory',
        'must not be empty',
      );
    }
    if (initializationTimeout <= Duration.zero) {
      throw ArgumentError.value(
        initializationTimeout,
        'initializationTimeout',
        'must be positive',
      );
    }
    if (shutdownTimeout <= Duration.zero) {
      throw ArgumentError.value(
        shutdownTimeout,
        'shutdownTimeout',
        'must be positive',
      );
    }
    if (maximumStderrTailCharacters < 0) {
      throw ArgumentError.value(
        maximumStderrTailCharacters,
        'maximumStderrTailCharacters',
        'must not be negative',
      );
    }
  }

  /// Explicit executable path or command.
  ///
  /// When omitted, [findOpenCodeExecutable] is used.
  final String? executable;

  /// Working directory inherited by OpenCode and used as its default project.
  final String? workingDirectory;

  /// Environment entries supplied to the child process.
  final Map<String, String>? environment;

  /// Whether the child and executable finder inherit the parent environment.
  final bool includeParentEnvironment;

  /// Maximum time allowed for the ACP initialization handshake.
  final Duration initializationTimeout;

  /// Grace period before a closing child process is terminated.
  final Duration shutdownTimeout;

  /// Maximum number of recent stderr characters retained for failures.
  final int maximumStderrTailCharacters;

  /// Optional observer for process stderr.
  final OpenCodeAcpStderrHandler? onStderr;
}

/// A failure to launch or initialize an OpenCode ACP process.
final class OpenCodeAcpClientException implements Exception {
  /// Creates a process client error.
  OpenCodeAcpClientException({
    required this.message,
    required this.executable,
    required List<String> arguments,
    this.stderrTail = '',
    this.cause,
  }) : arguments = List<String>.unmodifiable(arguments);

  /// Concise failure description.
  final String message;

  /// Executable used for the failed launch.
  final String executable;

  /// Argument vector used for the failed launch.
  final List<String> arguments;

  /// Bounded recent stderr, when available.
  final String stderrTail;

  /// Underlying failure, when available.
  final Object? cause;

  @override
  String toString() {
    final String stderr = stderrTail.trim();
    return 'OpenCodeAcpClientException: $message'
        '${cause == null ? '' : '\nCause: $cause'}'
        '${stderr.isEmpty ? '' : '\nOpenCode stderr:\n$stderr'}';
  }
}

/// Owns an OpenCode ACP subprocess and its initialized Dart client connection.
final class OpenCodeAcpClient {
  OpenCodeAcpClient._({
    required this.executable,
    required this.arguments,
    required this.connection,
    required Process process,
    required AcpDuplexStream<Object?> transport,
    required _StderrCapture stderrCapture,
    required OpenCodeAcpClientOptions options,
  }) : _process = process,
       _transport = transport,
       _options = options,
       _stderrCapture = stderrCapture;

  /// Starts `opencode acp`, connects [app], and waits for initialization.
  ///
  /// If [app] is omitted, a minimal client that advertises no file-system or
  /// terminal proxy capabilities is created. Pass a configured [AcpClientApp]
  /// to handle permissions, file-system requests, terminal requests, or
  /// elicitations.
  static Future<OpenCodeAcpClient> start({
    AcpClientApp? app,
    OpenCodeAcpClientOptions? options,
  }) async {
    final OpenCodeAcpClientOptions resolved =
        options ?? OpenCodeAcpClientOptions();
    final Map<String, String> finderEnvironment = <String, String>{
      if (resolved.includeParentEnvironment) ...Platform.environment,
      ...?resolved.environment,
    };
    final String executable =
        resolved.executable ??
        findOpenCodeExecutable(environment: finderEnvironment);
    const List<String> arguments = <String>['acp'];
    final Process process;
    try {
      process = await Process.start(
        executable,
        arguments,
        workingDirectory: resolved.workingDirectory,
        environment: resolved.environment,
        includeParentEnvironment: resolved.includeParentEnvironment,
        runInShell: Platform.isWindows,
      );
    } on Object catch (error) {
      throw OpenCodeAcpClientException(
        message: 'Unable to start the OpenCode ACP process.',
        executable: executable,
        arguments: arguments,
        cause: error,
      );
    }

    final _StderrCapture stderrCapture = _StderrCapture(
      input: process.stderr,
      maximumCharacters: resolved.maximumStderrTailCharacters,
      onStderr: resolved.onStderr,
    );
    final AcpDuplexStream<Object?> transport = ndJsonStream(
      input: process.stdout,
      output: AcpWritable<List<int>>(
        write: (List<int> bytes) async {
          process.stdin.add(bytes);
          await process.stdin.flush();
        },
        close: process.stdin.close,
      ),
      options: const NdJsonStreamOptions(closeOutput: true),
    );
    final AcpClientConnection connection;
    try {
      connection = (app ?? _defaultClientApp()).connect(transport);
    } on Object catch (error) {
      await _disposeUnconnectedProcess(
        process: process,
        transport: transport,
        stderrCapture: stderrCapture,
        shutdownTimeout: resolved.shutdownTimeout,
      );
      throw OpenCodeAcpClientException(
        message: 'Unable to connect the Dart ACP client to OpenCode.',
        executable: executable,
        arguments: arguments,
        stderrTail: stderrCapture.value,
        cause: error,
      );
    }
    final OpenCodeAcpClient client = OpenCodeAcpClient._(
      executable: executable,
      arguments: arguments,
      connection: connection,
      process: process,
      transport: transport,
      stderrCapture: stderrCapture,
      options: resolved,
    );

    try {
      await connection.lifecycle.ready.timeout(resolved.initializationTimeout);
    } on Object catch (error) {
      await client.close();
      throw OpenCodeAcpClientException(
        message: 'OpenCode did not complete the ACP initialization handshake.',
        executable: executable,
        arguments: arguments,
        stderrTail: client.stderrTail,
        cause: error,
      );
    }
    return client;
  }

  /// Resolved executable used by this client.
  final String executable;

  /// Exact immutable argument vector used by this client.
  final List<String> arguments;

  /// Initialized typed ACP client connection.
  final AcpClientConnection connection;

  final Process _process;
  final AcpDuplexStream<Object?> _transport;
  final OpenCodeAcpClientOptions _options;
  final _StderrCapture _stderrCapture;
  Future<void>? _closeFuture;

  /// Context for creating sessions and calling OpenCode ACP methods.
  AcpClientContext get agent => connection.agent;

  /// Child process identifier.
  int get processId => _process.pid;

  /// Completes with the OpenCode process exit code.
  Future<int> get exitCode => _process.exitCode;

  /// Completes after both the ACP connection and child process close.
  Future<void> get closed async {
    await connection.closed;
    await _process.exitCode;
  }

  /// Bounded recent stderr captured from OpenCode.
  String get stderrTail => _stderrCapture.value;

  /// Closes the ACP connection and process idempotently.
  Future<void> close() => _closeFuture ??= _close();

  Future<void> _close() async {
    connection.close();
    try {
      await _transport.writable.close();
    } on Object {
      // The child may already have closed stdin.
    }
    try {
      await _process.exitCode.timeout(_options.shutdownTimeout);
    } on TimeoutException {
      _process.kill();
      await _process.exitCode;
    } finally {
      await _stderrCapture.close();
    }
  }
}

AcpClientApp _defaultClientApp() =>
    AcpClientApp.v1(
      implementation: Implementation(
        name: 'dart_acp_opencode',
        title: 'Dart ACP OpenCode',
        version: dartAcpOpenCodeVersion,
      ),
      capabilities: ClientCapabilities(
        fs: FileSystemCapabilities(readTextFile: false, writeTextFile: false),
        terminal: false,
      ),
    ).onRequestPermission(
      (_) => RequestPermissionResponse(
        outcome: const RequestPermissionOutcomeCancelled(),
      ),
    );

final class _StderrCapture {
  _StderrCapture({
    required Stream<List<int>> input,
    required this.maximumCharacters,
    required OpenCodeAcpStderrHandler? onStderr,
  }) : _onStderr = onStderr {
    _subscription = input
        .transform(const Utf8Decoder(allowMalformed: true))
        .listen(
          _observe,
          onError: (Object error, StackTrace _) {
            _observe('Unable to read OpenCode stderr: $error\n');
          },
        );
  }

  final int maximumCharacters;
  final OpenCodeAcpStderrHandler? _onStderr;
  late final StreamSubscription<String> _subscription;
  String value = '';

  void _observe(String chunk) {
    if (maximumCharacters > 0) {
      value += chunk;
      if (value.length > maximumCharacters) {
        value = value.substring(value.length - maximumCharacters);
      }
    }
    try {
      _onStderr?.call(chunk);
    } on Object {
      // Observational callbacks cannot alter process lifecycle.
    }
  }

  Future<void> close() => _subscription.cancel();
}

Future<void> _disposeUnconnectedProcess({
  required Process process,
  required AcpDuplexStream<Object?> transport,
  required _StderrCapture stderrCapture,
  required Duration shutdownTimeout,
}) async {
  try {
    await transport.writable.close();
  } on Object {
    // The child may already have closed stdin.
  }
  try {
    await process.exitCode.timeout(shutdownTimeout);
  } on TimeoutException {
    process.kill();
    await process.exitCode;
  } finally {
    await stderrCapture.close();
  }
}
