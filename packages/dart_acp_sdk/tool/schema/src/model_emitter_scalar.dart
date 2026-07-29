part of 'model_emitter.dart';

extension _ModelEmitterScalar on ModelEmitter {
  void _emitStringValue(StringBuffer output, SchemaDefinition definition) {
    final String typeName = dartTypeName(definition.name);
    final List<String> constants = _stringConstants(definition);
    final bool isOpen = _hasCatchAll(definition, 'string');
    _docs(output, definition.description, 'String value ${definition.name}.');
    output
      ..writeln('final class $typeName implements AcpJsonEncodable {')
      ..writeln('  /// Validates and creates a $typeName value.')
      ..writeln('  factory $typeName(String value) {');
    if (definition.name == 'AbsolutePath') {
      output.writeln('    AcpAbsolutePath(value);');
    } else if (definition.name.endsWith('Id')) {
      output
        ..writeln('    if (value.isEmpty) {')
        ..writeln(
          "      throw const FormatException("
          "'Protocol identifiers must not be empty');",
        )
        ..writeln('    }');
    }
    if (constants.isNotEmpty && !isOpen) {
      output
        ..writeln('    if (!const <String>{')
        ..writeAll(
          constants.map(
            (String value) => '      ${dartStringLiteral(value)},\n',
          ),
        )
        ..writeln('    }.contains(value)) {')
        ..writeln(
          "      throw FormatException('Unknown ${definition.name}: "
          "\$value');",
        )
        ..writeln('    }');
    }
    final Object? minimum = definition.node.raw['minLength'];
    final Object? maximum = definition.node.raw['maxLength'];
    if (minimum is int) {
      output.writeln(
        "    if (value.length < $minimum) throw const FormatException("
        "'String is shorter than the schema minimum');",
      );
    }
    if (maximum is int) {
      output.writeln(
        "    if (value.length > $maximum) throw const FormatException("
        "'String exceeds the schema maximum');",
      );
    }
    final Object? pattern = definition.node.raw['pattern'];
    if (pattern is String) {
      output.writeln(
        '    if (!RegExp(${dartStringLiteral(pattern)}).hasMatch(value)) '
        "throw const FormatException('String does not match schema pattern');",
      );
    }
    output
      ..writeln('    return $typeName._(value);')
      ..writeln('  }')
      ..writeln()
      ..writeln('  const $typeName._(this.value);')
      ..writeln()
      ..writeln('  /// The exact wire string.')
      ..writeln('  final String value;');
    for (final String constant in constants) {
      output
        ..writeln()
        ..writeln('  /// The `${_docEscape(constant)}` schema value.')
        ..writeln(
          '  static const $typeName ${dartMemberName(constant)} = '
          '$typeName._(${dartStringLiteral(constant)});',
        );
    }
    output
      ..writeln()
      ..writeln('  /// Decodes a wire string.')
      ..writeln(
        '  factory $typeName.fromJson(Object? json) => '
        '$typeName(decodeAcpString(json));',
      )
      ..writeln()
      ..writeln('  /// Encodes the wire string.')
      ..writeln('  String toJson() => value;')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  AcpJsonString toAcpJson() => AcpJsonString(value);')
      ..writeln()
      ..writeln('  @override')
      ..writeln(
        '  bool operator ==(Object other) => '
        'other is $typeName && other.value == value;',
      )
      ..writeln()
      ..writeln('  @override')
      ..writeln('  int get hashCode => value.hashCode;')
      ..writeln('}')
      ..writeln();
    _emitScalarCodec(output, typeName, 'String');
  }

  void _emitIntegerValue(StringBuffer output, SchemaDefinition definition) {
    _emitNumericValue(
      output,
      definition,
      dartType: 'int',
      decoder: 'decodeAcpInteger',
    );
  }

  void _emitNumberValue(StringBuffer output, SchemaDefinition definition) {
    _emitNumericValue(
      output,
      definition,
      dartType: 'num',
      decoder: 'decodeAcpNumber',
    );
  }

  void _emitNumericValue(
    StringBuffer output,
    SchemaDefinition definition, {
    required String dartType,
    required String decoder,
  }) {
    final String typeName = dartTypeName(definition.name);
    _docs(output, definition.description, 'Numeric value ${definition.name}.');
    output
      ..writeln('final class $typeName implements AcpJsonEncodable {')
      ..writeln('  /// Validates and creates a $typeName value.')
      ..writeln('  factory $typeName($dartType value) {');
    final Object? minimum = definition.node.raw['minimum'];
    final Object? maximum = definition.node.raw['maximum'];
    if (minimum is num) {
      output
        ..writeln('    if (value < $minimum) {')
        ..writeln(
          "      throw const FormatException("
          "'Number is below the schema minimum');",
        )
        ..writeln('    }');
    }
    if (maximum is num) {
      output
        ..writeln('    if (value > $maximum) {')
        ..writeln(
          "      throw const FormatException("
          "'Number exceeds the schema maximum');",
        )
        ..writeln('    }');
    }
    output
      ..writeln('    return $typeName._(value);')
      ..writeln('  }')
      ..writeln()
      ..writeln('  const $typeName._(this.value);')
      ..writeln()
      ..writeln('  /// The exact wire number.')
      ..writeln('  final $dartType value;')
      ..writeln()
      ..writeln('  /// Decodes a wire number.')
      ..writeln(
        '  factory $typeName.fromJson(Object? json) => '
        '$typeName($decoder(json));',
      )
      ..writeln()
      ..writeln('  /// Encodes the wire number.')
      ..writeln('  $dartType toJson() => value;')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  AcpJsonNumber toAcpJson() => AcpJsonNumber(value);')
      ..writeln()
      ..writeln('  @override')
      ..writeln(
        '  bool operator ==(Object other) => '
        'other is $typeName && other.value == value;',
      )
      ..writeln()
      ..writeln('  @override')
      ..writeln('  int get hashCode => value.hashCode;')
      ..writeln('}')
      ..writeln();
    _emitScalarCodec(output, typeName, dartType);
  }

  void _emitBooleanValue(StringBuffer output, SchemaDefinition definition) {
    final String typeName = dartTypeName(definition.name);
    _docs(output, definition.description, 'Boolean value ${definition.name}.');
    output
      ..writeln('final class $typeName implements AcpJsonEncodable {')
      ..writeln('  /// Creates a $typeName value.')
      ..writeln('  const $typeName(this.value);')
      ..writeln()
      ..writeln('  /// The wire boolean.')
      ..writeln('  final bool value;')
      ..writeln()
      ..writeln('  /// Decodes a wire boolean.')
      ..writeln(
        '  factory $typeName.fromJson(Object? json) => '
        '$typeName(decodeAcpBoolean(json));',
      )
      ..writeln()
      ..writeln('  /// Encodes the wire boolean.')
      ..writeln('  bool toJson() => value;')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  AcpJsonBoolean toAcpJson() => AcpJsonBoolean(value);')
      ..writeln('}')
      ..writeln();
    _emitScalarCodec(output, typeName, 'bool');
  }

  void _emitScalarCodec(
    StringBuffer output,
    String typeName,
    String encodedType,
  ) {
    final String codecType = '${typeName}Codec';
    final String codecValue = '${dartMemberName(typeName)}Codec';
    output
      ..writeln('/// Codec for [$typeName].')
      ..writeln('final class $codecType implements AcpCodec<$typeName> {')
      ..writeln('  /// Creates the codec.')
      ..writeln('  const $codecType();')
      ..writeln()
      ..writeln('  @override')
      ..writeln(
        '  $typeName decode(Object? value) => $typeName.fromJson(value);',
      )
      ..writeln()
      ..writeln('  @override')
      ..writeln('  $encodedType encode($typeName value) => value.toJson();')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Shared codec for [$typeName].')
      ..writeln('const $codecType $codecValue = $codecType();');
  }

  void _emitArrayValue(StringBuffer output, SchemaDefinition definition) {
    final String typeName = dartTypeName(definition.name);
    final _DartType item = _typeForNode(
      definition.node.items ?? SchemaNode(const <String, Object?>{}),
    );
    _docs(output, definition.description, 'Array value ${definition.name}.');
    output
      ..writeln(
        'final class $typeName implements AcpJsonEncodable, '
        'Iterable<${item.code}> {',
      )
      ..writeln('  /// Creates an immutable $typeName value.')
      ..writeln(
        '  $typeName(Iterable<${item.code}> values) : '
        'values = List<${item.code}>.unmodifiable(values);',
      )
      ..writeln()
      ..writeln('  /// Array items.')
      ..writeln('  final List<${item.code}> values;')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  Iterator<${item.code}> get iterator => values.iterator;')
      ..writeln()
      ..writeln('  /// Decodes a wire array.')
      ..writeln('  factory $typeName.fromJson(Object? json) {')
      ..writeln('    if (json is! List<Object?>) {')
      ..writeln("      throw const FormatException('Expected an array');")
      ..writeln('    }')
      ..writeln(
        '    return $typeName(json.map((value) => ${item.decode('value')}));',
      )
      ..writeln('  }')
      ..writeln()
      ..writeln('  /// Encodes the wire array.')
      ..writeln(
        '  List<Object?> toJson() => '
        '<Object?>[for (final value in values) ${item.encode('value')}];',
      )
      ..writeln()
      ..writeln('  @override')
      ..writeln(
        '  AcpJsonArray toAcpJson() => '
        'AcpJsonArray(values.map((value) => '
        'AcpJsonValue.fromObject(${item.encode('value')})));',
      )
      ..writeln('}')
      ..writeln();
    _emitScalarCodec(output, typeName, 'List<Object?>');
  }

  void _emitJsonBoundary(StringBuffer output, SchemaDefinition definition) {
    final String typeName = dartTypeName(definition.name);
    _docs(
      output,
      definition.description,
      'Explicit JSON union boundary ${definition.name}.',
    );
    output
      ..writeln('final class $typeName implements AcpJsonEncodable {')
      ..writeln('  /// Creates a raw-preserving schema union value.')
      ..writeln('  $typeName(AcpJsonValue value) : value = value;')
      ..writeln()
      ..writeln('  /// The immutable union payload.')
      ..writeln('  final AcpJsonValue value;')
      ..writeln()
      ..writeln('  /// Decodes a union payload.')
      ..writeln(
        '  factory $typeName.fromJson(Object? json) => '
        '$typeName(AcpJsonValue.fromObject(json));',
      )
      ..writeln()
      ..writeln('  /// Encodes the union payload.')
      ..writeln('  Object? toJson() => value.toObject();')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  AcpJsonValue toAcpJson() => value;')
      ..writeln('}')
      ..writeln();
    _emitScalarCodec(output, typeName, 'Object?');
  }
}
