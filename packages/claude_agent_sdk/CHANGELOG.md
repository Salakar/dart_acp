# Changelog

## 0.1.0

- Initial release with one-shot and stateful agent sessions.
- Added typed messages, permissions, hooks, MCP tools, and CLI controls.
- Added local and external-store session management.
- Added typed initialization, runtime discovery, feature controls, and
  raw-preserving message envelopes.
- Added typed elicitation and user-dialog callbacks with cancellation.
- Added CLI resolution, execution, logout, and tiered settings resolution
  with managed-environment and project-trust filtering.
- Added optional UUID and priority fields to streamed user input for turn
  correlation and immediate steering.
- Added complete programmatic subagent configuration, main-thread agent
  selection, nested transcript forwarding, progress summaries, and an
  executable subagent example.
- Added current live controls for reinitialization, MCP permission overrides
  and replacement, permission-gated file reads, typed rewind results,
  read-state seeding, usage, plugin/skill reload, and task backgrounding.
- Added current hook names, richer permission metadata, current runtime
  message variants, and raw preservation for unknown top-level messages.
- Added pre-warmed one-shot queries, current result timing and initialization
  metadata, replay attachments, and complete published system-event decoding.
- Added raw settings-cascade provenance with separate project trust filtering,
  system-message history reads, and nested parent-agent ancestry.
- Added the complete published model capability surface, including adaptive
  thinking discovery, and aligned hook callbacks with their cancellation
  signal.
- Added defensive typed decoding for the runtime's per-tool
  `tool_result_meta` non-execution classifications and user feedback.
- Audited the runtime API against the official npm 0.3.220 declarations,
  including all current hook input/output families, settings-backed model and
  effort selection, initialization metadata, controls, and message variants.
