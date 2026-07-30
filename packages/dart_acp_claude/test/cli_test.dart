import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

void main() {
  test('uses process defaults for output and environment', () async {
    expect(await runDartAcpClaude(const <String>['--version']), 0);
    expect(
      await runDartAcpClaude(const <String>[
        'unknown',
      ], environment: const <String, String>{}),
      64,
    );
  });

  test('prints version and help without starting a process', () async {
    final output = <String>[];
    expect(
      await runDartAcpClaude(
        const <String>['--version'],
        environment: const <String, String>{},
        writeOutput: output.add,
      ),
      0,
    );
    expect(output, <String>[dartAcpClaudeVersion]);

    output.clear();
    expect(
      await runDartAcpClaude(
        const <String>['--help'],
        environment: const <String, String>{},
        writeOutput: output.add,
      ),
      0,
    );
    expect(output.single, contains('serves the Claude ACP agent'));
  });

  test('delegates CLI arguments and rejects unknown arguments', () async {
    List<String>? delegated;
    final result = await runDartAcpClaude(
      const <String>['--cli', '--version'],
      environment: const <String, String>{
        'CLAUDE_CODE_EXECUTABLE': '/opt/claude',
      },
      processRunner: (arguments, options, environment) async {
        delegated = arguments;
        expect(options.cliPath, '/opt/claude');
        return 7;
      },
    );
    expect(result, 7);
    expect(delegated, <String>['--version']);

    final errors = <String>[];
    expect(
      await runDartAcpClaude(
        const <String>['unknown'],
        environment: const <String, String>{},
        writeError: errors.add,
      ),
      64,
    );
    expect(errors.single, contains('Unknown argument'));
  });

  test('injects default stdio serving for deterministic tests', () async {
    ClaudeAcpOptions? captured;
    expect(
      await runDartAcpClaude(
        const <String>[],
        environment: const <String, String>{
          'CLAUDE_CODE_EXECUTABLE': '/opt/claude',
        },
        settingsResolver: (_) async =>
            claude.ClaudeResolvedSettings(<String, Object?>{
              'env': <String, Object?>{'MANAGED': 'yes'},
            }),
        stdioRunner: (options, environment) async {
          captured = options;
          expect(environment.variables, contains('CLAUDE_CODE_EXECUTABLE'));
          expect(environment.variables['MANAGED'], 'yes');
          return 3;
        },
      ),
      3,
    );
    expect(captured?.cliPath, '/opt/claude');
  });

  test('resolves managed settings through the default resolver', () async {
    expect(
      await runDartAcpClaude(
        const <String>[],
        environment: const <String, String>{},
        stdioRunner: (options, environment) async {
          expect(environment.variables, isEmpty);
          return 0;
        },
      ),
      0,
    );
  });

  test('fails cleanly when managed settings are invalid', () async {
    final errors = <String>[];
    expect(
      await runDartAcpClaude(
        const <String>[],
        environment: const <String, String>{},
        settingsResolver: (_) async => throw const FormatException('bad'),
        writeError: errors.add,
      ),
      78,
    );
    expect(errors.single, contains('managed Claude settings'));
  });
}
