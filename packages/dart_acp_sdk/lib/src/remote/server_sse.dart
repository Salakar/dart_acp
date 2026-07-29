import 'dart:async';
import 'dart:convert';

import 'outbound_hub.dart';

/// A cancellable periodic timer used by server-side SSE streams.
///
/// The abstraction keeps keepalive behavior deterministic in tests and lets
/// embedders substitute a scheduler without exposing `dart:io`.
abstract interface class AcpSsePeriodicTimer {
  /// Whether this timer can still fire.
  bool get isActive;

  /// Prevents future ticks. Calls are idempotent.
  void cancel();
}

/// Creates a periodic SSE timer.
typedef AcpSsePeriodicTimerFactory =
    AcpSsePeriodicTimer Function(Duration interval, void Function() onTick);

/// Encodes a platform-neutral server-sent event response body.
///
/// Every outbound JSON value is emitted in one byte chunk. Keepalive comments
/// run only while a downstream listener has demand. Pausing the response
/// pauses the bounded hub subscription, and cancellation tears down both the
/// subscription and timer.
Stream<List<int>> createAcpServerSseBody(
  AcpOutboundSubscription<Object?> outbound, {
  Duration keepAliveInterval = const Duration(seconds: 15),
  AcpSsePeriodicTimerFactory timerFactory = _createPeriodicTimer,
}) {
  if (keepAliveInterval <= Duration.zero) {
    throw ArgumentError.value(
      keepAliveInterval,
      'keepAliveInterval',
      'must be positive',
    );
  }

  StreamSubscription<Object?>? source;
  AcpSsePeriodicTimer? timer;
  var started = false;
  var liveStarted = false;
  var stopped = false;
  late final StreamController<List<int>> controller;

  void cancelTimer() {
    timer?.cancel();
    timer = null;
  }

  void startTimer() {
    if (stopped || timer?.isActive == true) {
      return;
    }
    timer = timerFactory(keepAliveInterval, () {
      if (!stopped && !controller.isPaused && !controller.isClosed) {
        controller.add(utf8.encode(':\n\n'));
      }
    });
  }

  Future<void> stop() async {
    if (stopped) {
      return;
    }
    stopped = true;
    cancelTimer();
    await source?.cancel();
  }

  Future<void> stopAfterError() async {
    cancelTimer();
    try {
      await source?.cancel();
    } on Object {
      // Preserve the original stream/encoding error.
    }
    if (!controller.isClosed) {
      await controller.close();
    }
  }

  void fail(Object error, StackTrace stackTrace) {
    if (stopped) {
      return;
    }
    stopped = true;
    if (!liveStarted) {
      liveStarted = true;
      source = outbound.live.listen((_) {});
    }
    controller.addError(error, stackTrace);
    unawaited(stopAfterError());
  }

  bool addJson(Object? value) {
    if (stopped) {
      return false;
    }
    try {
      controller.add(utf8.encode('data: ${jsonEncode(value)}\n\n'));
      return true;
    } on Object catch (error, stackTrace) {
      fail(error, stackTrace);
      return false;
    }
  }

  void startLive() {
    if (stopped || liveStarted || controller.isPaused) {
      return;
    }
    liveStarted = true;
    source = outbound.live.listen(
      addJson,
      onError: (Object error, StackTrace stackTrace) {
        fail(error, stackTrace);
      },
      onDone: () {
        stopped = true;
        cancelTimer();
        unawaited(controller.close());
      },
    );
  }

  void listen() {
    if (started) {
      return;
    }
    started = true;
    for (final Object? value in outbound.replay) {
      if (!addJson(value)) {
        return;
      }
    }
    startLive();
    startTimer();
  }

  controller = StreamController<List<int>>(
    sync: true,
    onListen: listen,
    onPause: () {
      cancelTimer();
      source?.pause();
    },
    onResume: () {
      if (liveStarted) {
        source?.resume();
      } else {
        startLive();
      }
      startTimer();
    },
    onCancel: stop,
  );
  return controller.stream;
}

AcpSsePeriodicTimer _createPeriodicTimer(
  Duration interval,
  void Function() onTick,
) => _DartPeriodicTimer(Timer.periodic(interval, (_) => onTick()));

final class _DartPeriodicTimer implements AcpSsePeriodicTimer {
  _DartPeriodicTimer(this._timer);

  final Timer _timer;

  @override
  bool get isActive => _timer.isActive;

  @override
  void cancel() => _timer.cancel();
}
