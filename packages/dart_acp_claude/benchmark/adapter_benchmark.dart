import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';

void main(List<String> arguments) {
  final benchmarks = <BenchmarkBase>[
    _PromptBenchmark(),
    _MessageBenchmark(),
    _LargeToolResultBenchmark(),
    _ElicitationBenchmark(),
  ];
  if (arguments.contains('--smoke')) {
    for (final benchmark in benchmarks) {
      benchmark
        ..setup()
        ..run()
        ..teardown();
    }
    return;
  }
  for (final benchmark in benchmarks) {
    benchmark.report();
  }
}

final class _PromptBenchmark extends BenchmarkBase {
  _PromptBenchmark() : super('prompt.blocks_1000');

  final ClaudePromptMapper mapper = const ClaudePromptMapper();
  late List<ContentBlock> prompt;
  var mapped = 0;

  @override
  void setup() {
    prompt = <ContentBlock>[
      for (var index = 0; index < 1000; index += 1)
        ContentBlockText(TextContent(text: 'message $index')),
    ];
  }

  @override
  void run() {
    final content = mapper.map(prompt).content;
    if (content is List<Object?>) mapped += content.length;
  }

  @override
  void teardown() {
    if (mapped == 0 || mapped % 1000 != 0) {
      throw StateError('Prompt benchmark mapped $mapped blocks');
    }
    mapped = 0;
  }
}

final class _MessageBenchmark extends BenchmarkBase {
  _MessageBenchmark() : super('message.mixed_blocks_100');

  final ClaudeMessageProjector mapper = const ClaudeMessageProjector();
  late claude.AssistantMessage message;
  var mapped = 0;

  @override
  void setup() {
    message = claude.AssistantMessage(
      model: 'benchmark-model',
      messageId: 'benchmark-message',
      content: <claude.ContentBlock>[
        for (var index = 0; index < 100; index += 1)
          if (index % 3 == 0)
            claude.ToolUseBlock(
              id: 'tool-$index',
              name: 'Read',
              input: <String, Object?>{'file_path': 'lib/$index.dart'},
            )
          else if (index.isEven)
            claude.ThinkingBlock(
              thinking: 'thought $index',
              signature: 'signature',
            )
          else
            claude.TextBlock('text $index'),
      ],
    );
  }

  @override
  void run() {
    mapped += mapper.project(message, cwd: '/workspace').length;
  }

  @override
  void teardown() {
    if (mapped == 0 || mapped % 100 != 0) {
      throw StateError('Message benchmark mapped $mapped updates');
    }
    mapped = 0;
  }
}

final class _LargeToolResultBenchmark extends BenchmarkBase {
  _LargeToolResultBenchmark() : super('tool_result.text_64k');

  final ClaudeToolProjector mapper = const ClaudeToolProjector();
  late claude.ToolResultBlock block;
  var mapped = 0;

  @override
  void setup() {
    block = claude.ToolResultBlock(
      toolUseId: 'tool',
      content:
          '${List<String>.filled(65536, 'x').join()}'
          '\n<usage>tokens</usage>',
    );
  }

  @override
  void run() {
    mapped += mapper.finish(block).toJson().length;
  }

  @override
  void teardown() {
    if (mapped == 0) throw StateError('Tool result benchmark mapped nothing');
    mapped = 0;
  }
}

final class _ElicitationBenchmark extends BenchmarkBase {
  _ElicitationBenchmark() : super('elicitation.questions_100');

  final ClaudeElicitationMapper mapper = const ClaudeElicitationMapper();
  late Map<String, Object?> input;
  var mapped = 0;

  @override
  void setup() {
    input = <String, Object?>{
      'questions': <Object?>[
        for (var index = 0; index < 100; index += 1)
          <String, Object?>{
            'question': 'Question $index?',
            'header': 'Q$index',
            'multiSelect': index.isEven,
            'options': <Object?>[
              <String, Object?>{
                'label': 'Yes',
                'description': 'Accept question $index',
              },
              <String, Object?>{'label': 'No'},
            ],
          },
      ],
    };
  }

  @override
  void run() {
    final request = mapper.mapAskUserQuestion(
      input,
      sessionId: SessionId('benchmark'),
      toolCallId: 'tool',
    );
    mapped += request?.toJson().length ?? 0;
  }

  @override
  void teardown() {
    if (mapped == 0) throw StateError('Elicitation benchmark mapped nothing');
    mapped = 0;
  }
}
