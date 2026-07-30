import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:claude_agent_sdk/claude_agent_sdk.dart';

final class ToolUseModelBenchmark extends BenchmarkBase {
  ToolUseModelBenchmark() : super('ToolUseBlock construction');

  ToolUseBlock? latest;

  @override
  void run() {
    latest = ToolUseBlock(
      id: 'tool-1',
      name: 'Read',
      input: {
        'file_path': '/tmp/example.dart',
        'options': {'offset': 10, 'limit': 100},
      },
    );
  }
}

void main(List<String> arguments) {
  final benchmark = ToolUseModelBenchmark();
  if (arguments.contains('--smoke')) {
    benchmark.run();
    return;
  }
  benchmark.report();
}
