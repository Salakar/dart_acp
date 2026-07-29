part of 'router.dart';

const int _maximumProtocolVersion = 0xffff;
const JsonRpcCodec _routerCodec = JsonRpcCodec();

extension _AcpProtocolRouting on AcpProtocolRouter {
  Future<void> _route(
    AcpDuplexStream<Object?> stream,
    AcpRoutedAgentConnection lifecycle,
  ) async {
    final StreamIterator<Object?> source = StreamIterator<Object?>(
      stream.readable,
    );
    bool handedOff = false;
    try {
      if (!await source.moveNext()) {
        await lifecycle._closeOutput();
        lifecycle._finish();
        return;
      }
      final Object? first = source.current;
      if (_shouldCloseSilently(first)) {
        await source.cancel();
        await lifecycle._closeOutput();
        lifecycle._finish();
        return;
      }

      bool batched = false;
      Object? message = first;
      if (first is List<Object?>) {
        if (first.length == 1 &&
            _routerCodec.isRequest(first.first) &&
            (_jsonObject(first.first)?['method'] == 'initialize')) {
          batched = true;
          message = first.first;
        } else {
          await _reject(
            source,
            stream.writable,
            id: null,
            error: JsonRpcRequestException.invalidRequest(
              data: 'first ACP message must be an initialize request',
            ),
          );
          lifecycle._finish();
          return;
        }
      }

      final Map<String, Object?>? request = _jsonObject(message);
      if (!_routerCodec.isRequest(message) || request == null) {
        await _reject(
          source,
          stream.writable,
          id: null,
          error: JsonRpcRequestException.invalidRequest(
            data: 'first ACP message must be an initialize request',
          ),
        );
        lifecycle._finish();
        return;
      }
      if (request['method'] != 'initialize') {
        await _reject(
          source,
          stream.writable,
          id: request['id'],
          error: JsonRpcRequestException.invalidRequest(
            data: 'first ACP request must be initialize',
          ),
          batched: batched,
        );
        lifecycle._finish();
        return;
      }

      final Map<String, Object?>? params = _jsonObject(request['params']);
      final int? requested = _protocolVersion(params?['protocolVersion']);
      if (params == null || requested == null) {
        await _reject(
          source,
          stream.writable,
          id: request['id'],
          error: JsonRpcRequestException.invalidParams(
            data:
                'initialize.protocolVersion must be a valid ACP protocol '
                'version',
          ),
          batched: batched,
        );
        lifecycle._finish();
        return;
      }

      final int? selected = _negotiatedVersion(requested);
      if (selected == null) {
        await _reject(
          source,
          stream.writable,
          id: request['id'],
          error: JsonRpcRequestException.invalidRequest(
            data:
                'unsupported ACP protocol version $requested; this endpoint '
                'supports ${_supportedDescription()}',
          ),
          batched: batched,
        );
        lifecycle._finish();
        return;
      }

      late final Map<String, Object?> rewrittenParams;
      try {
        rewrittenParams = _rewriteInitializeParams(params, requested, selected);
      } on Object catch (error) {
        await _reject(
          source,
          stream.writable,
          id: request['id'],
          error: JsonRpcRequestException.invalidParams(
            data: 'invalid initialize params: ${error.runtimeType}',
          ),
          batched: batched,
        );
        lifecycle._finish();
        return;
      }

      final Map<String, Object?> initialize = <String, Object?>{
        ...request,
        'params': rewrittenParams,
      };
      final Object routedFirst = batched && selected == 2
          ? <Object?>[initialize]
          : initialize;
      final AcpWritable<Object?> destination = batched && selected == 1
          ? _batchInitializeResponseWritable(stream.writable, request['id'])
          : stream.writable;
      final routedStream = AcpDuplexStream<Object?>(
        readable: _routedReadable(source, routedFirst),
        writable: destination,
      );
      handedOff = true;
      if (selected == 2) {
        final AcpV2AgentApp agent = _v2!;
        final AcpV2AgentConnection connection = agent.connect(
          routedStream,
          connectOptions: const AcpV2ConnectOptions(deferConnectHandlers: true),
        );
        lifecycle._attach(_AcpSelectedV2Connection(connection), 2);
      } else {
        final AcpAgentApp agent = _v1!;
        final AcpAgentConnection connection = agent.connect(
          routedStream,
          connectOptions: const AcpConnectOptions(deferConnectHandlers: true),
        );
        lifecycle._attach(_AcpSelectedV1Connection(connection), 1);
      }
    } on Object {
      if (!handedOff) {
        await source.cancel();
      }
      rethrow;
    }
  }
}

bool _shouldCloseSilently(Object? message) {
  if (message is! List<Object?>) {
    return _routerCodec.isNotification(message) ||
        _routerCodec.isResponseShaped(message);
  }
  return message.isNotEmpty &&
      (_routerCodec.isResponseBatch(message) ||
          message.every(
            (Object? item) =>
                _routerCodec.isNotification(item) ||
                _routerCodec.isResponse(item),
          ));
}

int? _protocolVersion(Object? value) {
  if (value is! num ||
      !value.isFinite ||
      value != value.truncate() ||
      value < 0 ||
      value > _maximumProtocolVersion) {
    return null;
  }
  return value.toInt();
}

Stream<Object?> _routedReadable(
  StreamIterator<Object?> source,
  Object first,
) async* {
  try {
    yield first;
    while (await source.moveNext()) {
      yield source.current;
    }
  } finally {
    await source.cancel();
  }
}

AcpWritable<Object?> _batchInitializeResponseWritable(
  AcpWritable<Object?> destination,
  Object? initializeId,
) {
  bool responseFramed = false;
  return AcpWritable<Object?>(
    write: (Object? value) {
      Object? outgoing = value;
      final Map<String, Object?>? object = _jsonObject(value);
      if (!responseFramed &&
          object != null &&
          _routerCodec.isResponseShaped(object) &&
          object.containsKey('id') &&
          object['id'] == initializeId) {
        responseFramed = true;
        outgoing = <Object?>[value];
      }
      return destination.write(outgoing);
    },
    close: destination.close,
  );
}

Future<void> _reject(
  StreamIterator<Object?> source,
  AcpWritable<Object?> writable, {
  required Object? id,
  required JsonRpcRequestException error,
  bool batched = false,
}) async {
  final Map<String, Object?> response = <String, Object?>{
    'jsonrpc': '2.0',
    'id': id,
    'error': error.error.toJson(),
  };
  try {
    await writable.write(batched ? <Object?>[response] : response);
    await writable.close();
  } finally {
    await source.cancel();
  }
}
