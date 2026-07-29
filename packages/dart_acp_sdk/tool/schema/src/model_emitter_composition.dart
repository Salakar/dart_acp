part of 'model_emitter.dart';

extension _ModelEmitterComposition on ModelEmitter {
  bool _emitObjectComposition(
    StringBuffer output,
    SchemaDefinition definition,
  ) {
    if (definition.properties.isEmpty &&
        !definition.node.typeNames.contains('object')) {
      return false;
    }
    final List<SchemaNode> nodes = definition.kind == SchemaDefinitionKind.oneOf
        ? definition.node.children('oneOf')
        : definition.node.children('anyOf');
    final branches = <_CompositionBranch>[];
    for (int index = 0; index < nodes.length; index += 1) {
      final SchemaNode node = nodes[index];
      final String? target = node.reference ?? _singleReference(node);
      final properties = <SchemaProperty>[
        for (final MapEntry<String, SchemaNode> entry
            in node.properties.entries)
          if (!entry.value.raw.containsKey('const'))
            SchemaProperty(
              wireName: entry.key,
              node: entry.value,
              isRequired: node.requiredNames.contains(entry.key),
            ),
      ];
      if (target == null && properties.isEmpty && node.properties.isEmpty) {
        return false;
      }
      if (target == null &&
          (node.raw['additionalProperties'] == true ||
              node.raw['unevaluatedProperties'] == true)) {
        return false;
      }
      final String label = node.raw['title'] is String
          ? node.raw['title']! as String
          : node.properties.values
                    .map((SchemaNode property) => property.constant)
                    .whereType<String>()
                    .firstOrNull ??
                target ??
                'variant${index + 1}';
      branches.add(
        _CompositionBranch(
          label: label,
          node: node,
          targetDefinition: target,
          fields: <_Field>[
            for (final SchemaProperty property in properties)
              _field(property, patchLike: false),
          ],
        ),
      );
    }
    if (branches.isEmpty) {
      return false;
    }

    final String typeName = dartTypeName(definition.name);
    final String variantBase = '${typeName}Variant';
    final usedNames = <String>{};
    for (final _CompositionBranch branch in branches) {
      var candidate = '$typeName${dartTypeName(branch.label)}';
      if (schema.definitions.containsKey(candidate)) {
        candidate = '${candidate}Variant';
      }
      var unique = candidate;
      int suffix = 2;
      while (!usedNames.add(unique)) {
        unique = '$candidate$suffix';
        suffix += 1;
      }
      branch.variantName = unique;
    }

    _docs(output, definition.description, 'Composed model ${definition.name}.');
    output.writeln('final class $typeName implements AcpJsonEncodable {');
    final List<_Field> commonFields = _fields(definition);
    _emitComposedConstructor(output, typeName, variantBase, commonFields);
    output.writeln();
    for (final _Field field in commonFields) {
      _docs(
        output,
        field.property.node.description,
        'Wire property `${field.property.wireName}`.',
        indent: '  ',
      );
      output.writeln('  final ${field.type.code} ${field.dartName};');
      output.writeln();
    }
    output
      ..writeln('  /// The concrete schema composition branch.')
      ..writeln('  final $variantBase variant;')
      ..writeln()
      ..writeln('  /// Decodes this composed model with resilient fields.')
      ..writeln('  static AcpDecoded<$typeName> decode(Object? json) {')
      ..writeln(
        '    final decoder = AcpResilientDecoder(decodeAcpObject(json));',
      )
      ..writeln('    final value = $typeName(');
    for (final _Field field in commonFields) {
      output.writeln(
        '      ${field.dartName}: ${_manualDecodeExpression(field)},',
      );
    }
    output
      ..writeln('      variant: ${_compositionDecoderName(typeName)}(json),')
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
      ..writeln('    final result = <String, Object?>{...variant.toJson()};');
    _emitFieldWrites(output, commonFields);
    output
      ..writeln('    return result;')
      ..writeln('  }')
      ..writeln()
      ..writeln('  @override')
      ..writeln(
        '  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());',
      )
      ..writeln('}')
      ..writeln();

    output
      ..writeln('/// One concrete composition branch for [$typeName].')
      ..writeln('sealed class $variantBase {')
      ..writeln('  const $variantBase();')
      ..writeln()
      ..writeln('  /// Encodes the branch fields into their flattened object.')
      ..writeln('  Map<String, Object?> toJson();')
      ..writeln('}')
      ..writeln();
    for (final _CompositionBranch branch in branches) {
      _emitCompositionVariant(output, typeName, variantBase, branch);
      output.writeln();
    }
    _emitCompositionDecoder(output, typeName, variantBase, branches);
    output.writeln();
    _emitObjectCodecClass(output, typeName, true);
    return true;
  }

  void _emitComposedConstructor(
    StringBuffer output,
    String typeName,
    String variantBase,
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
    for (final _Field field in sorted.where(
      (_Field field) => field.constructorRequired,
    )) {
      _emitConstructorParameter(output, field, initializers);
    }
    output.writeln('    required this.variant,');
    for (final _Field field in sorted.where(
      (_Field field) => !field.constructorRequired,
    )) {
      _emitConstructorParameter(output, field, initializers);
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

  void _emitConstructorParameter(
    StringBuffer output,
    _Field field,
    List<String> initializers,
  ) {
    final String prefix = field.constructorRequired ? 'required ' : '';
    if (field.isPatch) {
      output.writeln(
        '    this.${field.dartName} = '
        'const AcpPatch<${field.type.patchInner}>.unchanged(),',
      );
    } else if (field.type.collectionKind != _CollectionKind.none) {
      output.writeln('    $prefix${field.type.code} ${field.dartName},');
      initializers.add(field.type.immutableInitializer(field.dartName));
    } else {
      output.writeln('    ${prefix}this.${field.dartName},');
    }
  }

  void _emitCompositionVariant(
    StringBuffer output,
    String typeName,
    String variantBase,
    _CompositionBranch branch,
  ) {
    _docs(
      output,
      branch.node.description,
      'The `${branch.label}` [$typeName] branch.',
    );
    output.writeln('final class ${branch.variantName} extends $variantBase {');
    if (branch.targetDefinition != null) {
      final String target = dartTypeName(branch.targetDefinition!);
      output
        ..writeln('  /// Creates this typed composition branch.')
        ..writeln('  const ${branch.variantName}(this.value);')
        ..writeln()
        ..writeln('  /// The typed branch payload.')
        ..writeln('  final $target value;')
        ..writeln()
        ..writeln('  @override')
        ..writeln('  Map<String, Object?> toJson() => <String, Object?>{')
        ..writeln(
          '    ...decodeAcpObject('
          '${dartMemberName(branch.targetDefinition!)}Codec.encode(value)),',
        );
    } else {
      _emitConstructor(output, branch.variantName, branch.fields);
      output.writeln();
      for (final _Field field in branch.fields) {
        _docs(
          output,
          field.property.node.description,
          'Wire property `${field.property.wireName}`.',
          indent: '  ',
        );
        output.writeln('  final ${field.type.code} ${field.dartName};');
        output.writeln();
      }
      output
        ..writeln('  @override')
        ..writeln('  Map<String, Object?> toJson() {')
        ..writeln('    final result = <String, Object?>{};');
      _emitFieldWrites(output, branch.fields);
      for (final MapEntry<String, Object?> constant
          in branch.constantProperties.entries) {
        output.writeln(
          '    result[${dartStringLiteral(constant.key)}] = '
          '${_dartLiteral(constant.value)};',
        );
      }
      output
        ..writeln('    return result;')
        ..writeln('  }')
        ..writeln('}');
      return;
    }
    for (final MapEntry<String, Object?> constant
        in branch.constantProperties.entries) {
      output.writeln(
        '    ${dartStringLiteral(constant.key)}: '
        '${_dartLiteral(constant.value)},',
      );
    }
    output
      ..writeln('  };')
      ..writeln('}');
  }

  void _emitCompositionDecoder(
    StringBuffer output,
    String typeName,
    String variantBase,
    List<_CompositionBranch> branches,
  ) {
    output
      ..writeln(
        '$variantBase ${_compositionDecoderName(typeName)}(Object? value) {',
      )
      ..writeln('  final payload = decodeAcpObject(value);');
    for (final _CompositionBranch branch in branches.where(
      (_CompositionBranch branch) => branch.constantProperties.isNotEmpty,
    )) {
      final String condition = branch.constantProperties.entries
          .map(
            (MapEntry<String, Object?> entry) =>
                "payload[${dartStringLiteral(entry.key)}] == "
                '${_dartLiteral(entry.value)}',
          )
          .join(' && ');
      output
        ..writeln('  if ($condition) {')
        ..writeln('    return ${_compositionDecode(branch, 'payload')};')
        ..writeln('  }');
    }
    for (final _CompositionBranch branch in branches.where(
      (_CompositionBranch branch) => branch.constantProperties.isEmpty,
    )) {
      output
        ..writeln('  try {')
        ..writeln('    return ${_compositionDecode(branch, 'payload')};')
        ..writeln('  } on Object {')
        ..writeln('    // Try the next structurally distinct branch.')
        ..writeln('  }');
    }
    output
      ..writeln(
        "  throw const FormatException("
        "'Value does not match $typeName');",
      )
      ..writeln('}');
  }

  String _compositionDecode(_CompositionBranch branch, String payload) {
    if (branch.targetDefinition != null) {
      return '${branch.variantName}('
          '${dartMemberName(branch.targetDefinition!)}Codec.decode($payload))';
    }
    final values = <String>[
      for (final _Field field in branch.fields)
        '${field.dartName}: '
            '${field.property.isRequired ? field.type.decode("$payload[${dartStringLiteral(field.property.wireName)}]") : field.type.decode("$payload[${dartStringLiteral(field.property.wireName)}]")}',
    ];
    return '${branch.variantName}(${values.join(', ')})';
  }

  String _compositionDecoderName(String typeName) =>
      '_decode${typeName}Variant';
}
