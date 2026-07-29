import 'dart:async';

import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:dart_acp_sdk/src/remote/server_limits.dart';
import 'package:test/test.dart';

import 'http_server_test_support.dart';

void main() {
  late HttpServerHarness harness;

  setUp(() {
    harness = HttpServerHarness();
  });
  tearDown(() => harness.close());

  test('rejects over-depth HTTP JSON before application dispatch', () async {
    await harness.close();
    harness = HttpServerHarness(
      limits: const AcpRemoteServerLimits(maximumJsonNestingDepth: 3),
    );

    final response = await harness.request(
      'POST',
      headers: jsonHeaders(),
      rawBody:
          '{"jsonrpc":"2.0","method":"initialize","params":[[{}]]}'.codeUnits,
    );

    expect(response.statusCode, 400);
    expect(harness.inbound, isEmpty);
  });

  test('HTTP request policy times out closed', () async {
    await harness.close();
    final pending = Completer<bool>();
    harness = HttpServerHarness(
      policy: (_) => pending.future,
      limits: const AcpRemoteServerLimits(
        initializeTimeout: Duration(milliseconds: 10),
      ),
    );

    expect((await harness.request('GET')).statusCode, 403);
    pending.complete(true);
  });

  test('HTTP request policy observes request cancellation', () async {
    await harness.close();
    final called = Completer<void>();
    harness = HttpServerHarness(
      policy: (_) {
        called.complete();
        return Completer<bool>().future;
      },
    );
    final cancellation = CancellationSource();
    final response = harness.request('GET', cancellation: cancellation);
    await called.future;
    cancellation.cancel();

    expect((await response).statusCode, 499);
  });
}
