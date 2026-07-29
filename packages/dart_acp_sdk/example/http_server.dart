import 'dart:async';
import 'dart:io';

import 'package:dart_acp_sdk/experimental/server.dart';

import 'remote_example_support.dart';

/// A running loopback-safe HTTP and WebSocket example server.
final class RemoteExampleServer {
  /// Creates a handle around the owned ACP servers and native binding.
  const RemoteExampleServer({
    required this.httpEndpoint,
    required this.webSocketEndpoint,
    required AcpHttpServerBinding binding,
    required AcpHttpServer httpServer,
    required AcpWebSocketServer webSocketServer,
  }) : _binding = binding,
       _httpServer = httpServer,
       _webSocketServer = webSocketServer;

  /// HTTP/SSE endpoint.
  final Uri httpEndpoint;

  /// WebSocket endpoint hosted on the same listener.
  final Uri webSocketEndpoint;

  final AcpHttpServerBinding _binding;
  final AcpHttpServer _httpServer;
  final AcpWebSocketServer _webSocketServer;

  /// Stops the listener and every accepted connection.
  Future<void> close() async {
    await _binding.close();
    await Future.wait<void>(<Future<void>>[
      _httpServer.close(),
      _webSocketServer.close(),
    ]);
  }
}

/// Starts the example server on [host] and [port].
///
/// Non-loopback binding is rejected unless [allowInsecureDevelopment] is
/// explicitly true. The example has no authentication or TLS.
Future<RemoteExampleServer> startRemoteExampleServer({
  String host = '127.0.0.1',
  int port = 0,
  bool allowInsecureDevelopment = false,
  void Function(String event)? trace,
}) async {
  if (!_isLoopbackHost(host) && !allowInsecureDevelopment) {
    throw ArgumentError.value(
      host,
      'host',
      'non-loopback binding requires --allow-insecure-development',
    );
  }
  final agent = createRemoteExampleAgent(trace: trace);
  AcpServerConnectionState factory(String id) {
    trace?.call('server created connection');
    final state = connectRemoteExampleAgent(agent, id);
    if (trace != null) {
      final outbound = state.allOutbound.subscribe();
      final subscription = outbound.live.listen((_) {
        scheduleMicrotask(() {
          trace(
            'server routed outbound message '
            '(connection subscribers: '
            '${state.connectionOutbound.subscriberCount}, '
            'replay: ${state.connectionOutbound.replayLength}, '
            'sessions: ${state.sessionCount})',
          );
        });
      });
      unawaited(state.closed.whenComplete(subscription.cancel));
    }
    return state;
  }

  final httpServer = AcpHttpServer(
    createConnection: factory,
    requestPolicy: (request) {
      trace?.call('server received ${request.method}');
      return true;
    },
  );
  final webSocketServer = AcpWebSocketServer(
    createConnection: factory,
    upgradePolicy: (context) => _originAllowed(context.headers.value('origin')),
  );
  final adapter = createPlatformAcpHttpServerAdapter();
  if (!adapter.isSupported) {
    throw UnsupportedError('Native ACP server binding is unavailable');
  }
  final binding = await adapter.serve(
    httpServer,
    host: host,
    port: port,
    webSocketServer: webSocketServer,
  );
  final httpEndpoint = binding.endpoint;
  return RemoteExampleServer(
    httpEndpoint: httpEndpoint,
    webSocketEndpoint: httpEndpoint.replace(
      scheme: httpEndpoint.scheme == 'https' ? 'wss' : 'ws',
    ),
    binding: binding,
    httpServer: httpServer,
    webSocketServer: webSocketServer,
  );
}

Future<void> main(List<String> arguments) async {
  final host = _value(arguments, '--host') ?? '127.0.0.1';
  final port = int.tryParse(_value(arguments, '--port') ?? '0');
  if (port == null || port < 0 || port > 65535) {
    throw ArgumentError.value(port, 'port', 'must be 0 through 65535');
  }
  final server = await startRemoteExampleServer(
    host: host,
    port: port,
    allowInsecureDevelopment: arguments.contains(
      '--allow-insecure-development',
    ),
  );
  stderr
    ..writeln('HTTP/SSE: ${server.httpEndpoint}')
    ..writeln('WebSocket: ${server.webSocketEndpoint}');
  if (arguments.contains('--smoke')) {
    await server.close();
    return;
  }
  try {
    await Future.any<void>(<Future<void>>[
      ProcessSignal.sigint.watch().first,
      ProcessSignal.sigterm.watch().first,
    ]);
  } finally {
    await server.close();
  }
}

bool _isLoopbackHost(String host) {
  final normalized = host.toLowerCase();
  return normalized == '127.0.0.1' ||
      normalized == '::1' ||
      normalized == 'localhost';
}

bool _originAllowed(String? origin) {
  if (origin == null) {
    return true;
  }
  final uri = Uri.tryParse(origin);
  return uri != null && _isLoopbackHost(uri.host);
}

String? _value(List<String> arguments, String name) {
  final index = arguments.indexOf(name);
  return index < 0 || index + 1 == arguments.length
      ? null
      : arguments[index + 1];
}
