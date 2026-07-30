/// Token usage for a completed or active turn.
final class CodexUsage {
  /// Creates token usage.
  const CodexUsage({
    required this.totalTokens,
    required this.inputTokens,
    required this.cachedInputTokens,
    required this.outputTokens,
    required this.reasoningOutputTokens,
  }) : assert(totalTokens >= 0),
       assert(inputTokens >= 0),
       assert(cachedInputTokens >= 0),
       assert(outputTokens >= 0),
       assert(reasoningOutputTokens >= 0);

  /// Total tokens reported by the service.
  final int totalTokens;

  /// Non-cached input tokens.
  final int inputTokens;

  /// Cached input tokens.
  final int cachedInputTokens;

  /// Output tokens, including reasoning output.
  final int outputTokens;

  /// Reasoning output tokens.
  final int reasoningOutputTokens;

  /// Builds usage from a breakdown whose input count includes cached input.
  factory CodexUsage.fromInclusiveInput({
    required int totalTokens,
    required int inputTokens,
    required int cachedInputTokens,
    required int outputTokens,
    required int reasoningOutputTokens,
  }) {
    final nonCached = inputTokens - cachedInputTokens;
    if (nonCached < 0) {
      throw ArgumentError.value(
        inputTokens,
        'inputTokens',
        'must be at least cachedInputTokens',
      );
    }
    return CodexUsage(
      totalTokens: totalTokens,
      inputTokens: nonCached,
      cachedInputTokens: cachedInputTokens,
      outputTokens: outputTokens,
      reasoningOutputTokens: reasoningOutputTokens,
    );
  }
}

/// A rate-limit window.
final class CodexRateLimit {
  /// Creates a rate-limit snapshot.
  const CodexRateLimit({
    required this.usedPercent,
    this.windowDuration,
    this.resetsAt,
  });

  /// Percentage already consumed.
  final double usedPercent;

  /// Window duration.
  final Duration? windowDuration;

  /// Reset timestamp.
  final DateTime? resetsAt;
}
