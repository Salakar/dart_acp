import 'dart:collection';
import 'dart:io';

import '../app_server/json_values.dart';
import '../config/authentication.dart';
import '../config/modes.dart';
import 'diagnostics.dart';

/// The Codex app-server reviewer for eligible approval requests.
enum CodexApprovalsReviewer {
  /// Route approval requests to the ACP client for human review.
  user('user'),

  /// Let Codex's native automatic reviewer decide eligible requests.
  autoReview('auto_review');

  const CodexApprovalsReviewer(this.appServerValue);

  /// Wire value sent to Codex app-server.
  final String appServerValue;
}

/// Runtime configuration for a local adapter.
final class CodexAdapterOptions {
  /// Creates validated runtime options.
  CodexAdapterOptions({
    this.executable,
    CodexJsonObject? configuration,
    this.modelProvider,
    this.defaultAuthentication,
    Map<String, String>? environment,
    this.workspaceWriteApprovalsReviewer = CodexApprovalsReviewer.user,
    this.shutdownTimeout = const Duration(seconds: 2),
    this.maximumStderrTailCharacters = 2048,
    this.onDiagnostic,
  }) : configuration = configuration ?? CodexJsonObject.empty,
       environment = UnmodifiableMapView<String, String>(
         Map<String, String>.of(environment ?? Platform.environment),
       ) {
    if (executable case final String path when path.trim().isEmpty) {
      throw const CodexConfigurationException(
        'Executable path must not be empty.',
      );
    }
    if (shutdownTimeout <= Duration.zero) {
      throw const CodexConfigurationException(
        'Shutdown timeout must be positive.',
      );
    }
    if (maximumStderrTailCharacters <= 0) {
      throw const CodexConfigurationException(
        'Maximum stderr tail characters must be positive.',
      );
    }
  }

  /// Explicit executable path or command.
  final String? executable;

  /// Base app-server configuration.
  final CodexJsonObject configuration;

  /// Optional model-provider id.
  final String? modelProvider;

  /// Authentication attempted when a session requires it.
  final CodexAuthentication? defaultAuthentication;

  /// Child environment.
  final Map<String, String> environment;

  /// Reviewer used for standard workspace-write turns.
  ///
  /// Read-only and plan turns always remain human-reviewed. Full-access turns
  /// keep their `never` approval policy, so this setting does not widen their
  /// permissions.
  final CodexApprovalsReviewer workspaceWriteApprovalsReviewer;

  /// Resolves the app-server reviewer for a turn.
  ///
  /// Automatic review is deliberately limited to the standard collaboration
  /// mode in a workspace-write sandbox. This keeps read-only and plan turns on
  /// explicit human review even when an embedded client opts workspace work
  /// into automatic review.
  CodexApprovalsReviewer resolveApprovalsReviewer({
    required CodexAgentMode agentMode,
    required CodexCollaborationMode collaborationMode,
  }) =>
      agentMode == CodexAgentMode.workspaceWrite &&
          collaborationMode == CodexCollaborationMode.standard
      ? workspaceWriteApprovalsReviewer
      : CodexApprovalsReviewer.user;

  /// Graceful child shutdown timeout.
  final Duration shutdownTimeout;

  /// Maximum stderr characters retained for process-failure context.
  final int maximumStderrTailCharacters;

  /// Receives redacted diagnostics.
  final void Function(CodexDiagnostic diagnostic)? onDiagnostic;
}
