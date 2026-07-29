/// A JSON-RPC request identifier.
///
/// ACP narrows JSON-RPC numeric identifiers to signed 64-bit integers. The
/// variants keep string and numeric identifiers distinct when used as map
/// keys.
sealed class JsonRpcId {
  const JsonRpcId();

  /// Creates a string identifier.
  const factory JsonRpcId.string(String value) = StringJsonRpcId;

  /// Creates a signed 64-bit numeric identifier.
  factory JsonRpcId.number(int value) = NumberJsonRpcId;

  /// Creates the explicit JSON `null` identifier.
  const factory JsonRpcId.nullValue() = NullJsonRpcId;

  /// Decodes and validates an identifier.
  factory JsonRpcId.fromJson(Object? value) {
    if (value is String) {
      return StringJsonRpcId(value);
    }
    if (value is num && NumberJsonRpcId.isValidJsonNumber(value)) {
      return NumberJsonRpcId(value.toInt());
    }
    if (value == null) {
      return const NullJsonRpcId();
    }
    throw FormatException('Invalid JSON-RPC id: $value');
  }

  /// The JSON-compatible representation.
  Object? toJson();

  /// A diagnostic key that preserves the identifier's JSON type.
  String get correlationKey;
}

/// A string JSON-RPC identifier.
final class StringJsonRpcId extends JsonRpcId {
  /// Creates a string identifier.
  const StringJsonRpcId(this.value);

  /// The string value.
  final String value;

  @override
  String get correlationKey => 'string:$value';

  @override
  String toJson() => value;

  @override
  bool operator ==(Object other) =>
      other is StringJsonRpcId && other.value == value;

  @override
  int get hashCode => Object.hash(StringJsonRpcId, value);

  @override
  String toString() => 'JsonRpcId.string($value)';
}

/// A numeric JSON-RPC identifier.
final class NumberJsonRpcId extends JsonRpcId {
  /// Creates a numeric identifier.
  ///
  /// Throws when [value] is outside ACP's signed 64-bit range.
  NumberJsonRpcId(this.value) {
    if (!isValidJsonNumber(value)) {
      throw RangeError.value(
        value,
        'value',
        'must fit a signed 64-bit integer',
      );
    }
  }

  /// The smallest numeric ACP request ID as an exact decimal string.
  static const String minimumValueText = '-9223372036854775808';

  /// The largest numeric ACP request ID as an exact decimal string.
  static const String maximumValueText = '9223372036854775807';

  static final double _minimumValue = double.parse(minimumValueText);
  static final double _exclusiveMaximumValue = double.parse(
    '9223372036854775808',
  );

  /// Whether [value] is mathematically integral and in signed 64-bit range.
  ///
  /// Numeric runtime types merge on web builds, so this validates the value
  /// rather than relying on `value is int`.
  static bool isValidJsonNumber(num value) =>
      value.isFinite &&
      value == value.truncate() &&
      value >= _minimumValue &&
      value < _exclusiveMaximumValue;

  /// The numeric value.
  final int value;

  @override
  String get correlationKey => 'number:$value';

  @override
  int toJson() => value;

  @override
  bool operator ==(Object other) =>
      other is NumberJsonRpcId && other.value == value;

  @override
  int get hashCode => Object.hash(NumberJsonRpcId, value);

  @override
  String toString() => 'JsonRpcId.number($value)';
}

/// The explicit JSON `null` request identifier.
final class NullJsonRpcId extends JsonRpcId {
  /// Creates the null identifier.
  const NullJsonRpcId();

  @override
  String get correlationKey => 'null';

  @override
  Object? toJson() => null;

  @override
  bool operator ==(Object other) => other is NullJsonRpcId;

  @override
  int get hashCode => Object.hash(NullJsonRpcId, null);

  @override
  String toString() => 'JsonRpcId.nullValue()';
}
