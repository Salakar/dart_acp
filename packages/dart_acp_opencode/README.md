# dart_acp_opencode

`dart_acp_opencode` finds the local OpenCode CLI, starts its built-in ACP
server, and returns an initialized, typed `dart_acp_sdk` client connection.

## Install

```console
dart pub add dart_acp_opencode
```

Install and authenticate the
[OpenCode CLI](https://opencode.ai/docs/) separately.

## Quick start

```dart
import 'dart:io';

import 'package:dart_acp_opencode/dart_acp_opencode.dart';

Future<void> main() async {
  final client = await OpenCodeAcpClient.start();
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

## Configuration

Pass `OpenCodeAcpClientOptions` to select an executable, working directory,
environment, initialization timeout, shutdown timeout, and stderr observer.
Discovery checks `OPENCODE_EXECUTABLE`, `PATH`, official install locations,
and common package-manager locations on Windows, macOS, and Linux.

Pass your own `AcpClientApp` to `OpenCodeAcpClient.start` when the client should
handle permission, file-system, terminal, or elicitation requests. The default
client deliberately advertises none of those proxy capabilities and declines
permission requests.

OpenCode is launched as `opencode acp`, using its native JSON-RPC-over-stdio
ACP server.

This is an independent community package and is not built by or affiliated
with the OpenCode team.

## Testing

Unit tests use deterministic fake processes. To also verify the installed CLI:

```console
DART_ACP_LIVE_TESTS=true dart test test/live_integration_test.dart
```

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md).

## License

Licensed under the [Apache License 2.0](LICENSE).
