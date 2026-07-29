import 'conformance.dart';
import 'json_schema.dart';
import 'method_emitter.dart';
import 'model_emitter.dart';
import 'schema_loader.dart';
import 'validator.dart';

/// One physically isolated protocol-generation lane.
final class GenerationLane {
  /// Creates a generation lane.
  const GenerationLane({
    required this.protocolVersion,
    required this.isUnstable,
    required this.schemaPath,
    required this.metadataPath,
    required this.outputPath,
  });

  /// Protocol generation, either 1 or 2.
  final int protocolVersion;

  /// Whether this lane includes the unstable schema overlay.
  final bool isUnstable;

  /// Manifest-relative official schema path.
  final String schemaPath;

  /// Manifest-relative official metadata path.
  final String metadataPath;

  /// Package-relative output directory.
  final String outputPath;

  /// Stable lower-camel lane identifier.
  String get name => 'v$protocolVersion${isUnstable ? 'Unstable' : 'Stable'}';

  /// Human-readable lane label.
  String get label =>
      'ACP v$protocolVersion ${isUnstable ? 'unstable overlay' : 'baseline'}';
}

/// All checked-in generation lanes.
const List<GenerationLane> generationLanes = <GenerationLane>[
  GenerationLane(
    protocolVersion: 1,
    isUnstable: false,
    schemaPath: 'snapshots/official/schema/v1/schema.json',
    metadataPath: 'snapshots/official/schema/v1/meta.json',
    outputPath: 'lib/src/protocol/v1/generated/stable',
  ),
  GenerationLane(
    protocolVersion: 1,
    isUnstable: true,
    schemaPath: 'snapshots/official/schema/v1/schema.unstable.json',
    metadataPath: 'snapshots/official/schema/v1/meta.unstable.json',
    outputPath: 'lib/src/protocol/v1/generated/unstable',
  ),
  GenerationLane(
    protocolVersion: 2,
    isUnstable: false,
    schemaPath: 'snapshots/official/schema/v2/schema.json',
    metadataPath: 'snapshots/official/schema/v2/meta.json',
    outputPath: 'lib/src/protocol/v2/generated/stable',
  ),
  GenerationLane(
    protocolVersion: 2,
    isUnstable: true,
    schemaPath: 'snapshots/official/schema/v2/schema.unstable.json',
    metadataPath: 'snapshots/official/schema/v2/meta.unstable.json',
    outputPath: 'lib/src/protocol/v2/generated/unstable',
  ),
];

/// Generated sources and their executable conformance plan for one lane.
final class LaneEmission {
  /// Creates a lane emission.
  const LaneEmission({required this.sources, required this.conformance});

  /// Package-relative generated protocol sources.
  final Map<String, String> sources;

  /// Exhaustive generated codec/descriptor conformance plan.
  final ConformanceLanePlan conformance;
}

/// Emits all deterministic source files for one lane.
Map<String, String> emitLane({
  required SchemaLoader loader,
  required GenerationLane lane,
}) => emitLaneArtifacts(loader: loader, lane: lane).sources;

/// Emits deterministic sources plus the exhaustive conformance plan.
LaneEmission emitLaneArtifacts({
  required SchemaLoader loader,
  required GenerationLane lane,
}) {
  final SchemaDocument schema = loader.loadSchema(lane.schemaPath);
  final MethodMetadata metadata = loader.loadMetadata(lane.metadataPath);
  validateSchema(schema);
  final List<MethodFact> methods = validateAndCollectMethods(schema, metadata);
  final String schemaDigest = loader.manifest.entry(lane.schemaPath).sha256;
  final String metadataDigest = loader.manifest.entry(lane.metadataPath).sha256;
  final stability = <String, String>{};
  if (lane.isUnstable) {
    final GenerationLane baseline = generationLanes.firstWhere(
      (GenerationLane candidate) =>
          candidate.protocolVersion == lane.protocolVersion &&
          !candidate.isUnstable,
    );
    final MethodMetadata baselineMetadata = loader.loadMetadata(
      baseline.metadataPath,
    );
    final stableMethods = <String>{
      for (final method in baselineMetadata.methods) method.method,
    };
    for (final MethodFact method in methods) {
      stability[method.method] = stableMethods.contains(method.method)
          ? (lane.protocolVersion == 1 ? 'stable' : 'draft')
          : 'unstable';
    }
  }
  final modelEmitter = ModelEmitter(
    schema: schema,
    sourceDigest: schemaDigest,
    libraryLabel: lane.label,
  );
  final Map<String, String> models = <String, String>{
    'models.dart': modelEmitter.emit(),
  };
  final methodEmitter = MethodEmitter(
    schema: schema,
    methods: methods,
    protocolVersion: lane.protocolVersion,
    laneName: lane.name,
    stabilityByMethod: stability,
    sourceDigest: metadataDigest,
  );
  final Map<String, String> descriptors = <String, String>{
    'method_descriptors.dart': methodEmitter.emit(),
  };
  final String barrel = _emitBarrel(lane);
  final sources = Map<String, String>.unmodifiable(<String, String>{
    for (final MapEntry<String, String> entry in models.entries)
      '${lane.outputPath}/${entry.key}': entry.value,
    for (final MapEntry<String, String> entry in descriptors.entries)
      '${lane.outputPath}/${entry.key}': entry.value,
    '${lane.outputPath}/protocol.dart': barrel,
  });
  return LaneEmission(
    sources: sources,
    conformance: planConformanceLane(
      laneName: lane.name,
      laneLabel: lane.label,
      schemaSha256: schemaDigest,
      metadataSha256: metadataDigest,
      schema: schema,
      methods: methods,
      methodEmitter: methodEmitter,
      definitionSources: modelEmitter.emitDefinitionSources(),
    ),
  );
}

String _emitBarrel(GenerationLane lane) =>
    '// GENERATED CODE - DO NOT MODIFY BY HAND.\n'
    '// coverage-exempt: directives-only\n'
    '/// Generated ${lane.label} models and typed method descriptors.\n'
    "library;\n\n"
    "export 'method_descriptors.dart';\n"
    "export 'models.dart';\n";
