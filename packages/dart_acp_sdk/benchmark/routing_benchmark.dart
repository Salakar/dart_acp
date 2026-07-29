import 'dart:async';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:dart_acp_sdk/experimental/server.dart';

Future<void> main(List<String> arguments) async {
  final benchmarks = <AsyncBenchmarkBase>[
    for (final sessions in <int>[1, 100, 10000])
      _SessionLookupBenchmark(sessions),
    _FanOutBenchmark(),
    _RegistryCloseBenchmark(connectionCount: 100),
  ];
  if (arguments.contains('--smoke')) {
    for (final benchmark in benchmarks) {
      await benchmark.setup();
      try {
        await benchmark.run().timeout(const Duration(seconds: 10));
      } finally {
        await benchmark.teardown();
      }
    }
    return;
  }
  for (final benchmark in benchmarks) {
    await benchmark.report();
  }
}

final class _SessionLookupBenchmark extends AsyncBenchmarkBase {
  _SessionLookupBenchmark(this.sessionCount)
    : super('routing.lookup.sessions_$sessionCount');

  final int sessionCount;
  late final StreamController<Object?> _outbound;
  late final AcpServerConnectionState _state;
  var _lookups = 0;

  @override
  Future<void> setup() async {
    _outbound = StreamController<Object?>();
    _state = AcpServerConnectionState(
      connectionId: 'routing-benchmark',
      inbound: AcpWritable<Object?>(write: (_) async {}, close: () async {}),
      outbound: _outbound.stream,
      maximumSessions: sessionCount,
    );
    for (var index = 0; index < sessionCount; index += 1) {
      _state.ensureSession('session-$index');
    }
  }

  @override
  Future<void> run() async {
    var found = 0;
    for (var index = 0; index < 10000; index += 1) {
      if (_state.session('session-${index % sessionCount}') != null) {
        found += 1;
      }
    }
    _lookups += found;
  }

  @override
  Future<void> teardown() async {
    await _state.close();
    await _outbound.close();
    if (_lookups == 0) {
      throw StateError('Routing lookup benchmark did not run');
    }
    _lookups = 0;
  }
}

final class _FanOutBenchmark extends AsyncBenchmarkBase {
  _FanOutBenchmark() : super('routing.fan_out.capacity_1024');

  late final AcpOutboundHub<int> _hub;
  late final StreamSubscription<int> _fast;
  late final StreamSubscription<int> _slow;
  var _fastCount = 0;
  var _overflows = 0;

  @override
  Future<void> setup() async {
    _hub = AcpOutboundHub<int>(
      capacity: 1024,
      onOverflow: (_) => _overflows += 1,
    );
    _fast = _hub.subscribe().live.listen((_) => _fastCount += 1);
    _slow = _hub.subscribe().live.listen((_) {})..pause();
  }

  @override
  Future<void> run() async {
    for (var index = 0; index < 2048; index += 1) {
      _hub.add(index);
    }
    await Future<void>.delayed(Duration.zero);
  }

  @override
  Future<void> teardown() async {
    _slow.resume();
    await Future<void>.delayed(Duration.zero);
    await _fast.cancel();
    await _slow.cancel();
    await _hub.close();
    if (_fastCount == 0 || _overflows == 0) {
      throw StateError('Fan-out benchmark did not exercise both consumers');
    }
    _fastCount = 0;
    _overflows = 0;
  }
}

final class _RegistryCloseBenchmark extends AsyncBenchmarkBase {
  _RegistryCloseBenchmark({required this.connectionCount})
    : super('routing.registry_close.connections_$connectionCount');

  final int connectionCount;
  var _closed = 0;

  @override
  Future<void> run() async {
    var nextId = 0;
    final registry = AcpServerConnectionRegistry(
      createConnectionId: () => 'connection-${nextId++}',
    );
    final controllers = <StreamController<Object?>>[];
    for (var index = 0; index < connectionCount; index += 1) {
      final controller = StreamController<Object?>();
      controllers.add(controller);
      final id = registry.nextConnectionId();
      final state = AcpServerConnectionState(
        connectionId: id,
        inbound: AcpWritable<Object?>(write: (_) async {}, close: () async {}),
        outbound: controller.stream,
      );
      registry
        ..addPending(state)
        ..activate(id);
    }
    await registry.closeAll();
    for (final controller in controllers) {
      await controller.close();
    }
    _closed += connectionCount;
  }

  @override
  Future<void> teardown() async {
    if (_closed == 0) {
      throw StateError('Registry close benchmark did not run');
    }
    _closed = 0;
  }
}
