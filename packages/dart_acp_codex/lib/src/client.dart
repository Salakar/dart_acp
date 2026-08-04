import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import 'agent/codex_agent.dart';
import 'app_server/backend.dart';
import 'runtime/options.dart';
import 'runtime/runtime.dart';

/// Configuration accepted by [CodexAcpClient.start].
typedef CodexAcpClientOptions = CodexAdapterOptions;

/// A typed ACP client connected directly to the Codex adapter.
final class CodexAcpClient {
  CodexAcpClient._({
    required this.runtime,
    required this.adapter,
    required AcpDirectConnectionPair pair,
  }) : connection = pair.client,
       _pair = pair {
    _closedFuture = _finishWhenConnectionCloses();
    _closedFuture.ignore();
  }

  /// Starts the Codex runtime, connects [app], and waits for ACP
  /// initialization.
  ///
  /// If [app] is omitted, a minimal client that advertises no file-system or
  /// terminal proxy capabilities is created and permission requests are
  /// declined. Pass a configured [AcpClientApp] when the client should handle
  /// permissions, file-system requests, terminal requests, or elicitations.
  static Future<CodexAcpClient> start({
    AcpClientApp? app,
    CodexAcpClientOptions? options,
    CodexBackend? backend,
  }) async {
    final CodexRuntime runtime = await CodexRuntime.start(
      options: options,
      backend: backend,
    );
    final CodexAgent adapter = runtime.createAgent();
    AcpDirectConnectionPair? pair;
    try {
      pair = await (app ?? _defaultClientApp()).connectWith(adapter.app);
      await adapter.initialized;
      return CodexAcpClient._(runtime: runtime, adapter: adapter, pair: pair);
    } on Object {
      await pair?.close();
      await runtime.close();
      rethrow;
    }
  }

  /// Initialized typed ACP client connection.
  final AcpClientConnection connection;

  /// Runtime that owns the Codex app-server backend and process.
  final CodexRuntime runtime;

  /// Underlying Codex ACP adapter.
  final CodexAgent adapter;

  final AcpDirectConnectionPair _pair;
  late final Future<void> _closedFuture;
  Future<void>? _runtimeCloseFuture;
  Future<void>? _closeFuture;

  /// Context for creating sessions and calling Codex ACP methods.
  AcpClientContext get agent => connection.agent;

  /// Child process exit code, or zero after an injected backend closes.
  Future<int> get exitCode => runtime.exitCode;

  /// Completes after the ACP connection and runtime resources close.
  Future<void> get closed => _closedFuture;

  /// Closes the ACP connection and runtime idempotently.
  Future<void> close() => _closeFuture ??= _close();

  Future<void> _close() async {
    await _pair.close();
    await _closedFuture;
  }

  Future<void> _finishWhenConnectionCloses() async {
    await connection.closed;
    await _closeRuntime();
  }

  Future<void> _closeRuntime() => _runtimeCloseFuture ??= runtime.close();
}

AcpClientApp _defaultClientApp() =>
    AcpClientApp.v1(
      implementation: Implementation(
        name: 'dart_acp_codex',
        title: 'Dart ACP Codex',
        version: '0.1.5',
      ),
      capabilities: ClientCapabilities(
        fs: FileSystemCapabilities(readTextFile: false, writeTextFile: false),
        terminal: false,
      ),
    ).onRequestPermission(
      (_) => RequestPermissionResponse(
        outcome: const RequestPermissionOutcomeCancelled(),
      ),
    );
