import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:test/test.dart';

void main() {
  group('AcpHttpHeaders', () {
    test('normalizes names while preserving repeated values', () {
      final headers = const AcpHttpHeaders()
          .withAddedHeader('Set-Cookie', 'first=1')
          .withAddedHeader('set-cookie', 'second=2')
          .withHeader('CONTENT-TYPE', 'application/json');

      expect(headers.values('SET-cookie'), <String>['first=1', 'second=2']);
      expect(headers.value('content-type'), 'application/json');
      expect(headers.contains('Content-Type'), isTrue);
      expect(headers.toString(), isNot(contains('first=1')));
    });

    test('overlay replaces matching names and without removes them', () {
      final base = AcpHttpHeaders.fromMap(<String, String>{
        'Accept': 'text/plain',
        'X-Base': 'yes',
      });
      final overlaid = base.overlay(
        AcpHttpHeaders.fromMap(<String, String>{'accept': 'application/json'}),
      );

      expect(overlaid.value('Accept'), 'application/json');
      expect(overlaid.value('x-base'), 'yes');
      expect(overlaid.without('X-BASE').contains('x-base'), isFalse);
    });

    test('rejects invalid names and response splitting', () {
      expect(
        () => const AcpHttpHeaders().withHeader('bad name', 'value'),
        throwsArgumentError,
      );
      expect(
        () => const AcpHttpHeaders().withHeader('valid', 'one\r\ntwo'),
        throwsArgumentError,
      );
    });
  });

  test('request and response contracts expose cancellation and success', () {
    final cancellation = CancellationSource();
    final request = AcpHttpRequest(
      uri: Uri.parse('https://agent.example/acp'),
      method: 'POST',
      cancellationToken: cancellation.token,
      body: const <int>[1, 2],
    );
    const response = AcpHttpResponse(
      statusCode: 204,
      headers: AcpHttpHeaders(),
      body: Stream<List<int>>.empty(),
    );

    expect(request.cookiePolicy, AcpHttpCookiePolicy.include);
    expect(response.isSuccessful, isTrue);
    cancellation.cancel('test');
    expect(request.cancellationToken.isCancelled, isTrue);
  });
}
