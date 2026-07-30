part of 'model_emitter.dart';

extension _ModelEmitterTypes on ModelEmitter {
  List<_Field> _fields(SchemaDefinition definition) {
    final bool patchLike = _isPatchLike(definition);
    return <_Field>[
      for (final SchemaProperty property in definition.properties)
        _field(property, patchLike: patchLike),
    ];
  }

  _Field _field(SchemaProperty property, {required bool patchLike}) {
    if (property.wireName == '_meta') {
      return _Field(
        property: property,
        dartName: 'meta',
        type: _DartType.jsonObject(isNullable: true),
        isPatch: false,
        constructorRequired: false,
      );
    }
    final _DartType base = _typeForNode(property.node, ignoreNullable: true);
    final bool isPatch = patchLike && property.requiresPresenceTracking;
    if (isPatch) {
      return _Field(
        property: property,
        dartName: dartMemberName(property.wireName),
        type: _DartType.patch(base),
        isPatch: true,
        constructorRequired: false,
      );
    }
    final bool isNullable =
        property.node.isNullable ||
        (!property.isRequired && !property.node.hasDefault);
    final _DartType type = isNullable ? base.asNullable() : base;
    return _Field(
      property: property,
      dartName: dartMemberName(property.wireName),
      type: type,
      isPatch: false,
      constructorRequired:
          property.isRequired || (!isNullable && property.node.hasDefault),
    );
  }

  _DartType _typeForNode(SchemaNode node, {bool ignoreNullable = false}) {
    final String? directRef = node.reference ?? _singleReference(node);
    if (directRef != null) {
      final _DartType value = _DartType.named(directRef);
      return !ignoreNullable && node.isNullable ? value.asNullable() : value;
    }
    final List<SchemaNode> alternatives = node.children('anyOf').isNotEmpty
        ? node.children('anyOf')
        : node.children('oneOf');
    if (alternatives.isNotEmpty) {
      final nonNull = alternatives
          .where((SchemaNode child) => !child.typeNames.contains('null'))
          .toList(growable: false);
      if (nonNull.length == 1) {
        final _DartType value = _typeForNode(
          nonNull.single,
          ignoreNullable: true,
        );
        return !ignoreNullable && node.isNullable ? value.asNullable() : value;
      }
      return _DartType.jsonValue(
        isNullable: !ignoreNullable && node.isNullable,
      );
    }
    final Set<String> types = node.typeNames;
    _DartType value;
    if (types.contains('string')) {
      value = switch (node.raw['format']) {
        'uri' => _DartType.custom(
          code: 'Uri',
          decoder: (String input) => 'decodeAcpUri($input)',
          encoder: (String input) => '$input.toString()',
        ),
        'date-time' => _DartType.custom(
          code: 'AcpDateTimeString',
          decoder: (String input) => 'decodeAcpDateTime($input)',
          encoder: (String input) => '$input.value',
        ),
        'regex' => _DartType.primitive(
          code: 'String',
          decoder: 'decodeAcpRegexString',
        ),
        _ => _DartType.primitive(code: 'String', decoder: 'decodeAcpString'),
      };
    } else if (types.contains('integer')) {
      value = switch (node.raw['format']) {
        'int64' => _DartType.custom(
          code: 'AcpInt64',
          decoder: (String input) => 'decodeAcpInt64($input)',
          encoder: (String input) => 'encodeAcpInt64($input)',
        ),
        'uint64' => _DartType.custom(
          code: 'AcpUint64',
          decoder: (String input) => 'decodeAcpUint64($input)',
          encoder: (String input) => 'encodeAcpUint64($input)',
        ),
        'int32' => _DartType.custom(
          code: 'int',
          decoder: (String input) =>
              'decodeAcpIntegerInRange($input, -2147483648, 2147483647)',
          encoder: (String input) => input,
        ),
        'uint16' => _DartType.custom(
          code: 'int',
          decoder: (String input) =>
              'decodeAcpIntegerInRange($input, 0, 65535)',
          encoder: (String input) => input,
        ),
        'uint32' => _DartType.custom(
          code: 'int',
          decoder: (String input) =>
              'decodeAcpIntegerInRange($input, 0, 4294967295)',
          encoder: (String input) => input,
        ),
        _ => _DartType.primitive(code: 'int', decoder: 'decodeAcpInteger'),
      };
    } else if (types.contains('number')) {
      value = _DartType.primitive(code: 'num', decoder: 'decodeAcpNumber');
    } else if (types.contains('boolean')) {
      value = _DartType.primitive(code: 'bool', decoder: 'decodeAcpBoolean');
    } else if (types.contains('array')) {
      value = _DartType.list(
        _typeForNode(
          node.items ?? SchemaNode(const <String, Object?>{}),
          ignoreNullable: false,
        ),
      );
    } else if (types.contains('object')) {
      final SchemaNode? values = node.additionalProperties;
      value = values == null
          ? _DartType.jsonObject()
          : _DartType.map(_typeForNode(values));
    } else {
      value = _DartType.jsonValue();
    }
    return !ignoreNullable && node.isNullable ? value.asNullable() : value;
  }

  String? _singleReference(SchemaNode node) {
    final List<SchemaNode> inherited = node.children('allOf');
    return inherited.length == 1 ? inherited.single.reference : null;
  }

  bool _wireAllowsNull(SchemaNode node, [Set<String>? visited]) {
    if (node.typeNames.contains('null')) {
      return true;
    }
    final String? reference = node.reference ?? _singleReference(node);
    if (reference != null) {
      final seen = visited ?? <String>{};
      if (!seen.add(reference)) {
        return false;
      }
      final SchemaDefinition? definition = schema.definitions[reference];
      return definition != null && _wireAllowsNull(definition.node, seen);
    }
    final List<SchemaNode> alternatives = <SchemaNode>[
      ...node.children('oneOf'),
      ...node.children('anyOf'),
    ];
    if (alternatives.isNotEmpty) {
      return alternatives.any(
        (SchemaNode child) => _wireAllowsNull(child, visited),
      );
    }
    return node.typeNames.isEmpty &&
        node.children('allOf').isEmpty &&
        node.properties.isEmpty;
  }

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

  SchemaDefinitionKind? _scalarUnionKind(SchemaDefinition definition) {
    final List<SchemaNode> branches =
        definition.kind == SchemaDefinitionKind.oneOf
        ? definition.node.children('oneOf')
        : definition.node.children('anyOf');
    final kinds = <SchemaDefinitionKind>{};
    for (final SchemaNode branch in branches) {
      if (branch.typeNames.contains('null')) {
        continue;
      }
      if (branch.typeNames.contains('string')) {
        kinds.add(SchemaDefinitionKind.string);
      } else if (branch.typeNames.contains('integer')) {
        kinds.add(SchemaDefinitionKind.integer);
      } else if (branch.typeNames.contains('number')) {
        kinds.add(SchemaDefinitionKind.number);
      } else if (branch.typeNames.contains('boolean')) {
        kinds.add(SchemaDefinitionKind.boolean);
      } else {
        return null;
      }
    }
    return kinds.length == 1 ? kinds.single : null;
  }

  List<String> _stringConstants(SchemaDefinition definition) {
    final values = <String>[];
    final Object? enumValue = definition.node.raw['enum'];
    if (enumValue is List<Object?>) {
      for (final Object? value in enumValue) {
        if (value is String) {
          values.add(value);
        }
      }
    }
    for (final String composition in const <String>['oneOf', 'anyOf']) {
      for (final SchemaNode child in definition.node.children(composition)) {
        final Object? value = child.constant;
        if (value is String) {
          values.add(value);
        }
      }
    }
    return values.toSet().toList(growable: false);
  }

  bool _hasCatchAll(SchemaDefinition definition, String type) {
    for (final String composition in const <String>['oneOf', 'anyOf']) {
      for (final SchemaNode child in definition.node.children(composition)) {
        if (child.typeNames.contains(type) && child.constant == null) {
          return true;
        }
      }
    }
    return false;
  }
}

final class _Field {
  const _Field({
    required this.property,
    required this.dartName,
    required this.type,
    required this.isPatch,
    required this.constructorRequired,
  });

  final SchemaProperty property;
  final String dartName;
  final _DartType type;
  final bool isPatch;
  final bool constructorRequired;
}

final class _UnionBranch {
  _UnionBranch({
    required this.label,
    required this.type,
    required this.node,
    this.isNull = false,
    this.isOpenObject = false,
  });

  final String label;
  final _DartType? type;
  final SchemaNode node;
  final bool isNull;
  final bool isOpenObject;
  late String variantName;

  Map<String, Object?> get constantProperties => <String, Object?>{
    for (final MapEntry<String, SchemaNode> entry in node.properties.entries)
      if (entry.value.raw.containsKey('const')) entry.key: entry.value.constant,
  };
}

final class _CompositionBranch {
  _CompositionBranch({
    required this.label,
    required this.node,
    required this.targetDefinition,
    required this.fields,
  });

  final String label;
  final SchemaNode node;
  final String? targetDefinition;
  final List<_Field> fields;
  late String variantName;

  Map<String, Object?> get constantProperties => <String, Object?>{
    for (final MapEntry<String, SchemaNode> entry in node.properties.entries)
      if (entry.value.raw.containsKey('const')) entry.key: entry.value.constant,
  };
}

enum _CollectionKind { none, list, map }

final class _DartType {
  const _DartType._({
    required this.code,
    required this.decoder,
    required this.encoder,
    required this.isNullable,
    required this.collectionKind,
    this.item,
    this.patchInner,
    this.nonNullable,
  });

  factory _DartType.named(String schemaName) {
    final String type = dartTypeName(schemaName);
    final String codec = '${dartMemberName(type)}Codec';
    return _DartType._(
      code: type,
      decoder: (String value) => '$codec.decode($value)',
      encoder: (String value) => '$codec.encode($value)',
      isNullable: false,
      collectionKind: _CollectionKind.none,
    );
  }

  factory _DartType.primitive({
    required String code,
    required String decoder,
  }) => _DartType._(
    code: code,
    decoder: (String value) => '$decoder($value)',
    encoder: (String value) => value,
    isNullable: false,
    collectionKind: _CollectionKind.none,
  );

  factory _DartType.custom({
    required String code,
    required String Function(String value) decoder,
    required String Function(String value) encoder,
  }) => _DartType._(
    code: code,
    decoder: decoder,
    encoder: encoder,
    isNullable: false,
    collectionKind: _CollectionKind.none,
  );

  factory _DartType.jsonValue({bool isNullable = false}) {
    final _DartType value = _DartType._(
      code: 'AcpJsonValue',
      decoder: (String input) => 'AcpJsonValue.fromObject($input)',
      encoder: (String input) => '$input.toObject()',
      isNullable: false,
      collectionKind: _CollectionKind.none,
    );
    return isNullable ? value.asNullable() : value;
  }

  factory _DartType.jsonObject({bool isNullable = false}) {
    final _DartType value = _DartType._(
      code: 'AcpJsonObject',
      decoder: (String input) => 'AcpJsonObject.fromObject($input)',
      encoder: (String input) => '$input.toObject()',
      isNullable: false,
      collectionKind: _CollectionKind.none,
    );
    return isNullable ? value.asNullable() : value;
  }

  factory _DartType.list(_DartType item) => _DartType._(
    code: 'List<${item.code}>',
    decoder: (String value) =>
        'List<${item.code}>.unmodifiable('
        '($value as List<Object?>).map('
        '(item) => ${item.decode('item')}))',
    encoder: (String value) =>
        '<Object?>[for (final item in $value) ${item.encode('item')}]',
    isNullable: false,
    collectionKind: _CollectionKind.list,
    item: item,
  );

  factory _DartType.map(_DartType item) => _DartType._(
    code: 'Map<String, ${item.code}>',
    decoder: (String value) =>
        'Map<String, ${item.code}>.unmodifiable('
        '<String, ${item.code}>{'
        'for (final entry in decodeAcpObject($value).entries) '
        'entry.key: ${item.decode('entry.value')}})',
    encoder: (String value) =>
        '<String, Object?>{'
        'for (final entry in $value.entries) '
        'entry.key: ${item.encode('entry.value')}}',
    isNullable: false,
    collectionKind: _CollectionKind.map,
    item: item,
  );

  factory _DartType.patch(_DartType inner) => _DartType._(
    code: 'AcpPatch<${inner.code}>',
    decoder: inner.decoder,
    encoder: inner.encoder,
    isNullable: false,
    collectionKind: _CollectionKind.none,
    patchInner: inner.code,
    item: inner,
  );

  final String code;
  final String Function(String value) decoder;
  final String Function(String value) encoder;
  final bool isNullable;
  final _CollectionKind collectionKind;
  final _DartType? item;
  final String? patchInner;
  final _DartType? nonNullable;

  String decode(String value) => decoder(value);

  String encode(String value) => encoder(value);

  _DartType asNullable() {
    if (isNullable) {
      return this;
    }
    return _DartType._(
      code: '$code?',
      decoder: (String value) => '$value == null ? null : ${decode(value)}',
      encoder: (String value) => '$value == null ? null : ${encode('$value!')}',
      isNullable: true,
      collectionKind: collectionKind,
      item: item,
      patchInner: patchInner,
      nonNullable: this,
    );
  }

  _DartType withoutNullable() {
    return nonNullable ?? this;
  }

  String patchValueDecode(String value) => item!.decode(value);

  String patchValueEncode(String value) => item!.encode(value);

  String immutableInitializer(String value) {
    final String copy = immutableCopy(value);
    return '$value = ${isNullable ? '$value == null ? null : $copy' : copy}';
  }

  String immutableCopy(String value) => switch (collectionKind) {
    _CollectionKind.list => 'List<${item!.code}>.unmodifiable($value)',
    _CollectionKind.map => 'Map<String, ${item!.code}>.unmodifiable($value)',
    _CollectionKind.none => throw StateError(
      'A scalar field has no immutable collection copy',
    ),
  };
}

String _fieldHelperSuffix(String typeName, String fieldName) =>
    '$typeName${fieldName.substring(0, 1).toUpperCase()}'
    '${fieldName.substring(1)}';

String _dartLiteral(Object? value) {
  if (value == null) {
    return 'null';
  }
  if (value is bool || value is num) {
    return value.toString();
  }
  if (value is String) {
    return dartStringLiteral(value);
  }
  if (value is List<Object?>) {
    return '<Object?>[${value.map(_dartLiteral).join(', ')}]';
  }
  if (value is Map<Object?, Object?>) {
    final entries = <String>[];
    for (final MapEntry<Object?, Object?> entry in value.entries) {
      if (entry.key is! String) {
        throw const FormatException('Default object key is not a string');
      }
      entries.add(
        '${dartStringLiteral(entry.key! as String)}: '
        '${_dartLiteral(entry.value)}',
      );
    }
    return '<String, Object?>{${entries.join(', ')}}';
  }
  throw FormatException('Unsupported schema default: $value');
}

void _docs(
  StringBuffer output,
  String? source,
  String fallback, {
  String indent = '',
}) {
  final String text = source == null || source.trim().isEmpty
      ? fallback
      : source.trim();
  final List<String> lines = text
      .split('\n')
      .take(8)
      .map(_docEscape)
      .toList(growable: false);
  for (final String line in lines) {
    output.writeln('$indent///${line.isEmpty ? '' : ' $line'}');
  }
}

String _docEscape(String value) => sanitizeDartdoc(value);
