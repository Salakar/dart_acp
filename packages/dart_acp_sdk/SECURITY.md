# Security

`dart_acp_sdk` implements protocol parsing, routing, and transport mechanics.
It is not an authentication system, a sandbox, or an authorization policy.
Applications embedding the SDK decide which peers and operations to trust.

## Treat every peer as untrusted

ACP messages, JSON-RPC IDs, metadata, paths, terminal output, tool content,
elicitation values, HTTP headers, SSE events, and WebSocket frames can all be
attacker-controlled. Keep the SDK's size, depth, pending-request, session,
batch, and queue limits enabled. Configure lower limits when the host has a
smaller resource budget, and apply request deadlines, rate limits, connection
quotas, and process-level memory limits at the hosting boundary.

Connection and session IDs only select routing state. Possession of either ID
must never grant access. Authenticate the peer separately and authorize every
connection and session operation against that identity.

## Remote transports

- Native server adapters bind to loopback by default. Do not bind an
  unauthenticated server to a non-loopback address.
- Use TLS (`https`/`wss`) or a trusted local tunnel for traffic crossing a
  machine boundary.
- Enforce authentication, authorization, CORS, WebSocket `Origin` policy,
  rate limits, timeouts, quotas, and audit logging in the host application or
  reverse proxy.
- Browser cookie behavior is controlled by the browser. The SDK's affinity
  cookie store is for routing affinity only and is not a general credential
  jar.
- Validate forwarded host/origin information at the trusted proxy boundary.
  Never construct security decisions from an untrusted `Host`,
  `X-Forwarded-*`, connection ID, or session ID.
- Keep HTTP bodies and WebSocket frames bounded while streaming, not only
  after buffering. Close slow or overflowing consumers according to local
  policy.

The experimental server APIs expose policy callbacks so denial can happen
before protocol dispatch. A thrown policy callback fails closed and its
original message is not returned to the remote peer.

## Filesystem and terminal handlers

Filesystem, terminal, process, and executable handlers are privileged host
operations. Register them only after installing an explicit policy.

- Require nonempty absolute paths.
- Resolve canonical paths and symlinks before containment checks.
- Compare against an allowlist of approved roots and fail closed on resolution
  errors.
- Treat additional workspace directories as a complete replacement authority
  list on each lifecycle call. They do not change the process working
  directory.
- Apply separate read, write, execute, environment, network, and process
  policies; permission to read a directory does not imply permission to
  execute from it.
- Bound captured output and process lifetime, and clean up child processes
  when a session or connection closes.

ACP permission requests are user-experience messages, not a security boundary.
An unknown or future permission outcome must not be interpreted as approval.

## Sessions, authentication, and elicitation

- Authorize session creation, load, resume, fork, delete, and close
  independently. In particular, loading a known session ID is not proof that
  the requester may read it.
- Keep authentication secrets, cookies, environment values, prompts, and tool
  output out of logs. Use redacted diagnostics in production.
- Never pass draft terminal-authentication metadata to ordinary login
  handlers. Terminal authentication is an explicit unstable flow and should
  run in a separate, tightly controlled invocation.
- URL elicitation requires explicit user consent. Display the complete URL and
  destination domain, reject unsupported schemes, and do not automatically
  open a URL supplied by an untrusted agent.
- Validate elicitation form values again at the application boundary before
  using them in privileged operations.

## Reporting a vulnerability

Do not include credentials, private prompts, or sensitive protocol captures in
a public issue. Use the repository's private vulnerability-reporting form
under **Security → Advisories → Report a vulnerability** and include the
affected version, a minimal redacted reproduction, expected boundary, and
known mitigations.
