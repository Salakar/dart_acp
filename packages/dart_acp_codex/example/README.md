# Deterministic embedding example

Run:

```sh
dart run example/main.dart
```

The example connects a typed ACP client to `CodexAgent` over the SDK's bounded
in-process transport. Its fake backend demonstrates session creation, model
configuration, a streamed response, a tool permission request, turn
completion, and orderly shutdown without credentials or a local Codex binary.
