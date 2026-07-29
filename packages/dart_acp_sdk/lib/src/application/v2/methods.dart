part of 'application.dart';

/// Curated generated method descriptors for the baseline draft-v2 API.
abstract final class AcpV2Methods {
  /// Protocol cancellation.
  static const cancelRequest = v2_methods.cancelRequestMethod;

  /// Authentication login.
  static const authLogin = v2_methods.authLoginMethod;

  /// Authentication logout.
  static const authLogout = v2_methods.authLogoutMethod;

  /// Initialize.
  static const initialize = v2_methods.initializeMethod;

  /// Create a session.
  static const newSession = v2_methods.sessionNewMethod;

  /// List sessions.
  static const listSessions = v2_methods.sessionListMethod;

  /// Delete a session.
  static const deleteSession = v2_methods.sessionDeleteMethod;

  /// Resume a session.
  static const resumeSession = v2_methods.sessionResumeMethod;

  /// Close a session.
  static const closeSession = v2_methods.sessionCloseMethod;

  /// Set a configuration option.
  static const setSessionConfigOption = v2_methods.sessionSetConfigOptionMethod;

  /// Submit a prompt.
  static const prompt = v2_methods.sessionPromptMethod;

  /// Cancel session work.
  static const cancelSession = v2_methods.sessionCancelMethod;

  /// Request permission.
  static const requestPermission = v2_methods.sessionRequestPermissionMethod;

  /// Send a session update.
  static const updateSession = v2_methods.sessionUpdateMethod;

  /// Create elicitation.
  static const createElicitation = v2_methods.elicitationCreateMethod;

  /// Complete elicitation.
  static const completeElicitation = v2_methods.elicitationCompleteMethod;
}

/// Baseline agent-side named handler conveniences.
extension AcpV2AgentHandlers on AcpV2AgentApp {
  /// Handles `auth/login`.
  AcpV2AgentApp onAuthLogin(
    AcpV2AgentRequestHandler<v2.LoginAuthRequest, v2.LoginAuthResponse> handler,
  ) => onRequest(v2_methods.authLoginMethod, handler);

  /// Handles `auth/logout`.
  AcpV2AgentApp onAuthLogout(
    AcpV2AgentRequestHandler<v2.LogoutAuthRequest, v2.LogoutAuthResponse>
    handler,
  ) => onRequest(v2_methods.authLogoutMethod, handler);

  /// Handles `session/new`.
  AcpV2AgentApp onNewSession(
    AcpV2AgentRequestHandler<v2.NewSessionRequest, v2.NewSessionResponse>
    handler,
  ) => onRequest(v2_methods.sessionNewMethod, handler);

  /// Handles `session/list`.
  AcpV2AgentApp onListSessions(
    AcpV2AgentRequestHandler<v2.ListSessionsRequest, v2.ListSessionsResponse>
    handler,
  ) => onRequest(v2_methods.sessionListMethod, handler);

  /// Handles `session/delete`.
  AcpV2AgentApp onDeleteSession(
    AcpV2AgentRequestHandler<v2.DeleteSessionRequest, v2.DeleteSessionResponse>
    handler,
  ) => onRequest(v2_methods.sessionDeleteMethod, handler);

  /// Handles `session/resume`.
  AcpV2AgentApp onResumeSession(
    AcpV2AgentRequestHandler<v2.ResumeSessionRequest, v2.ResumeSessionResponse>
    handler,
  ) => onRequest(v2_methods.sessionResumeMethod, handler);

  /// Handles `session/close`.
  AcpV2AgentApp onCloseSession(
    AcpV2AgentRequestHandler<v2.CloseSessionRequest, v2.CloseSessionResponse>
    handler,
  ) => onRequest(v2_methods.sessionCloseMethod, handler);

  /// Handles `session/set_config_option`.
  AcpV2AgentApp onSetSessionConfigOption(
    AcpV2AgentRequestHandler<
      v2.SetSessionConfigOptionRequest,
      v2.SetSessionConfigOptionResponse
    >
    handler,
  ) => onRequest(v2_methods.sessionSetConfigOptionMethod, handler);

  /// Handles prompt acceptance.
  AcpV2AgentApp onPrompt(
    AcpV2AgentRequestHandler<v2.PromptRequest, v2.PromptResponse> handler,
  ) => onRequest(v2_methods.sessionPromptMethod, handler);

  /// Observes session cancellation.
  AcpV2AgentApp onCancelSession(
    AcpV2AgentNotificationHandler<v2.CancelSessionNotification> handler,
  ) => onNotification(v2_methods.sessionCancelMethod, handler);
}

/// Baseline client-side named handler conveniences.
extension AcpV2ClientHandlers on AcpV2ClientApp {
  /// Handles a permission request.
  AcpV2ClientApp onRequestPermission(
    AcpV2ClientRequestHandler<
      v2.RequestPermissionRequest,
      v2.RequestPermissionResponse
    >
    handler,
  ) => onRequest(v2_methods.sessionRequestPermissionMethod, handler);

  /// Observes a session update.
  AcpV2ClientApp onSessionUpdate(
    AcpV2ClientNotificationHandler<v2.UpdateSessionNotification> handler,
  ) => onNotification(v2_methods.sessionUpdateMethod, handler);

  /// Handles elicitation creation.
  AcpV2ClientApp onCreateElicitation(
    AcpV2ClientRequestHandler<
      v2.CreateElicitationRequest,
      v2.CreateElicitationResponse
    >
    handler,
  ) => onRequest(v2_methods.elicitationCreateMethod, handler);

  /// Observes elicitation completion.
  AcpV2ClientApp onCompleteElicitation(
    AcpV2ClientNotificationHandler<v2.CompleteElicitationNotification> handler,
  ) => onNotification(v2_methods.elicitationCompleteMethod, handler);
}

/// Baseline methods sent by a client.
extension AcpV2ClientMethods on AcpV2ClientContext {
  /// Authenticates with one method advertised during initialization.
  Future<v2.LoginAuthResponse> authLogin(
    v2.LoginAuthRequest params, {
    CancellationToken? cancellationToken,
  }) async {
    lifecycle.peerCapabilities._require(
      v2_methods.authLoginMethod.capabilityPath,
      v2_methods.authLoginMethod.name,
    );
    _requireAdvertisedV2AuthMethod(lifecycle.peerAuthMethods, params.methodId);
    return _request(
      v2_methods.authLoginMethod,
      params,
      cancellationToken: cancellationToken,
    );
  }

  /// Terminates the current authenticated session.
  Future<v2.LogoutAuthResponse> authLogout(
    v2.LogoutAuthRequest params, {
    CancellationToken? cancellationToken,
  }) async => _request(
    v2_methods.authLogoutMethod,
    params,
    cancellationToken: cancellationToken,
  );
}

void _requireAdvertisedV2AuthMethod(
  List<v2.AuthMethod> methods,
  v2.AuthMethodId methodId,
) {
  final bool advertised = methods.any(
    (v2.AuthMethod method) =>
        method is v2.AuthMethodAgentVariant &&
        method.value.methodId == methodId,
  );
  if (!advertised) {
    throw ArgumentError.value(
      methodId.value,
      'params.methodId',
      'was not advertised by the ACP v2 agent during initialization',
    );
  }
}

/// Baseline methods sent by an agent.
extension AcpV2AgentMethods on AcpV2AgentContext {
  /// Requests permission.
  Future<v2.RequestPermissionResponse> requestPermission(
    v2.RequestPermissionRequest params, {
    CancellationToken? cancellationToken,
  }) => _request(
    v2_methods.sessionRequestPermissionMethod,
    params,
    cancellationToken: cancellationToken,
  );

  /// Sends one session update.
  Future<void> updateSession(v2.UpdateSessionNotification params) =>
      notify(v2_methods.sessionUpdateMethod, params);

  /// Requests elicitation.
  ///
  /// Known form and URL variants require their matching advertised mode.
  /// Future custom variants require the peer's top-level elicitation marker.
  Future<v2.CreateElicitationResponse> createElicitation(
    v2.CreateElicitationRequest params, {
    CancellationToken? cancellationToken,
  }) {
    final String capabilityPath = switch (params) {
      v2.CreateElicitationRequestForm() => 'capabilities.elicitation.form',
      v2.CreateElicitationRequestUrl() => 'capabilities.elicitation.url',
      v2.CreateElicitationRequestCustom() => 'capabilities.elicitation',
    };
    lifecycle.peerCapabilities._require(
      capabilityPath,
      v2_methods.elicitationCreateMethod.name,
    );
    return _request(
      v2_methods.elicitationCreateMethod,
      params,
      cancellationToken: cancellationToken,
    );
  }

  /// Announces elicitation completion.
  Future<void> completeElicitation(v2.CompleteElicitationNotification params) {
    lifecycle.peerCapabilities._require(
      'capabilities.elicitation.url',
      v2_methods.elicitationCompleteMethod.name,
    );
    return notify(v2_methods.elicitationCompleteMethod, params);
  }
}
