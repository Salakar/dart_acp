import 'dart:async';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../configuration/agent_options.dart';
import '../configuration/session_configuration.dart';
import '../conversion/message_projector.dart';

/// Terminal data collected for one user-authored turn.
final class ClaudeAcpTurnOutcome {
  /// Creates a completed turn outcome.
  const ClaudeAcpTurnOutcome({
    required this.result,
    required this.assistantError,
  });

  /// Terminal SDK result.
  final ResultMessage result;

  /// Structured assistant error observed before the result.
  final AssistantMessageError? assistantError;
}

/// Runtime state owned by one ACP session.
final class ClaudeAcpSession {
  /// Creates a connected session state.
  ClaudeAcpSession({
    required this.id,
    required this.cwd,
    required this.additionalDirectories,
    required this.client,
    required this.configuration,
    required this.maximumPending,
    required this.fingerprint,
    this.forwardSubagentText = true,
    this.rawSdkMessages = false,
  });

  /// ACP and Claude session identifier.
  final SessionId id;

  /// Session working directory.
  final String cwd;

  /// Additional filesystem roots.
  final List<String> additionalDirectories;

  /// Connected Claude client.
  final ClaudeAgentClient client;

  /// Current selectable configuration.
  final ClaudeSessionConfiguration configuration;

  /// Maximum prompt operations retained by this session.
  final int maximumPending;

  /// Hash of the session-defining creation parameters.
  final int fingerprint;

  /// Whether complete nested-agent transcripts should be projected to ACP.
  final bool forwardSubagentText;

  /// Per-session raw SDK-message selection.
  final Object rawSdkMessages;

  /// Whether [raw] should be forwarded through the raw SDK extension.
  bool shouldForwardSdkMessage(Map<String, Object?> raw) {
    final selection = rawSdkMessages;
    if (selection == true) return true;
    if (selection is List<ClaudeSdkMessageFilter>) {
      return selection.any((filter) => filter.matches(raw));
    }
    return false;
  }

  /// Last title sent to the ACP client.
  String? title;

  /// Incremental message projection state for the active prompt.
  final ClaudeMessageProjectionState messageProjection =
      ClaudeMessageProjectionState();

  Future<void> _tail = Future<void>.value();
  bool _closed = false;
  bool _active = false;
  int _pending = 0;
  Completer<ClaudeAcpTurnOutcome>? _turn;
  AssistantMessageError? _assistantError;
  ClaudeAcpTurnOutcome? _deferredOutcome;
  Timer? _forceCancelTimer;
  final Set<String> _liveTasks = <String>{};
  final Set<String> _spawnedTaskIds = <String>{};
  final Map<String, String> _taskParents = <String, String>{};
  int _owedTrailingIdles = 0;

  /// Long-lived message consumer for this session.
  Future<void>? consumer;

  /// Whether a prompt is actively consuming messages.
  bool get isActive => _active;

  /// Parent Agent/Task tool-use ID for a live subagent identifier.
  String? parentToolUseIdForAgent(String agentId) => _taskParents[agentId];

  /// Number of active or queued prompt operations.
  int get pendingCount => _pending;

  /// Serializes [operation] behind earlier prompts.
  Future<T> enqueue<T>(Future<T> Function() operation) {
    if (_closed) {
      return Future<T>.error(StateError('Session is closed'));
    }
    if (_pending >= maximumPending) {
      return Future<T>.error(
        StateError('Session prompt queue is full ($maximumPending)'),
      );
    }
    _pending += 1;
    final completer = Completer<T>();
    _tail = _tail.catchError((Object _) {}).then((_) async {
      if (_closed) {
        _pending -= 1;
        completer.completeError(StateError('Session is closed'));
        return;
      }
      _active = true;
      try {
        completer.complete(await operation());
      } on Object catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      } finally {
        _active = false;
        _pending -= 1;
      }
    });
    return completer.future;
  }

  /// Interrupts active work.
  Future<ClaudeInterruptReceipt> interrupt() => client.interrupt();

  /// Interrupts active work and force-settles a wedged turn after [grace].
  Future<ClaudeInterruptReceipt> cancel({
    required Duration grace,
    void Function()? onForced,
  }) async {
    final turn = _turn;
    if (turn != null && !turn.isCompleted && _forceCancelTimer == null) {
      _forceCancelTimer = Timer(grace, () {
        if (!identical(_turn, turn) || turn.isCompleted) return;
        onForced?.call();
        final deferred = _deferredOutcome?.result;
        _completeTurn(
          turn,
          ClaudeAcpTurnOutcome(
            result: ResultMessage(
              subtype: 'success',
              duration: deferred?.duration ?? Duration.zero,
              apiDuration: deferred?.apiDuration ?? Duration.zero,
              isError: false,
              turns: deferred?.turns ?? 0,
              sessionId: id.value,
              usage: deferred?.usage,
              totalCostUsd: deferred?.totalCostUsd,
              modelUsage: deferred?.modelUsage,
              terminalReason: 'aborted_streaming',
            ),
            assistantError: _assistantError,
          ),
        );
      });
    }
    return client.interrupt();
  }

  /// Opens a result slot for the next user-authored turn.
  Future<ClaudeAcpTurnOutcome> beginTurn() {
    if (_turn != null) {
      throw StateError('A turn is already active');
    }
    final completer = Completer<ClaudeAcpTurnOutcome>();
    _turn = completer;
    _assistantError = null;
    _deferredOutcome = null;
    _spawnedTaskIds.clear();
    _disarmForceCancel();
    return completer.future;
  }

  /// Observes one message and settles the active turn when appropriate.
  void observe(ClaudeMessageEnvelope envelope) {
    final message = envelope.message;
    _trackTaskLifecycle(message);
    final turn = _turn;
    if (turn == null) return;
    if (message is AssistantMessage && message.error != null) {
      _assistantError = message.error;
      return;
    }
    if (message is ResultMessage) {
      _owedTrailingIdles += 1;
      if (isBackgroundResult(envelope)) {
        if (_deferredOutcome != null && !_hasLiveSpawnedTasks) {
          _completeTurn(turn, _deferredOutcome!);
        }
        return;
      }
      final outcome = ClaudeAcpTurnOutcome(
        result: message,
        assistantError: _assistantError,
      );
      if (_hasLiveSpawnedTasks) {
        _deferredOutcome = outcome;
      } else {
        _completeTurn(turn, outcome);
      }
      return;
    }
    if (message is SessionStateChangedMessage && message.state == 'idle') {
      if (_owedTrailingIdles > 0) {
        _owedTrailingIdles -= 1;
        return;
      }
      final deferred = _deferredOutcome;
      if (deferred != null && !_hasLiveSpawnedTasks) {
        _completeTurn(turn, deferred);
        return;
      }
      failTurn(
        StateError(
          'Claude became idle before returning a result for the active turn',
        ),
      );
    }
  }

  void _trackTaskLifecycle(AgentMessage message) {
    switch (message) {
      case TaskStartedMessage():
        _liveTasks.add(message.taskId);
        if (message.toolUseId case final parent?) {
          _taskParents[message.taskId] = parent;
        }
        if (_turn != null &&
            (message.taskType == 'local_agent' ||
                message.subagentType != null)) {
          _spawnedTaskIds.add(message.taskId);
        }
      case TaskNotificationMessage():
        _liveTasks.remove(message.taskId);
        _taskParents.remove(message.taskId);
      case TaskUpdatedMessage() when message.status?.isTerminal ?? false:
        _liveTasks.remove(message.taskId);
        _taskParents.remove(message.taskId);
      case BackgroundTasksChangedMessage():
        _liveTasks
          ..clear()
          ..addAll(message.tasks.map((task) => task.taskId));
        _taskParents.removeWhere((taskId, _) => !_liveTasks.contains(taskId));
      default:
        break;
    }
  }

  bool get _hasLiveSpawnedTasks => _spawnedTaskIds.any(_liveTasks.contains);

  void _completeTurn(
    Completer<ClaudeAcpTurnOutcome> turn,
    ClaudeAcpTurnOutcome outcome,
  ) {
    if (!identical(_turn, turn) || turn.isCompleted) return;
    _turn = null;
    _assistantError = null;
    _deferredOutcome = null;
    _spawnedTaskIds.clear();
    _disarmForceCancel();
    turn.complete(outcome);
  }

  /// Fails the current turn if it is still pending.
  void failTurn(Object error, [StackTrace? stackTrace]) {
    final turn = _turn;
    if (turn == null) return;
    _turn = null;
    _assistantError = null;
    _deferredOutcome = null;
    _spawnedTaskIds.clear();
    _disarmForceCancel();
    turn.completeError(error, stackTrace);
  }

  void _disarmForceCancel() {
    _forceCancelTimer?.cancel();
    _forceCancelTimer = null;
  }

  /// Whether [envelope] is a result owned by a background wake-up.
  bool isBackgroundResult(ClaudeMessageEnvelope envelope) {
    if (envelope.message is! ResultMessage) return false;
    final origin = envelope.raw['origin'];
    if (origin is! Map<Object?, Object?>) return false;
    final kind = origin['kind'];
    if (kind is! String) return false;
    return const <String>{
      'task-notification',
      'task_notification',
      'peer',
      'coordinator',
      'observer',
      'observer-activity',
    }.contains(kind);
  }

  /// Closes this session exactly once.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    if (_active) {
      try {
        await client.interrupt();
      } on Object {
        // The transport may already be gone.
      }
    }
    failTurn(StateError('Session is closed'));
    _disarmForceCancel();
    await client.close();
    await consumer;
  }
}
