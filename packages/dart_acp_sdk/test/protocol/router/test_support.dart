import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart' as v1;
import 'package:dart_acp_sdk/experimental/protocol_router.dart';
import 'package:dart_acp_sdk/experimental/v2.dart' as v2;

v1.AcpAgentApp v1Agent({
  void Function(v1.AcpIncomingMessage message)? observe,
  void Function()? onConnect,
}) {
  var app = v1.AcpAgentApp(
    implementation: v1.Implementation(name: 'v1-agent', version: '1'),
    capabilities: v1.AgentCapabilities.fromJson(<String, Object?>{}),
  );
  if (observe != null) {
    app = app.onMessage((message, _) {
      observe(message);
      return v1.AcpMiddlewareResult.pass;
    });
  }
  if (onConnect != null) {
    app = app.onConnect((_) => onConnect());
  }
  return app;
}

v2.AcpV2AgentApp v2Agent({void Function()? onConnect}) {
  var app = v2.AcpV2AgentApp(
    implementation: v2.Implementation(name: 'v2-agent', version: '1'),
    capabilities: v2.AgentCapabilities(),
  );
  if (onConnect != null) {
    app = app.onConnect((_) => onConnect());
  }
  return app;
}

Map<String, Object?> initializeRequest(
  Object? version, {
  Object? id = 1,
  Map<String, Object?>? capabilities,
}) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'method': 'initialize',
  'params': <String, Object?>{
    'protocolVersion': version,
    if (version is num && version >= 2) ...<String, Object?>{
      'info': <String, Object?>{'name': 'client', 'version': '1'},
      'capabilities': capabilities ?? <String, Object?>{},
    } else ...<String, Object?>{
      'clientInfo': <String, Object?>{'name': 'client', 'version': '1'},
      'clientCapabilities': capabilities ?? <String, Object?>{},
    },
  },
};

final class RouterHarness {
  RouterHarness(
    AcpProtocolRouter router, {
    AcpProtocolRouterConnectOptions options =
        const AcpProtocolRouterConnectOptions(),
  }) : _input = StreamController<Object?>(),
       _output = StreamController<Object?>() {
    _outputIterator = StreamIterator<Object?>(_output.stream);
    connection = router.connect(
      v1.AcpDuplexStream<Object?>(
        readable: _input.stream,
        writable: v1.AcpWritable<Object?>(
          write: (Object? value) {
            _output.add(value);
            return Future<void>.value();
          },
          close: _closeOutput,
        ),
      ),
      options: options,
    );
  }

  final StreamController<Object?> _input;
  final StreamController<Object?> _output;
  late final StreamIterator<Object?> _outputIterator;
  late final AcpRoutedAgentConnection connection;
  bool _outputClosed = false;

  Future<Object?> nextOutput() async {
    if (!await _outputIterator.moveNext()) {
      throw StateError('Router output closed before the next message');
    }
    return _outputIterator.current;
  }

  Future<bool> outputIsDone() async => !await _outputIterator.moveNext();

  void add(Object? value) => _input.add(value);

  Future<void> closeInput() => _input.close();

  Future<void> close() async {
    await _input.close();
    connection.close();
    await connection.closed;
    await _outputIterator.cancel();
    await _closeOutput();
  }

  Future<void> _closeOutput() {
    if (_outputClosed) {
      return Future<void>.value();
    }
    _outputClosed = true;
    // A paused StreamIterator does not request the done event until its next
    // moveNext call. Transport close acknowledgement must not wait for that
    // consumer demand or the router lifecycle would deadlock.
    unawaited(_output.close());
    return Future<void>.value();
  }
}

Map<String, Object?> asObject(Object? value) =>
    (value as Map<Object?, Object?>).cast<String, Object?>();

Map<String, Object?> errorOf(Object? response) =>
    asObject(asObject(response)['error']);
