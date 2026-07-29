import 'cancellation.dart';
import 'message.dart';
import 'params.dart';

/// A non-empty homogeneous JSON-RPC batch wire frame.
final class JsonRpcBatch implements JsonRpcWireMessage {
  /// Creates a validated batch.
  JsonRpcBatch(Iterable<JsonRpcMessage> messages)
    : messages = List<JsonRpcMessage>.unmodifiable(messages) {
    if (this.messages.isEmpty) {
      throw ArgumentError.value(messages, 'messages', 'must not be empty');
    }
    final bool containsResponse = this.messages.any(
      (JsonRpcMessage message) => message is JsonRpcResponse,
    );
    final bool containsCall = this.messages.any(
      (JsonRpcMessage message) => message is! JsonRpcResponse,
    );
    if (containsResponse && containsCall) {
      throw ArgumentError.value(
        messages,
        'messages',
        'must not mix calls and responses',
      );
    }
  }

  /// The batch messages.
  final List<JsonRpcMessage> messages;

  /// Whether this is a response batch.
  bool get isResponseBatch => messages.first is JsonRpcResponse;

  @override
  List<Object> toJson() => List<Object>.unmodifiable(
    messages.map((JsonRpcMessage message) => message.toJson()),
  );
}

/// One descriptor accepted by an outgoing batch.
sealed class JsonRpcBatchEntry {
  const JsonRpcBatchEntry();
}

/// An outgoing request in a batch.
final class JsonRpcBatchRequest<T> extends JsonRpcBatchEntry {
  /// Creates a batch request.
  const JsonRpcBatchRequest({
    required this.method,
    this.params = const JsonRpcParams.absent(),
    this.decode,
    this.cancellationToken,
  });

  /// The method name.
  final String method;

  /// Optional request params.
  final JsonRpcParams params;

  /// Converts the raw successful result.
  final T Function(Object? value)? decode;

  /// Cooperatively requests peer cancellation when cancelled.
  final CancellationToken? cancellationToken;
}

/// An outgoing notification in a batch.
final class JsonRpcBatchNotification extends JsonRpcBatchEntry {
  /// Creates a batch notification.
  const JsonRpcBatchNotification({
    required this.method,
    this.params = const JsonRpcParams.absent(),
  });

  /// The method name.
  final String method;

  /// Optional notification params.
  final JsonRpcParams params;
}
