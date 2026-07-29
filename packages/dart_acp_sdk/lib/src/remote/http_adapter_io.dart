import 'dart:async';
import 'dart:io';

import '../json_rpc/cancellation.dart';
import 'http_adapter.dart';

/// Creates the `dart:io` HTTP adapter.
AcpHttpAdapter createPlatformHttpAdapter() => _IoHttpAdapter();

final class _IoHttpAdapter implements AcpHttpAdapter {
  final HttpClient _client = HttpClient();
  bool _closed = false;

  @override
  Future<AcpHttpResponse> send(AcpHttpRequest request) async {
    if (_closed) {
      throw StateError('HTTP adapter is closed');
    }
    request.cancellationToken.throwIfCancelled();
    final ioRequest = await _client.openUrl(request.method, request.uri);
    final cancellation = request.cancellationToken.register((_) {
      ioRequest.abort(const _IoRequestCancelled());
    });
    try {
      ioRequest.followRedirects = false;
      ioRequest.cookies.clear();
      request.headers.forEach((name, value) {
        ioRequest.headers.add(name, value);
      });
      final body = request.body;
      if (body != null && body.isNotEmpty) {
        ioRequest.add(body);
      }
      final response = await ioRequest.close();
      var headers = const AcpHttpHeaders();
      response.headers.forEach((name, values) {
        for (final value in values) {
          headers = headers.withAddedHeader(name, value);
        }
      });
      return AcpHttpResponse(
        statusCode: response.statusCode,
        reasonPhrase: response.reasonPhrase,
        headers: headers,
        body: _responseBody(response, request.cancellationToken),
      );
    } finally {
      cancellation.dispose();
    }
  }

  Stream<List<int>> _responseBody(
    HttpClientResponse response,
    CancellationToken cancellationToken,
  ) {
    late final StreamController<List<int>> controller;
    StreamSubscription<List<int>>? subscription;
    CancellationRegistration? cancellation;
    controller = StreamController<List<int>>(
      onListen: () {
        subscription = response.listen(
          (chunk) {
            if (!controller.isClosed) {
              controller.add(List<int>.unmodifiable(chunk));
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            cancellation?.dispose();
            if (!controller.isClosed) {
              controller.addError(error, stackTrace);
              unawaited(controller.close());
            }
          },
          onDone: () {
            cancellation?.dispose();
            if (!controller.isClosed) {
              unawaited(controller.close());
            }
          },
          cancelOnError: true,
        );
        cancellation = cancellationToken.register((reason) {
          unawaited(subscription?.cancel());
          if (!controller.isClosed) {
            controller.addError(CancellationException(reason));
            unawaited(controller.close());
          }
        });
      },
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () async {
        cancellation?.dispose();
        await subscription?.cancel();
      },
    );
    return controller.stream;
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    _client.close(force: true);
  }
}

final class _IoRequestCancelled implements Exception {
  const _IoRequestCancelled();

  @override
  String toString() => 'ACP HTTP request cancelled';
}
