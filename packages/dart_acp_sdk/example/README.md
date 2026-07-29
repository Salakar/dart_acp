# Examples

Every executable here runs in the package smoke suite.

| Example                                              | Demonstrates                                                                                                    |
| ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| [`quick_start.dart`](quick_start.dart)               | Minimal stable-v1 agent/client conversation over bounded in-process streams                                     |
| [`main.dart`](main.dart)                             | Initialization, sessions, plans, tool calls, permissions, streamed text, usage, cancellation, errors, and close |
| [`stdio_agent.dart`](stdio_agent.dart)               | ACP agent served over NDJSON stdio                                                                              |
| [`stdio_client.dart`](stdio_client.dart)             | Launching and driving the stdio agent as a child process                                                        |
| [`http_server.dart`](http_server.dart)               | One loopback-safe HTTP/SSE and WebSocket server                                                                 |
| [`http_client.dart`](http_client.dart)               | Stable-v1 client conversation over HTTP/SSE                                                                     |
| [`web_socket_client.dart`](web_socket_client.dart)   | Stable-v1 client conversation over WebSocket                                                                    |
| [`dual_version_agent.dart`](dual_version_agent.dart) | Per-connection negotiation between stable v1 and draft v2                                                       |

Start with:

```console
dart run example/quick_start.dart
dart run example/main.dart
```

Run the stdio pair:

```console
dart run example/stdio_client.dart
```

Run the remote examples in separate terminals:

```console
dart run example/http_server.dart
dart run example/http_client.dart
dart run example/web_socket_client.dart
```

The server binds to loopback by default. A non-loopback bind requires the
explicit development override, but that flag does not add TLS,
authentication, authorization, CORS/origin policy, or rate limiting.
Production deployments must supply those controls at the host or trusted
proxy boundary.

To exercise all examples deterministically:

```console
dart run tool/smoke_examples.dart
```
