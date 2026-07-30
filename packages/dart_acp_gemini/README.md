# dart_acp_gemini

`dart_acp_gemini` finds the local Gemini CLI, starts its built-in ACP server,
and returns an initialized, typed `dart_acp_sdk` client connection.

## Install

```console
dart pub add dart_acp_gemini
```

Install and authenticate the
[Gemini CLI](https://geminicli.com/docs/get-started/installation/) separately.

## Quick start

```dart
import 'dart:io';

import 'package:dart_acp_gemini/dart_acp_gemini.dart';

Future<void> main() async {
  final client = await GeminiAcpClient.start();
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

Pass `GeminiAcpClientOptions` to select an executable, working directory,
environment, lifecycle timeouts, and stderr observer. Discovery checks
`GEMINI_EXECUTABLE`, `PATH`, and common npm and package-manager locations on
Windows, macOS, and Linux.

The client automatically detects whether the installed Gemini CLI expects the
current `--acp` flag or the earlier `--experimental-acp` spelling.

Pass your own `AcpClientApp` to `GeminiAcpClient.start` when the client should
handle permission, file-system, terminal, or elicitation requests. The default
client deliberately advertises none of those proxy capabilities and declines
permission requests.

This is an independent community package and is not an official Google
product.

## Testing

Unit tests use deterministic fake processes. To also verify the installed CLI:

```console
DART_ACP_LIVE_TESTS=true dart test test/live_integration_test.dart
```

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md).

## License

Licensed under the [Apache License 2.0](LICENSE).
