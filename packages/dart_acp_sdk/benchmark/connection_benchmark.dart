import 'dart:async';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

Future<void> main(List<String> arguments) async {
  final benchmarks = <AsyncBenchmarkBase>[
    for (final count in <int>[1, 100, 1000]) _PendingDispatchBenchmark(count),
    _MixedBatchDispatchBenchmark(),
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

final class _PendingDispatchBenchmark extends AsyncBenchmarkBase {
  _PendingDispatchBenchmark(this.pendingCount)
    : super('json_rpc.pending_dispatch.$pendingCount');

  final int pendingCount;
  late final AcpInProcessTransportPair<Object?> _pair;
  late final JsonRpcConnection _connection;
  late final StreamSubscription<Object?> _peer;
  final List<Map<String, Object?>> _requests = <Map<String, Object?>>[];
  Completer<void>? _received;
  var _completed = 0;

  @override
  Future<void> setup() async {
    _pair = acpInProcessTransportPair<Object?>(
      maximumBufferedMessages: pendingCount + 1,
    );
    _connection = JsonRpcConnection(
      stream: _pair.left,
      options: JsonRpcConnectionOptions(maximumPendingRequests: pendingCount),
    );
    _peer = _pair.right.readable.listen((value) {
      _requests.add(value! as Map<String, Object?>);
      if (_requests.length == pendingCount) {
        _received?.complete();
      }
    });
  }

  @override
  Future<void> run() async {
    _requests.clear();
    _received = Completer<void>();
    final responses = <Future<Object?>>[
      for (var index = 0; index < pendingCount; index += 1)
        _connection.sendRequest<Object?>(
          method: '_benchmark/pending',
          params: JsonRpcParams.value(<String, Object?>{'index': index}),
        ),
    ];
    await _received!.future;
    for (final request in _requests.reversed) {
      await _pair.right.writable.write(<String, Object?>{
        'jsonrpc': '2.0',
        'id': request['id'],
        'result': request['params'],
      });
    }
    final results = await Future.wait<Object?>(responses);
    _completed += results.length;
  }

  @override
  Future<void> teardown() async {
    _connection.close();
    await _peer.cancel();
    await _pair.right.writable.close();
    if (_completed == 0) {
      throw StateError('Pending dispatch benchmark did not complete');
    }
    _completed = 0;
  }
}

final class _MixedBatchDispatchBenchmark extends AsyncBenchmarkBase {
  _MixedBatchDispatchBenchmark()
    : super('json_rpc.batch_dispatch.50_requests_50_notifications');

  late final AcpInProcessTransportPair<Object?> _pair;
  late final JsonRpcConnection _left;
  late final JsonRpcConnection _right;
  var _notifications = 0;
  var _completed = 0;

  @override
  Future<void> setup() async {
    _pair = acpInProcessTransportPair<Object?>();
    _left = JsonRpcConnection(stream: _pair.left);
    _right = JsonRpcConnectionBuilder()
        .onRequest<Object?>(
          method: '_benchmark/request',
          parse: (value) => value,
          handler: (params, responder, _) async {
            await responder.respond(params);
            return const JsonRpcHandled();
          },
        )
        .onNotification<Object?>(
          method: '_benchmark/notification',
          parse: (value) => value,
          handler: (_, _) {
            _notifications += 1;
            return const JsonRpcHandled();
          },
        )
        .connect(stream: _pair.right);
  }

  @override
  Future<void> run() async {
    final entries = <JsonRpcBatchEntry>[
      for (var index = 0; index < 50; index += 1) ...<JsonRpcBatchEntry>[
        JsonRpcBatchRequest<Object?>(
          method: '_benchmark/request',
          params: JsonRpcParams.value(<String, Object?>{'index': index}),
        ),
        JsonRpcBatchNotification(
          method: '_benchmark/notification',
          params: JsonRpcParams.value(<String, Object?>{'index': index}),
        ),
      ],
    ];
    final results = await _left.sendBatch(entries);
    if (results.length != 100) {
      throw StateError('Mixed batch returned ${results.length} outputs');
    }
    _completed += 1;
  }

  @override
  Future<void> teardown() async {
    _left.close();
    _right.close();
    await _pair.left.writable.close();
    await _pair.right.writable.close();
    if (_completed == 0 || _notifications == 0) {
      throw StateError('Mixed batch dispatch benchmark did not complete');
    }
    _completed = 0;
    _notifications = 0;
  }
}
