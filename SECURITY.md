# Security Policy

## Supported versions

Until the first stable release, security fixes are provided on the latest
published prerelease and the `main` branch.

## Reporting a vulnerability

Please do not disclose suspected vulnerabilities in a public issue. Use the
repository's private vulnerability-reporting form under **Security →
Advisories → Report a vulnerability**.

Include the affected version, a minimal reproduction, the expected security
boundary, and any known mitigations. Remove credentials, private prompts, and
other sensitive data from logs or protocol captures.

The maintainers will acknowledge a complete report within seven days and will
share status updates while a fix is being assessed. Release timing depends on
severity, exploitability, and coordinated-disclosure needs.

## Security scope

This package parses untrusted protocol messages and can expose filesystem,
terminal, process, and network capabilities through applications that embed
it. Integrators remain responsible for authentication, authorization,
transport security, origin policy, resource limits, and user-facing permission
decisions.
