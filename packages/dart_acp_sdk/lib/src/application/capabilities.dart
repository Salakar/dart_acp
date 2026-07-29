part of 'application.dart';

/// Immutable peer capabilities negotiated during initialization.
final class AcpPeerCapabilities {
  /// Creates capabilities from an immutable JSON object.
  const AcpPeerCapabilities(this.value);

  /// Creates an empty capability set.
  factory AcpPeerCapabilities.empty() =>
      AcpPeerCapabilities(AcpJsonObject(const <String, AcpJsonValue>{}));

  /// The complete capability object.
  final AcpJsonObject value;

  /// Whether a dotted capability [path] is advertised.
  bool supports(String? path) {
    if (path == null || path.isEmpty) {
      return true;
    }
    AcpJsonValue current = value;
    for (final String segment in path.split('.')) {
      if (current is! AcpJsonObject) {
        return false;
      }
      final AcpJsonValue? next = current[segment];
      if (next == null) {
        return false;
      }
      current = next;
    }
    return switch (current) {
      AcpJsonBoolean(:final bool value) => value,
      AcpJsonNull() => false,
      _ => true,
    };
  }

  /// Throws a local, actionable error when [path] is unavailable.
  void require(String? path, {required String method}) {
    if (!supports(path)) {
      throw AcpCapabilityUnavailableException(
        method: method,
        capabilityPath: path!,
      );
    }
  }
}

/// A request was blocked because the peer did not advertise a capability.
final class AcpCapabilityUnavailableException implements Exception {
  /// Creates a capability error.
  const AcpCapabilityUnavailableException({
    required this.method,
    required this.capabilityPath,
  });

  /// The method that was not sent.
  final String method;

  /// The required dotted capability path.
  final String capabilityPath;

  @override
  String toString() =>
      'AcpCapabilityUnavailableException: $method requires '
      '$capabilityPath';
}

/// Explicit application behavior switches.
final class AcpApplicationOptions {
  /// Creates immutable application options.
  const AcpApplicationOptions({
    this.allowUnstableMethods = false,
    this.requireInitialization = true,
    this.jsonRpcOptions = const JsonRpcConnectionOptions(allowBatches: false),
  });

  /// Whether unstable generated descriptors may be registered or sent.
  final bool allowUnstableMethods;

  /// Whether non-initialize traffic waits for initialization.
  final bool requireInitialization;

  /// JSON-RPC concurrency, queue, batch, and diagnostic configuration.
  ///
  /// Stable-v1 defaults to rejecting batches. All numeric limits are validated
  /// by [JsonRpcConnection] when a connection opens.
  final JsonRpcConnectionOptions jsonRpcOptions;

  /// Returns a modified copy.
  AcpApplicationOptions copyWith({
    bool? allowUnstableMethods,
    bool? requireInitialization,
    JsonRpcConnectionOptions? jsonRpcOptions,
  }) => AcpApplicationOptions(
    allowUnstableMethods: allowUnstableMethods ?? this.allowUnstableMethods,
    requireInitialization: requireInitialization ?? this.requireInitialization,
    jsonRpcOptions: jsonRpcOptions ?? this.jsonRpcOptions,
  );
}

/// Per-connection startup behavior.
final class AcpConnectOptions {
  /// Creates connection options.
  const AcpConnectOptions({this.deferConnectHandlers = false});

  /// Whether ready handlers are started manually by the caller.
  final bool deferConnectHandlers;
}
