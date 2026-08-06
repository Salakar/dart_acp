@TestOn('vm')
library;

import 'package:dart_acp_antigravity/dart_acp_antigravity.dart';
import 'package:test/test.dart';

void main() {
  group('findAntigravityExecutable', () {
    test('uses configured executable before PATH', () {
      expect(
        findAntigravityExecutable(
          environment: const <String, String>{
            'ANTIGRAVITY_EXECUTABLE': '/custom/agy',
            'PATH': '/bin',
          },
          windows: false,
          fileExists: (String path) => path == '/custom/agy',
        ),
        '/custom/agy',
      );
    });

    test('finds agy on PATH', () {
      expect(
        findAntigravityExecutable(
          environment: const <String, String>{'PATH': '/bin:/usr/bin'},
          windows: false,
          fileExists: (String path) => path == '/usr/bin/agy',
        ),
        '/usr/bin/agy',
      );
    });

    test('checks the official installer directory', () {
      expect(
        findAntigravityExecutable(
          environment: const <String, String>{'HOME': '/home/dev'},
          windows: false,
          fileExists: (String path) => path == '/home/dev/.local/bin/agy',
        ),
        '/home/dev/.local/bin/agy',
      );
    });

    test('supports case-insensitive Windows environment lookups', () {
      expect(
        findAntigravityExecutable(
          environment: const <String, String>{'Path': r'C:\Tools'},
          windows: true,
          fileExists: (String path) => path == r'C:\Tools\agy.cmd',
        ),
        r'C:\Tools\agy.cmd',
      );
    });

    test('throws an actionable error when discovery fails', () {
      expect(
        () => findAntigravityExecutable(
          environment: const <String, String>{},
          windows: false,
          fileExists: (_) => false,
        ),
        throwsA(isA<AntigravityExecutableNotFoundException>()),
      );
    });
  });

  group('AntigravityAcpOptions', () {
    test('validates bounds and copies the environment', () {
      final Map<String, String> environment = <String, String>{'A': '1'};
      final AntigravityAcpOptions options = AntigravityAcpOptions(
        environment: environment,
      );
      environment['A'] = '2';
      expect(options.environment, <String, String>{'A': '1'});
      expect(() => AntigravityAcpOptions(executable: ' '), throwsArgumentError);
      expect(() => AntigravityAcpOptions(model: ''), throwsArgumentError);
      expect(() => AntigravityAcpOptions(agentName: ' '), throwsArgumentError);
      expect(
        () => AntigravityAcpOptions(promptTimeout: Duration.zero),
        throwsArgumentError,
      );
      expect(
        () => AntigravityAcpOptions(shutdownTimeout: Duration.zero),
        throwsArgumentError,
      );
      expect(
        () => AntigravityAcpOptions(maximumStderrTailCharacters: -1),
        throwsArgumentError,
      );
    });
  });

  group('renderAntigravityPrompt', () {
    test('renders text, links, and embedded resources', () {
      final String prompt = renderAntigravityPrompt(<ContentBlock>[
        ContentBlockText(TextContent(text: 'Fix the bug.')),
        ContentBlockResourceLink(
          ResourceLink(name: 'main.dart', uri: 'file:///w/main.dart'),
        ),
        ContentBlockResource(
          EmbeddedResource(
            resource: EmbeddedResourceResourceTextResourceContents(
              TextResourceContents(uri: 'file:///w/a.txt', text: 'alpha'),
            ),
          ),
        ),
      ]);
      expect(
        prompt,
        'Fix the bug.\n\n'
        'main.dart (file:///w/main.dart)\n\n'
        '<context ref="file:///w/a.txt">\nalpha\n</context>',
      );
    });
  });

  group('runAntigravityAdapter', () {
    test('prints the version and usage', () async {
      final List<String> out = <String>[];
      expect(
        await runAntigravityAdapter(
          const <String>['--version'],
          environment: const <String, String>{},
          writeOutput: out.add,
          writeError: (_) => fail('unexpected stderr'),
        ),
        0,
      );
      expect(out.single, dartAcpAntigravityVersion);
      expect(
        await runAntigravityAdapter(
          const <String>['--help'],
          environment: const <String, String>{},
          writeOutput: out.add,
          writeError: (_) => fail('unexpected stderr'),
        ),
        0,
      );
      expect(out.last, contains('serves the Antigravity ACP agent'));
    });

    test('rejects unknown arguments and invalid environments', () async {
      final List<String> errors = <String>[];
      expect(
        await runAntigravityAdapter(
          const <String>['--bogus'],
          environment: const <String, String>{},
          writeOutput: (_) => fail('unexpected stdout'),
          writeError: errors.add,
        ),
        64,
      );
      expect(errors.single, contains('Unknown argument'));
      expect(
        await runAntigravityAdapter(
          const <String>[],
          environment: const <String, String>{
            'ANTIGRAVITY_ACP_EFFORT': 'extreme',
          },
          writeOutput: (_) => fail('unexpected stdout'),
          writeError: errors.add,
        ),
        64,
      );
      expect(errors.last, contains('ANTIGRAVITY_ACP_EFFORT'));
    });

    test('builds options from the environment and serves stdio', () async {
      AntigravityAcpOptions? served;
      expect(
        await runAntigravityAdapter(
          const <String>[],
          environment: const <String, String>{
            'ANTIGRAVITY_EXECUTABLE': '/custom/agy',
            'ANTIGRAVITY_ACP_MODEL': 'gemini-3',
            'ANTIGRAVITY_ACP_EFFORT': 'high',
            'ANTIGRAVITY_ACP_PERMISSION_POLICY': 'accept-edits',
            'ANTIGRAVITY_ACP_PROMPT_TIMEOUT_MS': '60000',
            'ANTIGRAVITY_ACP_SHUTDOWN_TIMEOUT_MS': '500',
            'ANTIGRAVITY_ACP_MAX_STDERR_CHARS': '64',
          },
          stdioRunner: (AntigravityAcpOptions options) async {
            served = options;
            return 0;
          },
        ),
        0,
      );
      expect(served?.executable, '/custom/agy');
      expect(served?.model, 'gemini-3');
      expect(served?.effort, AntigravityReasoningEffort.high);
      expect(served?.permissionPolicy, AntigravityPermissionPolicy.acceptEdits);
      expect(served?.promptTimeout, const Duration(minutes: 1));
      expect(served?.shutdownTimeout, const Duration(milliseconds: 500));
      expect(served?.maximumStderrTailCharacters, 64);
    });
  });
}
