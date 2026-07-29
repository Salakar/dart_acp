// GENERATED CODE - DO NOT MODIFY BY HAND.
// Schema: snapshots/official/schema/v1/schema.unstable.json
// Metadata SHA-256: 3026898232badf413624010d1343e20bef853e6705c62d6b56387cf9de6b0543

import '../../../method.dart';
import 'models.dart';

/// Notification to cancel an ongoing request.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/cancellation)
const AcpMethodDescriptor<CancelRequestNotification, AcpNoResult>
cancelRequestMethod = AcpMethodDescriptor<CancelRequestNotification, AcpNoResult>(
  name: '\$/cancel_request',
  dartName: 'cancelRequest',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.either,
  kind: AcpMethodKind.notification,
  paramsDefinition: 'CancelRequestNotification',
  paramsCodec: cancelRequestNotificationCodec,
  resultCodec: acpNoResultCodec,
  resultDefinition: null,
  capabilityPath: null,
  documentation:
      'Notification to cancel an ongoing request.\n\nSee protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/cancellation)',
);

/// Request parameters for the authenticate method.
///
/// Specifies which authentication method to use.
const AcpMethodDescriptor<AuthenticateRequest, AuthenticateResponse>
authenticateMethod = AcpMethodDescriptor<AuthenticateRequest, AuthenticateResponse>(
  name: 'authenticate',
  dartName: 'authenticate',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'AuthenticateRequest',
  paramsCodec: authenticateRequestCodec,
  resultCodec: authenticateResponseCodec,
  resultDefinition: 'AuthenticateResponse',
  capabilityPath: 'agentCapabilities.authMethods',
  documentation:
      'Request parameters for the authenticate method.\n\nSpecifies which authentication method to use.',
);

/// Notification sent when a file is edited.
const AcpMethodDescriptor<DidChangeDocumentNotification, AcpNoResult>
documentDidChangeMethod =
    AcpMethodDescriptor<DidChangeDocumentNotification, AcpNoResult>(
      name: 'document/didChange',
      dartName: 'documentDidChange',
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
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
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
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

/// Request to read content from a text file.
///
/// Only available if the client supports the `fs.readTextFile` capability.
const AcpMethodDescriptor<ReadTextFileRequest, ReadTextFileResponse>
fsReadTextFileMethod =
    AcpMethodDescriptor<ReadTextFileRequest, ReadTextFileResponse>(
      name: 'fs/read_text_file',
      dartName: 'fsReadTextFile',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'ReadTextFileRequest',
      paramsCodec: readTextFileRequestCodec,
      resultCodec: readTextFileResponseCodec,
      resultDefinition: 'ReadTextFileResponse',
      capabilityPath: 'clientCapabilities.fs.readTextFile',
      documentation:
          'Request to read content from a text file.\n\nOnly available if the client supports the `fs.readTextFile` capability.',
    );

/// Request to write content to a text file.
///
/// Only available if the client supports the `fs.writeTextFile` capability.
const AcpMethodDescriptor<WriteTextFileRequest, WriteTextFileResponse>
fsWriteTextFileMethod =
    AcpMethodDescriptor<WriteTextFileRequest, WriteTextFileResponse>(
      name: 'fs/write_text_file',
      dartName: 'fsWriteTextFile',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'WriteTextFileRequest',
      paramsCodec: writeTextFileRequestCodec,
      resultCodec: writeTextFileResponseCodec,
      resultDefinition: 'WriteTextFileResponse',
      capabilityPath: 'clientCapabilities.fs.writeTextFile',
      documentation:
          'Request to write content to a text file.\n\nOnly available if the client supports the `fs.writeTextFile` capability.',
    );

/// Request parameters for the initialize method.
///
/// Sent by the client to establish connection and negotiate capabilities.
///
/// See protocol docs: [Initialization](https://agentclientprotocol.com/protocol/initialization)
const AcpMethodDescriptor<InitializeRequest, InitializeResponse>
initializeMethod = AcpMethodDescriptor<InitializeRequest, InitializeResponse>(
  name: 'initialize',
  dartName: 'initialize',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'InitializeRequest',
  paramsCodec: initializeRequestCodec,
  resultCodec: initializeResponseCodec,
  resultDefinition: 'InitializeResponse',
  capabilityPath: null,
  documentation:
      'Request parameters for the initialize method.\n\nSent by the client to establish connection and negotiate capabilities.\n\nSee protocol docs: [Initialization](https://agentclientprotocol.com/protocol/initialization)',
);

/// Request parameters for the logout method.
///
/// Terminates the current authenticated session.
const AcpMethodDescriptor<LogoutRequest, LogoutResponse>
logoutMethod = AcpMethodDescriptor<LogoutRequest, LogoutResponse>(
  name: 'logout',
  dartName: 'logout',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'LogoutRequest',
  paramsCodec: logoutRequestCodec,
  resultCodec: logoutResponseCodec,
  resultDefinition: 'LogoutResponse',
  capabilityPath: 'agentCapabilities.auth.logout',
  documentation:
      'Request parameters for the logout method.\n\nTerminates the current authenticated session.',
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
  protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
  protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
  protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
      protocol: AcpProtocolGeneration.v1,
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
  protocol: AcpProtocolGeneration.v1,
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
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/prompt-turn#cancellation)
const AcpMethodDescriptor<CancelNotification, AcpNoResult>
sessionCancelMethod = AcpMethodDescriptor<CancelNotification, AcpNoResult>(
  name: 'session/cancel',
  dartName: 'sessionCancel',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.notification,
  paramsDefinition: 'CancelNotification',
  paramsCodec: cancelNotificationCodec,
  resultCodec: acpNoResultCodec,
  resultDefinition: null,
  capabilityPath: null,
  documentation:
      'Notification to cancel ongoing operations for a session.\n\nSee protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/prompt-turn#cancellation)',
);

/// Request parameters for closing an active session.
///
/// If supported, the agent **must** cancel any ongoing work related to the session
/// (treat it as if `session/cancel` was called) and then free up any resources
/// associated with the session.
///
/// Only available if the Agent supports the `sessionCapabilities.close` capability.
const AcpMethodDescriptor<CloseSessionRequest, CloseSessionResponse>
sessionCloseMethod = AcpMethodDescriptor<CloseSessionRequest, CloseSessionResponse>(
  name: 'session/close',
  dartName: 'sessionClose',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'CloseSessionRequest',
  paramsCodec: closeSessionRequestCodec,
  resultCodec: closeSessionResponseCodec,
  resultDefinition: 'CloseSessionResponse',
  capabilityPath: 'agentCapabilities.sessionCapabilities.close',
  documentation:
      'Request parameters for closing an active session.\n\nIf supported, the agent **must** cancel any ongoing work related to the session\n(treat it as if `session/cancel` was called) and then free up any resources\nassociated with the session.\n\nOnly available if the Agent supports the `sessionCapabilities.close` capability.',
);

/// Request parameters for deleting an existing session from `session/list`.
///
/// Only available if the Agent supports the `sessionCapabilities.delete` capability.
const AcpMethodDescriptor<DeleteSessionRequest, DeleteSessionResponse>
sessionDeleteMethod =
    AcpMethodDescriptor<DeleteSessionRequest, DeleteSessionResponse>(
      name: 'session/delete',
      dartName: 'sessionDelete',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'DeleteSessionRequest',
      paramsCodec: deleteSessionRequestCodec,
      resultCodec: deleteSessionResponseCodec,
      resultDefinition: 'DeleteSessionResponse',
      capabilityPath: 'agentCapabilities.sessionCapabilities.delete',
      documentation:
          'Request parameters for deleting an existing session from `session/list`.\n\nOnly available if the Agent supports the `sessionCapabilities.delete` capability.',
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
  protocol: AcpProtocolGeneration.v1,
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
///
/// Only available if the Agent supports the `sessionCapabilities.list` capability.
const AcpMethodDescriptor<ListSessionsRequest, ListSessionsResponse>
sessionListMethod = AcpMethodDescriptor<ListSessionsRequest, ListSessionsResponse>(
  name: 'session/list',
  dartName: 'sessionList',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'ListSessionsRequest',
  paramsCodec: listSessionsRequestCodec,
  resultCodec: listSessionsResponseCodec,
  resultDefinition: 'ListSessionsResponse',
  capabilityPath: 'agentCapabilities.sessionCapabilities.list',
  documentation:
      'Request parameters for listing existing sessions.\n\nOnly available if the Agent supports the `sessionCapabilities.list` capability.',
);

/// Request parameters for loading an existing session.
///
/// Only available if the Agent supports the `loadSession` capability.
///
/// See protocol docs: [Loading Sessions](https://agentclientprotocol.com/protocol/session-setup#loading-sessions)
const AcpMethodDescriptor<LoadSessionRequest, LoadSessionResponse>
sessionLoadMethod = AcpMethodDescriptor<LoadSessionRequest, LoadSessionResponse>(
  name: 'session/load',
  dartName: 'sessionLoad',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'LoadSessionRequest',
  paramsCodec: loadSessionRequestCodec,
  resultCodec: loadSessionResponseCodec,
  resultDefinition: 'LoadSessionResponse',
  capabilityPath: 'agentCapabilities.loadSession',
  documentation:
      'Request parameters for loading an existing session.\n\nOnly available if the Agent supports the `loadSession` capability.\n\nSee protocol docs: [Loading Sessions](https://agentclientprotocol.com/protocol/session-setup#loading-sessions)',
);

/// Request parameters for creating a new session.
///
/// See protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/session-setup#creating-a-session)
const AcpMethodDescriptor<NewSessionRequest, NewSessionResponse>
sessionNewMethod = AcpMethodDescriptor<NewSessionRequest, NewSessionResponse>(
  name: 'session/new',
  dartName: 'sessionNew',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'NewSessionRequest',
  paramsCodec: newSessionRequestCodec,
  resultCodec: newSessionResponseCodec,
  resultDefinition: 'NewSessionResponse',
  capabilityPath: null,
  documentation:
      'Request parameters for creating a new session.\n\nSee protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/session-setup#creating-a-session)',
);

/// Request parameters for sending a user prompt to the agent.
///
/// Contains the user's message and any additional context.
///
/// See protocol docs: [User Message](https://agentclientprotocol.com/protocol/prompt-turn#1-user-message)
const AcpMethodDescriptor<PromptRequest, PromptResponse>
sessionPromptMethod = AcpMethodDescriptor<PromptRequest, PromptResponse>(
  name: 'session/prompt',
  dartName: 'sessionPrompt',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.clientToAgent,
  kind: AcpMethodKind.request,
  paramsDefinition: 'PromptRequest',
  paramsCodec: promptRequestCodec,
  resultCodec: promptResponseCodec,
  resultDefinition: 'PromptResponse',
  capabilityPath: null,
  documentation:
      'Request parameters for sending a user prompt to the agent.\n\nContains the user\'s message and any additional context.\n\nSee protocol docs: [User Message](https://agentclientprotocol.com/protocol/prompt-turn#1-user-message)',
);

/// Request for user permission to execute a tool call.
///
/// Sent when the agent needs authorization before performing a sensitive operation.
///
/// See protocol docs: [Requesting Permission](https://agentclientprotocol.com/protocol/tool-calls#requesting-permission)
const AcpMethodDescriptor<RequestPermissionRequest, RequestPermissionResponse>
sessionRequestPermissionMethod =
    AcpMethodDescriptor<RequestPermissionRequest, RequestPermissionResponse>(
      name: 'session/request_permission',
      dartName: 'sessionRequestPermission',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'RequestPermissionRequest',
      paramsCodec: requestPermissionRequestCodec,
      resultCodec: requestPermissionResponseCodec,
      resultDefinition: 'RequestPermissionResponse',
      capabilityPath: null,
      documentation:
          'Request for user permission to execute a tool call.\n\nSent when the agent needs authorization before performing a sensitive operation.\n\nSee protocol docs: [Requesting Permission](https://agentclientprotocol.com/protocol/tool-calls#requesting-permission)',
    );

/// Request parameters for resuming an existing session.
///
/// Resumes an existing session without returning previous messages (unlike `session/load`).
/// This is useful for agents that can resume sessions but don't implement full session loading.
///
/// Only available if the Agent supports the `sessionCapabilities.resume` capability.
const AcpMethodDescriptor<ResumeSessionRequest, ResumeSessionResponse>
sessionResumeMethod =
    AcpMethodDescriptor<ResumeSessionRequest, ResumeSessionResponse>(
      name: 'session/resume',
      dartName: 'sessionResume',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'ResumeSessionRequest',
      paramsCodec: resumeSessionRequestCodec,
      resultCodec: resumeSessionResponseCodec,
      resultDefinition: 'ResumeSessionResponse',
      capabilityPath: 'agentCapabilities.sessionCapabilities.resume',
      documentation:
          'Request parameters for resuming an existing session.\n\nResumes an existing session without returning previous messages (unlike `session/load`).\nThis is useful for agents that can resume sessions but don\'t implement full session loading.\n\nOnly available if the Agent supports the `sessionCapabilities.resume` capability.',
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
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'SetSessionConfigOptionRequest',
      paramsCodec: setSessionConfigOptionRequestCodec,
      resultCodec: setSessionConfigOptionResponseCodec,
      resultDefinition: 'SetSessionConfigOptionResponse',
      capabilityPath: null,
      documentation:
          'Request parameters for setting a session configuration option.',
    );

/// Request parameters for setting a session mode.
const AcpMethodDescriptor<SetSessionModeRequest, SetSessionModeResponse>
sessionSetModeMethod =
    AcpMethodDescriptor<SetSessionModeRequest, SetSessionModeResponse>(
      name: 'session/set_mode',
      dartName: 'sessionSetMode',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      paramsDefinition: 'SetSessionModeRequest',
      paramsCodec: setSessionModeRequestCodec,
      resultCodec: setSessionModeResponseCodec,
      resultDefinition: 'SetSessionModeResponse',
      capabilityPath: null,
      documentation: 'Request parameters for setting a session mode.',
    );

/// Notification containing a session update from the agent.
///
/// Used to stream real-time progress and results during prompt processing.
///
/// See protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/prompt-turn#3-agent-reports-output)
const AcpMethodDescriptor<SessionNotification, AcpNoResult>
sessionUpdateMethod = AcpMethodDescriptor<SessionNotification, AcpNoResult>(
  name: 'session/update',
  dartName: 'sessionUpdate',
  protocol: AcpProtocolGeneration.v1,
  stability: AcpMethodStability.stable,
  direction: AcpMethodDirection.agentToClient,
  kind: AcpMethodKind.notification,
  paramsDefinition: 'SessionNotification',
  paramsCodec: sessionNotificationCodec,
  resultCodec: acpNoResultCodec,
  resultDefinition: null,
  capabilityPath: null,
  documentation:
      'Notification containing a session update from the agent.\n\nUsed to stream real-time progress and results during prompt processing.\n\nSee protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/prompt-turn#3-agent-reports-output)',
);

/// Request to create a new terminal and execute a command.
const AcpMethodDescriptor<CreateTerminalRequest, CreateTerminalResponse>
terminalCreateMethod =
    AcpMethodDescriptor<CreateTerminalRequest, CreateTerminalResponse>(
      name: 'terminal/create',
      dartName: 'terminalCreate',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'CreateTerminalRequest',
      paramsCodec: createTerminalRequestCodec,
      resultCodec: createTerminalResponseCodec,
      resultDefinition: 'CreateTerminalResponse',
      capabilityPath: 'clientCapabilities.terminal',
      documentation: 'Request to create a new terminal and execute a command.',
    );

/// Request to kill a terminal without releasing it.
const AcpMethodDescriptor<KillTerminalRequest, KillTerminalResponse>
terminalKillMethod =
    AcpMethodDescriptor<KillTerminalRequest, KillTerminalResponse>(
      name: 'terminal/kill',
      dartName: 'terminalKill',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'KillTerminalRequest',
      paramsCodec: killTerminalRequestCodec,
      resultCodec: killTerminalResponseCodec,
      resultDefinition: 'KillTerminalResponse',
      capabilityPath: 'clientCapabilities.terminal',
      documentation: 'Request to kill a terminal without releasing it.',
    );

/// Request to get the current output and status of a terminal.
const AcpMethodDescriptor<TerminalOutputRequest, TerminalOutputResponse>
terminalOutputMethod =
    AcpMethodDescriptor<TerminalOutputRequest, TerminalOutputResponse>(
      name: 'terminal/output',
      dartName: 'terminalOutput',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'TerminalOutputRequest',
      paramsCodec: terminalOutputRequestCodec,
      resultCodec: terminalOutputResponseCodec,
      resultDefinition: 'TerminalOutputResponse',
      capabilityPath: 'clientCapabilities.terminal',
      documentation:
          'Request to get the current output and status of a terminal.',
    );

/// Request to release a terminal and free its resources.
const AcpMethodDescriptor<ReleaseTerminalRequest, ReleaseTerminalResponse>
terminalReleaseMethod =
    AcpMethodDescriptor<ReleaseTerminalRequest, ReleaseTerminalResponse>(
      name: 'terminal/release',
      dartName: 'terminalRelease',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'ReleaseTerminalRequest',
      paramsCodec: releaseTerminalRequestCodec,
      resultCodec: releaseTerminalResponseCodec,
      resultDefinition: 'ReleaseTerminalResponse',
      capabilityPath: 'clientCapabilities.terminal',
      documentation: 'Request to release a terminal and free its resources.',
    );

/// Request to wait for a terminal command to exit.
const AcpMethodDescriptor<
  WaitForTerminalExitRequest,
  WaitForTerminalExitResponse
>
terminalWaitForExitMethod =
    AcpMethodDescriptor<
      WaitForTerminalExitRequest,
      WaitForTerminalExitResponse
    >(
      name: 'terminal/wait_for_exit',
      dartName: 'terminalWaitForExit',
      protocol: AcpProtocolGeneration.v1,
      stability: AcpMethodStability.stable,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      paramsDefinition: 'WaitForTerminalExitRequest',
      paramsCodec: waitForTerminalExitRequestCodec,
      resultCodec: waitForTerminalExitResponseCodec,
      resultDefinition: 'WaitForTerminalExitResponse',
      capabilityPath: 'clientCapabilities.terminal',
      documentation: 'Request to wait for a terminal command to exit.',
    );

/// Every generated method descriptor in this lane.
const List<AcpMethodDescriptorBase> v1UnstableMethodDescriptors =
    <AcpMethodDescriptorBase>[
      cancelRequestMethod,
      authenticateMethod,
      documentDidChangeMethod,
      documentDidCloseMethod,
      documentDidFocusMethod,
      documentDidOpenMethod,
      documentDidSaveMethod,
      elicitationCompleteMethod,
      elicitationCreateMethod,
      fsReadTextFileMethod,
      fsWriteTextFileMethod,
      initializeMethod,
      logoutMethod,
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
      sessionLoadMethod,
      sessionNewMethod,
      sessionPromptMethod,
      sessionRequestPermissionMethod,
      sessionResumeMethod,
      sessionSetConfigOptionMethod,
      sessionSetModeMethod,
      sessionUpdateMethod,
      terminalCreateMethod,
      terminalKillMethod,
      terminalOutputMethod,
      terminalReleaseMethod,
      terminalWaitForExitMethod,
    ];

/// Duplicate-checked lookup registry for this lane.
final AcpMethodRegistry v1UnstableMethodRegistry = AcpMethodRegistry(
  v1UnstableMethodDescriptors,
);
