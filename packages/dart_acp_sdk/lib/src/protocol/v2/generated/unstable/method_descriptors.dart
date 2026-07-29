// GENERATED CODE - DO NOT MODIFY BY HAND.
// Schema: snapshots/official/schema/v2/schema.unstable.json
// Metadata SHA-256: 2c274308d2a773628bf6316b7f6c535cf87d2c1ceb495d02be9ee899dce0f0bc

import '../../../method.dart';
import 'models.dart';

/// Notification to cancel an ongoing request.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/draft/cancellation)
const AcpMethodDescriptor<CancelRequestNotification, AcpNoResult>
cancelRequestMethod = AcpMethodDescriptor<CancelRequestNotification, AcpNoResult>(
  name: '\$/cancel_request',
  dartName: 'cancelRequest',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.draft,
  direction: AcpMethodDirection.either,
  kind: AcpMethodKind.notification,
  paramsDefinition: 'CancelRequestNotification',
  paramsCodec: cancelRequestNotificationCodec,
  resultCodec: acpNoResultCodec,
  resultDefinition: null,
  capabilityPath: null,
  documentation:
      'Notification to cancel an ongoing request.\n\nSee protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/draft/cancellation)',
);

/// Request parameters for the `auth/login` method.
///
/// Specifies which authentication method to use.
///
/// Agents MUST support this method when their `initialize` response advertised
/// at least one valid authentication method. Clients MUST NOT call this method
/// when `authMethods` was omitted or empty.
const AcpMethodDescriptor<LoginAuthRequest, LoginAuthResponse>
authLoginMethod = AcpMethodDescriptor<LoginAuthRequest, LoginAuthResponse>(
  name: 'auth/login',
  dartName: 'authLogin',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.draft,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'LoginAuthRequest',
  paramsCodec: loginAuthRequestCodec,
  resultCodec: loginAuthResponseCodec,
  resultDefinition: 'LoginAuthResponse',
  capabilityPath: 'agentCapabilities.authMethods',
  documentation:
      'Request parameters for the `auth/login` method.\n\nSpecifies which authentication method to use.\n\nAgents MUST support this method when their `initialize` response advertised\nat least one valid authentication method. Clients MUST NOT call this method\nwhen `authMethods` was omitted or empty.',
);

/// Request parameters for the `auth/logout` method.
///
/// Terminates the current authenticated session.
///
/// Agents MUST support this method when their `initialize` response advertised
/// at least one valid authentication method. Clients MUST NOT call this method
/// when `authMethods` was omitted or empty.
const AcpMethodDescriptor<LogoutAuthRequest, LogoutAuthResponse>
authLogoutMethod = AcpMethodDescriptor<LogoutAuthRequest, LogoutAuthResponse>(
  name: 'auth/logout',
  dartName: 'authLogout',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.draft,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'LogoutAuthRequest',
  paramsCodec: logoutAuthRequestCodec,
  resultCodec: logoutAuthResponseCodec,
  resultDefinition: 'LogoutAuthResponse',
  capabilityPath: 'agentCapabilities.authMethods',
  documentation:
      'Request parameters for the `auth/logout` method.\n\nTerminates the current authenticated session.\n\nAgents MUST support this method when their `initialize` response advertised\nat least one valid authentication method. Clients MUST NOT call this method\nwhen `authMethods` was omitted or empty.',
);

/// Notification sent when a file is edited.
const AcpMethodDescriptor<DidChangeDocumentNotification, AcpNoResult>
documentDidChangeMethod =
    AcpMethodDescriptor<DidChangeDocumentNotification, AcpNoResult>(
      name: 'document/didChange',
      dartName: 'documentDidChange',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'DidChangeDocumentNotification',
      paramsCodec: didChangeDocumentNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: null,
      documentation: 'Notification sent when a file is edited.',
    );

/// Notification sent when a file is closed.
const AcpMethodDescriptor<DidCloseDocumentNotification, AcpNoResult>
documentDidCloseMethod =
    AcpMethodDescriptor<DidCloseDocumentNotification, AcpNoResult>(
      name: 'document/didClose',
      dartName: 'documentDidClose',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'DidCloseDocumentNotification',
      paramsCodec: didCloseDocumentNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: null,
      documentation: 'Notification sent when a file is closed.',
    );

/// Notification sent when a file becomes the active editor tab.
const AcpMethodDescriptor<DidFocusDocumentNotification, AcpNoResult>
documentDidFocusMethod =
    AcpMethodDescriptor<DidFocusDocumentNotification, AcpNoResult>(
      name: 'document/didFocus',
      dartName: 'documentDidFocus',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'DidFocusDocumentNotification',
      paramsCodec: didFocusDocumentNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: null,
      documentation:
          'Notification sent when a file becomes the active editor tab.',
    );

/// Notification sent when a file is opened in the editor.
const AcpMethodDescriptor<DidOpenDocumentNotification, AcpNoResult>
documentDidOpenMethod =
    AcpMethodDescriptor<DidOpenDocumentNotification, AcpNoResult>(
      name: 'document/didOpen',
      dartName: 'documentDidOpen',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'DidOpenDocumentNotification',
      paramsCodec: didOpenDocumentNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: null,
      documentation: 'Notification sent when a file is opened in the editor.',
    );

/// Notification sent when a file is saved.
const AcpMethodDescriptor<DidSaveDocumentNotification, AcpNoResult>
documentDidSaveMethod =
    AcpMethodDescriptor<DidSaveDocumentNotification, AcpNoResult>(
      name: 'document/didSave',
      dartName: 'documentDidSave',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'DidSaveDocumentNotification',
      paramsCodec: didSaveDocumentNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: null,
      documentation: 'Notification sent when a file is saved.',
    );

/// Notification sent by the agent when a URL-based elicitation is complete.
const AcpMethodDescriptor<CompleteElicitationNotification, AcpNoResult>
elicitationCompleteMethod =
    AcpMethodDescriptor<CompleteElicitationNotification, AcpNoResult>(
      name: 'elicitation/complete',
      dartName: 'elicitationComplete',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.draft,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'CompleteElicitationNotification',
      paramsCodec: completeElicitationNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: 'clientCapabilities.elicitation.url',
      documentation:
          'Notification sent by the agent when a URL-based elicitation is complete.',
    );

/// Request from the agent to elicit structured user input.
///
/// The agent sends this to the client to request information from the user,
/// either via a form or by directing them to a URL.
/// Elicitations are tied to a session (optionally a tool call) or a request.
const AcpMethodDescriptor<CreateElicitationRequest, CreateElicitationResponse>
elicitationCreateMethod =
    AcpMethodDescriptor<CreateElicitationRequest, CreateElicitationResponse>(
      name: 'elicitation/create',
      dartName: 'elicitationCreate',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.draft,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'CreateElicitationRequest',
      paramsCodec: createElicitationRequestCodec,
      resultCodec: createElicitationResponseCodec,
      resultDefinition: 'CreateElicitationResponse',
      capabilityPath: 'clientCapabilities.elicitation',
      documentation:
          'Request from the agent to elicit structured user input.\n\nThe agent sends this to the client to request information from the user,\neither via a form or by directing them to a URL.\nElicitations are tied to a session (optionally a tool call) or a request.',
    );

/// Request parameters for the initialize method.
///
/// Sent by the client to establish connection and negotiate capabilities.
///
/// See protocol docs: [Initialization](https://agentclientprotocol.com/protocol/v2/draft/initialization)
const AcpMethodDescriptor<InitializeRequest, InitializeResponse>
initializeMethod = AcpMethodDescriptor<InitializeRequest, InitializeResponse>(
  name: 'initialize',
  dartName: 'initialize',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.draft,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'InitializeRequest',
  paramsCodec: initializeRequestCodec,
  resultCodec: initializeResponseCodec,
  resultDefinition: 'InitializeResponse',
  capabilityPath: null,
  documentation:
      'Request parameters for the initialize method.\n\nSent by the client to establish connection and negotiate capabilities.\n\nSee protocol docs: [Initialization](https://agentclientprotocol.com/protocol/v2/draft/initialization)',
);

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `mcp/connect`.
const AcpMethodDescriptor<ConnectMcpRequest, ConnectMcpResponse>
mcpConnectMethod = AcpMethodDescriptor<ConnectMcpRequest, ConnectMcpResponse>(
  name: 'mcp/connect',
  dartName: 'mcpConnect',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.unstable,
  direction: AcpMethodDirection.agentToClient,
  kind: AcpMethodKind.request,
  paramsDefinition: 'ConnectMcpRequest',
  paramsCodec: connectMcpRequestCodec,
  resultCodec: connectMcpResponseCodec,
  resultDefinition: 'ConnectMcpResponse',
  capabilityPath: null,
  documentation:
      '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nRequest parameters for `mcp/connect`.',
);

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `mcp/disconnect`.
const AcpMethodDescriptor<DisconnectMcpRequest, DisconnectMcpResponse>
mcpDisconnectMethod =
    AcpMethodDescriptor<DisconnectMcpRequest, DisconnectMcpResponse>(
      name: 'mcp/disconnect',
      dartName: 'mcpDisconnect',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'DisconnectMcpRequest',
      paramsCodec: disconnectMcpRequestCodec,
      resultCodec: disconnectMcpResponseCodec,
      resultDefinition: 'DisconnectMcpResponse',
      capabilityPath: null,
      documentation:
          '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nRequest parameters for `mcp/disconnect`.',
    );

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `mcp/message`.
const AcpMethodDescriptor<MessageMcpRequest, MessageMcpResponse>
mcpMessageClientToAgentRequestMethod =
    AcpMethodDescriptor<MessageMcpRequest, MessageMcpResponse>(
      name: 'mcp/message',
      dartName: 'mcpMessage',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'MessageMcpRequest',
      paramsCodec: messageMcpRequestCodec,
      resultCodec: messageMcpResponseCodec,
      resultDefinition: 'MessageMcpResponse',
      capabilityPath: 'capabilities.mcp',
      documentation:
          '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nRequest parameters for `mcp/message`.',
    );

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Notification parameters for `mcp/message`.
///
/// This is used when the wrapped MCP message is a notification and the outer JSON-RPC
/// envelope has no `id`.
const AcpMethodDescriptor<MessageMcpNotification, AcpNoResult>
mcpMessageClientToAgentNotificationMethod =
    AcpMethodDescriptor<MessageMcpNotification, AcpNoResult>(
      name: 'mcp/message',
      dartName: 'mcpMessage',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'MessageMcpNotification',
      paramsCodec: messageMcpNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: 'capabilities.mcp',
      documentation:
          '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nNotification parameters for `mcp/message`.\n\nThis is used when the wrapped MCP message is a notification and the outer JSON-RPC\nenvelope has no `id`.',
    );

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `mcp/message`.
const AcpMethodDescriptor<MessageMcpRequest, MessageMcpResponse>
mcpMessageAgentToClientRequestMethod =
    AcpMethodDescriptor<MessageMcpRequest, MessageMcpResponse>(
      name: 'mcp/message',
      dartName: 'mcpMessage',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'MessageMcpRequest',
      paramsCodec: messageMcpRequestCodec,
      resultCodec: messageMcpResponseCodec,
      resultDefinition: 'MessageMcpResponse',
      capabilityPath: 'capabilities.mcp',
      documentation:
          '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nRequest parameters for `mcp/message`.',
    );

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Notification parameters for `mcp/message`.
///
/// This is used when the wrapped MCP message is a notification and the outer JSON-RPC
/// envelope has no `id`.
const AcpMethodDescriptor<MessageMcpNotification, AcpNoResult>
mcpMessageAgentToClientNotificationMethod =
    AcpMethodDescriptor<MessageMcpNotification, AcpNoResult>(
      name: 'mcp/message',
      dartName: 'mcpMessage',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'MessageMcpNotification',
      paramsCodec: messageMcpNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: 'capabilities.mcp',
      documentation:
          '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nNotification parameters for `mcp/message`.\n\nThis is used when the wrapped MCP message is a notification and the outer JSON-RPC\nenvelope has no `id`.',
    );

/// Notification sent when a suggestion is accepted.
const AcpMethodDescriptor<AcceptNesNotification, AcpNoResult> nesAcceptMethod =
    AcpMethodDescriptor<AcceptNesNotification, AcpNoResult>(
      name: 'nes/accept',
      dartName: 'nesAccept',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'AcceptNesNotification',
      paramsCodec: acceptNesNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: null,
      documentation: 'Notification sent when a suggestion is accepted.',
    );

/// Request to close an NES session.
///
/// The agent **must** cancel any ongoing work related to the NES session
/// and then free up any resources associated with the session.
const AcpMethodDescriptor<CloseNesRequest, CloseNesResponse>
nesCloseMethod = AcpMethodDescriptor<CloseNesRequest, CloseNesResponse>(
  name: 'nes/close',
  dartName: 'nesClose',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.unstable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'CloseNesRequest',
  paramsCodec: closeNesRequestCodec,
  resultCodec: closeNesResponseCodec,
  resultDefinition: 'CloseNesResponse',
  capabilityPath: null,
  documentation:
      'Request to close an NES session.\n\nThe agent **must** cancel any ongoing work related to the NES session\nand then free up any resources associated with the session.',
);

/// Notification sent when a suggestion is rejected.
const AcpMethodDescriptor<RejectNesNotification, AcpNoResult> nesRejectMethod =
    AcpMethodDescriptor<RejectNesNotification, AcpNoResult>(
      name: 'nes/reject',
      dartName: 'nesReject',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      paramsDefinition: 'RejectNesNotification',
      paramsCodec: rejectNesNotificationCodec,
      resultCodec: acpNoResultCodec,
      resultDefinition: null,
      capabilityPath: null,
      documentation: 'Notification sent when a suggestion is rejected.',
    );

/// Request to start an NES session.
const AcpMethodDescriptor<StartNesRequest, StartNesResponse> nesStartMethod =
    AcpMethodDescriptor<StartNesRequest, StartNesResponse>(
      name: 'nes/start',
      dartName: 'nesStart',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'StartNesRequest',
      paramsCodec: startNesRequestCodec,
      resultCodec: startNesResponseCodec,
      resultDefinition: 'StartNesResponse',
      capabilityPath: null,
      documentation: 'Request to start an NES session.',
    );

/// Request for a code suggestion.
const AcpMethodDescriptor<SuggestNesRequest, SuggestNesResponse>
nesSuggestMethod = AcpMethodDescriptor<SuggestNesRequest, SuggestNesResponse>(
  name: 'nes/suggest',
  dartName: 'nesSuggest',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.unstable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'SuggestNesRequest',
  paramsCodec: suggestNesRequestCodec,
  resultCodec: suggestNesResponseCodec,
  resultDefinition: 'SuggestNesResponse',
  capabilityPath: null,
  documentation: 'Request for a code suggestion.',
);

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `providers/disable`.
const AcpMethodDescriptor<DisableProviderRequest, DisableProviderResponse>
providersDisableMethod =
    AcpMethodDescriptor<DisableProviderRequest, DisableProviderResponse>(
      name: 'providers/disable',
      dartName: 'providersDisable',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'DisableProviderRequest',
      paramsCodec: disableProviderRequestCodec,
      resultCodec: disableProviderResponseCodec,
      resultDefinition: 'DisableProviderResponse',
      capabilityPath: null,
      documentation:
          '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nRequest parameters for `providers/disable`.',
    );

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `providers/list`.
const AcpMethodDescriptor<ListProvidersRequest, ListProvidersResponse>
providersListMethod =
    AcpMethodDescriptor<ListProvidersRequest, ListProvidersResponse>(
      name: 'providers/list',
      dartName: 'providersList',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.unstable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'ListProvidersRequest',
      paramsCodec: listProvidersRequestCodec,
      resultCodec: listProvidersResponseCodec,
      resultDefinition: 'ListProvidersResponse',
      capabilityPath: null,
      documentation:
          '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nRequest parameters for `providers/list`.',
    );

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `providers/set`.
///
/// Replaces the full configuration for one provider ID.
const AcpMethodDescriptor<SetProviderRequest, SetProviderResponse>
providersSetMethod = AcpMethodDescriptor<SetProviderRequest, SetProviderResponse>(
  name: 'providers/set',
  dartName: 'providersSet',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.unstable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'SetProviderRequest',
  paramsCodec: setProviderRequestCodec,
  resultCodec: setProviderResponseCodec,
  resultDefinition: 'SetProviderResponse',
  capabilityPath: null,
  documentation:
      '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nRequest parameters for `providers/set`.\n\nReplaces the full configuration for one provider ID.',
);

/// Notification to cancel ongoing operations for a session.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/draft/prompt-lifecycle#cancellation)
const AcpMethodDescriptor<CancelSessionNotification, AcpNoResult>
sessionCancelMethod = AcpMethodDescriptor<CancelSessionNotification, AcpNoResult>(
  name: 'session/cancel',
  dartName: 'sessionCancel',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.draft,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.notification,
  paramsDefinition: 'CancelSessionNotification',
  paramsCodec: cancelSessionNotificationCodec,
  resultCodec: acpNoResultCodec,
  resultDefinition: null,
  capabilityPath: 'agentCapabilities.session',
  documentation:
      'Notification to cancel ongoing operations for a session.\n\nSee protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/draft/prompt-lifecycle#cancellation)',
);

/// Request parameters for closing an active session.
///
/// The agent **must** cancel any ongoing work related to the session (treat it
/// as if `session/cancel` was called) and then free up any resources associated
/// with the session.
const AcpMethodDescriptor<CloseSessionRequest, CloseSessionResponse>
sessionCloseMethod = AcpMethodDescriptor<CloseSessionRequest, CloseSessionResponse>(
  name: 'session/close',
  dartName: 'sessionClose',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.draft,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'CloseSessionRequest',
  paramsCodec: closeSessionRequestCodec,
  resultCodec: closeSessionResponseCodec,
  resultDefinition: 'CloseSessionResponse',
  capabilityPath: 'agentCapabilities.session',
  documentation:
      'Request parameters for closing an active session.\n\nThe agent **must** cancel any ongoing work related to the session (treat it\nas if `session/cancel` was called) and then free up any resources associated\nwith the session.',
);

/// Request parameters for deleting an existing session from `session/list`.
///
/// Only available if the Agent supports the `session.delete` capability.
const AcpMethodDescriptor<DeleteSessionRequest, DeleteSessionResponse>
sessionDeleteMethod =
    AcpMethodDescriptor<DeleteSessionRequest, DeleteSessionResponse>(
      name: 'session/delete',
      dartName: 'sessionDelete',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.draft,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'DeleteSessionRequest',
      paramsCodec: deleteSessionRequestCodec,
      resultCodec: deleteSessionResponseCodec,
      resultDefinition: 'DeleteSessionResponse',
      capabilityPath: 'agentCapabilities.session.delete',
      documentation:
          'Request parameters for deleting an existing session from `session/list`.\n\nOnly available if the Agent supports the `session.delete` capability.',
    );

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for forking an existing session.
///
/// Creates a new session based on the context of an existing one, allowing
/// operations like generating summaries without affecting the original session's history.
///
/// Only available if the Agent supports the `session.fork` capability.
const AcpMethodDescriptor<ForkSessionRequest, ForkSessionResponse>
sessionForkMethod = AcpMethodDescriptor<ForkSessionRequest, ForkSessionResponse>(
  name: 'session/fork',
  dartName: 'sessionFork',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.unstable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'ForkSessionRequest',
  paramsCodec: forkSessionRequestCodec,
  resultCodec: forkSessionResponseCodec,
  resultDefinition: 'ForkSessionResponse',
  capabilityPath: 'agentCapabilities.sessionCapabilities.fork',
  documentation:
      '**UNSTABLE**\n\nThis capability is not part of the spec yet, and may be removed or changed at any point.\n\nRequest parameters for forking an existing session.\n\nCreates a new session based on the context of an existing one, allowing\noperations like generating summaries without affecting the original session\'s history.\n\nOnly available if the Agent supports the `session.fork` capability.',
);

/// Request parameters for listing existing sessions.
const AcpMethodDescriptor<ListSessionsRequest, ListSessionsResponse>
sessionListMethod =
    AcpMethodDescriptor<ListSessionsRequest, ListSessionsResponse>(
      name: 'session/list',
      dartName: 'sessionList',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.draft,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'ListSessionsRequest',
      paramsCodec: listSessionsRequestCodec,
      resultCodec: listSessionsResponseCodec,
      resultDefinition: 'ListSessionsResponse',
      capabilityPath: 'agentCapabilities.session',
      documentation: 'Request parameters for listing existing sessions.',
    );

/// Request parameters for creating a new session.
///
/// See protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/v2/draft/session-setup#creating-a-session)
const AcpMethodDescriptor<NewSessionRequest, NewSessionResponse>
sessionNewMethod = AcpMethodDescriptor<NewSessionRequest, NewSessionResponse>(
  name: 'session/new',
  dartName: 'sessionNew',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.draft,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'NewSessionRequest',
  paramsCodec: newSessionRequestCodec,
  resultCodec: newSessionResponseCodec,
  resultDefinition: 'NewSessionResponse',
  capabilityPath: 'agentCapabilities.session',
  documentation:
      'Request parameters for creating a new session.\n\nSee protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/v2/draft/session-setup#creating-a-session)',
);

/// Request parameters for sending a user prompt to the agent.
///
/// Contains the user's message and any additional context.
///
/// See protocol docs: [User Message](https://agentclientprotocol.com/protocol/v2/draft/prompt-lifecycle#1-user-message)
const AcpMethodDescriptor<PromptRequest, PromptResponse>
sessionPromptMethod = AcpMethodDescriptor<PromptRequest, PromptResponse>(
  name: 'session/prompt',
  dartName: 'sessionPrompt',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.draft,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'PromptRequest',
  paramsCodec: promptRequestCodec,
  resultCodec: promptResponseCodec,
  resultDefinition: 'PromptResponse',
  capabilityPath: 'agentCapabilities.session',
  documentation:
      'Request parameters for sending a user prompt to the agent.\n\nContains the user\'s message and any additional context.\n\nSee protocol docs: [User Message](https://agentclientprotocol.com/protocol/v2/draft/prompt-lifecycle#1-user-message)',
);

/// Request for user permission to proceed with an operation.
///
/// Sent when the agent needs authorization before performing a sensitive operation.
///
/// See protocol docs: [Requesting Permission](https://agentclientprotocol.com/protocol/v2/draft/tool-calls#requesting-permission)
const AcpMethodDescriptor<RequestPermissionRequest, RequestPermissionResponse>
sessionRequestPermissionMethod =
    AcpMethodDescriptor<RequestPermissionRequest, RequestPermissionResponse>(
      name: 'session/request_permission',
      dartName: 'sessionRequestPermission',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.draft,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'RequestPermissionRequest',
      paramsCodec: requestPermissionRequestCodec,
      resultCodec: requestPermissionResponseCodec,
      resultDefinition: 'RequestPermissionResponse',
      capabilityPath: null,
      documentation:
          'Request for user permission to proceed with an operation.\n\nSent when the agent needs authorization before performing a sensitive operation.\n\nSee protocol docs: [Requesting Permission](https://agentclientprotocol.com/protocol/v2/draft/tool-calls#requesting-permission)',
    );

/// Request parameters for resuming an existing session.
///
/// Resumes an existing session and optionally replays prior conversation
/// history according to `replayFrom`.
const AcpMethodDescriptor<ResumeSessionRequest, ResumeSessionResponse>
sessionResumeMethod =
    AcpMethodDescriptor<ResumeSessionRequest, ResumeSessionResponse>(
      name: 'session/resume',
      dartName: 'sessionResume',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.draft,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'ResumeSessionRequest',
      paramsCodec: resumeSessionRequestCodec,
      resultCodec: resumeSessionResponseCodec,
      resultDefinition: 'ResumeSessionResponse',
      capabilityPath: 'agentCapabilities.session',
      documentation:
          'Request parameters for resuming an existing session.\n\nResumes an existing session and optionally replays prior conversation\nhistory according to `replayFrom`.',
    );

/// Request parameters for setting a session configuration option.
const AcpMethodDescriptor<
  SetSessionConfigOptionRequest,
  SetSessionConfigOptionResponse
>
sessionSetConfigOptionMethod =
    AcpMethodDescriptor<
      SetSessionConfigOptionRequest,
      SetSessionConfigOptionResponse
    >(
      name: 'session/set_config_option',
      dartName: 'sessionSetConfigOption',
      protocol: AcpProtocolGeneration.v2,
      stability: AcpMethodStability.draft,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'SetSessionConfigOptionRequest',
      paramsCodec: setSessionConfigOptionRequestCodec,
      resultCodec: setSessionConfigOptionResponseCodec,
      resultDefinition: 'SetSessionConfigOptionResponse',
      capabilityPath: 'agentCapabilities.session',
      documentation:
          'Request parameters for setting a session configuration option.',
    );

/// Notification containing a session update from the agent.
///
/// Agents can send session updates at any point while the session exists.
///
/// See protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/v2/draft/prompt-lifecycle#3-agent-reports-output)
const AcpMethodDescriptor<UpdateSessionNotification, AcpNoResult>
sessionUpdateMethod = AcpMethodDescriptor<UpdateSessionNotification, AcpNoResult>(
  name: 'session/update',
  dartName: 'sessionUpdate',
  protocol: AcpProtocolGeneration.v2,
  stability: AcpMethodStability.draft,
  direction: AcpMethodDirection.agentToClient,
  kind: AcpMethodKind.notification,
  paramsDefinition: 'UpdateSessionNotification',
  paramsCodec: updateSessionNotificationCodec,
  resultCodec: acpNoResultCodec,
  resultDefinition: null,
  capabilityPath: null,
  documentation:
      'Notification containing a session update from the agent.\n\nAgents can send session updates at any point while the session exists.\n\nSee protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/v2/draft/prompt-lifecycle#3-agent-reports-output)',
);

/// Every generated method descriptor in this lane.
const List<AcpMethodDescriptorBase> v2UnstableMethodDescriptors =
    <AcpMethodDescriptorBase>[
      cancelRequestMethod,
      authLoginMethod,
      authLogoutMethod,
      documentDidChangeMethod,
      documentDidCloseMethod,
      documentDidFocusMethod,
      documentDidOpenMethod,
      documentDidSaveMethod,
      elicitationCompleteMethod,
      elicitationCreateMethod,
      initializeMethod,
      mcpConnectMethod,
      mcpDisconnectMethod,
      mcpMessageClientToAgentRequestMethod,
      mcpMessageClientToAgentNotificationMethod,
      mcpMessageAgentToClientRequestMethod,
      mcpMessageAgentToClientNotificationMethod,
      nesAcceptMethod,
      nesCloseMethod,
      nesRejectMethod,
      nesStartMethod,
      nesSuggestMethod,
      providersDisableMethod,
      providersListMethod,
      providersSetMethod,
      sessionCancelMethod,
      sessionCloseMethod,
      sessionDeleteMethod,
      sessionForkMethod,
      sessionListMethod,
      sessionNewMethod,
      sessionPromptMethod,
      sessionRequestPermissionMethod,
      sessionResumeMethod,
      sessionSetConfigOptionMethod,
      sessionUpdateMethod,
    ];

/// Duplicate-checked lookup registry for this lane.
final AcpMethodRegistry v2UnstableMethodRegistry = AcpMethodRegistry(
  v2UnstableMethodDescriptors,
);
