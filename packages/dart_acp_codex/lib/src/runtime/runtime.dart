import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../agent/codex_agent.dart';
import '../app_server/backend.dart';
import '../app_server/json_rpc_backend.dart';
import 'diagnostics.dart';
import 'options.dart';

/// Owns one local app-server process and its ACP agent.
final class CodexRuntime {
  CodexRuntime._({
    required this.options,
    required CodexBackend backend,
    required _OwnedProcess? process,
  }) : _backend = backend,
       _process = process;

  /// Starts a local app server.
  static Future<CodexRuntime> start({
    CodexAdapterOptions? options,
    CodexBackend? backend,
  }) async {
    final resolved = options ?? CodexAdapterOptions();
    if (backend != null) {
      return CodexRuntime._(options: resolved, backend: backend, process: null);
    }
    final owned = await _OwnedProcess.start(resolved);
    final transport = ndJsonStream(
      input: owned.process.stdout,
      output: AcpWritable<List<int>>(
        write: owned.writeInput,
        close: owned.closeInput,
      ),
      options: const NdJsonStreamOptions(closeOutput: true),
    );
    late final CodexJsonRpcBackend processBackend;
    processBackend = CodexJsonRpcBackend.connect(
      transport,
      onClose: () => owned.close(resolved.shutdownTimeout),
    );
    return CodexRuntime._(
      options: resolved,
      backend: processBackend,
      process: owned,
    );
  }

  /// Runtime options.
  final CodexAdapterOptions options;
  final CodexBackend _backend;
  final _OwnedProcess? _process;
  Future<void>? _closeFuture;

  /// Child exit code. Injected backends resolve to zero on close.
  Future<int> get exitCode => _process?.exitCode ?? Future<int>.value(0);

  /// Creates the typed ACP application.
  CodexAgent createAgent() => CodexAgent(backend: _backend, options: options);

  /// Serves the ACP agent over process stdio until the connection closes.
  Future<void> serveStdio() async {
    final connection = createAgent().app.connect(AcpStdioTransport.connect());
    await connection.closed;
  }

  /// Closes the backend and child process idempotently.
  Future<void> close() => _closeFuture ??= _doClose();

  Future<void> _doClose() async {
    await _process?.close(options.shutdownTimeout);
    await _backend.close();
  }
}

final class _OwnedProcess {
  _OwnedProcess(this.process, this._stderrSubscription);

  static Future<_OwnedProcess> start(CodexAdapterOptions options) async {
    final executable = options.executable ?? 'codex';
    final Process process;
    try {
      process = await Process.start(
        executable,
        const <String>['app-server'],
        environment: options.environment,
        runInShell: Platform.isWindows,
      );
    } on Object catch (_) {
      throw const CodexProcessException(
        'Unable to start the configured local process.',
      );
    }
    var stderrTail = '';
    // Stored on the returned owner and cancelled during shutdown.
    // ignore: cancel_subscriptions
    final subscription = process.stderr.transform(utf8.decoder).listen((chunk) {
      stderrTail = (stderrTail + chunk);
      if (stderrTail.length > options.maximumStderrTailCharacters) {
        stderrTail = stderrTail.substring(
          stderrTail.length - options.maximumStderrTailCharacters,
        );
      }
    });
    unawaited(
      process.exitCode.then((code) {
        if (code != 0) {
          options.onDiagnostic?.call(
            CodexDiagnostic(
              level: CodexDiagnosticLevel.error,
              category: CodexDiagnosticCategory.process,
              message: stderrTail.trim().isEmpty
                  ? 'Local process exited unexpectedly.'
                  : 'Local process exited unexpectedly; stderr was captured.',
              exitCode: code,
            ),
          );
        }
      }),
    );
    return _OwnedProcess(process, subscription);
  }

  final Process process;
  final StreamSubscription<String> _stderrSubscription;
  Future<void> _inputTail = Future<void>.value();
  Future<void>? _inputCloseFuture;
  Future<void>? _closeFuture;

  Future<int> get exitCode => process.exitCode;

  Future<void> writeInput(List<int> bytes) {
    if (_inputCloseFuture != null) {
      throw StateError('The local process input is closing.');
    }
    final operation = _inputTail.then((_) async {
      process.stdin.add(bytes);
      await process.stdin.flush();
    });
    _inputTail = operation.onError((_, _) {});
    return operation;
  }

  Future<void> closeInput() =>
      _inputCloseFuture ??= _inputTail.then((_) => process.stdin.close());

  Future<void> close(Duration timeout) => _closeFuture ??= _doClose(timeout);

  Future<void> _doClose(Duration timeout) async {
    await closeInput();
    try {
      await process.exitCode.timeout(timeout);
    } on TimeoutException {
      process.kill();
      await process.exitCode;
    } finally {
      await _stderrSubscription.cancel();
    }
  }
}
