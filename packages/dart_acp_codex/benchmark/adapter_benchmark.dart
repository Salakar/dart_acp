import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_acp_codex/dart_acp_codex.dart';
import 'package:dart_acp_codex/src/bridge/event_mapper.dart';
import 'package:dart_acp_codex/src/bridge/history_mapper.dart';
import 'package:dart_acp_codex/src/session/state.dart';
import 'package:dart_acp_codex/src/session/steering_queue.dart';

Future<void> main(List<String> arguments) async {
  final synchronous = <BenchmarkBase>[
    _EventBenchmark('event.message_delta.1000', <CodexNotification>[
      _messageDelta(),
    ]),
    _EventBenchmark('event.mixed.1000', <CodexNotification>[
      _messageDelta(),
      _terminalDelta(),
      _usageUpdate(),
    ]),
    _HistoryBenchmark(),
    _SessionRoutingBenchmark(),
  ];
  final asynchronous = <AsyncBenchmarkBase>[_SteeringBenchmark()];
  if (arguments.contains('--smoke')) {
    for (final benchmark in synchronous) {
      benchmark
        ..setup()
        ..run()
        ..teardown();
    }
    for (final benchmark in asynchronous) {
      await benchmark.setup();
      try {
        await benchmark.run().timeout(const Duration(seconds: 5));
      } finally {
        await benchmark.teardown();
      }
    }
    return;
  }
  for (final benchmark in synchronous) {
    benchmark.report();
  }
  for (final benchmark in asynchronous) {
    await benchmark.report();
  }
}

CodexNotification _messageDelta() => CodexNotification(
  method: 'item/agentMessage/delta',
  params: CodexJsonObject.from(<String, Object?>{'delta': 'hello'}),
  itemId: const CodexItemId('message'),
);

CodexNotification _terminalDelta() => CodexNotification(
  method: 'item/commandExecution/outputDelta',
  params: CodexJsonObject.from(<String, Object?>{
    'itemId': 'command',
    'delta': 'output',
  }),
  itemId: const CodexItemId('command'),
);

CodexNotification _usageUpdate() => CodexNotification(
  method: 'thread/tokenUsage/updated',
  params: CodexJsonObject.from(<String, Object?>{
    'totalTokens': 1000,
    'modelContextWindow': 128000,
  }),
);

final class _EventBenchmark extends BenchmarkBase {
  _EventBenchmark(super.name, this.events);

  final List<CodexNotification> events;
  late CodexEventMapper mapper;
  var mapped = 0;

  @override
  void setup() {
    mapper = CodexEventMapper();
  }

  @override
  void run() {
    for (var index = 0; index < 1000; index += 1) {
      for (final event in events) {
        mapped += mapper.map(event).length;
      }
    }
  }

  @override
  void teardown() {
    if (mapped == 0) {
      throw StateError('Event benchmark produced no updates');
    }
    mapped = 0;
  }
}

final class _HistoryBenchmark extends BenchmarkBase {
  _HistoryBenchmark() : super('history.replay.items_100');

  late CodexJsonObject thread;
  var mapped = 0;

  @override
  void setup() {
    thread = CodexJsonObject.from(<String, Object?>{
      'turns': <Object?>[
        <String, Object?>{
          'id': 'turn',
          'items': <Object?>[
            for (var index = 0; index < 100; index += 1)
              <String, Object?>{
                'id': 'message-$index',
                'type': index.isEven ? 'userMessage' : 'agentMessage',
                'text': 'message $index',
              },
          ],
        },
      ],
    });
  }

  @override
  void run() {
    mapped += CodexHistoryMapper().map(thread).length;
  }

  @override
  void teardown() {
    if (mapped == 0 || mapped % 100 != 0) {
      throw StateError('History benchmark replayed $mapped items');
    }
    mapped = 0;
  }
}

final class _SessionRoutingBenchmark extends BenchmarkBase {
  _SessionRoutingBenchmark() : super('session.routing.sessions_1000');

  late CodexSessionRegistry registry;
  var found = 0;

  @override
  void setup() {
    registry = CodexSessionRegistry();
    for (var index = 0; index < 1000; index += 1) {
      registry.add(
        CodexSessionState(
          sessionId: SessionId('session-$index'),
          cwd: '/workspace/$index',
          additionalDirectories: const <String>[],
          agentMode: CodexAgentMode.workspaceWrite,
          collaborationMode: CodexCollaborationMode.standard,
          model: 'model',
          effort: CodexReasoningEffort.medium,
        ),
      );
    }
  }

  @override
  void run() {
    for (var index = 0; index < 10000; index += 1) {
      if (registry.byThread(CodexThreadId('session-${index % 1000}')) != null) {
        found += 1;
      }
    }
  }

  @override
  void teardown() {
    if (found == 0 || found % 10000 != 0) {
      throw StateError('Session benchmark missed lookups');
    }
    found = 0;
  }
}

final class _SteeringBenchmark extends AsyncBenchmarkBase {
  _SteeringBenchmark() : super('steering.queue.entries_100');

  var completed = 0;

  @override
  Future<void> run() async {
    final queue = CodexSteeringQueue<int>((_) async {
      completed += 1;
      return const CodexSteeringInjected();
    });
    await Future.wait<CodexSteeringOutcome>(<Future<CodexSteeringOutcome>>[
      for (var index = 0; index < 100; index += 1) queue.enqueue(index),
    ]);
  }

  @override
  Future<void> teardown() async {
    if (completed == 0 || completed % 100 != 0) {
      throw StateError('Steering benchmark completed $completed entries');
    }
    completed = 0;
  }
}
