import 'dart:async';
import 'dart:math';

import 'server_connection.dart';

/// Tracks pending-handshake and active remote ACP connections.
final class AcpServerConnectionRegistry {
  /// Creates a registry.
  AcpServerConnectionRegistry({String Function()? createConnectionId})
    : _createConnectionId = createConnectionId ?? _randomUuidV4;

  final String Function() _createConnectionId;
  final Map<String, AcpServerConnectionState> _pending =
      <String, AcpServerConnectionState>{};
  final Map<String, AcpServerConnectionState> _active =
      <String, AcpServerConnectionState>{};
  final Set<String> _reserved = <String>{};
  Future<void>? _closeFuture;
  bool _isClosed = false;

  /// Number of active, publicly routable connections.
  int get activeCount => _active.length;

  /// Number of connections still completing their handshake.
  int get pendingCount => _pending.length;

  /// Whether this registry has begun terminal shutdown.
  bool get isClosed => _isClosed;

  /// Generates an ID not used by an active or pending state.
  String nextConnectionId() => _generateConnectionId(reserve: false);

  /// Atomically reserves a unique ID for an asynchronous connection factory.
  String reserveConnectionId() => _generateConnectionId(reserve: true);

  String _generateConnectionId({required bool reserve}) {
    if (_isClosed) {
      throw StateError('ACP connection registry is closed');
    }
    for (int attempt = 0; attempt < 100; attempt += 1) {
      final String id = _createConnectionId();
      if (id.isNotEmpty &&
          !_reserved.contains(id) &&
          !_pending.containsKey(id) &&
          !_active.containsKey(id)) {
        if (reserve) {
          _reserved.add(id);
        }
        return id;
      }
    }
    throw StateError('Could not generate a unique ACP connection ID');
  }

  /// Adds [state] as a non-routable pending handshake.
  void addPending(AcpServerConnectionState state) {
    if (_reserved.contains(state.connectionId)) {
      throw StateError(
        'ACP connection ID is reserved by an asynchronous handshake',
      );
    }
    _addPending(state);
  }

  /// Publishes [state] into the pending map using its reserved ID.
  void addReservedPending(AcpServerConnectionState state) {
    final String id = state.connectionId;
    if (!_reserved.contains(id)) {
      throw StateError('Unknown ACP connection ID reservation: $id');
    }
    _addPending(state);
    _reserved.remove(id);
  }

  /// Releases an unused asynchronous handshake reservation.
  void releaseConnectionId(String connectionId) {
    _reserved.remove(connectionId);
  }

  void _addPending(AcpServerConnectionState state) {
    if (_isClosed) {
      throw StateError('ACP connection registry is closed');
    }
    final String id = state.connectionId;
    if (_pending.containsKey(id) || _active.containsKey(id)) {
      throw StateError('Duplicate ACP connection ID: $id');
    }
    if (state.isClosed) {
      throw StateError('Cannot register a closed ACP connection');
    }
    _pending[id] = state;
    state.closed.whenComplete(() {
      if (identical(_pending[id], state)) {
        _pending.remove(id);
      }
      if (identical(_active[id], state)) {
        _active.remove(id);
      }
    });
  }

  /// Publishes a pending connection after successful initialization.
  AcpServerConnectionState activate(String connectionId) {
    final AcpServerConnectionState? state = _pending.remove(connectionId);
    if (state == null) {
      throw StateError('Unknown pending ACP connection: $connectionId');
    }
    if (state.isClosed) {
      throw StateError('Cannot activate a closed ACP connection');
    }
    _active[connectionId] = state;
    return state;
  }

  /// Finds only an initialized active connection.
  AcpServerConnectionState? lookup(String connectionId) =>
      _active[connectionId];

  /// Removes and closes one active connection.
  Future<bool> remove(String connectionId, [Object? reason]) async {
    final AcpServerConnectionState? state = _active.remove(connectionId);
    if (state == null) {
      return false;
    }
    await state.close(reason);
    return true;
  }

  /// Discards and closes an active or pending connection.
  Future<bool> discard(String connectionId, [Object? reason]) async {
    final AcpServerConnectionState? state =
        _active.remove(connectionId) ?? _pending.remove(connectionId);
    if (state == null) {
      return false;
    }
    await state.close(reason);
    return true;
  }

  /// Clears the registry first, then waits for every state to close.
  Future<void> closeAll([Object? reason]) {
    final Future<void>? existing = _closeFuture;
    if (existing != null) {
      return existing;
    }
    _isClosed = true;
    final completer = Completer<void>();
    _closeFuture = completer.future;
    unawaited(
      Future<void>.sync(() => _runCloseAll(reason)).then<void>(
        (_) => completer.complete(),
        onError: (Object error, StackTrace stackTrace) =>
            completer.completeError(error, stackTrace),
      ),
    );
    return completer.future;
  }

  Future<void> _runCloseAll(Object? reason) async {
    final Set<AcpServerConnectionState> states = <AcpServerConnectionState>{
      ..._active.values,
      ..._pending.values,
    };
    _active.clear();
    _pending.clear();
    _reserved.clear();
    await Future.wait<void>(
      states.map((AcpServerConnectionState state) => state.close(reason)),
    );
  }

  static String _randomUuidV4() {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(
      16,
      (int _) => random.nextInt(256),
      growable: false,
    );
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    String hex(int value) => value.toRadixString(16).padLeft(2, '0');
    final String value = bytes.map(hex).join();
    return '${value.substring(0, 8)}-'
        '${value.substring(8, 12)}-'
        '${value.substring(12, 16)}-'
        '${value.substring(16, 20)}-'
        '${value.substring(20)}';
  }
}
