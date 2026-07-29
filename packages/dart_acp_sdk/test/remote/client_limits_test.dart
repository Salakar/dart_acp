import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:test/test.dart';

import 'http_test_support.dart';

void main() {
  test('HTTP client validates all limits at runtime', () {
    final adapter = FakeHttpAdapter((_) => Completer<AcpHttpResponse>().future);
    final invalidLimits = <AcpHttpClientLimits>[
      const AcpHttpClientLimits(maximumBodyBytes: 0),
      const AcpHttpClientLimits(maximumSseLineBytes: 0),
      const AcpHttpClientLimits(maximumSseEventBytes: 0),
      const AcpHttpClientLimits(maximumPendingSessionRequests: 0),
      const AcpHttpClientLimits(maximumJsonNestingDepth: 0),
    ];

    for (final limits in invalidLimits) {
      expect(
        () => AcpHttpClientTransport(
          Uri.parse('https://example.test/acp'),
          adapter: adapter,
          limits: limits,
        ),
        throwsArgumentError,
        reason: limits.toString(),
      );
    }
  });

  test('SSE parser validates line and event limits at runtime', () async {
    for (final limits in <AcpSseLimits>[
      const AcpSseLimits(maximumLineBytes: 0),
      const AcpSseLimits(maximumEventBytes: 0),
      const AcpSseLimits(maximumJsonNestingDepth: 0),
    ]) {
      await expectLater(
        decodeSseJson(const Stream<List<int>>.empty(), limits: limits).toList(),
        throwsArgumentError,
      );
    }
  });

  test('HTTP client rejects an over-depth JSON response body', () async {
    final adapter = FakeHttpAdapter((AcpHttpRequest request) {
      if (request.method == 'DELETE') {
        return emptyResponse();
      }
      return jsonResponse(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 1,
        'result': <String, Object?>{
          'nested': <Object?>[
            <Object?>[<String, Object?>{}],
          ],
        },
      }, connectionId: 'connection');
    });
    final transport = AcpHttpClientTransport(
      Uri.parse('https://example.test/acp'),
      adapter: adapter,
      limits: const AcpHttpClientLimits(maximumJsonNestingDepth: 3),
    );

    await expectLater(
      transport.stream.writable.write(
        JsonRpcRequest(id: JsonRpcId.number(1), method: 'initialize'),
      ),
      throwsA(isA<AcpHttpTransportException>()),
    );
    await transport.done;
  });
}
