import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Prefix emitted when the browser WebSocket helper is ready for connections.
const String browserWebSocketHelperReadyPrefix =
    'ACP_BROWSER_WEBSOCKET_ECHO_READY ';

const String _expectedHelperUrl = 'ws://127.0.0.1:47321/echo';
const Duration _helperStartupTimeout = Duration(seconds: 15);
const Duration _helperShutdownTimeout = Duration(seconds: 3);

/// Builds the Dart command arguments for the complete Chrome dart2js suite.
List<String> buildChromeTestArguments(List<String> forwardedArguments) =>
    <String>[
      '--suppress-analytics',
      'test',
      '--platform',
      'chrome',
      '--compiler',
      'dart2js',
      ...forwardedArguments,
    ];

/// Parses the helper readiness sentinel, or returns `null` for another line.
Uri? parseBrowserWebSocketHelperReadyLine(String line) {
  if (!line.startsWith(browserWebSocketHelperReadyPrefix)) {
    return null;
  }
  final uri = Uri.tryParse(
    line.substring(browserWebSocketHelperReadyPrefix.length),
  );
  if (uri == null ||
      uri.scheme != 'ws' ||
      uri.host != InternetAddress.loopbackIPv4.address ||
      !uri.hasPort ||
      uri.path != '/echo') {
    return null;
  }
  return uri;
}

/// Runs all browser-compatible tests after starting their WebSocket helper.
///
/// [forwardedArguments] are appended verbatim to the `dart test` invocation,
/// including coverage flags or an optional focused test path.
Future<int> runChromeTestSuite(
  List<String> forwardedArguments, {
  Directory? packageRoot,
  Duration helperStartupTimeout = _helperStartupTimeout,
}) async {
  final root = (packageRoot ?? Directory.current).absolute;
  final helperFile = File(
    '${root.path}${Platform.pathSeparator}test'
    '${Platform.pathSeparator}remote'
    '${Platform.pathSeparator}support'
    '${Platform.pathSeparator}browser_web_socket_echo_server.dart',
  );
  if (!helperFile.existsSync()) {
    throw StateError(
      'Run this tool from the dart_acp_sdk package root; missing '
      '${helperFile.path}.',
    );
  }

  final helper = await _BrowserWebSocketHelper.start(
    executable: Platform.resolvedExecutable,
    helperFile: helperFile,
    packageRoot: root,
    startupTimeout: helperStartupTimeout,
  );
  try {
    return await _runTestProcess(
      executable: Platform.resolvedExecutable,
      arguments: buildChromeTestArguments(forwardedArguments),
      packageRoot: root,
    );
  } finally {
    await helper.close();
  }
}

Future<int> _runTestProcess({
  required String executable,
  required List<String> arguments,
  required Directory packageRoot,
}) async {
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: packageRoot.path,
  );
  final stdoutDone = _forwardBytes(process.stdout, stdout);
  final stderrDone = _forwardBytes(process.stderr, stderr);
  final result = await process.exitCode;
  await Future.wait<void>(<Future<void>>[stdoutDone, stderrDone]);
  return result;
}

Future<void> _forwardBytes(Stream<List<int>> input, IOSink output) {
  final done = Completer<void>();
  input.listen(
    output.add,
    onError: done.completeError,
    onDone: done.complete,
    cancelOnError: true,
  );
  return done.future;
}

final class _BrowserWebSocketHelper {
  _BrowserWebSocketHelper._(this._process) {
    _exitCode = _process.exitCode;
    _stdoutDone = _listenToStdout();
    _stderrDone = _listenToStderr();
  }

  final Process _process;
  final Completer<Uri> _ready = Completer<Uri>();
  final List<String> _stderrLines = <String>[];
  late final Future<int> _exitCode;
  late final Future<void> _stdoutDone;
  late final Future<void> _stderrDone;
  var _closed = false;

  static Future<_BrowserWebSocketHelper> start({
    required String executable,
    required File helperFile,
    required Directory packageRoot,
    required Duration startupTimeout,
  }) async {
    final process = await Process.start(executable, <String>[
      '--suppress-analytics',
      'run',
      helperFile.path,
    ], workingDirectory: packageRoot.path);
    final helper = _BrowserWebSocketHelper._(process);
    try {
      await helper._waitUntilReady(startupTimeout);
      return helper;
    } on Object {
      await helper.close();
      rethrow;
    }
  }

  Future<void> _waitUntilReady(Duration timeout) async {
    final outcome = await Future.any<Object>(<Future<Object>>[
      _ready.future,
      _exitCode.then<Object>((code) => code),
    ]).timeout(timeout);
    if (outcome is int) {
      throw StateError(
        'Browser WebSocket helper exited with code $outcome before readiness.'
        '${_formattedStderr()}',
      );
    }
    final uri = outcome as Uri;
    if (uri.toString() != _expectedHelperUrl) {
      throw StateError(
        'Browser WebSocket helper announced $uri; expected '
        '$_expectedHelperUrl.',
      );
    }
  }

  Future<void> _listenToStdout() async {
    await for (final line
        in _process.stdout
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
      final uri = parseBrowserWebSocketHelperReadyLine(line);
      if (uri != null && !_ready.isCompleted) {
        _ready.complete(uri);
      }
    }
  }

  Future<void> _listenToStderr() async {
    await for (final line
        in _process.stderr
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
      if (_stderrLines.length == 20) {
        _stderrLines.removeAt(0);
      }
      _stderrLines.add(line);
    }
  }

  String _formattedStderr() => _stderrLines.isEmpty
      ? ''
      : '\nHelper stderr:\n${_stderrLines.join('\n')}';

  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;

    try {
      await _process.stdin.close();
    } on Object {
      // The helper may already have closed its stdin after an early exit.
    }

    try {
      await _exitCode.timeout(_helperShutdownTimeout);
    } on TimeoutException {
      final killed = _process.kill();
      if (!killed) {
        throw StateError('Unable to stop the browser WebSocket helper.');
      }
      await _exitCode.timeout(_helperShutdownTimeout);
    }
    await Future.wait<void>(<Future<void>>[_stdoutDone, _stderrDone]);
  }
}
