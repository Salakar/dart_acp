import 'dart:collection';
import 'dart:convert';

import '../runtime/diagnostics.dart';

/// An immutable, validated JSON object.
final class CodexJsonObject {
  /// Validates and defensively copies [value].
  factory CodexJsonObject.from(Map<Object?, Object?> value) {
    return CodexJsonObject._(_copyObject(value, r'$'));
  }

  const CodexJsonObject._(this._value);

  /// An empty JSON object.
  static const CodexJsonObject empty = CodexJsonObject._(<String, Object?>{});

  final Map<String, Object?> _value;

  /// Whether [key] is present, including when its value is `null`.
  bool containsKey(String key) => _value.containsKey(key);

  /// Raw immutable JSON value for [key].
  Object? operator [](String key) => _value[key];

  /// Required string at [key].
  String requireString(String key) {
    final value = _value[key];
    if (value is String) {
      return value;
    }
    throw CodexProtocolException(
      r'$.'
      '$key must be a string',
    );
  }

  /// Optional string at [key].
  String? optionalString(String key) {
    final value = _value[key];
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    throw CodexProtocolException(
      r'$.'
      '$key must be a string or null',
    );
  }

  /// Required boolean at [key].
  bool requireBool(String key) {
    final value = _value[key];
    if (value is bool) {
      return value;
    }
    throw CodexProtocolException(
      r'$.'
      '$key must be a boolean',
    );
  }

  /// Optional finite number at [key].
  num? optionalNumber(String key) {
    final value = _value[key];
    if (value == null) {
      return null;
    }
    if (value is num && value.isFinite) {
      return value;
    }
    throw CodexProtocolException(
      r'$.'
      '$key must be a finite number or null',
    );
  }

  /// Optional exact integer at [key].
  int? optionalInt(String key) {
    final value = optionalNumber(key);
    if (value == null) {
      return null;
    }
    if (value == value.truncate()) {
      return value.toInt();
    }
    throw CodexProtocolException(
      r'$.'
      '$key must be an integer or null',
    );
  }

  /// Required object at [key].
  CodexJsonObject requireObject(String key) {
    final value = _value[key];
    if (value is Map<Object?, Object?>) {
      return CodexJsonObject.from(value);
    }
    throw CodexProtocolException(
      r'$.'
      '$key must be an object',
    );
  }

  /// Optional object at [key].
  CodexJsonObject? optionalObject(String key) {
    final value = _value[key];
    if (value == null) {
      return null;
    }
    if (value is Map<Object?, Object?>) {
      return CodexJsonObject.from(value);
    }
    throw CodexProtocolException(
      r'$.'
      '$key must be an object or null',
    );
  }

  /// Required immutable list at [key].
  List<Object?> requireList(String key) {
    final value = _value[key];
    if (value is List<Object?>) {
      return value;
    }
    throw CodexProtocolException(
      r'$.'
      '$key must be an array',
    );
  }

  /// Creates a detached JSON-compatible map.
  Map<String, Object?> toJson() => _copyObject(_value, r'$');

  /// Returns a bounded diagnostic representation.
  String preview({int maximumCharacters = 256}) {
    if (maximumCharacters < 0) {
      throw ArgumentError.value(
        maximumCharacters,
        'maximumCharacters',
        'must not be negative',
      );
    }
    final text = jsonEncode(_value);
    return text.length <= maximumCharacters
        ? text
        : '${text.substring(0, maximumCharacters)}…';
  }
}

Map<String, Object?> _copyObject(Map<Object?, Object?> source, String path) {
  final result = <String, Object?>{};
  for (final entry in source.entries) {
    final key = entry.key;
    if (key is! String) {
      throw CodexProtocolException('$path keys must be strings');
    }
    result[key] = _copyValue(entry.value, '$path.$key');
  }
  return UnmodifiableMapView<String, Object?>(result);
}

Object? _copyValue(Object? value, String path) => switch (value) {
  null || bool() || String() => value,
  num() when value.isFinite => value,
  num() => throw CodexProtocolException('$path must be finite'),
  Map<Object?, Object?>() => _copyObject(value, path),
  List<Object?>() => List<Object?>.unmodifiable(<Object?>[
    for (var index = 0; index < value.length; index += 1)
      _copyValue(value[index], '$path[$index]'),
  ]),
  _ => throw CodexProtocolException(
    '$path contains non-JSON ${value.runtimeType}',
  ),
};
