import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import 'agent.dart';
import 'options.dart';

/// A typed ACP client connected directly to the Antigravity adapter.
final class AntigravityAcpClient {
  AntigravityAcpClient._({
    required this.adapter,
    required AcpDirectConnectionPair pair,
  }) : connection = pair.client,
       _pair = pair {
    _closedFuture = _finishWhenConnectionCloses();
    _closedFuture.ignore();
  }

  /// Creates the in-process Antigravity adapter, connects [app], and waits
  /// for ACP initialization.
  ///
  /// If [app] is omitted, a minimal client that advertises no file-system or
  /// terminal proxy capabilities is created. The adapter never sends
  /// permission requests, so the default client declines them only as a
  /// safeguard. Pass a configured [AcpClientApp] to handle file-system
  /// requests or elicitations.
  static Future<AntigravityAcpClient> start({
    AcpClientApp? app,
    AntigravityAcpClientOptions? options,
  }) async {
    final AntigravityAcpAgent adapter = AntigravityAcpAgent(options: options);
    AcpDirectConnectionPair? pair;
    try {
      pair = await (app ?? _defaultClientApp()).connectWith(adapter.app);
      return AntigravityAcpClient._(adapter: adapter, pair: pair);
    } on Object {
      await pair?.close();
      await adapter.dispose();
      rethrow;
    }
  }

  /// Initialized typed ACP client connection.
  final AcpClientConnection connection;

  /// Underlying Antigravity ACP adapter.
  final AntigravityAcpAgent adapter;

  final AcpDirectConnectionPair _pair;
  late final Future<void> _closedFuture;
  Future<void>? _closeFuture;

  /// Context for creating sessions and calling Antigravity ACP methods.
  AcpClientContext get agent => connection.agent;

  /// Completes after the ACP connection closes and child processes stop.
  Future<void> get closed => _closedFuture;

  /// Closes the ACP connection and adapter idempotently.
  Future<void> close() => _closeFuture ??= _close();

  Future<void> _close() async {
    await _pair.close();
    await _closedFuture;
  }

  Future<void> _finishWhenConnectionCloses() async {
    await connection.closed;
    await adapter.dispose();
  }
}

AcpClientApp _defaultClientApp() =>
    AcpClientApp.v1(
      implementation: Implementation(
        name: 'dart_acp_antigravity',
        title: 'Dart ACP Antigravity',
        version: dartAcpAntigravityVersion,
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
