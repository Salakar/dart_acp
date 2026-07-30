@TestOn('vm')
library;

import 'dart:io';

import 'package:dart_acp_opencode/dart_acp_opencode.dart';
import 'package:test/test.dart';

void main() {
  group('findOpenCodeExecutable', () {
    test('uses configured executable before PATH', () {
      expect(
        findOpenCodeExecutable(
          environment: const <String, String>{
            'OPENCODE_EXECUTABLE': '/custom/opencode',
            'PATH': '/bin',
          },
          windows: false,
          fileExists: (String path) => path == '/custom/opencode',
        ),
        '/custom/opencode',
      );
    });

    test('supports case-insensitive Windows environment and launchers', () {
      expect(
        findOpenCodeExecutable(
          environment: const <String, String>{'Path': r'C:\Tools;C:\OpenCode'},
          windows: true,
          fileExists: (String path) => path == r'C:\OpenCode\opencode.cmd',
        ),
        r'C:\OpenCode\opencode.cmd',
      );
    });

    test('checks the documented OpenCode fallback directory', () {
      expect(
        findOpenCodeExecutable(
          environment: const <String, String>{'HOME': '/home/dev'},
          windows: false,
          fileExists: (String path) =>
              path == '/home/dev/.opencode/bin/opencode',
        ),
        '/home/dev/.opencode/bin/opencode',
      );
    });

    test('throws an actionable error when discovery fails', () {
      expect(
        () => findOpenCodeExecutable(
          environment: const <String, String>{},
          windows: false,
          fileExists: (_) => false,
        ),
        throwsA(isA<OpenCodeExecutableNotFoundException>()),
      );
    });
  });

  test('options validate lifecycle bounds and copy the environment', () {
    final Map<String, String> environment = <String, String>{'A': 'one'};
    final OpenCodeAcpClientOptions options = OpenCodeAcpClientOptions(
      environment: environment,
    );
    environment['A'] = 'two';

    expect(options.environment, const <String, String>{'A': 'one'});
    expect(
      () => OpenCodeAcpClientOptions(initializationTimeout: Duration.zero),
      throwsArgumentError,
    );
    expect(
      () => OpenCodeAcpClientOptions(shutdownTimeout: Duration.zero),
      throwsArgumentError,
    );
    expect(
      () => OpenCodeAcpClientOptions(maximumStderrTailCharacters: -1),
      throwsArgumentError,
    );
  });

  test(
    'starts native ACP mode and owns process shutdown',
    () async {
      final Directory temporary = Directory.systemTemp.createTempSync(
        'dart-acp-opencode-',
      );
      addTearDown(() => temporary.deleteSync(recursive: true));
      final File argumentsFile = File('${temporary.path}/arguments.txt');
      final File executable = File('${temporary.path}/opencode')
        ..writeAsStringSync(
          '#!/bin/sh\n'
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

      final OpenCodeAcpClient client = await OpenCodeAcpClient.start(
        options: OpenCodeAcpClientOptions(
          executable: executable.path,
          environment: <String, String>{'ARGUMENTS_FILE': argumentsFile.path},
          initializationTimeout: const Duration(seconds: 5),
        ),
      );
      expect(client.connection.lifecycle.isReady, isTrue);
      expect(client.arguments, const <String>['acp']);
      await client.close();
      expect(await client.exitCode, 0);
      expect(argumentsFile.readAsLinesSync(), const <String>['acp']);
    },
    skip: Platform.isWindows
        ? 'The fixture is a POSIX executable; Windows discovery is tested '
              'separately.'
        : false,
  );

  test(
    'reports malformed handshakes and cleans up the process',
    () async {
      final Directory temporary = Directory.systemTemp.createTempSync(
        'dart-acp-opencode-malformed-',
      );
      addTearDown(() => temporary.deleteSync(recursive: true));
      final File exitFile = File('${temporary.path}/exited.txt');
      final File executable = File('${temporary.path}/opencode')
        ..writeAsStringSync(
          '#!/bin/sh\n'
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
        OpenCodeAcpClient.start(
          options: OpenCodeAcpClientOptions(
            executable: executable.path,
            environment: <String, String>{'EXIT_FILE': exitFile.path},
            initializationTimeout: const Duration(milliseconds: 500),
            maximumStderrTailCharacters: 6,
          ),
        ),
        throwsA(
          isA<OpenCodeAcpClientException>()
              .having(
                (OpenCodeAcpClientException error) => error.message,
                'message',
                contains('initialization handshake'),
              )
              .having(
                (OpenCodeAcpClientException error) => error.stderrTail,
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
}
