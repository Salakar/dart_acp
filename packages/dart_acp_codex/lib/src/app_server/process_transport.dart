import 'package:dart_acp_sdk/dart_acp_sdk.dart';

/// Adapts app-server JSON-RPC compatibility framing to the strict SDK codec.
AcpDuplexStream<Object?> normalizedAppServerStream(
  AcpDuplexStream<Object?> stream,
) {
  return AcpDuplexStream<Object?>(
    readable: stream.readable.map<Object?>(_addJsonRpcVersion),
    writable: AcpWritable<Object?>(
      write: (value) => stream.writable.write(_removeJsonRpcVersion(value)),
      close: stream.writable.close,
    ),
  );
}

Object? _addJsonRpcVersion(Object? value) {
  if (value is List<Object?>) {
    return List<Object?>.unmodifiable(value.map<Object?>(_addJsonRpcVersion));
  }
  if (value is! Map<Object?, Object?>) {
    return value;
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key case final String key) {
      result[key] = entry.value;
    } else {
      return value;
    }
  }
  result.putIfAbsent('jsonrpc', () => '2.0');
  return result;
}

Object? _removeJsonRpcVersion(Object? value) {
  if (value is List<Object?>) {
    return List<Object?>.unmodifiable(
      value.map<Object?>(_removeJsonRpcVersion),
    );
  }
  if (value is! Map<Object?, Object?>) {
    return value;
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key case final String key when key != 'jsonrpc') {
      result[key] = entry.value;
    }
  }
  return result;
}
