import 'dart:async';
import 'dart:convert';

import '../errors.dart';
import '../json.dart';

/// Decodes byte chunks containing one JSON object per line.
final class NdjsonDecoder extends StreamTransformerBase<List<int>, JsonMap> {
  /// Creates a decoder with a per-line byte [maxBufferSize].
  const NdjsonDecoder({this.maxBufferSize = 1024 * 1024});

  /// Maximum bytes accepted for one complete or partial line.
  final int maxBufferSize;

  @override
  Stream<JsonMap> bind(Stream<List<int>> stream) {
    late StreamController<JsonMap> controller;
    StreamSubscription<List<int>>? subscription;
    var pending = <int>[];

    void fail(Object error, [StackTrace? stackTrace]) {
      controller.addError(error, stackTrace);
    }

    JsonMap? parseLine(List<int> bytes, {required bool isTail}) {
      var start = 0;
      var end = bytes.length;
      while (start < end && _isWhitespace(bytes[start])) {
        start++;
      }
      while (end > start && _isWhitespace(bytes[end - 1])) {
        end--;
      }
      if (start == end) return null;
      if (bytes[start] != 0x7b) return null;
      final lineBytes = bytes.sublist(start, end);
      late String line;
      try {
        line = utf8.decode(lineBytes);
        final value = jsonDecode(line);
        return asJsonMap(value, 'CLI stdout line');
      } catch (error) {
        if (isTail) return null;
        throw CliJsonDecodeException(
          line: lineBytes.length > 200
              ? utf8.decode(lineBytes.sublist(0, 200), allowMalformed: true)
              : utf8.decode(lineBytes, allowMalformed: true),
          cause: error,
        );
      }
    }

    void guard(int length) {
      if (length > maxBufferSize) {
        throw CliJsonDecodeException(
          line:
              'JSON message exceeded maximum buffer size of '
              '$maxBufferSize bytes',
          cause: StateError('$length bytes exceeds $maxBufferSize'),
        );
      }
    }

    void addChunk(List<int> chunk) {
      pending.addAll(chunk);
      var lineStart = 0;
      for (var index = 0; index < pending.length; index++) {
        if (pending[index] != 0x0a) continue;
        final lineLength = index - lineStart;
        guard(lineLength);
        final value = parseLine(
          pending.sublist(lineStart, index),
          isTail: false,
        );
        if (value != null) controller.add(value);
        lineStart = index + 1;
      }
      if (lineStart > 0) pending = pending.sublist(lineStart);
      guard(pending.length);
    }

    controller = StreamController<JsonMap>(
      sync: true,
      onListen: () {
        subscription = stream.listen(
          (chunk) {
            try {
              addChunk(chunk);
            } catch (error, stackTrace) {
              fail(error, stackTrace);
              subscription?.cancel();
              controller.close();
            }
          },
          onError: fail,
          onDone: () {
            if (pending.isNotEmpty) {
              try {
                guard(pending.length);
                final value = parseLine(pending, isTail: true);
                if (value != null) controller.add(value);
              } catch (error, stackTrace) {
                fail(error, stackTrace);
              }
            }
            controller.close();
          },
        );
      },
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }
}

bool _isWhitespace(int byte) =>
    byte == 0x20 || byte == 0x09 || byte == 0x0d || byte == 0x0a;
