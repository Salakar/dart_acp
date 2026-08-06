import 'dart:collection';

/// Version reported by the default Antigravity adapter application.
const String dartAcpAntigravityVersion = '0.1.0';

/// Receives one decoded chunk from an Antigravity process's stderr stream.
typedef AntigravityStderrHandler = void Function(String chunk);

/// Tool-permission behavior of headless Antigravity runs.
///
/// Print mode cannot prompt interactively, so ACP permission requests are not
/// bridged per call. Tools outside the selected policy and the CLI's
/// `settings.json` allow-rules are denied by the CLI itself.
enum AntigravityPermissionPolicy {
  /// Default CLI behavior: unapproved tool use is denied by the CLI.
  requestReview,

  /// Launches with `--mode accept-edits`, pre-approving file edits.
  acceptEdits,

  /// Launches with `--mode plan`, keeping the agent in planning mode.
  plan,

  /// Launches with `--dangerously-skip-permissions`, approving every tool.
  bypassPermissions,
}

/// Reasoning effort forwarded to the CLI with `--effort`.
enum AntigravityReasoningEffort {
  /// Low reasoning effort.
  low,

  /// Medium reasoning effort.
  medium,

  /// High reasoning effort.
  high,
}

/// Configuration for the Antigravity ACP adapter and client.
final class AntigravityAcpOptions {
  /// Creates validated adapter options.
  AntigravityAcpOptions({
    this.executable,
    Map<String, String>? environment,
    this.includeParentEnvironment = true,
    this.model,
    this.agentName,
    this.effort,
    this.permissionPolicy = AntigravityPermissionPolicy.requestReview,
    List<String>? additionalDirectories,
    this.promptTimeout,
    this.shutdownTimeout = const Duration(seconds: 2),
    this.maximumStderrTailCharacters = 8192,
    this.onStderr,
  }) : environment = environment == null
           ? null
           : UnmodifiableMapView<String, String>(
               Map<String, String>.of(environment),
             ),
       additionalDirectories = List<String>.unmodifiable(
         additionalDirectories ?? const <String>[],
       ) {
    if (executable case final String value when value.trim().isEmpty) {
      throw ArgumentError.value(executable, 'executable', 'must not be empty');
    }
    if (model case final String value when value.trim().isEmpty) {
      throw ArgumentError.value(model, 'model', 'must not be empty');
    }
    if (agentName case final String value when value.trim().isEmpty) {
      throw ArgumentError.value(agentName, 'agentName', 'must not be empty');
    }
    if (promptTimeout case final Duration value when value <= Duration.zero) {
      throw ArgumentError.value(
        promptTimeout,
        'promptTimeout',
        'must be positive',
      );
    }
    if (shutdownTimeout <= Duration.zero) {
      throw ArgumentError.value(
        shutdownTimeout,
        'shutdownTimeout',
        'must be positive',
      );
    }
    if (maximumStderrTailCharacters < 0) {
      throw ArgumentError.value(
        maximumStderrTailCharacters,
        'maximumStderrTailCharacters',
        'must not be negative',
      );
    }
  }

  /// Explicit executable path or command.
  ///
  /// When omitted, `findAntigravityExecutable` is used.
  final String? executable;

  /// Environment entries supplied to every child process.
  final Map<String, String>? environment;

  /// Whether child processes and the executable finder inherit the parent
  /// environment.
  final bool includeParentEnvironment;

  /// Model forwarded to the CLI with `--model`, when set.
  final String? model;

  /// Named Antigravity agent forwarded with `--agent`, when set.
  final String? agentName;

  /// Reasoning effort forwarded with `--effort`, when set.
  final AntigravityReasoningEffort? effort;

  /// Tool-permission behavior of headless runs.
  final AntigravityPermissionPolicy permissionPolicy;

  /// Extra workspace directories forwarded with `--add-dir` on every prompt.
  final List<String> additionalDirectories;

  /// Maximum turn duration forwarded with `--print-timeout`.
  ///
  /// When omitted, the CLI default applies.
  final Duration? promptTimeout;

  /// Grace period before a closing or cancelled child process is killed.
  final Duration shutdownTimeout;

  /// Maximum number of recent stderr characters retained for failures.
  final int maximumStderrTailCharacters;

  /// Optional observer for child-process stderr.
  final AntigravityStderrHandler? onStderr;
}

/// Configuration accepted by `AntigravityAcpClient.start`.
typedef AntigravityAcpClientOptions = AntigravityAcpOptions;
