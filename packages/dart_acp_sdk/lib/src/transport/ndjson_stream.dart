import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '../common/bounded_json.dart';
import 'duplex_stream.dart';
import 'line_buffer.dart';

/// A diagnostic emitted while decoding NDJSON.
final class NdJsonDiagnostic {
  /// Creates a diagnostic.
  const NdJsonDiagnostic({required this.message, this.preview});

  /// A safe summary.
  final String message;

  /// A truncated input preview when available.
  final String? preview;
}

/// Receives NDJSON diagnostics.
typedef NdJsonDiagnosticHandler = void Function(NdJsonDiagnostic diagnostic);

/// Configuration for [ndJsonStream].
final class NdJsonStreamOptions {
  /// Creates NDJSON options.
  const NdJsonStreamOptions({
    this.maximumLineBytes = 16 * 1024 * 1024,
    this.maximumJsonNestingDepth = 128,
    this.maximumDiagnosticCharacters = 256,
    this.allowMalformedUtf8 = true,
    this.closeOutput = false,
    this.onDiagnostic,
  });

  /// Maximum bytes in one line, excluding LF.
  final int maximumLineBytes;

  /// Maximum structural object/array nesting accepted in one JSON line.
  final int maximumJsonNestingDepth;

  /// Maximum characters included in diagnostic previews.
  final int maximumDiagnosticCharacters;

  /// Whether invalid UTF-8 is replaced rather than rejected.
  final bool allowMalformedUtf8;

  /// Whether closing the encoded sink also closes the underlying output.
  final bool closeOutput;

  /// Optional diagnostic receiver.
  final NdJsonDiagnosticHandler? onDiagnostic;
}

/// Adapts byte streams to newline-delimited JSON values.
AcpDuplexStream<Object?> ndJsonStream({
  required AcpWritable<List<int>> output,
  required Stream<List<int>> input,
  NdJsonStreamOptions options = const NdJsonStreamOptions(),
}) {
  if (options.maximumDiagnosticCharacters < 0) {
    throw ArgumentError.value(
      options.maximumDiagnosticCharacters,
      'maximumDiagnosticCharacters',
      'must not be negative',
    );
  }
  if (options.maximumJsonNestingDepth <= 0) {
    throw ArgumentError.value(
      options.maximumJsonNestingDepth,
      'maximumJsonNestingDepth',
      'must be positive',
    );
  }
  return AcpDuplexStream<Object?>(
    readable: _decodeNdJson(input, options),
    writable: _encodedWritable(output, options.closeOutput),
  );
}

Stream<Object?> _decodeNdJson(
  Stream<List<int>> input,
  NdJsonStreamOptions options,
) {
  final LineBuffer lines = LineBuffer(
    maximumLineBytes: options.maximumLineBytes,
  );
  StreamSubscription<List<int>>? inputSubscription;
  late final StreamController<Object?> output;
  bool stopped = false;

  Future<void> stopWithError(Object error, StackTrace stackTrace) async {
    if (stopped) {
      return;
    }
    stopped = true;
    output.addError(error, stackTrace);
    await inputSubscription?.cancel();
    await output.close();
  }

  void addLine(Uint8List line) {
    final Object? value = _decodeLine(line, options);
    if (value != null) {
      output.add(value);
    }
  }

  output = StreamController<Object?>(
    sync: true,
    onListen: () {
      final StreamSubscription<List<int>> subscription = input.listen(
        (List<int> chunk) {
          if (stopped) {
            return;
          }
          try {
            for (final Uint8List line in lines.add(chunk)) {
              addLine(line);
            }
          } on Object catch (error, stackTrace) {
            unawaited(stopWithError(error, stackTrace));
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          unawaited(stopWithError(error, stackTrace));
        },
        onDone: () {
          if (stopped) {
            return;
          }
          stopped = true;
          try {
            final Uint8List? finalLine = lines.flush();
            if (finalLine != null) {
              addLine(finalLine);
            }
            unawaited(output.close());
          } on Object catch (error, stackTrace) {
            output.addError(error, stackTrace);
            unawaited(output.close());
          }
        },
      );
      inputSubscription = subscription;
      if (stopped) {
        unawaited(subscription.cancel());
      }
    },
    onPause: () => inputSubscription?.pause(),
    onResume: () => inputSubscription?.resume(),
    onCancel: () {
      stopped = true;
      return inputSubscription?.cancel();
    },
  );
  return output.stream;
}

Object? _decodeLine(Uint8List bytes, NdJsonStreamOptions options) {
  final String line;
  try {
    line = utf8
        .decode(bytes, allowMalformed: options.allowMalformedUtf8)
        .trim();
  } on FormatException {
    _diagnose(
      options,
      const NdJsonDiagnostic(message: 'Skipping malformed UTF-8 line'),
    );
    return null;
  }
  if (line.isEmpty) {
    return null;
  }
  final Object? decoded;
  try {
    decoded = decodeBoundedJson(
      line,
      maximumNestingDepth: options.maximumJsonNestingDepth,
    );
  } on FormatException {
    _diagnose(
      options,
      NdJsonDiagnostic(
        message: 'Skipping malformed JSON line',
        preview: _preview(line, options.maximumDiagnosticCharacters),
      ),
    );
    return null;
  }
  if (decoded is Map<Object?, Object?> || decoded is List<Object?>) {
    return decoded;
  }
  _diagnose(
    options,
    NdJsonDiagnostic(
      message: 'Skipping JSON line that is not an object or array',
      preview: _preview(line, options.maximumDiagnosticCharacters),
    ),
  );
  return null;
}

void _diagnose(NdJsonStreamOptions options, NdJsonDiagnostic diagnostic) {
  try {
    options.onDiagnostic?.call(diagnostic);
  } on Object {
    // Diagnostics are observational and must not alter transport lifecycle.
  }
}

String _preview(String value, int maximumCharacters) {
  if (value.length <= maximumCharacters) {
    return value;
  }
  return '${value.substring(0, maximumCharacters)}…';
}

final class _NdJsonEncoder {
  _NdJsonEncoder(this._output, this._closeOutput);

  final AcpWritable<List<int>> _output;
  final bool _closeOutput;
  Future<void> _tail = Future<void>.value();
  bool _isClosed = false;

  Future<void> write(Object? data) {
    if (_isClosed) {
      return Future<void>.error(StateError('Cannot write to closed NDJSON'));
    }
    _tail = _enqueue(() async {
      await _output.write(utf8.encode('${jsonEncode(data)}\n'));
    });
    return _tail;
  }

  Future<void> close() {
    if (_isClosed) {
      return _tail;
    }
    _isClosed = true;
    _tail = _enqueue(() async {
      if (_closeOutput) {
        await _output.close();
      }
    });
    return _tail;
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    final Future<void> previous = _tail;
    return () async {
      await previous;
      await operation();
    }();
  }
}

AcpWritable<Object?> _encodedWritable(
  AcpWritable<List<int>> output,
  bool closeOutput,
) {
  final _NdJsonEncoder encoder = _NdJsonEncoder(output, closeOutput);
  return AcpWritable<Object?>(write: encoder.write, close: encoder.close);
}
