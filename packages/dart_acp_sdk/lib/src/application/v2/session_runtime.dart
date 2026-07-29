part of 'application.dart';

final class _AcpV2SessionRouter {
  final Map<String, Set<_AcpV2SessionChannel>> _routes =
      <String, Set<_AcpV2SessionChannel>>{};
  final Set<_AcpV2PendingRoute> _pending = <_AcpV2PendingRoute>{};

  Future<JsonRpcHandleResult?> handle(
    IncomingJsonRpcMessage message,
    JsonRpcHandlerContext _,
  ) async {
    if (message is! IncomingJsonRpcNotification ||
        message.method != v2_methods.sessionUpdateMethod.name) {
      return JsonRpcPass(message: message);
    }
    final notification = _decodeV2Params(
      v2_methods.sessionUpdateMethod.paramsCodec,
      message.params,
    );
    final Set<_AcpV2SessionChannel>? channels =
        _routes[notification.sessionId.value];
    if (channels != null) {
      for (final _AcpV2SessionChannel channel in List<_AcpV2SessionChannel>.of(
        channels,
      )) {
        channel.add(notification);
      }
    }
    for (final _AcpV2PendingRoute route in List<_AcpV2PendingRoute>.of(
      _pending,
    )) {
      route.add(notification);
    }
    return JsonRpcPass(message: message);
  }

  _AcpV2PendingRoute beginPending(_AcpV2SessionChannel channel) {
    final route = _AcpV2PendingRoute._(this, channel);
    _pending.add(route);
    return route;
  }

  AcpV2SessionSubscription attach(
    v2.SessionId sessionId,
    _AcpV2SessionChannel channel,
  ) {
    final Set<_AcpV2SessionChannel> channels = _routes[sessionId.value] ??=
        <_AcpV2SessionChannel>{};
    channels.add(channel);
    return AcpV2SessionSubscription._(() {
      channels.remove(channel);
      if (channels.isEmpty) {
        _routes.remove(sessionId.value);
      }
    });
  }
}

final class _AcpV2PendingRoute {
  _AcpV2PendingRoute._(this._router, this._channel);

  static const int _maximumBufferedUpdates = 1024;
  final _AcpV2SessionRouter _router;
  final _AcpV2SessionChannel _channel;
  final List<v2.UpdateSessionNotification> _updates =
      <v2.UpdateSessionNotification>[];
  bool _disposed = false;

  void add(v2.UpdateSessionNotification notification) {
    if (_disposed) {
      return;
    }
    if (_updates.length == _maximumBufferedUpdates) {
      _updates.removeAt(0);
    }
    _updates.add(notification);
  }

  AcpV2SessionSubscription activate(v2.SessionId sessionId) {
    if (_disposed) {
      throw const AcpV2SessionStateException('Pending route is inactive');
    }
    _disposed = true;
    _router._pending.remove(this);
    final AcpV2SessionSubscription subscription = _router.attach(
      sessionId,
      _channel,
    );
    for (final v2.UpdateSessionNotification notification in _updates) {
      if (notification.sessionId == sessionId) {
        _channel.add(notification);
      }
    }
    _updates.clear();
    return subscription;
  }

  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _router._pending.remove(this);
    _updates.clear();
  }
}

final class _AcpV2SessionChannel {
  final StreamController<AcpV2SessionEvent> _events =
      StreamController<AcpV2SessionEvent>.broadcast();
  final Set<_AcpV2PromptTurnState> _turns = <_AcpV2PromptTurnState>{};
  final AcpV2SessionSnapshot _snapshot = AcpV2SessionSnapshot._();
  int _sequence = 0;
  bool _closed = false;

  Stream<AcpV2SessionEvent> get events => _events.stream;

  void add(v2.UpdateSessionNotification notification) {
    if (_closed) {
      return;
    }
    final int sequence = ++_sequence;
    _snapshot._apply(notification.update);
    final event = AcpV2SessionUpdateEvent(
      sequence: sequence,
      notification: notification,
      snapshot: _snapshot.copy(),
    );
    _events.add(event);
    for (final _AcpV2PromptTurnState turn in List<_AcpV2PromptTurnState>.of(
      _turns,
    )) {
      turn.add(event);
    }
  }

  _AcpV2PromptTurnState beginTurn() {
    if (_closed) {
      throw const AcpV2SessionStateException('Session route is inactive');
    }
    late _AcpV2PromptTurnState turn;
    turn = _AcpV2PromptTurnState(
      startedAfterSequence: _sequence,
      onDone: () => _turns.remove(turn),
      sessionEvents: _events,
    );
    _turns.add(turn);
    return turn;
  }

  void fail(Object error, [StackTrace? stackTrace]) {
    if (_closed) {
      return;
    }
    _closed = true;
    for (final _AcpV2PromptTurnState turn in List<_AcpV2PromptTurnState>.of(
      _turns,
    )) {
      turn.fail(error, stackTrace ?? StackTrace.current);
    }
    _turns.clear();
    _events.addError(error, stackTrace);
    unawaited(_events.close());
  }

  void close() {
    if (_closed) {
      return;
    }
    _closed = true;
    for (final _AcpV2PromptTurnState turn in List<_AcpV2PromptTurnState>.of(
      _turns,
    )) {
      turn.fail(
        const AcpV2SessionStateException('Session disposed during prompt'),
        StackTrace.current,
      );
    }
    _turns.clear();
    unawaited(_events.close());
  }
}

final class _AcpV2PromptTurnState {
  _AcpV2PromptTurnState({
    required this.startedAfterSequence,
    required this.onDone,
    required this.sessionEvents,
  }) {
    unawaited(accepted.then<void>((_) {}, onError: (Object _) {}));
    unawaited(completed.then<void>((_) {}, onError: (Object _) {}));
  }

  final int startedAfterSequence;
  final void Function() onDone;
  final StreamController<AcpV2SessionEvent> sessionEvents;
  final StreamController<AcpV2SessionEvent> _events =
      StreamController<AcpV2SessionEvent>();
  final Completer<v2.PromptResponse> _accepted = Completer<v2.PromptResponse>();
  final Completer<AcpV2PromptCompletion> _completed =
      Completer<AcpV2PromptCompletion>();
  final List<AcpV2SessionUpdateEvent> updates = <AcpV2SessionUpdateEvent>[];
  bool _isAccepted = false;
  bool _isDone = false;

  Stream<AcpV2SessionEvent> get events => _events.stream;
  Future<v2.PromptResponse> get accepted => _accepted.future;
  Future<AcpV2PromptCompletion> get completed => _completed.future;

  void add(AcpV2SessionUpdateEvent event) {
    if (_isDone || event.sequence <= startedAfterSequence) {
      return;
    }
    updates.add(event);
    _events.add(event);
    final v2.SessionUpdate update = event.update;
    if (_isAccepted &&
        update is v2.SessionUpdateStateUpdate &&
        update.value is v2.StateUpdateIdle) {
      final state = update.value as v2.StateUpdateIdle;
      final completion = AcpV2PromptCompletion(
        notification: event.notification,
        state: state.value,
      );
      _isDone = true;
      _completed.complete(completion);
      final completedEvent = AcpV2PromptCompletedEvent(completion);
      _events.add(completedEvent);
      sessionEvents.add(completedEvent);
      onDone();
      unawaited(_events.close());
    }
  }

  void accept(v2.PromptResponse response) {
    if (_isDone || _isAccepted) {
      return;
    }
    _isAccepted = true;
    _accepted.complete(response);
    final event = AcpV2PromptAcceptedEvent(response);
    _events.add(event);
    sessionEvents.add(event);
  }

  void fail(Object error, StackTrace stackTrace) {
    if (_isDone) {
      return;
    }
    _isDone = true;
    if (!_accepted.isCompleted) {
      _accepted.completeError(error, stackTrace);
    }
    _completed.completeError(error, stackTrace);
    _events.addError(error, stackTrace);
    onDone();
    unawaited(_events.close());
  }
}

void _applyMessagePatch(
  Map<String, AcpV2MessageState> target, {
  required v2.MessageId id,
  required AcpV2MessageKind kind,
  required AcpPatch<List<v2.ContentBlock>> content,
}) {
  final AcpV2MessageState? previous = target[id.value];
  final List<v2.ContentBlock>? next = content.applyTo(previous?.content);
  target[id.value] = AcpV2MessageState(
    messageId: id,
    kind: kind,
    content: List<v2.ContentBlock>.unmodifiable(
      next ?? const <v2.ContentBlock>[],
    ),
  );
}

void _appendMessageChunk(
  Map<String, AcpV2MessageState> target,
  v2.ContentChunk chunk,
  AcpV2MessageKind kind,
) {
  final AcpV2MessageState? previous = target[chunk.messageId.value];
  target[chunk.messageId.value] = AcpV2MessageState(
    messageId: chunk.messageId,
    kind: kind,
    content: List<v2.ContentBlock>.unmodifiable(<v2.ContentBlock>[
      ...?previous?.content,
      chunk.content,
    ]),
  );
}
