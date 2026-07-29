import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:dart_acp_sdk/src/remote/http_adapter.dart';
import 'package:dart_acp_sdk/src/remote/http_server.dart';
import 'package:dart_acp_sdk/src/remote/server_connection.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:test/test.dart';

import 'http_server_test_support.dart';

void main() {
  test('server close waits for a DELETE cleanup already in progress', () async {
    final closeGate = Completer<void>();
    final outbound = StreamController<Object?>(sync: true);
    late AcpServerConnectionState state;
    final server = AcpHttpServer(
      createConnection: (String id) {
        state = AcpServerConnectionState(
          connectionId: id,
          inbound: AcpWritable<Object?>(
            write: (Object? value) async {
              final object = value as Map<String, Object?>;
              if (object['method'] == 'initialize') {
                outbound.add(<String, Object?>{
                  'jsonrpc': '2.0',
                  'id': object['id'],
                  'result': <String, Object?>{'protocolVersion': 1},
                });
              }
            },
            close: () => closeGate.future,
          ),
          outbound: outbound.stream,
        );
        return state;
      },
    );
    final initialized = await server.handle(
      _request('POST', headers: jsonHeaders(), body: initializeMessage(1)),
    );
    final connectionId = initialized.headers.value('Acp-Connection-Id')!;

    final deleted = await server.handle(
      _request(
        'DELETE',
        headers: const AcpHttpHeaders().withHeader(
          'Acp-Connection-Id',
          connectionId,
        ),
      ),
    );
    expect(deleted.statusCode, 202);

    var finished = false;
    final closing = server.close();
    unawaited(closing.whenComplete(() => finished = true));
    await Future<void>.delayed(Duration.zero);
    expect(finished, isFalse);

    closeGate.complete();
    await closing;
    await state.closed;
    expect(finished, isTrue);
    await outbound.close();
  });
}

AcpHttpRequest _request(
  String method, {
  AcpHttpHeaders headers = const AcpHttpHeaders(),
  Object? body,
}) => AcpHttpRequest(
  uri: Uri.parse('http://localhost/acp'),
  method: method,
  cancellationToken: CancellationSource().token,
  headers: headers,
  body: body == null ? null : utf8.encode(jsonEncode(body)),
);
