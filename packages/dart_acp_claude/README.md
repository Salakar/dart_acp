<p align="center">
  <img src="assets/logo.png" alt="dart_acp_claude logo" width="160" height="160">
</p>

<h1 align="center">dart_acp_claude</h1>

<hr>

<p align="center">
  A typed ACP client and adapter for Claude Code.
</p>

`dart_acp_claude` exposes Claude Code through ACP using the typed
`claude_agent_sdk`. Use `ClaudeAcpClient.start()` for a ready in-process ACP
client, embed `ClaudeAcpAgent` behind another transport, or run the packaged
stdio agent. The package requires Dart 3.10 or newer and an installed,
authenticated Claude Code CLI for live requests.

Claude Code goals use the provider-neutral ACP goal extension. The adapter
advertises update and clear, forwards those operations through
`_session/goal_control`, and publishes live state through
`session_info_update._meta.goal`.

## Install

```console
dart pub add dart_acp_claude
```

Install and authenticate Claude Code separately.

## Quick start

```dart
import 'dart:io';

import 'package:dart_acp_claude/dart_acp_claude.dart';

Future<void> main() async {
  final client = await ClaudeAcpClient.start();
  try {
    final session = await client.agent.createSession(
      NewSessionRequest(
        cwd: Directory.current.path,
        mcpServers: const <McpServer>[],
      ),
    );
    final result = await client.agent.sendPrompt(
      PromptRequest(
        sessionId: session.sessionId,
        prompt: <ContentBlock>[
          ContentBlockText(TextContent(text: 'Summarize this project.')),
        ],
      ),
    );
    print(result.stopReason);
  } finally {
    await client.close();
  }
}
```

`ClaudeAcpClient` owns the in-process ACP connection and underlying adapter.
Its `connection`, `agent`, `closed`, and `close()` members match the other
provider client packages.

## Configuration

Pass `ClaudeAcpClientOptions` to configure the Claude executable, environment,
model, permissions, tools, programmatic agents, skills/plugins, hooks,
sandboxing, thinking, and turn/budget limits. It aliases the adapter-level
`ClaudeAcpOptions` type:

```dart
final client = await ClaudeAcpClient.start(
  options: ClaudeAcpClientOptions(maxTurns: 20),
);
```

Programmatic subagents are forwarded to `claude_agent_sdk` without flattening
their configuration:

```dart
final client = await ClaudeAcpClient.start(
  options: ClaudeAcpClientOptions(
    agents: {
      'test-runner': AgentDefinition(
        description: 'Runs tests and diagnoses failures.',
        prompt: 'Run focused tests and report evidence.',
        tools: const ['Read', 'Glob', 'Grep', 'Bash'],
      ),
    },
    forwardSubagentText: true,
    agentProgressSummaries: true,
  ),
);
```

Claude invokes these through its Agent tool. Nested assistant/tool activity is
projected as ACP updates with subagent metadata when the client advertises the
subagent-transcript extension; legacy clients receive the safe flattened tool
view. `forwardSubagentText` defaults to `true` in this adapter so capable ACP
clients receive the complete nested conversation.

Pass a configured `AcpClientApp` to `ClaudeAcpClient.start(app: ...)` when your
application should handle permission, file-system, terminal, or elicitation
requests. The default app advertises no file-system or terminal proxy
capabilities and declines permissions.

ACP callers can override JSON-serializable SDK options per session through the
same `_meta.claudeCode.options` extension as the upstream adapter:

```dart
final session = await client.agent.createSession(
  NewSessionRequest(
    cwd: Directory.current.path,
    mcpServers: const <McpServer>[],
    meta: AcpJsonObject.fromObject({
      'claudeCode': {
        'emitRawSDKMessages': [
          {'type': 'system', 'subtype': 'task_started'},
        ],
        'options': {
          'model': 'sonnet',
          'allowedTools': ['Read', 'Glob', 'Grep'],
          'forwardSubagentText': true,
          'agentProgressSummaries': true,
          'maxTurns': 12,
          'env': {'PROJECT_FLAVOR': 'review'},
        },
      },
    }),
  ),
);
```

This includes tools, agents, MCP servers, prompts, settings, directories,
sandboxing, plugins, skills, thinking/effort, budgets, persistence, debug, and
output configuration. ACP-owned lifecycle fields and function callbacks remain
process-level options because JSON metadata cannot carry Dart functions.

## Adapter and stdio APIs

Use `ClaudeAcpAgent` directly when supplying your own ACP transport. To expose
the adapter over process stdio:

```console
dart run dart_acp_claude
```

The adapter supports session lifecycle, prompt streaming, tools, plans,
permissions, configuration, providers, steering, MCP servers, and
elicitations. A long-lived consumer keeps forwarding task output after the
foreground prompt has completed without allowing background result frames to
complete a later turn.

## Supported features

| Area | Support |
| --- | --- |
| Sessions | create, resume, load/replay, fork, list, close, and delete |
| Prompts | text, resource links, embedded context, and images |
| Updates | text, thoughts, tools, plans, usage/cost, commands, images, and nested subagent transcripts |
| Control | FIFO prompt queueing, steering, cancellation, modes, and config |
| Interaction | permissions, AskUserQuestion, form/URL elicitation, fallback consent |
| Routing | stdio/HTTP/SSE MCP servers and optional Anthropic/Bedrock/Vertex gateways |
| Authentication | capability-sensitive terminal login, gateway auth, and logout |
| Compatibility | stable and unstable ACP handlers, replay, raw message access, programmatic/main-thread agents |

Provider headers remain process-local and are never returned by provider
discovery or included in display strings.

Task/Todo tools are projected as ACP plans, including streamed input and
TaskCreated/TaskCompleted hook updates. If a plan tool needs permission, the
adapter first emits a real tool card so strict clients can resolve the
permission reference, then completes that card when the result arrives.
Denied, interrupted, and cancelled results retain Claude's structured
non-execution classification and optional user feedback.

Set `forwardSdkMessages: true` to mirror every raw Claude frame over
`_claude/sdkMessage`, or use `sdkMessageFilters` to select messages by
top-level type, subtype, and/or `origin.kind`.

## Example and benchmarks

The [deterministic example](example/main.dart) exercises a complete streamed
turn, permission request, active-turn steering, usage, and shutdown without
credentials:

```console
dart run example/main.dart
```

The [benchmark suite](benchmark/README.md) covers prompt, message, large tool
result, and elicitation conversion:

```console
dart run benchmark/adapter_benchmark.dart
dart run benchmark/adapter_benchmark.dart --smoke
```

| Scenario | Reference runtime |
| --- | ---: |
| 1,000 prompt blocks | 6,909.2 µs |
| 100 mixed assistant blocks | 2,188.2 µs |
| 64 KiB tool result | 1,393.6 µs |
| 100-question form | 11,244.4 µs |

Measured on the development host with Dart 3.12.2; timings are indicative.

## Security

Claude can read files, execute commands, and call external services according
to the selected permission mode and tool configuration. Validate working
directories, keep gateway secrets out of logs, and provide explicit ACP
permission/elicitation handlers for untrusted prompts. Stdio reserves stdout
for protocol frames; diagnostics go to stderr.

## Testing

```console
dart analyze --fatal-infos .
dart test
dart test --coverage=coverage
dart run coverage:format_coverage \
  --packages=.dart_tool/package_config.json \
  --report-on=lib --lcov --in=coverage --out=coverage/lcov.info
dart run tool/check_coverage.dart
```

## Contributing

See the repository
[contribution guide](https://github.com/Salakar/dart_acp/blob/main/CONTRIBUTING.md).

## License

Licensed under the
[Apache License 2.0](https://github.com/Salakar/dart_acp/blob/main/LICENSE).
