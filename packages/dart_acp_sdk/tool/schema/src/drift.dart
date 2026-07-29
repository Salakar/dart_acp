import 'dart:convert';

import 'json_schema.dart';
import 'schema_loader.dart';

/// An intentional set of differences between SDK and official schemas.
final class DriftAllowlist {
  /// Parses a drift allowlist.
  factory DriftAllowlist.fromJson(Object? json) {
    final root = _stringMap(json, 'drift allowlist');
    final int version = _integer(root['formatVersion'], 'formatVersion');
    if (version != 1) {
      throw FormatException('Unsupported drift allowlist version $version');
    }
    return DriftAllowlist._(
      sdkOnlyDefinitions: _stringList(
        root['sdkOnlyDefinitions'],
        'sdkOnlyDefinitions',
      ),
      officialOnlyDefinitions: _stringList(
        root['officialOnlyDefinitions'],
        'officialOnlyDefinitions',
      ),
      v1DifferingDefinitions: _stringList(
        root['v1DifferingDefinitions'],
        'v1DifferingDefinitions',
      ),
      v2DifferingDefinitions: _stringList(
        root['v2DifferingDefinitions'],
        'v2DifferingDefinitions',
      ),
      explanations: _stringMapValues(root['explanations'], 'explanations'),
    );
  }

  DriftAllowlist._({
    required this.sdkOnlyDefinitions,
    required this.officialOnlyDefinitions,
    required this.v1DifferingDefinitions,
    required this.v2DifferingDefinitions,
    required this.explanations,
  });

  /// Definitions expected only in the older SDK snapshots.
  final List<String> sdkOnlyDefinitions;

  /// Definitions expected only in official unstable snapshots.
  final List<String> officialOnlyDefinitions;

  /// Shared v1 definitions whose structures intentionally differ.
  final List<String> v1DifferingDefinitions;

  /// Shared v2 definitions whose structures intentionally differ.
  final List<String> v2DifferingDefinitions;

  /// Human-reviewed reasons for the known schema movement.
  final Map<String, String> explanations;
}

/// Structural differences for one protocol generation.
final class LaneDrift {
  /// Creates immutable lane drift.
  LaneDrift({
    required this.sdkOnlyDefinitions,
    required this.officialOnlyDefinitions,
    required this.differingDefinitions,
    required this.matchingDefinitionCount,
    required this.metadataMatches,
  });

  /// Names present only in the SDK snapshot.
  final List<String> sdkOnlyDefinitions;

  /// Names present only in the official snapshot.
  final List<String> officialOnlyDefinitions;

  /// Common definitions with unequal canonical JSON.
  final List<String> differingDefinitions;

  /// Common definitions with equal canonical JSON.
  final int matchingDefinitionCount;

  /// Whether SDK metadata equals official unstable metadata.
  final bool metadataMatches;

  /// Converts this lane to deterministic JSON.
  Map<String, Object?> toJson() => <String, Object?>{
    'sdkOnlyDefinitions': sdkOnlyDefinitions,
    'officialOnlyDefinitions': officialOnlyDefinitions,
    'differingDefinitions': differingDefinitions,
    'matchingDefinitionCount': matchingDefinitionCount,
    'metadataMatches': metadataMatches,
  };
}

/// Complete source-derived drift evidence.
final class SchemaDriftReport {
  /// Creates a drift report.
  SchemaDriftReport({
    required this.officialCommit,
    required this.sdkCommit,
    required this.v1,
    required this.v2,
    required this.elicitationIsStableInV1,
    required this.elicitationIsBaselineInV2,
    required this.v2EnvironmentAuthenticationRemoved,
    required this.v2TerminalAuthenticationIsUnstableOnly,
    required this.explanations,
  });

  /// Pinned official protocol commit.
  final String officialCommit;

  /// Pinned TypeScript SDK commit.
  final String sdkCommit;

  /// v1 SDK-to-official-unstable drift.
  final LaneDrift v1;

  /// v2 SDK-to-official-unstable drift.
  final LaneDrift v2;

  /// Whether elicitation definitions and methods occur in stable v1.
  final bool elicitationIsStableInV1;

  /// Whether elicitation definitions and methods occur in baseline v2.
  final bool elicitationIsBaselineInV2;

  /// Whether removed environment authentication is absent from official v2.
  final bool v2EnvironmentAuthenticationRemoved;

  /// Whether terminal authentication exists only in the v2 unstable overlay.
  final bool v2TerminalAuthenticationIsUnstableOnly;

  /// Reviewed explanations copied into the evidence report.
  final Map<String, String> explanations;

  /// Converts this report to deterministic JSON.
  Map<String, Object?> toJson() => <String, Object?>{
    'formatVersion': 1,
    'officialCommit': officialCommit,
    'sdkCommit': sdkCommit,
    'v1': v1.toJson(),
    'v2': v2.toJson(),
    'semanticEvidence': <String, Object?>{
      'elicitationIsStableInV1': elicitationIsStableInV1,
      'elicitationIsBaselineInV2': elicitationIsBaselineInV2,
      'v2EnvironmentAuthenticationRemoved': v2EnvironmentAuthenticationRemoved,
      'v2TerminalAuthenticationIsUnstableOnly':
          v2TerminalAuthenticationIsUnstableOnly,
    },
    'explanations': explanations,
  };
}

/// Computes SDK compatibility drift from all checked snapshots.
SchemaDriftReport computeSnapshotDrift(
  SchemaLoader loader,
  DriftAllowlist allowlist,
) {
  final SchemaDocument sdkV1 = loader.loadSchema(
    'snapshots/sdk/schema/schema.json',
  );
  final SchemaDocument sdkV2 = loader.loadSchema(
    'snapshots/sdk/schema/v2/schema.unstable.json',
  );
  final SchemaDocument stableV1 = loader.loadSchema(
    'snapshots/official/schema/v1/schema.json',
  );
  final SchemaDocument unstableV1 = loader.loadSchema(
    'snapshots/official/schema/v1/schema.unstable.json',
  );
  final SchemaDocument stableV2 = loader.loadSchema(
    'snapshots/official/schema/v2/schema.json',
  );
  final SchemaDocument unstableV2 = loader.loadSchema(
    'snapshots/official/schema/v2/schema.unstable.json',
  );
  final MethodMetadata sdkV1Metadata = loader.loadMetadata(
    'snapshots/sdk/schema/meta.json',
  );
  final MethodMetadata sdkV2Metadata = loader.loadMetadata(
    'snapshots/sdk/schema/v2/meta.unstable.json',
  );
  final MethodMetadata officialV1Metadata = loader.loadMetadata(
    'snapshots/official/schema/v1/meta.unstable.json',
  );
  final MethodMetadata officialV2Metadata = loader.loadMetadata(
    'snapshots/official/schema/v2/meta.unstable.json',
  );

  return SchemaDriftReport(
    officialCommit: loader.manifest.official.commit,
    sdkCommit: loader.manifest.sdk.commit,
    v1: _laneDrift(
      sdkV1,
      unstableV1,
      metadataMatches:
          _metadataShape(sdkV1Metadata) == _metadataShape(officialV1Metadata),
    ),
    v2: _laneDrift(
      sdkV2,
      unstableV2,
      metadataMatches:
          _metadataShape(sdkV2Metadata) == _metadataShape(officialV2Metadata),
    ),
    elicitationIsStableInV1:
        stableV1.definitions.containsKey('CreateElicitationRequest') &&
        _containsMethod(stableV1, 'elicitation/create'),
    elicitationIsBaselineInV2:
        stableV2.definitions.containsKey('CreateElicitationRequest') &&
        _containsMethod(stableV2, 'elicitation/create'),
    v2EnvironmentAuthenticationRemoved:
        !stableV2.definitions.containsKey('AuthEnvVar') &&
        !unstableV2.definitions.containsKey('AuthEnvVar') &&
        !stableV2.definitions.containsKey('AuthMethodEnvVar') &&
        !unstableV2.definitions.containsKey('AuthMethodEnvVar'),
    v2TerminalAuthenticationIsUnstableOnly:
        !stableV2.definitions.containsKey('TerminalAuthCapabilities') &&
        unstableV2.definitions.containsKey('TerminalAuthCapabilities'),
    explanations: allowlist.explanations,
  );
}

/// Returns review-required differences from [allowlist].
List<String> unexplainedDrift(
  SchemaDriftReport report,
  DriftAllowlist allowlist,
) {
  final issues = <String>[];
  _compareNames(
    issues,
    'v1 SDK-only definitions',
    report.v1.sdkOnlyDefinitions,
    allowlist.sdkOnlyDefinitions,
  );
  _compareNames(
    issues,
    'v2 SDK-only definitions',
    report.v2.sdkOnlyDefinitions,
    allowlist.sdkOnlyDefinitions,
  );
  _compareNames(
    issues,
    'v1 official-only definitions',
    report.v1.officialOnlyDefinitions,
    allowlist.officialOnlyDefinitions,
  );
  _compareNames(
    issues,
    'v2 official-only definitions',
    report.v2.officialOnlyDefinitions,
    allowlist.officialOnlyDefinitions,
  );
  _compareNames(
    issues,
    'v1 differing definitions',
    report.v1.differingDefinitions,
    allowlist.v1DifferingDefinitions,
  );
  _compareNames(
    issues,
    'v2 differing definitions',
    report.v2.differingDefinitions,
    allowlist.v2DifferingDefinitions,
  );
  if (!report.v1.metadataMatches) {
    issues.add('v1 method metadata differs without an allowlist');
  }
  if (!report.v2.metadataMatches) {
    issues.add('v2 method metadata differs without an allowlist');
  }
  if (!report.elicitationIsStableInV1) {
    issues.add('stable v1 no longer contains elicitation');
  }
  if (!report.elicitationIsBaselineInV2) {
    issues.add('baseline v2 no longer contains elicitation');
  }
  if (!report.v2EnvironmentAuthenticationRemoved) {
    issues.add('official v2 unexpectedly contains env_var authentication');
  }
  if (!report.v2TerminalAuthenticationIsUnstableOnly) {
    issues.add('v2 terminal authentication is not unstable-only');
  }
  return List<String>.unmodifiable(issues);
}

LaneDrift _laneDrift(
  SchemaDocument sdk,
  SchemaDocument official, {
  required bool metadataMatches,
}) {
  final sdkNames = sdk.definitions.keys.toSet();
  final officialNames = official.definitions.keys.toSet();
  final sdkOnly = sdkNames.difference(officialNames).toList()..sort();
  final officialOnly = officialNames.difference(sdkNames).toList()..sort();
  final common = sdkNames.intersection(officialNames).toList()..sort();
  final differing = <String>[];
  int matching = 0;
  for (final String name in common) {
    final String sdkShape = _canonicalJson(sdk.definitions[name]!.node.raw);
    final String officialShape = _canonicalJson(
      official.definitions[name]!.node.raw,
    );
    if (sdkShape == officialShape) {
      matching += 1;
    } else {
      differing.add(name);
    }
  }
  return LaneDrift(
    sdkOnlyDefinitions: List<String>.unmodifiable(sdkOnly),
    officialOnlyDefinitions: List<String>.unmodifiable(officialOnly),
    differingDefinitions: List<String>.unmodifiable(differing),
    matchingDefinitionCount: matching,
    metadataMatches: metadataMatches,
  );
}

bool _containsMethod(SchemaDocument schema, String method) =>
    schema.definitions.values.any(
      (SchemaDefinition definition) =>
          definition.node.raw['x-method'] == method,
    );

String _metadataShape(MethodMetadata metadata) {
  final values = <String>[
    for (final method in metadata.methods)
      '${method.side}\u0000${method.dartKey}\u0000${method.method}',
  ]..sort();
  return values.join('\u0001');
}

String _canonicalJson(Object? value) => jsonEncode(_canonicalValue(value));

Object? _canonicalValue(Object? value) {
  if (value is Map<Object?, Object?>) {
    final keys = value.keys.cast<String>().toList()..sort();
    return <String, Object?>{
      for (final String key in keys) key: _canonicalValue(value[key]),
    };
  }
  if (value is List<Object?>) {
    return <Object?>[for (final Object? item in value) _canonicalValue(item)];
  }
  return value;
}

void _compareNames(
  List<String> issues,
  String label,
  List<String> actual,
  List<String> expected,
) {
  final actualSorted = actual.toSet().toList()..sort();
  final expectedSorted = expected.toSet().toList()..sort();
  if (_listEquals(actualSorted, expectedSorted)) {
    return;
  }
  final added = actualSorted.toSet().difference(expectedSorted.toSet()).toList()
    ..sort();
  final removed =
      expectedSorted.toSet().difference(actualSorted.toSet()).toList()..sort();
  issues.add(
    '$label changed; unexplained=$added, '
    'resolvedButStillAllowlisted=$removed',
  );
}

bool _listEquals(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }
  for (int index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}

Map<String, Object?> _stringMap(Object? value, String context) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException('Expected an object at $context');
  }
  final result = <String, Object?>{};
  for (final MapEntry<Object?, Object?> entry in value.entries) {
    final Object? key = entry.key;
    if (key is! String) {
      throw FormatException('Expected string keys at $context');
    }
    result[key] = entry.value;
  }
  return result;
}

Map<String, String> _stringMapValues(Object? value, String context) {
  final raw = _stringMap(value, context);
  return Map<String, String>.unmodifiable(<String, String>{
    for (final MapEntry<String, Object?> entry in raw.entries)
      entry.key: _string(entry.value, '$context.${entry.key}'),
  });
}

List<String> _stringList(Object? value, String context) {
  if (value is! List<Object?>) {
    throw FormatException('Expected an array at $context');
  }
  final result = <String>[];
  for (int index = 0; index < value.length; index += 1) {
    result.add(_string(value[index], '$context[$index]'));
  }
  return List<String>.unmodifiable(result);
}

String _string(Object? value, String context) {
  if (value is! String) {
    throw FormatException('Expected a string at $context');
  }
  return value;
}

int _integer(Object? value, String context) {
  if (value is! int) {
    throw FormatException('Expected an integer at $context');
  }
  return value;
}
