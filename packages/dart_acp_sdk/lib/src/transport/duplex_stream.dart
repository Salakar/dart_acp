import 'dart:async';

/// An asynchronous writable transport half.
final class AcpWritable<T> {
  /// Creates a writable transport from explicit operations.
  const AcpWritable({
    required Future<void> Function(T value) write,
    required Future<void> Function() close,
  }) : _write = write,
       _close = close;

  /// Adapts a [StreamSink].
  ///
  /// A plain [StreamSink] cannot acknowledge individual writes, so this adapter
  /// completes after `add`. Prefer the main constructor when the transport can
  /// expose real write backpressure.
  factory AcpWritable.fromStreamSink(StreamSink<T> sink) => AcpWritable<T>(
    write: (T value) {
      sink.add(value);
      return Future<void>.value();
    },
    close: sink.close,
  );

  final Future<void> Function(T value) _write;
  final Future<void> Function() _close;

  /// Writes one value and completes after transport acceptance.
  Future<void> write(T value) => _write(value);

  /// Closes the writable transport.
  Future<void> close() => _close();
}

/// A typed pair of incoming and outgoing stream halves.
final class AcpDuplexStream<T> {
  /// Creates a duplex stream.
  const AcpDuplexStream({required this.readable, required this.writable});

  /// Values received from the peer.
  final Stream<T> readable;

  /// Values sent to the peer.
  final AcpWritable<T> writable;
}
