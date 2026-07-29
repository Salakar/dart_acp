// GENERATED CODE - DO NOT MODIFY BY HAND.
// Schema: snapshots/official/schema/v1/schema.json
// Metadata SHA-256: 061edb6efa8fb2aa2792459a86ec7268de5fe665bba48b2ffe7939df01481f88

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
const List<AcpMethodDescriptorBase> v1StableMethodDescriptors =
    <AcpMethodDescriptorBase>[
      cancelRequestMethod,
      authenticateMethod,
      elicitationCompleteMethod,
      elicitationCreateMethod,
      fsReadTextFileMethod,
      fsWriteTextFileMethod,
      initializeMethod,
      logoutMethod,
      sessionCancelMethod,
      sessionCloseMethod,
      sessionDeleteMethod,
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
final AcpMethodRegistry v1StableMethodRegistry = AcpMethodRegistry(
  v1StableMethodDescriptors,
);
