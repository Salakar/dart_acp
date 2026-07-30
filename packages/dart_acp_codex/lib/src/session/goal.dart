/// Goal lifecycle state.
enum CodexGoalStatus {
  /// The goal can drive work.
  active,

  /// The goal is paused.
  paused,

  /// The goal completed.
  completed,

  /// The goal was cancelled.
  cancelled,
}

/// Immutable goal snapshot.
final class CodexGoalSnapshot {
  /// Creates a goal snapshot.
  const CodexGoalSnapshot({
    required this.objective,
    required this.status,
    required this.timeUsed,
    required this.createdAt,
    this.tokenBudget,
  });

  /// Trimmed goal objective.
  final String objective;

  /// Goal state.
  final CodexGoalStatus status;

  /// Optional token budget.
  final int? tokenBudget;

  /// Elapsed goal time.
  final Duration timeUsed;

  /// Goal creation time.
  final DateTime createdAt;

  /// Whether [other] is the same observable goal state.
  bool sameState(CodexGoalSnapshot other) =>
      objective == other.objective &&
      status == other.status &&
      tokenBudget == other.tokenBudget &&
      createdAt == other.createdAt;
}

/// Goal-control action.
enum CodexGoalAction {
  /// Pause the active goal.
  pause,

  /// Clear the goal.
  clear,
}
