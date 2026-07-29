import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

/// A value that can be represented by JSON without using `dynamic`.
sealed class AcpJsonValue {
  /// Creates a JSON value.
  const AcpJsonValue();

  /// Converts a Dart JSON-like value into an immutable [AcpJsonValue].
  ///
  /// Supported inputs are `null`, booleans, finite numbers, strings, lists,
  /// maps with string keys, and existing [AcpJsonValue] instances.
  factory AcpJsonValue.fromObject(
    Object? value, {
    int maxDepth = 128,
    int maxCollectionEntries = 1000000,
  }) {
    if (maxDepth < 0) {
      throw RangeError.range(maxDepth, 0, null, 'maxDepth');
    }
    if (maxCollectionEntries < 0) {
      throw RangeError.range(
        maxCollectionEntries,
        0,
        null,
        'maxCollectionEntries',
      );
    }
    return _fromObject(
      value,
      depth: 0,
      maxDepth: maxDepth,
      budget: _EntryBudget(maxCollectionEntries),
    );
  }

  /// Converts this value to values accepted by `dart:convert`.
  Object? toObject();

  static AcpJsonValue _fromObject(
    Object? value, {
    required int depth,
    required int maxDepth,
    required _EntryBudget budget,
  }) {
    if (depth > maxDepth) {
      throw const FormatException('JSON value exceeds the maximum depth');
    }
    if (value is AcpJsonValue) {
      return value;
    }
    if (value == null) {
      return const AcpJsonNull();
    }
    if (value is bool) {
      return AcpJsonBoolean(value);
    }
    if (value is num) {
      return AcpJsonNumber(value);
    }
    if (value is String) {
      return AcpJsonString(value);
    }
    if (value is List<Object?>) {
      budget.consume(value.length);
      return AcpJsonArray(
        value
            .map(
              (Object? item) => _fromObject(
                item,
                depth: depth + 1,
                maxDepth: maxDepth,
                budget: budget,
              ),
            )
            .toList(growable: false),
      );
    }
    if (value is Map<Object?, Object?>) {
      budget.consume(value.length);
      final converted = <String, AcpJsonValue>{};
      for (final MapEntry<Object?, Object?> entry in value.entries) {
        final Object? key = entry.key;
        if (key is! String) {
          throw FormatException('JSON object key is not a string: $key');
        }
        converted[key] = _fromObject(
          entry.value,
          depth: depth + 1,
          maxDepth: maxDepth,
          budget: budget,
        );
      }
      return AcpJsonObject(converted);
    }
    throw FormatException(
      'Unsupported JSON value of type ${value.runtimeType}',
    );
  }
}

/// An interface for protocol values with an explicit recursive JSON boundary.
abstract interface class AcpJsonEncodable {
  /// Converts this protocol value to its immutable JSON representation.
  AcpJsonValue toAcpJson();
}

/// The JSON `null` value.
final class AcpJsonNull extends AcpJsonValue {
  /// Creates the JSON `null` value.
  const AcpJsonNull();

  @override
  Object? toObject() => null;

  @override
  bool operator ==(Object other) => other is AcpJsonNull;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'null';
}

/// A JSON boolean.
final class AcpJsonBoolean extends AcpJsonValue {
  /// Creates a JSON boolean.
  const AcpJsonBoolean(this.value);

  /// The boolean value.
  final bool value;

  @override
  Object toObject() => value;

  @override
  bool operator ==(Object other) =>
      other is AcpJsonBoolean && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

/// A finite JSON number.
final class AcpJsonNumber extends AcpJsonValue {
  /// Creates a finite JSON number.
  AcpJsonNumber(this.value) {
    if (!value.isFinite) {
      throw FormatException('JSON numbers must be finite: $value');
    }
  }

  /// The finite numeric value.
  final num value;

  @override
  Object toObject() => value;

  @override
  bool operator ==(Object other) =>
      other is AcpJsonNumber && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

/// A JSON string.
final class AcpJsonString extends AcpJsonValue {
  /// Creates a JSON string.
  const AcpJsonString(this.value);

  /// The string value.
  final String value;

  @override
  Object toObject() => value;

  @override
  bool operator ==(Object other) =>
      other is AcpJsonString && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// An immutable JSON array.
final class AcpJsonArray extends AcpJsonValue
    with ListMixin<AcpJsonValue>
    implements AcpJsonEncodable {
  /// Creates an immutable JSON array.
  AcpJsonArray(Iterable<AcpJsonValue> values)
    : _values = List<AcpJsonValue>.unmodifiable(values);

  final List<AcpJsonValue> _values;

  @override
  int get length => _values.length;

  @override
  set length(int value) {
    throw UnsupportedError('AcpJsonArray is immutable');
  }

  @override
  AcpJsonValue operator [](int index) => _values[index];

  @override
  void operator []=(int index, AcpJsonValue value) {
    throw UnsupportedError('AcpJsonArray is immutable');
  }

  @override
  List<Object?> toObject() => <Object?>[
    for (final AcpJsonValue value in _values) value.toObject(),
  ];

  @override
  AcpJsonValue toAcpJson() => this;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! AcpJsonArray || other.length != length) {
      return false;
    }
    for (int index = 0; index < length; index += 1) {
      if (other[index] != this[index]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_values);
}

/// An immutable JSON object whose keys are always strings.
final class AcpJsonObject extends AcpJsonValue
    with MapMixin<String, AcpJsonValue>
    implements AcpJsonEncodable {
  /// Creates an immutable JSON object.
  AcpJsonObject(Map<String, AcpJsonValue> values)
    : _values = Map<String, AcpJsonValue>.unmodifiable(values);

  /// Converts a Dart JSON-like map to an immutable JSON object.
  factory AcpJsonObject.fromObject(
    Object? value, {
    int maxDepth = 128,
    int maxCollectionEntries = 1000000,
  }) {
    final converted = AcpJsonValue.fromObject(
      value,
      maxDepth: maxDepth,
      maxCollectionEntries: maxCollectionEntries,
    );
    if (converted is! AcpJsonObject) {
      throw FormatException('Expected a JSON object, got ${value.runtimeType}');
    }
    return converted;
  }

  final Map<String, AcpJsonValue> _values;

  @override
  Iterable<String> get keys => _values.keys;

  @override
  AcpJsonValue? operator [](Object? key) => _values[key];

  @override
  void operator []=(String key, AcpJsonValue value) {
    throw UnsupportedError('AcpJsonObject is immutable');
  }

  @override
  void clear() {
    throw UnsupportedError('AcpJsonObject is immutable');
  }

  @override
  AcpJsonValue? remove(Object? key) {
    throw UnsupportedError('AcpJsonObject is immutable');
  }

  /// Returns a copy without [key].
  AcpJsonObject without(String key) => AcpJsonObject(<String, AcpJsonValue>{
    for (final MapEntry<String, AcpJsonValue> entry in _values.entries)
      if (entry.key != key) entry.key: entry.value,
  });

  /// Returns a copy containing [key] set to [value].
  AcpJsonObject withValue(String key, AcpJsonValue value) =>
      AcpJsonObject(<String, AcpJsonValue>{..._values, key: value});

  @override
  Map<String, Object?> toObject() => <String, Object?>{
    for (final MapEntry<String, AcpJsonValue> entry in _values.entries)
      entry.key: entry.value.toObject(),
  };

  @override
  AcpJsonValue toAcpJson() => this;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! AcpJsonObject || other.length != length) {
      return false;
    }
    for (final MapEntry<String, AcpJsonValue> entry in _values.entries) {
      if (other[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final entries = _values.entries.toList(growable: false)
      ..sort(
        (
          MapEntry<String, AcpJsonValue> left,
          MapEntry<String, AcpJsonValue> right,
        ) => left.key.compareTo(right.key),
      );
    return Object.hashAll(
      entries.map(
        (MapEntry<String, AcpJsonValue> entry) =>
            Object.hash(entry.key, entry.value),
      ),
    );
  }
}

/// Converts any recursive JSON value to and from [AcpJsonValue].
final class AcpJsonValueConverter
    implements JsonConverter<AcpJsonValue, Object?> {
  /// Creates a JSON value converter.
  const AcpJsonValueConverter();

  @override
  AcpJsonValue fromJson(Object? json) => AcpJsonValue.fromObject(json);

  @override
  Object? toJson(AcpJsonValue object) => object.toObject();
}

/// Converts nullable recursive JSON values.
final class AcpNullableJsonValueConverter
    implements JsonConverter<AcpJsonValue?, Object?> {
  /// Creates a nullable JSON value converter.
  const AcpNullableJsonValueConverter();

  @override
  AcpJsonValue? fromJson(Object? json) =>
      json == null ? null : AcpJsonValue.fromObject(json);

  @override
  Object? toJson(AcpJsonValue? object) => object?.toObject();
}

/// Strictly converts JSON objects.
final class AcpJsonObjectConverter
    implements JsonConverter<AcpJsonObject, Object?> {
  /// Creates a strict JSON object converter.
  const AcpJsonObjectConverter();

  @override
  AcpJsonObject fromJson(Object? json) => AcpJsonObject.fromObject(json);

  @override
  Object toJson(AcpJsonObject object) => object.toObject();
}

/// Converts nullable JSON objects.
final class AcpNullableJsonObjectConverter
    implements JsonConverter<AcpJsonObject?, Object?> {
  /// Creates a nullable JSON object converter.
  const AcpNullableJsonObjectConverter();

  @override
  AcpJsonObject? fromJson(Object? json) =>
      json == null ? null : AcpJsonObject.fromObject(json);

  @override
  Object? toJson(AcpJsonObject? object) => object?.toObject();
}

/// Implements ACP's forgiving `_meta` decoding rule.
///
/// A missing, null, or malformed metadata value becomes `null`. Valid objects
/// remain opaque and round-trip without interpreting their keys.
final class AcpMetaConverter implements JsonConverter<AcpJsonObject?, Object?> {
  /// Creates an ACP metadata converter.
  const AcpMetaConverter();

  @override
  AcpJsonObject? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    try {
      return AcpJsonObject.fromObject(json);
    } on FormatException {
      return null;
    }
  }

  @override
  Object? toJson(AcpJsonObject? object) => object?.toObject();
}

final class _EntryBudget {
  _EntryBudget(this.remaining);

  int remaining;

  void consume(int count) {
    remaining -= count;
    if (remaining < 0) {
      throw const FormatException(
        'JSON value exceeds the maximum collection-entry count',
      );
    }
  }
}
