import 'json_schema.dart';

/// Sentinel property used to verify closed-object unknown-field behavior.
const String conformanceUnknownProperty = '__acp_unknown_fixture__';

/// Sentinel property used to verify prototype-pollution scrubbing.
const String conformancePrototypeProperty = '__proto__';

/// One deterministic wire fixture for a serializer path.
final class ConformanceFixture {
  /// Creates a fixture.
  const ConformanceFixture({
    required this.label,
    required this.value,
    this.isOpenPath = false,
  });

  /// Stable path label within its schema definition.
  final String label;

  /// JSON-compatible wire value.
  final Object? value;

  /// Whether unknown object members are part of the represented value.
  final bool isOpenPath;
}

/// Synthesizes deterministic, schema-valid neutral wire values.
final class NeutralFixtureFactory {
  /// Creates a fixture factory for [schema].
  const NeutralFixtureFactory(this.schema);

  /// Source schema.
  final SchemaDocument schema;

  /// Produces every distinct serializer path for [definition].
  List<ConformanceFixture> fixturesFor(SchemaDefinition definition) {
    final TaggedUnionInfo? tagged = definition.taggedUnion;
    if (tagged != null) {
      final branches = definition.kind == SchemaDefinitionKind.oneOf
          ? definition.node.children('oneOf')
          : definition.node.children('anyOf');
      final fixtures = <ConformanceFixture>[];
      for (final TaggedUnionVariant variant in tagged.variants) {
        final int branchIndex = branches.indexWhere(
          (SchemaNode candidate) =>
              candidate.properties[tagged.propertyName]?.constant ==
              variant.tag,
        );
        fixtures.add(
          ConformanceFixture(
            label: 'tag:${variant.tag}',
            value: _fixtureDefinitionBranch(definition, branchIndex),
          ),
        );
      }
      if (tagged.isOpen) {
        final Object? known = _fixtureDefinitionBranch(definition, 0);
        final Map<String, Object?> common = known is Map<String, Object?>
            ? known
            : const <String, Object?>{};
        fixtures.add(
          ConformanceFixture(
            label: 'tag:custom',
            value: <String, Object?>{
              ...common,
              tagged.propertyName: '_vendor/conformance',
              conformanceUnknownProperty: 'preserved',
              conformancePrototypeProperty: <String, Object?>{'polluted': true},
            },
            isOpenPath: true,
          ),
        );
      }
      return List<ConformanceFixture>.unmodifiable(fixtures);
    }

    final List<Object?> enumValues = _enumValues(definition.node);
    if (enumValues.isNotEmpty) {
      return List<ConformanceFixture>.unmodifiable(<ConformanceFixture>[
        for (int index = 0; index < enumValues.length; index += 1)
          ConformanceFixture(label: 'enum:$index', value: enumValues[index]),
        if (_hasOpenStringBranch(definition.node))
          const ConformanceFixture(
            label: 'enum:custom',
            value: '_vendor/conformance',
            isOpenPath: true,
          ),
      ]);
    }

    final List<SchemaNode> branches =
        definition.kind == SchemaDefinitionKind.oneOf
        ? definition.node.children('oneOf')
        : definition.kind == SchemaDefinitionKind.anyOf
        ? definition.node.children('anyOf')
        : const <SchemaNode>[];
    if (branches.isNotEmpty) {
      return List<ConformanceFixture>.unmodifiable(<ConformanceFixture>[
        for (int index = 0; index < branches.length; index += 1)
          ConformanceFixture(
            label: 'branch:$index',
            value: _fixtureDefinitionBranch(definition, index),
            isOpenPath: _isOpenNode(branches[index]),
          ),
      ]);
    }

    return <ConformanceFixture>[
      ConformanceFixture(
        label: 'value',
        value: fixtureForDefinition(definition.name),
        isOpenPath: definition.kind == SchemaDefinitionKind.unconstrained,
      ),
    ];
  }

  /// Produces one schema-valid value for a named definition.
  Object? fixtureForDefinition(String name) {
    final SchemaDefinition? definition = schema.definitions[name];
    if (definition == null) {
      throw StateError('Unknown fixture definition $name');
    }
    return _fixtureDefinition(definition, <String>{name});
  }

  /// Produces one schema-valid value for an inline schema [node].
  Object? fixtureForNode(SchemaNode node, {String contextName = 'fixture'}) =>
      _fixtureNode(node, contextName: contextName, stack: <String>{});

  /// Produces deterministic invalid values for a named [definition].
  List<ConformanceFixture> invalidFixturesFor(SchemaDefinition definition) {
    final fixtures = <ConformanceFixture>[];

    void add(String label, Object? value) {
      if (!fixtures.any(
        (ConformanceFixture fixture) => fixture.value == value,
      )) {
        fixtures.add(ConformanceFixture(label: label, value: value));
      }
    }

    final Object? wrongShape = _invalidForDefinition(definition);
    if (!isNoInvalidFixture(wrongShape)) {
      add('invalid:shape', wrongShape);
    }

    final List<Object?> enumValues = _enumValues(definition.node);
    if (enumValues.isNotEmpty && !_hasOpenStringBranch(definition.node)) {
      add('invalid:enum', '_invalid/conformance');
    }
    if (definition.name == 'AbsolutePath') {
      add('invalid:absolute-path', 'relative/conformance');
    }
    if (definition.kind == SchemaDefinitionKind.string &&
        definition.name.endsWith('Id')) {
      add('invalid:empty-id', '');
    }

    final Object? minimumLength = definition.node.raw['minLength'];
    if (minimumLength is int && minimumLength > 0) {
      add('invalid:min-length', '');
    }
    final Object? maximumLength = definition.node.raw['maxLength'];
    if (maximumLength is int) {
      add('invalid:max-length', 'x' * (maximumLength + 1));
    }
    final Object? pattern = definition.node.raw['pattern'];
    if (pattern is String) {
      final expression = RegExp(pattern);
      for (final String candidate in const <String>[
        '',
        '!',
        '_invalid/conformance',
      ]) {
        if (!expression.hasMatch(candidate)) {
          add('invalid:pattern', candidate);
          break;
        }
      }
    }

    final Object? minimum = definition.node.raw['minimum'];
    if (minimum is num) {
      add('invalid:minimum', minimum - 1);
    }
    final Object? maximum = definition.node.raw['maximum'];
    if (maximum is num) {
      add('invalid:maximum', maximum + 1);
    }
    return List<ConformanceFixture>.unmodifiable(fixtures);
  }

  /// Produces one missing-field fixture for each required object property.
  List<ConformanceFixture> missingRequiredFixturesFor(
    SchemaDefinition definition,
  ) {
    final Object? base = fixtureForDefinition(definition.name);
    if (base is! Map<String, Object?>) {
      return const <ConformanceFixture>[];
    }
    return List<ConformanceFixture>.unmodifiable(<ConformanceFixture>[
      for (final SchemaProperty property in definition.properties.where(
        (SchemaProperty property) => property.isRequired,
      ))
        ConformanceFixture(
          label: 'invalid:missing:${property.wireName}',
          value: <String, Object?>{...base}..remove(property.wireName),
        ),
    ]);
  }

  /// Produces a value guaranteed to be invalid for [node], when possible.
  Object? invalidForNode(SchemaNode node) {
    final String? reference = node.reference ?? _singleReference(node);
    if (reference != null) {
      final SchemaDefinition? definition = schema.definitions[reference];
      if (definition == null) {
        return const _NoInvalidFixture();
      }
      return _invalidForDefinition(definition);
    }
    final List<SchemaNode> alternatives = _alternatives(node);
    if (alternatives.isNotEmpty) {
      final nonNull = alternatives
          .where((SchemaNode child) => !child.typeNames.contains('null'))
          .toList(growable: false);
      if (nonNull.length == 1) {
        return invalidForNode(nonNull.single);
      }
      return const _NoInvalidFixture();
    }
    final Set<String> types = node.typeNames;
    if (types.contains('string')) {
      return 42;
    }
    if (types.contains('integer') || types.contains('number')) {
      return 'not-a-number';
    }
    if (types.contains('boolean')) {
      return 'not-a-boolean';
    }
    if (types.contains('array')) {
      return <String, Object?>{'not': 'an-array'};
    }
    if (types.contains('object') || node.properties.isNotEmpty) {
      return 'not-an-object';
    }
    return const _NoInvalidFixture();
  }

  /// Whether [value] represents the absence of a reliable invalid fixture.
  bool isNoInvalidFixture(Object? value) => value is _NoInvalidFixture;

  /// Corrupts a strict field in [definition], when one is available.
  Map<String, Object?>? invalidObjectFixture(String definitionName) {
    final SchemaDefinition? definition = schema.definitions[definitionName];
    if (definition == null ||
        (definition.kind != SchemaDefinitionKind.object &&
            definition.properties.isEmpty)) {
      return null;
    }
    final Object? fixture = fixtureForDefinition(definitionName);
    if (fixture is! Map<String, Object?>) {
      return null;
    }
    for (final SchemaProperty property in definition.properties) {
      if (property.defaultsOnError ||
          property.skipsInvalidItems ||
          property.wireName == '_meta') {
        continue;
      }
      final Object? invalid = invalidForNode(property.node);
      if (isNoInvalidFixture(invalid)) {
        continue;
      }
      return <String, Object?>{...fixture, property.wireName: invalid};
    }
    return null;
  }

  Object? _fixtureDefinition(SchemaDefinition definition, Set<String> stack) {
    final List<SchemaNode> alternatives = _alternatives(definition.node);
    return _fixtureNode(
      definition.node,
      contextName: definition.name,
      stack: stack,
      selectedBranch: alternatives.isEmpty ? null : 0,
    );
  }

  Object? _fixtureDefinitionBranch(SchemaDefinition definition, int index) {
    return _fixtureNode(
      definition.node,
      contextName: definition.name,
      stack: <String>{definition.name},
      selectedBranch: index,
    );
  }

  Object? _fixtureNode(
    SchemaNode node, {
    required String contextName,
    required Set<String> stack,
    int? selectedBranch,
  }) {
    if (node.raw.containsKey('const')) {
      return node.constant;
    }
    final Object? enumValue = _firstEnumValue(node);
    if (enumValue != null) {
      return enumValue;
    }
    final String? reference = node.reference;
    if (reference != null) {
      return _fixtureReference(reference, stack);
    }

    final List<SchemaNode> inherited = node.children('allOf');
    final List<SchemaNode> alternatives = _alternatives(node);
    Object? composed;
    var hasComposition = false;
    if (inherited.isNotEmpty) {
      for (final SchemaNode child in inherited) {
        hasComposition = true;
        composed = _mergeFixtures(
          composed,
          _fixtureNode(child, contextName: contextName, stack: stack),
        );
      }
    }
    if (alternatives.isNotEmpty) {
      hasComposition = true;
      final int branchIndex = selectedBranch == null
          ? _preferredBranch(alternatives)
          : selectedBranch.clamp(0, alternatives.length - 1);
      composed = _mergeFixtures(
        composed,
        _fixtureNode(
          alternatives[branchIndex],
          contextName: contextName,
          stack: stack,
        ),
      );
    }

    final Set<String> types = node.typeNames;
    if (types.contains('object') || node.properties.isNotEmpty) {
      final object = <String, Object?>{};
      if (composed is Map<String, Object?>) {
        object.addAll(composed);
      }
      for (final MapEntry<String, SchemaNode> property
          in node.properties.entries) {
        try {
          object[property.key] = property.key == '_meta'
              ? <String, Object?>{'conformance': true}
              : _fixtureNode(
                  property.value,
                  contextName: property.key,
                  stack: stack,
                );
        } on _RecursiveFixture {
          if (node.requiredNames.contains(property.key)) {
            rethrow;
          }
        }
      }
      final SchemaNode? additional = node.additionalProperties;
      if (additional != null && object.isEmpty) {
        object['fixture'] = _fixtureNode(
          additional,
          contextName: 'fixture',
          stack: stack,
        );
      } else if (node.raw['additionalProperties'] == true && object.isEmpty) {
        object['fixture'] = true;
      }
      return object;
    }
    if (hasComposition) {
      return composed;
    }
    if (types.contains('string')) {
      return _stringFixture(node, contextName);
    }
    if (types.contains('integer')) {
      return _integerFixture(node);
    }
    if (types.contains('number')) {
      return _numberFixture(node);
    }
    if (types.contains('boolean')) {
      return true;
    }
    if (types.contains('array')) {
      final SchemaNode item =
          node.items ?? SchemaNode(const <String, Object?>{});
      final int minimum = node.raw['minItems'] is int
          ? node.raw['minItems']! as int
          : 1;
      final int maximum = node.raw['maxItems'] is int
          ? node.raw['maxItems']! as int
          : minimum < 1
          ? 1
          : minimum;
      final int count = maximum == 0 ? 0 : minimum.clamp(1, maximum);
      return <Object?>[
        for (int index = 0; index < count; index += 1)
          _fixtureNode(item, contextName: contextName, stack: stack),
      ];
    }
    if (types.contains('null')) {
      return null;
    }
    return <String, Object?>{'fixture': true};
  }

  Object? _fixtureReference(String name, Set<String> stack) {
    if (stack.contains(name)) {
      throw _RecursiveFixture(name);
    }
    final SchemaDefinition? definition = schema.definitions[name];
    if (definition == null) {
      throw StateError('Unknown referenced definition $name');
    }
    return _fixtureDefinition(definition, <String>{...stack, name});
  }

  Object? _invalidForDefinition(SchemaDefinition definition) {
    if (definition.taggedUnion != null) {
      return 'not-an-object';
    }
    if (definition.kind == SchemaDefinitionKind.object ||
        definition.properties.isNotEmpty) {
      return 'not-an-object';
    }
    return invalidForNode(definition.node);
  }
}

List<SchemaNode> _alternatives(SchemaNode node) =>
    node.children('oneOf').isNotEmpty
    ? node.children('oneOf')
    : node.children('anyOf');

String? _singleReference(SchemaNode node) {
  final List<SchemaNode> inherited = node.children('allOf');
  return inherited.length == 1 ? inherited.single.reference : null;
}

List<Object?> _enumValues(SchemaNode node) {
  final values = <Object?>[];
  final Object? direct = node.raw['enum'];
  if (direct is List<Object?>) {
    values.addAll(direct);
  }
  for (final SchemaNode child in _alternatives(node)) {
    if (child.raw.containsKey('const')) {
      values.add(child.constant);
    }
  }
  return values;
}

Object? _firstEnumValue(SchemaNode node) {
  final List<Object?> values = _enumValues(node);
  return values.isEmpty ? null : values.first;
}

bool _hasOpenStringBranch(SchemaNode node) => _alternatives(node).any(
  (SchemaNode child) =>
      child.typeNames.contains('string') &&
      !child.raw.containsKey('const') &&
      child.raw['enum'] == null,
);

bool _isOpenNode(SchemaNode node) =>
    node.raw['additionalProperties'] == true ||
    node.raw['unevaluatedProperties'] == true ||
    (node.typeNames.contains('string') &&
        !node.raw.containsKey('const') &&
        node.raw['enum'] == null);

int _preferredBranch(List<SchemaNode> branches) {
  for (int index = 0; index < branches.length; index += 1) {
    if (!branches[index].typeNames.contains('null')) {
      return index;
    }
  }
  return 0;
}

Object? _mergeFixtures(Object? left, Object? right) {
  if (left == null) {
    return right;
  }
  if (right == null) {
    return left;
  }
  if (left is Map<String, Object?> && right is Map<String, Object?>) {
    return <String, Object?>{...left, ...right};
  }
  return right;
}

String _stringFixture(SchemaNode node, String contextName) {
  final Object? format = node.raw['format'];
  if (format == 'uri') {
    return 'https://example.test/conformance';
  }
  if (format == 'date-time') {
    return '2026-01-02T03:04:05Z';
  }
  if (format == 'regex') {
    return '.*';
  }
  if (node.raw['pattern'] == r'^[A-Z]{3}$') {
    return 'USD';
  }
  String value;
  if (contextName == 'AbsolutePath' ||
      contextName == 'cwd' ||
      contextName.toLowerCase().contains('path')) {
    value = '/workspace/conformance';
  } else if (contextName.endsWith('Id') ||
      contextName.toLowerCase().endsWith('id')) {
    value = 'fixture-id';
  } else {
    value = 'fixture';
  }
  final int minimum = node.raw['minLength'] is int
      ? node.raw['minLength']! as int
      : 0;
  if (value.length < minimum) {
    value = value.padRight(minimum, 'x');
  }
  final int? maximum = node.raw['maxLength'] is int
      ? node.raw['maxLength']! as int
      : null;
  if (maximum != null && value.length > maximum) {
    value = value.substring(0, maximum);
  }
  return value;
}

int _integerFixture(SchemaNode node) {
  final num? minimum = node.raw['minimum'] is num
      ? node.raw['minimum']! as num
      : null;
  final num? maximum = node.raw['maximum'] is num
      ? node.raw['maximum']! as num
      : null;
  var value = minimum?.ceil() ?? 1;
  if (maximum != null && value > maximum) {
    value = maximum.floor();
  }
  return value;
}

num _numberFixture(SchemaNode node) {
  final num? minimum = node.raw['minimum'] is num
      ? node.raw['minimum']! as num
      : null;
  final num? maximum = node.raw['maximum'] is num
      ? node.raw['maximum']! as num
      : null;
  num value = minimum == null ? 1.5 : minimum + 0.5;
  if (maximum != null && value > maximum) {
    value = maximum;
  }
  return value;
}

final class _RecursiveFixture implements Exception {
  const _RecursiveFixture(this.definition);

  final String definition;
}

final class _NoInvalidFixture {
  const _NoInvalidFixture();
}
