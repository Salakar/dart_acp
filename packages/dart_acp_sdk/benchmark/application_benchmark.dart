import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

Future<void> main(List<String> arguments) async {
  final smoke = arguments.contains('--smoke');
  final benchmarks = <AsyncBenchmarkBase>[
    _PromptTurnBenchmark(sessionCount: 1),
    _PromptTurnBenchmark(sessionCount: 100),
  ];
  if (smoke) {
    for (final benchmark in benchmarks) {
      await benchmark.setup();
      try {
        await benchmark.run().timeout(const Duration(seconds: 5));
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

final class _PromptTurnBenchmark extends AsyncBenchmarkBase {
  _PromptTurnBenchmark({required this.sessionCount})
    : super('application.prompt_turn.sessions_$sessionCount');

  final int sessionCount;
  AcpDirectConnectionPair? _pair;
  AcpActiveSession? _session;
  final List<AcpActiveSession> _sessions = <AcpActiveSession>[];
  var _nextSession = 0;
  var _turns = 0;

  @override
  Future<void> setup() async {
    final agent =
        AcpAgentApp.v1(
              implementation: Implementation(
                name: 'benchmark-agent',
                version: '1.0.0',
              ),
              capabilities: AgentCapabilities(
                loadSession: false,
                promptCapabilities: PromptCapabilities(
                  image: false,
                  audio: false,
                  embeddedContext: false,
                ),
                mcpCapabilities: McpCapabilities(http: false, sse: false),
                sessionCapabilities: SessionCapabilities(),
                auth: AgentAuthCapabilities(),
              ),
            )
            .onNewSession((_) {
              _nextSession += 1;
              return NewSessionResponse(
                sessionId: SessionId('benchmark-session-$_nextSession'),
              );
            })
            .onPrompt((context) async {
              await context.client.updateSession(
                SessionNotification(
                  sessionId: context.params.sessionId,
                  update: SessionUpdateAgentMessageChunk(
                    ContentChunk(
                      content: ContentBlockText(TextContent(text: 'ok')),
                    ),
                  ),
                ),
              );
              return PromptResponse(stopReason: StopReason.endTurn);
            });
    final client = AcpClientApp.v1(
      implementation: Implementation(
        name: 'benchmark-client',
        version: '1.0.0',
      ),
      capabilities: ClientCapabilities(
        fs: FileSystemCapabilities(readTextFile: false, writeTextFile: false),
        terminal: false,
      ),
    );
    final pair = await client.connectWith(agent);
    _pair = pair;
    for (var index = 0; index < sessionCount; index += 1) {
      _sessions.add(
        await pair.client.agent
            .newSession(cwd: AcpAbsolutePath('/workspace/$index'))
            .start(),
      );
    }
    _session = _sessions.last;
  }

  @override
  Future<void> run() async {
    final result = await _session!
        .prompt(
          content: <ContentBlock>[
            ContentBlockText(TextContent(text: 'benchmark')),
          ],
        )
        .collectText();
    if (result.text != 'ok' ||
        result.response.stopReason != StopReason.endTurn) {
      throw StateError('Unexpected prompt result');
    }
    _turns += 1;
  }

  @override
  Future<void> teardown() async {
    for (final session in _sessions) {
      session.dispose();
    }
    _sessions.clear();
    await _pair?.close();
    _pair = null;
    _session = null;
    if (_turns == 0) {
      throw StateError('Application benchmark did not run');
    }
    _turns = 0;
    _nextSession = 0;
  }
}
