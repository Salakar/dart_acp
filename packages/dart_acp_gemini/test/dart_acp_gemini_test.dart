@TestOn('vm')
library;

import 'dart:io';

import 'package:dart_acp_gemini/dart_acp_gemini.dart';
import 'package:test/test.dart';

void main() {
  group('findGeminiExecutable', () {
    test('uses configured executable before PATH', () {
      expect(
        findGeminiExecutable(
          environment: const <String, String>{
            'GEMINI_EXECUTABLE': '/custom/gemini',
            'PATH': '/bin',
          },
          windows: false,
          fileExists: (String path) => path == '/custom/gemini',
        ),
        '/custom/gemini',
      );
    });

    test('supports case-insensitive Windows environment and npm launchers', () {
      expect(
        findGeminiExecutable(
          environment: const <String, String>{'Path': r'C:\Tools;C:\npm'},
          windows: true,
          fileExists: (String path) => path == r'C:\npm\gemini.cmd',
        ),
        r'C:\npm\gemini.cmd',
      );
    });

    test('checks the common npm fallback directory', () {
      expect(
        findGeminiExecutable(
          environment: const <String, String>{'HOME': '/home/dev'},
          windows: false,
          fileExists: (String path) =>
              path == '/home/dev/.npm-global/bin/gemini',
        ),
        '/home/dev/.npm-global/bin/gemini',
      );
    });

    test('throws an actionable error when discovery fails', () {
      expect(
        () => findGeminiExecutable(
          environment: const <String, String>{},
          windows: false,
          fileExists: (_) => false,
        ),
        throwsA(isA<GeminiExecutableNotFoundException>()),
      );
    });
  });

  test('options validate lifecycle bounds and copy the environment', () {
    final Map<String, String> environment = <String, String>{'A': 'one'};
    final GeminiAcpClientOptions options = GeminiAcpClientOptions(
      environment: environment,
    );
    environment['A'] = 'two';

    expect(options.environment, const <String, String>{'A': 'one'});
    expect(
      () => GeminiAcpClientOptions(flagDetectionTimeout: Duration.zero),
      throwsArgumentError,
    );
    expect(
      () => GeminiAcpClientOptions(initializationTimeout: Duration.zero),
      throwsArgumentError,
    );
    expect(
      () => GeminiAcpClientOptions(shutdownTimeout: Duration.zero),
      throwsArgumentError,
    );
    expect(
      () => GeminiAcpClientOptions(maximumStderrTailCharacters: -1),
      throwsArgumentError,
    );
  });

  test(
    'auto-detects the legacy flag and owns process shutdown',
    () async {
      final Directory temporary = Directory.systemTemp.createTempSync(
        'dart-acp-gemini-',
      );
      addTearDown(() => temporary.deleteSync(recursive: true));
      final File argumentsFile = File('${temporary.path}/arguments.txt');
      final File executable = File('${temporary.path}/gemini')
        ..writeAsStringSync(
          '#!/bin/sh\n'
          'if [ "\$1" = "--help" ]; then\n'
          '  printf "%s\\n" "  --experimental-acp  Starts ACP mode"\n'
          '  exit 0\n'
          'fi\n'
          'printf "%s\\n" "\$@" > "\$ARGUMENTS_FILE"\n'
          'IFS= read -r request\n'
          "printf '%s\\n' "
          '\'{"jsonrpc":"2.0","id":0,"result":{"protocolVersion":1,'
          '"agentCapabilities":{"loadSession":false,'
          '"promptCapabilities":{"image":false,"audio":false,'
          '"embeddedContext":false},"mcpCapabilities":{"http":false,'
          '"sse":false}},"authMethods":[]}}\'\n'
          'while IFS= read -r request; do :; done\n',
        );
      final ProcessResult chmod = Process.runSync('chmod', <String>[
        '+x',
        executable.path,
      ]);
      expect(chmod.exitCode, 0);

      final GeminiAcpClient client = await GeminiAcpClient.start(
        options: GeminiAcpClientOptions(
          executable: executable.path,
          environment: <String, String>{'ARGUMENTS_FILE': argumentsFile.path},
          initializationTimeout: const Duration(seconds: 5),
        ),
      );
      expect(client.connection.lifecycle.isReady, isTrue);
      expect(client.arguments, const <String>['--experimental-acp']);
      await client.close();
      expect(await client.exitCode, 0);
      expect(argumentsFile.readAsLinesSync(), const <String>[
        '--experimental-acp',
      ]);
    },
    skip: Platform.isWindows
        ? 'The fixture is a POSIX executable; Windows discovery is tested '
              'separately.'
        : false,
  );

  test(
    'passes the selected model to the CLI as --model',
    () async {
      final Directory temporary = Directory.systemTemp.createTempSync(
        'dart-acp-gemini-',
      );
      addTearDown(() => temporary.deleteSync(recursive: true));
      final File argumentsFile = File('${temporary.path}/arguments.txt');
      final File executable = File('${temporary.path}/gemini')
        ..writeAsStringSync(
          '#!/bin/sh\n'
          'if [ "\$1" = "--help" ]; then\n'
          '  printf "%s\\n" "  --experimental-acp  Starts ACP mode"\n'
          '  exit 0\n'
          'fi\n'
          'printf "%s\\n" "\$@" > "\$ARGUMENTS_FILE"\n'
          'IFS= read -r request\n'
          "printf '%s\\n' "
          '\'{"jsonrpc":"2.0","id":0,"result":{"protocolVersion":1,'
          '"agentCapabilities":{"loadSession":false,'
          '"promptCapabilities":{"image":false,"audio":false,'
          '"embeddedContext":false},"mcpCapabilities":{"http":false,'
          '"sse":false}},"authMethods":[]}}\'\n'
          'while IFS= read -r request; do :; done\n',
        );
      final ProcessResult chmod = Process.runSync('chmod', <String>[
        '+x',
        executable.path,
      ]);
      expect(chmod.exitCode, 0);

      final GeminiAcpClient client = await GeminiAcpClient.start(
        options: GeminiAcpClientOptions(
          executable: executable.path,
          model: 'gemini-2.5-pro',
          environment: <String, String>{'ARGUMENTS_FILE': argumentsFile.path},
          initializationTimeout: const Duration(seconds: 5),
        ),
      );
      expect(client.arguments, const <String>[
        '--experimental-acp',
        '--model',
        'gemini-2.5-pro',
      ]);
      await client.close();
      // The flag has to reach the process, not just the recorded vector.
      expect(argumentsFile.readAsLinesSync(), const <String>[
        '--experimental-acp',
        '--model',
        'gemini-2.5-pro',
      ]);
    },
    skip: Platform.isWindows
        ? 'The fixture is a POSIX executable; Windows discovery is tested '
              'separately.'
        : false,
  );

  test('rejects a blank model rather than launching without one', () {
    expect(
      () => GeminiAcpClientOptions(model: '   '),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
    'reports malformed handshakes and cleans up the process',
    () async {
      final Directory temporary = Directory.systemTemp.createTempSync(
        'dart-acp-gemini-malformed-',
      );
      addTearDown(() => temporary.deleteSync(recursive: true));
      final File exitFile = File('${temporary.path}/exited.txt');
      final File executable = File('${temporary.path}/gemini')
        ..writeAsStringSync(
          '#!/bin/sh\n'
          'if [ "\$1" = "--help" ]; then\n'
          '  printf "%s\\n" "  --acp  Starts ACP mode"\n'
          '  exit 0\n'
          'fi\n'
          'printf "%s" "diagnostic-123456789" >&2\n'
          'IFS= read -r request\n'
          "printf '%s\\n' 'not-json'\n"
          'while IFS= read -r request; do :; done\n'
          'printf "%s" "closed" > "\$EXIT_FILE"\n',
        );
      final ProcessResult chmod = Process.runSync('chmod', <String>[
        '+x',
        executable.path,
      ]);
      expect(chmod.exitCode, 0);

      await expectLater(
        GeminiAcpClient.start(
          options: GeminiAcpClientOptions(
            executable: executable.path,
            environment: <String, String>{'EXIT_FILE': exitFile.path},
            initializationTimeout: const Duration(milliseconds: 500),
            maximumStderrTailCharacters: 6,
          ),
        ),
        throwsA(
          isA<GeminiAcpClientException>()
              .having(
                (GeminiAcpClientException error) => error.message,
                'message',
                contains('initialization handshake'),
              )
              .having(
                (GeminiAcpClientException error) => error.stderrTail,
                'stderrTail',
                '456789',
              ),
        ),
      );
      expect(exitFile.readAsStringSync(), 'closed');
    },
    skip: Platform.isWindows
        ? 'The fixture is a POSIX executable; Windows discovery is tested '
              'separately.'
        : false,
  );

  test(
    'bounds shutdown when Gemini ignores graceful termination',
    () async {
      final Directory temporary = Directory.systemTemp.createTempSync(
        'dart-acp-gemini-stubborn-',
      );
      addTearDown(() => temporary.deleteSync(recursive: true));
      final File executable = File('${temporary.path}/gemini')
        ..writeAsStringSync(
          '#!/bin/sh\n'
          'if [ "\$1" = "--help" ]; then\n'
          '  printf "%s\\n" "  --acp  Starts ACP mode"\n'
          '  exit 0\n'
          'fi\n'
          'IFS= read -r request\n'
          "printf '%s\\n' "
          '\'{"jsonrpc":"2.0","id":0,"result":{"protocolVersion":1,'
          '"agentCapabilities":{"loadSession":false,'
          '"promptCapabilities":{"image":false,"audio":false,'
          '"embeddedContext":false},"mcpCapabilities":{"http":false,'
          '"sse":false}},"authMethods":[]}}\'\n'
          'trap "" TERM\n'
          'while :; do sleep 1; done\n',
        );
      final ProcessResult chmod = Process.runSync('chmod', <String>[
        '+x',
        executable.path,
      ]);
      expect(chmod.exitCode, 0);

      final GeminiAcpClient client = await GeminiAcpClient.start(
        options: GeminiAcpClientOptions(
          executable: executable.path,
          initializationTimeout: const Duration(seconds: 5),
          shutdownTimeout: const Duration(milliseconds: 100),
        ),
      );
      final Stopwatch stopwatch = Stopwatch()..start();
      await client.close().timeout(const Duration(seconds: 2));
      stopwatch.stop();

      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 2)));
      expect(await client.exitCode, isNonZero);
    },
    skip: Platform.isWindows
        ? 'The fixture is a POSIX executable; Windows discovery is tested '
              'separately.'
        : false,
  );
}
