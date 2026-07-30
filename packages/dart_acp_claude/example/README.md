# Deterministic embedding example

Run:

```sh
dart run example/main.dart
```

The example connects a typed ACP client to `ClaudeAcpAgent` over the bounded
in-process transport. Its scripted Claude transport demonstrates session
creation, discovered configuration, text and thought updates, a tool permission
request, steering into an active turn, usage, and orderly shutdown without
credentials or an installed executable.
