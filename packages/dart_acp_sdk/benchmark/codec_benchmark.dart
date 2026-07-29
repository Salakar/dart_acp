import 'dart:convert';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:dart_acp_sdk/experimental/http.dart';

Future<void> main(List<String> arguments) async {
  final smoke = arguments.contains('--smoke');
  final synchronous = <BenchmarkBase>[
    _JsonRpcCodecBenchmark(),
    _GeneratedDtoBenchmark(),
  ];
  final asynchronous = <AsyncBenchmarkBase>[
    for (final payloadBytes in <int>[1024, 1024 * 1024])
      for (final chunkCount in <int>[1, 64, 1024])
        _NdJsonDecodeBenchmark(
          payloadBytes: payloadBytes,
          chunkCount: chunkCount,
        ),
    _NdJsonDecodeBenchmark(payloadBytes: 10 * 1024 * 1024, chunkCount: 1024),
    _SseDecodeBenchmark(),
  ];

  if (smoke) {
    await _runSmoke(
      synchronous,
      asynchronous,
    ).timeout(const Duration(seconds: 15));
    return;
  }
  for (final benchmark in synchronous) {
    benchmark.report();
  }
  for (final benchmark in asynchronous) {
    await benchmark.report();
  }
}

Future<void> _runSmoke(
  List<BenchmarkBase> synchronous,
  List<AsyncBenchmarkBase> asynchronous,
) async {
  for (final benchmark in synchronous) {
    benchmark
      ..setup()
      ..run()
      ..teardown();
  }
  for (final benchmark in asynchronous) {
    await benchmark.setup();
    try {
      await benchmark.run();
    } finally {
      await benchmark.teardown();
    }
  }
}

final class _JsonRpcCodecBenchmark extends BenchmarkBase {
  _JsonRpcCodecBenchmark() : super('json_rpc.batch_100_decode');

  final JsonRpcCodec _codec = const JsonRpcCodec();
  late final List<Object?> _batch;
  int _decoded = 0;

  @override
  void setup() {
    _batch = <Object?>[
      for (var index = 0; index < 100; index += 1)
        <String, Object?>{
          'jsonrpc': '2.0',
          'id': index,
          'method': '_benchmark/echo',
          'params': <String, Object?>{'index': index},
        },
    ];
  }

  @override
  void run() {
    _decoded =
        (_codec.decodeWireMessage(_batch).toJson() as List<Object?>).length;
  }

  @override
  void teardown() {
    if (_decoded != 100) {
      throw StateError('JSON-RPC benchmark decoded $_decoded entries');
    }
  }
}

final class _GeneratedDtoBenchmark extends BenchmarkBase {
  _GeneratedDtoBenchmark() : super('generated.plan_and_open_union_round_trip');

  late final Plan _plan;
  late final CreateElicitationRequest _custom;
  Object? _last;

  @override
  void setup() {
    _plan = Plan(
      entries: <PlanEntry>[
        for (var index = 0; index < 50; index += 1)
          PlanEntry(
            content: 'Task $index',
            priority: PlanEntryPriority.medium,
            status: index.isEven
                ? PlanEntryStatus.inProgress
                : PlanEntryStatus.pending,
          ),
      ],
    );
    _custom = CreateElicitationRequest.fromJson(<String, Object?>{
      'mode': '_benchmark/custom',
      'message': 'Benchmark prompt',
      'payload': <String, Object?>{'enabled': true},
    });
  }

  @override
  void run() {
    _last = <Object?>[
      Plan.fromJson(_plan.toJson()).toJson(),
      CreateElicitationRequest.fromJson(_custom.toJson()).toJson(),
    ];
  }

  @override
  void teardown() {
    if (_last is! List<Object?>) {
      throw StateError('Generated DTO benchmark did not complete');
    }
  }
}

final class _NdJsonDecodeBenchmark extends AsyncBenchmarkBase {
  _NdJsonDecodeBenchmark({required this.payloadBytes, required this.chunkCount})
    : super('ndjson.${payloadBytes}_bytes.chunks_$chunkCount');

  final int payloadBytes;
  final int chunkCount;
  late final List<List<int>> _chunks;
  var _decoded = 0;

  @override
  Future<void> setup() async {
    final text = List<String>.filled(payloadBytes ~/ 2, 'é').join();
    final bytes = utf8.encode(
      '${jsonEncode(<String, Object?>{
        'jsonrpc': '2.0',
        'method': '_benchmark/unicode',
        'params': <String, Object?>{'text': text},
      })}\n',
    );
    final effectiveCount = chunkCount < bytes.length
        ? chunkCount
        : bytes.length;
    _chunks = <List<int>>[];
    for (var index = 0; index < effectiveCount; index += 1) {
      final start = bytes.length * index ~/ effectiveCount;
      final end = bytes.length * (index + 1) ~/ effectiveCount;
      _chunks.add(bytes.sublist(start, end));
    }
  }

  @override
  Future<void> run() async {
    final stream = ndJsonStream(
      input: Stream<List<int>>.fromIterable(_chunks),
      output: AcpWritable<List<int>>(
        write: (_) => Future<void>.value(),
        close: () => Future<void>.value(),
      ),
      options: NdJsonStreamOptions(maximumLineBytes: payloadBytes + 2048),
    );
    _decoded = (await stream.readable.toList()).length;
  }

  @override
  Future<void> teardown() async {
    if (_decoded != 1) {
      throw StateError('NDJSON benchmark decoded $_decoded messages');
    }
  }
}

final class _SseDecodeBenchmark extends AsyncBenchmarkBase {
  _SseDecodeBenchmark() : super('sse.100_multiline_events');

  late final List<List<int>> _chunks;
  var _decoded = 0;

  @override
  Future<void> setup() async {
    final buffer = StringBuffer();
    for (var index = 0; index < 100; index += 1) {
      final newline = index.isEven ? '\n' : '\r\n';
      buffer
        ..write(': keepalive$newline')
        ..write('data: {"jsonrpc":"2.0","method":"_benchmark/event",$newline')
        ..write('data: "params":{"index":$index}}$newline')
        ..write(newline);
    }
    final bytes = utf8.encode(buffer.toString());
    _chunks = <List<int>>[
      for (var offset = 0; offset < bytes.length; offset += 64)
        bytes.sublist(
          offset,
          offset + 64 < bytes.length ? offset + 64 : bytes.length,
        ),
    ];
  }

  @override
  Future<void> run() async {
    _decoded = (await decodeSseJson(
      Stream<List<int>>.fromIterable(_chunks),
    ).toList()).length;
  }

  @override
  Future<void> teardown() async {
    if (_decoded != 100) {
      throw StateError('SSE benchmark decoded $_decoded events');
    }
  }
}
