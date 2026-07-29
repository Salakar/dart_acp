import 'dart:convert';
import 'dart:typed_data';

import '../common/bounded_json.dart';
import '../json_rpc/message.dart';
import '../transport/line_buffer.dart';

/// A safe diagnostic emitted while parsing a remote transport.
final class AcpRemoteDiagnostic {
  /// Creates a diagnostic.
  const AcpRemoteDiagnostic(this.message);

  /// Redacted diagnostic text.
  final String message;

  @override
  String toString() => message;
}

/// Receives redacted remote-transport diagnostics.
typedef AcpRemoteDiagnosticHandler =
    void Function(AcpRemoteDiagnostic diagnostic);

/// Limits applied to one server-sent event stream.
final class AcpSseLimits {
  /// Creates validated limits.
  const AcpSseLimits({
    this.maximumLineBytes = 16 * 1024 * 1024,
    this.maximumEventBytes = 16 * 1024 * 1024,
    this.maximumJsonNestingDepth = 128,
  });

  /// Maximum bytes in one SSE line.
  final int maximumLineBytes;

  /// Maximum combined UTF-8 bytes in one event's `data` fields.
  final int maximumEventBytes;

  /// Maximum structural object/array nesting in one event payload.
  final int maximumJsonNestingDepth;

  /// Validates every limit even when Dart assertions are disabled.
  void validate() {
    if (maximumLineBytes <= 0) {
      throw ArgumentError.value(
        maximumLineBytes,
        'maximumLineBytes',
        'must be positive',
      );
    }
    if (maximumEventBytes <= 0) {
      throw ArgumentError.value(
        maximumEventBytes,
        'maximumEventBytes',
        'must be positive',
      );
    }
    if (maximumJsonNestingDepth <= 0) {
      throw ArgumentError.value(
        maximumJsonNestingDepth,
        'maximumJsonNestingDepth',
        'must be positive',
      );
    }
  }
}

/// Thrown when a complete SSE event exceeds its configured bound.
final class AcpSseLimitException implements Exception {
  /// Creates a limit exception.
  const AcpSseLimitException({required this.length, required this.maximum});

  /// Observed event bytes.
  final int length;

  /// Configured maximum.
  final int maximum;

  @override
  String toString() =>
      'AcpSseLimitException(length: $length, maximum: $maximum)';
}

/// Encodes one JSON-RPC value as an SSE data event.
String encodeSseEvent(JsonRpcWireMessage message) =>
    'data: ${jsonEncode(message.toJson())}\n\n';

/// Encodes an SSE keepalive comment.
String encodeSseKeepAlive() => ':\n\n';

/// Decodes JSON objects and arrays from a byte-oriented SSE response body.
///
/// Comments and non-`data` fields are ignored. Malformed JSON and primitive
/// payloads emit a redacted diagnostic and are skipped so the JSON-RPC layer
/// remains responsible for message-shape validation.
Stream<Object> decodeSseJson(
  Stream<List<int>> body, {
  AcpSseLimits limits = const AcpSseLimits(),
  AcpRemoteDiagnosticHandler? onDiagnostic,
}) async* {
  limits.validate();
  final lines = LineBuffer(maximumLineBytes: limits.maximumLineBytes);
  final dataLines = <String>[];
  var dataBytes = 0;

  void diagnose(AcpRemoteDiagnostic diagnostic) {
    try {
      onDiagnostic?.call(diagnostic);
    } on Object {
      // Diagnostics are observational and must not alter stream lifecycle.
    }
  }

  Object? takeEvent() {
    if (dataLines.isEmpty) {
      return null;
    }
    final data = dataLines.join('\n');
    dataLines.clear();
    dataBytes = 0;
    if (data.trim().isEmpty) {
      return null;
    }
    final Object? decoded;
    try {
      decoded = decodeBoundedJson(
        data,
        maximumNestingDepth: limits.maximumJsonNestingDepth,
      );
    } on FormatException {
      diagnose(
        const AcpRemoteDiagnostic('Skipping malformed SSE JSON payload'),
      );
      return null;
    }
    if (decoded is Map<Object?, Object?> || decoded is List<Object?>) {
      return decoded;
    }
    diagnose(const AcpRemoteDiagnostic('Skipping primitive SSE JSON payload'));
    return null;
  }

  void addEventLine(String line) {
    if (!line.startsWith('data:')) {
      return;
    }
    var value = line.substring(5);
    if (value.startsWith(' ')) {
      value = value.substring(1);
    }
    final nextLength =
        dataBytes + utf8.encode(value).length + (dataLines.isEmpty ? 0 : 1);
    if (nextLength > limits.maximumEventBytes) {
      throw AcpSseLimitException(
        length: nextLength,
        maximum: limits.maximumEventBytes,
      );
    }
    dataBytes = nextLength;
    dataLines.add(value);
  }

  String decodeLine(Uint8List bytes) {
    var line = utf8.decode(bytes);
    if (line.endsWith('\r')) {
      line = line.substring(0, line.length - 1);
    }
    return line;
  }

  await for (final chunk in body) {
    for (final bytes in lines.add(chunk)) {
      final line = decodeLine(bytes);
      if (line.isEmpty) {
        final event = takeEvent();
        if (event != null) {
          yield event;
        }
      } else {
        addEventLine(line);
      }
    }
  }

  final finalBytes = lines.flush();
  if (finalBytes != null) {
    final line = decodeLine(finalBytes);
    if (line.isNotEmpty) {
      addEventLine(line);
    }
  }
  final event = takeEvent();
  if (event != null) {
    yield event;
  }
}
