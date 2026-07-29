/// The optional `params` member of a JSON-RPC call.
sealed class JsonRpcParams {
  const JsonRpcParams();

  /// Omits `params` from the wire object.
  const factory JsonRpcParams.absent() = AbsentJsonRpcParams;

  /// Includes [value] as `params`, including when [value] is `null`.
  const factory JsonRpcParams.value(Object? value) = PresentJsonRpcParams;

  /// Whether the wire object contains a `params` member.
  bool get isPresent;

  /// The member value, or `null` when absent or explicitly null.
  Object? get value;
}

/// An omitted JSON-RPC `params` member.
final class AbsentJsonRpcParams extends JsonRpcParams {
  /// Creates an omitted params value.
  const AbsentJsonRpcParams();

  @override
  bool get isPresent => false;

  @override
  Object? get value => null;
}

/// A present JSON-RPC `params` member.
final class PresentJsonRpcParams extends JsonRpcParams {
  /// Creates a present params value.
  const PresentJsonRpcParams(this.value);

  @override
  final Object? value;

  @override
  bool get isPresent => true;
}
