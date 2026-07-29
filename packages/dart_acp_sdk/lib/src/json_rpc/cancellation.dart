import 'dart:async';

/// A cooperative cancellation exception thrown by [CancellationToken].
final class CancellationException implements Exception {
  /// Creates a cancellation exception.
  const CancellationException([this.reason]);

  /// The cancellation reason.
  final Object? reason;

  @override
  String toString() => 'CancellationException($reason)';
}

/// An idempotent registration for a cancellation callback.
final class CancellationRegistration {
  CancellationRegistration._(this._dispose);

  void Function()? _dispose;

  /// Removes the callback.
  void dispose() {
    final void Function()? dispose = _dispose;
    _dispose = null;
    dispose?.call();
  }
}

/// A read-only cooperative cancellation signal.
final class CancellationToken {
  CancellationToken._();

  final Completer<Object?> _cancelled = Completer<Object?>();
  final Set<void Function(Object? reason)> _callbacks =
      <void Function(Object? reason)>{};
  Object? _reason;

  /// Whether cancellation has been requested.
  bool get isCancelled => _cancelled.isCompleted;

  /// The cancellation reason, or `null` before cancellation.
  Object? get reason => _reason;

  /// Completes with the cancellation reason.
  Future<Object?> get whenCancelled => _cancelled.future;

  /// Registers [callback], invoking it synchronously if already cancelled.
  CancellationRegistration register(void Function(Object? reason) callback) {
    if (isCancelled) {
      callback(_reason);
      return CancellationRegistration._(() {});
    }
    _callbacks.add(callback);
    return CancellationRegistration._(() {
      _callbacks.remove(callback);
    });
  }

  /// Throws when cancellation has been requested.
  void throwIfCancelled() {
    if (isCancelled) {
      throw CancellationException(_reason);
    }
  }

  void _cancel(Object? reason) {
    if (isCancelled) {
      return;
    }
    _reason = reason;
    final List<void Function(Object? reason)> callbacks =
        List<void Function(Object? reason)>.of(_callbacks);
    _callbacks.clear();
    _cancelled.complete(reason);
    for (final void Function(Object? reason) callback in callbacks) {
      callback(reason);
    }
  }
}

/// The owner that can cancel a [token].
final class CancellationSource {
  /// Creates a cancellation source.
  CancellationSource();

  /// The read-only token.
  final CancellationToken token = CancellationToken._();

  /// Requests cancellation once.
  void cancel([Object? reason]) {
    token._cancel(reason);
  }
}
