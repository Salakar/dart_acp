import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../app_server/backend.dart';
import '../app_server/json_values.dart';
import '../config/models.dart';
import '../config/modes.dart';

/// Mutable state owned by one ACP session.
final class CodexSessionState {
  /// Creates state for a started or resumed thread.
  CodexSessionState({
    required this.sessionId,
    required this.cwd,
    required Iterable<String> additionalDirectories,
    required this.agentMode,
    required this.collaborationMode,
    required this.model,
    required this.effort,
    this.contextWindow,
  }) : additionalDirectories = List<String>.unmodifiable(additionalDirectories);

  /// ACP and app-server thread identity.
  final SessionId sessionId;

  /// Primary working directory.
  final String cwd;

  /// Additional workspace roots.
  final List<String> additionalDirectories;

  /// Approval and sandbox preset.
  CodexAgentMode agentMode;

  /// Collaboration behavior.
  CodexCollaborationMode collaborationMode;

  /// Selected model id.
  String model;

  /// Selected reasoning effort.
  CodexReasoningEffort effort;

  /// Selected model context window.
  int? contextWindow;

  /// Latest total token usage reported for the thread.
  int? usedTokens;

  /// Latest account rate-limit snapshot.
  CodexJsonObject? rateLimits;

  /// Current goal objective, when one is active.
  String? goalObjective;

  /// Current goal status.
  String? goalStatus;

  /// Whether the fast service tier is enabled.
  bool fastMode = false;

  /// Currently active turn.
  CodexTurnId? activeTurn;

  /// Completes when the current turn finishes.
  Completer<StopReason>? turnCompletion;

  /// Whether this session no longer accepts operations.
  bool isClosed = false;

  /// Serializes client notification delivery for this session.
  Future<void> notificationTail = Future<void>.value();

  /// Current generation used to fence stale asynchronous work.
  int generation = 0;

  /// Queues one notification operation in event order.
  void enqueueNotification(Future<void> Function() operation) {
    notificationTail = notificationTail.then(
      (_) => operation(),
      onError: (_) {
        return operation();
      },
    );
  }
}

/// In-memory registry for active ACP sessions.
final class CodexSessionRegistry {
  final Map<String, CodexSessionState> _sessions =
      <String, CodexSessionState>{};

  /// All active session states.
  Iterable<CodexSessionState> get values => _sessions.values;

  /// Looks up a session.
  CodexSessionState? operator [](SessionId id) => _sessions[id.value];

  /// Looks up a session by app-server thread id.
  CodexSessionState? byThread(CodexThreadId id) => _sessions[id.value];

  /// Installs state and rejects duplicate active identities.
  void add(CodexSessionState state) {
    final previous = _sessions[state.sessionId.value];
    if (previous != null && !previous.isClosed) {
      throw StateError('Session ${state.sessionId.value} is already active.');
    }
    _sessions[state.sessionId.value] = state;
  }

  /// Removes and closes a session.
  CodexSessionState? remove(SessionId id) {
    final state = _sessions.remove(id.value);
    if (state != null) {
      state
        ..isClosed = true
        ..generation += 1;
    }
    return state;
  }
}
