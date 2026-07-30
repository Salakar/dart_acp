part of 'application.dart';

AcpAgentInitializationConfiguration? _resolveAgentInitialization(
  AcpAgentInitializationConfiguration? configured,
  v1.Implementation? implementation,
  v1.AgentCapabilities? capabilities,
) {
  if (configured != null) {
    if (implementation != null || capabilities != null) {
      throw ArgumentError(
        'Provide either initialization or stable-v1 implementation and '
        'capabilities, not both',
      );
    }
    return configured;
  }
  if ((implementation == null) != (capabilities == null)) {
    throw ArgumentError(
      'Stable-v1 implementation and capabilities must be provided together',
    );
  }
  if (implementation == null) {
    return null;
  }
  return AcpAgentInitialization<v1.InitializeRequest, v1.InitializeResponse>(
    method: v1_methods.initializeMethod,
    peerCapabilities: _clientPeerCapabilities,
    peerImplementation: (v1.InitializeRequest request) =>
        request.clientInfo?.toAcpJson(),
    validateRequest: (v1.InitializeRequest request) =>
        _requireV1(request.protocolVersion),
  );
}

List<_AcpAgentBinding> _initialAgentBindings(
  AcpAgentInitializationConfiguration? configured,
  v1.Implementation? implementation,
  v1.AgentCapabilities? capabilities,
  Iterable<v1.AuthMethod> authMethods,
  AcpJsonObject? capabilityExtensions,
) {
  if (configured != null || implementation == null || capabilities == null) {
    return const <_AcpAgentBinding>[];
  }
  final List<v1.AuthMethod> methods = List<v1.AuthMethod>.unmodifiable(
    authMethods,
  );
  return List<_AcpAgentBinding>.unmodifiable(<_AcpAgentBinding>[
    _AcpAgentRequestBinding<v1.InitializeRequest, v1.InitializeResponse>(
      _v1InitializeMethod(capabilityExtensions),
      (AcpAgentRequestContext<v1.InitializeRequest> context) {
        _requireV1(context.params.protocolVersion);
        return v1.InitializeResponse(
          protocolVersion: v1.ProtocolVersion(1),
          agentCapabilities: capabilities,
          authMethods: methods,
          agentInfo: implementation,
        );
      },
    ),
  ]);
}

AcpMethodDescriptor<v1.InitializeRequest, v1.InitializeResponse>
_v1InitializeMethod(AcpJsonObject? capabilityExtensions) {
  if (capabilityExtensions == null || capabilityExtensions.isEmpty) {
    return v1_methods.initializeMethod;
  }
  final base = v1_methods.initializeMethod;
  return AcpMethodDescriptor<v1.InitializeRequest, v1.InitializeResponse>(
    name: base.name,
    dartName: base.dartName,
    protocol: base.protocol,
    stability: base.stability,
    direction: base.direction,
    kind: base.kind,
    paramsDefinition: base.paramsDefinition,
    paramsCodec: base.paramsCodec,
    resultCodec: _V1InitializeResponseCodec(capabilityExtensions),
    resultDefinition: base.resultDefinition,
    capabilityPath: base.capabilityPath,
    documentation: base.documentation,
  );
}

final class _V1InitializeResponseCodec
    implements AcpCodec<v1.InitializeResponse> {
  const _V1InitializeResponseCodec(this.extensions);

  final AcpJsonObject extensions;

  @override
  v1.InitializeResponse decode(Object? value) =>
      v1.initializeResponseCodec.decode(value);

  @override
  Object encode(v1.InitializeResponse value) {
    final result = value.toJson();
    final capabilities = value.agentCapabilities.toJson();
    for (final entry in extensions.toObject().entries) {
      if (capabilities.containsKey(entry.key)) {
        throw ArgumentError.value(
          entry.key,
          'capabilityExtensions',
          'must not replace a stable agent capability',
        );
      }
      capabilities[entry.key] = entry.value;
    }
    result['agentCapabilities'] = capabilities;
    return result;
  }
}

AcpClientInitializationConfiguration? _resolveClientInitialization(
  AcpClientInitializationConfiguration? configured,
  v1.Implementation? implementation,
  v1.ClientCapabilities? capabilities,
) {
  if (configured != null) {
    if (implementation != null || capabilities != null) {
      throw ArgumentError(
        'Provide either initialization or stable-v1 implementation and '
        'capabilities, not both',
      );
    }
    return configured;
  }
  if ((implementation == null) != (capabilities == null)) {
    throw ArgumentError(
      'Stable-v1 implementation and capabilities must be provided together',
    );
  }
  if (implementation == null) {
    return null;
  }
  return AcpClientInitialization<v1.InitializeRequest, v1.InitializeResponse>(
    method: v1_methods.initializeMethod,
    request: v1.InitializeRequest(
      protocolVersion: v1.ProtocolVersion(1),
      clientCapabilities: capabilities!,
      clientInfo: implementation,
    ),
    peerCapabilities: _agentPeerCapabilities,
    peerImplementation: (v1.InitializeResponse response) =>
        response.agentInfo?.toAcpJson(),
    peerAuthMethods: (v1.InitializeResponse response) => response.authMethods,
    validateResponse: (v1.InitializeResponse response) =>
        _requireV1(response.protocolVersion),
  );
}

AcpPeerCapabilities _clientPeerCapabilities(v1.InitializeRequest request) =>
    AcpPeerCapabilities(
      AcpJsonObject.fromObject(<String, Object?>{
        'clientCapabilities': request.clientCapabilities.toJson(),
      }),
    );

AcpPeerCapabilities _agentPeerCapabilities(v1.InitializeResponse response) {
  final Map<String, Object?> capabilities = response.agentCapabilities.toJson();
  return AcpPeerCapabilities(
    AcpJsonObject.fromObject(<String, Object?>{
      'agentCapabilities': <String, Object?>{
        ...capabilities,
        if (response.authMethods.isNotEmpty) 'authMethods': <String, Object?>{},
      },
    }),
  );
}

void _requireV1(v1.ProtocolVersion version) {
  if (version.value != 1) {
    throw JsonRpcRequestException.invalidParams(
      data: <String, Object?>{
        'protocolVersion': version.value,
        'supportedProtocolVersion': 1,
      },
    );
  }
}

/// Named stable-v1 handlers for an agent application.
extension AcpAgentAppV1Handlers on AcpAgentApp {
  /// Handles `authenticate`.
  AcpAgentApp onAuthenticate(
    AcpAgentRequestHandler<v1.AuthenticateRequest, v1.AuthenticateResponse>
    handler,
  ) => onRequest(v1_methods.authenticateMethod, handler);

  /// Handles `logout`.
  AcpAgentApp onLogout(
    AcpAgentRequestHandler<v1.LogoutRequest, v1.LogoutResponse> handler,
  ) => onRequest(v1_methods.logoutMethod, handler);

  /// Handles `session/new`.
  AcpAgentApp onNewSession(
    AcpAgentRequestHandler<v1.NewSessionRequest, v1.NewSessionResponse> handler,
  ) => onRequest(v1_methods.sessionNewMethod, handler);

  /// Handles `session/load`.
  AcpAgentApp onLoadSession(
    AcpAgentRequestHandler<v1.LoadSessionRequest, v1.LoadSessionResponse>
    handler,
  ) => onRequest(v1_methods.sessionLoadMethod, handler);

  /// Handles `session/list`.
  AcpAgentApp onListSessions(
    AcpAgentRequestHandler<v1.ListSessionsRequest, v1.ListSessionsResponse>
    handler,
  ) => onRequest(v1_methods.sessionListMethod, handler);

  /// Handles `session/delete`.
  AcpAgentApp onDeleteSession(
    AcpAgentRequestHandler<v1.DeleteSessionRequest, v1.DeleteSessionResponse>
    handler,
  ) => onRequest(v1_methods.sessionDeleteMethod, handler);

  /// Handles `session/resume`.
  AcpAgentApp onResumeSession(
    AcpAgentRequestHandler<v1.ResumeSessionRequest, v1.ResumeSessionResponse>
    handler,
  ) => onRequest(v1_methods.sessionResumeMethod, handler);

  /// Handles `session/close`.
  AcpAgentApp onCloseSession(
    AcpAgentRequestHandler<v1.CloseSessionRequest, v1.CloseSessionResponse>
    handler,
  ) => onRequest(v1_methods.sessionCloseMethod, handler);

  /// Handles `session/set_mode`.
  AcpAgentApp onSetSessionMode(
    AcpAgentRequestHandler<v1.SetSessionModeRequest, v1.SetSessionModeResponse>
    handler,
  ) => onRequest(v1_methods.sessionSetModeMethod, handler);

  /// Handles `session/set_config_option`.
  AcpAgentApp onSetSessionConfigOption(
    AcpAgentRequestHandler<
      v1.SetSessionConfigOptionRequest,
      v1.SetSessionConfigOptionResponse
    >
    handler,
  ) => onRequest(v1_methods.sessionSetConfigOptionMethod, handler);

  /// Handles `session/prompt`.
  AcpAgentApp onPrompt(
    AcpAgentRequestHandler<v1.PromptRequest, v1.PromptResponse> handler,
  ) => onRequest(v1_methods.sessionPromptMethod, handler);

  /// Observes `session/cancel`.
  AcpAgentApp onCancelSession(
    AcpAgentNotificationHandler<v1.CancelNotification> handler,
  ) => onNotification(v1_methods.sessionCancelMethod, handler);

  /// Observes protocol request cancellation.
  AcpAgentApp onCancelRequest(
    AcpAgentNotificationHandler<v1.CancelRequestNotification> handler,
  ) => onNotification(v1_methods.cancelRequestMethod, handler);
}

/// Named stable-v1 handlers for a client application.
extension AcpClientAppV1Handlers on AcpClientApp {
  /// Handles `session/request_permission`.
  AcpClientApp onRequestPermission(
    AcpClientRequestHandler<
      v1.RequestPermissionRequest,
      v1.RequestPermissionResponse
    >
    handler,
  ) => onRequest(v1_methods.sessionRequestPermissionMethod, handler);

  /// Handles `fs/read_text_file`.
  AcpClientApp onReadTextFile(
    AcpClientRequestHandler<v1.ReadTextFileRequest, v1.ReadTextFileResponse>
    handler,
  ) => onRequest(v1_methods.fsReadTextFileMethod, handler);

  /// Handles `fs/write_text_file`.
  AcpClientApp onWriteTextFile(
    AcpClientRequestHandler<v1.WriteTextFileRequest, v1.WriteTextFileResponse>
    handler,
  ) => onRequest(v1_methods.fsWriteTextFileMethod, handler);

  /// Handles `terminal/create`.
  AcpClientApp onCreateTerminal(
    AcpClientRequestHandler<v1.CreateTerminalRequest, v1.CreateTerminalResponse>
    handler,
  ) => onRequest(v1_methods.terminalCreateMethod, handler);

  /// Handles `terminal/output`.
  AcpClientApp onTerminalOutput(
    AcpClientRequestHandler<v1.TerminalOutputRequest, v1.TerminalOutputResponse>
    handler,
  ) => onRequest(v1_methods.terminalOutputMethod, handler);

  /// Handles `terminal/release`.
  AcpClientApp onReleaseTerminal(
    AcpClientRequestHandler<
      v1.ReleaseTerminalRequest,
      v1.ReleaseTerminalResponse
    >
    handler,
  ) => onRequest(v1_methods.terminalReleaseMethod, handler);

  /// Handles `terminal/wait_for_exit`.
  AcpClientApp onWaitForTerminalExit(
    AcpClientRequestHandler<
      v1.WaitForTerminalExitRequest,
      v1.WaitForTerminalExitResponse
    >
    handler,
  ) => onRequest(v1_methods.terminalWaitForExitMethod, handler);

  /// Handles `terminal/kill`.
  AcpClientApp onKillTerminal(
    AcpClientRequestHandler<v1.KillTerminalRequest, v1.KillTerminalResponse>
    handler,
  ) => onRequest(v1_methods.terminalKillMethod, handler);

  /// Handles `elicitation/create`.
  AcpClientApp onCreateElicitation(
    AcpClientRequestHandler<
      v1.CreateElicitationRequest,
      v1.CreateElicitationResponse
    >
    handler,
  ) => onRequest(v1_methods.elicitationCreateMethod, handler);

  /// Observes `session/update` after internal session routing.
  AcpClientApp onSessionUpdate(
    AcpClientNotificationHandler<v1.SessionNotification> handler,
  ) => onNotification(v1_methods.sessionUpdateMethod, handler);

  /// Observes `elicitation/complete`.
  AcpClientApp onElicitationComplete(
    AcpClientNotificationHandler<v1.CompleteElicitationNotification> handler,
  ) => onNotification(v1_methods.elicitationCompleteMethod, handler);

  /// Observes protocol request cancellation.
  AcpClientApp onCancelRequest(
    AcpClientNotificationHandler<v1.CancelRequestNotification> handler,
  ) => onNotification(v1_methods.cancelRequestMethod, handler);
}

/// Stable-v1 requests and notifications sent by an agent.
extension AcpAgentV1Methods on AcpAgentContext {
  /// Requests permission for a tool call.
  Future<v1.RequestPermissionResponse> requestPermission(
    v1.RequestPermissionRequest request, {
    CancellationToken? cancellationToken,
  }) => this.request(
    v1_methods.sessionRequestPermissionMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Reads text through the client file-system boundary.
  Future<v1.ReadTextFileResponse> readTextFile(
    v1.ReadTextFileRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.fsReadTextFileMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Writes text through the client file-system boundary.
  Future<v1.WriteTextFileResponse> writeTextFile(
    v1.WriteTextFileRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.fsWriteTextFileMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Creates a client-managed terminal.
  Future<v1.CreateTerminalResponse> createTerminal(
    v1.CreateTerminalRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.terminalCreateMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Reads current terminal output.
  Future<v1.TerminalOutputResponse> terminalOutput(
    v1.TerminalOutputRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.terminalOutputMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Releases a client-managed terminal.
  Future<v1.ReleaseTerminalResponse> releaseTerminal(
    v1.ReleaseTerminalRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.terminalReleaseMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Waits for a terminal to exit.
  Future<v1.WaitForTerminalExitResponse> waitForTerminalExit(
    v1.WaitForTerminalExitRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.terminalWaitForExitMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Kills a client-managed terminal.
  Future<v1.KillTerminalResponse> killTerminal(
    v1.KillTerminalRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.terminalKillMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Requests structured input from the user.
  ///
  /// Known form and URL variants require their matching advertised mode.
  /// Future custom variants require the peer's top-level elicitation marker.
  Future<v1.CreateElicitationResponse> createElicitation(
    v1.CreateElicitationRequest request, {
    CancellationToken? cancellationToken,
  }) {
    final String capabilityPath = switch (request) {
      v1.CreateElicitationRequestForm() =>
        'clientCapabilities.elicitation.form',
      v1.CreateElicitationRequestUrl() => 'clientCapabilities.elicitation.url',
      v1.CreateElicitationRequestCustom() => 'clientCapabilities.elicitation',
    };
    lifecycle.peerCapabilities.require(
      capabilityPath,
      method: v1_methods.elicitationCreateMethod.name,
    );
    return _requestKnown(
      v1_methods.elicitationCreateMethod,
      request,
      cancellationToken: cancellationToken,
    );
  }

  /// Sends an update for one active session.
  Future<void> updateSession(v1.SessionNotification notification) =>
      _notifyKnown(v1_methods.sessionUpdateMethod, notification);

  /// Signals completion of a URL-based elicitation.
  Future<void> completeElicitation(
    v1.CompleteElicitationNotification notification,
  ) {
    lifecycle.peerCapabilities.require(
      'clientCapabilities.elicitation.url',
      method: v1_methods.elicitationCompleteMethod.name,
    );
    return _notifyKnown(v1_methods.elicitationCompleteMethod, notification);
  }

  /// Sends an explicit protocol cancellation notification.
  Future<void> cancelRequest(v1.CancelRequestNotification notification) =>
      _notifyKnown(v1_methods.cancelRequestMethod, notification);
}

/// Stable-v1 requests and notifications sent by a client.
extension AcpClientV1Methods on AcpClientContext {
  /// Authenticates with an advertised method.
  Future<v1.AuthenticateResponse> authenticate(
    v1.AuthenticateRequest request, {
    CancellationToken? cancellationToken,
  }) async {
    lifecycle.peerCapabilities.require(
      v1_methods.authenticateMethod.capabilityPath,
      method: v1_methods.authenticateMethod.name,
    );
    _requireAdvertisedV1AuthMethod(lifecycle.peerAuthMethods, request.methodId);
    return _requestKnown(
      v1_methods.authenticateMethod,
      request,
      cancellationToken: cancellationToken,
    );
  }

  /// Ends the current authenticated session.
  Future<v1.LogoutResponse> logout(
    v1.LogoutRequest request, {
    CancellationToken? cancellationToken,
  }) async => _requestKnown(
    v1_methods.logoutMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Sends a raw generated `session/new` request.
  Future<v1.NewSessionResponse> createSession(
    v1.NewSessionRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.sessionNewMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Sends a raw generated `session/load` request.
  Future<v1.LoadSessionResponse> loadSession(
    v1.LoadSessionRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.sessionLoadMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Lists sessions.
  Future<v1.ListSessionsResponse> listSessions(
    v1.ListSessionsRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.sessionListMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Deletes a session.
  Future<v1.DeleteSessionResponse> deleteSession(
    v1.DeleteSessionRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.sessionDeleteMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Resumes a session.
  Future<v1.ResumeSessionResponse> resumeSession(
    v1.ResumeSessionRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.sessionResumeMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Closes a session.
  Future<v1.CloseSessionResponse> closeSession(
    v1.CloseSessionRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.sessionCloseMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Sets a session mode.
  Future<v1.SetSessionModeResponse> setSessionMode(
    v1.SetSessionModeRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.sessionSetModeMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Sets a session configuration option.
  Future<v1.SetSessionConfigOptionResponse> setSessionConfigOption(
    v1.SetSessionConfigOptionRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.sessionSetConfigOptionMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Sends a generated prompt request without session collection helpers.
  Future<v1.PromptResponse> sendPrompt(
    v1.PromptRequest request, {
    CancellationToken? cancellationToken,
  }) => _requestKnown(
    v1_methods.sessionPromptMethod,
    request,
    cancellationToken: cancellationToken,
  );

  /// Cancels active operations for one session.
  Future<void> cancelSession(v1.CancelNotification notification) =>
      _notifyKnown(v1_methods.sessionCancelMethod, notification);

  /// Sends an explicit protocol cancellation notification.
  Future<void> cancelRequest(v1.CancelRequestNotification notification) =>
      _notifyKnown(v1_methods.cancelRequestMethod, notification);
}

void _requireAdvertisedV1AuthMethod(
  List<v1.AuthMethod> methods,
  v1.AuthMethodId methodId,
) {
  final bool advertised = methods.any(
    (v1.AuthMethod method) =>
        method is v1.AuthMethodAgentVariant && method.value.id == methodId,
  );
  if (!advertised) {
    throw ArgumentError.value(
      methodId.value,
      'request.methodId',
      'was not advertised by the ACP v1 agent during initialization',
    );
  }
}
