import 'batch.dart';
import 'error.dart';
import 'id.dart';
import 'message.dart';
import 'params.dart';

/// Presence-aware manual JSON-RPC envelope and batch codec.
///
/// Generated DTO codecs are unsuitable here because JSON-RPC distinguishes
/// missing members from explicit JSON `null`, and because a response must
/// contain exactly one of `result` and `error`.
class JsonRpcCodec {
  /// Creates a codec.
  const JsonRpcCodec();

  /// Decodes one strict JSON-RPC message.
  JsonRpcMessage decodeMessage(Object? value) {
    final Map<String, Object?>? object = asJsonObject(value);
    if (object == null) {
      throw JsonRpcFormatException('JSON-RPC message must be an object', value);
    }
    if (isRequest(value)) {
      return JsonRpcRequest(
        id: JsonRpcId.fromJson(object['id']),
        method: object['method']! as String,
        params: _params(object),
      );
    }
    if (isResponse(value)) {
      final JsonRpcId id = JsonRpcId.fromJson(object['id']);
      if (object.containsKey('result')) {
        return JsonRpcSuccessResponse(id: id, result: object['result']);
      }
      return JsonRpcErrorResponse(id: id, error: decodeError(object['error']));
    }
    if (isNotification(value)) {
      return JsonRpcNotification(
        method: object['method']! as String,
        params: _params(object),
      );
    }
    throw JsonRpcFormatException('Malformed JSON-RPC message', value);
  }

  /// Decodes one strict individual or batch transport frame.
  JsonRpcWireMessage decodeWireMessage(Object? value) {
    if (value is! List<Object?>) {
      return decodeMessage(value);
    }
    if (value.isEmpty) {
      throw JsonRpcFormatException('JSON-RPC batch must not be empty', value);
    }
    final List<JsonRpcMessage> messages = value
        .map<JsonRpcMessage>(decodeMessage)
        .toList(growable: false);
    try {
      return JsonRpcBatch(messages);
    } on ArgumentError catch (error) {
      throw JsonRpcFormatException(error.message.toString(), value);
    }
  }

  /// Decodes and validates an error object.
  JsonRpcErrorObject decodeError(Object? value) {
    final Map<String, Object?>? object = asJsonObject(value);
    if (object == null) {
      throw JsonRpcFormatException('JSON-RPC error must be an object', value);
    }
    final Object? rawCode = object['code'];
    final Object? rawMessage = object['message'];
    if (rawCode is! num ||
        !rawCode.isFinite ||
        rawCode != rawCode.truncate() ||
        rawCode < JsonRpcErrorObject.minimumCode ||
        rawCode > JsonRpcErrorObject.maximumCode ||
        rawMessage is! String) {
      throw JsonRpcFormatException(
        'JSON-RPC error requires a signed 32-bit integer code and '
        'string message',
        value,
      );
    }
    return JsonRpcErrorObject(
      code: rawCode.toInt(),
      message: rawMessage,
      data: object['data'],
      hasData: object.containsKey('data'),
    );
  }

  /// Whether [value] is a strict JSON-RPC request.
  bool isRequest(Object? value) {
    final Map<String, Object?>? object = asJsonObject(value);
    return object != null &&
        object['jsonrpc'] == '2.0' &&
        object.containsKey('id') &&
        object['method'] is String &&
        tryDecodeId(object['id']) != null;
  }

  /// Whether [value] is a strict JSON-RPC notification.
  bool isNotification(Object? value) {
    final Map<String, Object?>? object = asJsonObject(value);
    return object != null &&
        object['jsonrpc'] == '2.0' &&
        !object.containsKey('id') &&
        object['method'] is String;
  }

  /// Whether [value] is a strict JSON-RPC response.
  bool isResponse(Object? value) {
    final Map<String, Object?>? object = asJsonObject(value);
    if (object == null ||
        object['jsonrpc'] != '2.0' ||
        object.containsKey('method') ||
        !object.containsKey('id') ||
        tryDecodeId(object['id']) == null) {
      return false;
    }
    final bool hasResult = object.containsKey('result');
    final bool hasError = object.containsKey('error');
    if (hasResult == hasError) {
      return false;
    }
    if (!hasError) {
      return true;
    }
    try {
      decodeError(object['error']);
      return true;
    } on JsonRpcFormatException {
      return false;
    }
  }

  /// Whether [value] is a strict individual JSON-RPC message.
  bool isMessage(Object? value) =>
      isRequest(value) || isNotification(value) || isResponse(value);

  /// Whether [value] is a strict non-empty homogeneous JSON-RPC batch.
  bool isBatch(Object? value) {
    if (value is! List<Object?> || value.isEmpty) {
      return false;
    }
    return value.every(
          (Object? item) => isRequest(item) || isNotification(item),
        ) ||
        value.every(isResponse);
  }

  /// Whether an object has a response shape, even if malformed.
  bool isResponseShaped(Object? value) {
    final Map<String, Object?>? object = asJsonObject(value);
    return object != null &&
        !object.containsKey('method') &&
        (object.containsKey('id') ||
            object.containsKey('result') ||
            object.containsKey('error'));
  }

  /// Classifies a potentially malformed batch as response-directed.
  ///
  /// Valid calls take precedence. Otherwise a valid response establishes
  /// response semantics. Shape hints are used only when no valid message is
  /// available, preventing malformed responses from causing reply loops.
  bool isResponseBatch(List<Object?> batch) {
    bool hasValidCall = false;
    bool hasValidResponse = false;
    bool hasCallShape = false;
    bool hasResponseShape = false;

    for (final Object? item in batch) {
      hasValidCall = hasValidCall || isRequest(item) || isNotification(item);
      hasValidResponse = hasValidResponse || isResponse(item);
      final Map<String, Object?>? object = asJsonObject(item);
      if (object == null) {
        continue;
      }
      hasCallShape = hasCallShape || object.containsKey('method');
      hasResponseShape =
          hasResponseShape ||
          object.containsKey('result') ||
          object.containsKey('error');
    }
    if (hasValidCall) {
      return false;
    }
    if (hasValidResponse) {
      return true;
    }
    return hasResponseShape && !hasCallShape;
  }

  /// Attempts to decode an ID, returning `null` for invalid values.
  JsonRpcId? tryDecodeId(Object? value) {
    try {
      return JsonRpcId.fromJson(value);
    } on FormatException {
      return null;
    }
  }

  /// Returns a string-keyed JSON object view or `null`.
  Map<String, Object?>? asJsonObject(Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is! Map<Object?, Object?>) {
      return null;
    }
    final Map<String, Object?> result = <String, Object?>{};
    for (final MapEntry<Object?, Object?> entry in value.entries) {
      final Object? key = entry.key;
      if (key is! String) {
        return null;
      }
      result[key] = entry.value;
    }
    return result;
  }

  JsonRpcParams _params(Map<String, Object?> object) =>
      object.containsKey('params')
      ? JsonRpcParams.value(object['params'])
      : const JsonRpcParams.absent();
}

/// A JSON-RPC codec that also enforces ACP method-name ownership.
///
/// Core method names must be registered with this codec. Unregistered custom
/// methods and notifications are accepted only when they begin with `_`.
final class AcpJsonRpcCodec extends JsonRpcCodec {
  /// Creates an ACP codec for one protocol side's known methods.
  AcpJsonRpcCodec({required Iterable<String> protocolMethods})
    : protocolMethods = Set<String>.unmodifiable(protocolMethods) {
    if (this.protocolMethods.any((String method) => method.isEmpty)) {
      throw ArgumentError.value(
        protocolMethods,
        'protocolMethods',
        'must not contain an empty method',
      );
    }
  }

  /// The JSON-RPC cancellation control method used by ACP transports.
  static const String cancelRequestMethod = r'$/cancel_request';

  /// Known non-extension methods for this protocol side.
  final Set<String> protocolMethods;

  /// Whether [method] is a known protocol, control, or extension method.
  bool isAllowedMethod(String method) =>
      protocolMethods.contains(method) ||
      method == cancelRequestMethod ||
      (method.length > 1 && method.startsWith('_'));

  /// Validates a method before writing it to the wire.
  void validateMethod(String method) {
    if (!isAllowedMethod(method)) {
      throw ArgumentError.value(
        method,
        'method',
        'must be a registered ACP method or start with "_"',
      );
    }
  }

  @override
  JsonRpcMessage decodeMessage(Object? value) {
    final Map<String, Object?>? object = asJsonObject(value);
    final Object? method = object?['method'];
    if (method is String && !isAllowedMethod(method)) {
      throw JsonRpcFormatException(
        'Unregistered ACP method must start with "_"',
        value,
      );
    }
    return super.decodeMessage(value);
  }

  @override
  bool isRequest(Object? value) {
    final Map<String, Object?>? object = asJsonObject(value);
    final Object? method = object?['method'];
    return method is String &&
        isAllowedMethod(method) &&
        super.isRequest(value);
  }

  @override
  bool isNotification(Object? value) {
    final Map<String, Object?>? object = asJsonObject(value);
    final Object? method = object?['method'];
    return method is String &&
        isAllowedMethod(method) &&
        super.isNotification(value);
  }
}
