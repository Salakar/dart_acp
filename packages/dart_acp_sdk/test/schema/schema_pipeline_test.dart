@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../../tool/schema/src/drift.dart';
import '../../tool/schema/src/emitter.dart';
import '../../tool/schema/src/naming.dart';
import '../../tool/schema/src/schema_loader.dart';

void main() {
  late SchemaLoader loader;

  setUpAll(() {
    loader = SchemaLoader(Directory('tool/schema'));
  });

  test('manifest pins and verifies every source snapshot', () {
    final Map<String, List<int>> verified = loader.verifyAll();

    expect(
      loader.manifest.official.commit,
      '67ab340154fdfab4759a8046d31e82387ddc079a',
    );
    expect(
      loader.manifest.sdk.commit,
      'f1c01412e2c3e081f13f343b9e6586c5a4759b8f',
    );
    expect(verified, hasLength(12));
    expect(
      loader.loadSchema('snapshots/official/schema/v1/schema.json').definitions,
      hasLength(168),
    );
    expect(
      loader
          .loadSchema('snapshots/official/schema/v1/schema.unstable.json')
          .definitions,
      hasLength(260),
    );
    expect(
      loader.loadSchema('snapshots/official/schema/v2/schema.json').definitions,
      hasLength(172),
    );
    expect(
      loader
          .loadSchema('snapshots/official/schema/v2/schema.unstable.json')
          .definitions,
      hasLength(261),
    );
  });

  test('source-derived drift is fully explained', () {
    final DriftAllowlist allowlist = DriftAllowlist.fromJson(
      jsonDecode(File('tool/schema/drift_allowlist.json').readAsStringSync()),
    );
    final SchemaDriftReport report = computeSnapshotDrift(loader, allowlist);

    expect(unexplainedDrift(report, allowlist), isEmpty);
    expect(report.v1.sdkOnlyDefinitions, <String>[
      'AuthEnvVar',
      'AuthMethodEnvVar',
    ]);
    expect(report.v2.sdkOnlyDefinitions, <String>[
      'AuthEnvVar',
      'AuthMethodEnvVar',
    ]);
    expect(report.v1.matchingDefinitionCount, 231);
    expect(report.v2.matchingDefinitionCount, 230);
    expect(report.elicitationIsStableInV1, isTrue);
    expect(report.elicitationIsBaselineInV2, isTrue);
    expect(report.v2EnvironmentAuthenticationRemoved, isTrue);
    expect(report.v2TerminalAuthenticationIsUnstableOnly, isTrue);
  });

  test('each generation lane is deterministic and concretely typed', () {
    for (final GenerationLane lane in generationLanes) {
      final Map<String, String> first = emitLane(loader: loader, lane: lane);
      final Map<String, String> second = emitLane(loader: loader, lane: lane);

      expect(second, first);
      expect(first.length, 3);
      expect(first, contains('${lane.outputPath}/models.dart'));
      final String models = first['${lane.outputPath}/models.dart']!;
      expect(first, contains('${lane.outputPath}/method_descriptors.dart'));
      final String descriptors =
          first['${lane.outputPath}/method_descriptors.dart']!;
      expect(models, isNot(contains('final dynamic ')));
      expect(models, isNot(contains('final Object? ')));
      expect(descriptors, contains('AcpMethodDescriptor<'));
      expect(descriptors, contains('paramsDefinition:'));
      expect(descriptors, contains('resultDefinition:'));
      final RegExp foreignReference = RegExp(r'\[`[^`\r\n]+`\](?![\(\[])');
      expect(foreignReference.hasMatch(models), isFalse);
      expect(foreignReference.hasMatch(descriptors), isFalse);
      for (final MapEntry<String, String> entry in first.entries) {
        expect(
          entry.value,
          startsWith('// GENERATED CODE - DO NOT MODIFY BY HAND.'),
          reason: entry.key,
        );
      }
    }
  });

  test('generated/common/protocol layers do not import dart:io', () {
    final files = <File>[
      ...Directory(
        'lib/src/common',
      ).listSync(recursive: true).whereType<File>(),
      File('lib/src/protocol/method.dart'),
      File('lib/src/protocol/resilient_decoder.dart'),
      ...Directory(
        'lib/src/protocol/v1',
      ).listSync(recursive: true).whereType<File>(),
      ...Directory(
        'lib/src/protocol/v2',
      ).listSync(recursive: true).whereType<File>(),
    ];

    for (final File file in files) {
      expect(
        file.readAsStringSync(),
        isNot(contains("import 'dart:io'")),
        reason: file.path,
      );
    }
  });

  test('foreign schema references remain safe Dartdoc code spans', () {
    expect(
      sanitizeDartdoc(
        'See [`ContentBlock::Text`], [`AgentMessage::message_id`], and '
        '[`PromptCapabilities`](https://example.com).',
      ),
      'See `ContentBlock::Text`, `AgentMessage::message_id`, and '
      '[`PromptCapabilities`](https://example.com).',
    );
  });
}
