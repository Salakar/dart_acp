import 'dart:io';

import 'package:dart_acp_codex/dart_acp_codex.dart';
import 'package:test/test.dart';

void main() {
  test('prints version and help without starting anything', () async {
    final output = <String>[];
    expect(
      await runCodexAdapter(
        <String>['--version'],
        environment: const <String, String>{},
        writeOutput: output.add,
      ),
      0,
    );
    expect(output, <String>[dartAcpCodexVersion]);

    output.clear();
    expect(
      await runCodexAdapter(
        <String>['--help'],
        environment: const <String, String>{},
        writeOutput: output.add,
      ),
      0,
    );
    expect(output.single, contains('serves the Codex ACP agent'));
  });

  test(
    'forwards login and cli arguments to the configured executable',
    () async {
      final calls = <(String, List<String>, Map<String, String>)>[];
      Future<int> runner(
        String executable,
        List<String> arguments,
        Map<String, String> environment,
      ) async {
        calls.add((executable, arguments, environment));
        return 7;
      }

      expect(
        await runCodexAdapter(
          <String>['login', '--device-auth'],
          environment: const <String, String>{'CODEX_EXECUTABLE': '/bin/codex'},
          processRunner: runner,
        ),
        7,
      );
      expect(calls.single.$1, '/bin/codex');
      expect(calls.single.$2, <String>['login', '--device-auth']);

      calls.clear();
      expect(
        await runCodexAdapter(
          <String>['cli', 'exec', 'hello'],
          environment: const <String, String>{},
          processRunner: runner,
        ),
        7,
      );
      expect(calls.single.$2, <String>['exec', 'hello']);
    },
  );

  test(
    'parses default-mode environment and validates positive values',
    () async {
      CodexAdapterOptions? captured;
      final exit = await runCodexAdapter(
        const <String>[],
        environment: const <String, String>{
          'CODEX_EXECUTABLE': '/opt/codex',
          'CODEX_ACP_MODEL_PROVIDER': 'provider',
          'CODEX_ACP_SHUTDOWN_TIMEOUT_MS': '125',
          'CODEX_ACP_MAX_STDERR_CHARS': '512',
        },
        stdioRunner: (options) async {
          captured = options;
          return 3;
        },
      );
      expect(exit, 3);
      expect(captured?.executable, '/opt/codex');
      expect(captured?.modelProvider, 'provider');
      expect(captured?.shutdownTimeout, const Duration(milliseconds: 125));
      expect(captured?.maximumStderrTailCharacters, 512);

      final errors = <String>[];
      expect(
        await runCodexAdapter(
          const <String>[],
          environment: const <String, String>{
            'CODEX_ACP_SHUTDOWN_TIMEOUT_MS': 'zero',
          },
          stdioRunner: (_) async => 0,
          writeError: errors.add,
        ),
        64,
      );
      expect(errors.single, contains('positive integer'));
    },
  );

  test('reports unknown arguments with usage', () async {
    final errors = <String>[];
    expect(
      await runCodexAdapter(
        <String>['unknown'],
        environment: const <String, String>{},
        writeError: errors.add,
      ),
      64,
    );
    expect(
      errors.single,
      allOf(contains('Unknown argument'), contains('Usage:')),
    );
  });

  test(
    'runs and reports failure from the default child process runner',
    () async {
      expect(
        await runCodexAdapter(
          <String>['cli', '--version'],
          environment: <String, String>{
            'CODEX_EXECUTABLE': Platform.resolvedExecutable,
          },
        ),
        0,
      );
      expect(
        await runCodexAdapter(
          <String>['cli'],
          environment: const <String, String>{
            'CODEX_EXECUTABLE': '/definitely/missing/codex',
          },
        ),
        69,
      );
    },
  );
}
