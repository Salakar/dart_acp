# dart_acp_antigravity

`dart_acp_antigravity` exposes the Antigravity CLI (`agy`) as a typed
Agent Client Protocol agent. The CLI has no native ACP server, so the adapter
maps each ACP session onto a headless Antigravity conversation: prompts run
`agy --print --output-format stream-json`, stream-json events become ACP
session updates, and later prompts resume the same conversation with
`--conversation`.

## Install

```console
dart pub add dart_acp_antigravity
```

Install and authenticate the
[Antigravity CLI](https://antigravity.google/docs/cli/reference) separately.
Headless runs reuse credentials cached by an interactive `agy` session.

## Quick start

```dart
import 'dart:io';

import 'package:dart_acp_antigravity/dart_acp_antigravity.dart';

Future<void> main() async {
  final client = await AntigravityAcpClient.start();
  try {
    final session = await client.agent
        .newSession(cwd: AcpAbsolutePath(Directory.current.path))
        .start();
    final result = await session
        .prompt(
          content: <ContentBlock>[
            ContentBlockText(TextContent(text: 'Summarize this project.')),
          ],
        )
        .collectText();
    print(result.text);
    session.dispose();
  } finally {
    await client.close();
  }
}
```

## Run over stdio

```sh
dart run dart_acp_antigravity
```

With no arguments, stdin and stdout are reserved for ACP NDJSON. `--version`
and `--help` print and exit. The executable reads its configuration from
environment variables:

| Environment variable | Meaning |
| --- | --- |
| `ANTIGRAVITY_EXECUTABLE` | Executable path or command; defaults to `agy` |
| `ANTIGRAVITY_ACP_MODEL` | Model forwarded with `--model` |
| `ANTIGRAVITY_ACP_AGENT` | Named agent forwarded with `--agent` |
| `ANTIGRAVITY_ACP_EFFORT` | `low`, `medium`, or `high` |
| `ANTIGRAVITY_ACP_PERMISSION_POLICY` | `request-review`, `accept-edits`, `plan`, or `bypass-permissions` |
| `ANTIGRAVITY_ACP_PROMPT_TIMEOUT_MS` | Positive `--print-timeout` override |
| `ANTIGRAVITY_ACP_SHUTDOWN_TIMEOUT_MS` | Positive termination grace period |
| `ANTIGRAVITY_ACP_MAX_STDERR_CHARS` | Positive retained stderr tail |

## Configuration

Pass `AntigravityAcpOptions` to select an executable, model, named agent,
reasoning effort, permission policy, additional workspace directories, prompt
timeout, shutdown grace period, and stderr observer. Discovery checks
`ANTIGRAVITY_EXECUTABLE`, `PATH`, the official installer location
(`~/.local/bin`), and common package-manager locations on Windows, macOS, and
Linux.

Applications that need their own ACP transport can create an
`AntigravityAcpAgent` and connect `agent.app` directly.

## Sessions and cancellation

Each ACP session binds to one Antigravity conversation on its first prompt.
Conversation state lives in the CLI's own state directory, so a session's
history survives adapter restarts. `session/cancel` stops the running CLI
process and reports a `cancelled` stop reason; the conversation stays
resumable. If the CLI cannot resume a bound conversation and silently starts
a fresh one, the prompt fails instead of continuing without history.

## Permissions

Print mode cannot prompt for tool approvals, so the adapter never sends
`session/request_permission`. The CLI denies unapproved tool use on its own.
Choose an `AntigravityPermissionPolicy` (`request-review` by default,
`accept-edits`, `plan`, or `bypass-permissions`), or configure allow-rules in
the CLI's `settings.json`.

MCP servers passed through `session/new` are not forwarded; configure MCP for
Antigravity through its own `mcp_config.json` files instead.

This is an independent community package and is not an official Google
product.
