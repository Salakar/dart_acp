import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../errors.dart';
import '../json.dart';
import '../options.dart';
import 'cli_command.dart';
import 'ndjson_decoder.dart';
import 'transport.dart';

/// A [Transport] backed by a local Claude Code subprocess.
final class SubprocessCliTransport implements Transport {
  /// Creates a subprocess transport configured by [options].
  SubprocessCliTransport(this.options);

  /// Options used to locate and launch the CLI.
  final ClaudeAgentOptions options;
  Process? _process;
  Stream<JsonMap>? _messages;
  StreamSubscription<String>? _stderrSubscription;
  Future<void> _writeTail = Future<void>.value();
  bool _isReady = false;
  bool _isClosed = false;

  @override
  bool get isReady => _isReady;

  @override
  Stream<JsonMap> get messages {
    final value = _messages;
    if (value == null) {
      throw const CliConnectionException('Transport is not connected');
    }
    return value;
  }

  @override
  Future<void> connect() async {
    if (_process != null) return;
    if (options.user != null) {
      throw UnsupportedError(
        'Dart Process.start cannot change the operating-system user; '
        'launch the parent process as the desired user instead.',
      );
    }
    late CliLaunchPlan plan;
    try {
      plan = await createCliLaunchPlan(options);
      await _checkVersion(plan.executable);
      final process = await Process.start(
        plan.executable,
        plan.arguments,
        workingDirectory: plan.workingDirectory,
        environment: plan.environment,
        includeParentEnvironment: false,
        runInShell: false,
      );
      _process = process;
      final decoded = process.stdout.transform(
        NdjsonDecoder(maxBufferSize: options.maxBufferSize ?? 1024 * 1024),
      );
      _messages = _messagesWithExit(decoded, process);
      if (options.stderr != null) {
        _stderrSubscription = process.stderr
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(_emitStderr);
      } else {
        unawaited(process.stderr.drain<void>());
      }
      _isReady = true;
    } on ClaudeAgentException {
      rethrow;
    } on ProcessException catch (error) {
      if (options.workingDirectory != null &&
          !Directory(options.workingDirectory!).existsSync()) {
        throw CliConnectionException(
          'Working directory does not exist: ${options.workingDirectory}',
        );
      }
      throw CliConnectionException(
        'Failed to start Claude Code CLI: ${error.message}',
      );
    } catch (error) {
      throw CliConnectionException('Failed to start Claude Code CLI: $error');
    }
  }

  Stream<JsonMap> _messagesWithExit(
    Stream<JsonMap> decoded,
    Process process,
  ) async* {
    await for (final message in decoded) {
      yield message;
    }
    final code = await process.exitCode;
    if (code != 0 && !_isClosed) {
      throw CliProcessException(
        'Claude Code CLI exited unsuccessfully',
        exitCode: code,
        stderr: 'Use ClaudeAgentOptions(stderr: ...) for process diagnostics',
      );
    }
  }

  void _emitStderr(String line) {
    if (line.trim().isEmpty) return;
    try {
      options.stderr?.call(line.trimRight());
    } catch (_) {
      // A diagnostic callback must never stop delivery of later lines.
    }
  }

  Future<void> _checkVersion(String executable) async {
    if (Platform.environment['CLAUDE_AGENT_SDK_SKIP_VERSION_CHECK'] != null) {
      return;
    }
    try {
      final result = await Process.run(executable, const [
        '-v',
      ], runInShell: false).timeout(const Duration(seconds: 2));
      final match = RegExp(
        r'^(\d+)\.(\d+)\.(\d+)',
      ).firstMatch('${result.stdout}'.trim());
      if (match == null) return;
      final current = [
        int.parse(match.group(1)!),
        int.parse(match.group(2)!),
        int.parse(match.group(3)!),
      ];
      const minimum = [2, 0, 0];
      for (var index = 0; index < 3; index++) {
        if (current[index] > minimum[index]) break;
        if (current[index] < minimum[index]) {
          _emitStderr(
            'Claude Code ${current.join('.')} is unsupported; '
            'minimum version is $minimumCliVersion.',
          );
          break;
        }
      }
    } on Object {
      // Version probing is advisory.
    }
  }

  @override
  Future<void> write(String data) {
    final completer = Completer<void>();
    _writeTail = _writeTail
        .catchError((Object _) {})
        .then((_) async {
          if (!_isReady || _process == null) {
            throw const CliConnectionException(
              'Process transport is not ready for writing',
            );
          }
          try {
            _process!.stdin.write(data);
            await _process!.stdin.flush();
          } catch (error) {
            _isReady = false;
            throw CliConnectionException(
              'Failed to write to CLI stdin: $error',
            );
          }
        })
        .then(completer.complete, onError: completer.completeError);
    return completer.future;
  }

  @override
  Future<void> endInput() async {
    await _writeTail.catchError((Object _) {});
    final process = _process;
    if (process == null) return;
    _isReady = false;
    try {
      await process.stdin.close();
    } on Object {
      // Closing an already-closed pipe is idempotent.
    }
  }

  @override
  Future<void> close() async {
    if (_isClosed) return;
    _isClosed = true;
    _isReady = false;
    final process = _process;
    if (process == null) return;
    await _stderrSubscription?.cancel();
    _stderrSubscription = null;
    await endInput();
    try {
      await process.exitCode.timeout(const Duration(seconds: 5));
    } on TimeoutException {
      process.kill(ProcessSignal.sigterm);
      try {
        await process.exitCode.timeout(const Duration(seconds: 5));
      } on TimeoutException {
        process.kill(ProcessSignal.sigkill);
        try {
          await process.exitCode.timeout(const Duration(seconds: 5));
        } on TimeoutException {
          // The operating system retains responsibility for a killed child.
        }
      }
    }
    _process = null;
  }
}
