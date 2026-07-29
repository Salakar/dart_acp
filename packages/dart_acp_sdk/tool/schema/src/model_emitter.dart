import 'json_schema.dart';
import 'naming.dart';

part 'model_emitter_composition.dart';
part 'model_emitter_object.dart';
part 'model_emitter_scalar.dart';
part 'model_emitter_tagged_union.dart';
part 'model_emitter_types.dart';
part 'model_emitter_untagged_union.dart';

/// Emits one isolated protocol model library.
final class ModelEmitter {
  /// Creates a model emitter.
  const ModelEmitter({
    required this.schema,
    required this.sourceDigest,
    required this.libraryLabel,
  });

  /// Source schema.
  final SchemaDocument schema;

  /// Source schema SHA-256.
  final String sourceDigest;

  /// Human-readable protocol/stability lane.
  final String libraryLabel;

  /// Emits the complete Dart library.
  String emit() {
    final output = StringBuffer()..write(_emitHeader());
    for (final String chunk in _definitionChunks()) {
      output.write(chunk);
    }
    return output.toString();
  }

  /// Emits each named schema definition independently for tooling inventory.
  Map<String, String> emitDefinitionSources() {
    final sources = <String, String>{};
    for (final SchemaDefinition definition in schema.definitions.values) {
      final output = StringBuffer();
      _emitDefinition(output, definition);
      output.writeln();
      sources[definition.name] = output.toString();
    }
    return Map<String, String>.unmodifiable(sources);
  }

  List<String> _definitionChunks() =>
      emitDefinitionSources().values.toList(growable: false);

  String _emitHeader() {
    final output = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.');
    output
      ..writeln(
        '// ignore_for_file: prefer_initializing_formals, '
        'prefer_null_aware_operators, prefer_if_null_operators',
      )
      ..writeln('// Source: ${schema.sourceName}')
      ..writeln('// SHA-256: $sourceDigest')
      ..writeln()
      ..writeln("import 'package:json_annotation/json_annotation.dart';")
      ..writeln()
      ..writeln("import '../../../../common/json_value.dart';")
      ..writeln("import '../../../../common/patch.dart';")
      ..writeln("import '../../../../common/value_types.dart';")
      ..writeln("import '../../../method.dart';")
      ..writeln("import '../../../resilient_decoder.dart';")
      ..writeln()
      ..writeln("part 'models.g.dart';");
    output
      ..writeln()
      ..writeln('/// Every schema definition generated for $libraryLabel.')
      ..writeln('const Set<String> schemaDefinitionNames = <String>{');
    for (final String name in schema.definitions.keys) {
      output.writeln('  ${dartStringLiteral(name)},');
    }
    output
      ..writeln('};')
      ..writeln()
      ..writeln('/// SHA-256 of the schema that produced this library.')
      ..writeln(
        'const String schemaSourceSha256 = '
        '${dartStringLiteral(sourceDigest)};',
      )
      ..writeln();
    return output.toString();
  }

  void _emitDefinition(StringBuffer output, SchemaDefinition definition) {
    final TaggedUnionInfo? tagged = definition.taggedUnion;
    if (tagged != null) {
      _emitTaggedUnion(output, definition, tagged);
      return;
    }
    switch (definition.kind) {
      case SchemaDefinitionKind.object:
        _emitObject(output, definition);
        return;
      case SchemaDefinitionKind.string:
        _emitStringValue(output, definition);
        return;
      case SchemaDefinitionKind.integer:
        _emitIntegerValue(output, definition);
        return;
      case SchemaDefinitionKind.number:
        _emitNumberValue(output, definition);
        return;
      case SchemaDefinitionKind.boolean:
        _emitBooleanValue(output, definition);
        return;
      case SchemaDefinitionKind.array:
        _emitArrayValue(output, definition);
        return;
      case SchemaDefinitionKind.oneOf:
      case SchemaDefinitionKind.anyOf:
        if (_emitObjectComposition(output, definition)) {
          return;
        }
        final SchemaDefinitionKind? scalarKind = _scalarUnionKind(definition);
        switch (scalarKind) {
          case SchemaDefinitionKind.string:
            _emitStringValue(output, definition);
            return;
          case SchemaDefinitionKind.integer:
            _emitIntegerValue(output, definition);
            return;
          case SchemaDefinitionKind.number:
            _emitNumberValue(output, definition);
            return;
          case SchemaDefinitionKind.boolean:
            _emitBooleanValue(output, definition);
            return;
          case null:
          case SchemaDefinitionKind.object:
          case SchemaDefinitionKind.array:
          case SchemaDefinitionKind.oneOf:
          case SchemaDefinitionKind.anyOf:
          case SchemaDefinitionKind.unconstrained:
            if (!_emitUntaggedUnion(output, definition)) {
              _emitJsonBoundary(output, definition);
            }
            return;
        }
      case SchemaDefinitionKind.unconstrained:
        _emitJsonBoundary(output, definition);
        return;
    }
  }
}
