/// The negotiated ACP protocol generation.
enum AcpProtocolGeneration {
  /// Stable ACP v1.
  v1(1),

  /// Draft ACP v2.
  v2(2);

  const AcpProtocolGeneration(this.wireValue);

  /// The integer sent during initialization.
  final int wireValue;
}

/// The stability of a generated protocol method.
enum AcpMethodStability {
  /// A stable v1 method.
  stable,

  /// A method in the draft-v2 baseline.
  draft,

  /// An opt-in method from an unstable schema overlay.
  unstable,
}

/// The side that sends a protocol method.
enum AcpMethodDirection {
  /// The client sends the method to the agent.
  clientToAgent,

  /// The agent sends the method to the client.
  agentToClient,

  /// Either peer may send the protocol-level method.
  either,
}

/// Whether a JSON-RPC method expects a response.
enum AcpMethodKind {
  /// A request that expects exactly one response.
  request,

  /// A one-way notification.
  notification,
}

/// Encodes and decodes one concrete protocol value type.
abstract interface class AcpCodec<T> {
  /// Decodes a JSON-compatible wire value.
  T decode(Object? value);

  /// Encodes a value to JSON-compatible Dart objects.
  Object? encode(T value);
}

/// The explicit result type used by notification descriptors.
final class AcpNoResult {
  /// Creates the single notification no-result value.
  const AcpNoResult();
}

/// Codec for the explicit notification no-result type.
final class AcpNoResultCodec implements AcpCodec<AcpNoResult> {
  /// Creates a no-result codec.
  const AcpNoResultCodec();

  @override
  AcpNoResult decode(Object? value) {
    if (value != null) {
      throw const FormatException('A notification cannot have a result');
    }
    return const AcpNoResult();
  }

  @override
  Object? encode(AcpNoResult value) => null;
}

/// The shared no-result codec for generated notification descriptors.
const AcpNoResultCodec acpNoResultCodec = AcpNoResultCodec();

/// A unique method-registry key.
final class AcpMethodKey {
  /// Creates a method key.
  const AcpMethodKey({
    required this.name,
    required this.direction,
    required this.kind,
  });

  /// The exact JSON-RPC method string.
  final String name;

  /// The direction in which the method travels.
  final AcpMethodDirection direction;

  /// Whether the message expects a response.
  final AcpMethodKind kind;

  @override
  bool operator ==(Object other) =>
      other is AcpMethodKey &&
      other.name == name &&
      other.direction == direction &&
      other.kind == kind;

  @override
  int get hashCode => Object.hash(name, direction, kind);

  @override
  String toString() => '$direction $kind $name';
}

/// Type-erased schema facts shared by all method descriptors.
abstract interface class AcpMethodDescriptorBase {
  /// The exact JSON-RPC method string.
  String get name;

  /// The deterministic Dart-style identifier for the method.
  String get dartName;

  /// The negotiated protocol generation.
  AcpProtocolGeneration get protocol;

  /// The stability lane containing this method.
  AcpMethodStability get stability;

  /// The direction in which this method travels.
  AcpMethodDirection get direction;

  /// Whether this is a request or notification.
  AcpMethodKind get kind;

  /// The schema definition containing request or notification parameters.
  String get paramsDefinition;

  /// The correlated response definition, or `null` for a notification.
  String? get resultDefinition;

  /// The dotted capability path required before sending, when applicable.
  String? get capabilityPath;

  /// Schema-derived documentation for the parameter definition.
  String? get documentation;

  /// The unique registry key.
  AcpMethodKey get key;
}

/// Schema-derived facts for one ACP request or notification.
///
/// Generic parameters preserve the compile-time correlation between concrete
/// parameter and result models.
final class AcpMethodDescriptor<P, R> implements AcpMethodDescriptorBase {
  /// Creates a method descriptor.
  const AcpMethodDescriptor({
    required this.name,
    required this.dartName,
    required this.protocol,
    required this.stability,
    required this.direction,
    required this.kind,
    required this.paramsDefinition,
    required this.paramsCodec,
    required this.resultCodec,
    this.resultDefinition,
    this.capabilityPath,
    this.documentation,
  });

  /// The exact JSON-RPC method string.
  @override
  final String name;

  /// The deterministic Dart-style identifier for the method.
  @override
  final String dartName;

  /// The negotiated protocol generation.
  @override
  final AcpProtocolGeneration protocol;

  /// The stability lane containing this method.
  @override
  final AcpMethodStability stability;

  /// The direction in which this method travels.
  @override
  final AcpMethodDirection direction;

  /// Whether this is a request or notification.
  @override
  final AcpMethodKind kind;

  /// The schema definition containing request or notification parameters.
  @override
  final String paramsDefinition;

  /// The concrete parameter codec.
  final AcpCodec<P> paramsCodec;

  /// The concrete result codec.
  final AcpCodec<R> resultCodec;

  /// The correlated response definition, or `null` for a notification.
  @override
  final String? resultDefinition;

  /// The dotted capability path required before sending, when applicable.
  @override
  final String? capabilityPath;

  /// Schema-derived documentation for the parameter definition.
  @override
  final String? documentation;

  /// The unique registry key.
  @override
  AcpMethodKey get key =>
      AcpMethodKey(name: name, direction: direction, kind: kind);

  /// Whether callers must expect a JSON-RPC response.
  bool get expectsResponse => kind == AcpMethodKind.request;
}

/// An immutable, duplicate-checked collection of method descriptors.
final class AcpMethodRegistry {
  /// Creates a registry and rejects duplicate method keys.
  AcpMethodRegistry(Iterable<AcpMethodDescriptorBase> descriptors)
    : _descriptors = _index(descriptors);

  final Map<AcpMethodKey, AcpMethodDescriptorBase> _descriptors;

  /// All descriptors in deterministic key order.
  Iterable<AcpMethodDescriptorBase> get descriptors => _descriptors.values;

  /// Finds the descriptor for an exact method key.
  AcpMethodDescriptorBase? lookup({
    required String name,
    required AcpMethodDirection direction,
    required AcpMethodKind kind,
  }) =>
      _descriptors[AcpMethodKey(name: name, direction: direction, kind: kind)];

  /// Finds every descriptor having the exact wire [name].
  Iterable<AcpMethodDescriptorBase> named(String name) => _descriptors.values
      .where((AcpMethodDescriptorBase descriptor) => descriptor.name == name);

  static Map<AcpMethodKey, AcpMethodDescriptorBase> _index(
    Iterable<AcpMethodDescriptorBase> descriptors,
  ) {
    final sorted = descriptors.toList(growable: false)
      ..sort((AcpMethodDescriptorBase left, AcpMethodDescriptorBase right) {
        final int byName = left.name.compareTo(right.name);
        if (byName != 0) {
          return byName;
        }
        final int byDirection = left.direction.index.compareTo(
          right.direction.index,
        );
        return byDirection != 0
            ? byDirection
            : left.kind.index.compareTo(right.kind.index);
      });
    final indexed = <AcpMethodKey, AcpMethodDescriptorBase>{};
    for (final AcpMethodDescriptorBase descriptor in sorted) {
      if (indexed.containsKey(descriptor.key)) {
        throw StateError('Duplicate ACP method descriptor: ${descriptor.key}');
      }
      indexed[descriptor.key] = descriptor;
    }
    return Map<AcpMethodKey, AcpMethodDescriptorBase>.unmodifiable(indexed);
  }
}
