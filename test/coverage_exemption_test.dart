import 'dart:io';

import 'package:test/test.dart';

import 'support/tool_test_fixture.dart';

void main() {
  final coverageScript =
      '${Directory.current.absolute.path}${Platform.pathSeparator}tool'
      '${Platform.pathSeparator}check_coverage.dart';

  test('accepts structurally valid directive and const exemptions', () async {
    final fixture = temporaryDirectory();
    addTearDown(() => fixture.deleteSync(recursive: true));
    final source = writeLines(
      fixture,
      'packages/dart_acp_sdk/lib/source.dart',
      1,
    );
    writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/barrel.dart',
      '// coverage-exempt: directives-only\n'
          "export 'source.dart';\n",
    );
    writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/constants.dart',
      '// coverage-exempt: const-declarations-only\n'
          'const values = <String>{\'one\', \'two\'};\n',
    );
    final lcov = writeLcov(fixture, source: source, lineHits: const <int>[1]);

    final result = await _runGate(coverageScript, source, lcov);

    expect(result.exitCode, 0, reason: '${result.stderr}');
    expect(result.stdout, contains('2 structurally validated exemption(s)'));
  });

  test('rejects malformed and structurally false exemptions', () async {
    final fixture = temporaryDirectory();
    addTearDown(() => fixture.deleteSync(recursive: true));
    final covered = writeLines(
      fixture,
      'packages/dart_acp_sdk/lib/covered.dart',
      1,
    );
    writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/unknown.dart',
      '// coverage-exempt: hand-waved\n'
          "export 'covered.dart';\n",
    );
    writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/executable.dart',
      '// coverage-exempt: directives-only\n'
          'library;\n'
          'int calculate() => 42;\n',
    );
    writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/non_const.dart',
      '// coverage-exempt: const-declarations-only\n'
          'final timestamp = DateTime.now();\n',
    );
    final lcov = writeLcov(fixture, source: covered, lineHits: const <int>[1]);

    final result = await _runGate(coverageScript, covered, lcov);

    expect(result.exitCode, 1);
    expect(result.stderr, contains('unsupported or malformed exemption'));
    expect(result.stderr, contains('contains top-level declarations'));
    expect(
      result.stderr,
      contains('every top-level declaration must be const data'),
    );
  });

  test('validates abstract-declaration-only sources', () async {
    final fixture = temporaryDirectory();
    addTearDown(() => fixture.deleteSync(recursive: true));
    final covered = writeLines(
      fixture,
      'packages/dart_acp_sdk/lib/covered.dart',
      1,
    );
    final adapter = 'packages/dart_acp_sdk/lib/adapter.dart';
    writeSource(
      fixture,
      adapter,
      '// coverage-exempt: abstract-declarations-only\n'
      'abstract interface class Adapter {\n'
      '  bool get isSupported;\n'
      '  Future<void> close();\n'
      '}\n',
    );
    final lcov = writeLcov(fixture, source: covered, lineHits: const <int>[1]);

    final accepted = await _runGate(coverageScript, covered, lcov);
    expect(accepted.exitCode, 0, reason: '${accepted.stderr}');

    writeSource(
      fixture,
      adapter,
      '// coverage-exempt: abstract-declarations-only\n'
      'abstract class Adapter {\n'
      '  void close() {}\n'
      '}\n',
    );
    final rejected = await _runGate(coverageScript, covered, lcov);
    expect(rejected.exitCode, 1);
    expect(
      rejected.stderr,
      contains('abstract class methods must not have implementations'),
    );
  });

  test('requires conditional fallbacks to be unreachable defaults', () async {
    final fixture = temporaryDirectory();
    addTearDown(() => fixture.deleteSync(recursive: true));
    final factory = writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/adapter_factory.dart',
      "import 'adapter_stub.dart'\n"
          "    if (dart.library.io) 'adapter_io.dart';\n",
    );
    writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/adapter_stub.dart',
      '// coverage-exempt: conditional-fallback\n'
          'Never createAdapter() => throw UnsupportedError(\'unsupported\');\n',
    );
    final lcov = writeLcov(fixture, source: factory, lineHits: const <int>[1]);

    final accepted = await _runGate(coverageScript, factory, lcov);
    expect(accepted.exitCode, 0, reason: '${accepted.stderr}');

    writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/orphan_stub.dart',
      '// coverage-exempt: conditional-fallback\n'
          'Never createOrphan() => throw UnsupportedError(\'unsupported\');\n',
    );
    final rejected = await _runGate(coverageScript, factory, lcov);
    expect(rejected.exitCode, 1);
    expect(
      rejected.stderr,
      contains('not the default target of a conditional import'),
    );
  });

  test('rejects an exemption when LCOV finds executable lines', () async {
    final fixture = temporaryDirectory();
    addTearDown(() => fixture.deleteSync(recursive: true));
    writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/adapter_factory.dart',
      '// coverage-exempt: directives-only\n'
          "import 'adapter_stub.dart'\n"
          "    if (dart.library.io) 'adapter_io.dart';\n",
    );
    final fallback = writeSource(
      fixture,
      'packages/dart_acp_sdk/lib/adapter_stub.dart',
      '// coverage-exempt: conditional-fallback\n'
          'Never createAdapter() => throw UnsupportedError(\'unsupported\');\n',
    );
    final lcov = writeLcov(fixture, source: fallback, lineHits: const <int>[1]);

    final result = await _runGate(coverageScript, fallback, lcov);

    expect(result.exitCode, 1);
    expect(result.stderr, contains('LCOV reports 1 executable line(s)'));
  });
}

Future<ProcessResult> _runGate(String coverageScript, File source, File lcov) =>
    Process.run(Platform.resolvedExecutable, <String>[
      coverageScript,
      '--source-root=${source.parent.path}',
      lcov.path,
    ]);
