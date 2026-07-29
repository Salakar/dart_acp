import 'error.dart';
import 'id.dart';
import 'params.dart';

/// A JSON-RPC value that can occupy one transport frame.
abstract interface class JsonRpcWireMessage {
  /// Encodes the value to a JSON-compatible representation.
  Object toJson();
}

/// A single JSON-RPC message.
sealed class JsonRpcMessage implements JsonRpcWireMessage {
  const JsonRpcMessage();
}

/// A JSON-RPC request.
final class JsonRpcRequest extends JsonRpcMessage {
  /// Creates a request.
  const JsonRpcRequest({
    required this.id,
    required this.method,
    this.params = const JsonRpcParams.absent(),
  });

  /// The response correlation identifier.
  final JsonRpcId id;

  /// The method name.
  final String method;

  /// Optional request params.
  final JsonRpcParams params;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'jsonrpc': '2.0',
    'id': id.toJson(),
    'method': method,
    if (params.isPresent) 'params': params.value,
  };
}

/// A JSON-RPC notification.
final class JsonRpcNotification extends JsonRpcMessage {
  /// Creates a notification.
  const JsonRpcNotification({
    required this.method,
    this.params = const JsonRpcParams.absent(),
  });

  /// The method name.
  final String method;

  /// Optional notification params.
  final JsonRpcParams params;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'jsonrpc': '2.0',
    'method': method,
    if (params.isPresent) 'params': params.value,
  };
}

/// A JSON-RPC response.
sealed class JsonRpcResponse extends JsonRpcMessage {
  const JsonRpcResponse(this.id);

  /// The request identifier this response resolves.
  final JsonRpcId id;
}

/// A successful JSON-RPC response.
final class JsonRpcSuccessResponse extends JsonRpcResponse {
  /// Creates a successful response.
  const JsonRpcSuccessResponse({required JsonRpcId id, required this.result})
    : super(id);

  /// The successful result, including JSON `null`.
  final Object? result;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'jsonrpc': '2.0',
    'id': id.toJson(),
    'result': result,
  };
}

/// A failed JSON-RPC response.
final class JsonRpcErrorResponse extends JsonRpcResponse {
  /// Creates a failed response.
  const JsonRpcErrorResponse({required JsonRpcId id, required this.error})
    : super(id);

  /// The error payload.
  final JsonRpcErrorObject error;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'jsonrpc': '2.0',
    'id': id.toJson(),
    'error': error.toJson(),
  };
}
