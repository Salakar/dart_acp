import 'dart:collection';
import 'dart:io';

import '../app_server/json_values.dart';
import '../config/authentication.dart';
import 'diagnostics.dart';

/// Runtime configuration for a local adapter.
final class CodexAdapterOptions {
  /// Creates validated runtime options.
  CodexAdapterOptions({
    this.executable,
    CodexJsonObject? configuration,
    this.modelProvider,
    this.defaultAuthentication,
    Map<String, String>? environment,
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

  /// Graceful child shutdown timeout.
  final Duration shutdownTimeout;

  /// Maximum stderr characters retained for process-failure context.
  final int maximumStderrTailCharacters;

  /// Receives redacted diagnostics.
  final void Function(CodexDiagnostic diagnostic)? onDiagnostic;
}
