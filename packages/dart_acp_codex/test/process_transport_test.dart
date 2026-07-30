import 'package:dart_acp_codex/src/app_server/process_transport.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('normalizer adds inbound and removes outbound jsonrpc', () async {
    final pair = acpInProcessTransportPair<Object?>();
    final normalized = normalizedAppServerStream(pair.left);
    final incoming = normalized.readable.first;

    await pair.right.writable.write(<String, Object?>{
      'method': 'event',
      'params': <String, Object?>{},
    });
    final inbound = await incoming as Map<Object?, Object?>;
    expect(inbound['jsonrpc'], '2.0');

    final outbound = pair.right.readable.first;
    await normalized.writable.write(<String, Object?>{
      'jsonrpc': '2.0',
      'method': 'call',
    });
    final raw = await outbound as Map<Object?, Object?>;
    expect(raw, isNot(contains('jsonrpc')));
    await normalized.writable.close();
  });
}
