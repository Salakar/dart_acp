import 'dart:async';
import 'dart:collection';

/// Outcome of steering a session.
sealed class CodexSteeringOutcome {
  const CodexSteeringOutcome();
}

/// The prompt joined the current turn.
final class CodexSteeringInjected extends CodexSteeringOutcome {
  /// Creates an injected result.
  const CodexSteeringInjected();
}

/// The prompt started a new turn.
final class CodexSteeringStartedNewTurn extends CodexSteeringOutcome {
  /// Creates a new-turn result.
  const CodexSteeringStartedNewTurn();
}

/// The prompt could not be steered.
final class CodexSteeringFailed extends CodexSteeringOutcome {
  /// Creates a failed result.
  const CodexSteeringFailed();
}

final class _QueuedSteering<T> {
  _QueuedSteering(this.value, this.completer);

  final T value;
  final Completer<CodexSteeringOutcome> completer;
}

/// Serializes steering operations in arrival order.
final class CodexSteeringQueue<T> {
  /// Creates a queue with its one-at-a-time [handler].
  CodexSteeringQueue(this._handler);

  final Future<CodexSteeringOutcome> Function(T value) _handler;
  final Queue<_QueuedSteering<T>> _pending = Queue<_QueuedSteering<T>>();
  bool _isProcessing = false;

  /// Whether no request is running or queued.
  bool get isIdle => !_isProcessing && _pending.isEmpty;

  /// Enqueues one operation.
  Future<CodexSteeringOutcome> enqueue(T value) {
    final completer = Completer<CodexSteeringOutcome>();
    _pending.add(_QueuedSteering<T>(value, completer));
    if (!_isProcessing) {
      _isProcessing = true;
      unawaited(_drain());
    }
    return completer.future;
  }

  Future<void> _drain() async {
    try {
      while (_pending.isNotEmpty) {
        final item = _pending.removeFirst();
        try {
          item.completer.complete(await _handler(item.value));
        } on Object catch (error, stackTrace) {
          item.completer.completeError(error, stackTrace);
        }
      }
    } finally {
      _isProcessing = false;
      if (_pending.isNotEmpty) {
        _isProcessing = true;
        unawaited(_drain());
      }
    }
  }
}
