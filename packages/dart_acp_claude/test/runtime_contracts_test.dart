import 'dart:math';

import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

void main() {
  test(
    'runtime environment detects local, browserless, and remote contexts',
    () {
      final local = ClaudeAcpEnvironment(variables: const <String, String>{});
      expect(local.isRemote, isFalse);
      expect(local.browserAllowed, isTrue);

      final browserless = ClaudeAcpEnvironment(
        variables: const <String, String>{'NO_BROWSER': '1'},
      );
      expect(browserless.isRemote, isTrue);
      expect(browserless.browserAllowed, isFalse);

      final hidden = ClaudeAcpEnvironment(
        variables: const <String, String>{},
        hideAuthentication: true,
      );
      expect(hidden.browserAllowed, isFalse);
      expect(
        ClaudeAcpEnvironment(
          variables: const <String, String>{'SSH_CONNECTION': 'remote'},
        ).isRemote,
        isTrue,
      );
    },
  );

  test(
    'runtime boundaries provide deterministic IDs and filesystem checks',
    () async {
      final id = ClaudeAcpRandomIdGenerator(Random(1))();
      expect(
        id,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-'
            r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );

      const fileSystem = LocalClaudeAcpFileSystem();
      expect(fileSystem.isAbsolute('/tmp'), isTrue);
      expect(await fileSystem.isDirectory('/tmp'), isTrue);
      expect(
        await fileSystem.isDirectory('/definitely/missing/dart-acp'),
        isFalse,
      );
    },
  );

  test('diagnostic logger implementations accept all message shapes', () {
    const ClaudeAcpNullLogger()
      ..log('ignored')
      ..error(
        'ignored',
        error: StateError('ignored'),
        stackTrace: StackTrace.empty,
      );
    const ClaudeAcpStderrLogger()
      ..log('runtime-contracts-test')
      ..error(
        'runtime-contracts-test error',
        error: StateError('expected'),
        stackTrace: StackTrace.empty,
      );
  });
}
