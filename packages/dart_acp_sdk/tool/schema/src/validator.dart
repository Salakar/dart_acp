import 'json_schema.dart';
import 'naming.dart';
import 'schema_loader.dart';

const Set<String> _supportedSchemaKeywords = <String>{
  r'$ref',
  'additionalProperties',
  'allOf',
  'anyOf',
  'const',
  'contentEncoding',
  'default',
  'description',
  'discriminator',
  'enum',
  'format',
  'items',
  'maxItems',
  'maxLength',
  'maximum',
  'minItems',
  'minLength',
  'minimum',
  'not',
  'oneOf',
  'pattern',
  'properties',
  'required',
  'title',
  'type',
  'unevaluatedProperties',
  'x-deserialize-default-on-error',
  'x-deserialize-skip-invalid-items',
  'x-docs-ignore',
  'x-method',
  'x-side',
};

/// The kind of a schema-declared method payload.
enum MethodPayloadKind {
  /// Parameters for a request.
  request,

  /// Result for a request.
  response,

  /// Parameters for a notification.
  notification,
}

/// Validated facts for a request or notification.
final class MethodFact {
  /// Creates validated method facts.
  const MethodFact({
    required this.side,
    required this.metadataKey,
    required this.method,
    required this.kind,
    required this.paramsDefinition,
    required this.resultDefinition,
    required this.documentation,
  });

  /// Receiving side from method metadata.
  final String side;

  /// Stable code-generation key from method metadata.
  final String metadataKey;

  /// Exact JSON-RPC method.
  final String method;

  /// Request or notification.
  final MethodPayloadKind kind;

  /// Request or notification `$defs` name.
  final String paramsDefinition;

  /// Response `$defs` name for requests.
  final String? resultDefinition;

  /// Parameter definition documentation.
  final String? documentation;
}

/// Validates supported schema structure and all local references.
void validateSchema(SchemaDocument document) {
  final names = <String>{};
  for (final SchemaDefinition definition in document.definitions.values) {
    final String dartName = dartTypeName(definition.name);
    if (!names.add(dartName)) {
      throw StateError(
        'Dart definition-name collision at $dartName in '
        '${document.sourceName}',
      );
    }
    _validateNode(
      definition.node.raw,
      pointer: '#/\$defs/${definition.name}',
      definitionNames: document.definitions.keys.toSet(),
    );
  }
}

/// Validates metadata and correlates concrete parameter/result definitions.
List<MethodFact> validateAndCollectMethods(
  SchemaDocument schema,
  MethodMetadata metadata,
) {
  if (metadata.version != 1 && metadata.version != 2) {
    throw StateError('Unsupported ACP metadata version ${metadata.version}');
  }

  final byMethod = <String, List<({String name, MethodPayloadKind kind})>>{};
  for (final SchemaDefinition definition in schema.definitions.values) {
    final Object? methodValue = definition.node.raw['x-method'];
    if (methodValue == null) {
      continue;
    }
    if (methodValue is! String) {
      throw FormatException('x-method must be a string on ${definition.name}');
    }
    final MethodPayloadKind kind;
    if (definition.name.endsWith('Notification')) {
      kind = MethodPayloadKind.notification;
    } else if (definition.name.endsWith('Request')) {
      kind = MethodPayloadKind.request;
    } else if (definition.name.endsWith('Response')) {
      kind = MethodPayloadKind.response;
    } else {
      throw StateError('Cannot determine payload kind for ${definition.name}');
    }
    byMethod
        .putIfAbsent(
          methodValue,
          () => <({String name, MethodPayloadKind kind})>[],
        )
        .add((name: definition.name, kind: kind));
  }

  final facts = <MethodFact>[];
  final metadataMethods = <String>{};
  for (final method in metadata.methods) {
    metadataMethods.add(method.method);
    final payloads = byMethod[method.method];
    if (payloads == null || payloads.isEmpty) {
      throw StateError(
        'Metadata method ${method.method} has no schema payload',
      );
    }
    final requests = payloads
        .where(
          (({MethodPayloadKind kind, String name}) payload) =>
              payload.kind == MethodPayloadKind.request,
        )
        .toList(growable: false);
    final responses = payloads
        .where(
          (({MethodPayloadKind kind, String name}) payload) =>
              payload.kind == MethodPayloadKind.response,
        )
        .toList(growable: false);
    final notifications = payloads
        .where(
          (({MethodPayloadKind kind, String name}) payload) =>
              payload.kind == MethodPayloadKind.notification,
        )
        .toList(growable: false);

    if (requests.length > 1 || responses.length > 1) {
      throw StateError(
        'Method ${method.method} has ambiguous request/response definitions',
      );
    }
    if (requests.isNotEmpty) {
      if (responses.length != 1) {
        throw StateError(
          'Request ${method.method} has no unique response definition',
        );
      }
      final String paramsName = requests.single.name;
      facts.add(
        MethodFact(
          side: method.side,
          metadataKey: method.dartKey,
          method: method.method,
          kind: MethodPayloadKind.request,
          paramsDefinition: paramsName,
          resultDefinition: responses.single.name,
          documentation: schema.definitions[paramsName]?.description,
        ),
      );
    }
    for (final notification in notifications) {
      facts.add(
        MethodFact(
          side: method.side,
          metadataKey: method.dartKey,
          method: method.method,
          kind: MethodPayloadKind.notification,
          paramsDefinition: notification.name,
          resultDefinition: null,
          documentation: schema.definitions[notification.name]?.description,
        ),
      );
    }
    if (requests.isEmpty && notifications.isEmpty) {
      throw StateError('Method ${method.method} has only a response payload');
    }
  }

  for (final String schemaMethod in byMethod.keys) {
    if (!metadataMethods.contains(schemaMethod)) {
      throw StateError(
        'Schema method $schemaMethod is absent from method metadata',
      );
    }
  }

  facts.sort((MethodFact left, MethodFact right) {
    final int byMethod = left.method.compareTo(right.method);
    if (byMethod != 0) {
      return byMethod;
    }
    final int bySide = left.side.compareTo(right.side);
    return bySide != 0 ? bySide : left.kind.index.compareTo(right.kind.index);
  });
  return List<MethodFact>.unmodifiable(facts);
}

void _validateNode(
  Map<String, Object?> node, {
  required String pointer,
  required Set<String> definitionNames,
}) {
  for (final String key in node.keys) {
    if (!_supportedSchemaKeywords.contains(key)) {
      throw StateError('Unsupported schema keyword "$key" at $pointer');
    }
    if (key.startsWith('x-deserialize-') &&
        key != 'x-deserialize-default-on-error' &&
        key != 'x-deserialize-skip-invalid-items') {
      throw StateError('Unhandled deserialization extension "$key"');
    }
  }

  final Object? reference = node[r'$ref'];
  if (reference != null) {
    if (reference is! String || !reference.startsWith(r'#/$defs/')) {
      throw StateError('Unsupported reference "$reference" at $pointer');
    }
    final String name = reference.substring(r'#/$defs/'.length);
    if (!definitionNames.contains(name)) {
      throw StateError('Missing definition "$name" referenced at $pointer');
    }
  }

  final Object? properties = node['properties'];
  if (properties is Map<Object?, Object?>) {
    for (final MapEntry<Object?, Object?> entry in properties.entries) {
      final Object? key = entry.key;
      if (key is! String) {
        throw StateError('Non-string property name at $pointer');
      }
      _validateNode(
        _stringMap(entry.value, '$pointer/properties/$key'),
        pointer: '$pointer/properties/$key',
        definitionNames: definitionNames,
      );
    }
  }

  for (final String composition in const <String>['allOf', 'anyOf', 'oneOf']) {
    final Object? value = node[composition];
    if (value == null) {
      continue;
    }
    if (value is! List<Object?> || value.isEmpty) {
      throw StateError('$composition must be a nonempty array at $pointer');
    }
    for (int index = 0; index < value.length; index += 1) {
      _validateNode(
        _stringMap(value[index], '$pointer/$composition/$index'),
        pointer: '$pointer/$composition/$index',
        definitionNames: definitionNames,
      );
    }
  }

  for (final String childKey in const <String>['items', 'not']) {
    final Object? child = node[childKey];
    if (child is Map<Object?, Object?>) {
      _validateNode(
        _stringMap(child, '$pointer/$childKey'),
        pointer: '$pointer/$childKey',
        definitionNames: definitionNames,
      );
    }
  }
  for (final String childKey in const <String>[
    'additionalProperties',
    'unevaluatedProperties',
  ]) {
    final Object? child = node[childKey];
    if (child is Map<Object?, Object?>) {
      _validateNode(
        _stringMap(child, '$pointer/$childKey'),
        pointer: '$pointer/$childKey',
        definitionNames: definitionNames,
      );
    }
  }
}

Map<String, Object?> _stringMap(Object? value, String context) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException('Expected an object at $context');
  }
  final result = <String, Object?>{};
  for (final MapEntry<Object?, Object?> entry in value.entries) {
    final Object? key = entry.key;
    if (key is! String) {
      throw FormatException('Expected string keys at $context');
    }
    result[key] = entry.value;
  }
  return result;
}
