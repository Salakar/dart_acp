import 'dart:io';

import 'package:test/test.dart';

import 'support/tool_test_fixture.dart';

void main() {
  final repositoryRoot = Directory.current.absolute.path;
  final fileSizeScript =
      '$repositoryRoot${Platform.pathSeparator}tool'
      '${Platform.pathSeparator}check_file_sizes.dart';
  final coverageScript =
      '$repositoryRoot${Platform.pathSeparator}tool'
      '${Platform.pathSeparator}check_coverage.dart';
  final mergeCoverageScript =
      '$repositoryRoot${Platform.pathSeparator}tool'
      '${Platform.pathSeparator}merge_coverage.dart';

  group('check_file_sizes', () {
    test('accepts files at the configured limits', () async {
      final fixture = temporaryDirectory();
      addTearDown(() => fixture.deleteSync(recursive: true));
      writeLines(fixture, 'packages/example/lib/source.dart', 3);
      writeLines(fixture, 'packages/example/test/source_test.dart', 2);

      final result = await Process.run(Platform.resolvedExecutable, <String>[
        fileSizeScript,
        '--root=${fixture.path}',
        '--source-limit=3',
        '--test-limit=2',
      ]);

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect(result.stdout, contains('File-size guidance checked'));
    });

    test('reports source and test advisories without failing', () async {
      final fixture = temporaryDirectory();
      addTearDown(() => fixture.deleteSync(recursive: true));
      writeLines(fixture, 'packages/example/lib/source.dart', 4);
      writeLines(fixture, 'packages/example/test/source_test.dart', 3);

      final result = await Process.run(Platform.resolvedExecutable, <String>[
        fileSizeScript,
        '--root=${fixture.path}',
        '--source-limit=3',
        '--test-limit=2',
      ]);

      expect(result.exitCode, 0);
      expect(result.stdout, contains('source.dart: 4 lines'));
      expect(result.stdout, contains('source_test.dart: 3 lines'));
      expect(result.stdout, contains('2 advisory overage(s)'));
    });

    test('exempts explicitly marked generated Dart files', () async {
      final fixture = temporaryDirectory();
      addTearDown(() => fixture.deleteSync(recursive: true));
      final generated = writeLines(
        fixture,
        'packages/example/lib/generated_models.dart',
        10,
      );
      generated.writeAsStringSync(
        '// GENERATED CODE - DO NOT MODIFY BY HAND.\n'
        '${generated.readAsStringSync()}',
      );

      final result = await Process.run(Platform.resolvedExecutable, <String>[
        fileSizeScript,
        '--root=${fixture.path}',
        '--source-limit=3',
      ]);

      expect(result.exitCode, 0, reason: '${result.stderr}');
    });
  });

  group('check_coverage', () {
    test('accepts complete coverage above the threshold', () async {
      final fixture = temporaryDirectory();
      addTearDown(() => fixture.deleteSync(recursive: true));
      final source = writeLines(
        fixture,
        'packages/dart_acp_sdk/lib/source.dart',
        2,
      );
      final lcov = writeLcov(
        fixture,
        source: source,
        lineHits: const <int>[1, 1],
      );

      final result = await Process.run(Platform.resolvedExecutable, <String>[
        coverageScript,
        '--source-root=${source.parent.path}',
        '--minimum=100',
        lcov.path,
      ]);

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect(result.stdout, contains('100.00%'));
    });

    test('rejects coverage below the threshold', () async {
      final fixture = temporaryDirectory();
      addTearDown(() => fixture.deleteSync(recursive: true));
      final source = writeLines(
        fixture,
        'packages/dart_acp_sdk/lib/source.dart',
        2,
      );
      final lcov = writeLcov(
        fixture,
        source: source,
        lineHits: const <int>[1, 0],
      );

      final result = await Process.run(Platform.resolvedExecutable, <String>[
        coverageScript,
        '--source-root=${source.parent.path}',
        '--minimum=95',
        lcov.path,
      ]);

      expect(result.exitCode, 1);
      expect(result.stderr, contains('50.00%'));
    });

    test('rejects package sources absent from LCOV', () async {
      final fixture = temporaryDirectory();
      addTearDown(() => fixture.deleteSync(recursive: true));
      final covered = writeLines(
        fixture,
        'packages/dart_acp_sdk/lib/covered.dart',
        1,
      );
      writeLines(fixture, 'packages/dart_acp_sdk/lib/missing.dart', 1);
      final lcov = writeLcov(
        fixture,
        source: covered,
        lineHits: const <int>[1],
      );

      final result = await Process.run(Platform.resolvedExecutable, <String>[
        coverageScript,
        '--source-root=${covered.parent.path}',
        lcov.path,
      ]);

      expect(result.exitCode, 1);
      expect(result.stderr, contains('missing.dart'));
    });
  });

  test('merge_coverage unions VM and browser hits deterministically', () async {
    final fixture = temporaryDirectory();
    addTearDown(() => fixture.deleteSync(recursive: true));
    final source = writeLines(
      fixture,
      'packages/dart_acp_sdk/lib/source.dart',
      3,
    );
    final vm = writeLcov(
      fixture,
      source: source,
      lineHits: const <int>[1, 0, 1],
      name: 'vm.info',
    );
    final browser = writeLcov(
      fixture,
      source: source,
      lineHits: const <int>[0, 2, 0],
      name: 'browser.info',
    );
    final merged = File(
      '${fixture.path}${Platform.pathSeparator}coverage'
      '${Platform.pathSeparator}merged.info',
    );

    final mergeResult = await Process.run(Platform.resolvedExecutable, <String>[
      mergeCoverageScript,
      '--output=${merged.path}',
      vm.path,
      browser.path,
    ]);
    expect(mergeResult.exitCode, 0, reason: '${mergeResult.stderr}');
    expect(
      merged.readAsStringSync(),
      contains('DA:1,1\nDA:2,2\nDA:3,1\nLF:3\nLH:3'),
    );

    final checkResult = await Process.run(Platform.resolvedExecutable, <String>[
      coverageScript,
      '--source-root=${source.parent.path}',
      '--minimum=100',
      merged.path,
    ]);
    expect(checkResult.exitCode, 0, reason: '${checkResult.stderr}');
  });
}
