# Changelog

## 0.1.1

- Bound Gemini subprocess shutdown and escalate to a hard kill when a
  Node-based launcher ignores graceful termination.
- Preserve the actionable ACP initialization error when process cleanup also
  fails.

## 0.1.0

- Add the managed `GeminiAcpClient` subprocess client.
- Add automatic support for stable and legacy Gemini ACP flags.
- Add Windows, macOS, and Linux executable discovery.
- Add configurable process environment, lifecycle timeouts, and bounded stderr
  capture.
