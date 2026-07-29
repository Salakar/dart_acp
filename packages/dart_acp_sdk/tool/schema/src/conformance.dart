import 'conformance_fixture.dart';
import 'json_schema.dart';
import 'method_emitter.dart';
import 'naming.dart';
import 'validator.dart';

/// Expected handling of an injected unknown object member.
enum ConformanceUnknownBehavior {
  /// No unknown-member assertion applies.
  none,

  /// A closed generated model must drop the member.
  dropped,

  /// An explicit open boundary must preserve the member.
  preserved,
}

/// One generated codec exercise.
final class ConformanceCasePlan {
  /// Creates a codec case plan.
  ConformanceCasePlan({
    required this.id,
    required this.definition,
    required this.label,
    required this.fixture,
    required Iterable<String> features,
    this.rejects = false,
    this.exerciseFactory = false,
    this.unknownBehavior = ConformanceUnknownBehavior.none,
    this.prototypeDropped = false,
    Iterable<String> absentFields = const <String>[],
    Iterable<String> nullFields = const <String>[],
    Iterable<String> presentFields = const <String>[],
    this.listField,
    this.listLength,
  }) : features = List<String>.unmodifiable(features),
       absentFields = List<String>.unmodifiable(absentFields),
       nullFields = List<String>.unmodifiable(nullFields),
       presentFields = List<String>.unmodifiable(presentFields);

  /// Globally unique deterministic case ID.
  final String id;

  /// `$defs` name whose codec is exercised.
  final String definition;

  /// Stable path label within the definition.
  final String label;

  /// JSON-compatible input value.
  final Object? fixture;

  /// Semantic behaviors exercised by this case.
  final List<String> features;

  /// Whether decoding must reject this input.
  final bool rejects;

  /// Whether the generated public `fromJson` factory is exercised directly.
  final bool exerciseFactory;

  /// Expected behavior for [conformanceUnknownProperty].
  final ConformanceUnknownBehavior unknownBehavior;

  /// Whether [conformancePrototypeProperty] must be absent after encoding.
  final bool prototypeDropped;

  /// Fields expected to be omitted after encoding.
  final List<String> absentFields;

  /// Fields expected to encode as explicit JSON null.
  final List<String> nullFields;

  /// Required fields expected to remain present after encoding.
  final List<String> presentFields;

  /// A filtered list field whose encoded length is asserted.
  final String? listField;

  /// Expected encoded [listField] length.
  final int? listLength;

  /// Machine-readable representation excluding bulky fixture contents.
  Map<String, Object?> toReportJson(List<String> declarations) =>
      <String, Object?>{
        'id': id,
        'label': label,
        'features': features,
        'rejects': rejects,
        'exerciseFactory': exerciseFactory,
        'unknownBehavior': unknownBehavior.name,
        'prototypeDropped': prototypeDropped,
        'absentFields': absentFields,
        'nullFields': nullFields,
        'presentFields': presentFields,
        if (listField != null) 'listField': listField,
        if (listLength != null) 'listLength': listLength,
        'coveredDeclarations': declarations,
      };
}

/// One generated descriptor exercise.
final class ConformanceMethodPlan {
  /// Creates a method plan.
  const ConformanceMethodPlan({
    required this.index,
    required this.identifier,
    required this.fact,
    required this.paramsFixture,
    required this.resultFixture,
  });

  /// Position in the generated lane descriptor list.
  final int index;

  /// Emitted Dart constant name.
  final String identifier;

  /// Validated schema/metadata correlation.
  final MethodFact fact;

  /// Schema-valid parameters used through the descriptor codec.
  final Object? paramsFixture;

  /// Schema-valid result, or JSON null for notifications.
  final Object? resultFixture;

  /// Globally unique deterministic case ID.
  String get id =>
      'method:${fact.method}:${fact.side}:${fact.kind.name}:$identifier';

  /// Machine-readable representation.
  Map<String, Object?> toReportJson() => <String, Object?>{
    'id': id,
    'index': index,
    'identifier': identifier,
    'wireName': fact.method,
    'side': fact.side,
    'kind': fact.kind.name,
    'paramsDefinition': fact.paramsDefinition,
    'resultDefinition': fact.resultDefinition,
    'exercisesParamsCodec': true,
    'exercisesResultCodec': true,
  };
}

/// Exhaustive conformance plan for one physical generation lane.
final class ConformanceLanePlan {
  /// Creates a lane plan.
  ConformanceLanePlan({
    required this.name,
    required this.label,
    required this.schemaSource,
    required this.schemaSha256,
    required this.metadataSha256,
    required Map<String, List<String>> declarationsByDefinition,
    required Map<String, List<ConformanceCasePlan>> casesByDefinition,
    required Iterable<ConformanceMethodPlan> methods,
  }) : declarationsByDefinition = Map<String, List<String>>.unmodifiable(
         declarationsByDefinition,
       ),
       casesByDefinition = Map<String, List<ConformanceCasePlan>>.unmodifiable(
         casesByDefinition,
       ),
       methods = List<ConformanceMethodPlan>.unmodifiable(methods);

  /// Stable lower-camel lane name.
  final String name;

  /// Human-readable lane label.
  final String label;

  /// Manifest-relative official schema path.
  final String schemaSource;

  /// Pinned official schema digest.
  final String schemaSha256;

  /// Pinned official metadata digest.
  final String metadataSha256;

  /// Every emitted class/codec declaration grouped by `$defs` name.
  final Map<String, List<String>> declarationsByDefinition;

  /// Every executable codec path grouped by `$defs` name.
  final Map<String, List<ConformanceCasePlan>> casesByDefinition;

  /// Every emitted method descriptor.
  final List<ConformanceMethodPlan> methods;

  /// All codec cases in deterministic definition order.
  List<ConformanceCasePlan> get cases => <ConformanceCasePlan>[
    for (final List<ConformanceCasePlan> values in casesByDefinition.values)
      ...values,
  ];

  /// Every generated declaration with no assigned executable case.
  List<String> get uncoveredDeclarations => <String>[
    for (final MapEntry<String, List<String>> entry
        in declarationsByDefinition.entries)
      if (casesByDefinition[entry.key]?.isEmpty ?? true) ...entry.value,
  ];

  /// Every descriptor with no emitted method case.
  List<String> get uncoveredMethods => <String>[
    if (methods.isEmpty) 'lane:$name',
  ];

  /// Machine-readable completeness proof for this lane.
  Map<String, Object?> toReportJson() => <String, Object?>{
    'name': name,
    'label': label,
    'schemaSource': schemaSource,
    'schemaSha256': schemaSha256,
    'metadataSha256': metadataSha256,
    'definitionCount': casesByDefinition.length,
    'declarationCount': declarationsByDefinition.values.fold<int>(
      0,
      (int total, List<String> values) => total + values.length,
    ),
    'codecCaseCount': cases.length,
    'methodCount': methods.length,
    'definitions': <Object?>[
      for (final String definition in casesByDefinition.keys)
        <String, Object?>{
          'name': definition,
          'declarations': declarationsByDefinition[definition],
          'cases': <Object?>[
            for (final ConformanceCasePlan value
                in casesByDefinition[definition]!)
              value.toReportJson(declarationsByDefinition[definition]!),
          ],
        },
    ],
    'methods': <Object?>[
      for (final ConformanceMethodPlan method in methods) method.toReportJson(),
    ],
    'uncoveredDeclarations': uncoveredDeclarations,
    'uncoveredMethods': uncoveredMethods,
  };
}

/// Builds exhaustive codec and descriptor plans from pinned schema facts.
ConformanceLanePlan planConformanceLane({
  required String laneName,
  required String laneLabel,
  required String schemaSha256,
  required String metadataSha256,
  required SchemaDocument schema,
  required List<MethodFact> methods,
  required MethodEmitter methodEmitter,
  required Map<String, String> definitionSources,
}) {
  final NeutralFixtureFactory fixtures = NeutralFixtureFactory(schema);
  final declarations = <String, List<String>>{};
  final cases = <String, List<ConformanceCasePlan>>{};
  for (final SchemaDefinition definition in schema.definitions.values) {
    final String source = definitionSources[definition.name]!;
    declarations[definition.name] = _declarations(source);
    cases[definition.name] = _definitionCases(
      laneName: laneName,
      definition: definition,
      fixtures: fixtures,
      preservesUnknownBoundary: source.contains('final AcpJsonValue value;'),
    );
    if (declarations[definition.name]!.isEmpty) {
      throw StateError('No declarations emitted for ${definition.name}');
    }
    if (cases[definition.name]!.isEmpty) {
      throw StateError('No conformance cases emitted for ${definition.name}');
    }
  }
  final emittedMethods = methodEmitter.emittedMethods;
  if (emittedMethods.length != methods.length) {
    throw StateError('Method emission inventory diverged in $laneName');
  }
  return ConformanceLanePlan(
    name: laneName,
    label: laneLabel,
    schemaSource: schema.sourceName,
    schemaSha256: schemaSha256,
    metadataSha256: metadataSha256,
    declarationsByDefinition: declarations,
    casesByDefinition: cases,
    methods: <ConformanceMethodPlan>[
      for (int index = 0; index < emittedMethods.length; index += 1)
        ConformanceMethodPlan(
          index: index,
          identifier: emittedMethods[index].name,
          fact: emittedMethods[index].fact,
          paramsFixture: fixtures.fixtureForDefinition(
            emittedMethods[index].fact.paramsDefinition,
          ),
          resultFixture: emittedMethods[index].fact.resultDefinition == null
              ? null
              : fixtures.fixtureForDefinition(
                  emittedMethods[index].fact.resultDefinition!,
                ),
        ),
    ],
  );
}

List<ConformanceCasePlan> _definitionCases({
  required String laneName,
  required SchemaDefinition definition,
  required NeutralFixtureFactory fixtures,
  required bool preservesUnknownBoundary,
}) {
  final result = <ConformanceCasePlan>[];
  final List<ConformanceFixture> paths = fixtures.fixturesFor(definition);
  for (final ConformanceFixture path in paths) {
    Object? fixture = path.value;
    var unknownBehavior = ConformanceUnknownBehavior.none;
    var prototypeDropped = false;
    if (fixture is Map<String, Object?>) {
      fixture = <String, Object?>{
        ...fixture,
        conformanceUnknownProperty: 'preserved',
      };
      if (path.isOpenPath || preservesUnknownBoundary) {
        unknownBehavior = ConformanceUnknownBehavior.preserved;
      } else {
        unknownBehavior = ConformanceUnknownBehavior.dropped;
      }
      if (path.label == 'tag:custom') {
        fixture[conformancePrototypeProperty] = <String, Object?>{
          'polluted': true,
        };
        prototypeDropped = true;
      }
    }
    result.add(
      ConformanceCasePlan(
        id: '$laneName:${definition.name}:${path.label}',
        definition: definition.name,
        label: path.label,
        fixture: fixture,
        features: <String>[
          'roundTrip',
          _definitionFeature(definition),
          if (unknownBehavior != ConformanceUnknownBehavior.none) 'unknowns',
          if (prototypeDropped) 'prototypeScrub',
        ],
        exerciseFactory:
            definition.kind == SchemaDefinitionKind.oneOf ||
            definition.kind == SchemaDefinitionKind.anyOf,
        unknownBehavior: unknownBehavior,
        prototypeDropped: prototypeDropped,
        presentFields: fixture is Map<String, Object?>
            ? fixture.keys
                  .where(
                    (String key) =>
                        key != conformanceUnknownProperty &&
                        key != conformancePrototypeProperty,
                  )
                  .toList(growable: false)
            : const <String>[],
      ),
    );
  }
  _addInvalidCases(laneName, definition, fixtures, result);
  _addDefaultCase(laneName, definition, fixtures, result);
  _addDefaultOmittedCase(laneName, definition, fixtures, result);
  _addPatchCases(laneName, definition, fixtures, result);
  _addMetaCase(laneName, definition, fixtures, result);
  _addListFilteringCases(laneName, definition, fixtures, result);
  _addTaggedRejectionCases(laneName, definition, fixtures, result);
  return List<ConformanceCasePlan>.unmodifiable(result);
}

void _addInvalidCases(
  String laneName,
  SchemaDefinition definition,
  NeutralFixtureFactory fixtures,
  List<ConformanceCasePlan> result,
) {
  for (final ConformanceFixture invalid in fixtures.invalidFixturesFor(
    definition,
  )) {
    result.add(
      ConformanceCasePlan(
        id: '$laneName:${definition.name}:${invalid.label}',
        definition: definition.name,
        label: invalid.label,
        fixture: invalid.value,
        features: const <String>['invalidShape'],
        rejects: true,
      ),
    );
  }
  for (final ConformanceFixture missing in fixtures.missingRequiredFixturesFor(
    definition,
  )) {
    result.add(
      ConformanceCasePlan(
        id: '$laneName:${definition.name}:${missing.label}',
        definition: definition.name,
        label: missing.label,
        fixture: missing.value,
        features: const <String>['invalidShape', 'missingRequired'],
        rejects: true,
      ),
    );
  }
}

void _addDefaultCase(
  String laneName,
  SchemaDefinition definition,
  NeutralFixtureFactory fixtures,
  List<ConformanceCasePlan> result,
) {
  final properties = definition.properties
      .where(
        (SchemaProperty property) =>
            property.defaultsOnError && !_isPatchProperty(definition, property),
      )
      .toList(growable: false);
  if (properties.isEmpty) {
    return;
  }
  final Object? base = fixtures.fixtureForDefinition(definition.name);
  if (base is! Map<String, Object?>) {
    return;
  }
  final value = <String, Object?>{...base};
  final invalidated = <String>[];
  for (final SchemaProperty property in properties) {
    final Object? invalid = fixtures.invalidForNode(property.node);
    if (!fixtures.isNoInvalidFixture(invalid)) {
      value[property.wireName] = invalid;
      invalidated.add(property.wireName);
    }
  }
  if (invalidated.isEmpty) {
    return;
  }
  result.add(
    ConformanceCasePlan(
      id: '$laneName:${definition.name}:defaults',
      definition: definition.name,
      label: 'defaults',
      fixture: value,
      features: <String>[
        'defaults',
        ...invalidated.map((String v) => 'field:$v'),
      ],
    ),
  );
}

void _addDefaultOmittedCase(
  String laneName,
  SchemaDefinition definition,
  NeutralFixtureFactory fixtures,
  List<ConformanceCasePlan> result,
) {
  final properties = definition.properties
      .where((SchemaProperty property) => property.node.hasDefault)
      .toList(growable: false);
  if (properties.isEmpty) {
    return;
  }
  final Object? base = fixtures.fixtureForDefinition(definition.name);
  if (base is! Map<String, Object?>) {
    return;
  }
  final value = <String, Object?>{...base};
  for (final SchemaProperty property in properties) {
    value.remove(property.wireName);
  }
  result.add(
    ConformanceCasePlan(
      id: '$laneName:${definition.name}:defaults:omitted',
      definition: definition.name,
      label: 'defaults:omitted',
      fixture: value,
      features: <String>[
        'defaults',
        'defaultOmitted',
        ...properties.map(
          (SchemaProperty property) => 'field:${property.wireName}',
        ),
      ],
    ),
  );
}

void _addPatchCases(
  String laneName,
  SchemaDefinition definition,
  NeutralFixtureFactory fixtures,
  List<ConformanceCasePlan> result,
) {
  if (!_isPatchLike(definition)) {
    return;
  }
  final fields = definition.properties
      .where(
        (SchemaProperty property) => _isPatchProperty(definition, property),
      )
      .map((SchemaProperty property) => property.wireName)
      .toList(growable: false);
  if (fields.isEmpty) {
    return;
  }
  final Object? base = fixtures.fixtureForDefinition(definition.name);
  if (base is! Map<String, Object?>) {
    return;
  }
  final omitted = <String, Object?>{...base}
    ..removeWhere((String key, Object? value) => fields.contains(key));
  result
    ..add(
      ConformanceCasePlan(
        id: '$laneName:${definition.name}:patch:omitted',
        definition: definition.name,
        label: 'patch:omitted',
        fixture: omitted,
        features: const <String>['patch', 'patchOmitted'],
        absentFields: fields,
      ),
    )
    ..add(
      ConformanceCasePlan(
        id: '$laneName:${definition.name}:patch:null',
        definition: definition.name,
        label: 'patch:null',
        fixture: <String, Object?>{
          ...base,
          for (final String field in fields) field: null,
        },
        features: const <String>['patch', 'patchNull'],
        nullFields: fields,
      ),
    );
}

void _addMetaCase(
  String laneName,
  SchemaDefinition definition,
  NeutralFixtureFactory fixtures,
  List<ConformanceCasePlan> result,
) {
  if (!definition.node.properties.containsKey('_meta')) {
    return;
  }
  final Object? base = fixtures.fixtureForDefinition(definition.name);
  if (base is! Map<String, Object?>) {
    return;
  }
  result.add(
    ConformanceCasePlan(
      id: '$laneName:${definition.name}:meta:invalid',
      definition: definition.name,
      label: 'meta:invalid',
      fixture: <String, Object?>{...base, '_meta': 'invalid-meta'},
      features: const <String>['meta', 'defaults'],
      absentFields: const <String>['_meta'],
    ),
  );
}

void _addListFilteringCases(
  String laneName,
  SchemaDefinition definition,
  NeutralFixtureFactory fixtures,
  List<ConformanceCasePlan> result,
) {
  final Object? base = fixtures.fixtureForDefinition(definition.name);
  if (base is! Map<String, Object?>) {
    return;
  }
  for (final SchemaProperty property in definition.properties.where(
    (SchemaProperty property) =>
        property.skipsInvalidItems && !_isPatchProperty(definition, property),
  )) {
    final SchemaNode? item = property.node.items;
    if (item == null) {
      continue;
    }
    final Object? invalid = fixtures.invalidForNode(item);
    if (fixtures.isNoInvalidFixture(invalid)) {
      continue;
    }
    final Object? existing = base[property.wireName];
    final Object? valid = existing is List<Object?> && existing.isNotEmpty
        ? existing.first
        : fixtures.fixtureForNode(item, contextName: property.wireName);
    result.add(
      ConformanceCasePlan(
        id: '$laneName:${definition.name}:list:${property.wireName}',
        definition: definition.name,
        label: 'list:${property.wireName}',
        fixture: <String, Object?>{
          ...base,
          property.wireName: <Object?>[valid, invalid],
        },
        features: const <String>['listFiltering'],
        listField: property.wireName,
        listLength: 1,
      ),
    );
  }
}

void _addTaggedRejectionCases(
  String laneName,
  SchemaDefinition definition,
  NeutralFixtureFactory fixtures,
  List<ConformanceCasePlan> result,
) {
  final TaggedUnionInfo? tagged = definition.taggedUnion;
  if (tagged == null) {
    return;
  }
  if (!tagged.isOpen) {
    result.add(
      ConformanceCasePlan(
        id: '$laneName:${definition.name}:tag:unknown-rejected',
        definition: definition.name,
        label: 'tag:unknown-rejected',
        fixture: <String, Object?>{tagged.propertyName: '_unknown/conformance'},
        features: const <String>['closedUnion', 'unknownTag'],
        rejects: true,
      ),
    );
  }
  for (final TaggedUnionVariant variant in tagged.variants) {
    final String? target = variant.targetDefinition;
    if (target == null) {
      continue;
    }
    final Map<String, Object?>? invalid = fixtures.invalidObjectFixture(target);
    if (invalid == null) {
      continue;
    }
    result.add(
      ConformanceCasePlan(
        id: '$laneName:${definition.name}:tag:${variant.tag}:invalid',
        definition: definition.name,
        label: 'tag:${variant.tag}:invalid',
        fixture: <String, Object?>{
          ...invalid,
          tagged.propertyName: variant.tag,
        },
        features: const <String>['taggedUnion', 'invalidKnownTag'],
        rejects: true,
      ),
    );
  }
}

List<String> _declarations(String source) {
  final values = <String>{};
  for (final RegExpMatch match in RegExp(
    r'^(?:final|sealed) class ([A-Za-z][A-Za-z0-9_]*)',
    multiLine: true,
  ).allMatches(source)) {
    values.add(match.group(1)!);
  }
  for (final RegExpMatch match in RegExp(
    r'^const [A-Za-z][A-Za-z0-9_]* ([A-Za-z][A-Za-z0-9_]*Codec) =',
    multiLine: true,
  ).allMatches(source)) {
    values.add(match.group(1)!);
  }
  return values.toList(growable: false)..sort();
}

String _definitionFeature(SchemaDefinition definition) {
  if (definition.taggedUnion != null) {
    return definition.taggedUnion!.isOpen ? 'openUnion' : 'closedUnion';
  }
  final Object? enumValue = definition.node.raw['enum'];
  if (enumValue is List<Object?> || _hasConstantBranch(definition.node)) {
    return 'enum';
  }
  return switch (definition.kind) {
    SchemaDefinitionKind.object => 'dto',
    SchemaDefinitionKind.oneOf || SchemaDefinitionKind.anyOf => 'union',
    SchemaDefinitionKind.string ||
    SchemaDefinitionKind.integer ||
    SchemaDefinitionKind.number ||
    SchemaDefinitionKind.boolean => 'scalar',
    SchemaDefinitionKind.array => 'array',
    SchemaDefinitionKind.unconstrained => 'jsonBoundary',
  };
}

bool _hasConstantBranch(SchemaNode node) => <SchemaNode>[
  ...node.children('oneOf'),
  ...node.children('anyOf'),
].any((SchemaNode child) => child.raw.containsKey('const'));

bool _isPatchLike(SchemaDefinition definition) {
  final String text = '${definition.name}\n${definition.description ?? ''}'
      .toLowerCase();
  return definition.name.contains('Update') ||
      const <String>{
        'AgentMessage',
        'AgentThought',
        'UserMessage',
      }.contains(definition.name) ||
      text.contains('patch semantics') ||
      text.contains('omitted fields leave') ||
      text.contains('omission means no change');
}

bool _isPatchProperty(SchemaDefinition definition, SchemaProperty property) =>
    property.wireName != '_meta' &&
    property.requiresPresenceTracking &&
    _isPatchLike(definition);

/// Exact descriptor direction enum member for [side].
String conformanceDirection(String side) => switch (side) {
  'agent' => 'clientToAgent',
  'client' => 'agentToClient',
  'protocol' => 'either',
  _ => throw StateError('Unknown method side $side'),
};

/// Exact descriptor method-kind enum member for [kind].
String conformanceMethodKind(MethodPayloadKind kind) => switch (kind) {
  MethodPayloadKind.request => 'request',
  MethodPayloadKind.notification => 'notification',
  MethodPayloadKind.response => throw StateError(
    'Response payload does not have a descriptor',
  ),
};

/// Lower-camel codec identifier for a schema definition.
String conformanceCodecName(String definition) =>
    '${dartMemberName(definition)}Codec';
