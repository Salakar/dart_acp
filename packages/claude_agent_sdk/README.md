<p align="center">
  <img src="assets/logo.png" alt="claude_agent_sdk logo" width="160" height="160">
</p>

<h1 align="center">claude_agent_sdk</h1>

<hr>

<p align="center">
  A typed Dart SDK for building agents on top of the Claude Code CLI.
</p>

## Overview

`claude_agent_sdk` launches an installed Claude Code CLI and exposes one-shot
queries, interactive sessions, typed stream messages, runtime permissions,
hooks, in-process MCP tools, and persistent session APIs.

The package does not bundle Claude Code or an API client. Install and
authenticate the `claude` CLI before running a live agent.

## Install

```console
dart pub add claude_agent_sdk
```

The package requires Dart 3.11 or newer and Claude Code 2.0 or newer.

## Quick Start

```dart
import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';

Future<void> main() async {
  await for (final message in query(
    'Explain the architecture of this repository.',
    options: ClaudeAgentOptions(
      workingDirectory: Directory.current.path,
      allowedTools: const ['Read', 'Glob', 'Grep'],
      permissionMode: PermissionMode.plan,
    ),
  )) {
    if (message case AssistantMessage(:final content)) {
      for (final block in content.whereType<TextBlock>()) {
        stdout.write(block.text);
      }
    }
  }
}
```

## Interactive client

```dart
final client = ClaudeAgentClient(
  options: ClaudeAgentOptions(
    systemPrompt: const SystemPrompt.claudeCode(
      append: 'Keep answers concise.',
    ),
  ),
);

await client.connect();
try {
  await client.send('Review the current implementation.');
  await for (final message in client.receiveResponse()) {
    // The stream includes the terminal ResultMessage.
  }

  await client.setPermissionMode(PermissionMode.acceptEdits);
  await client.send('Apply the fixes you found.');
  await client.receiveResponse().drain<void>();
} finally {
  await client.disconnect();
}
```

## Permissions, hooks, and SDK MCP

`canUseTool` receives interactive permission decisions over the control
channel. Hooks are typed by lifecycle event. `SdkMcpServer` exposes local Dart
functions as MCP tools without starting another process.

```dart
final options = ClaudeAgentOptions(
  canUseTool: (toolName, input, context) async {
    if (toolName == 'Bash') {
      return const PermissionDenied(message: 'Shell access is disabled.');
    }
    return PermissionAllowed();
  },
  hooks: {
    HookEvent.preToolUse: [
      HookMatcher(
        matcher: 'Write|Edit',
        hooks: [
          (input, toolUseId) async =>
              const HookOutput(systemMessage: 'Edit audited by Dart.'),
        ],
      ),
    ],
  },
  mcp: McpServers({
    'local': SdkMcpServer(
      name: 'local',
      tools: [
        SdkMcpTool(
          name: 'lookup',
          description: 'Looks up an application value.',
          inputSchema: {
            'type': 'object',
            'properties': <String, Object?>{},
          },
          handler: (input) async => McpToolResult(
            content: const [McpTextContent('value')],
          ),
        ),
      ],
    ),
  }),
);
```

## Session persistence

Local session helpers read the same JSONL transcripts as Claude Code:

```dart
final sessions = listSessions(directory: Directory.current.path);
final messages = getSessionMessages(
  sessions.first.sessionId,
  directory: Directory.current.path,
);
```

Use `SessionStore` to mirror transcripts into a database or object store.
`InMemorySessionStore` is the reference implementation. Store-backed resume
materializes a temporary Claude config tree, copies only the authentication
state needed by the subprocess, removes OAuth refresh tokens from copied
credentials, and cleans the tree after disconnect.

## Supported Features

| Area | Dart API |
| --- | --- |
| One-shot | `query`, `queryStream` |
| Interactive | `ClaudeAgentClient`, `UserInput` |
| Messages | `AssistantMessage`, `UserMessage`, `ResultMessage`, system/task/rate-limit events |
| Control | interrupt, permission/model switching, file rewind, task stop, MCP and context status |
| Extensibility | typed hooks, `canUseTool`, stdio/SSE/HTTP MCP config, `SdkMcpServer` |
| Sessions | local list/read/rename/tag/fork/delete and corresponding `SessionStore` APIs |

Unknown message types are skipped. Unknown content blocks are preserved as
`UnknownContentBlock`, keeping newer CLI output forward-compatible.

## Examples and verification

```console
dart run example/quick_start.dart
CLAUDE_AGENT_SDK_LIVE_TEST=1 dart run example/quick_start.dart
dart test
dart analyze .
dart pub publish --dry-run
```

See [example/README.md](example/README.md) and
[benchmark/README.md](benchmark/README.md).

## Security

Agents can read files, execute tools, and call external services according to
their configuration. Read [SECURITY.md](SECURITY.md) before enabling tools in
an application that processes untrusted input.

## Benchmarks

| Scenario | Runtime |
| --- | ---: |
| `ToolUseBlock` construction with nested immutable input | 4.57 µs |

Measured on the package's development host with Dart 3.12.0.

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md). Run formatting, analysis, tests,
the example smoke tool, and the benchmark smoke tool before opening a change.

## License

Licensed under the [Apache License 2.0](LICENSE).
