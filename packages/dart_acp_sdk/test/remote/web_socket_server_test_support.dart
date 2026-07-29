import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/src/remote/http_adapter.dart';
import 'package:dart_acp_sdk/src/remote/server_connection.dart';
import 'package:dart_acp_sdk/src/remote/server_limits.dart';
import 'package:dart_acp_sdk/src/remote/web_socket_adapter.dart';
import 'package:dart_acp_sdk/src/remote/web_socket_server.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';

final class WebSocketServerHarness {
  WebSocketServerHarness({
    this.protocolVersion = 1,
    this.failInitialize = false,
    AcpWebSocketUpgradePolicy? policy,
    int maximumFrameBytes = 16 * 1024 * 1024,
    int maximumJsonNestingDepth = 128,
  }) {
    server = AcpWebSocketServer(
      createConnection: _createConnection,
      upgradePolicy: policy,
      limits: AcpRemoteServerLimits(
        maximumWebSocketFrameBytes: maximumFrameBytes,
        maximumJsonNestingDepth: maximumJsonNestingDepth,
      ),
    );
  }

  final int protocolVersion;
  final bool failInitialize;
  late final AcpWebSocketServer server;
  final List<Object?> inbound = [];
  final List<StreamController<Object?>> _agentOutbound = [];
  final List<AcpServerConnectionState> connections = [];
  FakeServerWebSocket? socket;
  AcpWebSocketServerSession? session;

  AcpServerConnectionState _createConnection(String id) {
    final outbound = StreamController<Object?>(sync: true);
    _agentOutbound.add(outbound);
    final state = AcpServerConnectionState(
      connectionId: id,
      inbound: AcpWritable<Object?>(
        write: (Object? value) async {
          inbound.add(value);
          if (failInitialize) {
            throw StateError('connector detail');
          }
          final Map<Object?, Object?>? object = value is Map<Object?, Object?>
              ? value
              : null;
          if (object?['method'] == 'initialize') {
            outbound.add(<String, Object?>{
              'jsonrpc': '2.0',
              'id': object?['id'],
              'result': <String, Object?>{'protocolVersion': protocolVersion},
            });
          }
        },
        close: () async {},
      ),
      outbound: outbound.stream,
    );
    connections.add(state);
    return state;
  }

  Future<FakeServerWebSocket> connect() async {
    final prepared = await server.prepare(
      AcpWebSocketUpgradeContext(uri: Uri.parse('ws://localhost/acp')),
    );
    final channel = FakeServerWebSocket();
    socket = channel;
    session = prepared.accept(channel);
    return channel;
  }

  void initialize({bool batch = false}) {
    final value = <String, Object?>{
      'jsonrpc': '2.0',
      'id': 1,
      'method': 'initialize',
      'params': <String, Object?>{'protocolVersion': protocolVersion},
    };
    socket!.receiveText(jsonEncode(batch ? <Object?>[value] : value));
  }

  void emit(Object? value) => _agentOutbound.last.add(value);

  Future<void> close() async {
    await server.close();
    for (final controller in _agentOutbound) {
      await controller.close();
    }
  }
}

final class FakeServerWebSocket implements AcpWebSocketChannel {
  FakeServerWebSocket() {
    _frames = StreamController<AcpWebSocketFrame>(
      sync: true,
      onPause: () {
        isInputPaused = true;
        pauseCount += 1;
      },
      onResume: () {
        isInputPaused = false;
      },
    );
  }

  late final StreamController<AcpWebSocketFrame> _frames;
  final Completer<void> _closed = Completer<void>();
  final List<String> sent = [];
  Completer<void>? sendGate;
  int? closeCode;
  String? closeReason;
  int pauseCount = 0;
  bool isInputPaused = false;

  @override
  Future<void> get closed => _closed.future;

  @override
  Stream<AcpWebSocketFrame> get frames => _frames.stream;

  @override
  AcpHttpHeaders get responseHeaders => const AcpHttpHeaders();

  void receiveText(String text) => _frames.add(AcpWebSocketTextFrame(text));

  void receiveBinary(List<int> bytes) =>
      _frames.add(AcpWebSocketBinaryFrame(bytes));

  @override
  Future<void> sendText(String text) async {
    sent.add(text);
    await sendGate?.future;
  }

  @override
  Future<void> close({int? code, String? reason}) async {
    closeCode ??= code;
    closeReason ??= reason;
    final Completer<void>? gate = sendGate;
    if (gate != null && !gate.isCompleted) {
      gate.complete();
    }
    if (!_frames.isClosed) {
      unawaited(_frames.close());
    }
    if (!_closed.isCompleted) {
      _closed.complete();
    }
  }
}

Future<void> waitFor(bool Function() condition) async {
  for (var attempt = 0; attempt < 100; attempt += 1) {
    if (condition()) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  throw StateError('Condition did not become true');
}
