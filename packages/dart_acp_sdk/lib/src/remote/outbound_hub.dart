import 'dart:async';
import 'dart:collection';

/// Reports a bounded outbound queue overflow.
typedef AcpOutboundOverflowHandler =
    void Function(AcpOutboundOverflow overflow);

/// Details about a subscriber queue that dropped its oldest value.
final class AcpOutboundOverflow {
  /// Creates an overflow diagnostic.
  const AcpOutboundOverflow({
    required this.capacity,
    required this.droppedValues,
  });

  /// The configured queue capacity.
  final int capacity;

  /// Values dropped during the current overflow episode.
  final int droppedValues;
}

/// One subscription to an [AcpOutboundHub].
///
/// Only the first subscription receives [replay]. Later subscriptions receive
/// an empty list and observe live values only.
final class AcpOutboundSubscription<T> {
  const AcpOutboundSubscription._({required this.replay, required this.live});

  /// Values buffered before the first subscription was created.
  final List<T> replay;

  /// The bounded stream of live values for this subscriber.
  final Stream<T> live;
}

/// A bounded one-to-many outbound hub.
///
/// Before a subscriber exists, the hub retains at most [capacity] values. That
/// replay is consumed by the first subscription only. Every live subscriber
/// then owns an independent bounded queue while its Dart subscription is
/// paused. Queue overflow drops the oldest value and reports once per overflow
/// episode until the subscriber resumes and drains.
final class AcpOutboundHub<T> {
  /// Creates a bounded hub.
  AcpOutboundHub({this.capacity = 1024, this.onOverflow}) {
    if (capacity <= 0) {
      throw ArgumentError.value(capacity, 'capacity', 'must be positive');
    }
  }

  /// Maximum replay and per-subscriber paused values.
  final int capacity;

  /// Optional overflow diagnostic callback.
  final AcpOutboundOverflowHandler? onOverflow;

  final ListQueue<T> _replay = ListQueue<T>();
  final Set<_HubSubscriber<T>> _subscribers = <_HubSubscriber<T>>{};
  bool _hasSubscribed = false;
  bool _isClosed = false;
  Future<void>? _closeFuture;

  /// Whether [close] has been called.
  bool get isClosed => _isClosed;

  /// Current number of live subscriber streams.
  int get subscriberCount => _subscribers.length;

  /// Number of values waiting for the first subscriber.
  int get replayLength => _replay.length;

  /// Creates an independent live subscription.
  AcpOutboundSubscription<T> subscribe() {
    if (_isClosed) {
      return AcpOutboundSubscription<T>._(
        replay: List<T>.unmodifiable(<T>[]),
        live: Stream<T>.empty(),
      );
    }

    final List<T> replay;
    if (_hasSubscribed) {
      replay = List<T>.unmodifiable(<T>[]);
    } else {
      _hasSubscribed = true;
      replay = List<T>.unmodifiable(_replay);
      _replay.clear();
    }

    late final _HubSubscriber<T> subscriber;
    subscriber = _HubSubscriber<T>(
      capacity: capacity,
      onOverflow: onOverflow,
      onCancel: () {
        _subscribers.remove(subscriber);
      },
    );
    _subscribers.add(subscriber);
    return AcpOutboundSubscription<T>._(
      replay: replay,
      live: subscriber.stream,
    );
  }

  /// Sends [value] to all current subscribers or the initial replay buffer.
  void add(T value) {
    if (_isClosed) {
      return;
    }
    if (_subscribers.isEmpty && !_hasSubscribed) {
      if (_replay.length == capacity) {
        _replay.removeFirst();
      }
      _replay.addLast(value);
      return;
    }
    for (final _HubSubscriber<T> subscriber in _subscribers.toList()) {
      subscriber.add(value);
    }
  }

  /// Closes every subscriber and discards queued values.
  Future<void> close() {
    final Future<void>? existing = _closeFuture;
    if (existing != null) {
      return existing;
    }
    _isClosed = true;
    final Future<void> closed = Future<void>.value();
    _closeFuture = closed;
    _replay.clear();
    final List<_HubSubscriber<T>> subscribers = _subscribers.toList();
    _subscribers.clear();
    for (final _HubSubscriber<T> subscriber in subscribers) {
      unawaited(subscriber.close());
    }
    return closed;
  }
}

final class _HubSubscriber<T> {
  _HubSubscriber({
    required this.capacity,
    required this.onOverflow,
    required this.onCancel,
  }) {
    _controller = StreamController<T>(
      sync: true,
      onListen: _handleListen,
      onPause: _handlePause,
      onResume: _handleResume,
      onCancel: _handleCancel,
    );
  }

  final int capacity;
  final AcpOutboundOverflowHandler? onOverflow;
  final void Function() onCancel;
  final ListQueue<T> _queue = ListQueue<T>();
  late final StreamController<T> _controller;
  bool _isListening = false;
  bool _isPaused = true;
  bool _canDeliverDirectly = false;
  bool _isClosed = false;
  bool _reportedOverflow = false;
  int _droppedValues = 0;

  Stream<T> get stream => _controller.stream;

  void add(T value) {
    if (_isClosed) {
      return;
    }
    if (_isListening && !_isPaused && _canDeliverDirectly) {
      _controller.add(value);
      return;
    }
    if (_queue.length == capacity) {
      _queue.removeFirst();
      _droppedValues += 1;
      if (!_reportedOverflow) {
        _reportedOverflow = true;
        try {
          onOverflow?.call(
            AcpOutboundOverflow(
              capacity: capacity,
              droppedValues: _droppedValues,
            ),
          );
        } on Object {
          // Diagnostics must never interrupt routing or corrupt queue state.
        }
      }
    }
    _queue.addLast(value);
  }

  void _handleListen() {
    _isListening = true;
    _isPaused = false;
    _scheduleDrain();
  }

  void _handlePause() {
    _isPaused = true;
    _canDeliverDirectly = false;
  }

  void _handleResume() {
    _isPaused = false;
    _scheduleDrain();
  }

  Future<void> _handleCancel() async {
    _isClosed = true;
    _canDeliverDirectly = false;
    _queue.clear();
    onCancel();
  }

  void _drain() {
    if (_isClosed || _isPaused) {
      return;
    }
    _canDeliverDirectly = true;
    while (!_isClosed && !_isPaused && _queue.isNotEmpty) {
      _controller.add(_queue.removeFirst());
    }
    if (_queue.isEmpty) {
      _reportedOverflow = false;
      _droppedValues = 0;
    }
  }

  void _scheduleDrain() {
    _canDeliverDirectly = false;
    scheduleMicrotask(_drain);
  }

  Future<void> close() async {
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    _canDeliverDirectly = false;
    _queue.clear();
    // A controller's close future waits for paused listeners to resume. The
    // hub does not own those listeners and must not let one stalled consumer
    // block connection shutdown indefinitely.
    scheduleMicrotask(() => unawaited(_controller.close()));
  }
}
