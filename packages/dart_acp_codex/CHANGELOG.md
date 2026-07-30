# Changelog

## 0.1.2

- Implement the shared ACP goal-control extension, including objective updates,
  pause, resume, and clear, and publish goal snapshots when sessions open or
  change.

## 0.1.1

- Fixed Codex app-server thread creation to classify sessions with
  `threadSource` instead of sending the invalid `sessionStartSource` variant.

## 0.1.0

- Added the typed `CodexAcpClient`, `CodexAgent`, `CodexRuntime`, and
  injectable `CodexBackend` APIs.
- Added stdio executable, version output, login passthrough, and Codex CLI
  passthrough.
- Added API-key, ChatGPT, and custom-gateway authentication with secret-safe
  provider discovery and configuration.
- Added session lifecycle, model/reasoning/mode configuration, prompt
  streaming, cancellation, steering, goals, and slash commands.
- Added typed event, tool, history, approval, MCP, and elicitation bridges.
- Added bounded app-server JSON-RPC/process transport, deterministic example,
  regression tests, and representative benchmarks.
