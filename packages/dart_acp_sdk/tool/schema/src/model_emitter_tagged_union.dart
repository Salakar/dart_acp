part of 'model_emitter.dart';

extension _ModelEmitterTaggedUnion on ModelEmitter {
  void _emitTaggedUnion(
    StringBuffer output,
    SchemaDefinition definition,
    TaggedUnionInfo tagged,
  ) {
    final String typeName = dartTypeName(definition.name);
    final String codecType = '${typeName}Codec';
    final String codecValue = '${dartMemberName(typeName)}Codec';
    final List<_Field> commonFields = _taggedCommonFields(definition, tagged);
    _docs(output, definition.description, 'Tagged union ${definition.name}.');
    output
      ..writeln('sealed class $typeName implements AcpJsonEncodable {')
      ..writeln('  const $typeName();')
      ..writeln()
      ..writeln('  /// Decodes the tagged union.')
      ..writeln(
        '  factory $typeName.fromJson(Object? json) => '
        '$codecValue.decode(json);',
      )
      ..writeln()
      ..writeln('  /// The exact discriminator string.')
      ..writeln('  String get discriminator;')
      ..writeln()
      ..writeln('  /// Encodes the tagged union.')
      ..writeln(
        '  Map<String, Object?> toJson() => '
        'decodeAcpObject(toAcpJson().toObject());',
      )
      ..writeln('}')
      ..writeln();
    for (final TaggedUnionVariant variant in tagged.variants) {
      final String variantName = _variantTypeName(typeName, variant.tag);
      final List<_Field> inlineFields = variant.targetDefinition == null
          ? _inlineTaggedFields(definition, tagged, variant)
          : const <_Field>[];
      final List<_Field> targetCommonFields = variant.targetDefinition == null
          ? const <_Field>[]
          : _taggedCommonFields(
              definition,
              tagged,
              targetDefinition: variant.targetDefinition,
            );
      _docs(
        output,
        variant.description,
        'The `${variant.tag}` [$typeName] variant.',
      );
      output
        ..writeln('final class $variantName extends $typeName {')
        ..writeln('  /// Creates this known tagged-union variant.');
      if (variant.targetDefinition != null) {
        final String target = dartTypeName(variant.targetDefinition!);
        _emitTaggedTargetConstructor(output, variantName, targetCommonFields);
        output
          ..writeln()
          ..writeln('  /// The typed variant payload.')
          ..writeln('  final $target value;')
          ..writeln();
        for (final _Field field in targetCommonFields) {
          _docs(
            output,
            field.property.node.description,
            'Wire property `${field.property.wireName}`.',
            indent: '  ',
          );
          output.writeln('  final ${field.type.code} ${field.dartName};');
          output.writeln();
        }
      } else {
        if (inlineFields.isEmpty) {
          output.writeln('  const $variantName();');
        } else {
          _emitConstructor(output, variantName, inlineFields);
        }
        output.writeln();
        for (final _Field field in inlineFields) {
          _docs(
            output,
            field.property.node.description,
            'Wire property `${field.property.wireName}`.',
            indent: '  ',
          );
          output.writeln('  final ${field.type.code} ${field.dartName};');
          output.writeln();
        }
      }
      output
        ..writeln()
        ..writeln('  @override')
        ..writeln(
          '  String get discriminator => ${dartStringLiteral(variant.tag)};',
        )
        ..writeln()
        ..writeln('  @override')
        ..writeln('  AcpJsonObject toAcpJson() {');
      if (variant.targetDefinition != null) {
        final String targetCodec =
            '${dartMemberName(variant.targetDefinition!)}Codec';
        output.writeln(
          '    final payload = decodeAcpObject($targetCodec.encode(value));',
        );
        output.writeln('    final result = <String, Object?>{...payload};');
        _emitFieldWrites(output, targetCommonFields);
        output
          ..writeln(
            '    result[${dartStringLiteral(tagged.propertyName)}] = '
            'discriminator;',
          )
          ..writeln('    return AcpJsonObject.fromObject(result);')
          ..writeln('  }');
      } else {
        output.writeln('    final result = <String, Object?>{};');
        _emitFieldWrites(output, inlineFields);
        output
          ..writeln(
            '    result[${dartStringLiteral(tagged.propertyName)}] = '
            'discriminator;',
          )
          ..writeln('    return AcpJsonObject.fromObject(result);')
          ..writeln('  }');
      }
      output
        ..writeln('}')
        ..writeln();
    }
    if (tagged.isOpen) {
      final String customName = '${typeName}Custom';
      output
        ..writeln('/// An unknown future or `_`-prefixed [$typeName] variant.')
        ..writeln('final class $customName extends $typeName {')
        ..writeln('  /// Creates a raw-preserving custom variant.')
        ..writeln(
          '  $customName({required this.discriminator, '
          'required AcpJsonObject payload}) '
          ": payload = payload.without('__proto__');",
        )
        ..writeln()
        ..writeln('  @override')
        ..writeln('  final String discriminator;')
        ..writeln()
        ..writeln('  /// Opaque extension fields.')
        ..writeln('  final AcpJsonObject payload;')
        ..writeln()
        ..writeln('  @override')
        ..writeln(
          '  AcpJsonObject toAcpJson() => payload.withValue('
          '${dartStringLiteral(tagged.propertyName)}, '
          'AcpJsonString(discriminator));',
        )
        ..writeln('}')
        ..writeln();
    }
    output
      ..writeln('/// Codec for [$typeName].')
      ..writeln('final class $codecType implements AcpCodec<$typeName> {')
      ..writeln('  /// Creates the codec.')
      ..writeln('  const $codecType();')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  $typeName decode(Object? value) {')
      ..writeln('    final payload = decodeAcpObject(value);')
      ..writeln(
        '    final tag = decodeAcpString('
        'payload[${dartStringLiteral(tagged.propertyName)}]);',
      )
      ..writeln('    switch (tag) {');
    for (final TaggedUnionVariant variant in tagged.variants) {
      final String variantName = _variantTypeName(typeName, variant.tag);
      output.writeln('      case ${dartStringLiteral(variant.tag)}:');
      if (variant.targetDefinition != null) {
        final String targetCodec =
            '${dartMemberName(variant.targetDefinition!)}Codec';
        final List<_Field> targetCommonFields = _taggedCommonFields(
          definition,
          tagged,
          targetDefinition: variant.targetDefinition,
        );
        if (targetCommonFields.isEmpty) {
          output.writeln(
            '        return $variantName($targetCodec.decode(payload));',
          );
        } else {
          output
            ..writeln('        final decoder = AcpResilientDecoder(payload);')
            ..writeln('        return $variantName(')
            ..writeln('          $targetCodec.decode(payload),');
          for (final _Field field in targetCommonFields) {
            output.writeln(
              '          ${field.dartName}: '
              '${_manualDecodeExpression(field)},',
            );
          }
          output.writeln('        );');
        }
      } else {
        final List<_Field> fields = _inlineTaggedFields(
          definition,
          tagged,
          variant,
        );
        if (fields.isNotEmpty) {
          output.writeln(
            '        final decoder = AcpResilientDecoder(payload);',
          );
        }
        output.writeln('        return $variantName(');
        for (final _Field field in fields) {
          output.writeln(
            '          ${field.dartName}: '
            '${_manualDecodeExpression(field)},',
          );
        }
        output.writeln('        );');
      }
    }
    output.writeln('      default:');
    if (tagged.isOpen) {
      final List<_Field> requiredCommonFields = commonFields
          .where((_Field field) => field.property.isRequired)
          .toList(growable: false);
      if (requiredCommonFields.isNotEmpty) {
        output.writeln('        final decoder = AcpResilientDecoder(payload);');
        for (final _Field field in requiredCommonFields) {
          output.writeln('        ${_manualDecodeExpression(field)};');
        }
      }
      output.writeln(
        '        return ${typeName}Custom('
        'discriminator: tag, payload: AcpJsonObject.fromObject(payload));',
      );
    } else {
      output.writeln(
        "        throw FormatException('Unknown ${definition.name} tag: "
        "\$tag');",
      );
    }
    output
      ..writeln('    }')
      ..writeln('  }')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  Object encode($typeName value) => value.toJson();')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Shared codec for [$typeName].')
      ..writeln('const $codecType $codecValue = $codecType();');
  }

  String _variantTypeName(String unionName, String tag) {
    final String candidate = '$unionName${dartVariantSuffix(tag)}';
    return schema.definitions.containsKey(candidate)
        ? '${candidate}Variant'
        : candidate;
  }

  List<_Field> _taggedCommonFields(
    SchemaDefinition definition,
    TaggedUnionInfo tagged, {
    String? targetDefinition,
  }) {
    final Set<String> targetProperties = targetDefinition == null
        ? const <String>{}
        : schema.definitions[targetDefinition]!.node.properties.keys.toSet();
    return <_Field>[
      for (final SchemaProperty property in definition.properties)
        if (property.wireName != tagged.propertyName &&
            !property.node.raw.containsKey('const') &&
            !targetProperties.contains(property.wireName))
          _field(property, patchLike: _isPatchLike(definition)),
    ];
  }

  void _emitTaggedTargetConstructor(
    StringBuffer output,
    String variantName,
    List<_Field> fields,
  ) {
    if (fields.isEmpty) {
      output.writeln('  const $variantName(this.value);');
      return;
    }
    output
      ..writeln('  $variantName(')
      ..writeln('    this.value, {');
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
    }
    output.writeln(';');
  }

  List<_Field> _inlineTaggedFields(
    SchemaDefinition definition,
    TaggedUnionInfo tagged,
    TaggedUnionVariant variant,
  ) {
    final List<SchemaNode> branches =
        definition.kind == SchemaDefinitionKind.oneOf
        ? definition.node.children('oneOf')
        : definition.node.children('anyOf');
    final SchemaNode branch = branches.firstWhere(
      (SchemaNode candidate) =>
          candidate.properties[tagged.propertyName]?.constant == variant.tag,
    );
    final properties = <String, SchemaProperty>{};
    for (final SchemaProperty property in definition.properties) {
      if (property.wireName != tagged.propertyName &&
          !property.node.raw.containsKey('const')) {
        properties[property.wireName] = property;
      }
    }
    for (final MapEntry<String, SchemaNode> entry
        in branch.properties.entries) {
      if (entry.key != tagged.propertyName &&
          !entry.value.raw.containsKey('const')) {
        properties[entry.key] = SchemaProperty(
          wireName: entry.key,
          node: entry.value,
          isRequired: branch.requiredNames.contains(entry.key),
        );
      }
    }
    return <_Field>[
      for (final SchemaProperty property in properties.values)
        _field(property, patchLike: _isPatchLike(definition)),
    ];
  }
}
