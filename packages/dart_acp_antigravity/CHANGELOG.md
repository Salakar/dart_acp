# Changelog

## 0.1.0

- Add the in-process `AntigravityAcpAgent` adapter over headless Antigravity
  CLI print-mode runs with streamed message, thought, and tool-call updates.
- Add the connected `AntigravityAcpClient` and the stdio executable.
- Add conversation binding with `--conversation` resume, mismatch detection,
  and cancellation that keeps the conversation resumable.
- Add Windows, macOS, and Linux executable discovery.
- Add configurable model, named agent, reasoning effort, permission policy,
  additional directories, prompt timeout, and bounded stderr capture.
