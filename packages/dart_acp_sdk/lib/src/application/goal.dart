part of 'application.dart';

/// Provider-neutral actions for the ACP goal-control extension.
enum AcpGoalControlAction {
  /// Create a goal or replace its objective.
  update('update'),

  /// Pause the current goal without clearing it.
  pause('pause'),

  /// Resume a paused goal.
  resume('resume'),

  /// Remove the current goal.
  clear('clear');

  const AcpGoalControlAction(this.wireName);

  /// JSON value used by the goal-control extension.
  final String wireName;

  static AcpGoalControlAction _fromWire(Object? value) => values.firstWhere(
    (candidate) => candidate.wireName == value,
    orElse: () =>
        throw const FormatException('Invalid ACP goal-control action'),
  );
}

/// Lifecycle state reported for a provider-managed goal.
enum AcpGoalStatus {
  /// The goal can continue driving work.
  active('active'),

  /// The goal is attached to the session but temporarily paused.
  paused('paused'),

  /// The goal completed successfully.
  completed('completed'),

  /// The goal was cancelled.
  cancelled('cancelled');

  const AcpGoalStatus(this.wireName);

  /// JSON value used in goal snapshots.
  final String wireName;

  static AcpGoalStatus _fromWire(Object? value) => values.firstWhere(
    (candidate) => candidate.wireName == value,
    orElse: () => throw const FormatException('Invalid ACP goal status'),
  );
}

/// Goal actions advertised under `agentCapabilities._meta.goalControl`.
final class AcpGoalControlCapabilities {
  /// Creates an immutable action set.
  AcpGoalControlCapabilities(Iterable<AcpGoalControlAction> actions)
    : actions = Set<AcpGoalControlAction>.unmodifiable(actions);

  /// Supported goal-control actions.
  final Set<AcpGoalControlAction> actions;

  /// Whether this provider supports any goal control.
  bool get supported => actions.isNotEmpty;

  /// Whether [action] is supported.
  bool supports(AcpGoalControlAction action) => actions.contains(action);

  /// Decodes the `goalControl` capability value.
  factory AcpGoalControlCapabilities.fromJson(Object? value) {
    final json = _goalObject(value, 'goal-control capabilities');
    final rawActions = json['actions'];
    if (rawActions is! List<Object?>) {
      throw const FormatException(
        'ACP goal-control capabilities require an actions array',
      );
    }
    return AcpGoalControlCapabilities(
      rawActions.map(AcpGoalControlAction._fromWire),
    );
  }

  /// Returns `null` when [value] is not valid goal-control metadata.
  static AcpGoalControlCapabilities? tryFromJson(Object? value) {
    try {
      return AcpGoalControlCapabilities.fromJson(value);
    } on FormatException {
      return null;
    }
  }

  /// Encodes capability metadata for an initialize response.
  Map<String, Object?> toJson() => <String, Object?>{
    'supported': supported,
    'actions': <Object?>[for (final action in actions) action.wireName],
  };
}

/// Current goal state carried by `session_info_update._meta.goal`.
final class AcpGoalSnapshot {
  /// Creates a goal snapshot.
  const AcpGoalSnapshot({required this.objective, required this.status});

  /// Human-readable completion condition.
  final String objective;

  /// Current lifecycle state.
  final AcpGoalStatus status;

  /// Decodes provider-neutral session goal metadata.
  factory AcpGoalSnapshot.fromJson(Object? value) {
    final json = _goalObject(value, 'goal snapshot');
    final objective = json['objective'];
    if (objective is! String || objective.trim().isEmpty) {
      throw const FormatException(
        'ACP goal snapshot requires a non-empty objective',
      );
    }
    return AcpGoalSnapshot(
      objective: objective.trim(),
      status: AcpGoalStatus._fromWire(json['status']),
    );
  }

  /// Returns `null` when [value] is not a valid snapshot.
  static AcpGoalSnapshot? tryFromJson(Object? value) {
    try {
      return AcpGoalSnapshot.fromJson(value);
    } on FormatException {
      return null;
    }
  }

  /// Encodes session goal metadata.
  Map<String, Object?> toJson() => <String, Object?>{
    'objective': objective,
    'status': status.wireName,
  };
}

/// Parameters for the provider-neutral `_session/goal_control` extension.
final class AcpGoalControlRequest {
  /// Creates a goal-control request.
  const AcpGoalControlRequest({
    required this.sessionId,
    required this.action,
    this.objective,
  });

  /// Session whose goal should change.
  final v1.SessionId sessionId;

  /// Requested operation.
  final AcpGoalControlAction action;

  /// Replacement objective, required for [AcpGoalControlAction.update].
  final String? objective;
}

/// Shared goal-control request descriptor implemented by capable agents.
final AcpMethodDescriptor<AcpGoalControlRequest, AcpNoResult>
acpSessionGoalControlMethod =
    acpCustomRequestMethod<AcpGoalControlRequest, AcpNoResult>(
      name: '_session/goal_control',
      direction: AcpMethodDirection.clientToAgent,
      paramsCodec: const _AcpGoalControlRequestCodec(),
      resultCodec: acpNoResultCodec,
    );

final class _AcpGoalControlRequestCodec
    implements AcpCodec<AcpGoalControlRequest> {
  const _AcpGoalControlRequestCodec();

  @override
  AcpGoalControlRequest decode(Object? value) {
    final json = _goalObject(value, 'goal-control request');
    final sessionId = json['sessionId'];
    final rawObjective = json['objective'];
    if (sessionId is! String ||
        sessionId.isEmpty ||
        (rawObjective != null && rawObjective is! String)) {
      throw const FormatException('Invalid ACP goal-control request');
    }
    final action = AcpGoalControlAction._fromWire(json['action']);
    final objective = rawObjective is String ? rawObjective.trim() : null;
    if (action == AcpGoalControlAction.update &&
        (objective == null || objective.isEmpty)) {
      throw const FormatException(
        'Updating an ACP goal requires a non-empty objective',
      );
    }
    if (action != AcpGoalControlAction.update && objective != null) {
      throw const FormatException(
        'Only an ACP goal update accepts an objective',
      );
    }
    return AcpGoalControlRequest(
      sessionId: v1.SessionId(sessionId),
      action: action,
      objective: objective,
    );
  }

  @override
  Object encode(AcpGoalControlRequest value) {
    final objective = value.objective?.trim();
    if (value.action == AcpGoalControlAction.update &&
        (objective == null || objective.isEmpty)) {
      throw const FormatException(
        'Updating an ACP goal requires a non-empty objective',
      );
    }
    if (value.action != AcpGoalControlAction.update && objective != null) {
      throw const FormatException(
        'Only an ACP goal update accepts an objective',
      );
    }
    return <String, Object?>{
      'sessionId': value.sessionId.value,
      'action': value.action.wireName,
      'objective': ?objective,
    };
  }
}

Map<Object?, Object?> _goalObject(Object? value, String context) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException('ACP $context must be an object');
  }
  return value;
}
