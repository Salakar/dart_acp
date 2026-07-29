import '../common/json_value.dart';
import '../common/patch.dart';
import '../common/value_types.dart';

/// Decodes one wire value to [T].
typedef AcpValueDecoder<T> = T Function(Object? value);

/// One recoverable or fatal protocol decoding problem.
final class AcpDecodingIssue {
  /// Creates a decoding issue.
  AcpDecodingIssue({
    required Iterable<Object> path,
    required this.message,
    this.cause,
  }) : path = List<Object>.unmodifiable(path);

  /// Property names and list indexes leading to the invalid value.
  final List<Object> path;

  /// A concise explanation that does not include the raw payload.
  final String message;

  /// The underlying exception, when retaining it is safe.
  final Object? cause;

  /// A JSONPath-like display path.
  String get displayPath {
    final buffer = StringBuffer(r'$');
    for (final Object segment in path) {
      if (segment is int) {
        buffer
          ..write('[')
          ..write(segment)
          ..write(']');
      } else {
        buffer
          ..write('.')
          ..write(segment);
      }
    }
    return buffer.toString();
  }

  @override
  String toString() => '$displayPath: $message';
}

/// A fatal ACP model decoding failure.
final class AcpDecodeException implements FormatException {
  /// Creates a fatal decoding failure.
  AcpDecodeException({required this.issue, this.source, this.offset});

  /// The structured decoding issue.
  final AcpDecodingIssue issue;

  @override
  String get message => issue.toString();

  @override
  final Object? source;

  @override
  final int? offset;

  @override
  String toString() => 'AcpDecodeException: $message';
}

/// A decoded value and all recoverable issues encountered while producing it.
final class AcpDecoded<T> {
  /// Creates a decoded result.
  AcpDecoded({required this.value, required Iterable<AcpDecodingIssue> issues})
    : issues = List<AcpDecodingIssue>.unmodifiable(issues);

  /// The decoded value.
  final T value;

  /// Recoverable invalid fields or list items.
  final List<AcpDecodingIssue> issues;
}

/// Implements ACP's field-level resilient-deserialization extensions.
///
/// This decoder is intentionally separate from JSON-RPC envelope parsing.
/// Required fields remain strict unless a schema explicitly supplies a
/// required-default-on-error policy.
final class AcpResilientDecoder {
  /// Creates a decoder for an object at an optional parent [path].
  AcpResilientDecoder(
    Map<String, Object?> input, {
    Iterable<Object> path = const <Object>[],
  }) : _input = Map<String, Object?>.unmodifiable(input),
       _path = List<Object>.unmodifiable(path);

  final Map<String, Object?> _input;
  final List<Object> _path;
  final List<AcpDecodingIssue> _issues = <AcpDecodingIssue>[];

  /// Recoverable issues accumulated so far.
  List<AcpDecodingIssue> get issues =>
      List<AcpDecodingIssue>.unmodifiable(_issues);

  /// Whether the input contains [key], including an explicit `null`.
  bool contains(String key) => _input.containsKey(key);

  /// Reads a strict required field.
  T required<T>(String key, AcpValueDecoder<T> decode) {
    if (!_input.containsKey(key)) {
      throw _failure(key, 'Missing required property');
    }
    return _decodeStrict(key, _input[key], decode);
  }

  /// Reads a strict optional field.
  T? optional<T>(String key, AcpValueDecoder<T> decode) {
    if (!_input.containsKey(key) || _input[key] == null) {
      return null;
    }
    return _decodeStrict(key, _input[key], decode);
  }

  /// Reads an optional field that becomes absent when invalid.
  AcpOptional<T> optionalOnError<T>(String key, AcpValueDecoder<T> decode) {
    if (!_input.containsKey(key) || _input[key] == null) {
      return AcpOptional<T>.absent();
    }
    try {
      return AcpOptional<T>.present(decode(_input[key]));
    } on Object catch (error) {
      _record(key, 'Invalid optional property; treated as absent', error);
      return AcpOptional<T>.absent();
    }
  }

  /// Reads a field whose invalid or missing value becomes [defaultValue].
  T defaultOnError<T>(String key, T defaultValue, AcpValueDecoder<T> decode) {
    if (!_input.containsKey(key)) {
      return defaultValue;
    }
    try {
      return decode(_input[key]);
    } on Object catch (error) {
      _record(key, 'Invalid property; schema default applied', error);
      return defaultValue;
    }
  }

  /// Reads a required field that defaults only when present but invalid.
  T requiredDefaultOnError<T>(
    String key,
    T defaultValue,
    AcpValueDecoder<T> decode,
  ) {
    if (!_input.containsKey(key)) {
      throw _failure(key, 'Missing required property');
    }
    try {
      return decode(_input[key]);
    } on Object catch (error) {
      _record(key, 'Invalid required property; schema default applied', error);
      return defaultValue;
    }
  }

  /// Reads a list and skips invalid items while preserving valid order.
  List<T> listSkippingInvalid<T>(
    String key,
    AcpValueDecoder<T> decodeItem, {
    bool isRequired = false,
    List<T>? defaultValue,
  }) {
    final fallback = defaultValue ?? <T>[];
    if (!_input.containsKey(key)) {
      if (isRequired) {
        throw _failure(key, 'Missing required property');
      }
      return List<T>.unmodifiable(fallback);
    }
    final Object? raw = _input[key];
    if (raw is! List<Object?>) {
      _record(key, 'Invalid list; schema default applied', raw);
      return List<T>.unmodifiable(fallback);
    }
    final decoded = <T>[];
    for (int index = 0; index < raw.length; index += 1) {
      try {
        decoded.add(decodeItem(raw[index]));
      } on Object catch (error) {
        _issues.add(
          AcpDecodingIssue(
            path: <Object>[..._path, key, index],
            message: 'Invalid list item; item skipped',
            cause: error,
          ),
        );
      }
    }
    return List<T>.unmodifiable(decoded);
  }

  /// Reads an omitted/null/value patch field.
  AcpPatch<T> patch<T>(String key, AcpValueDecoder<T> decode) {
    if (!_input.containsKey(key)) {
      return AcpPatch<T>.unchanged();
    }
    final Object? raw = _input[key];
    if (raw == null) {
      return AcpPatch<T>.clear();
    }
    return AcpPatch<T>.set(_decodeStrict(key, raw, decode));
  }

  /// Reads opaque `_meta`, applying its default-on-error behavior.
  AcpJsonObject? meta() {
    if (!_input.containsKey('_meta') || _input['_meta'] == null) {
      return null;
    }
    try {
      return AcpJsonObject.fromObject(_input['_meta']);
    } on Object catch (error) {
      _record('_meta', 'Invalid metadata; treated as absent', error);
      return null;
    }
  }

  /// Returns a result containing [value] and accumulated recoverable issues.
  AcpDecoded<T> finish<T>(T value) =>
      AcpDecoded<T>(value: value, issues: _issues);

  T _decodeStrict<T>(String key, Object? raw, AcpValueDecoder<T> decode) {
    try {
      return decode(raw);
    } on AcpDecodeException catch (error) {
      throw AcpDecodeException(
        issue: AcpDecodingIssue(
          path: <Object>[..._path, key, ...error.issue.path],
          message: error.issue.message,
          cause: error.issue.cause ?? error,
        ),
        source: error.source,
        offset: error.offset,
      );
    } on Object catch (error) {
      throw _failure(key, 'Invalid property', error);
    }
  }

  AcpDecodeException _failure(String key, String message, [Object? cause]) =>
      AcpDecodeException(
        issue: AcpDecodingIssue(
          path: <Object>[..._path, key],
          message: message,
          cause: cause,
        ),
      );

  void _record(String key, String message, Object? cause) {
    _issues.add(
      AcpDecodingIssue(
        path: <Object>[..._path, key],
        message: message,
        cause: cause,
      ),
    );
  }
}

/// Decodes a JSON object with string keys.
Map<String, Object?> decodeAcpObject(Object? value) {
  if (value is! Map<Object?, Object?>) {
    throw const FormatException('Expected a JSON object');
  }
  final result = <String, Object?>{};
  for (final MapEntry<Object?, Object?> entry in value.entries) {
    final Object? key = entry.key;
    if (key is! String) {
      throw const FormatException('Expected JSON object keys to be strings');
    }
    result[key] = entry.value;
  }
  return result;
}

/// Decodes a string.
String decodeAcpString(Object? value) {
  if (value is! String) {
    throw const FormatException('Expected a string');
  }
  return value;
}

/// Decodes a boolean.
bool decodeAcpBoolean(Object? value) {
  if (value is! bool) {
    throw const FormatException('Expected a boolean');
  }
  return value;
}

/// Decodes an integer.
int decodeAcpInteger(Object? value) {
  if (value is! int) {
    throw const FormatException('Expected an integer');
  }
  return value;
}

/// Decodes an integer constrained to the inclusive range.
int decodeAcpIntegerInRange(Object? value, int minimum, int maximum) {
  final int decoded = decodeAcpInteger(value);
  if (decoded < minimum || decoded > maximum) {
    throw RangeError.range(decoded, minimum, maximum, 'value');
  }
  return decoded;
}

/// Decodes a signed 64-bit integer.
AcpInt64 decodeAcpInt64(Object? value) =>
    AcpInt64(BigInt.from(decodeAcpInteger(value)));

/// Decodes an unsigned 64-bit integer without narrowing its model type.
AcpUint64 decodeAcpUint64(Object? value) =>
    AcpUint64(BigInt.from(decodeAcpInteger(value)));

/// Decodes an absolute RFC 3986 URI.
Uri decodeAcpUri(Object? value) {
  final Uri uri = Uri.parse(decodeAcpString(value));
  if (!uri.hasScheme) {
    throw const FormatException('Expected an absolute URI');
  }
  return uri;
}

/// Decodes an RFC 3339 date-time while preserving its wire spelling.
AcpDateTimeString decodeAcpDateTime(Object? value) =>
    AcpDateTimeString(decodeAcpString(value));

/// Decodes and validates a regular-expression string.
String decodeAcpRegexString(Object? value) {
  final String pattern = decodeAcpString(value);
  RegExp(pattern);
  return pattern;
}

/// Decodes a finite number.
num decodeAcpNumber(Object? value) {
  if (value is! num || !value.isFinite) {
    throw const FormatException('Expected a finite number');
  }
  return value;
}

/// Decodes an immutable recursive JSON value.
AcpJsonValue decodeAcpJsonValue(Object? value) =>
    AcpJsonValue.fromObject(value);
