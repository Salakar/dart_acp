@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../../tool/schema/src/emitter.dart';
import '../../tool/schema/src/schema_loader.dart';
import '../../tool/schema/src/validator.dart';

void main() {
  late SchemaLoader loader;
  late Map<String, Object?> report;

  setUpAll(() {
    loader = SchemaLoader(Directory('tool/schema'));
    report = _map(
      jsonDecode(
        File('tool/schema/conformance_report.json').readAsStringSync(),
      ),
    );
  });

  test('report proves exact declarations and descriptors for every lane', () {
    expect(report['formatVersion'], 1);
    expect(report['laneCount'], generationLanes.length);
    expect(report['uncoveredDeclarations'], isEmpty);
    expect(report['uncoveredMethods'], isEmpty);
    final Map<String, Object?> coverage = _map(report['coveragePolicy']);
    expect(coverage['minimumGeneratedLinePercent'], 95);
    expect(coverage['wholeFileIgnoreCount'], 0);
    expect(coverage['lineIgnoreCount'], _coverageIgnoreLineCount());
    expect(coverage['lineIgnores'], isEmpty);

    final List<Object?> lanes = report['lanes']! as List<Object?>;
    final allCaseIds = <String>{};
    var definitionTotal = 0;
    var declarationTotal = 0;
    var caseTotal = 0;
    var methodTotal = 0;
    for (final GenerationLane lane in generationLanes) {
      final Map<String, Object?> laneReport = lanes
          .map(_map)
          .singleWhere(
            (Map<String, Object?> value) => value['name'] == lane.name,
          );
      final schema = loader.loadSchema(lane.schemaPath);
      final metadata = loader.loadMetadata(lane.metadataPath);
      final List<MethodFact> methods = validateAndCollectMethods(
        schema,
        metadata,
      );
      final List<Object?> definitions =
          laneReport['definitions']! as List<Object?>;
      final List<Object?> reportedMethods =
          laneReport['methods']! as List<Object?>;

      expect(
        definitions.map((Object? value) => _map(value)['name']).toSet(),
        schema.definitions.keys.toSet(),
        reason: lane.name,
      );
      expect(
        laneReport['schemaSha256'],
        loader.manifest.entry(lane.schemaPath).sha256,
      );
      expect(
        laneReport['metadataSha256'],
        loader.manifest.entry(lane.metadataPath).sha256,
      );

      final reportedDeclarations = <String>{};
      for (final Object? value in definitions) {
        final Map<String, Object?> definition = _map(value);
        final List<Object?> declarations =
            definition['declarations']! as List<Object?>;
        final List<Object?> cases = definition['cases']! as List<Object?>;
        expect(declarations, isNotEmpty, reason: definition['name']! as String);
        expect(cases, isNotEmpty, reason: definition['name']! as String);
        reportedDeclarations.addAll(declarations.cast<String>());
        for (final Object? caseValue in cases) {
          final Map<String, Object?> codecCase = _map(caseValue);
          expect(
            allCaseIds.add(codecCase['id']! as String),
            isTrue,
            reason: codecCase['id']! as String,
          );
          expect(
            (codecCase['coveredDeclarations']! as List<Object?>).toSet(),
            declarations.toSet(),
          );
        }
      }
      expect(
        reportedDeclarations,
        _actualModelDeclarations(lane),
        reason: lane.name,
      );

      final reportedIdentifiers = reportedMethods
          .map((Object? value) => _map(value)['identifier']! as String)
          .toSet();
      expect(reportedIdentifiers, _actualMethodIdentifiers(lane));
      expect(reportedMethods, hasLength(methods.length));
      for (final MethodFact method in methods) {
        expect(
          reportedMethods.map(_map),
          contains(
            allOf(
              containsPair('wireName', method.method),
              containsPair('side', method.side),
              containsPair('kind', method.kind.name),
              containsPair('paramsDefinition', method.paramsDefinition),
              containsPair('resultDefinition', method.resultDefinition),
            ),
          ),
        );
      }

      definitionTotal += definitions.length;
      declarationTotal += reportedDeclarations.length;
      caseTotal += definitions.fold<int>(
        0,
        (int total, Object? value) =>
            total + (_map(value)['cases']! as List<Object?>).length,
      );
      methodTotal += reportedMethods.length;
    }
    expect(report['definitionCount'], definitionTotal);
    expect(report['declarationCount'], declarationTotal);
    expect(report['codecCaseCount'], caseTotal);
    expect(report['methodCount'], methodTotal);
  });

  test('matrix includes every required semantic behavior', () {
    final features = <String>{};
    for (final Object? laneValue in report['lanes']! as List<Object?>) {
      for (final Object? definitionValue
          in _map(laneValue)['definitions']! as List<Object?>) {
        for (final Object? caseValue
            in _map(definitionValue)['cases']! as List<Object?>) {
          features.addAll(
            (_map(caseValue)['features']! as List<Object?>).cast<String>(),
          );
        }
      }
    }
    expect(
      features,
      containsAll(<String>[
        'dto',
        'enum',
        'openUnion',
        'closedUnion',
        'defaults',
        'patchOmitted',
        'patchNull',
        'meta',
        'unknowns',
        'unknownTag',
        'invalidKnownTag',
        'listFiltering',
        'invalidShape',
        'missingRequired',
        'defaultOmitted',
      ]),
    );
  });
}

int _coverageIgnoreLineCount() {
  var count = 0;
  for (final int version in const <int>[1, 2]) {
    final Directory root = Directory('lib/src/protocol/v$version/generated');
    for (final File file
        in root
            .listSync(recursive: true)
            .whereType<File>()
            .where((File file) => file.path.endsWith('.dart'))) {
      final String source = file.readAsStringSync();
      expect(
        source,
        isNot(contains('coverage:ignore-file')),
        reason: file.path,
      );
      count += 'coverage:ignore-line'.allMatches(source).length;
    }
  }
  return count;
}

Set<String> _actualModelDeclarations(GenerationLane lane) {
  final declarations = <String>{};
  for (final File file in _generatedParts(lane, 'models')) {
    final String source = file.readAsStringSync();
    declarations.addAll(
      RegExp(
        r'^(?:final|sealed) class ([A-Za-z][A-Za-z0-9_]*)',
        multiLine: true,
      ).allMatches(source).map((RegExpMatch match) => match.group(1)!),
    );
    declarations.addAll(
      RegExp(
        r'const\s+[A-Za-z][A-Za-z0-9_]*\s+'
        r'([A-Za-z][A-Za-z0-9_]*Codec)\s*=',
      ).allMatches(source).map((RegExpMatch match) => match.group(1)!),
    );
  }
  return declarations;
}

Set<String> _actualMethodIdentifiers(GenerationLane lane) {
  final identifiers = <String>{};
  for (final File file in _generatedParts(lane, 'method_descriptors')) {
    identifiers.addAll(
      RegExp(
            r'const AcpMethodDescriptor<[\s\S]*?>\s+([A-Za-z][A-Za-z0-9_]*)\s*=',
          )
          .allMatches(file.readAsStringSync())
          .map((RegExpMatch match) => match.group(1)!),
    );
  }
  return identifiers;
}

Iterable<File> _generatedParts(GenerationLane lane, String prefix) => <File>[
  File('${lane.outputPath}/$prefix.dart'),
];

Map<String, Object?> _map(Object? value) =>
    (value! as Map<Object?, Object?>).cast<String, Object?>();
