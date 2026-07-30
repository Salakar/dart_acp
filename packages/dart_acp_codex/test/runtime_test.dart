import 'dart:io';

import 'package:dart_acp_codex/dart_acp_codex.dart';
import 'package:test/test.dart';

import 'helpers/fake_backend.dart';

late Directory _fixtureDirectory;
late String _fakeExecutable;

void main() {
  setUpAll(() async {
    _fixtureDirectory = await Directory.systemTemp.createTemp(
      'dart-acp-codex-process-',
    );
    _fakeExecutable = '${_fixtureDirectory.path}/fake_codex_process';
    final result = await Process.run(Platform.resolvedExecutable, <String>[
      'compile',
      'exe',
      File('test/fixtures/fake_codex_process.dart').absolute.path,
      '-o',
      _fakeExecutable,
    ]);
    if (result.exitCode != 0) {
      throw StateError('Unable to compile fake process: ${result.stderr}');
    }
  });

  tearDownAll(() async {
    await _fixtureDirectory.delete(recursive: true);
  });

  test(
    'injected backend runtime creates agents and closes idempotently',
    () async {
      final backend = FakeCodexBackend();
      final options = CodexAdapterOptions(
        environment: const <String, String>{},
      );
      final runtime = await CodexRuntime.start(
        options: options,
        backend: backend,
      );

      expect(runtime.options, same(options));
      expect(runtime.createAgent(), isA<CodexAgent>());
      expect(await runtime.exitCode, 0);
      await runtime.close();
      await runtime.close();
      expect(backend.isClosed, isTrue);
    },
  );

  test(
    'owns a real fake NDJSON process through initialization and close',
    () async {
      final log = File('${_fixtureDirectory.path}/clean.log');
      final runtime = await CodexRuntime.start(
        options: CodexAdapterOptions(
          executable: _fakeExecutable,
          environment: <String, String>{
            ...Platform.environment,
            'FAKE_CODEX_LOG': log.path,
          },
          shutdownTimeout: const Duration(seconds: 2),
        ),
      );
      final client = AcpClientApp.v1(
        implementation: Implementation(name: 'runtime-test', version: '1.0.0'),
        capabilities: ClientCapabilities.fromJson(<String, Object?>{
          'fs': <String, Object?>{
            'readTextFile': false,
            'writeTextFile': false,
          },
          'terminal': false,
        }),
      );
      final pair = await client.connectWith(runtime.createAgent().app);

      await pair.close();
      await runtime.close();
      expect(
        await runtime.exitCode,
        0,
        reason: log.existsSync() ? log.readAsStringSync() : 'no child log',
      );
    },
  );

  test('reports spawn failure without exposing the executable', () async {
    await expectLater(
      CodexRuntime.start(
        options: CodexAdapterOptions(
          executable: '/definitely/missing/dart-acp-codex',
          environment: const <String, String>{},
        ),
      ),
      throwsA(
        isA<CodexProcessException>().having(
          (error) => error.message,
          'message',
          isNot(contains('missing')),
        ),
      ),
    );
  });

  test('captures non-zero exit diagnostics without stderr content', () async {
    final diagnostics = <CodexDiagnostic>[];
    final runtime = await CodexRuntime.start(
      options: CodexAdapterOptions(
        executable: _fakeExecutable,
        environment: <String, String>{
          ...Platform.environment,
          'FAKE_CODEX_MODE': 'exit',
        },
        onDiagnostic: diagnostics.add,
      ),
    );

    expect(await runtime.exitCode, 3);
    await Future<void>.delayed(Duration.zero);
    expect(diagnostics.single.exitCode, 3);
    expect(diagnostics.single.message, isNot(contains('fake process failure')));
    await runtime.close();
  });

  test('kills an unresponsive owned process after the grace period', () async {
    final runtime = await CodexRuntime.start(
      options: CodexAdapterOptions(
        executable: _fakeExecutable,
        environment: <String, String>{
          ...Platform.environment,
          'FAKE_CODEX_MODE': 'hang',
        },
        shutdownTimeout: const Duration(milliseconds: 20),
      ),
    );

    await runtime.close();
    expect(await runtime.exitCode, isNot(0));
  });
}
