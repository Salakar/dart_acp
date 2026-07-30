import 'json.dart';

/// Base exception for failures produced by the SDK.
sealed class ClaudeAgentException implements Exception {
  /// Creates an SDK exception with an actionable [message].
  const ClaudeAgentException(this.message);

  /// Human-readable failure details.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a CLI transport cannot connect or is not ready.
final class CliConnectionException extends ClaudeAgentException {
  /// Creates a connection exception.
  const CliConnectionException(super.message);
}

/// Thrown when no supported Claude Code executable can be found.
final class CliNotFoundException extends ClaudeAgentException {
  /// Creates a not-found exception, optionally naming the requested [cliPath].
  CliNotFoundException({
    String message = 'Claude Code CLI was not found',
    this.cliPath,
  }) : super(cliPath == null ? message : '$message: $cliPath');

  /// Explicit path that failed discovery, when available.
  final String? cliPath;
}

/// Thrown when the CLI subprocess exits unsuccessfully.
final class CliProcessException extends ClaudeAgentException {
  /// Creates a process exception.
  CliProcessException(String message, {this.exitCode, this.stderr})
    : super(
        [
          message,
          if (exitCode != null) '(exit code: $exitCode)',
          if (stderr != null && stderr.isNotEmpty) '\nError output: $stderr',
        ].join(' '),
      );

  /// Subprocess exit code, if it was observed.
  final int? exitCode;

  /// Captured or summarized stderr details.
  final String? stderr;
}

/// Thrown when one complete CLI stdout line is invalid JSON.
final class CliJsonDecodeException extends ClaudeAgentException {
  /// Creates a JSON decoding exception.
  CliJsonDecodeException({required this.line, required this.cause})
    : super(
        'Failed to decode CLI JSON: '
        '${line.length <= 100 ? line : '${line.substring(0, 100)}…'}',
      );

  /// Offending line or an explanatory synthetic value for an oversized frame.
  final String line;

  /// Decoder failure that caused this exception.
  final Object cause;
}

/// Thrown when a known CLI message has invalid fields.
final class MessageParseException extends ClaudeAgentException {
  /// Creates a message parsing exception.
  const MessageParseException(super.message, {this.data, this.cause});

  /// Raw message that could not be decoded.
  final JsonMap? data;

  /// Lower-level validation failure.
  final Object? cause;
}

/// Thrown when a control request fails or times out.
final class ControlProtocolException extends ClaudeAgentException {
  /// Creates a control protocol exception.
  const ControlProtocolException(super.message);
}

/// Thrown when session data or options violate a session contract.
final class SessionException extends ClaudeAgentException {
  /// Creates a session exception.
  const SessionException(super.message);
}
