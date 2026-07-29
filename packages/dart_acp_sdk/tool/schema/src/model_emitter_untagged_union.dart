part of 'model_emitter.dart';

extension _ModelEmitterUntaggedUnion on ModelEmitter {
  bool _emitUntaggedUnion(StringBuffer output, SchemaDefinition definition) {
    if (definition.properties.isNotEmpty ||
        definition.node.typeNames.contains('object')) {
      return false;
    }
    final List<SchemaNode> nodes = definition.kind == SchemaDefinitionKind.oneOf
        ? definition.node.children('oneOf')
        : definition.node.children('anyOf');
    final branches = <_UnionBranch>[];
    for (int index = 0; index < nodes.length; index += 1) {
      final _UnionBranch? branch = _unionBranch(nodes[index], index);
      if (branch == null) {
        return false;
      }
      branches.add(branch);
    }
    if (branches.isEmpty) {
      return false;
    }
    final String typeName = dartTypeName(definition.name);
    final usedVariantNames = <String>{};
    for (final _UnionBranch branch in branches) {
      var candidate = '$typeName${dartTypeName(branch.label)}';
      if (schema.definitions.containsKey(candidate)) {
        candidate = '${candidate}Variant';
      }
      var unique = candidate;
      int suffix = 2;
      while (!usedVariantNames.add(unique)) {
        unique = '$candidate$suffix';
        suffix += 1;
      }
      branch.variantName = unique;
    }

    _docs(output, definition.description, 'Union ${definition.name}.');
    output
      ..writeln('sealed class $typeName implements AcpJsonEncodable {')
      ..writeln('  const $typeName();')
      ..writeln()
      ..writeln('  /// Decodes one concrete union member.')
      ..writeln(
        '  factory $typeName.fromJson(Object? json) => '
        '${dartMemberName(typeName)}Codec.decode(json);',
      )
      ..writeln()
      ..writeln('  /// Encodes the concrete union member.')
      ..writeln('  Object? toJson();')
      ..writeln()
      ..writeln('  @override')
      ..writeln(
        '  AcpJsonValue toAcpJson() => AcpJsonValue.fromObject(toJson());',
      )
      ..writeln('}')
      ..writeln();
    for (final _UnionBranch branch in branches) {
      _emitUntaggedVariant(output, typeName, branch);
      output.writeln();
    }
    _emitUntaggedUnionCodec(output, definition, branches);
    return true;
  }

  _UnionBranch? _unionBranch(SchemaNode node, int index) {
    final String? title = node.raw['title'] is String
        ? node.raw['title']! as String
        : null;
    if (node.typeNames.contains('null')) {
      return _UnionBranch(
        label: title ?? 'null',
        type: null,
        node: node,
        isNull: true,
      );
    }
    final String? reference = node.reference ?? _singleReference(node);
    if (reference != null) {
      return _UnionBranch(
        label: title ?? reference,
        type: _DartType.named(reference),
        node: node,
      );
    }
    final Set<String> types = node.typeNames;
    if (types.contains('string') ||
        types.contains('integer') ||
        types.contains('number') ||
        types.contains('boolean') ||
        types.contains('array')) {
      return _UnionBranch(
        label: title ?? 'variant${index + 1}',
        type: _typeForNode(node, ignoreNullable: true),
        node: node,
      );
    }
    if (types.contains('object') && node.raw['additionalProperties'] == true) {
      return _UnionBranch(
        label: title ?? 'custom',
        type: _DartType.jsonObject(),
        node: node,
        isOpenObject: true,
      );
    }
    return null;
  }

  void _emitUntaggedVariant(
    StringBuffer output,
    String unionName,
    _UnionBranch branch,
  ) {
    final String variantName = branch.variantName;
    _docs(output, branch.node.description, 'A concrete [$unionName] member.');
    output.writeln('final class $variantName extends $unionName {');
    if (branch.isNull) {
      output
        ..writeln('  /// Creates the JSON-null union member.')
        ..writeln('  const $variantName();')
        ..writeln()
        ..writeln('  @override')
        ..writeln('  Object? toJson() => null;');
    } else {
      final _DartType type = branch.type!;
      output
        ..writeln('  /// Creates this concrete union member.')
        ..writeln(
          branch.isOpenObject
              ? "  $variantName(AcpJsonObject value) : "
                    "value = value.without('__proto__');"
              : '  const $variantName(this.value);',
        )
        ..writeln()
        ..writeln('  /// The typed union value.')
        ..writeln('  final ${type.code} value;')
        ..writeln()
        ..writeln('  @override');
      if (branch.constantProperties.isEmpty) {
        output.writeln('  Object? toJson() => ${type.encode('value')};');
      } else {
        output
          ..writeln('  Map<String, Object?> toJson() => <String, Object?>{')
          ..writeln('    ...decodeAcpObject(${type.encode('value')}),');
        for (final MapEntry<String, Object?> constant
            in branch.constantProperties.entries) {
          output.writeln(
            '    ${dartStringLiteral(constant.key)}: '
            '${_dartLiteral(constant.value)},',
          );
        }
        output.writeln('  };');
      }
    }
    output.writeln('}');
  }

  void _emitUntaggedUnionCodec(
    StringBuffer output,
    SchemaDefinition definition,
    List<_UnionBranch> branches,
  ) {
    final String typeName = dartTypeName(definition.name);
    final String codecType = '${typeName}Codec';
    final String codecValue = '${dartMemberName(typeName)}Codec';
    output
      ..writeln('/// Codec for [$typeName].')
      ..writeln('final class $codecType implements AcpCodec<$typeName> {')
      ..writeln('  /// Creates the codec.')
      ..writeln('  const $codecType();')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  $typeName decode(Object? value) {');
    for (final _UnionBranch branch in branches.where(
      (_UnionBranch branch) => branch.constantProperties.isNotEmpty,
    )) {
      final String condition = branch.constantProperties.entries
          .map(
            (MapEntry<String, Object?> entry) =>
                "payload[${dartStringLiteral(entry.key)}] == "
                '${_dartLiteral(entry.value)}',
          )
          .join(' && ');
      output
        ..writeln('    if (value is Map<Object?, Object?>) {')
        ..writeln('      final payload = decodeAcpObject(value);')
        ..writeln('      if ($condition) {')
        ..writeln(
          '        return ${branch.variantName}('
          '${branch.type!.decode('value')});',
        )
        ..writeln('      }')
        ..writeln('    }');
    }
    for (final _UnionBranch branch in branches.where(
      (_UnionBranch branch) =>
          branch.constantProperties.isEmpty && !branch.isOpenObject,
    )) {
      if (branch.isNull) {
        output
          ..writeln('    if (value == null) {')
          ..writeln('      return const ${branch.variantName}();')
          ..writeln('    }');
        continue;
      }
      final _DartType type = branch.type!;
      final String? guard = _unionGuard(type, 'value');
      if (guard != null) {
        if (type.collectionKind == _CollectionKind.list) {
          output
            ..writeln('    if ($guard) {')
            ..writeln('      try {')
            ..writeln(
              '        return ${branch.variantName}('
              '${_guardedUnionDecode(type, 'value')});',
            )
            ..writeln('      } on Object {')
            ..writeln('        // Try the next array-shaped member.')
            ..writeln('      }')
            ..writeln('    }');
        } else {
          output
            ..writeln('    if ($guard) {')
            ..writeln(
              '      return ${branch.variantName}(${type.decode('value')});',
            )
            ..writeln('    }');
        }
      } else {
        output
          ..writeln('    try {')
          ..writeln(
            '      return ${branch.variantName}(${type.decode('value')});',
          )
          ..writeln('    } on Object {')
          ..writeln('      // Try the next structurally distinct member.')
          ..writeln('    }');
      }
    }
    for (final _UnionBranch branch in branches.where(
      (_UnionBranch branch) => branch.isOpenObject,
    )) {
      output
        ..writeln('    if (value is Map<Object?, Object?>) {')
        ..writeln(
          '      return ${branch.variantName}('
          'AcpJsonObject.fromObject(value));',
        )
        ..writeln('    }');
    }
    output
      ..writeln(
        "    throw const FormatException("
        "'Value does not match ${definition.name}');",
      )
      ..writeln('  }')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  Object? encode($typeName value) => value.toJson();')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Shared codec for [$typeName].')
      ..writeln('const $codecType $codecValue = $codecType();');
  }

  String? _unionGuard(_DartType type, String value) {
    if (type.code == 'String') {
      return '$value is String';
    }
    if (type.code == 'int') {
      return '$value is int';
    }
    if (type.code == 'num') {
      return '$value is num';
    }
    if (type.code == 'bool') {
      return '$value is bool';
    }
    if (type.collectionKind == _CollectionKind.list) {
      return '$value is List<Object?>';
    }
    return null;
  }

  String _guardedUnionDecode(_DartType type, String value) =>
      type.decode(value).replaceAll('($value as List<Object?>)', value);
}
