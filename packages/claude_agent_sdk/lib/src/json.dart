import 'dart:convert';

/// A JSON value at an intentional serialization or protocol boundary.
typedef JsonValue = Object?;

/// A JSON object at an intentional serialization or protocol boundary.
typedef JsonMap = Map<String, JsonValue>;

/// Returns a recursively immutable copy of a JSON object.
JsonMap immutableJsonMap(Map<Object?, Object?> value) {
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    final key = entry.key;
    if (key is! String) {
      throw FormatException('JSON object key must be a string: $key');
    }
    result[key] = immutableJsonValue(entry.value);
  }
  return Map<String, Object?>.unmodifiable(result);
}

/// Returns a recursively immutable JSON-compatible value.
JsonValue immutableJsonValue(Object? value) => switch (value) {
  final Map<String, Object?> map => immutableJsonMap(map),
  final Map<Object?, Object?> map => immutableJsonMap(map),
  final List<Object?> list => List<Object?>.unmodifiable(
    list.map(immutableJsonValue),
  ),
  null || String() || num() || bool() => value,
  _ => throw FormatException(
    'Value is not JSON-compatible: ${value.runtimeType}',
  ),
};

/// Validates [value] as a JSON object and returns an immutable copy.
JsonMap asJsonMap(Object? value, String context) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException('$context must be a JSON object');
  }
  return immutableJsonMap(value);
}

/// Validates [value] as a JSON array and returns an immutable copy.
List<Object?> asJsonList(Object? value, String context) {
  if (value is! List<Object?>) {
    throw FormatException('$context must be a JSON array');
  }
  return List<Object?>.unmodifiable(value.map(immutableJsonValue));
}

/// Reads a required string field from [map].
String requiredString(JsonMap map, String key, String context) {
  final value = map[key];
  if (value is! String) {
    throw FormatException('$context.$key must be a string');
  }
  return value;
}

/// Reads a required integer field from [map].
int requiredInt(JsonMap map, String key, String context) {
  final value = map[key];
  if (value is! int) {
    throw FormatException('$context.$key must be an integer');
  }
  return value;
}

/// Reads a required numeric field from [map].
num requiredNum(JsonMap map, String key, String context) {
  final value = map[key];
  if (value is! num) {
    throw FormatException('$context.$key must be a number');
  }
  return value;
}

/// Reads a required Boolean field from [map].
bool requiredBool(JsonMap map, String key, String context) {
  final value = map[key];
  if (value is! bool) {
    throw FormatException('$context.$key must be a boolean');
  }
  return value;
}

/// Reads an optional string field from [map].
String? optionalString(JsonMap map, String key, String context) {
  final value = map[key];
  if (value == null) return null;
  if (value is! String) {
    throw FormatException('$context.$key must be a string or null');
  }
  return value;
}

/// Reads an optional integer field from [map].
int? optionalInt(JsonMap map, String key, String context) {
  final value = map[key];
  if (value == null) return null;
  if (value is! int) {
    throw FormatException('$context.$key must be an integer or null');
  }
  return value;
}

/// Reads an optional numeric field from [map] as a double.
double? optionalDouble(JsonMap map, String key, String context) {
  final value = map[key];
  if (value == null) return null;
  if (value is! num) {
    throw FormatException('$context.$key must be a number or null');
  }
  return value.toDouble();
}

/// Reads an optional Boolean field from [map].
bool? optionalBool(JsonMap map, String key, String context) {
  final value = map[key];
  if (value == null) return null;
  if (value is! bool) {
    throw FormatException('$context.$key must be a boolean or null');
  }
  return value;
}

/// Reads an optional JSON-object field from [map].
JsonMap? optionalMap(JsonMap map, String key, String context) {
  final value = map[key];
  if (value == null) return null;
  return asJsonMap(value, '$context.$key');
}

/// Encodes [value] as one newline-delimited JSON record.
String encodeJsonLine(JsonMap value) => '${jsonEncode(value)}\n';
