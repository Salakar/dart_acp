import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import 'agent/claude_acp_agent.dart';
import 'configuration/agent_options.dart';
import 'runtime/contracts.dart';

/// Configuration accepted by [ClaudeAcpClient.start].
typedef ClaudeAcpClientOptions = ClaudeAcpOptions;

/// A typed ACP client connected directly to the Claude adapter.
final class ClaudeAcpClient {
  ClaudeAcpClient._({
    required this.adapter,
    required AcpDirectConnectionPair pair,
  }) : connection = pair.client,
       _pair = pair {
    _closedFuture = _finishWhenConnectionCloses();
    _closedFuture.ignore();
  }

  /// Creates the Claude adapter, connects [app], and waits for ACP
  /// initialization.
  ///
  /// If [app] is omitted, a minimal client that advertises no file-system or
  /// terminal proxy capabilities is created and permission requests are
  /// declined. Pass a configured [AcpClientApp] when the client should handle
  /// permissions, file-system requests, terminal requests, or elicitations.
  static Future<ClaudeAcpClient> start({
    AcpClientApp? app,
    ClaudeAcpClientOptions? options,
    ClaudeAcpEnvironment? environment,
    ClaudeAgentClientFactory? clientFactory,
    ClaudeAcpLogger logger = const ClaudeAcpNullLogger(),
    ClaudeAcpFileSystem fileSystem = const LocalClaudeAcpFileSystem(),
    ClaudeAcpIdGenerator? idGenerator,
    ClaudeLogoutRunner? logoutRunner,
  }) async {
    final ClaudeAcpAgent adapter = ClaudeAcpAgent(
      clientFactory: clientFactory,
      options: options,
      environment: environment,
      logger: logger,
      fileSystem: fileSystem,
      idGenerator: idGenerator,
      logoutRunner: logoutRunner,
    );
    try {
      final AcpDirectConnectionPair pair = await (app ?? _defaultClientApp())
          .connectWith(adapter.app);
      return ClaudeAcpClient._(adapter: adapter, pair: pair);
    } on Object {
      await adapter.dispose();
      rethrow;
    }
  }

  /// Initialized typed ACP client connection.
  final AcpClientConnection connection;

  /// Underlying Claude ACP adapter.
  final ClaudeAcpAgent adapter;

  final AcpDirectConnectionPair _pair;
  late final Future<void> _closedFuture;
  Future<void>? _adapterDisposeFuture;
  Future<void>? _closeFuture;

  /// Context for creating sessions and calling Claude ACP methods.
  AcpClientContext get agent => connection.agent;

  /// Completes after the ACP connection and adapter resources close.
  Future<void> get closed => _closedFuture;

  /// Closes the ACP connection and adapter idempotently.
  Future<void> close() => _closeFuture ??= _close();

  Future<void> _close() async {
    await _pair.close();
    await _closedFuture;
  }

  Future<void> _finishWhenConnectionCloses() async {
    await connection.closed;
    await _disposeAdapter();
  }

  Future<void> _disposeAdapter() => _adapterDisposeFuture ??= adapter.dispose();
}

AcpClientApp _defaultClientApp() =>
    AcpClientApp.v1(
      implementation: Implementation(
        name: 'dart_acp_claude',
        title: 'Dart ACP Claude',
        version: '0.1.2',
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
