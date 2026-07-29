import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:dart_acp_sdk/src/remote/http_adapter.dart';
import 'package:dart_acp_sdk/src/remote/http_server.dart';
import 'package:dart_acp_sdk/src/remote/server_connection.dart';
import 'package:dart_acp_sdk/src/remote/server_limits.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';

final class HttpServerHarness {
  HttpServerHarness({
    AcpHttpRequestPolicy? policy,
    AcpRemoteServerLimits limits = const AcpRemoteServerLimits(),
  }) {
    server = AcpHttpServer(
      createConnection: createConnection,
      requestPolicy: policy,
      limits: limits,
    );
  }

  late final AcpHttpServer server;
  final List<StreamController<Object?>> _outbound = [];
  final List<AcpServerConnectionState> connections = [];
  final List<Object?> inbound = [];
  bool failFactory = false;
  bool initializeError = false;

  AcpServerConnectionState createConnection(String id) {
    if (failFactory) {
      throw StateError('factory secret');
    }
    final outbound = StreamController<Object?>(sync: true);
    _outbound.add(outbound);
    final state = AcpServerConnectionState(
      connectionId: id,
      inbound: AcpWritable<Object?>(
        write: (Object? value) async {
          inbound.add(value);
          if (value case <String, Object?>{
            'method': 'initialize',
            'id': final Object? requestId,
          }) {
            outbound.add(<String, Object?>{
              'jsonrpc': '2.0',
              'id': requestId,
              if (initializeError)
                'error': <String, Object?>{
                  'code': -32000,
                  'message': 'not configured',
                }
              else
                'result': <String, Object?>{'protocolVersion': 1},
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

  void emit(Object? value) => _outbound.last.add(value);

  Future<AcpHttpResponse> initialize({Object? id = 1}) =>
      request('POST', headers: jsonHeaders(), body: initializeMessage(id));

  Future<AcpHttpResponse> request(
    String method, {
    AcpHttpHeaders headers = const AcpHttpHeaders(),
    Object? body,
    List<int>? rawBody,
    CancellationSource? cancellation,
  }) => server.handle(
    AcpHttpRequest(
      uri: Uri.parse('http://localhost/acp'),
      method: method,
      cancellationToken: (cancellation ?? CancellationSource()).token,
      headers: headers,
      body: rawBody ?? (body == null ? null : utf8.encode(jsonEncode(body))),
    ),
  );

  Future<void> close() async {
    await server.close();
    for (final controller in _outbound) {
      await controller.close();
    }
  }
}

AcpHttpHeaders jsonHeaders() => const AcpHttpHeaders().withHeader(
  'Content-Type',
  'application/json; charset=utf-8',
);

Map<String, Object?> initializeMessage(Object? id) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'method': 'initialize',
  'params': <String, Object?>{},
};

Map<String, Object?> notification(String method) => <String, Object?>{
  'jsonrpc': '2.0',
  'method': method,
};

Future<Map<String, Object?>> jsonBody(AcpHttpResponse response) async =>
    jsonDecode(
          utf8.decode(
            (await response.body.toList()).expand((chunk) => chunk).toList(),
          ),
        )
        as Map<String, Object?>;
