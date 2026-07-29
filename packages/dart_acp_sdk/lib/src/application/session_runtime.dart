part of 'application.dart';

final class _AcpSessionRouter {
  final Map<String, Set<_AcpSessionChannel>> _routes =
      <String, Set<_AcpSessionChannel>>{};
  final Set<_AcpPendingSessionRoute> _pending = <_AcpPendingSessionRoute>{};

  Future<JsonRpcHandleResult?> handle(
    IncomingJsonRpcMessage message,
    JsonRpcHandlerContext _,
  ) async {
    if (message is! IncomingJsonRpcNotification ||
        message.method != v1_methods.sessionUpdateMethod.name) {
      return JsonRpcPass(message: message);
    }
    final v1.SessionNotification notification = _decodeParams(
      v1_methods.sessionUpdateMethod.paramsCodec,
      message.params,
    );
    final Set<_AcpSessionChannel>? channels =
        _routes[notification.sessionId.value];
    if (channels != null) {
      for (final _AcpSessionChannel channel in List<_AcpSessionChannel>.of(
        channels,
      )) {
        channel.add(notification);
      }
    }
    for (final _AcpPendingSessionRoute route
        in List<_AcpPendingSessionRoute>.of(_pending)) {
      route.add(notification);
    }
    return JsonRpcPass(message: message);
  }

  _AcpPendingSessionRoute beginPending(_AcpSessionChannel channel) {
    final _AcpPendingSessionRoute route = _AcpPendingSessionRoute._(
      this,
      channel,
    );
    _pending.add(route);
    return route;
  }

  AcpSessionSubscription attach(
    v1.SessionId sessionId,
    _AcpSessionChannel channel,
  ) {
    final String key = sessionId.value;
    final Set<_AcpSessionChannel> channels = _routes[key] ??=
        <_AcpSessionChannel>{};
    channels.add(channel);
    return AcpSessionSubscription._(() {
      channels.remove(channel);
      if (channels.isEmpty) {
        _routes.remove(key);
      }
    });
  }
}

final class _AcpPendingSessionRoute {
  _AcpPendingSessionRoute._(this._router, this._channel);

  static const int _maximumBufferedUpdates = 1024;
  final _AcpSessionRouter _router;
  final _AcpSessionChannel _channel;
  final List<v1.SessionNotification> _updates = <v1.SessionNotification>[];
  bool _disposed = false;

  void add(v1.SessionNotification notification) {
    if (_disposed) {
      return;
    }
    if (_updates.length == _maximumBufferedUpdates) {
      _updates.removeAt(0);
    }
    _updates.add(notification);
  }

  AcpSessionSubscription activate(v1.SessionId sessionId) {
    if (_disposed) {
      throw const AcpSessionStateException(
        'Pending session route is no longer active',
      );
    }
    _disposed = true;
    _router._pending.remove(this);
    final AcpSessionSubscription subscription = _router.attach(
      sessionId,
      _channel,
    );
    for (final v1.SessionNotification notification in _updates) {
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
    _updates.clear();
    _router._pending.remove(this);
  }
}

final class _AcpSessionChannel {
  final StreamController<AcpActiveSessionEvent> _events =
      StreamController<AcpActiveSessionEvent>(sync: true);
  final Set<_AcpPromptTurnState> _turns = <_AcpPromptTurnState>{};
  bool _closed = false;

  Stream<AcpActiveSessionEvent> get events => _events.stream;

  void add(v1.SessionNotification notification) {
    if (_closed) {
      return;
    }
    final AcpSessionUpdateEvent event = AcpSessionUpdateEvent(notification);
    _events.add(event);
    for (final _AcpPromptTurnState turn in List<_AcpPromptTurnState>.of(
      _turns,
    )) {
      turn.add(event);
    }
  }

  _AcpPromptTurnState beginTurn() {
    if (_closed) {
      throw const AcpSessionStateException('Session route is inactive');
    }
    late _AcpPromptTurnState turn;
    turn = _AcpPromptTurnState(() => _turns.remove(turn), this);
    _turns.add(turn);
    return turn;
  }

  void addCompletion(AcpPromptCompletedEvent event) {
    if (!_closed) {
      _events.add(event);
    }
  }

  void fail(Object error, [StackTrace? stackTrace]) {
    if (_closed) {
      return;
    }
    _closed = true;
    for (final _AcpPromptTurnState turn in List<_AcpPromptTurnState>.of(
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
    for (final _AcpPromptTurnState turn in List<_AcpPromptTurnState>.of(
      _turns,
    )) {
      turn.fail(
        const AcpSessionStateException('Session disposed during prompt'),
        StackTrace.current,
      );
    }
    _turns.clear();
    unawaited(_events.close());
  }
}

final class _AcpPromptTurnState {
  _AcpPromptTurnState(this._onDone, this._sessionChannel) {
    unawaited(
      _completed.future.then<void>(
        (_) {},
        onError: (Object _, StackTrace _) {},
      ),
    );
  }

  final void Function() _onDone;
  final _AcpSessionChannel _sessionChannel;
  final StreamController<AcpActiveSessionEvent> _events =
      StreamController<AcpActiveSessionEvent>(sync: true);
  final Completer<v1.PromptResponse> _completed =
      Completer<v1.PromptResponse>();
  bool _done = false;

  Stream<AcpActiveSessionEvent> get events => _events.stream;
  Future<v1.PromptResponse> get completed => _completed.future;

  void add(AcpSessionUpdateEvent event) {
    if (!_done) {
      _events.add(event);
    }
  }

  void complete(v1.PromptResponse response) {
    if (_done) {
      return;
    }
    _done = true;
    final AcpPromptCompletedEvent event = AcpPromptCompletedEvent(response);
    _events.add(event);
    _sessionChannel.addCompletion(event);
    _completed.complete(response);
    _onDone();
    unawaited(_events.close());
  }

  void fail(Object error, StackTrace stackTrace) {
    if (_done) {
      return;
    }
    _done = true;
    _events.addError(error, stackTrace);
    _completed.completeError(error, stackTrace);
    _onDone();
    unawaited(_events.close());
  }
}

final class _AcpTextCollector {
  _AcpTextCollector(this._turn, {required this.includeThoughts});

  final _AcpPromptTurnState _turn;
  final bool includeThoughts;
  final Completer<AcpCollectedText> _result = Completer<AcpCollectedText>();
  final StringBuffer _text = StringBuffer();
  final StringBuffer _thoughts = StringBuffer();
  StreamSubscription<AcpActiveSessionEvent>? _subscription;

  Future<AcpCollectedText> run() {
    _subscription = _turn.events.listen(
      _onEvent,
      onError: (Object error, StackTrace stackTrace) {
        if (!_result.isCompleted) {
          _result.completeError(error, stackTrace);
        }
      },
    );
    return _result.future;
  }

  void fail(Object error) {
    unawaited(_subscription?.cancel() ?? Future<void>.value());
    if (!_result.isCompleted) {
      _result.completeError(error);
    }
  }

  void _onEvent(AcpActiveSessionEvent event) {
    switch (event) {
      case AcpSessionUpdateEvent(:final update):
        switch (update) {
          case v1.SessionUpdateAgentMessageChunk(:final value):
            _append(value.content, _text);
          case v1.SessionUpdateAgentThoughtChunk(:final value)
              when includeThoughts:
            _append(value.content, _thoughts);
          default:
            break;
        }
      case AcpPromptCompletedEvent(:final response):
        if (!_result.isCompleted) {
          _result.complete(
            AcpCollectedText(
              text: _text.toString(),
              thoughts: _thoughts.toString(),
              response: response,
            ),
          );
        }
        unawaited(_subscription?.cancel() ?? Future<void>.value());
    }
  }

  void _append(v1.ContentBlock content, StringBuffer output) {
    if (content case v1.ContentBlockText(:final value)) {
      output.write(value.text);
    }
  }
}
