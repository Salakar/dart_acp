part of 'model_emitter.dart';

extension _ModelEmitterObject on ModelEmitter {
  void _emitObject(StringBuffer output, SchemaDefinition definition) {
    final String typeName = dartTypeName(definition.name);
    final List<_Field> fields = _fields(definition);
    final bool isManual =
        definition.hasResilientFields ||
        definition.hasArbitraryProperties ||
        fields.any((_Field field) => field.isPatch);
    if (!isManual) {
      for (final _Field field in fields) {
        _emitFieldConverter(output, typeName, field);
      }
      output.writeln(
        '@JsonSerializable(checked: true, explicitToJson: true, '
        'includeIfNull: false)',
      );
    } else {
      output.writeln(
        '@JsonSerializable(createFactory: false, createToJson: false)',
      );
    }
    _docs(output, definition.description, 'Schema model ${definition.name}.');
    output.writeln('final class $typeName implements AcpJsonEncodable {');
    _emitConstructor(output, typeName, fields);
    output.writeln();
    for (final _Field field in fields) {
      _docs(
        output,
        field.property.node.description,
        'Wire property `${field.property.wireName}`.',
        indent: '  ',
      );
      if (!isManual) {
        if (field.property.wireName == '_meta') {
          output.writeln(
            field.property.isRequired
                ? "  @JsonKey(name: '_meta', required: true)"
                : "  @JsonKey(name: '_meta')",
          );
          output.writeln('  @AcpMetaConverter()');
        } else {
          final String suffix = _fieldHelperSuffix(typeName, field.dartName);
          final bool includeNull =
              field.property.isRequired && _wireAllowsNull(field.property.node);
          output.writeln(
            '  @JsonKey('
            'name: ${dartStringLiteral(field.property.wireName)}, '
            'fromJson: _decode$suffix, '
            'toJson: _encode$suffix, '
            'includeIfNull: $includeNull, '
            'required: ${field.property.isRequired}'
            ')',
          );
        }
      }
      output.writeln('  final ${field.type.code} ${field.dartName};');
      output.writeln();
    }

    if (isManual) {
      _emitManualObjectCodec(output, typeName, fields);
    } else {
      output
        ..writeln('  /// Decodes a schema-validated JSON object.')
        ..writeln(
          '  factory $typeName.fromJson(Map<String, Object?> json) => '
          '_\$${typeName}FromJson(json);',
        )
        ..writeln()
        ..writeln('  /// Encodes this value to its wire object.')
        ..writeln(
          '  Map<String, Object?> toJson() => _\$${typeName}ToJson(this);',
        );
    }
    output
      ..writeln()
      ..writeln('  @override')
      ..writeln(
        '  AcpJsonObject toAcpJson() => '
        'AcpJsonObject.fromObject(toJson());',
      )
      ..writeln('}')
      ..writeln();
    _emitObjectCodecClass(output, typeName, isManual);
  }

  void _emitConstructor(
    StringBuffer output,
    String typeName,
    List<_Field> fields,
  ) {
    output
      ..writeln('  /// Creates a $typeName value.')
      ..writeln('  $typeName({');
    final List<_Field> sorted = <_Field>[
      ...fields.where((_Field field) => field.constructorRequired),
      ...fields.where((_Field field) => !field.constructorRequired),
    ];
    final initializers = <String>[];
    for (final _Field field in sorted) {
      final String prefix = field.constructorRequired ? 'required ' : '';
      if (field.isPatch) {
        final _DartType patchValue = field.type.item!;
        if (patchValue.collectionKind == _CollectionKind.none) {
          output.writeln(
            '    this.${field.dartName} = '
            'const AcpPatch<${field.type.patchInner}>.unchanged(),',
          );
        } else {
          output.writeln(
            '    AcpPatch<${field.type.patchInner}> ${field.dartName} = '
            'const AcpPatch<${field.type.patchInner}>.unchanged(),',
          );
          initializers.add(
            '${field.dartName} = ${field.dartName}.map('
            '(value) => ${patchValue.immutableCopy('value')})',
          );
        }
      } else if (field.type.collectionKind != _CollectionKind.none) {
        output.writeln('    $prefix${field.type.code} ${field.dartName},');
        initializers.add(field.type.immutableInitializer(field.dartName));
      } else {
        output.writeln('    ${prefix}this.${field.dartName},');
      }
    }
    output.write('  })');
    if (initializers.isNotEmpty) {
      output
        ..write(' : ${initializers.first}')
        ..writeAll(
          initializers.skip(1).map((String value) => ',\n       $value'),
        );
      output.writeln(';');
      return;
    }
    output.writeln(';');
  }

  void _emitFieldConverter(StringBuffer output, String typeName, _Field field) {
    if (field.property.wireName == '_meta') {
      return;
    }
    final String suffix = _fieldHelperSuffix(typeName, field.dartName);
    final String encoded = field.type.isNullable
        ? 'value == null ? null : '
              '${field.type.withoutNullable().encode('value')}'
        : field.type.encode('value');
    output
      ..writeln(
        '${field.type.code} _decode$suffix(Object? value) => '
        '${field.type.decode('value')};',
      )
      ..writeln(
        'Object? _encode$suffix(${field.type.code} value) => '
        '$encoded;',
      )
      ..writeln();
  }

  void _emitManualObjectCodec(
    StringBuffer output,
    String typeName,
    List<_Field> fields,
  ) {
    output
      ..writeln('  /// Decodes this model and reports recoverable issues.')
      ..writeln('  static AcpDecoded<$typeName> decode(Object? json) {')
      ..writeln(
        '    final decoder = AcpResilientDecoder(decodeAcpObject(json));',
      )
      ..writeln('    final value = $typeName(');
    for (final _Field field in fields) {
      output.writeln(
        '      ${field.dartName}: ${_manualDecodeExpression(field)},',
      );
    }
    output
      ..writeln('    );')
      ..writeln('    return decoder.finish(value);')
      ..writeln('  }')
      ..writeln()
      ..writeln('  /// Decodes a JSON object, discarding recoverable issues.')
      ..writeln(
        '  factory $typeName.fromJson(Map<String, Object?> json) => '
        'decode(json).value;',
      )
      ..writeln()
      ..writeln('  /// Encodes this value to its wire object.')
      ..writeln('  Map<String, Object?> toJson() {')
      ..writeln('    final result = <String, Object?>{};');
    _emitFieldWrites(output, fields);
    output
      ..writeln('    return result;')
      ..writeln('  }');
  }

  void _emitFieldWrites(StringBuffer output, List<_Field> fields) {
    for (final _Field field in fields) {
      final String key = dartStringLiteral(field.property.wireName);
      if (field.isPatch) {
        output.writeln(
          '    ${field.dartName}.writeTo('
          'result, $key, '
          '(value) => ${field.type.patchValueEncode('value')});',
        );
      } else if (field.type.isNullable && !field.property.isRequired) {
        final _DartType nonNull = field.type.withoutNullable();
        output
          ..writeln('    if (${field.dartName} != null) {')
          ..writeln(
            '      result[$key] = '
            '${nonNull.encode('${field.dartName}!')};',
          )
          ..writeln('    }');
      } else {
        output.writeln(
          '    result[$key] = ${field.type.encode(field.dartName)};',
        );
      }
    }
  }

  String _manualDecodeExpression(_Field field) {
    final String key = dartStringLiteral(field.property.wireName);
    if (field.property.wireName == '_meta') {
      return 'decoder.meta()';
    }
    if (field.isPatch) {
      return 'decoder.patch($key, '
          '(value) => ${field.type.patchValueDecode('value')})';
    }
    final String closure = '(value) => ${field.type.decode('value')}';
    if (field.property.skipsInvalidItems && field.type.item != null) {
      final _DartType item = field.type.item!;
      return 'decoder.listSkippingInvalid($key, '
          '(value) => ${item.decode('value')}, '
          'isRequired: ${field.property.isRequired})';
    }
    if (field.property.defaultsOnError) {
      if (field.property.node.hasDefault) {
        final String fallback = _decodeDefault(
          field.type,
          field.property.node.defaultValue,
        );
        final String method = field.property.isRequired
            ? 'requiredDefaultOnError'
            : 'defaultOnError';
        return 'decoder.$method($key, $fallback, $closure)';
      }
      if (!field.property.isRequired) {
        final _DartType nonNull = field.type.withoutNullable();
        return 'decoder.optionalOnError($key, '
            '(value) => ${nonNull.decode('value')}).valueOrNull';
      }
    }
    if (field.property.isRequired) {
      return 'decoder.required($key, $closure)';
    }
    final _DartType nonNull = field.type.withoutNullable();
    final String nonNullClosure = '(value) => ${nonNull.decode('value')}';
    if (field.property.node.hasDefault) {
      final String fallback = _decodeDefault(
        nonNull,
        field.property.node.defaultValue,
      );
      return 'decoder.contains($key) '
          '? decoder.required($key, $nonNullClosure) '
          ': $fallback';
    }
    return 'decoder.optional($key, $nonNullClosure)';
  }

  String _decodeDefault(_DartType type, Object? value) {
    if (value is Map<Object?, Object?> &&
        value.isEmpty &&
        type.collectionKind == _CollectionKind.map) {
      return '<String, ${type.item!.code}>{}';
    }
    if (value is List<Object?> &&
        value.isEmpty &&
        type.collectionKind == _CollectionKind.list) {
      return '<${type.item!.code}>[]';
    }
    return type.decode(_dartLiteral(value));
  }

  void _emitObjectCodecClass(
    StringBuffer output,
    String typeName,
    bool isManual,
  ) {
    final String codecType = '${typeName}Codec';
    final String codecValue = '${dartMemberName(typeName)}Codec';
    _docs(output, null, 'Codec for [$typeName].');
    output
      ..writeln('final class $codecType implements AcpCodec<$typeName> {')
      ..writeln('  /// Creates the codec.')
      ..writeln('  const $codecType();')
      ..writeln()
      ..writeln('  @override')
      ..writeln(
        '  $typeName decode(Object? value) => '
        '$typeName.fromJson(decodeAcpObject(value));',
      )
      ..writeln()
      ..writeln('  @override')
      ..writeln('  Object encode($typeName value) => value.toJson();')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Shared codec for [$typeName].')
      ..writeln('const $codecType $codecValue = $codecType();');
  }
}
