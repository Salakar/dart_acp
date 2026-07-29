import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import '../json_rpc/cancellation.dart';
import 'http_adapter.dart';

/// Creates the browser Fetch adapter.
AcpHttpAdapter createPlatformHttpAdapter() => _WebHttpAdapter();

final class _WebHttpAdapter implements AcpHttpAdapter {
  bool _closed = false;

  @override
  Future<AcpHttpResponse> send(AcpHttpRequest request) async {
    if (_closed) {
      throw StateError('HTTP adapter is closed');
    }
    request.cancellationToken.throwIfCancelled();
    if (request.headers.contains('cookie')) {
      throw UnsupportedError(
        'Browser Fetch does not support caller-managed Cookie headers. '
        'Use the browser cookie jar instead.',
      );
    }
    final abortController = _JsAbortController();
    final cancellation = request.cancellationToken.register((_) {
      abortController.abort();
    });
    try {
      final headers = _JsHeaders();
      request.headers.forEach((name, value) {
        headers.append(name.toJS, value.toJS);
      });
      final body = request.body;
      final init = _JsRequestInit(
        method: request.method.toJS,
        headers: headers,
        body: body == null ? null : Uint8List.fromList(body).toJS,
        credentials:
            (request.cookiePolicy == AcpHttpCookiePolicy.include
                    ? 'include'
                    : 'omit')
                .toJS,
        signal: abortController.signal,
      );
      final response = await _fetch(request.uri.toString().toJS, init).toDart;
      var responseHeaders = const AcpHttpHeaders();
      for (final name in const <String>[
        'content-type',
        'content-length',
        'acp-connection-id',
        'acp-session-id',
      ]) {
        final value = response.headers.get(name.toJS)?.toDart;
        if (value != null) {
          responseHeaders = responseHeaders.withHeader(name, value);
        }
      }
      return AcpHttpResponse(
        statusCode: response.status.toDartInt,
        reasonPhrase: response.statusText.toDart,
        headers: responseHeaders,
        body: _readBody(response.body, request.cancellationToken),
      );
    } finally {
      cancellation.dispose();
    }
  }

  Stream<List<int>> _readBody(
    _JsReadableStream? body,
    CancellationToken cancellationToken,
  ) async* {
    if (body == null) {
      return;
    }
    final reader = body.getReader();
    final cancellation = cancellationToken.register((_) {
      unawaited(
        reader.cancel().toDart.then<void>((_) {}, onError: (Object _) {}),
      );
    });
    try {
      while (true) {
        cancellationToken.throwIfCancelled();
        final result = await reader.read().toDart;
        if (result.done.toDart) {
          return;
        }
        final value = result.value;
        if (value != null) {
          yield List<int>.unmodifiable(value.toDart);
        }
      }
    } finally {
      cancellation.dispose();
      reader.releaseLock();
    }
  }

  @override
  Future<void> close() async {
    _closed = true;
  }
}

@JS('fetch')
external JSPromise<_JsResponse> _fetch(JSString input, [_JsRequestInit? init]);

@JS()
extension type _JsRequestInit._(JSObject _) implements JSObject {
  external factory _JsRequestInit({
    JSString? method,
    _JsHeaders? headers,
    JSAny? body,
    JSString? credentials,
    JSObject? signal,
  });
}

@JS('Headers')
extension type _JsHeaders._(JSObject _) implements JSObject {
  external factory _JsHeaders();

  external void append(JSString name, JSString value);

  external JSString? get(JSString name);
}

@JS()
extension type _JsResponse(JSObject _) implements JSObject {
  external JSNumber get status;

  external JSString get statusText;

  external _JsHeaders get headers;

  external _JsReadableStream? get body;
}

@JS()
extension type _JsReadableStream(JSObject _) implements JSObject {
  external _JsReader getReader();
}

@JS()
extension type _JsReader(JSObject _) implements JSObject {
  external JSPromise<_JsReadResult> read();

  external JSPromise<JSAny?> cancel();

  external void releaseLock();
}

@JS()
extension type _JsReadResult(JSObject _) implements JSObject {
  external JSBoolean get done;

  external JSUint8Array? get value;
}

@JS('AbortController')
extension type _JsAbortController._(JSObject _) implements JSObject {
  external factory _JsAbortController();

  external JSObject get signal;

  external void abort();
}
