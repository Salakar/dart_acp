import 'dart:typed_data';

/// Thrown when an unterminated or complete line exceeds its configured limit.
final class LineLengthExceededException implements Exception {
  /// Creates a line-length exception.
  const LineLengthExceededException({
    required this.length,
    required this.maximum,
  });

  /// The observed line length.
  final int length;

  /// The configured maximum.
  final int maximum;

  @override
  String toString() =>
      'LineLengthExceededException(length: $length, maximum: $maximum)';
}

/// Incrementally splits byte chunks on LF without quadratic rescanning.
final class LineBuffer {
  /// Creates a bounded line buffer.
  LineBuffer({this.maximumLineBytes = 16 * 1024 * 1024}) {
    if (maximumLineBytes <= 0) {
      throw ArgumentError.value(
        maximumLineBytes,
        'maximumLineBytes',
        'must be positive',
      );
    }
  }

  /// The largest line accepted, excluding its LF delimiter.
  final int maximumLineBytes;

  final List<Uint8List> _pending = <Uint8List>[];
  int _pendingLength = 0;

  /// Consumes [chunk] and returns every complete line without its LF.
  List<Uint8List> add(List<int> chunk) {
    final List<Uint8List> lines = <Uint8List>[];
    int start = 0;
    for (int index = 0; index < chunk.length; index += 1) {
      if (chunk[index] != 0x0a) {
        continue;
      }
      final Uint8List tail = Uint8List.fromList(chunk.sublist(start, index));
      lines.add(_takeLine(tail));
      start = index + 1;
    }
    if (start < chunk.length) {
      final Uint8List tail = Uint8List.fromList(chunk.sublist(start));
      _checkLength(_pendingLength + tail.length);
      _pending.add(tail);
      _pendingLength += tail.length;
    }
    return lines;
  }

  /// Emits the final unterminated line once, or `null` when empty.
  Uint8List? flush() {
    if (_pending.isEmpty) {
      return null;
    }
    return _takeLine(Uint8List(0));
  }

  Uint8List _takeLine(Uint8List tail) {
    final int total = _pendingLength + tail.length;
    _checkLength(total);
    if (_pending.isEmpty) {
      return tail;
    }
    final Uint8List line = Uint8List(total);
    int offset = 0;
    for (final Uint8List part in _pending) {
      line.setRange(offset, offset + part.length, part);
      offset += part.length;
    }
    line.setRange(offset, offset + tail.length, tail);
    _pending.clear();
    _pendingLength = 0;
    return line;
  }

  void _checkLength(int length) {
    if (length > maximumLineBytes) {
      throw LineLengthExceededException(
        length: length,
        maximum: maximumLineBytes,
      );
    }
  }
}
