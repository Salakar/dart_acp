part of 'application.dart';

/// A session operation was attempted after its local route became inactive.
final class AcpSessionStateException implements Exception {
  /// Creates a session state error.
  const AcpSessionStateException(this.message);

  /// A concise explanation of the invalid operation.
  final String message;

  @override
  String toString() => 'AcpSessionStateException: $message';
}

/// An idempotent registration for one active session update route.
final class AcpSessionSubscription {
  AcpSessionSubscription._(this._dispose);

  void Function()? _dispose;

  /// Removes the route. Repeated calls have no effect.
  void dispose() {
    final void Function()? callback = _dispose;
    _dispose = null;
    callback?.call();
  }
}

/// An event observed for an active session or prompt turn.
sealed class AcpActiveSessionEvent {
  const AcpActiveSessionEvent();
}

/// A typed `session/update` notification.
final class AcpSessionUpdateEvent extends AcpActiveSessionEvent {
  /// Creates an update event.
  const AcpSessionUpdateEvent(this.notification);

  /// The complete generated notification.
  final v1.SessionNotification notification;

  /// The typed update payload.
  v1.SessionUpdate get update => notification.update;
}

/// The final response for one v1 prompt turn.
final class AcpPromptCompletedEvent extends AcpActiveSessionEvent {
  /// Creates a completion event.
  const AcpPromptCompletedEvent(this.response);

  /// The generated prompt response.
  final v1.PromptResponse response;

  /// Why the agent stopped.
  v1.StopReason get stopReason => response.stopReason;
}

/// Markdown text collected from a completed prompt turn.
final class AcpCollectedText {
  /// Creates a collection result.
  const AcpCollectedText({
    required this.text,
    required this.thoughts,
    required this.response,
  });

  /// Concatenated agent message text.
  final String text;

  /// Concatenated agent thought text when requested.
  final String thoughts;

  /// Final prompt response.
  final v1.PromptResponse response;
}

/// Immutable builder for a new stable-v1 session.
final class AcpSessionBuilder {
  AcpSessionBuilder._({
    required AcpClientContext context,
    required _AcpSessionRouter router,
    required v1.NewSessionRequest request,
  }) : _context = context,
       _router = router,
       _request = request;

  final AcpClientContext _context;
  final _AcpSessionRouter _router;
  final v1.NewSessionRequest _request;

  /// Returns the exact generated request represented by this builder.
  v1.NewSessionRequest toRequest() => v1.NewSessionRequest(
    cwd: _request.cwd,
    mcpServers: _request.mcpServers,
    additionalDirectories: _request.additionalDirectories,
    meta: _request.meta,
  );

  /// Returns a copy with the complete MCP server list replaced.
  AcpSessionBuilder withMcpServers(Iterable<v1.McpServer> servers) =>
      _copy(mcpServers: List<v1.McpServer>.of(servers));

  /// Returns a copy with one MCP server appended.
  AcpSessionBuilder withMcpServer(v1.McpServer server) =>
      _copy(mcpServers: <v1.McpServer>[..._request.mcpServers, server]);

  /// Returns a copy with the complete additional-root list replaced.
  AcpSessionBuilder withAdditionalDirectories(
    Iterable<AcpAbsolutePath> directories,
  ) => _copy(
    additionalDirectories: <String>[
      for (final AcpAbsolutePath directory in directories) directory.value,
    ],
  );

  /// Starts the session after installing its update route.
  Future<AcpActiveSession> start({CancellationToken? cancellationToken}) async {
    _validateAdditionalDirectoriesCapability(
      _context,
      _request.additionalDirectories,
      method: v1_methods.sessionNewMethod.name,
    );
    _validateMcpCapabilities(_context, _request.mcpServers);
    final _AcpSessionChannel channel = _AcpSessionChannel();
    final _AcpPendingSessionRoute pending = _router.beginPending(channel);
    try {
      final v1.NewSessionResponse response = await _context._requestKnown(
        v1_methods.sessionNewMethod,
        toRequest(),
        cancellationToken: cancellationToken,
      );
      final AcpSessionSubscription subscription = pending.activate(
        response.sessionId,
      );
      return AcpActiveSession._(
        context: _context,
        channel: channel,
        subscription: subscription,
        sessionId: response.sessionId,
        modes: response.modes,
        configOptions: response.configOptions,
        newSessionResponse: response,
      );
    } on Object catch (error, stackTrace) {
      pending.dispose();
      channel.fail(error, stackTrace);
      rethrow;
    }
  }

  /// Starts, runs [operation], and always disposes local update routing.
  Future<T> withSession<T>(
    FutureOr<T> Function(AcpActiveSession session) operation,
  ) async {
    final AcpActiveSession session = await start();
    try {
      return await operation(session);
    } finally {
      session.dispose();
    }
  }

  AcpSessionBuilder _copy({
    List<v1.McpServer>? mcpServers,
    List<String>? additionalDirectories,
  }) => AcpSessionBuilder._(
    context: _context,
    router: _router,
    request: v1.NewSessionRequest(
      cwd: _request.cwd,
      mcpServers: mcpServers ?? _request.mcpServers,
      additionalDirectories:
          additionalDirectories ?? _request.additionalDirectories,
      meta: _request.meta,
    ),
  );
}

/// Stable session creation and lifecycle operations for one client connection.
final class AcpSessions {
  AcpSessions._(this._context, this._router);

  final AcpClientContext _context;
  final _AcpSessionRouter _router;

  /// Creates an immutable `session/new` builder.
  AcpSessionBuilder newSession({
    required AcpAbsolutePath cwd,
    Iterable<v1.McpServer> mcpServers = const <v1.McpServer>[],
    Iterable<AcpAbsolutePath>? additionalDirectories,
    AcpJsonObject? meta,
  }) => AcpSessionBuilder._(
    context: _context,
    router: _router,
    request: v1.NewSessionRequest(
      cwd: cwd.value,
      mcpServers: List<v1.McpServer>.of(mcpServers),
      additionalDirectories: additionalDirectories == null
          ? null
          : <String>[
              for (final AcpAbsolutePath directory in additionalDirectories)
                directory.value,
            ],
      meta: meta,
    ),
  );

  /// Loads a session while routing replay updates before the response.
  Future<AcpActiveSession> load(
    v1.LoadSessionRequest request, {
    CancellationToken? cancellationToken,
  }) => _attachExisting(
    sessionId: request.sessionId,
    cwd: request.cwd,
    additionalDirectories: request.additionalDirectories,
    mcpServers: request.mcpServers,
    method: v1_methods.sessionLoadMethod.name,
    send: () => _context._requestKnown(
      v1_methods.sessionLoadMethod,
      request,
      cancellationToken: cancellationToken,
    ),
    modes: (Object response) => (response as v1.LoadSessionResponse).modes,
    configOptions: (Object response) =>
        (response as v1.LoadSessionResponse).configOptions,
  );

  /// Resumes a session without replaying prior updates.
  Future<AcpActiveSession> resume(
    v1.ResumeSessionRequest request, {
    CancellationToken? cancellationToken,
  }) => _attachExisting(
    sessionId: request.sessionId,
    cwd: request.cwd,
    additionalDirectories: request.additionalDirectories,
    mcpServers: request.mcpServers ?? const <v1.McpServer>[],
    method: v1_methods.sessionResumeMethod.name,
    send: () => _context._requestKnown(
      v1_methods.sessionResumeMethod,
      request,
      cancellationToken: cancellationToken,
    ),
    modes: (Object response) => (response as v1.ResumeSessionResponse).modes,
    configOptions: (Object response) =>
        (response as v1.ResumeSessionResponse).configOptions,
  );

  /// Lists sessions using an opaque optional cursor.
  Future<v1.ListSessionsResponse> list(
    v1.ListSessionsRequest request, {
    CancellationToken? cancellationToken,
  }) {
    final String? cwd = request.cwd;
    if (cwd != null) {
      AcpAbsolutePath(cwd);
    }
    return _context._requestKnown(
      v1_methods.sessionListMethod,
      request,
      cancellationToken: cancellationToken,
    );
  }

  /// Deletes a session. The protocol defines repeated deletion as idempotent.
  Future<v1.DeleteSessionResponse> delete(
    v1.DeleteSessionRequest request, {
    CancellationToken? cancellationToken,
  }) => _context._requestKnown(
    v1_methods.sessionDeleteMethod,
    request,
    cancellationToken: cancellationToken,
  );

  Future<AcpActiveSession> _attachExisting({
    required v1.SessionId sessionId,
    required String cwd,
    required Iterable<String>? additionalDirectories,
    required Iterable<v1.McpServer> mcpServers,
    required String method,
    required Future<Object> Function() send,
    required v1.SessionModeState? Function(Object response) modes,
    required List<v1.SessionConfigOption>? Function(Object response)
    configOptions,
  }) async {
    AcpAbsolutePath(cwd);
    for (final String directory in additionalDirectories ?? const <String>[]) {
      AcpAbsolutePath(directory);
    }
    _validateAdditionalDirectoriesCapability(
      _context,
      additionalDirectories,
      method: method,
    );
    _validateMcpCapabilities(_context, mcpServers);
    final _AcpSessionChannel channel = _AcpSessionChannel();
    final AcpSessionSubscription subscription = _router.attach(
      sessionId,
      channel,
    );
    try {
      final Object response = await send();
      return AcpActiveSession._(
        context: _context,
        channel: channel,
        subscription: subscription,
        sessionId: sessionId,
        modes: modes(response),
        configOptions: configOptions(response),
      );
    } on Object catch (error, stackTrace) {
      subscription.dispose();
      channel.fail(error, stackTrace);
      rethrow;
    }
  }
}

/// A locally routed stable-v1 session.
final class AcpActiveSession {
  AcpActiveSession._({
    required this.sessionId,
    required AcpClientContext context,
    required _AcpSessionChannel channel,
    required AcpSessionSubscription subscription,
    this.modes,
    this.configOptions,
    this.newSessionResponse,
  }) : _context = context,
       _channel = channel,
       _subscription = subscription {
    _closeRegistration = context.lifecycle.cancellationToken.register(
      (Object? reason) => _fail(
        reason ?? const AcpSessionStateException('ACP connection closed'),
      ),
    );
  }

  final AcpClientContext _context;
  final _AcpSessionChannel _channel;
  final AcpSessionSubscription _subscription;
  late final CancellationRegistration _closeRegistration;
  _AcpTextCollector? _collector;
  bool _disposed = false;

  /// Protocol session identifier.
  final v1.SessionId sessionId;

  /// Initial mode state returned by the lifecycle request.
  final v1.SessionModeState? modes;

  /// Initial configuration returned by the lifecycle request.
  final List<v1.SessionConfigOption>? configOptions;

  /// The creation response, or `null` for a loaded/resumed session.
  final v1.NewSessionResponse? newSessionResponse;

  /// Single-subscription stream of all routed updates and prompt completions.
  Stream<AcpActiveSessionEvent> get events => _channel.events;

  /// Starts a prompt turn and begins buffering its events before sending.
  AcpPromptTurn prompt({
    required Iterable<v1.ContentBlock> content,
    CancellationToken? cancellationToken,
    AcpJsonObject? meta,
  }) {
    _ensureActive();
    final List<v1.ContentBlock> blocks = List<v1.ContentBlock>.of(content);
    _validatePromptCapabilities(_context, blocks);
    final _AcpPromptTurnState state = _channel.beginTurn();
    final Future<v1.PromptResponse> response = _context._requestKnown(
      v1_methods.sessionPromptMethod,
      v1.PromptRequest(sessionId: sessionId, prompt: blocks, meta: meta),
      cancellationToken: cancellationToken,
    );
    unawaited(
      response.then<void>(
        state.complete,
        onError: (Object error, StackTrace stackTrace) {
          state.fail(error, stackTrace);
        },
      ),
    );
    return AcpPromptTurn._(this, state);
  }

  /// Sends the session-level cancellation notification.
  Future<void> cancel({AcpJsonObject? meta}) {
    _ensureActive();
    return _context._notifyKnown(
      v1_methods.sessionCancelMethod,
      v1.CancelNotification(sessionId: sessionId, meta: meta),
    );
  }

  /// Changes the v1 session mode.
  Future<v1.SetSessionModeResponse> setMode(
    v1.SessionModeId modeId, {
    CancellationToken? cancellationToken,
    AcpJsonObject? meta,
  }) {
    _ensureActive();
    final bool advertised =
        modes?.availableModes.any((v1.SessionMode mode) => mode.id == modeId) ??
        false;
    if (!advertised) {
      throw ArgumentError.value(
        modeId,
        'modeId',
        'was not advertised for this session',
      );
    }
    return _context._requestKnown(
      v1_methods.sessionSetModeMethod,
      v1.SetSessionModeRequest(
        sessionId: sessionId,
        modeId: modeId,
        meta: meta,
      ),
      cancellationToken: cancellationToken,
    );
  }

  /// Sends a generated configuration-option update request.
  Future<v1.SetSessionConfigOptionResponse> setConfigOption(
    v1.SetSessionConfigOptionRequest request, {
    CancellationToken? cancellationToken,
  }) {
    _ensureActive();
    if (request.sessionId != sessionId) {
      throw ArgumentError.value(
        request.sessionId,
        'request.sessionId',
        'does not match this session',
      );
    }
    final bool advertised =
        configOptions?.any(
          (v1.SessionConfigOption option) =>
              _sessionConfigOptionId(option) == request.configId,
        ) ??
        false;
    if (!advertised) {
      throw ArgumentError.value(
        request.configId,
        'request.configId',
        'was not advertised for this session',
      );
    }
    return _context._requestKnown(
      v1_methods.sessionSetConfigOptionMethod,
      request,
      cancellationToken: cancellationToken,
    );
  }

  /// Requests protocol-level close, then removes local routing.
  Future<v1.CloseSessionResponse> close({
    CancellationToken? cancellationToken,
    AcpJsonObject? meta,
  }) async {
    _ensureActive();
    try {
      return await _context._requestKnown(
        v1_methods.sessionCloseMethod,
        v1.CloseSessionRequest(sessionId: sessionId, meta: meta),
        cancellationToken: cancellationToken,
      );
    } finally {
      dispose();
    }
  }

  /// Removes local update routing without sending `session/close`.
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _closeRegistration.dispose();
    _subscription.dispose();
    _collector?.fail(
      const AcpSessionStateException('Session disposed during text collection'),
    );
    _channel.close();
  }

  Future<AcpCollectedText> _collect(
    _AcpPromptTurnState turn, {
    required bool includeThoughts,
  }) {
    _ensureActive();
    _collector?.fail(
      const AcpSessionStateException(
        'A newer text collector replaced an overlapping v1 collector',
      ),
    );
    final _AcpTextCollector collector = _AcpTextCollector(
      turn,
      includeThoughts: includeThoughts,
    );
    _collector = collector;
    return collector.run().whenComplete(() {
      if (identical(_collector, collector)) {
        _collector = null;
      }
    });
  }

  void _fail(Object error) {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _subscription.dispose();
    _collector?.fail(error);
    _channel.fail(error);
  }

  void _ensureActive() {
    if (_disposed) {
      throw const AcpSessionStateException('Session route is inactive');
    }
  }
}

v1.SessionConfigId _sessionConfigOptionId(v1.SessionConfigOption option) =>
    switch (option) {
      v1.SessionConfigOptionSelect(:final id) => id,
      v1.SessionConfigOptionBoolean(:final id) => id,
    };

/// One stable-v1 prompt turn with race-free events and completion.
final class AcpPromptTurn {
  AcpPromptTurn._(this._session, this._state);

  final AcpActiveSession _session;
  final _AcpPromptTurnState _state;

  /// Single-subscription updates followed by one completion event.
  Stream<AcpActiveSessionEvent> get events => _state.events;

  /// Completes with the final prompt response.
  Future<v1.PromptResponse> get completed => _state.completed;

  /// Sends session cancellation while leaving completion peer-controlled.
  Future<void> cancel() => _session.cancel();

  /// Collects agent message text until this turn completes.
  Future<AcpCollectedText> collectText({bool includeThoughts = false}) =>
      _session._collect(_state, includeThoughts: includeThoughts);
}

void _validateAdditionalDirectoriesCapability(
  AcpClientContext context,
  Iterable<String>? additionalDirectories, {
  required String method,
}) {
  if (additionalDirectories?.isNotEmpty ?? false) {
    context.lifecycle.peerCapabilities.require(
      'agentCapabilities.sessionCapabilities.additionalDirectories',
      method: method,
    );
  }
}

void _validatePromptCapabilities(
  AcpClientContext context,
  Iterable<v1.ContentBlock> blocks,
) {
  for (final v1.ContentBlock block in blocks) {
    switch (block) {
      case v1.ContentBlockImage():
        context.lifecycle.peerCapabilities.require(
          'agentCapabilities.promptCapabilities.image',
          method: v1_methods.sessionPromptMethod.name,
        );
      case v1.ContentBlockAudio():
        context.lifecycle.peerCapabilities.require(
          'agentCapabilities.promptCapabilities.audio',
          method: v1_methods.sessionPromptMethod.name,
        );
      case v1.ContentBlockResource():
        context.lifecycle.peerCapabilities.require(
          'agentCapabilities.promptCapabilities.embeddedContext',
          method: v1_methods.sessionPromptMethod.name,
        );
      default:
        break;
    }
  }
}

void _validateMcpCapabilities(
  AcpClientContext context,
  Iterable<v1.McpServer> servers,
) {
  for (final v1.McpServer server in servers) {
    final String? capability = switch (server) {
      v1.McpServerMcpServerHttp() => 'agentCapabilities.mcpCapabilities.http',
      v1.McpServerMcpServerSse() => 'agentCapabilities.mcpCapabilities.sse',
      _ => null,
    };
    context.lifecycle.peerCapabilities.require(
      capability,
      method: v1_methods.sessionNewMethod.name,
    );
  }
}

/// Stable session conveniences on a client-to-agent context.
extension AcpClientSessionMethods on AcpClientContext {
  /// Creates an immutable session builder.
  AcpSessionBuilder newSession({
    required AcpAbsolutePath cwd,
    Iterable<v1.McpServer> mcpServers = const <v1.McpServer>[],
    Iterable<AcpAbsolutePath>? additionalDirectories,
    AcpJsonObject? meta,
  }) => sessions.newSession(
    cwd: cwd,
    mcpServers: mcpServers,
    additionalDirectories: additionalDirectories,
    meta: meta,
  );
}
