# Security

## Reporting a vulnerability

Do not open a public issue for a vulnerability. Use the private security
reporting channel of the repository that distributes this package and include
the affected version, impact, and a minimal reproduction.

## Agent permissions

Claude Code tools can read files, edit files, execute commands, and access
external services. Use an explicit `PermissionMode`, keep `allowedTools`
narrow, and use `canUseTool` when a human or application policy must approve
individual calls. Treat prompts, tool inputs, MCP responses, hook data, and
transcript content as untrusted.

`PermissionMode.bypassPermissions` is appropriate only inside an isolation
boundary whose contents and credentials can be discarded.

## Process execution

The SDK starts the Claude Code executable directly with an argument vector; it
does not invoke a shell. On Windows it rejects `.cmd` and `.bat` wrappers
because `cmd.exe` can reinterpret argument metacharacters. Prefer the native
`claude.exe` or provide an explicit trusted executable path.

Environment overrides are passed to the child process. Never copy secrets from
an untrusted request into `ClaudeAgentOptions.environment`.

## Session stores and credentials

`SessionStore` implementations receive transcript content, including prompts,
tool inputs, and model responses. Encrypt sensitive storage, enforce tenant
separation in `projectKey`, and apply retention controls.

When a stored session is resumed, the SDK creates a temporary Claude config
tree. Copied OAuth credentials have `refreshToken` removed so the subprocess
cannot consume and strand the parent's single-use refresh token. The temporary
tree is deleted after subprocess shutdown. Applications should still protect
the operating-system temporary directory and avoid abrupt process termination
during materialization.

Store-supplied nested transcript paths are validated against absolute paths,
drive prefixes, null bytes, and traversal components before being written.

## MCP and hooks

SDK MCP handlers and hooks execute application code in the Dart process. Bound
their latency, validate JSON inputs, avoid returning secrets, and ensure thrown
errors are safe to expose to the model. External MCP server configuration
should use TLS and trusted endpoints.
