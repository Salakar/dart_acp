<p align="center">
  <img src="assets/logo.png" alt="dart_acp_sdk logo" width="160" height="160">
</p>

<h1 align="center">dart_acp_sdk</h1>

<hr>

## Overview

`dart_acp_sdk` is a Dart implementation of the
[Agent Client Protocol (ACP)](https://agentclientprotocol.com/). It lets Dart
applications act as ACP clients, agents, or remote protocol hosts. It combines
schema-generated protocol values with typed
application builders, correlated JSON-RPC, session workflows, cancellation,
bounded transports, and browser-safe conditional libraries.

The default library is the stable ACP v1 surface. Draft v2, unstable protocol
overlays, HTTP/SSE, WebSocket, and server APIs require explicit experimental
imports.

## Supported Features

| Area | Support |
| --- | --- |
| Protocol | Stable ACP v1 by default; draft v2 and unstable overlays through explicit experimental imports |
| Applications | Typed client and agent builders, sessions, streaming updates, cancellation, and capability checks |
| JSON-RPC | Bidirectional requests, notifications, batches, correlation, cancellation, and bounded queues |
| Transports | In-process, NDJSON, conditional stdio, HTTP/SSE, and WebSocket |
| Platforms | Native Dart and browser-safe public libraries through conditional implementations |
| Models | Schema-generated typed values and method descriptors with deterministic regeneration |

## Install

```console
dart pub add dart_acp_sdk
```

## Quick Start

The smallest complete example builds an in-memory client and agent, negotiates
ACP v1, opens a session, streams an agent message, and closes both ends:

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

This repository is a one-package Melos workspace:

```text
packages/
└── dart_acp_sdk/
```

Common verification commands:

```console
dart run melos bootstrap
dart run melos run codegen
dart run melos run spec:check
dart run melos run reference:check
dart run melos run analyze
dart run melos run test
dart run melos run test:web
dart run melos run examples:smoke
dart run melos run benchmarks:smoke
dart run melos run verify:web-compile
dart run melos run publish:dry-run
```

Code generation is deterministic and uses the schema snapshots committed under
the package's `tool/schema/snapshots/` directory. Refreshing those snapshots is
an explicit operation:

```console
dart run melos run schema:sync
```

## More

- [Examples](packages/dart_acp_sdk/example/README.md)
- [Benchmarks](packages/dart_acp_sdk/benchmark/README.md)
- [Security guidance](packages/dart_acp_sdk/SECURITY.md)
- [Contributing](CONTRIBUTING.md)
- [Changelog](packages/dart_acp_sdk/CHANGELOG.md)

## Benchmarks

Measured on 2026-07-29 with Dart 3.12.2 on arm64 macOS:

| Result | p50 | p95 |
| --- | ---: | ---: |
| In-process end-to-end | 1,895 µs | 2,835 µs |
| HTTP/SSE end-to-end | 5,128 µs | 8,164 µs |
| WebSocket end-to-end | 2,809 µs | 3,550 µs |
| stdio end-to-end | 568,016 µs | 600,019 µs |

Licensed under the [Apache License 2.0](LICENSE).
