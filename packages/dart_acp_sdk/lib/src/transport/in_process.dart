import 'dart:async';
import 'dart:collection';

import 'duplex_stream.dart';

/// A pair of connected, platform-neutral in-process transports.
final class AcpInProcessTransportPair<T> {
  /// Creates an already-connected pair of endpoints.
  const AcpInProcessTransportPair({required this.left, required this.right});

  /// The left endpoint.
  final AcpDuplexStream<T> left;

  /// The right endpoint.
  final AcpDuplexStream<T> right;
}

/// Creates two bounded in-memory transport endpoints.
///
/// Writes are delivered in call order. If a peer is paused or has not started
/// listening, at most [maximumBufferedMessages] values are retained; further
/// writes fail rather than growing memory without bound.
AcpInProcessTransportPair<T> acpInProcessTransportPair<T>({
  int maximumBufferedMessages = 1024,
}) {
  if (maximumBufferedMessages <= 0) {
    throw ArgumentError.value(
      maximumBufferedMessages,
      'maximumBufferedMessages',
      'must be positive',
    );
  }
  final _AcpMemoryPipe<T> leftToRight = _AcpMemoryPipe<T>(
    maximumBufferedMessages,
  );
  final _AcpMemoryPipe<T> rightToLeft = _AcpMemoryPipe<T>(
    maximumBufferedMessages,
  );
  return AcpInProcessTransportPair<T>(
    left: AcpDuplexStream<T>(
      readable: rightToLeft.stream,
      writable: leftToRight.writable,
    ),
    right: AcpDuplexStream<T>(
      readable: leftToRight.stream,
      writable: rightToLeft.writable,
    ),
  );
}

final class _AcpMemoryPipe<T> {
  _AcpMemoryPipe(this.maximumBufferedMessages) {
    _controller = StreamController<T>(
      sync: true,
      onListen: () {
        _hasListener = true;
        scheduleMicrotask(_drain);
      },
      onPause: () => _isPaused = true,
      onResume: () {
        _isPaused = false;
        _drain();
      },
      onCancel: () {
        _isCancelled = true;
        _rejectPending(StateError('In-process transport reader cancelled'));
      },
    );
  }

  final int maximumBufferedMessages;
  final Queue<_AcpMemoryWrite<T>> _pending = Queue<_AcpMemoryWrite<T>>();
  late final StreamController<T> _controller;
  final Completer<void> _closed = Completer<void>();
  bool _hasListener = false;
  bool _isPaused = false;
  bool _isClosing = false;
  bool _isCancelled = false;
  bool _isDraining = false;

  Stream<T> get stream => _controller.stream;

  AcpWritable<T> get writable => AcpWritable<T>(write: _write, close: _close);

  Future<void> _write(T value) {
    if (_isClosing || _isCancelled) {
      return Future<void>.error(
        StateError('Cannot write to a closed in-process transport'),
      );
    }
    if (_pending.length >= maximumBufferedMessages) {
      return Future<void>.error(
        StateError(
          'In-process transport exceeded $maximumBufferedMessages '
          'buffered messages',
        ),
      );
    }
    final _AcpMemoryWrite<T> write = _AcpMemoryWrite<T>(value);
    _pending.addLast(write);
    _drain();
    return write.completed;
  }

  Future<void> _close() {
    if (_isClosing) {
      return _closed.future;
    }
    _isClosing = true;
    if (_pending.isEmpty) {
      _finishClose();
      return _closed.future;
    }
    _drain();
    return _closed.future;
  }

  void _drain() {
    if (_isDraining || !_hasListener || _isPaused || _isCancelled) {
      return;
    }
    _isDraining = true;
    try {
      while (_pending.isNotEmpty && !_isPaused && !_isCancelled) {
        final _AcpMemoryWrite<T> write = _pending.removeFirst();
        try {
          _controller.add(write.value);
          write.complete();
        } on Object catch (error, stackTrace) {
          write.completeError(error, stackTrace);
        }
      }
      if (_isClosing && _pending.isEmpty && !_controller.isClosed) {
        _finishClose();
      }
    } finally {
      _isDraining = false;
    }
  }

  void _rejectPending(Object error) {
    while (_pending.isNotEmpty) {
      _pending.removeFirst().completeError(error);
    }
    if (!_closed.isCompleted) {
      _closed.complete();
    }
  }

  void _finishClose() {
    if (!_controller.isClosed) {
      unawaited(_controller.close());
    }
    if (!_closed.isCompleted) {
      _closed.complete();
    }
  }
}

final class _AcpMemoryWrite<T> {
  _AcpMemoryWrite(this.value);

  final T value;
  final Completer<void> _completer = Completer<void>();

  Future<void> get completed => _completer.future;

  void complete() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  void completeError(Object error, [StackTrace? stackTrace]) {
    if (!_completer.isCompleted) {
      _completer.completeError(error, stackTrace);
    }
  }
}
