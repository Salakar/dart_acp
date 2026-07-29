import 'dart:convert';

import 'conformance.dart';
import 'naming.dart';
import 'validator.dart';

/// Package-relative directory containing generated conformance matrices.
const String conformanceOutputPath =
    'test/protocol/generated/conformance/generated';

/// Emits one platform-neutral executable conformance matrix.
Map<String, String> emitConformanceMatrix(ConformanceLanePlan plan) {
  final String baseName = _snakeName(plan.name);
  final String mainName = '${baseName}_matrix.dart';
  final chunks = <String>[
    for (final ConformanceCasePlan value in plan.cases) _emitCodecCase(value),
    for (final ConformanceMethodPlan method in plan.methods)
      _emitMethodCase(plan, method),
  ];
  return Map<String, String>.unmodifiable(<String, String>{
    '$conformanceOutputPath/$mainName': _emitMain(plan, chunks),
  });
}

/// Emits the checked machine-readable completeness proof.
String emitConformanceReport(Iterable<ConformanceLanePlan> plans) {
  final lanes = plans.toList(growable: false);
  final Object report = <String, Object?>{
    'formatVersion': 1,
    'generator': 'tool/schema/generate.dart',
    'laneCount': lanes.length,
    'definitionCount': lanes.fold<int>(
      0,
      (int total, ConformanceLanePlan lane) =>
          total + lane.casesByDefinition.length,
    ),
    'declarationCount': lanes.fold<int>(
      0,
      (int total, ConformanceLanePlan lane) =>
          total +
          lane.declarationsByDefinition.values.fold<int>(
            0,
            (int subtotal, List<String> declarations) =>
                subtotal + declarations.length,
          ),
    ),
    'codecCaseCount': lanes.fold<int>(
      0,
      (int total, ConformanceLanePlan lane) => total + lane.cases.length,
    ),
    'methodCount': lanes.fold<int>(
      0,
      (int total, ConformanceLanePlan lane) => total + lane.methods.length,
    ),
    'coveragePolicy': <String, Object?>{
      'minimumGeneratedLinePercent': 95,
      'wholeFileIgnoreCount': 0,
      'lineIgnoreCount': 0,
      'lineIgnores': <Object?>[],
    },
    'uncoveredDeclarations': <Object?>[
      for (final ConformanceLanePlan lane in lanes)
        for (final String declaration in lane.uncoveredDeclarations)
          <String, Object?>{'lane': lane.name, 'declaration': declaration},
    ],
    'uncoveredMethods': <Object?>[
      for (final ConformanceLanePlan lane in lanes)
        for (final String method in lane.uncoveredMethods)
          <String, Object?>{'lane': lane.name, 'method': method},
    ],
    'lanes': <Object?>[
      for (final ConformanceLanePlan lane in lanes) lane.toReportJson(),
    ],
  };
  return '${const JsonEncoder.withIndent('  ').convert(report)}\n';
}

String _emitMain(ConformanceLanePlan plan, List<String> chunks) {
  final String version = plan.name.startsWith('v1') ? 'v1' : 'v2';
  final String stability = plan.name.endsWith('Stable') ? 'stable' : 'unstable';
  final output = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Source: ${plan.schemaSource}')
    ..writeln('// SHA-256: ${plan.schemaSha256}')
    ..writeln()
    ..writeln("import 'package:dart_acp_sdk/src/protocol/method.dart';")
    ..writeln(
      "import 'package:dart_acp_sdk/src/protocol/$version/generated/"
      "$stability/method_descriptors.dart' as descriptors;",
    )
    ..writeln(
      "import 'package:dart_acp_sdk/src/protocol/$version/generated/"
      "$stability/models.dart' as models;",
    )
    ..writeln()
    ..writeln("import '../conformance_support.dart';");
  output
    ..writeln()
    ..writeln('/// Complete executable matrix for ${plan.label}.')
    ..writeln(
      'final List<AcpConformanceCase> ${plan.name}ConformanceCases = '
      '<AcpConformanceCase>[',
    );
  output.writeAll(chunks);
  output.writeln('];');
  return output.toString();
}

String _emitCodecCase(ConformanceCasePlan plan) {
  final String codec = 'models.${conformanceCodecName(plan.definition)}';
  final String fixture = dartStringLiteral(jsonEncode(plan.fixture));
  if (plan.rejects) {
    return "  rejectingCodecCase(${dartStringLiteral(plan.id)}, "
        '$codec, $fixture),\n';
  }
  final output = StringBuffer()
    ..writeln('  codecCase(')
    ..writeln('    ${dartStringLiteral(plan.id)},')
    ..writeln('    $codec,')
    ..writeln('    $fixture,');
  if (plan.exerciseFactory) {
    output.writeln(
      '    directDecode: (value) => Function.apply('
      'models.${dartTypeName(plan.definition)}.fromJson, <Object?>[value]),',
    );
  }
  if (plan.unknownBehavior != ConformanceUnknownBehavior.none) {
    output.writeln(
      '    unknownBehavior: AcpUnknownBehavior.'
      '${plan.unknownBehavior.name},',
    );
  }
  if (plan.prototypeDropped) {
    output.writeln('    prototypeDropped: true,');
  }
  if (plan.absentFields.isNotEmpty) {
    output.writeln(
      '    absentFields: ${_stringListLiteral(plan.absentFields)},',
    );
  }
  if (plan.nullFields.isNotEmpty) {
    output.writeln('    nullFields: ${_stringListLiteral(plan.nullFields)},');
  }
  if (plan.presentFields.isNotEmpty) {
    output.writeln(
      '    presentFields: ${_stringListLiteral(plan.presentFields)},',
    );
  }
  if (plan.listField != null) {
    output.writeln('    listField: ${dartStringLiteral(plan.listField!)},');
  }
  if (plan.listLength != null) {
    output.writeln('    listLength: ${plan.listLength},');
  }
  output.writeln('  ),');
  return output.toString();
}

String _emitMethodCase(ConformanceLanePlan lane, ConformanceMethodPlan method) {
  final MethodFact fact = method.fact;
  return (StringBuffer()
        ..writeln('  descriptorCase(')
        ..writeln('    ${dartStringLiteral(method.id)},')
        ..writeln('    descriptors.${method.identifier},')
        ..writeln('    descriptors.${lane.name}MethodRegistry,')
        ..writeln('    name: ${dartStringLiteral(fact.method)},')
        ..writeln(
          '    paramsDefinition: '
          '${dartStringLiteral(fact.paramsDefinition)},',
        )
        ..writeln(
          '    resultDefinition: '
          '${fact.resultDefinition == null ? 'null' : dartStringLiteral(fact.resultDefinition!)},',
        )
        ..writeln(
          '    direction: AcpMethodDirection.'
          '${conformanceDirection(fact.side)},',
        )
        ..writeln(
          '    kind: AcpMethodKind.'
          '${conformanceMethodKind(fact.kind)},',
        )
        ..writeln(
          '    paramsFixtureJson: '
          '${dartStringLiteral(jsonEncode(method.paramsFixture))},',
        )
        ..writeln(
          '    resultFixtureJson: '
          '${dartStringLiteral(jsonEncode(method.resultFixture))},',
        )
        ..writeln('  ),'))
      .toString();
}

String _stringListLiteral(List<String> values) =>
    '<String>[${values.map(dartStringLiteral).join(', ')}]';

String _snakeName(String value) => value.replaceAllMapped(
  RegExp(r'([a-z0-9])([A-Z])'),
  (Match match) => '${match.group(1)}_${match.group(2)!.toLowerCase()}',
);
