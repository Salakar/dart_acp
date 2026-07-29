// GENERATED CODE - DO NOT MODIFY BY HAND.
// Schema: snapshots/official/schema/v2/schema.json
// Metadata SHA-256: ad94c01f2736416776fd53d66e3aaf89242ab72d99832664f39d6ab41e049736

import '../../../method.dart';
import 'models.dart';

/// Notification to cancel an ongoing request.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/cancellation)
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
      'Notification to cancel an ongoing request.\n\nSee protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/cancellation)',
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
/// See protocol docs: [Initialization](https://agentclientprotocol.com/protocol/v2/initialization)
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
      'Request parameters for the initialize method.\n\nSent by the client to establish connection and negotiate capabilities.\n\nSee protocol docs: [Initialization](https://agentclientprotocol.com/protocol/v2/initialization)',
);

/// Notification to cancel ongoing operations for a session.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#cancellation)
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
      'Notification to cancel ongoing operations for a session.\n\nSee protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#cancellation)',
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
/// See protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/v2/session-setup#creating-a-session)
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
      'Request parameters for creating a new session.\n\nSee protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/v2/session-setup#creating-a-session)',
);

/// Request parameters for sending a user prompt to the agent.
///
/// Contains the user's message and any additional context.
///
/// See protocol docs: [User Message](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#1-user-message)
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
      'Request parameters for sending a user prompt to the agent.\n\nContains the user\'s message and any additional context.\n\nSee protocol docs: [User Message](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#1-user-message)',
);

/// Request for user permission to proceed with an operation.
///
/// Sent when the agent needs authorization before performing a sensitive operation.
///
/// See protocol docs: [Requesting Permission](https://agentclientprotocol.com/protocol/v2/tool-calls#requesting-permission)
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
          'Request for user permission to proceed with an operation.\n\nSent when the agent needs authorization before performing a sensitive operation.\n\nSee protocol docs: [Requesting Permission](https://agentclientprotocol.com/protocol/v2/tool-calls#requesting-permission)',
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
/// See protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#3-agent-reports-output)
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
      'Notification containing a session update from the agent.\n\nAgents can send session updates at any point while the session exists.\n\nSee protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#3-agent-reports-output)',
);

/// Every generated method descriptor in this lane.
const List<AcpMethodDescriptorBase> v2StableMethodDescriptors =
    <AcpMethodDescriptorBase>[
      cancelRequestMethod,
      authLoginMethod,
      authLogoutMethod,
      elicitationCompleteMethod,
      elicitationCreateMethod,
      initializeMethod,
      sessionCancelMethod,
      sessionCloseMethod,
      sessionDeleteMethod,
      sessionListMethod,
      sessionNewMethod,
      sessionPromptMethod,
      sessionRequestPermissionMethod,
      sessionResumeMethod,
      sessionSetConfigOptionMethod,
      sessionUpdateMethod,
    ];

/// Duplicate-checked lookup registry for this lane.
final AcpMethodRegistry v2StableMethodRegistry = AcpMethodRegistry(
  v2StableMethodDescriptors,
);
