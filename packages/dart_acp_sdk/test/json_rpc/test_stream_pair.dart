import 'dart:async';

import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';

final class TestStreamPair {
  TestStreamPair._({
    required this.left,
    required this.right,
    required StreamController<Object?> leftToRight,
    required StreamController<Object?> rightToLeft,
  }) : _leftToRight = leftToRight,
       _rightToLeft = rightToLeft;

  factory TestStreamPair.create() {
    // These controllers are owned by the returned pair and closed by close().
    // ignore: close_sinks
    final StreamController<Object?> leftToRight = StreamController<Object?>();
    // ignore: close_sinks
    final StreamController<Object?> rightToLeft = StreamController<Object?>();
    return TestStreamPair._(
      left: AcpDuplexStream<Object?>(
        readable: rightToLeft.stream,
        writable: AcpWritable<Object?>.fromStreamSink(leftToRight.sink),
      ),
      right: AcpDuplexStream<Object?>(
        readable: leftToRight.stream,
        writable: AcpWritable<Object?>.fromStreamSink(rightToLeft.sink),
      ),
      leftToRight: leftToRight,
      rightToLeft: rightToLeft,
    );
  }

  final AcpDuplexStream<Object?> left;
  final AcpDuplexStream<Object?> right;
  final StreamController<Object?> _leftToRight;
  final StreamController<Object?> _rightToLeft;

  Future<void> close() async {
    await _leftToRight.close();
    await _rightToLeft.close();
  }
}
