# Examples

- `quick_start.dart` demonstrates a typed one-shot query. It performs a
  deterministic configuration smoke by default; set
  `CLAUDE_AGENT_SDK_LIVE_TEST=1` to contact the authenticated Claude CLI.
- `session_store.dart` demonstrates the external transcript-store APIs without
  network access or a CLI subprocess.
- `subagents.dart` demonstrates programmatic agent definitions and nested
  transcript/progress options. It is deterministic unless the same live-test
  environment variable is set.

Run both deterministic paths with:

```console
dart run tool/smoke_example.dart
```
