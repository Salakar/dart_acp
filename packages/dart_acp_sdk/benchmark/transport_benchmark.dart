import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../example/http_client.dart' as http_example;
import '../example/http_server.dart';
import '../example/main.dart' as in_process_example;
import '../example/stdio_client.dart' as stdio_example;
import '../example/web_socket_client.dart' as web_socket_example;

Future<void> main(List<String> arguments) async {
  final smoke = arguments.contains('--smoke');
  final iterations = smoke ? 1 : 20;
  final results = <_LatencyResult>[];

  results.add(
    await _measure(
      'end_to_end.in_process',
      iterations,
      in_process_example.runInProcessExample,
    ),
  );
  results.add(
    await _measure(
      'end_to_end.stdio',
      iterations,
      stdio_example.runStdioClientExample,
    ),
  );

  final server = await startRemoteExampleServer();
  try {
    results
      ..add(
        await _measure(
          'end_to_end.http_sse',
          iterations,
          () => http_example.runHttpExampleClient(server.httpEndpoint),
        ),
      )
      ..add(
        await _measure(
          'end_to_end.web_socket',
          iterations,
          () => web_socket_example.runWebSocketExampleClient(
            server.webSocketEndpoint,
          ),
        ),
      );
  } finally {
    await server.close();
  }

  if (smoke) {
    return;
  }
  final report = <String, Object?>{
    'environment': <String, Object?>{
      'dart': Platform.version.split(' ').first,
      'operatingSystem': Platform.operatingSystem,
      'processors': Platform.numberOfProcessors,
    },
    'iterations': iterations,
    'results': <Object?>[for (final result in results) result.toJson()],
  };
  if (arguments.contains('--json')) {
    stdout.writeln(const JsonEncoder.withIndent('  ').convert(report));
    return;
  }
  for (final result in results) {
    stdout.writeln(
      '${result.name}: p50 ${result.p50Micros} µs, '
      'p95 ${result.p95Micros} µs',
    );
  }
}

Future<_LatencyResult> _measure(
  String name,
  int iterations,
  Future<Object?> Function() operation,
) async {
  await operation();
  final samples = <int>[];
  for (var index = 0; index < iterations; index += 1) {
    final stopwatch = Stopwatch()..start();
    await operation();
    stopwatch.stop();
    samples.add(stopwatch.elapsedMicroseconds);
  }
  samples.sort();
  return _LatencyResult(
    name: name,
    p50Micros: _percentile(samples, 0.50),
    p95Micros: _percentile(samples, 0.95),
  );
}

int _percentile(List<int> sorted, double percentile) {
  final index = max(0, (sorted.length * percentile).ceil() - 1);
  return sorted[index];
}

final class _LatencyResult {
  const _LatencyResult({
    required this.name,
    required this.p50Micros,
    required this.p95Micros,
  });

  final String name;
  final int p50Micros;
  final int p95Micros;

  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'p50Micros': p50Micros,
    'p95Micros': p95Micros,
  };
}
