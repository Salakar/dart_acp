/// Severity of an adapter diagnostic.
enum CodexDiagnosticLevel {
  /// Recoverable or noteworthy behavior.
  warning,

  /// An operation or transport failed.
  error,
}

/// Stable category for an adapter diagnostic.
enum CodexDiagnosticCategory {
  /// Configuration was invalid or incomplete.
  configuration,

  /// Protocol input was malformed or unsupported.
  protocol,

  /// A child process could not start or exited.
  process,

  /// A lifecycle operation failed.
  lifecycle,
}

/// A payload-safe diagnostic.
final class CodexDiagnostic {
  /// Creates a diagnostic.
  const CodexDiagnostic({
    required this.level,
    required this.category,
    required this.message,
    this.exitCode,
  });

  /// Severity.
  final CodexDiagnosticLevel level;

  /// Stable category.
  final CodexDiagnosticCategory category;

  /// Concise redacted message.
  final String message;

  /// Child exit code, when relevant.
  final int? exitCode;
}

/// Base exception thrown by the adapter.
sealed class CodexAdapterException implements Exception {
  /// Creates an adapter exception.
  const CodexAdapterException(this.message);

  /// Concise payload-safe description.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Invalid adapter configuration.
final class CodexConfigurationException extends CodexAdapterException {
  /// Creates a configuration exception.
  const CodexConfigurationException(super.message);
}

/// Invalid or unsupported protocol input.
final class CodexProtocolException extends CodexAdapterException {
  /// Creates a protocol exception.
  const CodexProtocolException(super.message);
}

/// Child process startup or exit failure.
final class CodexProcessException extends CodexAdapterException {
  /// Creates a process exception.
  const CodexProcessException(super.message, {this.exitCode});

  /// Child exit code, when known.
  final int? exitCode;
}

/// Authentication is missing or failed.
final class CodexAuthenticationException extends CodexAdapterException {
  /// Creates an authentication exception.
  const CodexAuthenticationException(super.message);
}

/// A requested session does not exist or is no longer available.
final class CodexSessionException extends CodexAdapterException {
  /// Creates a session exception.
  const CodexSessionException(super.message);
}

/// A capability cannot be represented safely.
final class CodexUnsupportedFeatureException extends CodexAdapterException {
  /// Creates an unsupported-feature exception.
  const CodexUnsupportedFeatureException(super.message);
}
