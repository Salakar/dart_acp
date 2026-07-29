import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/experimental/http.dart';

typedef HttpRequestHandler =
    FutureOr<AcpHttpResponse> Function(AcpHttpRequest request);

final class FakeHttpAdapter implements AcpHttpAdapter {
  FakeHttpAdapter(this.handler);

  HttpRequestHandler handler;
  final List<AcpHttpRequest> requests = <AcpHttpRequest>[];
  int closeCount = 0;

  @override
  Future<AcpHttpResponse> send(AcpHttpRequest request) async {
    requests.add(request);
    return handler(request);
  }

  @override
  Future<void> close() async {
    closeCount += 1;
  }
}

AcpHttpResponse jsonResponse(
  Object? value, {
  int statusCode = 200,
  String? connectionId,
  Iterable<String> setCookies = const <String>[],
  String? contentType = acpJsonMediaType,
}) {
  var headers = const AcpHttpHeaders();
  if (contentType != null) {
    headers = headers.withHeader('Content-Type', contentType);
  }
  if (connectionId != null) {
    headers = headers.withHeader(acpConnectionIdHeader, connectionId);
  }
  for (final cookie in setCookies) {
    headers = headers.withAddedHeader('Set-Cookie', cookie);
  }
  return AcpHttpResponse(
    statusCode: statusCode,
    headers: headers,
    body: Stream<List<int>>.value(utf8.encode(jsonEncode(value))),
  );
}

AcpHttpResponse emptyResponse({int statusCode = 204}) => AcpHttpResponse(
  statusCode: statusCode,
  headers: const AcpHttpHeaders(),
  body: const Stream<List<int>>.empty(),
);

AcpHttpResponse sseResponse(Stream<List<int>> body) => AcpHttpResponse(
  statusCode: 200,
  headers: const AcpHttpHeaders().withHeader('Content-Type', acpSseMediaType),
  body: body,
);

Future<void> pumpUntil(bool Function() predicate) async {
  for (var attempt = 0; attempt < 100; attempt += 1) {
    if (predicate()) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  throw StateError('Condition was not reached');
}

String requestBody(AcpHttpRequest request) => utf8.decode(request.body!);
