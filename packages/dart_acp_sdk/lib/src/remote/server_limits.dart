/// Bounded resource settings shared by experimental remote ACP servers.
final class AcpRemoteServerLimits {
  /// Creates server limits.
  const AcpRemoteServerLimits({
    this.maximumBodyBytes = 16 * 1024 * 1024,
    this.maximumSessions = 10000,
    this.maximumPendingRoutes = 4096,
    this.outboundQueueCapacity = 1024,
    this.maximumWebSocketFrameBytes = 16 * 1024 * 1024,
    this.maximumJsonNestingDepth = 128,
    this.initializeTimeout = const Duration(seconds: 30),
    this.sseKeepAliveInterval = const Duration(seconds: 15),
  });

  /// Maximum decoded HTTP request-body bytes.
  final int maximumBodyBytes;

  /// Maximum session routes retained by one connection.
  final int maximumSessions;

  /// Maximum pending request routes or handshake response waiters.
  final int maximumPendingRoutes;

  /// Maximum replay and paused-subscriber values per outbound hub.
  final int outboundQueueCapacity;

  /// Maximum UTF-8 or binary WebSocket frame bytes.
  final int maximumWebSocketFrameBytes;

  /// Maximum structural object/array nesting in an inbound JSON payload.
  final int maximumJsonNestingDepth;

  /// Maximum time allowed for authorization/preflight and initialization.
  final Duration initializeTimeout;

  /// Idle interval between demand-aware SSE keepalive comments.
  final Duration sseKeepAliveInterval;

  /// Validates every limit at runtime.
  ///
  /// Const constructor assertions are useful during development but may be
  /// disabled in production, so server entry points call this method too.
  void validate() {
    _requirePositive(maximumBodyBytes, 'maximumBodyBytes');
    _requirePositive(maximumSessions, 'maximumSessions');
    _requirePositive(maximumPendingRoutes, 'maximumPendingRoutes');
    _requirePositive(outboundQueueCapacity, 'outboundQueueCapacity');
    _requirePositive(maximumWebSocketFrameBytes, 'maximumWebSocketFrameBytes');
    _requirePositive(maximumJsonNestingDepth, 'maximumJsonNestingDepth');
    _requirePositiveDuration(initializeTimeout, 'initializeTimeout');
    _requirePositiveDuration(sseKeepAliveInterval, 'sseKeepAliveInterval');
  }

  static void _requirePositive(int value, String name) {
    if (value <= 0) {
      throw ArgumentError.value(value, name, 'must be positive');
    }
  }

  static void _requirePositiveDuration(Duration value, String name) {
    if (value <= Duration.zero) {
      throw ArgumentError.value(value, name, 'must be positive');
    }
  }
}
