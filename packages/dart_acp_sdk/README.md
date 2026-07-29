<p align="center">
  <img src="assets/logo.png" alt="dart_acp_sdk logo" width="160" height="160">
</p>

<h1 align="center">dart_acp_sdk</h1>

<hr>

## Overview

`dart_acp_sdk` implements the
[Agent Client Protocol (ACP)](https://agentclientprotocol.com/) for Dart. Use
it to build ACP clients and agents with typed protocol values, immutable
application builders, bidirectional JSON-RPC, session workflows, cancellation,
and bounded Dart streams.

The default library contains stable ACP v1. Draft v2, unstable method overlays,
HTTP/SSE, WebSocket, and server APIs are isolated behind explicit experimental
imports.

## Install

```console
dart pub add dart_acp_sdk
```

The package requires Dart 3.11 or newer.

## Quick start

This is the same code exercised by
[`example/quick_start.dart`](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/quick_start.dart)
and its automated test:

```dart
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

Future<void> main() async {
  final sessionId = SessionId('quick-start');
  final agent =
      AcpAgentApp.v1(
            implementation: Implementation(
              name: 'example-agent',
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
          .onNewSession(
            (_) => NewSessionResponse(sessionId: sessionId),
          )
          .onPrompt((context) async {
            await context.client.updateSession(
              SessionNotification(
                sessionId: context.params.sessionId,
                update: SessionUpdateAgentMessageChunk(
                  ContentChunk(
                    content: ContentBlockText(
                      TextContent(text: 'Hello from Dart ACP.'),
                    ),
                  ),
                ),
              ),
            );
            return PromptResponse(stopReason: StopReason.endTurn);
          });

  final client = AcpClientApp.v1(
    implementation: Implementation(
      name: 'example-client',
      version: '1.0.0',
    ),
    capabilities: ClientCapabilities(
      fs: FileSystemCapabilities(
        readTextFile: false,
        writeTextFile: false,
      ),
      terminal: false,
    ),
  );

  final pair = await client.connectWith(agent);
  try {
    final session = await pair.client.agent
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start();
    final turn = await session
        .prompt(
          content: <ContentBlock>[
            ContentBlockText(TextContent(text: 'Say hello')),
          ],
        )
        .collectText();
    print(turn.text);
  } finally {
    await pair.close();
  }
}
```

`connectWith` uses two bounded in-process streams. The same applications can
connect to stdio, HTTP/SSE, or WebSocket transports without changing their
typed handlers.

## Supported Features

`package:dart_acp_sdk/dart_acp_sdk.dart` exports stable v1 protocol models,
method descriptors, applications, JSON-RPC, and local transports. Generated
descriptors preserve each method's parameter/result pairing, direction,
message kind, stability, and capability requirement.

| Method | Sender | Kind | Local preflight requirement |
| --- | --- | --- | --- |
| `$/cancel_request` | either peer | notification | — |
| `authenticate` | client → agent | request | matching advertised `authMethods` entry |
| `elicitation/complete` | agent → client | notification | `clientCapabilities.elicitation.url` |
| `elicitation/create` | agent → client | request | matching `clientCapabilities.elicitation.form` or `.url` mode |
| `fs/read_text_file` | agent → client | request | `clientCapabilities.fs.readTextFile` |
| `fs/write_text_file` | agent → client | request | `clientCapabilities.fs.writeTextFile` |
| `initialize` | client → agent | request | — |
| `logout` | client → agent | request | `agentCapabilities.auth.logout` |
| `session/cancel` | client → agent | notification | — |
| `session/close` | client → agent | request | `agentCapabilities.sessionCapabilities.close` |
| `session/delete` | client → agent | request | `agentCapabilities.sessionCapabilities.delete` |
| `session/list` | client → agent | request | `agentCapabilities.sessionCapabilities.list` |
| `session/load` | client → agent | request | `agentCapabilities.loadSession` |
| `session/new` | client → agent | request | — |
| `session/prompt` | client → agent | request | — |
| `session/request_permission` | agent → client | request | — (baseline method) |
| `session/resume` | client → agent | request | `agentCapabilities.sessionCapabilities.resume` |
| `session/set_config_option` | client → agent | request | matching configuration ID advertised for the session |
| `session/set_mode` | client → agent | request | matching mode ID advertised for the session |
| `session/update` | agent → client | notification | — |
| `terminal/create` | agent → client | request | `clientCapabilities.terminal` |
| `terminal/kill` | agent → client | request | `clientCapabilities.terminal` |
| `terminal/output` | agent → client | request | `clientCapabilities.terminal` |
| `terminal/release` | agent → client | request | `clientCapabilities.terminal` |
| `terminal/wait_for_exit` | agent → client | request | `clientCapabilities.terminal` |

Application helpers perform local capability and advertised-inventory checks
before a request is sent. A dash denotes a baseline method without a negotiated
capability gate.
Unknown open-union variants and permitted metadata remain available as typed
ACP JSON values, so a newer peer can be decoded without silently rewriting its
wire data.

Every generated model provides `fromJson` and `toJson`; schema cases that
permit recovery also provide a `decode` result with structured issues.
`json_serializable` is used for closed, schema-validated model shapes, while
handwritten codecs cover open unions, resilient defaults, and recursive JSON.

## Version and library boundaries

Import only the surfaces your application intends to support:

| Library | Surface | Stability |
| --- | --- | --- |
| `dart_acp_sdk.dart` | ACP v1, JSON-RPC, in-process, NDJSON, conditional stdio | stable |
| `experimental/v1_unstable.dart` | v1 unstable models and method registry | experimental, explicit gate |
| `experimental/v2.dart` | draft-v2 models and applications | experimental |
| `experimental/v2_unstable.dart` | draft-v2 unstable overlay | experimental, explicit gate |
| `experimental/protocol_router.dart` | per-connection v1/v2 negotiation | experimental |
| `experimental/http.dart` | HTTP/SSE client | experimental |
| `experimental/web_socket.dart` | WebSocket client | experimental |
| `experimental/server.dart` | HTTP/SSE and WebSocket servers and routing | experimental |

Stable v1 signatures never accept or return draft-v2 values. The protocol
router chooses an application during initialization; it does not transcode
subsequent messages between versions. Unstable descriptors also require an
application feature gate, preventing an accidental import from enabling them.

## Transports

| Transport | Native Dart | Browser | Notes |
| --- | ---: | ---: | --- |
| In-process | yes | yes | bounded pair for embedding and tests |
| NDJSON stream | yes | yes | incremental UTF-8 line framing |
| stdio | yes | compile-safe stub | intended for editor-launched agents |
| HTTP/SSE client | yes | yes | POST requests plus server-sent responses |
| WebSocket client | yes | yes | text-frame JSON-RPC |
| HTTP/SSE server | yes | no | loopback binding by default |
| WebSocket server | yes | no | origin-policy hook and bounded routing |

Remote transports expose wire streams. Wrap one with `acpApplicationStream`
before passing it to `AcpAgentApp.connect` or `AcpClientApp.connect`. Complete
HTTP/SSE and WebSocket usage is in the
[examples](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/README.md).

All public libraries are compiled for the web during verification. Native-only
implementations are selected through conditional imports, so importing a
stable or experimental entrypoint does not leak `dart:io` into browser builds.

## Resource limits and diagnostics

`AcpApplicationOptions.jsonRpcOptions` controls pending requests, concurrent
handlers, batches, queue sizes, and diagnostics. Transport and server options
add byte, frame, connection, session, replay, and slow-consumer limits. Keep
limits finite when peers are not fully trusted.

The remote server libraries provide routing primitives, not identity or
privilege policy. Hosts remain responsible for TLS, authentication,
authorization, origin/CORS policy, rate limiting, quotas, and auditing. Read
the
[security guidance](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/SECURITY.md)
before exposing a listener or registering
filesystem, terminal, process, or URL handlers.

## Examples

The examples are executable and included in the smoke suite:

- [`quick_start.dart`](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/quick_start.dart):
  smallest in-process v1 flow.
- [`main.dart`](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/main.dart):
  sessions, streamed updates, permissions,
  cancellation, failure, usage, and close.
- [`stdio_agent.dart`](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/stdio_agent.dart)
  and
  [`stdio_client.dart`](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/stdio_client.dart):
  a child agent over NDJSON
  stdio.
- [`http_server.dart`](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/http_server.dart),
  [`http_client.dart`](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/http_client.dart),
  and
  [`web_socket_client.dart`](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/web_socket_client.dart):
  loopback-safe
  remote flows.
- [`dual_version_agent.dart`](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/example/dual_version_agent.dart):
  one listener
  negotiating stable v1 or draft v2.

Run all of them with:

```console
dart run tool/smoke_examples.dart
```

## Generation and verification

Protocol source is generated deterministically from pinned schema snapshots.
The generator emits separate v1/v2 baseline and unstable lanes, typed model
codecs, method descriptors, and conformance cases. Normal development does not
require network access.

From the workspace root:

```console
dart run melos run codegen
dart run melos run schema:check
dart run melos run spec:check
dart run melos run reference:check
dart run melos run analyze
dart run melos run test
dart run melos run test:web
dart run melos run verify:web-compile
dart run melos run examples:smoke
dart run melos run benchmarks:smoke
dart run melos run publish:dry-run
```

## Benchmarks

Measured on 2026-07-29 with Dart 3.12.2 on arm64 macOS:

| Result | p50 | p95 |
| --- | ---: | ---: |
| In-process end-to-end | 1,895 µs | 2,835 µs |
| HTTP/SSE end-to-end | 5,128 µs | 8,164 µs |
| WebSocket end-to-end | 2,809 µs | 3,550 µs |
| stdio end-to-end | 568,016 µs | 600,019 µs |

## Contributing and license

See the
[repository contribution guide](https://github.com/salakar/dart_acp_sdk/blob/main/CONTRIBUTING.md).
Release history is recorded in the
[changelog](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/CHANGELOG.md).

Licensed under the
[Apache License 2.0](https://github.com/salakar/dart_acp_sdk/blob/main/packages/dart_acp_sdk/LICENSE).
