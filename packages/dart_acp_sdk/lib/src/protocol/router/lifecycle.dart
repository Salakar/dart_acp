part of 'router.dart';

/// Startup options for a routed agent connection.
final class AcpProtocolRouterConnectOptions {
  /// Creates router startup options.
  const AcpProtocolRouterConnectOptions({this.deferConnectHandlers = false});

  /// Whether selected app connect handlers await manual start.
  final bool deferConnectHandlers;
}

abstract interface class _AcpSelectedConnection {
  Future<void> get closed;
  void close([Object? reason]);
  void startConnectHandlers();
}

final class _AcpSelectedV1Connection implements _AcpSelectedConnection {
  const _AcpSelectedV1Connection(this.value);

  final AcpAgentConnection value;

  @override
  Future<void> get closed => value.closed;

  @override
  void close([Object? reason]) => value.close(reason);

  @override
  void startConnectHandlers() => value.startConnectHandlers();
}

final class _AcpSelectedV2Connection implements _AcpSelectedConnection {
  const _AcpSelectedV2Connection(this.value);

  final AcpV2AgentConnection value;

  @override
  Future<void> get closed => value.closed;

  @override
  void close([Object? reason]) => value.close(reason);

  @override
  void startConnectHandlers() => value.startConnectHandlers();
}

/// Lifecycle handle returned before version selection completes.
final class AcpRoutedAgentConnection {
  AcpRoutedAgentConnection._({
    required bool startRequested,
    required Future<void> Function() closeDestination,
  }) : _startRequested = startRequested,
       _closeDestination = closeDestination;

  final Completer<void> _closed = Completer<void>();
  final Future<void> Function() _closeDestination;
  _AcpSelectedConnection? _selected;
  bool _startRequested;
  bool _connectHandlersStarted = false;
  bool _outputClosed = false;
  bool _finished = false;
  int? _selectedProtocolVersion;

  /// Completes when routing or the selected application connection ends.
  Future<void> get closed => _closed.future;

  /// Selected protocol version, once the initialize frame is routed.
  int? get selectedProtocolVersion => _selectedProtocolVersion;

  /// Starts selected app connect handlers exactly once.
  void startConnectHandlers() {
    _startRequested = true;
    _maybeStartConnectHandlers();
  }

  /// Closes the selected connection and destination writer.
  void close([Object? reason]) {
    _selected?.close(reason);
    unawaited(_closeOutput());
    _finish();
  }

  void _attach(_AcpSelectedConnection selected, int version) {
    if (_selected != null || _finished) {
      selected.close(StateError('Router lifecycle is already complete'));
      return;
    }
    _selected = selected;
    _selectedProtocolVersion = version;
    _maybeStartConnectHandlers();
    unawaited(
      selected.closed.whenComplete(() async {
        await _closeOutput();
        _finish();
      }),
    );
  }

  void _maybeStartConnectHandlers() {
    final _AcpSelectedConnection? selected = _selected;
    if (!_startRequested ||
        _connectHandlersStarted ||
        selected == null ||
        _finished) {
      return;
    }
    _connectHandlersStarted = true;
    selected.startConnectHandlers();
  }

  Future<void> _closeOutput() async {
    if (_outputClosed) {
      return;
    }
    _outputClosed = true;
    try {
      await _closeDestination();
    } on Object {
      // Shutdown is already owned by the routed lifecycle.
    }
  }

  void _finish() {
    if (_finished) {
      return;
    }
    _finished = true;
    if (!_closed.isCompleted) {
      _closed.complete();
    }
  }
}
