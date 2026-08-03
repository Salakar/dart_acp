<p align="center">
  <img src="assets/logo.png" alt="dart_acp logo" width="160" height="160">
</p>

<h1 align="center">dart_acp</h1>

<hr>

## Overview

`dart_acp` is a collection of Dart packages for the
[Agent Client Protocol (ACP)](https://agentclientprotocol.com/). It includes
the typed protocol SDK and ready-to-use clients for OpenCode, Gemini CLI,
Claude Code, and Codex.

## Packages

### Ready-to-use clients

Every provider package exposes the same client shape: an asynchronous
`<Provider>AcpClient.start()` constructor, `connection` and `agent` accessors,
a `closed` future, idempotent `close()`, and a matching
`<Provider>AcpClientOptions` configuration type.

| Package                                            | Client entry point          | Backing implementation                                                |
| -------------------------------------------------- | --------------------------- | --------------------------------------------------------------------- |
| [`dart_acp_opencode`](packages/dart_acp_opencode/) | `OpenCodeAcpClient.start()` | Native `opencode acp` server with cross-platform executable discovery |
| [`dart_acp_gemini`](packages/dart_acp_gemini/)     | `GeminiAcpClient.start()`   | Native Gemini ACP server with automatic stable/legacy flag detection  |
| [`dart_acp_claude`](packages/dart_acp_claude/)     | `ClaudeAcpClient.start()`   | In-process ACP adapter over the typed Claude Agent SDK                |
| [`dart_acp_codex`](packages/dart_acp_codex/)       | `CodexAcpClient.start()`    | In-process ACP adapter over a managed Codex `app-server` runtime      |
| [`dart_acp_antigravity`](packages/dart_acp_antigravity/) | `AntigravityAcpClient.start()` | In-process ACP adapter over headless Antigravity CLI print-mode runs |

### Adapter building blocks

Claude, Codex, and Antigravity also expose their lower-level adapter APIs for
custom transports and service boundaries.

| Package                                        | Advanced APIs                                                                 |
| ---------------------------------------------- | ----------------------------------------------------------------------------- |
| [`dart_acp_claude`](packages/dart_acp_claude/) | `ClaudeAcpAgent`, reusable ACP application builder, and stdio executable      |
| [`dart_acp_codex`](packages/dart_acp_codex/)   | `CodexAgent`, `CodexRuntime`, injectable `CodexBackend`, and stdio executable |
| [`dart_acp_antigravity`](packages/dart_acp_antigravity/) | `AntigravityAcpAgent`, stream-json event types and mapper, and stdio executable |

### SDKs

| Package                                          | Role                                                                                                                                  |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| [`dart_acp_sdk`](packages/dart_acp_sdk/)         | Stable ACP v1 applications, protocol models, sessions, JSON-RPC, and transports, with explicit experimental v2 and remote entrypoints |
| [`claude_agent_sdk`](packages/claude_agent_sdk/) | Typed Dart SDK for building agents with the Claude Code CLI                                                                           |

## Getting started

Choose a provider package for the quickest path to an agent:

```console
dart pub add dart_acp_opencode
```

```dart
import 'dart:io';

import 'package:dart_acp_opencode/dart_acp_opencode.dart';

Future<void> main() async {
  final client = await OpenCodeAcpClient.start();
  try {
    final session = await client.agent
        .newSession(cwd: AcpAbsolutePath(Directory.current.path))
        .start();
    // Prompt through session.prompt(...), then consume the streamed result.
    session.dispose();
  } finally {
    await client.close();
  }
}
```

The equivalent entry points are `GeminiAcpClient.start()`,
`ClaudeAcpClient.start()`, `CodexAcpClient.start()`, and
`AntigravityAcpClient.start()`.

Use `dart_acp_sdk` directly when implementing an ACP client, agent, transport,
or remote protocol host. Its default library is the stable ACP v1 surface.
Draft v2, unstable protocol overlays, HTTP/SSE, WebSocket, and server APIs use
explicit experimental imports.

## SDK features

| Area         | Support                                                                                           |
| ------------ | ------------------------------------------------------------------------------------------------- |
| Protocol     | Stable ACP v1 by default; draft v2 and unstable overlays through explicit experimental imports    |
| Applications | Typed client and agent builders, sessions, streaming updates, cancellation, and capability checks |
| JSON-RPC     | Bidirectional requests, notifications, batches, correlation, cancellation, and bounded queues     |
| Transports   | In-process, NDJSON, conditional stdio, HTTP/SSE, and WebSocket                                    |
| Platforms    | Native Dart and browser-safe public libraries through conditional implementations                 |
| Models       | Schema-generated typed values and method descriptors with deterministic regeneration              |

The smallest complete SDK example builds an in-memory client and agent,
negotiates ACP v1, opens a session, streams an agent message, and closes both
ends:

```console
dart run packages/dart_acp_sdk/example/quick_start.dart
```

Output:

```text
Hello from Dart ACP.
```

See the [package README](packages/dart_acp_sdk/README.md) for the complete
walkthrough, supported method matrix, version boundaries, and transport
guidance.

## Workspace

This repository is a Melos workspace:

```text
packages/
├── claude_agent_sdk/
├── dart_acp_antigravity/
├── dart_acp_claude/
├── dart_acp_codex/
├── dart_acp_gemini/
├── dart_acp_opencode/
└── dart_acp_sdk/
```

Common workspace verification commands:

```console
dart run melos bootstrap
dart run melos run format
dart run melos run analyze
dart run melos run test
dart run melos run publish:dry-run
```

The core SDK additionally has deterministic schema, browser, coverage, example,
and benchmark gates. See its [package README](packages/dart_acp_sdk/README.md)
and [contribution guide](CONTRIBUTING.md) for the complete command set.

SDK code generation uses the schema snapshots committed under
`packages/dart_acp_sdk/tool/schema/snapshots/`. Refreshing those snapshots is
an explicit operation:

```console
dart run melos run schema:sync
```

## More

- [SDK examples](packages/dart_acp_sdk/example/README.md)
- [SDK benchmarks](packages/dart_acp_sdk/benchmark/README.md)
- [Security guidance](SECURITY.md)
- [Contributing](CONTRIBUTING.md)
- [SDK changelog](packages/dart_acp_sdk/CHANGELOG.md)

## SDK benchmarks

Measured on 2026-07-29 with Dart 3.12.2 on arm64 macOS:

| Result                |        p50 |        p95 |
| --------------------- | ---------: | ---------: |
| In-process end-to-end |   1,895 µs |   2,835 µs |
| HTTP/SSE end-to-end   |   5,128 µs |   8,164 µs |
| WebSocket end-to-end  |   2,809 µs |   3,550 µs |
| stdio end-to-end      | 568,016 µs | 600,019 µs |

Licensed under the [Apache License 2.0](LICENSE).
