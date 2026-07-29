/// The top-level shape of a normalized schema definition.
enum SchemaDefinitionKind {
  /// An object with named properties.
  object,

  /// A string or string-constrained value.
  string,

  /// An integer value.
  integer,

  /// A numeric value.
  number,

  /// A boolean value.
  boolean,

  /// An array value.
  array,

  /// A `oneOf` union.
  oneOf,

  /// An `anyOf` union.
  anyOf,

  /// A schema that accepts arbitrary JSON or uses unsupported composition.
  unconstrained,
}

/// A normalized JSON Schema node.
final class SchemaNode {
  /// Creates a schema node from [raw].
  SchemaNode(Map<String, Object?> raw)
    : raw = Map<String, Object?>.unmodifiable(raw);

  /// The original schema fields.
  final Map<String, Object?> raw;

  /// Human-readable schema documentation.
  String? get description =>
      raw['description'] is String ? raw['description']! as String : null;

  /// A referenced `$defs` name, when this node is a direct reference.
  String? get reference {
    final Object? value = raw[r'$ref'];
    if (value is! String || !value.startsWith(r'#/$defs/')) {
      return null;
    }
    return value.substring(r'#/$defs/'.length);
  }

  /// The schema's `const` value.
  Object? get constant => raw['const'];

  /// Whether the schema declares an explicit default.
  bool get hasDefault => raw.containsKey('default');

  /// The schema default, which may itself be `null`.
  Object? get defaultValue => raw['default'];

  /// Whether this node explicitly accepts JSON `null`.
  bool get isNullable =>
      typeNames.contains('null') ||
      _hasNullBranch ||
      (typeNames.isEmpty &&
          reference == null &&
          children('oneOf').isEmpty &&
          children('anyOf').isEmpty &&
          children('allOf').isEmpty);

  /// Declared JSON type names.
  Set<String> get typeNames {
    final Object? value = raw['type'];
    if (value is String) {
      return <String>{value};
    }
    if (value is List<Object?>) {
      return <String>{
        for (final Object? item in value)
          if (item is String) item,
      };
    }
    return const <String>{};
  }

  /// Child nodes from `oneOf`, `anyOf`, or `allOf`.
  List<SchemaNode> children(String keyword) {
    final Object? value = raw[keyword];
    if (value is! List<Object?>) {
      return const <SchemaNode>[];
    }
    return <SchemaNode>[
      for (final Object? item in value)
        SchemaNode(_stringMap(item, '$keyword item')),
    ];
  }

  /// The array item schema, when present.
  SchemaNode? get items {
    final Object? value = raw['items'];
    return value is Map<Object?, Object?>
        ? SchemaNode(_stringMap(value, 'items'))
        : null;
  }

  /// The map-value schema from `additionalProperties`, when typed.
  SchemaNode? get additionalProperties {
    final Object? value = raw['additionalProperties'];
    return value is Map<Object?, Object?>
        ? SchemaNode(_stringMap(value, 'additionalProperties'))
        : null;
  }

  /// Named object properties.
  Map<String, SchemaNode> get properties {
    final Object? value = raw['properties'];
    if (value == null) {
      return const <String, SchemaNode>{};
    }
    final map = _stringMap(value, 'properties');
    return Map<String, SchemaNode>.unmodifiable(<String, SchemaNode>{
      for (final MapEntry<String, Object?> entry in map.entries)
        entry.key: SchemaNode(_stringMap(entry.value, entry.key)),
    });
  }

  /// Required object property names.
  Set<String> get requiredNames {
    final Object? value = raw['required'];
    if (value is! List<Object?>) {
      return const <String>{};
    }
    final names = <String>{};
    for (final Object? item in value) {
      if (item is! String) {
        throw const FormatException('Schema required item must be a string');
      }
      names.add(item);
    }
    return Set<String>.unmodifiable(names);
  }

  /// Whether this node or a descendant uses [keyword].
  bool containsKeyword(String keyword) {
    if (raw.containsKey(keyword)) {
      return true;
    }
    for (final String composition in const <String>[
      'oneOf',
      'anyOf',
      'allOf',
    ]) {
      for (final SchemaNode child in children(composition)) {
        if (child.containsKeyword(keyword)) {
          return true;
        }
      }
    }
    final Object? items = raw['items'];
    if (items is Map<Object?, Object?> &&
        SchemaNode(_stringMap(items, 'items')).containsKeyword(keyword)) {
      return true;
    }
    for (final SchemaNode child in properties.values) {
      if (child.containsKeyword(keyword)) {
        return true;
      }
    }
    return false;
  }

  bool get _hasNullBranch {
    for (final String composition in const <String>['oneOf', 'anyOf']) {
      for (final SchemaNode child in children(composition)) {
        if (child.typeNames.contains('null')) {
          return true;
        }
      }
    }
    return false;
  }
}

/// A normalized object property.
final class SchemaProperty {
  /// Creates a normalized property.
  SchemaProperty({
    required this.wireName,
    required this.node,
    required this.isRequired,
  });

  /// The exact JSON property name.
  final String wireName;

  /// The property's schema.
  final SchemaNode node;

  /// Whether omission is invalid.
  final bool isRequired;

  /// Whether the property has default-on-error behavior.
  bool get defaultsOnError =>
      node.raw['x-deserialize-default-on-error'] == true;

  /// Whether invalid list entries are skipped.
  bool get skipsInvalidItems =>
      node.raw['x-deserialize-skip-invalid-items'] == true;

  /// Whether missing, null, and concrete values have patch semantics.
  bool get requiresPresenceTracking => !isRequired && node.isNullable;
}

/// One known member of a tagged union.
final class TaggedUnionVariant {
  /// Creates a tagged-union variant.
  const TaggedUnionVariant({
    required this.tag,
    required this.targetDefinition,
    required this.description,
  });

  /// The discriminator string.
  final String tag;

  /// The referenced payload definition, when one exists.
  final String? targetDefinition;

  /// Variant documentation.
  final String? description;
}

/// Tagged-union metadata derived from the schema.
final class TaggedUnionInfo {
  /// Creates tagged-union metadata.
  TaggedUnionInfo({
    required this.propertyName,
    required Iterable<TaggedUnionVariant> variants,
    required this.isOpen,
  }) : variants = List<TaggedUnionVariant>.unmodifiable(variants);

  /// The discriminator property.
  final String propertyName;

  /// Known variants in schema order.
  final List<TaggedUnionVariant> variants;

  /// Whether an unknown future/custom variant is allowed.
  final bool isOpen;
}

/// A named schema definition.
final class SchemaDefinition {
  /// Creates a named definition.
  SchemaDefinition({required this.name, required Map<String, Object?> raw})
    : node = SchemaNode(raw);

  /// The `$defs` key.
  final String name;

  /// The normalized schema node.
  final SchemaNode node;

  /// Documentation from the schema.
  String? get description => node.description;

  /// The definition's top-level shape.
  SchemaDefinitionKind get kind {
    if (node.raw.containsKey('oneOf')) {
      return SchemaDefinitionKind.oneOf;
    }
    if (node.raw.containsKey('anyOf')) {
      return SchemaDefinitionKind.anyOf;
    }
    final Set<String> types = node.typeNames;
    if (types.contains('object') || node.raw.containsKey('properties')) {
      return SchemaDefinitionKind.object;
    }
    if (types.contains('string')) {
      return SchemaDefinitionKind.string;
    }
    if (types.contains('integer')) {
      return SchemaDefinitionKind.integer;
    }
    if (types.contains('number')) {
      return SchemaDefinitionKind.number;
    }
    if (types.contains('boolean')) {
      return SchemaDefinitionKind.boolean;
    }
    if (types.contains('array')) {
      return SchemaDefinitionKind.array;
    }
    return SchemaDefinitionKind.unconstrained;
  }

  /// Object properties in source order.
  List<SchemaProperty> get properties => <SchemaProperty>[
    for (final MapEntry<String, SchemaNode> entry in node.properties.entries)
      SchemaProperty(
        wireName: entry.key,
        node: entry.value,
        isRequired: node.requiredNames.contains(entry.key),
      ),
  ];

  /// Whether this definition requires manual resilient decoding.
  bool get hasResilientFields => properties.any(
    (SchemaProperty property) =>
        property.wireName != '_meta' &&
        (property.defaultsOnError ||
            property.skipsInvalidItems ||
            property.requiresPresenceTracking),
  );

  /// Whether arbitrary object properties are accepted.
  bool get hasArbitraryProperties =>
      node.raw['additionalProperties'] == true ||
      node.raw['unevaluatedProperties'] == true;

  /// Tagged-union metadata, when all known branches share a discriminator.
  TaggedUnionInfo? get taggedUnion {
    final List<SchemaNode> branches = node.raw.containsKey('oneOf')
        ? node.children('oneOf')
        : node.children('anyOf');
    if (branches.isEmpty) {
      return null;
    }

    String? explicitProperty;
    final Object? discriminator = node.raw['discriminator'];
    if (discriminator is Map<Object?, Object?>) {
      final map = _stringMap(discriminator, 'discriminator');
      if (map['propertyName'] is String) {
        explicitProperty = map['propertyName']! as String;
      }
    }

    String? propertyName = explicitProperty;
    if (propertyName == null) {
      final Map<String, SchemaNode> firstProperties = branches.first.properties;
      for (final MapEntry<String, SchemaNode> entry
          in firstProperties.entries) {
        if (entry.value.constant is String) {
          propertyName = entry.key;
          break;
        }
      }
    }
    if (propertyName == null) {
      return null;
    }

    final variants = <TaggedUnionVariant>[];
    bool isOpen = false;
    for (final SchemaNode branch in branches) {
      final SchemaNode? tagNode = branch.properties[propertyName];
      final Object? tag = tagNode?.constant;
      if (tag is! String) {
        if (tagNode?.typeNames.contains('string') ?? false) {
          isOpen = true;
          continue;
        }
        return null;
      }
      String? target;
      for (final SchemaNode inherited in branch.children('allOf')) {
        target ??= inherited.reference;
      }
      variants.add(
        TaggedUnionVariant(
          tag: tag,
          targetDefinition: target,
          description: branch.description,
        ),
      );
    }
    if (variants.isEmpty) {
      return null;
    }
    return TaggedUnionInfo(
      propertyName: propertyName,
      variants: variants,
      isOpen: isOpen,
    );
  }
}

/// A parsed schema document with deterministically ordered definitions.
final class SchemaDocument {
  /// Parses a complete schema document.
  factory SchemaDocument.fromJson(Object? json, {required String sourceName}) {
    final root = _stringMap(json, sourceName);
    final definitionsRaw = _stringMap(root[r'$defs'], r'$defs');
    final definitions = <String, SchemaDefinition>{};
    final names = definitionsRaw.keys.toList(growable: false)..sort();
    for (final String name in names) {
      definitions[name] = SchemaDefinition(
        name: name,
        raw: _stringMap(definitionsRaw[name], '#/\$defs/$name'),
      );
    }
    return SchemaDocument._(
      sourceName: sourceName,
      root: root,
      definitions: definitions,
    );
  }

  const SchemaDocument._({
    required this.sourceName,
    required this.root,
    required this.definitions,
  });

  /// The manifest-relative schema path.
  final String sourceName;

  /// The raw top-level schema.
  final Map<String, Object?> root;

  /// Definitions ordered by schema name.
  final Map<String, SchemaDefinition> definitions;

  /// The top-level schema title.
  String? get title =>
      root['title'] is String ? root['title']! as String : null;
}

Map<String, Object?> _stringMap(Object? value, String context) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException('Expected an object at $context');
  }
  final result = <String, Object?>{};
  for (final MapEntry<Object?, Object?> entry in value.entries) {
    final Object? key = entry.key;
    if (key is! String) {
      throw FormatException('Expected a string key at $context');
    }
    result[key] = entry.value;
  }
  return result;
}
