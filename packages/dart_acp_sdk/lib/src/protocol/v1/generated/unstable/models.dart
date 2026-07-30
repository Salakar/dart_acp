// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: prefer_initializing_formals, prefer_null_aware_operators, prefer_if_null_operators
// Source: snapshots/official/schema/v1/schema.unstable.json
// SHA-256: 0465fd8b7d52b1b5dac4afec48e3a72e444a52ef262ccf7401e4e59c6039dfb5

import 'package:json_annotation/json_annotation.dart';

import '../../../../common/json_value.dart';
import '../../../../common/patch.dart';
import '../../../../common/value_types.dart';
import '../../../method.dart';
import '../../../resilient_decoder.dart';

part 'models.g.dart';

/// Every schema definition generated for ACP v1 unstable overlay.
const Set<String> schemaDefinitionNames = <String>{
  'AcceptNesNotification',
  'AgentAuthCapabilities',
  'AgentCapabilities',
  'AgentNotification',
  'AgentRequest',
  'AgentResponse',
  'Annotations',
  'AudioContent',
  'AuthCapabilities',
  'AuthMethod',
  'AuthMethodAgent',
  'AuthMethodId',
  'AuthMethodTerminal',
  'AuthenticateRequest',
  'AuthenticateResponse',
  'AvailableCommand',
  'AvailableCommandInput',
  'AvailableCommandsUpdate',
  'BlobResourceContents',
  'BooleanConfigOptionCapabilities',
  'BooleanPropertySchema',
  'CancelNotification',
  'CancelRequestNotification',
  'ClientCapabilities',
  'ClientNesCapabilities',
  'ClientNotification',
  'ClientRequest',
  'ClientResponse',
  'ClientSessionCapabilities',
  'CloseNesRequest',
  'CloseNesResponse',
  'CloseSessionRequest',
  'CloseSessionResponse',
  'CompleteElicitationNotification',
  'ConfigOptionUpdate',
  'ConnectMcpRequest',
  'ConnectMcpResponse',
  'Content',
  'ContentBlock',
  'ContentChunk',
  'Cost',
  'CreateElicitationRequest',
  'CreateElicitationResponse',
  'CreateTerminalRequest',
  'CreateTerminalResponse',
  'CurrentModeUpdate',
  'DeleteSessionRequest',
  'DeleteSessionResponse',
  'DidChangeDocumentNotification',
  'DidCloseDocumentNotification',
  'DidFocusDocumentNotification',
  'DidOpenDocumentNotification',
  'DidSaveDocumentNotification',
  'Diff',
  'DisableProviderRequest',
  'DisableProviderResponse',
  'DisconnectMcpRequest',
  'DisconnectMcpResponse',
  'ElicitationAcceptAction',
  'ElicitationCapabilities',
  'ElicitationContentValue',
  'ElicitationFormCapabilities',
  'ElicitationFormMode',
  'ElicitationId',
  'ElicitationPropertySchema',
  'ElicitationRequestScope',
  'ElicitationSchema',
  'ElicitationSchemaType',
  'ElicitationSessionScope',
  'ElicitationUrlCapabilities',
  'ElicitationUrlMode',
  'EmbeddedResource',
  'EmbeddedResourceResource',
  'EnumOption',
  'EnvVariable',
  'Error',
  'ErrorCode',
  'ExtNotification',
  'ExtRequest',
  'ExtResponse',
  'FileSystemCapabilities',
  'ForkSessionRequest',
  'ForkSessionResponse',
  'HttpHeader',
  'ImageContent',
  'Implementation',
  'InitializeRequest',
  'InitializeResponse',
  'IntegerPropertySchema',
  'KillTerminalRequest',
  'KillTerminalResponse',
  'ListProvidersRequest',
  'ListProvidersResponse',
  'ListSessionsRequest',
  'ListSessionsResponse',
  'LlmProtocol',
  'LoadSessionRequest',
  'LoadSessionResponse',
  'LogoutCapabilities',
  'LogoutRequest',
  'LogoutResponse',
  'McpCapabilities',
  'McpConnectionId',
  'McpServer',
  'McpServerAcp',
  'McpServerAcpId',
  'McpServerHttp',
  'McpServerSse',
  'McpServerStdio',
  'MessageId',
  'MessageMcpNotification',
  'MessageMcpRequest',
  'MessageMcpResponse',
  'MultiSelectItems',
  'MultiSelectPropertySchema',
  'NesCapabilities',
  'NesContextCapabilities',
  'NesDiagnostic',
  'NesDiagnosticSeverity',
  'NesDiagnosticsCapabilities',
  'NesDocumentDidChangeCapabilities',
  'NesDocumentDidCloseCapabilities',
  'NesDocumentDidFocusCapabilities',
  'NesDocumentDidOpenCapabilities',
  'NesDocumentDidSaveCapabilities',
  'NesDocumentEventCapabilities',
  'NesEditHistoryCapabilities',
  'NesEditHistoryEntry',
  'NesEditSuggestion',
  'NesEventCapabilities',
  'NesExcerpt',
  'NesJumpCapabilities',
  'NesJumpSuggestion',
  'NesOpenFile',
  'NesOpenFilesCapabilities',
  'NesRecentFile',
  'NesRecentFilesCapabilities',
  'NesRejectReason',
  'NesRelatedSnippet',
  'NesRelatedSnippetsCapabilities',
  'NesRenameCapabilities',
  'NesRenameSuggestion',
  'NesRepository',
  'NesSearchAndReplaceCapabilities',
  'NesSearchAndReplaceSuggestion',
  'NesSuggestContext',
  'NesSuggestion',
  'NesSuggestionId',
  'NesTextEdit',
  'NesTriggerKind',
  'NesUserAction',
  'NesUserActionsCapabilities',
  'NewSessionRequest',
  'NewSessionResponse',
  'NumberPropertySchema',
  'PermissionOption',
  'PermissionOptionId',
  'PermissionOptionKind',
  'Plan',
  'PlanCapabilities',
  'PlanEntry',
  'PlanEntryPriority',
  'PlanEntryStatus',
  'PlanFile',
  'PlanId',
  'PlanItems',
  'PlanMarkdown',
  'PlanRemoved',
  'PlanUpdate',
  'PlanUpdateContent',
  'Position',
  'PositionEncodingKind',
  'PromptCapabilities',
  'PromptRequest',
  'PromptResponse',
  'ProtocolVersion',
  'ProviderCurrentConfig',
  'ProviderId',
  'ProviderInfo',
  'ProvidersCapabilities',
  'Range',
  'ReadTextFileRequest',
  'ReadTextFileResponse',
  'RejectNesNotification',
  'ReleaseTerminalRequest',
  'ReleaseTerminalResponse',
  'RequestId',
  'RequestPermissionOutcome',
  'RequestPermissionRequest',
  'RequestPermissionResponse',
  'ResourceLink',
  'ResumeSessionRequest',
  'ResumeSessionResponse',
  'Role',
  'SelectedPermissionOutcome',
  'SessionAdditionalDirectoriesCapabilities',
  'SessionCapabilities',
  'SessionCloseCapabilities',
  'SessionConfigBoolean',
  'SessionConfigGroupId',
  'SessionConfigId',
  'SessionConfigOption',
  'SessionConfigOptionCategory',
  'SessionConfigOptionsCapabilities',
  'SessionConfigSelect',
  'SessionConfigSelectGroup',
  'SessionConfigSelectOption',
  'SessionConfigSelectOptions',
  'SessionConfigValueId',
  'SessionDeleteCapabilities',
  'SessionForkCapabilities',
  'SessionId',
  'SessionInfo',
  'SessionInfoUpdate',
  'SessionListCapabilities',
  'SessionMode',
  'SessionModeId',
  'SessionModeState',
  'SessionNotification',
  'SessionResumeCapabilities',
  'SessionUpdate',
  'SetProviderRequest',
  'SetProviderResponse',
  'SetSessionConfigOptionRequest',
  'SetSessionConfigOptionResponse',
  'SetSessionModeRequest',
  'SetSessionModeResponse',
  'StartNesRequest',
  'StartNesResponse',
  'StopReason',
  'StringFormat',
  'StringMultiSelectItems',
  'StringPropertySchema',
  'SuggestNesRequest',
  'SuggestNesResponse',
  'Terminal',
  'TerminalExitStatus',
  'TerminalId',
  'TerminalOutputRequest',
  'TerminalOutputResponse',
  'TextContent',
  'TextDocumentContentChangeEvent',
  'TextDocumentSyncKind',
  'TextResourceContents',
  'TitledMultiSelectItems',
  'ToolCall',
  'ToolCallContent',
  'ToolCallId',
  'ToolCallLocation',
  'ToolCallStatus',
  'ToolCallUpdate',
  'ToolKind',
  'UnstructuredCommandInput',
  'Usage',
  'UsageUpdate',
  'WaitForTerminalExitRequest',
  'WaitForTerminalExitResponse',
  'WorkspaceFolder',
  'WriteTextFileRequest',
  'WriteTextFileResponse',
};

/// SHA-256 of the schema that produced this library.
const String schemaSourceSha256 =
    '0465fd8b7d52b1b5dac4afec48e3a72e444a52ef262ccf7401e4e59c6039dfb5';

SessionId _decodeAcceptNesNotificationSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeAcceptNesNotificationSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

NesSuggestionId _decodeAcceptNesNotificationId(Object? value) =>
    nesSuggestionIdCodec.decode(value);
Object? _encodeAcceptNesNotificationId(NesSuggestionId value) =>
    nesSuggestionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification sent when a suggestion is accepted.
final class AcceptNesNotification implements AcpJsonEncodable {
  /// Creates a AcceptNesNotification value.
  AcceptNesNotification({required this.sessionId, required this.id, this.meta});

  /// The session ID for this notification.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeAcceptNesNotificationSessionId,
    toJson: _encodeAcceptNesNotificationSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The ID of the accepted suggestion.
  @JsonKey(
    name: 'id',
    fromJson: _decodeAcceptNesNotificationId,
    toJson: _encodeAcceptNesNotificationId,
    includeIfNull: false,
    required: true,
  )
  final NesSuggestionId id;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory AcceptNesNotification.fromJson(Map<String, Object?> json) =>
      _$AcceptNesNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$AcceptNesNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AcceptNesNotification].
final class AcceptNesNotificationCodec
    implements AcpCodec<AcceptNesNotification> {
  /// Creates the codec.
  const AcceptNesNotificationCodec();

  @override
  AcceptNesNotification decode(Object? value) =>
      AcceptNesNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(AcceptNesNotification value) => value.toJson();
}

/// Shared codec for [AcceptNesNotification].
const AcceptNesNotificationCodec acceptNesNotificationCodec =
    AcceptNesNotificationCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Authentication-related capabilities supported by the agent.
final class AgentAuthCapabilities implements AcpJsonEncodable {
  /// Creates a AgentAuthCapabilities value.
  AgentAuthCapabilities({this.logout, this.meta});

  /// Whether the agent supports the logout method.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports the logout method.
  final LogoutCapabilities? logout;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AgentAuthCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AgentAuthCapabilities(
      logout: decoder
          .optionalOnError(
            'logout',
            (value) => logoutCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AgentAuthCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (logout != null) {
      result['logout'] = logoutCapabilitiesCodec.encode(logout!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AgentAuthCapabilities].
final class AgentAuthCapabilitiesCodec
    implements AcpCodec<AgentAuthCapabilities> {
  /// Creates the codec.
  const AgentAuthCapabilitiesCodec();

  @override
  AgentAuthCapabilities decode(Object? value) =>
      AgentAuthCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(AgentAuthCapabilities value) => value.toJson();
}

/// Shared codec for [AgentAuthCapabilities].
const AgentAuthCapabilitiesCodec agentAuthCapabilitiesCodec =
    AgentAuthCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Capabilities supported by the agent.
///
/// Advertised during initialization to inform the client about
/// available features and content types.
///
/// See protocol docs: [Agent Capabilities](https://agentclientprotocol.com/protocol/initialization#agent-capabilities)
final class AgentCapabilities implements AcpJsonEncodable {
  /// Creates a AgentCapabilities value.
  AgentCapabilities({
    required this.loadSession,
    required this.promptCapabilities,
    required this.mcpCapabilities,
    required this.sessionCapabilities,
    required this.auth,
    this.providers,
    this.nes,
    this.positionEncoding,
    this.meta,
  });

  /// Whether the agent supports `session/load`.
  final bool loadSession;

  /// Prompt capabilities supported by the agent.
  final PromptCapabilities promptCapabilities;

  /// MCP capabilities supported by the agent.
  final McpCapabilities mcpCapabilities;

  /// Session lifecycle and prompt capabilities advertised by the agent.
  final SessionCapabilities sessionCapabilities;

  /// Authentication-related capabilities supported by the agent.
  final AgentAuthCapabilities auth;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// Provider configuration capabilities supported by the agent.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports provider configuration methods.
  final ProvidersCapabilities? providers;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// NES (Next Edit Suggestions) capabilities supported by the agent.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support
  /// for NES methods.
  final NesCapabilities? nes;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// The position encoding selected by the agent from the client's supported encodings.
  final PositionEncodingKind? positionEncoding;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AgentCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AgentCapabilities(
      loadSession: decoder.defaultOnError(
        'loadSession',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      promptCapabilities: decoder.defaultOnError(
        'promptCapabilities',
        promptCapabilitiesCodec.decode(<String, Object?>{
          'image': false,
          'audio': false,
          'embeddedContext': false,
        }),
        (value) => promptCapabilitiesCodec.decode(value),
      ),
      mcpCapabilities: decoder.defaultOnError(
        'mcpCapabilities',
        mcpCapabilitiesCodec.decode(<String, Object?>{
          'http': false,
          'sse': false,
          'acp': false,
        }),
        (value) => mcpCapabilitiesCodec.decode(value),
      ),
      sessionCapabilities: decoder.defaultOnError(
        'sessionCapabilities',
        sessionCapabilitiesCodec.decode(<String, Object?>{}),
        (value) => sessionCapabilitiesCodec.decode(value),
      ),
      auth: decoder.defaultOnError(
        'auth',
        agentAuthCapabilitiesCodec.decode(<String, Object?>{}),
        (value) => agentAuthCapabilitiesCodec.decode(value),
      ),
      providers: decoder
          .optionalOnError(
            'providers',
            (value) => providersCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      nes: decoder
          .optionalOnError('nes', (value) => nesCapabilitiesCodec.decode(value))
          .valueOrNull,
      positionEncoding: decoder
          .optionalOnError(
            'positionEncoding',
            (value) => positionEncodingKindCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AgentCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['loadSession'] = loadSession;
    result['promptCapabilities'] = promptCapabilitiesCodec.encode(
      promptCapabilities,
    );
    result['mcpCapabilities'] = mcpCapabilitiesCodec.encode(mcpCapabilities);
    result['sessionCapabilities'] = sessionCapabilitiesCodec.encode(
      sessionCapabilities,
    );
    result['auth'] = agentAuthCapabilitiesCodec.encode(auth);
    if (providers != null) {
      result['providers'] = providersCapabilitiesCodec.encode(providers!);
    }
    if (nes != null) {
      result['nes'] = nesCapabilitiesCodec.encode(nes!);
    }
    if (positionEncoding != null) {
      result['positionEncoding'] = positionEncodingKindCodec.encode(
        positionEncoding!,
      );
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AgentCapabilities].
final class AgentCapabilitiesCodec implements AcpCodec<AgentCapabilities> {
  /// Creates the codec.
  const AgentCapabilitiesCodec();

  @override
  AgentCapabilities decode(Object? value) =>
      AgentCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(AgentCapabilities value) => value.toJson();
}

/// Shared codec for [AgentCapabilities].
const AgentCapabilitiesCodec agentCapabilitiesCodec = AgentCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A JSON-RPC notification object.
final class AgentNotification implements AcpJsonEncodable {
  /// Creates a AgentNotification value.
  AgentNotification({required this.method, this.params});

  /// The notification method name.
  final String method;

  /// Method-specific notification parameters.
  final AcpJsonValue? params;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AgentNotification> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AgentNotification(
      method: decoder.required('method', (value) => decodeAcpString(value)),
      params: decoder.optional(
        'params',
        (value) => AcpJsonValue.fromObject(value),
      ),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AgentNotification.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['method'] = method;
    if (params != null) {
      result['params'] = params!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AgentNotification].
final class AgentNotificationCodec implements AcpCodec<AgentNotification> {
  /// Creates the codec.
  const AgentNotificationCodec();

  @override
  AgentNotification decode(Object? value) =>
      AgentNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(AgentNotification value) => value.toJson();
}

/// Shared codec for [AgentNotification].
const AgentNotificationCodec agentNotificationCodec = AgentNotificationCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A JSON-RPC request object.
final class AgentRequest implements AcpJsonEncodable {
  /// Creates a AgentRequest value.
  AgentRequest({required this.id, required this.method, this.params});

  /// The request id used to correlate the matching response.
  final RequestId id;

  /// The method name to invoke.
  final String method;

  /// Method-specific request parameters.
  final AcpJsonValue? params;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AgentRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AgentRequest(
      id: decoder.required('id', (value) => requestIdCodec.decode(value)),
      method: decoder.required('method', (value) => decodeAcpString(value)),
      params: decoder.optional(
        'params',
        (value) => AcpJsonValue.fromObject(value),
      ),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AgentRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['id'] = requestIdCodec.encode(id);
    result['method'] = method;
    if (params != null) {
      result['params'] = params!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AgentRequest].
final class AgentRequestCodec implements AcpCodec<AgentRequest> {
  /// Creates the codec.
  const AgentRequestCodec();

  @override
  AgentRequest decode(Object? value) =>
      AgentRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(AgentRequest value) => value.toJson();
}

/// Shared codec for [AgentRequest].
const AgentRequestCodec agentRequestCodec = AgentRequestCodec();

/// A JSON-RPC response object.
final class AgentResponse implements AcpJsonEncodable {
  /// Creates a raw-preserving schema union value.
  AgentResponse(AcpJsonValue value) : value = value;

  /// The immutable union payload.
  final AcpJsonValue value;

  /// Decodes a union payload.
  factory AgentResponse.fromJson(Object? json) =>
      AgentResponse(AcpJsonValue.fromObject(json));

  /// Encodes the union payload.
  Object? toJson() => value.toObject();

  @override
  AcpJsonValue toAcpJson() => value;
}

/// Codec for [AgentResponse].
final class AgentResponseCodec implements AcpCodec<AgentResponse> {
  /// Creates the codec.
  const AgentResponseCodec();

  @override
  AgentResponse decode(Object? value) => AgentResponse.fromJson(value);

  @override
  Object? encode(AgentResponse value) => value.toJson();
}

/// Shared codec for [AgentResponse].
const AgentResponseCodec agentResponseCodec = AgentResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Optional annotations for the client. The client can use annotations to inform how objects are used or displayed
final class Annotations implements AcpJsonEncodable {
  /// Creates a Annotations value.
  Annotations({
    List<Role>? audience,
    this.lastModified,
    this.priority,
    this.meta,
  }) : audience = audience == null ? null : List<Role>.unmodifiable(audience);

  /// Intended recipients for this content, such as the user or assistant.
  final List<Role>? audience;

  /// Timestamp indicating when the underlying resource was last modified.
  final String? lastModified;

  /// Relative importance of this content when clients choose what to surface.
  final num? priority;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<Annotations> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = Annotations(
      audience: decoder.listSkippingInvalid(
        'audience',
        (value) => roleCodec.decode(value),
        isRequired: false,
      ),
      lastModified: decoder
          .optionalOnError('lastModified', (value) => decodeAcpString(value))
          .valueOrNull,
      priority: decoder
          .optionalOnError('priority', (value) => decodeAcpNumber(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory Annotations.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (audience != null) {
      result['audience'] = <Object?>[
        for (final item in audience!) roleCodec.encode(item),
      ];
    }
    if (lastModified != null) {
      result['lastModified'] = lastModified!;
    }
    if (priority != null) {
      result['priority'] = priority!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Annotations].
final class AnnotationsCodec implements AcpCodec<Annotations> {
  /// Creates the codec.
  const AnnotationsCodec();

  @override
  Annotations decode(Object? value) =>
      Annotations.fromJson(decodeAcpObject(value));

  @override
  Object encode(Annotations value) => value.toJson();
}

/// Shared codec for [Annotations].
const AnnotationsCodec annotationsCodec = AnnotationsCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Audio provided to or from an LLM.
final class AudioContent implements AcpJsonEncodable {
  /// Creates a AudioContent value.
  AudioContent({
    required this.data,
    required this.mimeType,
    this.annotations,
    this.meta,
  });

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// Base64-encoded media payload.
  final String data;

  /// MIME type describing the encoded media payload.
  final String mimeType;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AudioContent> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AudioContent(
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
          .valueOrNull,
      data: decoder.required('data', (value) => decodeAcpString(value)),
      mimeType: decoder.required('mimeType', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AudioContent.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
    }
    result['data'] = data;
    result['mimeType'] = mimeType;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AudioContent].
final class AudioContentCodec implements AcpCodec<AudioContent> {
  /// Creates the codec.
  const AudioContentCodec();

  @override
  AudioContent decode(Object? value) =>
      AudioContent.fromJson(decodeAcpObject(value));

  @override
  Object encode(AudioContent value) => value.toJson();
}

/// Shared codec for [AudioContent].
const AudioContentCodec audioContentCodec = AudioContentCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Authentication capabilities supported by the client.
///
/// Advertised during initialization to inform the agent which authentication
/// method types the client can handle. This governs opt-in types that require
final class AuthCapabilities implements AcpJsonEncodable {
  /// Creates a AuthCapabilities value.
  AuthCapabilities({required this.terminal, this.meta});

  /// Whether the client supports `terminal` authentication methods.
  ///
  /// The client should set this to `true` only when it can reproduce the
  /// configured agent invocation in an interactive terminal. When `true`, the
  /// agent may include `terminal` entries in its authentication methods.
  final bool terminal;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AuthCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AuthCapabilities(
      terminal: decoder.defaultOnError(
        'terminal',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AuthCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['terminal'] = terminal;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AuthCapabilities].
final class AuthCapabilitiesCodec implements AcpCodec<AuthCapabilities> {
  /// Creates the codec.
  const AuthCapabilitiesCodec();

  @override
  AuthCapabilities decode(Object? value) =>
      AuthCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(AuthCapabilities value) => value.toJson();
}

/// Shared codec for [AuthCapabilities].
const AuthCapabilitiesCodec authCapabilitiesCodec = AuthCapabilitiesCodec();

/// Describes an available authentication method.
///
/// The `type` field acts as the discriminator in the serialized JSON form.
/// When no `type` is present, the method is treated as `agent`.
sealed class AuthMethod implements AcpJsonEncodable {
  const AuthMethod();

  /// Decodes one concrete union member.
  factory AuthMethod.fromJson(Object? json) => authMethodCodec.decode(json);

  /// Encodes the concrete union member.
  Object? toJson();

  @override
  AcpJsonValue toAcpJson() => AcpJsonValue.fromObject(toJson());
}

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Client runs the configured agent program as a separate interactive
/// process, without passing this method to `authenticate`.
final class AuthMethodAuthMethodTerminal extends AuthMethod {
  /// Creates this concrete union member.
  const AuthMethodAuthMethodTerminal(this.value);

  /// The typed union value.
  final AuthMethodTerminal value;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    ...decodeAcpObject(authMethodTerminalCodec.encode(value)),
    'type': 'terminal',
  };
}

/// Agent handles authentication itself through `authenticate`.
///
/// This is the default when no `type` is specified.
final class AuthMethodAgentVariant extends AuthMethod {
  /// Creates this concrete union member.
  const AuthMethodAgentVariant(this.value);

  /// The typed union value.
  final AuthMethodAgent value;

  @override
  Object? toJson() => authMethodAgentCodec.encode(value);
}

/// Codec for [AuthMethod].
final class AuthMethodCodec implements AcpCodec<AuthMethod> {
  /// Creates the codec.
  const AuthMethodCodec();

  @override
  AuthMethod decode(Object? value) {
    if (value is Map<Object?, Object?>) {
      final payload = decodeAcpObject(value);
      if (payload['type'] == 'terminal') {
        return AuthMethodAuthMethodTerminal(
          authMethodTerminalCodec.decode(value),
        );
      }
    }
    try {
      return AuthMethodAgentVariant(authMethodAgentCodec.decode(value));
    } on Object {
      // Try the next structurally distinct member.
    }
    throw const FormatException('Value does not match AuthMethod');
  }

  @override
  Object? encode(AuthMethod value) => value.toJson();
}

/// Shared codec for [AuthMethod].
const AuthMethodCodec authMethodCodec = AuthMethodCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Agent handles authentication itself through `authenticate`.
///
/// This is the default authentication method type.
final class AuthMethodAgent implements AcpJsonEncodable {
  /// Creates a AuthMethodAgent value.
  AuthMethodAgent({
    required this.id,
    required this.name,
    this.description,
    this.meta,
  });

  /// Unique identifier for this authentication method.
  final AuthMethodId id;

  /// Human-readable name of the authentication method.
  final String name;

  /// Optional description providing more details about this authentication method.
  final String? description;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AuthMethodAgent> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AuthMethodAgent(
      id: decoder.required('id', (value) => authMethodIdCodec.decode(value)),
      name: decoder.required('name', (value) => decodeAcpString(value)),
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AuthMethodAgent.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['id'] = authMethodIdCodec.encode(id);
    result['name'] = name;
    if (description != null) {
      result['description'] = description!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AuthMethodAgent].
final class AuthMethodAgentCodec implements AcpCodec<AuthMethodAgent> {
  /// Creates the codec.
  const AuthMethodAgentCodec();

  @override
  AuthMethodAgent decode(Object? value) =>
      AuthMethodAgent.fromJson(decodeAcpObject(value));

  @override
  Object encode(AuthMethodAgent value) => value.toJson();
}

/// Shared codec for [AuthMethodAgent].
const AuthMethodAgentCodec authMethodAgentCodec = AuthMethodAgentCodec();

/// Typed identifier used for auth method values on the wire.
final class AuthMethodId implements AcpJsonEncodable {
  /// Validates and creates a AuthMethodId value.
  factory AuthMethodId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return AuthMethodId._(value);
  }

  const AuthMethodId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory AuthMethodId.fromJson(Object? json) =>
      AuthMethodId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is AuthMethodId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [AuthMethodId].
final class AuthMethodIdCodec implements AcpCodec<AuthMethodId> {
  /// Creates the codec.
  const AuthMethodIdCodec();

  @override
  AuthMethodId decode(Object? value) => AuthMethodId.fromJson(value);

  @override
  String encode(AuthMethodId value) => value.toJson();
}

/// Shared codec for [AuthMethodId].
const AuthMethodIdCodec authMethodIdCodec = AuthMethodIdCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Terminal-based authentication method.
///
/// The client runs the configured agent program as a separate interactive
/// process for the user to authenticate via a TUI. Agents MUST advertise this
final class AuthMethodTerminal implements AcpJsonEncodable {
  /// Creates a AuthMethodTerminal value.
  AuthMethodTerminal({
    required this.id,
    required this.name,
    this.description,
    List<String>? args,
    Map<String, String>? env,
    this.meta,
  }) : args = args == null ? null : List<String>.unmodifiable(args),
       env = env == null ? null : Map<String, String>.unmodifiable(env);

  /// Unique identifier for this authentication method.
  final AuthMethodId id;

  /// Human-readable name of the authentication method.
  final String name;

  /// Optional description providing more details about this authentication method.
  final String? description;

  /// Additional arguments to append to the configured agent invocation for terminal auth.
  final List<String>? args;

  /// Additional environment variables to set on the configured agent invocation for terminal auth.
  /// These values override same-named variables in the base launch configuration.
  final Map<String, String>? env;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AuthMethodTerminal> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AuthMethodTerminal(
      id: decoder.required('id', (value) => authMethodIdCodec.decode(value)),
      name: decoder.required('name', (value) => decodeAcpString(value)),
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      args: decoder.listSkippingInvalid(
        'args',
        (value) => decodeAcpString(value),
        isRequired: false,
      ),
      env: decoder
          .optionalOnError(
            'env',
            (value) => Map<String, String>.unmodifiable(<String, String>{
              for (final entry in decodeAcpObject(value).entries)
                entry.key: decodeAcpString(entry.value),
            }),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AuthMethodTerminal.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['id'] = authMethodIdCodec.encode(id);
    result['name'] = name;
    if (description != null) {
      result['description'] = description!;
    }
    if (args != null) {
      result['args'] = <Object?>[for (final item in args!) item];
    }
    if (env != null) {
      result['env'] = <String, Object?>{
        for (final entry in env!.entries) entry.key: entry.value,
      };
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AuthMethodTerminal].
final class AuthMethodTerminalCodec implements AcpCodec<AuthMethodTerminal> {
  /// Creates the codec.
  const AuthMethodTerminalCodec();

  @override
  AuthMethodTerminal decode(Object? value) =>
      AuthMethodTerminal.fromJson(decodeAcpObject(value));

  @override
  Object encode(AuthMethodTerminal value) => value.toJson();
}

/// Shared codec for [AuthMethodTerminal].
const AuthMethodTerminalCodec authMethodTerminalCodec =
    AuthMethodTerminalCodec();

AuthMethodId _decodeAuthenticateRequestMethodId(Object? value) =>
    authMethodIdCodec.decode(value);
Object? _encodeAuthenticateRequestMethodId(AuthMethodId value) =>
    authMethodIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for the authenticate method.
///
/// Specifies which authentication method to use.
final class AuthenticateRequest implements AcpJsonEncodable {
  /// Creates a AuthenticateRequest value.
  AuthenticateRequest({required this.methodId, this.meta});

  /// The ID of the authentication method to use.
  /// Must be one of the methods advertised in the initialize response.
  @JsonKey(
    name: 'methodId',
    fromJson: _decodeAuthenticateRequestMethodId,
    toJson: _encodeAuthenticateRequestMethodId,
    includeIfNull: false,
    required: true,
  )
  final AuthMethodId methodId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory AuthenticateRequest.fromJson(Map<String, Object?> json) =>
      _$AuthenticateRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$AuthenticateRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AuthenticateRequest].
final class AuthenticateRequestCodec implements AcpCodec<AuthenticateRequest> {
  /// Creates the codec.
  const AuthenticateRequestCodec();

  @override
  AuthenticateRequest decode(Object? value) =>
      AuthenticateRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(AuthenticateRequest value) => value.toJson();
}

/// Shared codec for [AuthenticateRequest].
const AuthenticateRequestCodec authenticateRequestCodec =
    AuthenticateRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to the `authenticate` method.
final class AuthenticateResponse implements AcpJsonEncodable {
  /// Creates a AuthenticateResponse value.
  AuthenticateResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory AuthenticateResponse.fromJson(Map<String, Object?> json) =>
      _$AuthenticateResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$AuthenticateResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AuthenticateResponse].
final class AuthenticateResponseCodec
    implements AcpCodec<AuthenticateResponse> {
  /// Creates the codec.
  const AuthenticateResponseCodec();

  @override
  AuthenticateResponse decode(Object? value) =>
      AuthenticateResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(AuthenticateResponse value) => value.toJson();
}

/// Shared codec for [AuthenticateResponse].
const AuthenticateResponseCodec authenticateResponseCodec =
    AuthenticateResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Information about a command.
final class AvailableCommand implements AcpJsonEncodable {
  /// Creates a AvailableCommand value.
  AvailableCommand({
    required this.name,
    required this.description,
    this.input,
    this.meta,
  });

  /// Command name (e.g., `create_plan`, `research_codebase`).
  final String name;

  /// Human-readable description of what the command does.
  final String description;

  /// Input for the command if required
  final AvailableCommandInput? input;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AvailableCommand> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AvailableCommand(
      name: decoder.required('name', (value) => decodeAcpString(value)),
      description: decoder.required(
        'description',
        (value) => decodeAcpString(value),
      ),
      input: decoder
          .optionalOnError(
            'input',
            (value) => availableCommandInputCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AvailableCommand.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['name'] = name;
    result['description'] = description;
    if (input != null) {
      result['input'] = availableCommandInputCodec.encode(input!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AvailableCommand].
final class AvailableCommandCodec implements AcpCodec<AvailableCommand> {
  /// Creates the codec.
  const AvailableCommandCodec();

  @override
  AvailableCommand decode(Object? value) =>
      AvailableCommand.fromJson(decodeAcpObject(value));

  @override
  Object encode(AvailableCommand value) => value.toJson();
}

/// Shared codec for [AvailableCommand].
const AvailableCommandCodec availableCommandCodec = AvailableCommandCodec();

/// The input specification for a command.
sealed class AvailableCommandInput implements AcpJsonEncodable {
  const AvailableCommandInput();

  /// Decodes one concrete union member.
  factory AvailableCommandInput.fromJson(Object? json) =>
      availableCommandInputCodec.decode(json);

  /// Encodes the concrete union member.
  Object? toJson();

  @override
  AcpJsonValue toAcpJson() => AcpJsonValue.fromObject(toJson());
}

/// All text that was typed after the command name is provided as input.
final class AvailableCommandInputUnstructured extends AvailableCommandInput {
  /// Creates this concrete union member.
  const AvailableCommandInputUnstructured(this.value);

  /// The typed union value.
  final UnstructuredCommandInput value;

  @override
  Object? toJson() => unstructuredCommandInputCodec.encode(value);
}

/// Codec for [AvailableCommandInput].
final class AvailableCommandInputCodec
    implements AcpCodec<AvailableCommandInput> {
  /// Creates the codec.
  const AvailableCommandInputCodec();

  @override
  AvailableCommandInput decode(Object? value) {
    try {
      return AvailableCommandInputUnstructured(
        unstructuredCommandInputCodec.decode(value),
      );
    } on Object {
      // Try the next structurally distinct member.
    }
    throw const FormatException('Value does not match AvailableCommandInput');
  }

  @override
  Object? encode(AvailableCommandInput value) => value.toJson();
}

/// Shared codec for [AvailableCommandInput].
const AvailableCommandInputCodec availableCommandInputCodec =
    AvailableCommandInputCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Available commands are ready or have changed
final class AvailableCommandsUpdate implements AcpJsonEncodable {
  /// Creates a AvailableCommandsUpdate value.
  AvailableCommandsUpdate({
    required List<AvailableCommand> availableCommands,
    this.meta,
  }) : availableCommands = List<AvailableCommand>.unmodifiable(
         availableCommands,
       );

  /// Commands the agent can execute
  final List<AvailableCommand> availableCommands;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AvailableCommandsUpdate> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AvailableCommandsUpdate(
      availableCommands: decoder.listSkippingInvalid(
        'availableCommands',
        (value) => availableCommandCodec.decode(value),
        isRequired: true,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AvailableCommandsUpdate.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['availableCommands'] = <Object?>[
      for (final item in availableCommands) availableCommandCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AvailableCommandsUpdate].
final class AvailableCommandsUpdateCodec
    implements AcpCodec<AvailableCommandsUpdate> {
  /// Creates the codec.
  const AvailableCommandsUpdateCodec();

  @override
  AvailableCommandsUpdate decode(Object? value) =>
      AvailableCommandsUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(AvailableCommandsUpdate value) => value.toJson();
}

/// Shared codec for [AvailableCommandsUpdate].
const AvailableCommandsUpdateCodec availableCommandsUpdateCodec =
    AvailableCommandsUpdateCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Binary resource contents.
final class BlobResourceContents implements AcpJsonEncodable {
  /// Creates a BlobResourceContents value.
  BlobResourceContents({
    required this.blob,
    required this.uri,
    this.mimeType,
    this.meta,
  });

  /// Base64-encoded bytes for a binary resource payload.
  final String blob;

  /// MIME type describing the encoded media payload.
  final String? mimeType;

  /// URI associated with this resource or media payload.
  final String uri;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<BlobResourceContents> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = BlobResourceContents(
      blob: decoder.required('blob', (value) => decodeAcpString(value)),
      mimeType: decoder
          .optionalOnError('mimeType', (value) => decodeAcpString(value))
          .valueOrNull,
      uri: decoder.required('uri', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory BlobResourceContents.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['blob'] = blob;
    if (mimeType != null) {
      result['mimeType'] = mimeType!;
    }
    result['uri'] = uri;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [BlobResourceContents].
final class BlobResourceContentsCodec
    implements AcpCodec<BlobResourceContents> {
  /// Creates the codec.
  const BlobResourceContentsCodec();

  @override
  BlobResourceContents decode(Object? value) =>
      BlobResourceContents.fromJson(decodeAcpObject(value));

  @override
  Object encode(BlobResourceContents value) => value.toJson();
}

/// Shared codec for [BlobResourceContents].
const BlobResourceContentsCodec blobResourceContentsCodec =
    BlobResourceContentsCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for boolean session configuration options.
///
/// Supplying `{}` means the client supports boolean session configuration options.
final class BooleanConfigOptionCapabilities implements AcpJsonEncodable {
  /// Creates a BooleanConfigOptionCapabilities value.
  BooleanConfigOptionCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory BooleanConfigOptionCapabilities.fromJson(Map<String, Object?> json) =>
      _$BooleanConfigOptionCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() =>
      _$BooleanConfigOptionCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [BooleanConfigOptionCapabilities].
final class BooleanConfigOptionCapabilitiesCodec
    implements AcpCodec<BooleanConfigOptionCapabilities> {
  /// Creates the codec.
  const BooleanConfigOptionCapabilitiesCodec();

  @override
  BooleanConfigOptionCapabilities decode(Object? value) =>
      BooleanConfigOptionCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(BooleanConfigOptionCapabilities value) => value.toJson();
}

/// Shared codec for [BooleanConfigOptionCapabilities].
const BooleanConfigOptionCapabilitiesCodec
booleanConfigOptionCapabilitiesCodec = BooleanConfigOptionCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Schema for boolean properties in an elicitation form.
final class BooleanPropertySchema implements AcpJsonEncodable {
  /// Creates a BooleanPropertySchema value.
  BooleanPropertySchema({
    this.title,
    this.description,
    this.defaultValue,
    this.meta,
  });

  /// Optional title for the property.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no title is provided.
  final String? title;

  /// Human-readable description.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no description is provided.
  final String? description;

  /// Default value.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no default value is provided.
  final bool? defaultValue;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<BooleanPropertySchema> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = BooleanPropertySchema(
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      defaultValue: decoder
          .optionalOnError('default', (value) => decodeAcpBoolean(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory BooleanPropertySchema.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (title != null) {
      result['title'] = title!;
    }
    if (description != null) {
      result['description'] = description!;
    }
    if (defaultValue != null) {
      result['default'] = defaultValue!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [BooleanPropertySchema].
final class BooleanPropertySchemaCodec
    implements AcpCodec<BooleanPropertySchema> {
  /// Creates the codec.
  const BooleanPropertySchemaCodec();

  @override
  BooleanPropertySchema decode(Object? value) =>
      BooleanPropertySchema.fromJson(decodeAcpObject(value));

  @override
  Object encode(BooleanPropertySchema value) => value.toJson();
}

/// Shared codec for [BooleanPropertySchema].
const BooleanPropertySchemaCodec booleanPropertySchemaCodec =
    BooleanPropertySchemaCodec();

SessionId _decodeCancelNotificationSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeCancelNotificationSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification to cancel ongoing operations for a session.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/prompt-turn#cancellation)
final class CancelNotification implements AcpJsonEncodable {
  /// Creates a CancelNotification value.
  CancelNotification({required this.sessionId, this.meta});

  /// The ID of the session to cancel operations for.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeCancelNotificationSessionId,
    toJson: _encodeCancelNotificationSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CancelNotification.fromJson(Map<String, Object?> json) =>
      _$CancelNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CancelNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CancelNotification].
final class CancelNotificationCodec implements AcpCodec<CancelNotification> {
  /// Creates the codec.
  const CancelNotificationCodec();

  @override
  CancelNotification decode(Object? value) =>
      CancelNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(CancelNotification value) => value.toJson();
}

/// Shared codec for [CancelNotification].
const CancelNotificationCodec cancelNotificationCodec =
    CancelNotificationCodec();

RequestId _decodeCancelRequestNotificationRequestId(Object? value) =>
    requestIdCodec.decode(value);
Object? _encodeCancelRequestNotificationRequestId(RequestId value) =>
    requestIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification to cancel an ongoing request.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/cancellation)
final class CancelRequestNotification implements AcpJsonEncodable {
  /// Creates a CancelRequestNotification value.
  CancelRequestNotification({required this.requestId, this.meta});

  /// The ID of the request to cancel.
  @JsonKey(
    name: 'requestId',
    fromJson: _decodeCancelRequestNotificationRequestId,
    toJson: _encodeCancelRequestNotificationRequestId,
    includeIfNull: true,
    required: true,
  )
  final RequestId requestId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CancelRequestNotification.fromJson(Map<String, Object?> json) =>
      _$CancelRequestNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CancelRequestNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CancelRequestNotification].
final class CancelRequestNotificationCodec
    implements AcpCodec<CancelRequestNotification> {
  /// Creates the codec.
  const CancelRequestNotificationCodec();

  @override
  CancelRequestNotification decode(Object? value) =>
      CancelRequestNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(CancelRequestNotification value) => value.toJson();
}

/// Shared codec for [CancelRequestNotification].
const CancelRequestNotificationCodec cancelRequestNotificationCodec =
    CancelRequestNotificationCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Capabilities supported by the client.
///
/// Advertised during initialization to inform the agent about
/// available features and methods.
///
/// See protocol docs: [Client Capabilities](https://agentclientprotocol.com/protocol/initialization#client-capabilities)
final class ClientCapabilities implements AcpJsonEncodable {
  /// Creates a ClientCapabilities value.
  ClientCapabilities({
    required this.fs,
    required this.terminal,
    required this.auth,
    this.session,
    this.plan,
    this.elicitation,
    this.nes,
    List<PositionEncodingKind>? positionEncodings,
    this.meta,
  }) : positionEncodings = positionEncodings == null
           ? null
           : List<PositionEncodingKind>.unmodifiable(positionEncodings);

  /// File system capabilities supported by the client.
  /// Determines which file operations the agent can request.
  final FileSystemCapabilities fs;

  /// Whether the Client support all `terminal/*` methods.
  final bool terminal;

  /// Session-related capabilities supported by the client.
  ///
  /// Optional. Omitted or `null` both mean the client does not advertise any
  /// session-related extensions.
  final ClientSessionCapabilities? session;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// Whether the client supports `plan_update` and `plan_removed` session updates.
  ///
  /// Optional. Omitted or `null` both mean the client does not advertise support.
  /// Supplying `{}` means the client can receive both update types.
  final PlanCapabilities? plan;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// Authentication capabilities supported by the client.
  /// Determines which authentication method types the agent may include
  /// in its `InitializeResponse`.
  final AuthCapabilities auth;

  /// Elicitation capabilities supported by the client.
  /// Determines which elicitation modes the agent may use.
  ///
  /// Optional. Omitted or `null` both mean the client does not advertise
  /// elicitation support.
  final ElicitationCapabilities? elicitation;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// NES (Next Edit Suggestions) capabilities supported by the client.
  ///
  /// Optional. Omitted or `null` both mean the client does not advertise any
  /// NES suggestion-kind extensions.
  final ClientNesCapabilities? nes;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// The position encodings supported by the client, in order of preference.
  final List<PositionEncodingKind>? positionEncodings;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ClientCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ClientCapabilities(
      fs: decoder.defaultOnError(
        'fs',
        fileSystemCapabilitiesCodec.decode(<String, Object?>{
          'readTextFile': false,
          'writeTextFile': false,
        }),
        (value) => fileSystemCapabilitiesCodec.decode(value),
      ),
      terminal: decoder.defaultOnError(
        'terminal',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      session: decoder
          .optionalOnError(
            'session',
            (value) => clientSessionCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      plan: decoder
          .optionalOnError(
            'plan',
            (value) => planCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      auth: decoder.defaultOnError(
        'auth',
        authCapabilitiesCodec.decode(<String, Object?>{'terminal': false}),
        (value) => authCapabilitiesCodec.decode(value),
      ),
      elicitation: decoder
          .optionalOnError(
            'elicitation',
            (value) => elicitationCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      nes: decoder
          .optionalOnError(
            'nes',
            (value) => clientNesCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      positionEncodings: decoder.listSkippingInvalid(
        'positionEncodings',
        (value) => positionEncodingKindCodec.decode(value),
        isRequired: false,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ClientCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['fs'] = fileSystemCapabilitiesCodec.encode(fs);
    result['terminal'] = terminal;
    if (session != null) {
      result['session'] = clientSessionCapabilitiesCodec.encode(session!);
    }
    if (plan != null) {
      result['plan'] = planCapabilitiesCodec.encode(plan!);
    }
    result['auth'] = authCapabilitiesCodec.encode(auth);
    if (elicitation != null) {
      result['elicitation'] = elicitationCapabilitiesCodec.encode(elicitation!);
    }
    if (nes != null) {
      result['nes'] = clientNesCapabilitiesCodec.encode(nes!);
    }
    if (positionEncodings != null) {
      result['positionEncodings'] = <Object?>[
        for (final item in positionEncodings!)
          positionEncodingKindCodec.encode(item),
      ];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ClientCapabilities].
final class ClientCapabilitiesCodec implements AcpCodec<ClientCapabilities> {
  /// Creates the codec.
  const ClientCapabilitiesCodec();

  @override
  ClientCapabilities decode(Object? value) =>
      ClientCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(ClientCapabilities value) => value.toJson();
}

/// Shared codec for [ClientCapabilities].
const ClientCapabilitiesCodec clientCapabilitiesCodec =
    ClientCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// NES capabilities advertised by the client during initialization.
final class ClientNesCapabilities implements AcpJsonEncodable {
  /// Creates a ClientNesCapabilities value.
  ClientNesCapabilities({
    this.jump,
    this.rename,
    this.searchAndReplace,
    this.meta,
  });

  /// Whether the client supports the `jump` suggestion kind.
  final NesJumpCapabilities? jump;

  /// Whether the client supports the `rename` suggestion kind.
  final NesRenameCapabilities? rename;

  /// Whether the client supports the `searchAndReplace` suggestion kind.
  final NesSearchAndReplaceCapabilities? searchAndReplace;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ClientNesCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ClientNesCapabilities(
      jump: decoder
          .optionalOnError(
            'jump',
            (value) => nesJumpCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      rename: decoder
          .optionalOnError(
            'rename',
            (value) => nesRenameCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      searchAndReplace: decoder
          .optionalOnError(
            'searchAndReplace',
            (value) => nesSearchAndReplaceCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ClientNesCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (jump != null) {
      result['jump'] = nesJumpCapabilitiesCodec.encode(jump!);
    }
    if (rename != null) {
      result['rename'] = nesRenameCapabilitiesCodec.encode(rename!);
    }
    if (searchAndReplace != null) {
      result['searchAndReplace'] = nesSearchAndReplaceCapabilitiesCodec.encode(
        searchAndReplace!,
      );
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ClientNesCapabilities].
final class ClientNesCapabilitiesCodec
    implements AcpCodec<ClientNesCapabilities> {
  /// Creates the codec.
  const ClientNesCapabilitiesCodec();

  @override
  ClientNesCapabilities decode(Object? value) =>
      ClientNesCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(ClientNesCapabilities value) => value.toJson();
}

/// Shared codec for [ClientNesCapabilities].
const ClientNesCapabilitiesCodec clientNesCapabilitiesCodec =
    ClientNesCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A JSON-RPC notification object.
final class ClientNotification implements AcpJsonEncodable {
  /// Creates a ClientNotification value.
  ClientNotification({required this.method, this.params});

  /// The notification method name.
  final String method;

  /// Method-specific notification parameters.
  final AcpJsonValue? params;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ClientNotification> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ClientNotification(
      method: decoder.required('method', (value) => decodeAcpString(value)),
      params: decoder.optional(
        'params',
        (value) => AcpJsonValue.fromObject(value),
      ),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ClientNotification.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['method'] = method;
    if (params != null) {
      result['params'] = params!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ClientNotification].
final class ClientNotificationCodec implements AcpCodec<ClientNotification> {
  /// Creates the codec.
  const ClientNotificationCodec();

  @override
  ClientNotification decode(Object? value) =>
      ClientNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(ClientNotification value) => value.toJson();
}

/// Shared codec for [ClientNotification].
const ClientNotificationCodec clientNotificationCodec =
    ClientNotificationCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A JSON-RPC request object.
final class ClientRequest implements AcpJsonEncodable {
  /// Creates a ClientRequest value.
  ClientRequest({required this.id, required this.method, this.params});

  /// The request id used to correlate the matching response.
  final RequestId id;

  /// The method name to invoke.
  final String method;

  /// Method-specific request parameters.
  final AcpJsonValue? params;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ClientRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ClientRequest(
      id: decoder.required('id', (value) => requestIdCodec.decode(value)),
      method: decoder.required('method', (value) => decodeAcpString(value)),
      params: decoder.optional(
        'params',
        (value) => AcpJsonValue.fromObject(value),
      ),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ClientRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['id'] = requestIdCodec.encode(id);
    result['method'] = method;
    if (params != null) {
      result['params'] = params!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ClientRequest].
final class ClientRequestCodec implements AcpCodec<ClientRequest> {
  /// Creates the codec.
  const ClientRequestCodec();

  @override
  ClientRequest decode(Object? value) =>
      ClientRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(ClientRequest value) => value.toJson();
}

/// Shared codec for [ClientRequest].
const ClientRequestCodec clientRequestCodec = ClientRequestCodec();

/// A JSON-RPC response object.
final class ClientResponse implements AcpJsonEncodable {
  /// Creates a raw-preserving schema union value.
  ClientResponse(AcpJsonValue value) : value = value;

  /// The immutable union payload.
  final AcpJsonValue value;

  /// Decodes a union payload.
  factory ClientResponse.fromJson(Object? json) =>
      ClientResponse(AcpJsonValue.fromObject(json));

  /// Encodes the union payload.
  Object? toJson() => value.toObject();

  @override
  AcpJsonValue toAcpJson() => value;
}

/// Codec for [ClientResponse].
final class ClientResponseCodec implements AcpCodec<ClientResponse> {
  /// Creates the codec.
  const ClientResponseCodec();

  @override
  ClientResponse decode(Object? value) => ClientResponse.fromJson(value);

  @override
  Object? encode(ClientResponse value) => value.toJson();
}

/// Shared codec for [ClientResponse].
const ClientResponseCodec clientResponseCodec = ClientResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Session-related capabilities supported by the client.
final class ClientSessionCapabilities implements AcpJsonEncodable {
  /// Creates a ClientSessionCapabilities value.
  ClientSessionCapabilities({this.configOptions, this.meta});

  /// Config option capabilities supported by the client.
  ///
  /// Omitted or `null` both mean the client does not advertise support for any
  /// config option extensions.
  final SessionConfigOptionsCapabilities? configOptions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ClientSessionCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ClientSessionCapabilities(
      configOptions: decoder
          .optionalOnError(
            'configOptions',
            (value) => sessionConfigOptionsCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ClientSessionCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (configOptions != null) {
      result['configOptions'] = sessionConfigOptionsCapabilitiesCodec.encode(
        configOptions!,
      );
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ClientSessionCapabilities].
final class ClientSessionCapabilitiesCodec
    implements AcpCodec<ClientSessionCapabilities> {
  /// Creates the codec.
  const ClientSessionCapabilitiesCodec();

  @override
  ClientSessionCapabilities decode(Object? value) =>
      ClientSessionCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(ClientSessionCapabilities value) => value.toJson();
}

/// Shared codec for [ClientSessionCapabilities].
const ClientSessionCapabilitiesCodec clientSessionCapabilitiesCodec =
    ClientSessionCapabilitiesCodec();

SessionId _decodeCloseNesRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeCloseNesRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request to close an NES session.
///
/// The agent **must** cancel any ongoing work related to the NES session
/// and then free up any resources associated with the session.
final class CloseNesRequest implements AcpJsonEncodable {
  /// Creates a CloseNesRequest value.
  CloseNesRequest({required this.sessionId, this.meta});

  /// The ID of the NES session to close.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeCloseNesRequestSessionId,
    toJson: _encodeCloseNesRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CloseNesRequest.fromJson(Map<String, Object?> json) =>
      _$CloseNesRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CloseNesRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CloseNesRequest].
final class CloseNesRequestCodec implements AcpCodec<CloseNesRequest> {
  /// Creates the codec.
  const CloseNesRequestCodec();

  @override
  CloseNesRequest decode(Object? value) =>
      CloseNesRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(CloseNesRequest value) => value.toJson();
}

/// Shared codec for [CloseNesRequest].
const CloseNesRequestCodec closeNesRequestCodec = CloseNesRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response from closing an NES session.
final class CloseNesResponse implements AcpJsonEncodable {
  /// Creates a CloseNesResponse value.
  CloseNesResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CloseNesResponse.fromJson(Map<String, Object?> json) =>
      _$CloseNesResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CloseNesResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CloseNesResponse].
final class CloseNesResponseCodec implements AcpCodec<CloseNesResponse> {
  /// Creates the codec.
  const CloseNesResponseCodec();

  @override
  CloseNesResponse decode(Object? value) =>
      CloseNesResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(CloseNesResponse value) => value.toJson();
}

/// Shared codec for [CloseNesResponse].
const CloseNesResponseCodec closeNesResponseCodec = CloseNesResponseCodec();

SessionId _decodeCloseSessionRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeCloseSessionRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for closing an active session.
///
/// If supported, the agent **must** cancel any ongoing work related to the session
/// (treat it as if `session/cancel` was called) and then free up any resources
/// associated with the session.
///
/// Only available if the Agent supports the `sessionCapabilities.close` capability.
final class CloseSessionRequest implements AcpJsonEncodable {
  /// Creates a CloseSessionRequest value.
  CloseSessionRequest({required this.sessionId, this.meta});

  /// The ID of the session to close.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeCloseSessionRequestSessionId,
    toJson: _encodeCloseSessionRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CloseSessionRequest.fromJson(Map<String, Object?> json) =>
      _$CloseSessionRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CloseSessionRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CloseSessionRequest].
final class CloseSessionRequestCodec implements AcpCodec<CloseSessionRequest> {
  /// Creates the codec.
  const CloseSessionRequestCodec();

  @override
  CloseSessionRequest decode(Object? value) =>
      CloseSessionRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(CloseSessionRequest value) => value.toJson();
}

/// Shared codec for [CloseSessionRequest].
const CloseSessionRequestCodec closeSessionRequestCodec =
    CloseSessionRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response from closing a session.
final class CloseSessionResponse implements AcpJsonEncodable {
  /// Creates a CloseSessionResponse value.
  CloseSessionResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CloseSessionResponse.fromJson(Map<String, Object?> json) =>
      _$CloseSessionResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CloseSessionResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CloseSessionResponse].
final class CloseSessionResponseCodec
    implements AcpCodec<CloseSessionResponse> {
  /// Creates the codec.
  const CloseSessionResponseCodec();

  @override
  CloseSessionResponse decode(Object? value) =>
      CloseSessionResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(CloseSessionResponse value) => value.toJson();
}

/// Shared codec for [CloseSessionResponse].
const CloseSessionResponseCodec closeSessionResponseCodec =
    CloseSessionResponseCodec();

ElicitationId _decodeCompleteElicitationNotificationElicitationId(
  Object? value,
) => elicitationIdCodec.decode(value);
Object? _encodeCompleteElicitationNotificationElicitationId(
  ElicitationId value,
) => elicitationIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification sent by the agent when a URL-based elicitation is complete.
final class CompleteElicitationNotification implements AcpJsonEncodable {
  /// Creates a CompleteElicitationNotification value.
  CompleteElicitationNotification({required this.elicitationId, this.meta});

  /// The ID of the elicitation that completed.
  @JsonKey(
    name: 'elicitationId',
    fromJson: _decodeCompleteElicitationNotificationElicitationId,
    toJson: _encodeCompleteElicitationNotificationElicitationId,
    includeIfNull: false,
    required: true,
  )
  final ElicitationId elicitationId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CompleteElicitationNotification.fromJson(Map<String, Object?> json) =>
      _$CompleteElicitationNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() =>
      _$CompleteElicitationNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CompleteElicitationNotification].
final class CompleteElicitationNotificationCodec
    implements AcpCodec<CompleteElicitationNotification> {
  /// Creates the codec.
  const CompleteElicitationNotificationCodec();

  @override
  CompleteElicitationNotification decode(Object? value) =>
      CompleteElicitationNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(CompleteElicitationNotification value) => value.toJson();
}

/// Shared codec for [CompleteElicitationNotification].
const CompleteElicitationNotificationCodec
completeElicitationNotificationCodec = CompleteElicitationNotificationCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Session configuration options have been updated.
final class ConfigOptionUpdate implements AcpJsonEncodable {
  /// Creates a ConfigOptionUpdate value.
  ConfigOptionUpdate({
    required List<SessionConfigOption> configOptions,
    this.meta,
  }) : configOptions = List<SessionConfigOption>.unmodifiable(configOptions);

  /// The full set of configuration options and their current values.
  final List<SessionConfigOption> configOptions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ConfigOptionUpdate> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ConfigOptionUpdate(
      configOptions: decoder.listSkippingInvalid(
        'configOptions',
        (value) => sessionConfigOptionCodec.decode(value),
        isRequired: true,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ConfigOptionUpdate.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['configOptions'] = <Object?>[
      for (final item in configOptions) sessionConfigOptionCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ConfigOptionUpdate].
final class ConfigOptionUpdateCodec implements AcpCodec<ConfigOptionUpdate> {
  /// Creates the codec.
  const ConfigOptionUpdateCodec();

  @override
  ConfigOptionUpdate decode(Object? value) =>
      ConfigOptionUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(ConfigOptionUpdate value) => value.toJson();
}

/// Shared codec for [ConfigOptionUpdate].
const ConfigOptionUpdateCodec configOptionUpdateCodec =
    ConfigOptionUpdateCodec();

McpServerAcpId _decodeConnectMcpRequestServerId(Object? value) =>
    mcpServerAcpIdCodec.decode(value);
Object? _encodeConnectMcpRequestServerId(McpServerAcpId value) =>
    mcpServerAcpIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `mcp/connect`.
final class ConnectMcpRequest implements AcpJsonEncodable {
  /// Creates a ConnectMcpRequest value.
  ConnectMcpRequest({required this.serverId, this.meta});

  /// The ACP MCP server ID that was provided by the component declaring the MCP server.
  @JsonKey(
    name: 'serverId',
    fromJson: _decodeConnectMcpRequestServerId,
    toJson: _encodeConnectMcpRequestServerId,
    includeIfNull: false,
    required: true,
  )
  final McpServerAcpId serverId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ConnectMcpRequest.fromJson(Map<String, Object?> json) =>
      _$ConnectMcpRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ConnectMcpRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ConnectMcpRequest].
final class ConnectMcpRequestCodec implements AcpCodec<ConnectMcpRequest> {
  /// Creates the codec.
  const ConnectMcpRequestCodec();

  @override
  ConnectMcpRequest decode(Object? value) =>
      ConnectMcpRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(ConnectMcpRequest value) => value.toJson();
}

/// Shared codec for [ConnectMcpRequest].
const ConnectMcpRequestCodec connectMcpRequestCodec = ConnectMcpRequestCodec();

McpConnectionId _decodeConnectMcpResponseConnectionId(Object? value) =>
    mcpConnectionIdCodec.decode(value);
Object? _encodeConnectMcpResponseConnectionId(McpConnectionId value) =>
    mcpConnectionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Response to `mcp/connect`.
final class ConnectMcpResponse implements AcpJsonEncodable {
  /// Creates a ConnectMcpResponse value.
  ConnectMcpResponse({required this.connectionId, this.meta});

  /// The unique identifier for this MCP-over-ACP connection.
  @JsonKey(
    name: 'connectionId',
    fromJson: _decodeConnectMcpResponseConnectionId,
    toJson: _encodeConnectMcpResponseConnectionId,
    includeIfNull: false,
    required: true,
  )
  final McpConnectionId connectionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ConnectMcpResponse.fromJson(Map<String, Object?> json) =>
      _$ConnectMcpResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ConnectMcpResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ConnectMcpResponse].
final class ConnectMcpResponseCodec implements AcpCodec<ConnectMcpResponse> {
  /// Creates the codec.
  const ConnectMcpResponseCodec();

  @override
  ConnectMcpResponse decode(Object? value) =>
      ConnectMcpResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(ConnectMcpResponse value) => value.toJson();
}

/// Shared codec for [ConnectMcpResponse].
const ConnectMcpResponseCodec connectMcpResponseCodec =
    ConnectMcpResponseCodec();

ContentBlock _decodeContentContent(Object? value) =>
    contentBlockCodec.decode(value);
Object? _encodeContentContent(ContentBlock value) =>
    contentBlockCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Standard content block (text, images, resources).
final class Content implements AcpJsonEncodable {
  /// Creates a Content value.
  Content({required this.content, this.meta});

  /// The actual content block.
  @JsonKey(
    name: 'content',
    fromJson: _decodeContentContent,
    toJson: _encodeContentContent,
    includeIfNull: false,
    required: true,
  )
  final ContentBlock content;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory Content.fromJson(Map<String, Object?> json) =>
      _$ContentFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ContentToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Content].
final class ContentCodec implements AcpCodec<Content> {
  /// Creates the codec.
  const ContentCodec();

  @override
  Content decode(Object? value) => Content.fromJson(decodeAcpObject(value));

  @override
  Object encode(Content value) => value.toJson();
}

/// Shared codec for [Content].
const ContentCodec contentCodec = ContentCodec();

/// Content blocks represent displayable information in the Agent Client Protocol.
///
/// They provide a structured way to handle various types of user-facing content—whether
/// it's text from language models, images for analysis, or embedded resources for context.
///
/// Content blocks appear in:
/// - User prompts sent via `session/prompt`
/// - Language model output streamed through `session/update` notifications
sealed class ContentBlock implements AcpJsonEncodable {
  const ContentBlock();

  /// Decodes the tagged union.
  factory ContentBlock.fromJson(Object? json) => contentBlockCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// Text content. May be plain text or formatted with Markdown.
///
/// All agents MUST support text content blocks in prompts.
/// Clients SHOULD render this text as Markdown.
final class ContentBlockText extends ContentBlock {
  /// Creates this known tagged-union variant.
  const ContentBlockText(this.value);

  /// The typed variant payload.
  final TextContent value;

  @override
  String get discriminator => 'text';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(textContentCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Images for visual context or analysis.
///
/// Requires the `image` prompt capability when included in prompts.
final class ContentBlockImage extends ContentBlock {
  /// Creates this known tagged-union variant.
  const ContentBlockImage(this.value);

  /// The typed variant payload.
  final ImageContent value;

  @override
  String get discriminator => 'image';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(imageContentCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Audio data for transcription or analysis.
///
/// Requires the `audio` prompt capability when included in prompts.
final class ContentBlockAudio extends ContentBlock {
  /// Creates this known tagged-union variant.
  const ContentBlockAudio(this.value);

  /// The typed variant payload.
  final AudioContent value;

  @override
  String get discriminator => 'audio';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(audioContentCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// References to resources that the agent can access.
///
/// All agents MUST support resource links in prompts.
final class ContentBlockResourceLink extends ContentBlock {
  /// Creates this known tagged-union variant.
  const ContentBlockResourceLink(this.value);

  /// The typed variant payload.
  final ResourceLink value;

  @override
  String get discriminator => 'resource_link';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(resourceLinkCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Complete resource contents embedded directly in the message.
///
/// Preferred for including context as it avoids extra round-trips.
///
/// Requires the `embeddedContext` prompt capability when included in prompts.
final class ContentBlockResource extends ContentBlock {
  /// Creates this known tagged-union variant.
  const ContentBlockResource(this.value);

  /// The typed variant payload.
  final EmbeddedResource value;

  @override
  String get discriminator => 'resource';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(embeddedResourceCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Codec for [ContentBlock].
final class ContentBlockCodec implements AcpCodec<ContentBlock> {
  /// Creates the codec.
  const ContentBlockCodec();

  @override
  ContentBlock decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'text':
        return ContentBlockText(textContentCodec.decode(payload));
      case 'image':
        return ContentBlockImage(imageContentCodec.decode(payload));
      case 'audio':
        return ContentBlockAudio(audioContentCodec.decode(payload));
      case 'resource_link':
        return ContentBlockResourceLink(resourceLinkCodec.decode(payload));
      case 'resource':
        return ContentBlockResource(embeddedResourceCodec.decode(payload));
      default:
        throw FormatException('Unknown ContentBlock tag: $tag');
    }
  }

  @override
  Object encode(ContentBlock value) => value.toJson();
}

/// Shared codec for [ContentBlock].
const ContentBlockCodec contentBlockCodec = ContentBlockCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A streamed item of content
final class ContentChunk implements AcpJsonEncodable {
  /// Creates a ContentChunk value.
  ContentChunk({required this.content, this.messageId, this.meta});

  /// A single item of content
  final ContentBlock content;

  /// A unique identifier for the message this chunk belongs to.
  ///
  /// All chunks belonging to the same message share the same `messageId`.
  /// A change in `messageId` indicates a new message has started.
  final MessageId? messageId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ContentChunk> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ContentChunk(
      content: decoder.required(
        'content',
        (value) => contentBlockCodec.decode(value),
      ),
      messageId: decoder
          .optionalOnError('messageId', (value) => messageIdCodec.decode(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ContentChunk.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['content'] = contentBlockCodec.encode(content);
    if (messageId != null) {
      result['messageId'] = messageIdCodec.encode(messageId!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ContentChunk].
final class ContentChunkCodec implements AcpCodec<ContentChunk> {
  /// Creates the codec.
  const ContentChunkCodec();

  @override
  ContentChunk decode(Object? value) =>
      ContentChunk.fromJson(decodeAcpObject(value));

  @override
  Object encode(ContentChunk value) => value.toJson();
}

/// Shared codec for [ContentChunk].
const ContentChunkCodec contentChunkCodec = ContentChunkCodec();

num _decodeCostAmount(Object? value) => decodeAcpNumber(value);
Object? _encodeCostAmount(num value) => value;

String _decodeCostCurrency(Object? value) => decodeAcpString(value);
Object? _encodeCostCurrency(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Cost information for a session.
final class Cost implements AcpJsonEncodable {
  /// Creates a Cost value.
  Cost({required this.amount, required this.currency, this.meta});

  /// Total cumulative cost for session.
  @JsonKey(
    name: 'amount',
    fromJson: _decodeCostAmount,
    toJson: _encodeCostAmount,
    includeIfNull: false,
    required: true,
  )
  final num amount;

  /// ISO 4217 currency code (e.g., "USD", "EUR").
  @JsonKey(
    name: 'currency',
    fromJson: _decodeCostCurrency,
    toJson: _encodeCostCurrency,
    includeIfNull: false,
    required: true,
  )
  final String currency;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory Cost.fromJson(Map<String, Object?> json) => _$CostFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CostToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Cost].
final class CostCodec implements AcpCodec<Cost> {
  /// Creates the codec.
  const CostCodec();

  @override
  Cost decode(Object? value) => Cost.fromJson(decodeAcpObject(value));

  @override
  Object encode(Cost value) => value.toJson();
}

/// Shared codec for [Cost].
const CostCodec costCodec = CostCodec();

/// Request from the agent to elicit structured user input.
///
/// The agent sends this to the client to request information from the user,
/// either via a form or by directing them to a URL.
/// Elicitations are tied to a session (optionally a tool call) or a request.
sealed class CreateElicitationRequest implements AcpJsonEncodable {
  const CreateElicitationRequest();

  /// Decodes the tagged union.
  factory CreateElicitationRequest.fromJson(Object? json) =>
      createElicitationRequestCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// Form-based elicitation where the client renders a form from the provided schema.
final class CreateElicitationRequestForm extends CreateElicitationRequest {
  /// Creates this known tagged-union variant.
  CreateElicitationRequestForm(this.value, {required this.message, this.meta});

  /// The typed variant payload.
  final ElicitationFormMode value;

  /// A human-readable message describing what input is needed.
  final String message;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'form';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(elicitationFormModeCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['message'] = message;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['mode'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// URL-based elicitation where the client directs the user to a URL.
final class CreateElicitationRequestUrl extends CreateElicitationRequest {
  /// Creates this known tagged-union variant.
  CreateElicitationRequestUrl(this.value, {required this.message, this.meta});

  /// The typed variant payload.
  final ElicitationUrlMode value;

  /// A human-readable message describing what input is needed.
  final String message;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'url';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(elicitationUrlModeCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['message'] = message;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['mode'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [CreateElicitationRequest] variant.
final class CreateElicitationRequestCustom extends CreateElicitationRequest {
  /// Creates a raw-preserving custom variant.
  CreateElicitationRequestCustom({
    required this.discriminator,
    required AcpJsonObject payload,
  }) : payload = payload.without('__proto__');

  @override
  final String discriminator;

  /// Opaque extension fields.
  final AcpJsonObject payload;

  @override
  AcpJsonObject toAcpJson() =>
      payload.withValue('mode', AcpJsonString(discriminator));
}

/// Codec for [CreateElicitationRequest].
final class CreateElicitationRequestCodec
    implements AcpCodec<CreateElicitationRequest> {
  /// Creates the codec.
  const CreateElicitationRequestCodec();

  @override
  CreateElicitationRequest decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['mode']);
    switch (tag) {
      case 'form':
        final decoder = AcpResilientDecoder(payload);
        return CreateElicitationRequestForm(
          elicitationFormModeCodec.decode(payload),
          message: decoder.required(
            'message',
            (value) => decodeAcpString(value),
          ),
          meta: decoder.meta(),
        );
      case 'url':
        final decoder = AcpResilientDecoder(payload);
        return CreateElicitationRequestUrl(
          elicitationUrlModeCodec.decode(payload),
          message: decoder.required(
            'message',
            (value) => decodeAcpString(value),
          ),
          meta: decoder.meta(),
        );
      default:
        final decoder = AcpResilientDecoder(payload);
        decoder.required('message', (value) => decodeAcpString(value));
        return CreateElicitationRequestCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(CreateElicitationRequest value) => value.toJson();
}

/// Shared codec for [CreateElicitationRequest].
const CreateElicitationRequestCodec createElicitationRequestCodec =
    CreateElicitationRequestCodec();

/// Response from the client to an elicitation request.
sealed class CreateElicitationResponse implements AcpJsonEncodable {
  const CreateElicitationResponse();

  /// Decodes the tagged union.
  factory CreateElicitationResponse.fromJson(Object? json) =>
      createElicitationResponseCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// The user accepted and provided content.
final class CreateElicitationResponseAccept extends CreateElicitationResponse {
  /// Creates this known tagged-union variant.
  CreateElicitationResponseAccept(this.value, {this.meta});

  /// The typed variant payload.
  final ElicitationAcceptAction value;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'accept';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(elicitationAcceptActionCodec.encode(value));
    final result = <String, Object?>{...payload};
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['action'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// The user declined the elicitation.
final class CreateElicitationResponseDecline extends CreateElicitationResponse {
  /// Creates this known tagged-union variant.
  /// Creates a CreateElicitationResponseDecline value.
  CreateElicitationResponseDecline({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'decline';

  @override
  AcpJsonObject toAcpJson() {
    final result = <String, Object?>{};
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['action'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// The elicitation was cancelled.
final class CreateElicitationResponseCancel extends CreateElicitationResponse {
  /// Creates this known tagged-union variant.
  /// Creates a CreateElicitationResponseCancel value.
  CreateElicitationResponseCancel({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'cancel';

  @override
  AcpJsonObject toAcpJson() {
    final result = <String, Object?>{};
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['action'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [CreateElicitationResponse] variant.
final class CreateElicitationResponseCustom extends CreateElicitationResponse {
  /// Creates a raw-preserving custom variant.
  CreateElicitationResponseCustom({
    required this.discriminator,
    required AcpJsonObject payload,
  }) : payload = payload.without('__proto__');

  @override
  final String discriminator;

  /// Opaque extension fields.
  final AcpJsonObject payload;

  @override
  AcpJsonObject toAcpJson() =>
      payload.withValue('action', AcpJsonString(discriminator));
}

/// Codec for [CreateElicitationResponse].
final class CreateElicitationResponseCodec
    implements AcpCodec<CreateElicitationResponse> {
  /// Creates the codec.
  const CreateElicitationResponseCodec();

  @override
  CreateElicitationResponse decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['action']);
    switch (tag) {
      case 'accept':
        final decoder = AcpResilientDecoder(payload);
        return CreateElicitationResponseAccept(
          elicitationAcceptActionCodec.decode(payload),
          meta: decoder.meta(),
        );
      case 'decline':
        final decoder = AcpResilientDecoder(payload);
        return CreateElicitationResponseDecline(meta: decoder.meta());
      case 'cancel':
        final decoder = AcpResilientDecoder(payload);
        return CreateElicitationResponseCancel(meta: decoder.meta());
      default:
        return CreateElicitationResponseCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(CreateElicitationResponse value) => value.toJson();
}

/// Shared codec for [CreateElicitationResponse].
const CreateElicitationResponseCodec createElicitationResponseCodec =
    CreateElicitationResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request to create a new terminal and execute a command.
final class CreateTerminalRequest implements AcpJsonEncodable {
  /// Creates a CreateTerminalRequest value.
  CreateTerminalRequest({
    required this.sessionId,
    required this.command,
    List<String>? args,
    List<EnvVariable>? env,
    this.cwd,
    this.outputByteLimit,
    this.meta,
  }) : args = args == null ? null : List<String>.unmodifiable(args),
       env = env == null ? null : List<EnvVariable>.unmodifiable(env);

  /// The session ID for this request.
  final SessionId sessionId;

  /// The command to execute.
  final String command;

  /// Array of command arguments.
  final List<String>? args;

  /// Environment variables for the command.
  final List<EnvVariable>? env;

  /// Working directory for the command. Must be an absolute path.
  final String? cwd;

  /// Maximum number of output bytes to retain.
  ///
  /// When the limit is exceeded, the Client truncates from the beginning of the output
  /// to stay within the limit.
  ///
  /// The Client MUST ensure truncation happens at a character boundary to maintain valid
  /// string output, even if this means the retained output is slightly less than the
  /// specified limit.
  final AcpUint64? outputByteLimit;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<CreateTerminalRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = CreateTerminalRequest(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      command: decoder.required('command', (value) => decodeAcpString(value)),
      args: decoder.listSkippingInvalid(
        'args',
        (value) => decodeAcpString(value),
        isRequired: false,
      ),
      env: decoder.listSkippingInvalid(
        'env',
        (value) => envVariableCodec.decode(value),
        isRequired: false,
      ),
      cwd: decoder
          .optionalOnError('cwd', (value) => decodeAcpString(value))
          .valueOrNull,
      outputByteLimit: decoder
          .optionalOnError('outputByteLimit', (value) => decodeAcpUint64(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory CreateTerminalRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['command'] = command;
    if (args != null) {
      result['args'] = <Object?>[for (final item in args!) item];
    }
    if (env != null) {
      result['env'] = <Object?>[
        for (final item in env!) envVariableCodec.encode(item),
      ];
    }
    if (cwd != null) {
      result['cwd'] = cwd!;
    }
    if (outputByteLimit != null) {
      result['outputByteLimit'] = encodeAcpUint64(outputByteLimit!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CreateTerminalRequest].
final class CreateTerminalRequestCodec
    implements AcpCodec<CreateTerminalRequest> {
  /// Creates the codec.
  const CreateTerminalRequestCodec();

  @override
  CreateTerminalRequest decode(Object? value) =>
      CreateTerminalRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(CreateTerminalRequest value) => value.toJson();
}

/// Shared codec for [CreateTerminalRequest].
const CreateTerminalRequestCodec createTerminalRequestCodec =
    CreateTerminalRequestCodec();

TerminalId _decodeCreateTerminalResponseTerminalId(Object? value) =>
    terminalIdCodec.decode(value);
Object? _encodeCreateTerminalResponseTerminalId(TerminalId value) =>
    terminalIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response containing the ID of the created terminal.
final class CreateTerminalResponse implements AcpJsonEncodable {
  /// Creates a CreateTerminalResponse value.
  CreateTerminalResponse({required this.terminalId, this.meta});

  /// The unique identifier for the created terminal.
  @JsonKey(
    name: 'terminalId',
    fromJson: _decodeCreateTerminalResponseTerminalId,
    toJson: _encodeCreateTerminalResponseTerminalId,
    includeIfNull: false,
    required: true,
  )
  final TerminalId terminalId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CreateTerminalResponse.fromJson(Map<String, Object?> json) =>
      _$CreateTerminalResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CreateTerminalResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CreateTerminalResponse].
final class CreateTerminalResponseCodec
    implements AcpCodec<CreateTerminalResponse> {
  /// Creates the codec.
  const CreateTerminalResponseCodec();

  @override
  CreateTerminalResponse decode(Object? value) =>
      CreateTerminalResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(CreateTerminalResponse value) => value.toJson();
}

/// Shared codec for [CreateTerminalResponse].
const CreateTerminalResponseCodec createTerminalResponseCodec =
    CreateTerminalResponseCodec();

SessionModeId _decodeCurrentModeUpdateCurrentModeId(Object? value) =>
    sessionModeIdCodec.decode(value);
Object? _encodeCurrentModeUpdateCurrentModeId(SessionModeId value) =>
    sessionModeIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// The current mode of the session has changed
///
/// See protocol docs: [Session Modes](https://agentclientprotocol.com/protocol/session-modes)
final class CurrentModeUpdate implements AcpJsonEncodable {
  /// Creates a CurrentModeUpdate value.
  CurrentModeUpdate({required this.currentModeId, this.meta});

  /// The ID of the current mode
  @JsonKey(
    name: 'currentModeId',
    fromJson: _decodeCurrentModeUpdateCurrentModeId,
    toJson: _encodeCurrentModeUpdateCurrentModeId,
    includeIfNull: false,
    required: true,
  )
  final SessionModeId currentModeId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CurrentModeUpdate.fromJson(Map<String, Object?> json) =>
      _$CurrentModeUpdateFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CurrentModeUpdateToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CurrentModeUpdate].
final class CurrentModeUpdateCodec implements AcpCodec<CurrentModeUpdate> {
  /// Creates the codec.
  const CurrentModeUpdateCodec();

  @override
  CurrentModeUpdate decode(Object? value) =>
      CurrentModeUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(CurrentModeUpdate value) => value.toJson();
}

/// Shared codec for [CurrentModeUpdate].
const CurrentModeUpdateCodec currentModeUpdateCodec = CurrentModeUpdateCodec();

SessionId _decodeDeleteSessionRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeDeleteSessionRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for deleting an existing session from `session/list`.
///
/// Only available if the Agent supports the `sessionCapabilities.delete` capability.
final class DeleteSessionRequest implements AcpJsonEncodable {
  /// Creates a DeleteSessionRequest value.
  DeleteSessionRequest({required this.sessionId, this.meta});

  /// The ID of the session to delete.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeDeleteSessionRequestSessionId,
    toJson: _encodeDeleteSessionRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DeleteSessionRequest.fromJson(Map<String, Object?> json) =>
      _$DeleteSessionRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DeleteSessionRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DeleteSessionRequest].
final class DeleteSessionRequestCodec
    implements AcpCodec<DeleteSessionRequest> {
  /// Creates the codec.
  const DeleteSessionRequestCodec();

  @override
  DeleteSessionRequest decode(Object? value) =>
      DeleteSessionRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(DeleteSessionRequest value) => value.toJson();
}

/// Shared codec for [DeleteSessionRequest].
const DeleteSessionRequestCodec deleteSessionRequestCodec =
    DeleteSessionRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response from deleting a session.
final class DeleteSessionResponse implements AcpJsonEncodable {
  /// Creates a DeleteSessionResponse value.
  DeleteSessionResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DeleteSessionResponse.fromJson(Map<String, Object?> json) =>
      _$DeleteSessionResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DeleteSessionResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DeleteSessionResponse].
final class DeleteSessionResponseCodec
    implements AcpCodec<DeleteSessionResponse> {
  /// Creates the codec.
  const DeleteSessionResponseCodec();

  @override
  DeleteSessionResponse decode(Object? value) =>
      DeleteSessionResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(DeleteSessionResponse value) => value.toJson();
}

/// Shared codec for [DeleteSessionResponse].
const DeleteSessionResponseCodec deleteSessionResponseCodec =
    DeleteSessionResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Notification sent when a file is edited.
final class DidChangeDocumentNotification implements AcpJsonEncodable {
  /// Creates a DidChangeDocumentNotification value.
  DidChangeDocumentNotification({
    required this.sessionId,
    required this.uri,
    required this.version,
    required List<TextDocumentContentChangeEvent> contentChanges,
    this.meta,
  }) : contentChanges = List<TextDocumentContentChangeEvent>.unmodifiable(
         contentChanges,
       );

  /// The session ID for this notification.
  final SessionId sessionId;

  /// The URI of the changed document.
  final String uri;

  /// The new version number of the document.
  final AcpInt64 version;

  /// The content changes.
  final List<TextDocumentContentChangeEvent> contentChanges;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<DidChangeDocumentNotification> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = DidChangeDocumentNotification(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      uri: decoder.required('uri', (value) => decodeAcpString(value)),
      version: decoder.required('version', (value) => decodeAcpInt64(value)),
      contentChanges: decoder.listSkippingInvalid(
        'contentChanges',
        (value) => textDocumentContentChangeEventCodec.decode(value),
        isRequired: true,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory DidChangeDocumentNotification.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['uri'] = uri;
    result['version'] = encodeAcpInt64(version);
    result['contentChanges'] = <Object?>[
      for (final item in contentChanges)
        textDocumentContentChangeEventCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DidChangeDocumentNotification].
final class DidChangeDocumentNotificationCodec
    implements AcpCodec<DidChangeDocumentNotification> {
  /// Creates the codec.
  const DidChangeDocumentNotificationCodec();

  @override
  DidChangeDocumentNotification decode(Object? value) =>
      DidChangeDocumentNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(DidChangeDocumentNotification value) => value.toJson();
}

/// Shared codec for [DidChangeDocumentNotification].
const DidChangeDocumentNotificationCodec didChangeDocumentNotificationCodec =
    DidChangeDocumentNotificationCodec();

SessionId _decodeDidCloseDocumentNotificationSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeDidCloseDocumentNotificationSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

String _decodeDidCloseDocumentNotificationUri(Object? value) =>
    decodeAcpString(value);
Object? _encodeDidCloseDocumentNotificationUri(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification sent when a file is closed.
final class DidCloseDocumentNotification implements AcpJsonEncodable {
  /// Creates a DidCloseDocumentNotification value.
  DidCloseDocumentNotification({
    required this.sessionId,
    required this.uri,
    this.meta,
  });

  /// The session ID for this notification.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeDidCloseDocumentNotificationSessionId,
    toJson: _encodeDidCloseDocumentNotificationSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The URI of the closed document.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeDidCloseDocumentNotificationUri,
    toJson: _encodeDidCloseDocumentNotificationUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DidCloseDocumentNotification.fromJson(Map<String, Object?> json) =>
      _$DidCloseDocumentNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DidCloseDocumentNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DidCloseDocumentNotification].
final class DidCloseDocumentNotificationCodec
    implements AcpCodec<DidCloseDocumentNotification> {
  /// Creates the codec.
  const DidCloseDocumentNotificationCodec();

  @override
  DidCloseDocumentNotification decode(Object? value) =>
      DidCloseDocumentNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(DidCloseDocumentNotification value) => value.toJson();
}

/// Shared codec for [DidCloseDocumentNotification].
const DidCloseDocumentNotificationCodec didCloseDocumentNotificationCodec =
    DidCloseDocumentNotificationCodec();

SessionId _decodeDidFocusDocumentNotificationSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeDidFocusDocumentNotificationSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

String _decodeDidFocusDocumentNotificationUri(Object? value) =>
    decodeAcpString(value);
Object? _encodeDidFocusDocumentNotificationUri(String value) => value;

AcpInt64 _decodeDidFocusDocumentNotificationVersion(Object? value) =>
    decodeAcpInt64(value);
Object? _encodeDidFocusDocumentNotificationVersion(AcpInt64 value) =>
    encodeAcpInt64(value);

Position _decodeDidFocusDocumentNotificationPosition(Object? value) =>
    positionCodec.decode(value);
Object? _encodeDidFocusDocumentNotificationPosition(Position value) =>
    positionCodec.encode(value);

Range _decodeDidFocusDocumentNotificationVisibleRange(Object? value) =>
    rangeCodec.decode(value);
Object? _encodeDidFocusDocumentNotificationVisibleRange(Range value) =>
    rangeCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification sent when a file becomes the active editor tab.
final class DidFocusDocumentNotification implements AcpJsonEncodable {
  /// Creates a DidFocusDocumentNotification value.
  DidFocusDocumentNotification({
    required this.sessionId,
    required this.uri,
    required this.version,
    required this.position,
    required this.visibleRange,
    this.meta,
  });

  /// The session ID for this notification.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeDidFocusDocumentNotificationSessionId,
    toJson: _encodeDidFocusDocumentNotificationSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The URI of the focused document.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeDidFocusDocumentNotificationUri,
    toJson: _encodeDidFocusDocumentNotificationUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The version number of the document.
  @JsonKey(
    name: 'version',
    fromJson: _decodeDidFocusDocumentNotificationVersion,
    toJson: _encodeDidFocusDocumentNotificationVersion,
    includeIfNull: false,
    required: true,
  )
  final AcpInt64 version;

  /// The current cursor position.
  @JsonKey(
    name: 'position',
    fromJson: _decodeDidFocusDocumentNotificationPosition,
    toJson: _encodeDidFocusDocumentNotificationPosition,
    includeIfNull: false,
    required: true,
  )
  final Position position;

  /// The portion of the file currently visible in the editor viewport.
  @JsonKey(
    name: 'visibleRange',
    fromJson: _decodeDidFocusDocumentNotificationVisibleRange,
    toJson: _encodeDidFocusDocumentNotificationVisibleRange,
    includeIfNull: false,
    required: true,
  )
  final Range visibleRange;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DidFocusDocumentNotification.fromJson(Map<String, Object?> json) =>
      _$DidFocusDocumentNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DidFocusDocumentNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DidFocusDocumentNotification].
final class DidFocusDocumentNotificationCodec
    implements AcpCodec<DidFocusDocumentNotification> {
  /// Creates the codec.
  const DidFocusDocumentNotificationCodec();

  @override
  DidFocusDocumentNotification decode(Object? value) =>
      DidFocusDocumentNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(DidFocusDocumentNotification value) => value.toJson();
}

/// Shared codec for [DidFocusDocumentNotification].
const DidFocusDocumentNotificationCodec didFocusDocumentNotificationCodec =
    DidFocusDocumentNotificationCodec();

SessionId _decodeDidOpenDocumentNotificationSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeDidOpenDocumentNotificationSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

String _decodeDidOpenDocumentNotificationUri(Object? value) =>
    decodeAcpString(value);
Object? _encodeDidOpenDocumentNotificationUri(String value) => value;

String _decodeDidOpenDocumentNotificationLanguageId(Object? value) =>
    decodeAcpString(value);
Object? _encodeDidOpenDocumentNotificationLanguageId(String value) => value;

AcpInt64 _decodeDidOpenDocumentNotificationVersion(Object? value) =>
    decodeAcpInt64(value);
Object? _encodeDidOpenDocumentNotificationVersion(AcpInt64 value) =>
    encodeAcpInt64(value);

String _decodeDidOpenDocumentNotificationText(Object? value) =>
    decodeAcpString(value);
Object? _encodeDidOpenDocumentNotificationText(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification sent when a file is opened in the editor.
final class DidOpenDocumentNotification implements AcpJsonEncodable {
  /// Creates a DidOpenDocumentNotification value.
  DidOpenDocumentNotification({
    required this.sessionId,
    required this.uri,
    required this.languageId,
    required this.version,
    required this.text,
    this.meta,
  });

  /// The session ID for this notification.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeDidOpenDocumentNotificationSessionId,
    toJson: _encodeDidOpenDocumentNotificationSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The URI of the opened document.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeDidOpenDocumentNotificationUri,
    toJson: _encodeDidOpenDocumentNotificationUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The language identifier of the document (e.g., "rust", "python").
  @JsonKey(
    name: 'languageId',
    fromJson: _decodeDidOpenDocumentNotificationLanguageId,
    toJson: _encodeDidOpenDocumentNotificationLanguageId,
    includeIfNull: false,
    required: true,
  )
  final String languageId;

  /// The version number of the document.
  @JsonKey(
    name: 'version',
    fromJson: _decodeDidOpenDocumentNotificationVersion,
    toJson: _encodeDidOpenDocumentNotificationVersion,
    includeIfNull: false,
    required: true,
  )
  final AcpInt64 version;

  /// The full text content of the document.
  @JsonKey(
    name: 'text',
    fromJson: _decodeDidOpenDocumentNotificationText,
    toJson: _encodeDidOpenDocumentNotificationText,
    includeIfNull: false,
    required: true,
  )
  final String text;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DidOpenDocumentNotification.fromJson(Map<String, Object?> json) =>
      _$DidOpenDocumentNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DidOpenDocumentNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DidOpenDocumentNotification].
final class DidOpenDocumentNotificationCodec
    implements AcpCodec<DidOpenDocumentNotification> {
  /// Creates the codec.
  const DidOpenDocumentNotificationCodec();

  @override
  DidOpenDocumentNotification decode(Object? value) =>
      DidOpenDocumentNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(DidOpenDocumentNotification value) => value.toJson();
}

/// Shared codec for [DidOpenDocumentNotification].
const DidOpenDocumentNotificationCodec didOpenDocumentNotificationCodec =
    DidOpenDocumentNotificationCodec();

SessionId _decodeDidSaveDocumentNotificationSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeDidSaveDocumentNotificationSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

String _decodeDidSaveDocumentNotificationUri(Object? value) =>
    decodeAcpString(value);
Object? _encodeDidSaveDocumentNotificationUri(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification sent when a file is saved.
final class DidSaveDocumentNotification implements AcpJsonEncodable {
  /// Creates a DidSaveDocumentNotification value.
  DidSaveDocumentNotification({
    required this.sessionId,
    required this.uri,
    this.meta,
  });

  /// The session ID for this notification.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeDidSaveDocumentNotificationSessionId,
    toJson: _encodeDidSaveDocumentNotificationSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The URI of the saved document.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeDidSaveDocumentNotificationUri,
    toJson: _encodeDidSaveDocumentNotificationUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DidSaveDocumentNotification.fromJson(Map<String, Object?> json) =>
      _$DidSaveDocumentNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DidSaveDocumentNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DidSaveDocumentNotification].
final class DidSaveDocumentNotificationCodec
    implements AcpCodec<DidSaveDocumentNotification> {
  /// Creates the codec.
  const DidSaveDocumentNotificationCodec();

  @override
  DidSaveDocumentNotification decode(Object? value) =>
      DidSaveDocumentNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(DidSaveDocumentNotification value) => value.toJson();
}

/// Shared codec for [DidSaveDocumentNotification].
const DidSaveDocumentNotificationCodec didSaveDocumentNotificationCodec =
    DidSaveDocumentNotificationCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A diff representing file modifications.
///
/// Shows changes to files in a format suitable for display in the client UI.
///
/// See protocol docs: [Content](https://agentclientprotocol.com/protocol/tool-calls#content)
final class Diff implements AcpJsonEncodable {
  /// Creates a Diff value.
  Diff({required this.path, required this.newText, this.oldText, this.meta});

  /// The absolute file path being modified.
  final String path;

  /// The original content (None for new files).
  final String? oldText;

  /// The new content after modification.
  final String newText;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<Diff> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = Diff(
      path: decoder.required('path', (value) => decodeAcpString(value)),
      oldText: decoder
          .optionalOnError('oldText', (value) => decodeAcpString(value))
          .valueOrNull,
      newText: decoder.required('newText', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory Diff.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['path'] = path;
    if (oldText != null) {
      result['oldText'] = oldText!;
    }
    result['newText'] = newText;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Diff].
final class DiffCodec implements AcpCodec<Diff> {
  /// Creates the codec.
  const DiffCodec();

  @override
  Diff decode(Object? value) => Diff.fromJson(decodeAcpObject(value));

  @override
  Object encode(Diff value) => value.toJson();
}

/// Shared codec for [Diff].
const DiffCodec diffCodec = DiffCodec();

ProviderId _decodeDisableProviderRequestProviderId(Object? value) =>
    providerIdCodec.decode(value);
Object? _encodeDisableProviderRequestProviderId(ProviderId value) =>
    providerIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `providers/disable`.
final class DisableProviderRequest implements AcpJsonEncodable {
  /// Creates a DisableProviderRequest value.
  DisableProviderRequest({required this.providerId, this.meta});

  /// Provider ID to disable.
  @JsonKey(
    name: 'providerId',
    fromJson: _decodeDisableProviderRequestProviderId,
    toJson: _encodeDisableProviderRequestProviderId,
    includeIfNull: false,
    required: true,
  )
  final ProviderId providerId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DisableProviderRequest.fromJson(Map<String, Object?> json) =>
      _$DisableProviderRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DisableProviderRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DisableProviderRequest].
final class DisableProviderRequestCodec
    implements AcpCodec<DisableProviderRequest> {
  /// Creates the codec.
  const DisableProviderRequestCodec();

  @override
  DisableProviderRequest decode(Object? value) =>
      DisableProviderRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(DisableProviderRequest value) => value.toJson();
}

/// Shared codec for [DisableProviderRequest].
const DisableProviderRequestCodec disableProviderRequestCodec =
    DisableProviderRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Response to `providers/disable`.
final class DisableProviderResponse implements AcpJsonEncodable {
  /// Creates a DisableProviderResponse value.
  DisableProviderResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DisableProviderResponse.fromJson(Map<String, Object?> json) =>
      _$DisableProviderResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DisableProviderResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DisableProviderResponse].
final class DisableProviderResponseCodec
    implements AcpCodec<DisableProviderResponse> {
  /// Creates the codec.
  const DisableProviderResponseCodec();

  @override
  DisableProviderResponse decode(Object? value) =>
      DisableProviderResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(DisableProviderResponse value) => value.toJson();
}

/// Shared codec for [DisableProviderResponse].
const DisableProviderResponseCodec disableProviderResponseCodec =
    DisableProviderResponseCodec();

McpConnectionId _decodeDisconnectMcpRequestConnectionId(Object? value) =>
    mcpConnectionIdCodec.decode(value);
Object? _encodeDisconnectMcpRequestConnectionId(McpConnectionId value) =>
    mcpConnectionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `mcp/disconnect`.
final class DisconnectMcpRequest implements AcpJsonEncodable {
  /// Creates a DisconnectMcpRequest value.
  DisconnectMcpRequest({required this.connectionId, this.meta});

  /// The MCP-over-ACP connection to close.
  @JsonKey(
    name: 'connectionId',
    fromJson: _decodeDisconnectMcpRequestConnectionId,
    toJson: _encodeDisconnectMcpRequestConnectionId,
    includeIfNull: false,
    required: true,
  )
  final McpConnectionId connectionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DisconnectMcpRequest.fromJson(Map<String, Object?> json) =>
      _$DisconnectMcpRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DisconnectMcpRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DisconnectMcpRequest].
final class DisconnectMcpRequestCodec
    implements AcpCodec<DisconnectMcpRequest> {
  /// Creates the codec.
  const DisconnectMcpRequestCodec();

  @override
  DisconnectMcpRequest decode(Object? value) =>
      DisconnectMcpRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(DisconnectMcpRequest value) => value.toJson();
}

/// Shared codec for [DisconnectMcpRequest].
const DisconnectMcpRequestCodec disconnectMcpRequestCodec =
    DisconnectMcpRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Response to `mcp/disconnect`.
final class DisconnectMcpResponse implements AcpJsonEncodable {
  /// Creates a DisconnectMcpResponse value.
  DisconnectMcpResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory DisconnectMcpResponse.fromJson(Map<String, Object?> json) =>
      _$DisconnectMcpResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DisconnectMcpResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DisconnectMcpResponse].
final class DisconnectMcpResponseCodec
    implements AcpCodec<DisconnectMcpResponse> {
  /// Creates the codec.
  const DisconnectMcpResponseCodec();

  @override
  DisconnectMcpResponse decode(Object? value) =>
      DisconnectMcpResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(DisconnectMcpResponse value) => value.toJson();
}

/// Shared codec for [DisconnectMcpResponse].
const DisconnectMcpResponseCodec disconnectMcpResponseCodec =
    DisconnectMcpResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// The user accepted the elicitation and provided content.
final class ElicitationAcceptAction implements AcpJsonEncodable {
  /// Creates a ElicitationAcceptAction value.
  ElicitationAcceptAction({Map<String, ElicitationContentValue>? content})
    : content = content == null
          ? null
          : Map<String, ElicitationContentValue>.unmodifiable(content);

  /// The user-provided content, if any, as an object matching the requested schema.
  final Map<String, ElicitationContentValue>? content;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ElicitationAcceptAction> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ElicitationAcceptAction(
      content: decoder.optional(
        'content',
        (value) => Map<String, ElicitationContentValue>.unmodifiable(
          <String, ElicitationContentValue>{
            for (final entry in decodeAcpObject(value).entries)
              entry.key: elicitationContentValueCodec.decode(entry.value),
          },
        ),
      ),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ElicitationAcceptAction.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (content != null) {
      result['content'] = <String, Object?>{
        for (final entry in content!.entries)
          entry.key: elicitationContentValueCodec.encode(entry.value),
      };
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ElicitationAcceptAction].
final class ElicitationAcceptActionCodec
    implements AcpCodec<ElicitationAcceptAction> {
  /// Creates the codec.
  const ElicitationAcceptActionCodec();

  @override
  ElicitationAcceptAction decode(Object? value) =>
      ElicitationAcceptAction.fromJson(decodeAcpObject(value));

  @override
  Object encode(ElicitationAcceptAction value) => value.toJson();
}

/// Shared codec for [ElicitationAcceptAction].
const ElicitationAcceptActionCodec elicitationAcceptActionCodec =
    ElicitationAcceptActionCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Elicitation capabilities supported by the client.
final class ElicitationCapabilities implements AcpJsonEncodable {
  /// Creates a ElicitationCapabilities value.
  ElicitationCapabilities({this.form, this.url, this.meta});

  /// Whether the client supports form-based elicitation.
  ///
  /// Optional. Omitted and `null` are equivalent and mean form support is not advertised.
  /// Supplying `{}` explicitly advertises form support.
  final ElicitationFormCapabilities? form;

  /// Whether the client supports URL-based elicitation.
  ///
  /// Optional. Omitted or `null` both mean the client does not advertise support.
  /// Supplying `{}` means the client supports URL-based elicitation.
  final ElicitationUrlCapabilities? url;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ElicitationCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ElicitationCapabilities(
      form: decoder
          .optionalOnError(
            'form',
            (value) => elicitationFormCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      url: decoder
          .optionalOnError(
            'url',
            (value) => elicitationUrlCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ElicitationCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (form != null) {
      result['form'] = elicitationFormCapabilitiesCodec.encode(form!);
    }
    if (url != null) {
      result['url'] = elicitationUrlCapabilitiesCodec.encode(url!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ElicitationCapabilities].
final class ElicitationCapabilitiesCodec
    implements AcpCodec<ElicitationCapabilities> {
  /// Creates the codec.
  const ElicitationCapabilitiesCodec();

  @override
  ElicitationCapabilities decode(Object? value) =>
      ElicitationCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(ElicitationCapabilities value) => value.toJson();
}

/// Shared codec for [ElicitationCapabilities].
const ElicitationCapabilitiesCodec elicitationCapabilitiesCodec =
    ElicitationCapabilitiesCodec();

/// Allowed wire representations for `ElicitationContentValue`.
sealed class ElicitationContentValue implements AcpJsonEncodable {
  const ElicitationContentValue();

  /// Decodes one concrete union member.
  factory ElicitationContentValue.fromJson(Object? json) =>
      elicitationContentValueCodec.decode(json);

  /// Encodes the concrete union member.
  Object? toJson();

  @override
  AcpJsonValue toAcpJson() => AcpJsonValue.fromObject(toJson());
}

/// String value accepted in elicitation response content.
final class ElicitationContentValueString extends ElicitationContentValue {
  /// Creates this concrete union member.
  const ElicitationContentValueString(this.value);

  /// The typed union value.
  final String value;

  @override
  Object? toJson() => value;
}

/// Integer value accepted in elicitation response content.
final class ElicitationContentValueInteger extends ElicitationContentValue {
  /// Creates this concrete union member.
  const ElicitationContentValueInteger(this.value);

  /// The typed union value.
  final AcpInt64 value;

  @override
  Object? toJson() => encodeAcpInt64(value);
}

/// Number value accepted in elicitation response content.
final class ElicitationContentValueNumber extends ElicitationContentValue {
  /// Creates this concrete union member.
  const ElicitationContentValueNumber(this.value);

  /// The typed union value.
  final num value;

  @override
  Object? toJson() => value;
}

/// Boolean value accepted in elicitation response content.
final class ElicitationContentValueBoolean extends ElicitationContentValue {
  /// Creates this concrete union member.
  const ElicitationContentValueBoolean(this.value);

  /// The typed union value.
  final bool value;

  @override
  Object? toJson() => value;
}

/// String array value accepted in elicitation response content.
final class ElicitationContentValueStringArray extends ElicitationContentValue {
  /// Creates this concrete union member.
  const ElicitationContentValueStringArray(this.value);

  /// The typed union value.
  final List<String> value;

  @override
  Object? toJson() => <Object?>[for (final item in value) item];
}

/// Codec for [ElicitationContentValue].
final class ElicitationContentValueCodec
    implements AcpCodec<ElicitationContentValue> {
  /// Creates the codec.
  const ElicitationContentValueCodec();

  @override
  ElicitationContentValue decode(Object? value) {
    if (value is String) {
      return ElicitationContentValueString(decodeAcpString(value));
    }
    try {
      return ElicitationContentValueInteger(decodeAcpInt64(value));
    } on Object {
      // Try the next structurally distinct member.
    }
    if (value is num) {
      return ElicitationContentValueNumber(decodeAcpNumber(value));
    }
    if (value is bool) {
      return ElicitationContentValueBoolean(decodeAcpBoolean(value));
    }
    if (value is List<Object?>) {
      try {
        return ElicitationContentValueStringArray(
          List<String>.unmodifiable(value.map((item) => decodeAcpString(item))),
        );
      } on Object {
        // Try the next array-shaped member.
      }
    }
    throw const FormatException('Value does not match ElicitationContentValue');
  }

  @override
  Object? encode(ElicitationContentValue value) => value.toJson();
}

/// Shared codec for [ElicitationContentValue].
const ElicitationContentValueCodec elicitationContentValueCodec =
    ElicitationContentValueCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Form-based elicitation capabilities.
///
/// Supplying `{}` means the client supports form-based elicitation.
final class ElicitationFormCapabilities implements AcpJsonEncodable {
  /// Creates a ElicitationFormCapabilities value.
  ElicitationFormCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ElicitationFormCapabilities.fromJson(Map<String, Object?> json) =>
      _$ElicitationFormCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ElicitationFormCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ElicitationFormCapabilities].
final class ElicitationFormCapabilitiesCodec
    implements AcpCodec<ElicitationFormCapabilities> {
  /// Creates the codec.
  const ElicitationFormCapabilitiesCodec();

  @override
  ElicitationFormCapabilities decode(Object? value) =>
      ElicitationFormCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(ElicitationFormCapabilities value) => value.toJson();
}

/// Shared codec for [ElicitationFormCapabilities].
const ElicitationFormCapabilitiesCodec elicitationFormCapabilitiesCodec =
    ElicitationFormCapabilitiesCodec();

/// Form-based elicitation mode where the client renders a form from the provided schema.
final class ElicitationFormMode implements AcpJsonEncodable {
  /// Creates a ElicitationFormMode value.
  ElicitationFormMode({required this.requestedSchema, required this.variant});

  /// A JSON Schema describing the form fields to present to the user.
  final ElicitationSchema requestedSchema;

  /// The concrete schema composition branch.
  final ElicitationFormModeVariant variant;

  /// Decodes this composed model with resilient fields.
  static AcpDecoded<ElicitationFormMode> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ElicitationFormMode(
      requestedSchema: decoder.required(
        'requestedSchema',
        (value) => elicitationSchemaCodec.decode(value),
      ),
      variant: _decodeElicitationFormModeVariant(json),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ElicitationFormMode.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{...variant.toJson()};
    result['requestedSchema'] = elicitationSchemaCodec.encode(requestedSchema);
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// One concrete composition branch for [ElicitationFormMode].
sealed class ElicitationFormModeVariant {
  const ElicitationFormModeVariant();

  /// Encodes the branch fields into their flattened object.
  Map<String, Object?> toJson();
}

/// Tied to a session, optionally to a specific tool call within that session.
final class ElicitationFormModeSession extends ElicitationFormModeVariant {
  /// Creates this typed composition branch.
  const ElicitationFormModeSession(this.value);

  /// The typed branch payload.
  final ElicitationSessionScope value;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    ...decodeAcpObject(elicitationSessionScopeCodec.encode(value)),
  };
}

/// Tied to a specific JSON-RPC request outside of a session
/// (e.g., during auth/configuration phases before any session is started).
final class ElicitationFormModeRequest extends ElicitationFormModeVariant {
  /// Creates this typed composition branch.
  const ElicitationFormModeRequest(this.value);

  /// The typed branch payload.
  final ElicitationRequestScope value;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    ...decodeAcpObject(elicitationRequestScopeCodec.encode(value)),
  };
}

ElicitationFormModeVariant _decodeElicitationFormModeVariant(Object? value) {
  final payload = decodeAcpObject(value);
  try {
    return ElicitationFormModeSession(
      elicitationSessionScopeCodec.decode(payload),
    );
  } on Object {
    // Try the next structurally distinct branch.
  }
  try {
    return ElicitationFormModeRequest(
      elicitationRequestScopeCodec.decode(payload),
    );
  } on Object {
    // Try the next structurally distinct branch.
  }
  throw const FormatException('Value does not match ElicitationFormMode');
}

/// Codec for [ElicitationFormMode].
final class ElicitationFormModeCodec implements AcpCodec<ElicitationFormMode> {
  /// Creates the codec.
  const ElicitationFormModeCodec();

  @override
  ElicitationFormMode decode(Object? value) =>
      ElicitationFormMode.fromJson(decodeAcpObject(value));

  @override
  Object encode(ElicitationFormMode value) => value.toJson();
}

/// Shared codec for [ElicitationFormMode].
const ElicitationFormModeCodec elicitationFormModeCodec =
    ElicitationFormModeCodec();

/// Unique identifier for an elicitation.
final class ElicitationId implements AcpJsonEncodable {
  /// Validates and creates a ElicitationId value.
  factory ElicitationId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return ElicitationId._(value);
  }

  const ElicitationId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory ElicitationId.fromJson(Object? json) =>
      ElicitationId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is ElicitationId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [ElicitationId].
final class ElicitationIdCodec implements AcpCodec<ElicitationId> {
  /// Creates the codec.
  const ElicitationIdCodec();

  @override
  ElicitationId decode(Object? value) => ElicitationId.fromJson(value);

  @override
  String encode(ElicitationId value) => value.toJson();
}

/// Shared codec for [ElicitationId].
const ElicitationIdCodec elicitationIdCodec = ElicitationIdCodec();

/// Property schema for elicitation form fields.
///
/// Each variant corresponds to a JSON Schema `"type"` value.
/// Single-select enums use the `String` variant with `enum` or `oneOf` set.
/// Multi-select enums use the `Array` variant.
sealed class ElicitationPropertySchema implements AcpJsonEncodable {
  const ElicitationPropertySchema();

  /// Decodes the tagged union.
  factory ElicitationPropertySchema.fromJson(Object? json) =>
      elicitationPropertySchemaCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// String property (or single-select enum when `enum`/`oneOf` is set).
final class ElicitationPropertySchemaString extends ElicitationPropertySchema {
  /// Creates this known tagged-union variant.
  const ElicitationPropertySchemaString(this.value);

  /// The typed variant payload.
  final StringPropertySchema value;

  @override
  String get discriminator => 'string';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(stringPropertySchemaCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Number (floating-point) property.
final class ElicitationPropertySchemaNumber extends ElicitationPropertySchema {
  /// Creates this known tagged-union variant.
  const ElicitationPropertySchemaNumber(this.value);

  /// The typed variant payload.
  final NumberPropertySchema value;

  @override
  String get discriminator => 'number';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(numberPropertySchemaCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Integer property.
final class ElicitationPropertySchemaInteger extends ElicitationPropertySchema {
  /// Creates this known tagged-union variant.
  const ElicitationPropertySchemaInteger(this.value);

  /// The typed variant payload.
  final IntegerPropertySchema value;

  @override
  String get discriminator => 'integer';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(integerPropertySchemaCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Boolean property.
final class ElicitationPropertySchemaBoolean extends ElicitationPropertySchema {
  /// Creates this known tagged-union variant.
  const ElicitationPropertySchemaBoolean(this.value);

  /// The typed variant payload.
  final BooleanPropertySchema value;

  @override
  String get discriminator => 'boolean';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(booleanPropertySchemaCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Multi-select array property.
final class ElicitationPropertySchemaArray extends ElicitationPropertySchema {
  /// Creates this known tagged-union variant.
  const ElicitationPropertySchemaArray(this.value);

  /// The typed variant payload.
  final MultiSelectPropertySchema value;

  @override
  String get discriminator => 'array';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(
      multiSelectPropertySchemaCodec.encode(value),
    );
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [ElicitationPropertySchema] variant.
final class ElicitationPropertySchemaCustom extends ElicitationPropertySchema {
  /// Creates a raw-preserving custom variant.
  ElicitationPropertySchemaCustom({
    required this.discriminator,
    required AcpJsonObject payload,
  }) : payload = payload.without('__proto__');

  @override
  final String discriminator;

  /// Opaque extension fields.
  final AcpJsonObject payload;

  @override
  AcpJsonObject toAcpJson() =>
      payload.withValue('type', AcpJsonString(discriminator));
}

/// Codec for [ElicitationPropertySchema].
final class ElicitationPropertySchemaCodec
    implements AcpCodec<ElicitationPropertySchema> {
  /// Creates the codec.
  const ElicitationPropertySchemaCodec();

  @override
  ElicitationPropertySchema decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'string':
        return ElicitationPropertySchemaString(
          stringPropertySchemaCodec.decode(payload),
        );
      case 'number':
        return ElicitationPropertySchemaNumber(
          numberPropertySchemaCodec.decode(payload),
        );
      case 'integer':
        return ElicitationPropertySchemaInteger(
          integerPropertySchemaCodec.decode(payload),
        );
      case 'boolean':
        return ElicitationPropertySchemaBoolean(
          booleanPropertySchemaCodec.decode(payload),
        );
      case 'array':
        return ElicitationPropertySchemaArray(
          multiSelectPropertySchemaCodec.decode(payload),
        );
      default:
        return ElicitationPropertySchemaCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(ElicitationPropertySchema value) => value.toJson();
}

/// Shared codec for [ElicitationPropertySchema].
const ElicitationPropertySchemaCodec elicitationPropertySchemaCodec =
    ElicitationPropertySchemaCodec();

RequestId _decodeElicitationRequestScopeRequestId(Object? value) =>
    requestIdCodec.decode(value);
Object? _encodeElicitationRequestScopeRequestId(RequestId value) =>
    requestIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request-scoped elicitation, tied to a specific JSON-RPC request outside of a session
/// (e.g., during auth/configuration phases before any session is started).
final class ElicitationRequestScope implements AcpJsonEncodable {
  /// Creates a ElicitationRequestScope value.
  ElicitationRequestScope({required this.requestId});

  /// The request this elicitation is tied to.
  @JsonKey(
    name: 'requestId',
    fromJson: _decodeElicitationRequestScopeRequestId,
    toJson: _encodeElicitationRequestScopeRequestId,
    includeIfNull: true,
    required: true,
  )
  final RequestId requestId;

  /// Decodes a schema-validated JSON object.
  factory ElicitationRequestScope.fromJson(Map<String, Object?> json) =>
      _$ElicitationRequestScopeFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ElicitationRequestScopeToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ElicitationRequestScope].
final class ElicitationRequestScopeCodec
    implements AcpCodec<ElicitationRequestScope> {
  /// Creates the codec.
  const ElicitationRequestScopeCodec();

  @override
  ElicitationRequestScope decode(Object? value) =>
      ElicitationRequestScope.fromJson(decodeAcpObject(value));

  @override
  Object encode(ElicitationRequestScope value) => value.toJson();
}

/// Shared codec for [ElicitationRequestScope].
const ElicitationRequestScopeCodec elicitationRequestScopeCodec =
    ElicitationRequestScopeCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Type-safe elicitation schema for requesting structured user input.
///
/// This represents a JSON Schema object with primitive-typed properties,
/// as required by the elicitation specification.
final class ElicitationSchema implements AcpJsonEncodable {
  /// Creates a ElicitationSchema value.
  ElicitationSchema({
    required this.type,
    required Map<String, ElicitationPropertySchema> properties,
    this.title,
    List<String>? requiredValue,
    this.description,
    this.meta,
  }) : properties = Map<String, ElicitationPropertySchema>.unmodifiable(
         properties,
       ),
       requiredValue = requiredValue == null
           ? null
           : List<String>.unmodifiable(requiredValue);

  /// Type discriminator. Always `"object"`.
  final ElicitationSchemaType type;

  /// Optional title for the schema.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no title is provided.
  final String? title;

  /// Property definitions (must be primitive types).
  final Map<String, ElicitationPropertySchema> properties;

  /// List of required property names.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no property names are required.
  final List<String>? requiredValue;

  /// Optional description of what this schema represents.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no schema description is provided.
  final String? description;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ElicitationSchema> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ElicitationSchema(
      type: decoder.defaultOnError(
        'type',
        elicitationSchemaTypeCodec.decode('object'),
        (value) => elicitationSchemaTypeCodec.decode(value),
      ),
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      properties: decoder.contains('properties')
          ? decoder.required(
              'properties',
              (value) => Map<String, ElicitationPropertySchema>.unmodifiable(<
                String,
                ElicitationPropertySchema
              >{
                for (final entry in decodeAcpObject(value).entries)
                  entry.key: elicitationPropertySchemaCodec.decode(entry.value),
              }),
            )
          : <String, ElicitationPropertySchema>{},
      requiredValue: decoder.optional(
        'required',
        (value) => List<String>.unmodifiable(
          (value as List<Object?>).map((item) => decodeAcpString(item)),
        ),
      ),
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ElicitationSchema.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['type'] = elicitationSchemaTypeCodec.encode(type);
    if (title != null) {
      result['title'] = title!;
    }
    result['properties'] = <String, Object?>{
      for (final entry in properties.entries)
        entry.key: elicitationPropertySchemaCodec.encode(entry.value),
    };
    if (requiredValue != null) {
      result['required'] = <Object?>[for (final item in requiredValue!) item];
    }
    if (description != null) {
      result['description'] = description!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ElicitationSchema].
final class ElicitationSchemaCodec implements AcpCodec<ElicitationSchema> {
  /// Creates the codec.
  const ElicitationSchemaCodec();

  @override
  ElicitationSchema decode(Object? value) =>
      ElicitationSchema.fromJson(decodeAcpObject(value));

  @override
  Object encode(ElicitationSchema value) => value.toJson();
}

/// Shared codec for [ElicitationSchema].
const ElicitationSchemaCodec elicitationSchemaCodec = ElicitationSchemaCodec();

/// Type discriminator for elicitation schemas.
final class ElicitationSchemaType implements AcpJsonEncodable {
  /// Validates and creates a ElicitationSchemaType value.
  factory ElicitationSchemaType(String value) {
    if (!const <String>{'object'}.contains(value)) {
      throw FormatException('Unknown ElicitationSchemaType: $value');
    }
    return ElicitationSchemaType._(value);
  }

  const ElicitationSchemaType._(this.value);

  /// The exact wire string.
  final String value;

  /// The `object` schema value.
  static const ElicitationSchemaType object = ElicitationSchemaType._('object');

  /// Decodes a wire string.
  factory ElicitationSchemaType.fromJson(Object? json) =>
      ElicitationSchemaType(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is ElicitationSchemaType && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [ElicitationSchemaType].
final class ElicitationSchemaTypeCodec
    implements AcpCodec<ElicitationSchemaType> {
  /// Creates the codec.
  const ElicitationSchemaTypeCodec();

  @override
  ElicitationSchemaType decode(Object? value) =>
      ElicitationSchemaType.fromJson(value);

  @override
  String encode(ElicitationSchemaType value) => value.toJson();
}

/// Shared codec for [ElicitationSchemaType].
const ElicitationSchemaTypeCodec elicitationSchemaTypeCodec =
    ElicitationSchemaTypeCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Session-scoped elicitation, optionally tied to a specific tool call.
///
/// When `tool_call_id` is set, the elicitation is tied to a specific tool call.
/// This is useful when an agent receives an elicitation from an MCP server
/// during a tool call and needs to redirect it to the user.
final class ElicitationSessionScope implements AcpJsonEncodable {
  /// Creates a ElicitationSessionScope value.
  ElicitationSessionScope({required this.sessionId, this.toolCallId});

  /// The session this elicitation is tied to.
  final SessionId sessionId;

  /// Optional tool call within the session.
  ///
  /// Optional. Omitted and `null` are equivalent and mean the elicitation is scoped to the
  /// session without a specific tool call.
  final ToolCallId? toolCallId;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ElicitationSessionScope> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ElicitationSessionScope(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      toolCallId: decoder
          .optionalOnError(
            'toolCallId',
            (value) => toolCallIdCodec.decode(value),
          )
          .valueOrNull,
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ElicitationSessionScope.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    if (toolCallId != null) {
      result['toolCallId'] = toolCallIdCodec.encode(toolCallId!);
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ElicitationSessionScope].
final class ElicitationSessionScopeCodec
    implements AcpCodec<ElicitationSessionScope> {
  /// Creates the codec.
  const ElicitationSessionScopeCodec();

  @override
  ElicitationSessionScope decode(Object? value) =>
      ElicitationSessionScope.fromJson(decodeAcpObject(value));

  @override
  Object encode(ElicitationSessionScope value) => value.toJson();
}

/// Shared codec for [ElicitationSessionScope].
const ElicitationSessionScopeCodec elicitationSessionScopeCodec =
    ElicitationSessionScopeCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// URL-based elicitation capabilities.
///
/// Supplying `{}` means the client supports URL-based elicitation.
final class ElicitationUrlCapabilities implements AcpJsonEncodable {
  /// Creates a ElicitationUrlCapabilities value.
  ElicitationUrlCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ElicitationUrlCapabilities.fromJson(Map<String, Object?> json) =>
      _$ElicitationUrlCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ElicitationUrlCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ElicitationUrlCapabilities].
final class ElicitationUrlCapabilitiesCodec
    implements AcpCodec<ElicitationUrlCapabilities> {
  /// Creates the codec.
  const ElicitationUrlCapabilitiesCodec();

  @override
  ElicitationUrlCapabilities decode(Object? value) =>
      ElicitationUrlCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(ElicitationUrlCapabilities value) => value.toJson();
}

/// Shared codec for [ElicitationUrlCapabilities].
const ElicitationUrlCapabilitiesCodec elicitationUrlCapabilitiesCodec =
    ElicitationUrlCapabilitiesCodec();

/// URL-based elicitation mode where the client directs the user to a URL.
final class ElicitationUrlMode implements AcpJsonEncodable {
  /// Creates a ElicitationUrlMode value.
  ElicitationUrlMode({
    required this.elicitationId,
    required this.url,
    required this.variant,
  });

  /// The unique identifier for this elicitation.
  final ElicitationId elicitationId;

  /// The URL to direct the user to.
  final Uri url;

  /// The concrete schema composition branch.
  final ElicitationUrlModeVariant variant;

  /// Decodes this composed model with resilient fields.
  static AcpDecoded<ElicitationUrlMode> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ElicitationUrlMode(
      elicitationId: decoder.required(
        'elicitationId',
        (value) => elicitationIdCodec.decode(value),
      ),
      url: decoder.required('url', (value) => decodeAcpUri(value)),
      variant: _decodeElicitationUrlModeVariant(json),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ElicitationUrlMode.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{...variant.toJson()};
    result['elicitationId'] = elicitationIdCodec.encode(elicitationId);
    result['url'] = url.toString();
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// One concrete composition branch for [ElicitationUrlMode].
sealed class ElicitationUrlModeVariant {
  const ElicitationUrlModeVariant();

  /// Encodes the branch fields into their flattened object.
  Map<String, Object?> toJson();
}

/// Tied to a session, optionally to a specific tool call within that session.
final class ElicitationUrlModeSession extends ElicitationUrlModeVariant {
  /// Creates this typed composition branch.
  const ElicitationUrlModeSession(this.value);

  /// The typed branch payload.
  final ElicitationSessionScope value;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    ...decodeAcpObject(elicitationSessionScopeCodec.encode(value)),
  };
}

/// Tied to a specific JSON-RPC request outside of a session
/// (e.g., during auth/configuration phases before any session is started).
final class ElicitationUrlModeRequest extends ElicitationUrlModeVariant {
  /// Creates this typed composition branch.
  const ElicitationUrlModeRequest(this.value);

  /// The typed branch payload.
  final ElicitationRequestScope value;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    ...decodeAcpObject(elicitationRequestScopeCodec.encode(value)),
  };
}

ElicitationUrlModeVariant _decodeElicitationUrlModeVariant(Object? value) {
  final payload = decodeAcpObject(value);
  try {
    return ElicitationUrlModeSession(
      elicitationSessionScopeCodec.decode(payload),
    );
  } on Object {
    // Try the next structurally distinct branch.
  }
  try {
    return ElicitationUrlModeRequest(
      elicitationRequestScopeCodec.decode(payload),
    );
  } on Object {
    // Try the next structurally distinct branch.
  }
  throw const FormatException('Value does not match ElicitationUrlMode');
}

/// Codec for [ElicitationUrlMode].
final class ElicitationUrlModeCodec implements AcpCodec<ElicitationUrlMode> {
  /// Creates the codec.
  const ElicitationUrlModeCodec();

  @override
  ElicitationUrlMode decode(Object? value) =>
      ElicitationUrlMode.fromJson(decodeAcpObject(value));

  @override
  Object encode(ElicitationUrlMode value) => value.toJson();
}

/// Shared codec for [ElicitationUrlMode].
const ElicitationUrlModeCodec elicitationUrlModeCodec =
    ElicitationUrlModeCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// The contents of a resource, embedded into a prompt or tool call result.
final class EmbeddedResource implements AcpJsonEncodable {
  /// Creates a EmbeddedResource value.
  EmbeddedResource({required this.resource, this.annotations, this.meta});

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// Embedded resource payload, either text or binary data.
  final EmbeddedResourceResource resource;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<EmbeddedResource> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = EmbeddedResource(
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
          .valueOrNull,
      resource: decoder.required(
        'resource',
        (value) => embeddedResourceResourceCodec.decode(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory EmbeddedResource.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
    }
    result['resource'] = embeddedResourceResourceCodec.encode(resource);
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [EmbeddedResource].
final class EmbeddedResourceCodec implements AcpCodec<EmbeddedResource> {
  /// Creates the codec.
  const EmbeddedResourceCodec();

  @override
  EmbeddedResource decode(Object? value) =>
      EmbeddedResource.fromJson(decodeAcpObject(value));

  @override
  Object encode(EmbeddedResource value) => value.toJson();
}

/// Shared codec for [EmbeddedResource].
const EmbeddedResourceCodec embeddedResourceCodec = EmbeddedResourceCodec();

/// Resource content that can be embedded in a message.
sealed class EmbeddedResourceResource implements AcpJsonEncodable {
  const EmbeddedResourceResource();

  /// Decodes one concrete union member.
  factory EmbeddedResourceResource.fromJson(Object? json) =>
      embeddedResourceResourceCodec.decode(json);

  /// Encodes the concrete union member.
  Object? toJson();

  @override
  AcpJsonValue toAcpJson() => AcpJsonValue.fromObject(toJson());
}

/// Text resource contents embedded directly in the message.
final class EmbeddedResourceResourceTextResourceContents
    extends EmbeddedResourceResource {
  /// Creates this concrete union member.
  const EmbeddedResourceResourceTextResourceContents(this.value);

  /// The typed union value.
  final TextResourceContents value;

  @override
  Object? toJson() => textResourceContentsCodec.encode(value);
}

/// Binary resource contents embedded directly in the message.
final class EmbeddedResourceResourceBlobResourceContents
    extends EmbeddedResourceResource {
  /// Creates this concrete union member.
  const EmbeddedResourceResourceBlobResourceContents(this.value);

  /// The typed union value.
  final BlobResourceContents value;

  @override
  Object? toJson() => blobResourceContentsCodec.encode(value);
}

/// Codec for [EmbeddedResourceResource].
final class EmbeddedResourceResourceCodec
    implements AcpCodec<EmbeddedResourceResource> {
  /// Creates the codec.
  const EmbeddedResourceResourceCodec();

  @override
  EmbeddedResourceResource decode(Object? value) {
    try {
      return EmbeddedResourceResourceTextResourceContents(
        textResourceContentsCodec.decode(value),
      );
    } on Object {
      // Try the next structurally distinct member.
    }
    try {
      return EmbeddedResourceResourceBlobResourceContents(
        blobResourceContentsCodec.decode(value),
      );
    } on Object {
      // Try the next structurally distinct member.
    }
    throw const FormatException(
      'Value does not match EmbeddedResourceResource',
    );
  }

  @override
  Object? encode(EmbeddedResourceResource value) => value.toJson();
}

/// Shared codec for [EmbeddedResourceResource].
const EmbeddedResourceResourceCodec embeddedResourceResourceCodec =
    EmbeddedResourceResourceCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A titled enum option with a const value, human-readable title, and optional description.
final class EnumOption implements AcpJsonEncodable {
  /// Creates a EnumOption value.
  EnumOption({
    required this.constValue,
    required this.title,
    this.description,
    this.meta,
  });

  /// The constant value for this option.
  final String constValue;

  /// Human-readable title for this option.
  final String title;

  /// Human-readable description.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no description is provided.
  final String? description;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<EnumOption> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = EnumOption(
      constValue: decoder.required('const', (value) => decodeAcpString(value)),
      title: decoder.required('title', (value) => decodeAcpString(value)),
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory EnumOption.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['const'] = constValue;
    result['title'] = title;
    if (description != null) {
      result['description'] = description!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [EnumOption].
final class EnumOptionCodec implements AcpCodec<EnumOption> {
  /// Creates the codec.
  const EnumOptionCodec();

  @override
  EnumOption decode(Object? value) =>
      EnumOption.fromJson(decodeAcpObject(value));

  @override
  Object encode(EnumOption value) => value.toJson();
}

/// Shared codec for [EnumOption].
const EnumOptionCodec enumOptionCodec = EnumOptionCodec();

String _decodeEnvVariableName(Object? value) => decodeAcpString(value);
Object? _encodeEnvVariableName(String value) => value;

String _decodeEnvVariableValue(Object? value) => decodeAcpString(value);
Object? _encodeEnvVariableValue(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// An environment variable to set when launching an MCP server.
final class EnvVariable implements AcpJsonEncodable {
  /// Creates a EnvVariable value.
  EnvVariable({required this.name, required this.value, this.meta});

  /// The name of the environment variable.
  @JsonKey(
    name: 'name',
    fromJson: _decodeEnvVariableName,
    toJson: _encodeEnvVariableName,
    includeIfNull: false,
    required: true,
  )
  final String name;

  /// The value to set for the environment variable.
  @JsonKey(
    name: 'value',
    fromJson: _decodeEnvVariableValue,
    toJson: _encodeEnvVariableValue,
    includeIfNull: false,
    required: true,
  )
  final String value;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory EnvVariable.fromJson(Map<String, Object?> json) =>
      _$EnvVariableFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$EnvVariableToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [EnvVariable].
final class EnvVariableCodec implements AcpCodec<EnvVariable> {
  /// Creates the codec.
  const EnvVariableCodec();

  @override
  EnvVariable decode(Object? value) =>
      EnvVariable.fromJson(decodeAcpObject(value));

  @override
  Object encode(EnvVariable value) => value.toJson();
}

/// Shared codec for [EnvVariable].
const EnvVariableCodec envVariableCodec = EnvVariableCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// JSON-RPC error object.
///
/// Represents an error that occurred during method execution, following the
/// JSON-RPC 2.0 error object specification with optional additional data.
///
/// See protocol docs: [JSON-RPC Error Object](https://www.jsonrpc.org/specification#error_object)
final class Error implements AcpJsonEncodable {
  /// Creates a Error value.
  Error({required this.code, required this.message, this.data});

  /// A number indicating the error type that occurred.
  /// This must be an integer as defined in the JSON-RPC specification.
  final ErrorCode code;

  /// A string providing a short description of the error.
  /// The message should be limited to a concise single sentence.
  final String message;

  /// Optional primitive or structured value that contains additional information about the error.
  /// This may include debugging information or context-specific details.
  final AcpJsonValue? data;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<Error> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = Error(
      code: decoder.required('code', (value) => errorCodeCodec.decode(value)),
      message: decoder.required('message', (value) => decodeAcpString(value)),
      data: decoder
          .optionalOnError('data', (value) => AcpJsonValue.fromObject(value))
          .valueOrNull,
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory Error.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['code'] = errorCodeCodec.encode(code);
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Error].
final class ErrorCodec implements AcpCodec<Error> {
  /// Creates the codec.
  const ErrorCodec();

  @override
  Error decode(Object? value) => Error.fromJson(decodeAcpObject(value));

  @override
  Object encode(Error value) => value.toJson();
}

/// Shared codec for [Error].
const ErrorCodec errorCodec = ErrorCodec();

/// Predefined error codes for common JSON-RPC and ACP-specific errors.
///
/// These codes follow the JSON-RPC 2.0 specification for standard errors
/// and use the reserved range (-32000 to -32099) for protocol-specific errors.
final class ErrorCode implements AcpJsonEncodable {
  /// Validates and creates a ErrorCode value.
  factory ErrorCode(int value) {
    return ErrorCode._(value);
  }

  const ErrorCode._(this.value);

  /// The exact wire number.
  final int value;

  /// Decodes a wire number.
  factory ErrorCode.fromJson(Object? json) => ErrorCode(decodeAcpInteger(json));

  /// Encodes the wire number.
  int toJson() => value;

  @override
  AcpJsonNumber toAcpJson() => AcpJsonNumber(value);

  @override
  bool operator ==(Object other) => other is ErrorCode && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [ErrorCode].
final class ErrorCodeCodec implements AcpCodec<ErrorCode> {
  /// Creates the codec.
  const ErrorCodeCodec();

  @override
  ErrorCode decode(Object? value) => ErrorCode.fromJson(value);

  @override
  int encode(ErrorCode value) => value.toJson();
}

/// Shared codec for [ErrorCode].
const ErrorCodeCodec errorCodeCodec = ErrorCodeCodec();

/// Allows the Agent to send an arbitrary notification that is not part of the ACP spec.
/// Extension notifications provide a way to send one-way messages for custom functionality
/// while maintaining protocol compatibility.
///
/// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
final class ExtNotification implements AcpJsonEncodable {
  /// Creates a raw-preserving schema union value.
  ExtNotification(AcpJsonValue value) : value = value;

  /// The immutable union payload.
  final AcpJsonValue value;

  /// Decodes a union payload.
  factory ExtNotification.fromJson(Object? json) =>
      ExtNotification(AcpJsonValue.fromObject(json));

  /// Encodes the union payload.
  Object? toJson() => value.toObject();

  @override
  AcpJsonValue toAcpJson() => value;
}

/// Codec for [ExtNotification].
final class ExtNotificationCodec implements AcpCodec<ExtNotification> {
  /// Creates the codec.
  const ExtNotificationCodec();

  @override
  ExtNotification decode(Object? value) => ExtNotification.fromJson(value);

  @override
  Object? encode(ExtNotification value) => value.toJson();
}

/// Shared codec for [ExtNotification].
const ExtNotificationCodec extNotificationCodec = ExtNotificationCodec();

/// Allows for sending an arbitrary request that is not part of the ACP spec.
/// Extension methods provide a way to add custom functionality while maintaining
/// protocol compatibility.
///
/// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
final class ExtRequest implements AcpJsonEncodable {
  /// Creates a raw-preserving schema union value.
  ExtRequest(AcpJsonValue value) : value = value;

  /// The immutable union payload.
  final AcpJsonValue value;

  /// Decodes a union payload.
  factory ExtRequest.fromJson(Object? json) =>
      ExtRequest(AcpJsonValue.fromObject(json));

  /// Encodes the union payload.
  Object? toJson() => value.toObject();

  @override
  AcpJsonValue toAcpJson() => value;
}

/// Codec for [ExtRequest].
final class ExtRequestCodec implements AcpCodec<ExtRequest> {
  /// Creates the codec.
  const ExtRequestCodec();

  @override
  ExtRequest decode(Object? value) => ExtRequest.fromJson(value);

  @override
  Object? encode(ExtRequest value) => value.toJson();
}

/// Shared codec for [ExtRequest].
const ExtRequestCodec extRequestCodec = ExtRequestCodec();

/// Allows for sending an arbitrary response to an `ExtRequest` that is not part of the ACP spec.
/// Extension methods provide a way to add custom functionality while maintaining
/// protocol compatibility.
///
/// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
final class ExtResponse implements AcpJsonEncodable {
  /// Creates a raw-preserving schema union value.
  ExtResponse(AcpJsonValue value) : value = value;

  /// The immutable union payload.
  final AcpJsonValue value;

  /// Decodes a union payload.
  factory ExtResponse.fromJson(Object? json) =>
      ExtResponse(AcpJsonValue.fromObject(json));

  /// Encodes the union payload.
  Object? toJson() => value.toObject();

  @override
  AcpJsonValue toAcpJson() => value;
}

/// Codec for [ExtResponse].
final class ExtResponseCodec implements AcpCodec<ExtResponse> {
  /// Creates the codec.
  const ExtResponseCodec();

  @override
  ExtResponse decode(Object? value) => ExtResponse.fromJson(value);

  @override
  Object? encode(ExtResponse value) => value.toJson();
}

/// Shared codec for [ExtResponse].
const ExtResponseCodec extResponseCodec = ExtResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// File system capabilities that a client may support.
///
/// See protocol docs: [FileSystem](https://agentclientprotocol.com/protocol/initialization#filesystem)
final class FileSystemCapabilities implements AcpJsonEncodable {
  /// Creates a FileSystemCapabilities value.
  FileSystemCapabilities({
    required this.readTextFile,
    required this.writeTextFile,
    this.meta,
  });

  /// Whether the Client supports `fs/read_text_file` requests.
  final bool readTextFile;

  /// Whether the Client supports `fs/write_text_file` requests.
  final bool writeTextFile;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<FileSystemCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = FileSystemCapabilities(
      readTextFile: decoder.defaultOnError(
        'readTextFile',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      writeTextFile: decoder.defaultOnError(
        'writeTextFile',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory FileSystemCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['readTextFile'] = readTextFile;
    result['writeTextFile'] = writeTextFile;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [FileSystemCapabilities].
final class FileSystemCapabilitiesCodec
    implements AcpCodec<FileSystemCapabilities> {
  /// Creates the codec.
  const FileSystemCapabilitiesCodec();

  @override
  FileSystemCapabilities decode(Object? value) =>
      FileSystemCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(FileSystemCapabilities value) => value.toJson();
}

/// Shared codec for [FileSystemCapabilities].
const FileSystemCapabilitiesCodec fileSystemCapabilitiesCodec =
    FileSystemCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for forking an existing session.
///
/// Creates a new session based on the context of an existing one, allowing
/// operations like generating summaries without affecting the original session's history.
final class ForkSessionRequest implements AcpJsonEncodable {
  /// Creates a ForkSessionRequest value.
  ForkSessionRequest({
    required this.sessionId,
    required this.cwd,
    List<String>? additionalDirectories,
    List<McpServer>? mcpServers,
    this.meta,
  }) : additionalDirectories = additionalDirectories == null
           ? null
           : List<String>.unmodifiable(additionalDirectories),
       mcpServers = mcpServers == null
           ? null
           : List<McpServer>.unmodifiable(mcpServers);

  /// The ID of the session to fork.
  final SessionId sessionId;

  /// The working directory for this session. Must be an absolute path.
  final String cwd;

  /// Additional workspace roots to activate for this session. Each path must be absolute.
  ///
  /// When omitted or empty, no additional roots are activated. When non-empty,
  /// this is the complete resulting additional-root list for the forked
  /// session.
  final List<String>? additionalDirectories;

  /// List of MCP servers to connect to for this session.
  final List<McpServer>? mcpServers;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ForkSessionRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ForkSessionRequest(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      cwd: decoder.required('cwd', (value) => decodeAcpString(value)),
      additionalDirectories: decoder.listSkippingInvalid(
        'additionalDirectories',
        (value) => decodeAcpString(value),
        isRequired: false,
      ),
      mcpServers: decoder.listSkippingInvalid(
        'mcpServers',
        (value) => mcpServerCodec.decode(value),
        isRequired: false,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ForkSessionRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['cwd'] = cwd;
    if (additionalDirectories != null) {
      result['additionalDirectories'] = <Object?>[
        for (final item in additionalDirectories!) item,
      ];
    }
    if (mcpServers != null) {
      result['mcpServers'] = <Object?>[
        for (final item in mcpServers!) mcpServerCodec.encode(item),
      ];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ForkSessionRequest].
final class ForkSessionRequestCodec implements AcpCodec<ForkSessionRequest> {
  /// Creates the codec.
  const ForkSessionRequestCodec();

  @override
  ForkSessionRequest decode(Object? value) =>
      ForkSessionRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(ForkSessionRequest value) => value.toJson();
}

/// Shared codec for [ForkSessionRequest].
const ForkSessionRequestCodec forkSessionRequestCodec =
    ForkSessionRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Response from forking an existing session.
final class ForkSessionResponse implements AcpJsonEncodable {
  /// Creates a ForkSessionResponse value.
  ForkSessionResponse({
    required this.sessionId,
    this.modes,
    List<SessionConfigOption>? configOptions,
    this.meta,
  }) : configOptions = configOptions == null
           ? null
           : List<SessionConfigOption>.unmodifiable(configOptions);

  /// Unique identifier for the newly created forked session.
  final SessionId sessionId;

  /// Initial mode state if supported by the Agent
  ///
  /// See protocol docs: [Session Modes](https://agentclientprotocol.com/protocol/session-modes)
  final SessionModeState? modes;

  /// Initial session configuration options if supported by the Agent.
  final List<SessionConfigOption>? configOptions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ForkSessionResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ForkSessionResponse(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      modes: decoder
          .optionalOnError(
            'modes',
            (value) => sessionModeStateCodec.decode(value),
          )
          .valueOrNull,
      configOptions: decoder.listSkippingInvalid(
        'configOptions',
        (value) => sessionConfigOptionCodec.decode(value),
        isRequired: false,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ForkSessionResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    if (modes != null) {
      result['modes'] = sessionModeStateCodec.encode(modes!);
    }
    if (configOptions != null) {
      result['configOptions'] = <Object?>[
        for (final item in configOptions!)
          sessionConfigOptionCodec.encode(item),
      ];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ForkSessionResponse].
final class ForkSessionResponseCodec implements AcpCodec<ForkSessionResponse> {
  /// Creates the codec.
  const ForkSessionResponseCodec();

  @override
  ForkSessionResponse decode(Object? value) =>
      ForkSessionResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(ForkSessionResponse value) => value.toJson();
}

/// Shared codec for [ForkSessionResponse].
const ForkSessionResponseCodec forkSessionResponseCodec =
    ForkSessionResponseCodec();

String _decodeHttpHeaderName(Object? value) => decodeAcpString(value);
Object? _encodeHttpHeaderName(String value) => value;

String _decodeHttpHeaderValue(Object? value) => decodeAcpString(value);
Object? _encodeHttpHeaderValue(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// An HTTP header to set when making requests to the MCP server.
final class HttpHeader implements AcpJsonEncodable {
  /// Creates a HttpHeader value.
  HttpHeader({required this.name, required this.value, this.meta});

  /// The name of the HTTP header.
  @JsonKey(
    name: 'name',
    fromJson: _decodeHttpHeaderName,
    toJson: _encodeHttpHeaderName,
    includeIfNull: false,
    required: true,
  )
  final String name;

  /// The value to set for the HTTP header.
  @JsonKey(
    name: 'value',
    fromJson: _decodeHttpHeaderValue,
    toJson: _encodeHttpHeaderValue,
    includeIfNull: false,
    required: true,
  )
  final String value;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory HttpHeader.fromJson(Map<String, Object?> json) =>
      _$HttpHeaderFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$HttpHeaderToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [HttpHeader].
final class HttpHeaderCodec implements AcpCodec<HttpHeader> {
  /// Creates the codec.
  const HttpHeaderCodec();

  @override
  HttpHeader decode(Object? value) =>
      HttpHeader.fromJson(decodeAcpObject(value));

  @override
  Object encode(HttpHeader value) => value.toJson();
}

/// Shared codec for [HttpHeader].
const HttpHeaderCodec httpHeaderCodec = HttpHeaderCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// An image provided to or from an LLM.
final class ImageContent implements AcpJsonEncodable {
  /// Creates a ImageContent value.
  ImageContent({
    required this.data,
    required this.mimeType,
    this.annotations,
    this.uri,
    this.meta,
  });

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// Base64-encoded media payload.
  final String data;

  /// MIME type describing the encoded media payload.
  final String mimeType;

  /// URI associated with this resource or media payload.
  final String? uri;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ImageContent> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ImageContent(
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
          .valueOrNull,
      data: decoder.required('data', (value) => decodeAcpString(value)),
      mimeType: decoder.required('mimeType', (value) => decodeAcpString(value)),
      uri: decoder
          .optionalOnError('uri', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ImageContent.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
    }
    result['data'] = data;
    result['mimeType'] = mimeType;
    if (uri != null) {
      result['uri'] = uri!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ImageContent].
final class ImageContentCodec implements AcpCodec<ImageContent> {
  /// Creates the codec.
  const ImageContentCodec();

  @override
  ImageContent decode(Object? value) =>
      ImageContent.fromJson(decodeAcpObject(value));

  @override
  Object encode(ImageContent value) => value.toJson();
}

/// Shared codec for [ImageContent].
const ImageContentCodec imageContentCodec = ImageContentCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Metadata about the implementation of the client or agent.
/// Describes the name and version of an ACP implementation, with an optional
/// title for UI representation.
final class Implementation implements AcpJsonEncodable {
  /// Creates a Implementation value.
  Implementation({
    required this.name,
    required this.version,
    this.title,
    this.meta,
  });

  /// Intended for programmatic or logical use, but can be used as a display
  /// name fallback if title isn’t present.
  final String name;

  /// Intended for UI and end-user contexts — optimized to be human-readable
  /// and easily understood.
  ///
  /// If not provided, the name should be used for display.
  final String? title;

  /// Version of the implementation. Can be displayed to the user or used
  /// for debugging or metrics purposes. (e.g. "1.0.0").
  final String version;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<Implementation> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = Implementation(
      name: decoder.required('name', (value) => decodeAcpString(value)),
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      version: decoder.required('version', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory Implementation.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['name'] = name;
    if (title != null) {
      result['title'] = title!;
    }
    result['version'] = version;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Implementation].
final class ImplementationCodec implements AcpCodec<Implementation> {
  /// Creates the codec.
  const ImplementationCodec();

  @override
  Implementation decode(Object? value) =>
      Implementation.fromJson(decodeAcpObject(value));

  @override
  Object encode(Implementation value) => value.toJson();
}

/// Shared codec for [Implementation].
const ImplementationCodec implementationCodec = ImplementationCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request parameters for the initialize method.
///
/// Sent by the client to establish connection and negotiate capabilities.
///
/// See protocol docs: [Initialization](https://agentclientprotocol.com/protocol/initialization)
final class InitializeRequest implements AcpJsonEncodable {
  /// Creates a InitializeRequest value.
  InitializeRequest({
    required this.protocolVersion,
    required this.clientCapabilities,
    this.clientInfo,
    this.meta,
  });

  /// The latest protocol version supported by the client.
  final ProtocolVersion protocolVersion;

  /// Capabilities supported by the client.
  final ClientCapabilities clientCapabilities;

  /// Information about the Client name and version sent to the Agent.
  ///
  /// Note: in future versions of the protocol, this will be required.
  final Implementation? clientInfo;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<InitializeRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = InitializeRequest(
      protocolVersion: decoder.required(
        'protocolVersion',
        (value) => protocolVersionCodec.decode(value),
      ),
      clientCapabilities: decoder.defaultOnError(
        'clientCapabilities',
        clientCapabilitiesCodec.decode(<String, Object?>{
          'fs': <String, Object?>{
            'readTextFile': false,
            'writeTextFile': false,
          },
          'terminal': false,
          'auth': <String, Object?>{'terminal': false},
        }),
        (value) => clientCapabilitiesCodec.decode(value),
      ),
      clientInfo: decoder
          .optionalOnError(
            'clientInfo',
            (value) => implementationCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory InitializeRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['protocolVersion'] = protocolVersionCodec.encode(protocolVersion);
    result['clientCapabilities'] = clientCapabilitiesCodec.encode(
      clientCapabilities,
    );
    if (clientInfo != null) {
      result['clientInfo'] = implementationCodec.encode(clientInfo!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [InitializeRequest].
final class InitializeRequestCodec implements AcpCodec<InitializeRequest> {
  /// Creates the codec.
  const InitializeRequestCodec();

  @override
  InitializeRequest decode(Object? value) =>
      InitializeRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(InitializeRequest value) => value.toJson();
}

/// Shared codec for [InitializeRequest].
const InitializeRequestCodec initializeRequestCodec = InitializeRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Response to the `initialize` method.
///
/// Contains the negotiated protocol version and agent capabilities.
///
/// See protocol docs: [Initialization](https://agentclientprotocol.com/protocol/initialization)
final class InitializeResponse implements AcpJsonEncodable {
  /// Creates a InitializeResponse value.
  InitializeResponse({
    required this.protocolVersion,
    required this.agentCapabilities,
    required List<AuthMethod> authMethods,
    this.agentInfo,
    this.meta,
  }) : authMethods = List<AuthMethod>.unmodifiable(authMethods);

  /// The protocol version the client specified if supported by the agent,
  /// or the latest protocol version supported by the agent.
  ///
  /// The client should disconnect, if it doesn't support this version.
  final ProtocolVersion protocolVersion;

  /// Capabilities supported by the agent.
  final AgentCapabilities agentCapabilities;

  /// Authentication methods supported by the agent.
  final List<AuthMethod> authMethods;

  /// Information about the Agent name and version sent to the Client.
  ///
  /// Note: in future versions of the protocol, this will be required.
  final Implementation? agentInfo;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<InitializeResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = InitializeResponse(
      protocolVersion: decoder.required(
        'protocolVersion',
        (value) => protocolVersionCodec.decode(value),
      ),
      agentCapabilities: decoder.defaultOnError(
        'agentCapabilities',
        agentCapabilitiesCodec.decode(<String, Object?>{
          'loadSession': false,
          'promptCapabilities': <String, Object?>{
            'image': false,
            'audio': false,
            'embeddedContext': false,
          },
          'mcpCapabilities': <String, Object?>{
            'http': false,
            'sse': false,
            'acp': false,
          },
          'sessionCapabilities': <String, Object?>{},
          'auth': <String, Object?>{},
        }),
        (value) => agentCapabilitiesCodec.decode(value),
      ),
      authMethods: decoder.listSkippingInvalid(
        'authMethods',
        (value) => authMethodCodec.decode(value),
        isRequired: false,
      ),
      agentInfo: decoder
          .optionalOnError(
            'agentInfo',
            (value) => implementationCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory InitializeResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['protocolVersion'] = protocolVersionCodec.encode(protocolVersion);
    result['agentCapabilities'] = agentCapabilitiesCodec.encode(
      agentCapabilities,
    );
    result['authMethods'] = <Object?>[
      for (final item in authMethods) authMethodCodec.encode(item),
    ];
    if (agentInfo != null) {
      result['agentInfo'] = implementationCodec.encode(agentInfo!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [InitializeResponse].
final class InitializeResponseCodec implements AcpCodec<InitializeResponse> {
  /// Creates the codec.
  const InitializeResponseCodec();

  @override
  InitializeResponse decode(Object? value) =>
      InitializeResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(InitializeResponse value) => value.toJson();
}

/// Shared codec for [InitializeResponse].
const InitializeResponseCodec initializeResponseCodec =
    InitializeResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Schema for integer properties in an elicitation form.
final class IntegerPropertySchema implements AcpJsonEncodable {
  /// Creates a IntegerPropertySchema value.
  IntegerPropertySchema({
    this.title,
    this.description,
    this.minimum,
    this.maximum,
    this.defaultValue,
    this.meta,
  });

  /// Optional title for the property.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no title is provided.
  final String? title;

  /// Human-readable description.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no description is provided.
  final String? description;

  /// Minimum value (inclusive).
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no inclusive lower bound.
  final AcpInt64? minimum;

  /// Maximum value (inclusive).
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no inclusive upper bound.
  final AcpInt64? maximum;

  /// Default value.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no default value is provided.
  final AcpInt64? defaultValue;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<IntegerPropertySchema> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = IntegerPropertySchema(
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      minimum: decoder.optional('minimum', (value) => decodeAcpInt64(value)),
      maximum: decoder.optional('maximum', (value) => decodeAcpInt64(value)),
      defaultValue: decoder
          .optionalOnError('default', (value) => decodeAcpInt64(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory IntegerPropertySchema.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (title != null) {
      result['title'] = title!;
    }
    if (description != null) {
      result['description'] = description!;
    }
    if (minimum != null) {
      result['minimum'] = encodeAcpInt64(minimum!);
    }
    if (maximum != null) {
      result['maximum'] = encodeAcpInt64(maximum!);
    }
    if (defaultValue != null) {
      result['default'] = encodeAcpInt64(defaultValue!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [IntegerPropertySchema].
final class IntegerPropertySchemaCodec
    implements AcpCodec<IntegerPropertySchema> {
  /// Creates the codec.
  const IntegerPropertySchemaCodec();

  @override
  IntegerPropertySchema decode(Object? value) =>
      IntegerPropertySchema.fromJson(decodeAcpObject(value));

  @override
  Object encode(IntegerPropertySchema value) => value.toJson();
}

/// Shared codec for [IntegerPropertySchema].
const IntegerPropertySchemaCodec integerPropertySchemaCodec =
    IntegerPropertySchemaCodec();

SessionId _decodeKillTerminalRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeKillTerminalRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

TerminalId _decodeKillTerminalRequestTerminalId(Object? value) =>
    terminalIdCodec.decode(value);
Object? _encodeKillTerminalRequestTerminalId(TerminalId value) =>
    terminalIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request to kill a terminal without releasing it.
final class KillTerminalRequest implements AcpJsonEncodable {
  /// Creates a KillTerminalRequest value.
  KillTerminalRequest({
    required this.sessionId,
    required this.terminalId,
    this.meta,
  });

  /// The session ID for this request.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeKillTerminalRequestSessionId,
    toJson: _encodeKillTerminalRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The ID of the terminal to kill.
  @JsonKey(
    name: 'terminalId',
    fromJson: _decodeKillTerminalRequestTerminalId,
    toJson: _encodeKillTerminalRequestTerminalId,
    includeIfNull: false,
    required: true,
  )
  final TerminalId terminalId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory KillTerminalRequest.fromJson(Map<String, Object?> json) =>
      _$KillTerminalRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$KillTerminalRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [KillTerminalRequest].
final class KillTerminalRequestCodec implements AcpCodec<KillTerminalRequest> {
  /// Creates the codec.
  const KillTerminalRequestCodec();

  @override
  KillTerminalRequest decode(Object? value) =>
      KillTerminalRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(KillTerminalRequest value) => value.toJson();
}

/// Shared codec for [KillTerminalRequest].
const KillTerminalRequestCodec killTerminalRequestCodec =
    KillTerminalRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to `terminal/kill` method
final class KillTerminalResponse implements AcpJsonEncodable {
  /// Creates a KillTerminalResponse value.
  KillTerminalResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory KillTerminalResponse.fromJson(Map<String, Object?> json) =>
      _$KillTerminalResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$KillTerminalResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [KillTerminalResponse].
final class KillTerminalResponseCodec
    implements AcpCodec<KillTerminalResponse> {
  /// Creates the codec.
  const KillTerminalResponseCodec();

  @override
  KillTerminalResponse decode(Object? value) =>
      KillTerminalResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(KillTerminalResponse value) => value.toJson();
}

/// Shared codec for [KillTerminalResponse].
const KillTerminalResponseCodec killTerminalResponseCodec =
    KillTerminalResponseCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `providers/list`.
final class ListProvidersRequest implements AcpJsonEncodable {
  /// Creates a ListProvidersRequest value.
  ListProvidersRequest({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ListProvidersRequest.fromJson(Map<String, Object?> json) =>
      _$ListProvidersRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ListProvidersRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ListProvidersRequest].
final class ListProvidersRequestCodec
    implements AcpCodec<ListProvidersRequest> {
  /// Creates the codec.
  const ListProvidersRequestCodec();

  @override
  ListProvidersRequest decode(Object? value) =>
      ListProvidersRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(ListProvidersRequest value) => value.toJson();
}

/// Shared codec for [ListProvidersRequest].
const ListProvidersRequestCodec listProvidersRequestCodec =
    ListProvidersRequestCodec();

List<ProviderInfo> _decodeListProvidersResponseProviders(Object? value) =>
    List<ProviderInfo>.unmodifiable(
      (value as List<Object?>).map((item) => providerInfoCodec.decode(item)),
    );
Object? _encodeListProvidersResponseProviders(List<ProviderInfo> value) =>
    <Object?>[for (final item in value) providerInfoCodec.encode(item)];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Response to `providers/list`.
final class ListProvidersResponse implements AcpJsonEncodable {
  /// Creates a ListProvidersResponse value.
  ListProvidersResponse({required List<ProviderInfo> providers, this.meta})
    : providers = List<ProviderInfo>.unmodifiable(providers);

  /// Configurable providers with current routing info suitable for UI display.
  @JsonKey(
    name: 'providers',
    fromJson: _decodeListProvidersResponseProviders,
    toJson: _encodeListProvidersResponseProviders,
    includeIfNull: false,
    required: true,
  )
  final List<ProviderInfo> providers;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ListProvidersResponse.fromJson(Map<String, Object?> json) =>
      _$ListProvidersResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ListProvidersResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ListProvidersResponse].
final class ListProvidersResponseCodec
    implements AcpCodec<ListProvidersResponse> {
  /// Creates the codec.
  const ListProvidersResponseCodec();

  @override
  ListProvidersResponse decode(Object? value) =>
      ListProvidersResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(ListProvidersResponse value) => value.toJson();
}

/// Shared codec for [ListProvidersResponse].
const ListProvidersResponseCodec listProvidersResponseCodec =
    ListProvidersResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request parameters for listing existing sessions.
///
/// Only available if the Agent supports the `sessionCapabilities.list` capability.
final class ListSessionsRequest implements AcpJsonEncodable {
  /// Creates a ListSessionsRequest value.
  ListSessionsRequest({this.cwd, this.cursor, this.meta});

  /// Filter sessions by working directory. Must be an absolute path.
  final String? cwd;

  /// Opaque cursor token from a previous response's nextCursor field for cursor-based pagination
  final String? cursor;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ListSessionsRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ListSessionsRequest(
      cwd: decoder.optional('cwd', (value) => decodeAcpString(value)),
      cursor: decoder.optional('cursor', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ListSessionsRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (cwd != null) {
      result['cwd'] = cwd!;
    }
    if (cursor != null) {
      result['cursor'] = cursor!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ListSessionsRequest].
final class ListSessionsRequestCodec implements AcpCodec<ListSessionsRequest> {
  /// Creates the codec.
  const ListSessionsRequestCodec();

  @override
  ListSessionsRequest decode(Object? value) =>
      ListSessionsRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(ListSessionsRequest value) => value.toJson();
}

/// Shared codec for [ListSessionsRequest].
const ListSessionsRequestCodec listSessionsRequestCodec =
    ListSessionsRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Response from listing sessions.
final class ListSessionsResponse implements AcpJsonEncodable {
  /// Creates a ListSessionsResponse value.
  ListSessionsResponse({
    required List<SessionInfo> sessions,
    this.nextCursor,
    this.meta,
  }) : sessions = List<SessionInfo>.unmodifiable(sessions);

  /// Array of session information objects
  final List<SessionInfo> sessions;

  /// Opaque cursor token. If present, pass this in the next request's cursor parameter
  /// to fetch the next page. If absent, there are no more results.
  final String? nextCursor;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ListSessionsResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ListSessionsResponse(
      sessions: decoder.listSkippingInvalid(
        'sessions',
        (value) => sessionInfoCodec.decode(value),
        isRequired: true,
      ),
      nextCursor: decoder
          .optionalOnError('nextCursor', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ListSessionsResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessions'] = <Object?>[
      for (final item in sessions) sessionInfoCodec.encode(item),
    ];
    if (nextCursor != null) {
      result['nextCursor'] = nextCursor!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ListSessionsResponse].
final class ListSessionsResponseCodec
    implements AcpCodec<ListSessionsResponse> {
  /// Creates the codec.
  const ListSessionsResponseCodec();

  @override
  ListSessionsResponse decode(Object? value) =>
      ListSessionsResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(ListSessionsResponse value) => value.toJson();
}

/// Shared codec for [ListSessionsResponse].
const ListSessionsResponseCodec listSessionsResponseCodec =
    ListSessionsResponseCodec();

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Well-known API protocol identifiers for LLM providers.
///
/// Agents and clients MUST handle unknown protocol identifiers gracefully.
///
final class LlmProtocol implements AcpJsonEncodable {
  /// Validates and creates a LlmProtocol value.
  factory LlmProtocol(String value) {
    return LlmProtocol._(value);
  }

  const LlmProtocol._(this.value);

  /// The exact wire string.
  final String value;

  /// The `anthropic` schema value.
  static const LlmProtocol anthropic = LlmProtocol._('anthropic');

  /// The `openai` schema value.
  static const LlmProtocol openai = LlmProtocol._('openai');

  /// The `azure` schema value.
  static const LlmProtocol azure = LlmProtocol._('azure');

  /// The `vertex` schema value.
  static const LlmProtocol vertex = LlmProtocol._('vertex');

  /// The `bedrock` schema value.
  static const LlmProtocol bedrock = LlmProtocol._('bedrock');

  /// Decodes a wire string.
  factory LlmProtocol.fromJson(Object? json) =>
      LlmProtocol(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is LlmProtocol && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [LlmProtocol].
final class LlmProtocolCodec implements AcpCodec<LlmProtocol> {
  /// Creates the codec.
  const LlmProtocolCodec();

  @override
  LlmProtocol decode(Object? value) => LlmProtocol.fromJson(value);

  @override
  String encode(LlmProtocol value) => value.toJson();
}

/// Shared codec for [LlmProtocol].
const LlmProtocolCodec llmProtocolCodec = LlmProtocolCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request parameters for loading an existing session.
///
/// Only available if the Agent supports the `loadSession` capability.
///
/// See protocol docs: [Loading Sessions](https://agentclientprotocol.com/protocol/session-setup#loading-sessions)
final class LoadSessionRequest implements AcpJsonEncodable {
  /// Creates a LoadSessionRequest value.
  LoadSessionRequest({
    required List<McpServer> mcpServers,
    required this.cwd,
    required this.sessionId,
    List<String>? additionalDirectories,
    this.meta,
  }) : mcpServers = List<McpServer>.unmodifiable(mcpServers),
       additionalDirectories = additionalDirectories == null
           ? null
           : List<String>.unmodifiable(additionalDirectories);

  /// List of MCP servers to connect to for this session.
  final List<McpServer> mcpServers;

  /// The working directory for this session. Must be an absolute path.
  final String cwd;

  /// Additional workspace roots to activate for this session. Each path must be absolute.
  ///
  /// When omitted or empty, no additional roots are activated. When non-empty,
  /// this is the complete resulting additional-root list for the loaded
  /// session. It may differ from any previously used or reported list as long as
  /// the request `cwd` matches the session's `cwd`.
  final List<String>? additionalDirectories;

  /// The ID of the session to load.
  final SessionId sessionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<LoadSessionRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = LoadSessionRequest(
      mcpServers: decoder.listSkippingInvalid(
        'mcpServers',
        (value) => mcpServerCodec.decode(value),
        isRequired: true,
      ),
      cwd: decoder.required('cwd', (value) => decodeAcpString(value)),
      additionalDirectories: decoder.listSkippingInvalid(
        'additionalDirectories',
        (value) => decodeAcpString(value),
        isRequired: false,
      ),
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory LoadSessionRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['mcpServers'] = <Object?>[
      for (final item in mcpServers) mcpServerCodec.encode(item),
    ];
    result['cwd'] = cwd;
    if (additionalDirectories != null) {
      result['additionalDirectories'] = <Object?>[
        for (final item in additionalDirectories!) item,
      ];
    }
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [LoadSessionRequest].
final class LoadSessionRequestCodec implements AcpCodec<LoadSessionRequest> {
  /// Creates the codec.
  const LoadSessionRequestCodec();

  @override
  LoadSessionRequest decode(Object? value) =>
      LoadSessionRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(LoadSessionRequest value) => value.toJson();
}

/// Shared codec for [LoadSessionRequest].
const LoadSessionRequestCodec loadSessionRequestCodec =
    LoadSessionRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Response from loading an existing session.
final class LoadSessionResponse implements AcpJsonEncodable {
  /// Creates a LoadSessionResponse value.
  LoadSessionResponse({
    this.modes,
    List<SessionConfigOption>? configOptions,
    this.meta,
  }) : configOptions = configOptions == null
           ? null
           : List<SessionConfigOption>.unmodifiable(configOptions);

  /// Initial mode state if supported by the Agent
  ///
  /// See protocol docs: [Session Modes](https://agentclientprotocol.com/protocol/session-modes)
  final SessionModeState? modes;

  /// Initial session configuration options if supported by the Agent.
  final List<SessionConfigOption>? configOptions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<LoadSessionResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = LoadSessionResponse(
      modes: decoder
          .optionalOnError(
            'modes',
            (value) => sessionModeStateCodec.decode(value),
          )
          .valueOrNull,
      configOptions: decoder.listSkippingInvalid(
        'configOptions',
        (value) => sessionConfigOptionCodec.decode(value),
        isRequired: false,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory LoadSessionResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (modes != null) {
      result['modes'] = sessionModeStateCodec.encode(modes!);
    }
    if (configOptions != null) {
      result['configOptions'] = <Object?>[
        for (final item in configOptions!)
          sessionConfigOptionCodec.encode(item),
      ];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [LoadSessionResponse].
final class LoadSessionResponseCodec implements AcpCodec<LoadSessionResponse> {
  /// Creates the codec.
  const LoadSessionResponseCodec();

  @override
  LoadSessionResponse decode(Object? value) =>
      LoadSessionResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(LoadSessionResponse value) => value.toJson();
}

/// Shared codec for [LoadSessionResponse].
const LoadSessionResponseCodec loadSessionResponseCodec =
    LoadSessionResponseCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Logout capabilities supported by the agent.
///
/// Supplying `{}` means the agent supports the logout method.
final class LogoutCapabilities implements AcpJsonEncodable {
  /// Creates a LogoutCapabilities value.
  LogoutCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory LogoutCapabilities.fromJson(Map<String, Object?> json) =>
      _$LogoutCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$LogoutCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [LogoutCapabilities].
final class LogoutCapabilitiesCodec implements AcpCodec<LogoutCapabilities> {
  /// Creates the codec.
  const LogoutCapabilitiesCodec();

  @override
  LogoutCapabilities decode(Object? value) =>
      LogoutCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(LogoutCapabilities value) => value.toJson();
}

/// Shared codec for [LogoutCapabilities].
const LogoutCapabilitiesCodec logoutCapabilitiesCodec =
    LogoutCapabilitiesCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for the logout method.
///
/// Terminates the current authenticated session.
final class LogoutRequest implements AcpJsonEncodable {
  /// Creates a LogoutRequest value.
  LogoutRequest({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory LogoutRequest.fromJson(Map<String, Object?> json) =>
      _$LogoutRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$LogoutRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [LogoutRequest].
final class LogoutRequestCodec implements AcpCodec<LogoutRequest> {
  /// Creates the codec.
  const LogoutRequestCodec();

  @override
  LogoutRequest decode(Object? value) =>
      LogoutRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(LogoutRequest value) => value.toJson();
}

/// Shared codec for [LogoutRequest].
const LogoutRequestCodec logoutRequestCodec = LogoutRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to the `logout` method.
final class LogoutResponse implements AcpJsonEncodable {
  /// Creates a LogoutResponse value.
  LogoutResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory LogoutResponse.fromJson(Map<String, Object?> json) =>
      _$LogoutResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$LogoutResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [LogoutResponse].
final class LogoutResponseCodec implements AcpCodec<LogoutResponse> {
  /// Creates the codec.
  const LogoutResponseCodec();

  @override
  LogoutResponse decode(Object? value) =>
      LogoutResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(LogoutResponse value) => value.toJson();
}

/// Shared codec for [LogoutResponse].
const LogoutResponseCodec logoutResponseCodec = LogoutResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// MCP capabilities supported by the agent
final class McpCapabilities implements AcpJsonEncodable {
  /// Creates a McpCapabilities value.
  McpCapabilities({
    required this.http,
    required this.sse,
    required this.acp,
    this.meta,
  });

  /// Agent supports `McpServer::Http`.
  final bool http;

  /// Agent supports `McpServer::Sse`.
  final bool sse;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// Agent supports `McpServer::Acp`.
  final bool acp;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<McpCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = McpCapabilities(
      http: decoder.defaultOnError(
        'http',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      sse: decoder.defaultOnError(
        'sse',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      acp: decoder.defaultOnError(
        'acp',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory McpCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['http'] = http;
    result['sse'] = sse;
    result['acp'] = acp;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [McpCapabilities].
final class McpCapabilitiesCodec implements AcpCodec<McpCapabilities> {
  /// Creates the codec.
  const McpCapabilitiesCodec();

  @override
  McpCapabilities decode(Object? value) =>
      McpCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(McpCapabilities value) => value.toJson();
}

/// Shared codec for [McpCapabilities].
const McpCapabilitiesCodec mcpCapabilitiesCodec = McpCapabilitiesCodec();

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// A unique identifier for an active MCP-over-ACP connection.
final class McpConnectionId implements AcpJsonEncodable {
  /// Validates and creates a McpConnectionId value.
  factory McpConnectionId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return McpConnectionId._(value);
  }

  const McpConnectionId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory McpConnectionId.fromJson(Object? json) =>
      McpConnectionId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is McpConnectionId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [McpConnectionId].
final class McpConnectionIdCodec implements AcpCodec<McpConnectionId> {
  /// Creates the codec.
  const McpConnectionIdCodec();

  @override
  McpConnectionId decode(Object? value) => McpConnectionId.fromJson(value);

  @override
  String encode(McpConnectionId value) => value.toJson();
}

/// Shared codec for [McpConnectionId].
const McpConnectionIdCodec mcpConnectionIdCodec = McpConnectionIdCodec();

/// Configuration for connecting to an MCP (Model Context Protocol) server.
///
/// MCP servers provide tools and context that the agent can use when
/// processing prompts.
///
/// See protocol docs: [MCP Servers](https://agentclientprotocol.com/protocol/session-setup#mcp-servers)
sealed class McpServer implements AcpJsonEncodable {
  const McpServer();

  /// Decodes one concrete union member.
  factory McpServer.fromJson(Object? json) => mcpServerCodec.decode(json);

  /// Encodes the concrete union member.
  Object? toJson();

  @override
  AcpJsonValue toAcpJson() => AcpJsonValue.fromObject(toJson());
}

/// HTTP transport configuration
///
/// Only available when the Agent capabilities indicate `mcp_capabilities.http` is `true`.
final class McpServerMcpServerHttp extends McpServer {
  /// Creates this concrete union member.
  const McpServerMcpServerHttp(this.value);

  /// The typed union value.
  final McpServerHttp value;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    ...decodeAcpObject(mcpServerHttpCodec.encode(value)),
    'type': 'http',
  };
}

/// SSE transport configuration
///
/// Only available when the Agent capabilities indicate `mcp_capabilities.sse` is `true`.
final class McpServerMcpServerSse extends McpServer {
  /// Creates this concrete union member.
  const McpServerMcpServerSse(this.value);

  /// The typed union value.
  final McpServerSse value;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    ...decodeAcpObject(mcpServerSseCodec.encode(value)),
    'type': 'sse',
  };
}

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// ACP transport configuration
///
/// Only available when the Agent capabilities indicate `mcp_capabilities.acp` is `true`.
/// The MCP server is provided by an ACP component and communicates over the ACP channel.
final class McpServerMcpServerAcp extends McpServer {
  /// Creates this concrete union member.
  const McpServerMcpServerAcp(this.value);

  /// The typed union value.
  final McpServerAcp value;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    ...decodeAcpObject(mcpServerAcpCodec.encode(value)),
    'type': 'acp',
  };
}

/// Stdio transport configuration
///
/// All Agents MUST support this transport.
final class McpServerStdioVariant extends McpServer {
  /// Creates this concrete union member.
  const McpServerStdioVariant(this.value);

  /// The typed union value.
  final McpServerStdio value;

  @override
  Object? toJson() => mcpServerStdioCodec.encode(value);
}

/// Codec for [McpServer].
final class McpServerCodec implements AcpCodec<McpServer> {
  /// Creates the codec.
  const McpServerCodec();

  @override
  McpServer decode(Object? value) {
    if (value is Map<Object?, Object?>) {
      final payload = decodeAcpObject(value);
      if (payload['type'] == 'http') {
        return McpServerMcpServerHttp(mcpServerHttpCodec.decode(value));
      }
    }
    if (value is Map<Object?, Object?>) {
      final payload = decodeAcpObject(value);
      if (payload['type'] == 'sse') {
        return McpServerMcpServerSse(mcpServerSseCodec.decode(value));
      }
    }
    if (value is Map<Object?, Object?>) {
      final payload = decodeAcpObject(value);
      if (payload['type'] == 'acp') {
        return McpServerMcpServerAcp(mcpServerAcpCodec.decode(value));
      }
    }
    try {
      return McpServerStdioVariant(mcpServerStdioCodec.decode(value));
    } on Object {
      // Try the next structurally distinct member.
    }
    throw const FormatException('Value does not match McpServer');
  }

  @override
  Object? encode(McpServer value) => value.toJson();
}

/// Shared codec for [McpServer].
const McpServerCodec mcpServerCodec = McpServerCodec();

String _decodeMcpServerAcpName(Object? value) => decodeAcpString(value);
Object? _encodeMcpServerAcpName(String value) => value;

McpServerAcpId _decodeMcpServerAcpServerId(Object? value) =>
    mcpServerAcpIdCodec.decode(value);
Object? _encodeMcpServerAcpServerId(McpServerAcpId value) =>
    mcpServerAcpIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// ACP transport configuration for MCP.
///
/// The MCP server is provided by an ACP component and communicates over the ACP channel
/// using `mcp/connect`, `mcp/message`, and `mcp/disconnect`.
final class McpServerAcp implements AcpJsonEncodable {
  /// Creates a McpServerAcp value.
  McpServerAcp({required this.name, required this.serverId, this.meta});

  /// Human-readable name identifying this MCP server.
  @JsonKey(
    name: 'name',
    fromJson: _decodeMcpServerAcpName,
    toJson: _encodeMcpServerAcpName,
    includeIfNull: false,
    required: true,
  )
  final String name;

  /// Unique identifier for this MCP server, generated by the component providing it.
  ///
  /// Providers MUST NOT reuse an ID for multiple ACP-transport MCP servers that are visible
  /// on the same ACP connection.
  @JsonKey(
    name: 'serverId',
    fromJson: _decodeMcpServerAcpServerId,
    toJson: _encodeMcpServerAcpServerId,
    includeIfNull: false,
    required: true,
  )
  final McpServerAcpId serverId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory McpServerAcp.fromJson(Map<String, Object?> json) =>
      _$McpServerAcpFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$McpServerAcpToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [McpServerAcp].
final class McpServerAcpCodec implements AcpCodec<McpServerAcp> {
  /// Creates the codec.
  const McpServerAcpCodec();

  @override
  McpServerAcp decode(Object? value) =>
      McpServerAcp.fromJson(decodeAcpObject(value));

  @override
  Object encode(McpServerAcp value) => value.toJson();
}

/// Shared codec for [McpServerAcp].
const McpServerAcpCodec mcpServerAcpCodec = McpServerAcpCodec();

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Unique identifier for an MCP server using the ACP transport.
///
/// The value is opaque and generated by the ACP component providing the MCP server. It is
/// used by `mcp/connect` to route connection requests back to the component that declared the
final class McpServerAcpId implements AcpJsonEncodable {
  /// Validates and creates a McpServerAcpId value.
  factory McpServerAcpId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return McpServerAcpId._(value);
  }

  const McpServerAcpId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory McpServerAcpId.fromJson(Object? json) =>
      McpServerAcpId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is McpServerAcpId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [McpServerAcpId].
final class McpServerAcpIdCodec implements AcpCodec<McpServerAcpId> {
  /// Creates the codec.
  const McpServerAcpIdCodec();

  @override
  McpServerAcpId decode(Object? value) => McpServerAcpId.fromJson(value);

  @override
  String encode(McpServerAcpId value) => value.toJson();
}

/// Shared codec for [McpServerAcpId].
const McpServerAcpIdCodec mcpServerAcpIdCodec = McpServerAcpIdCodec();

String _decodeMcpServerHttpName(Object? value) => decodeAcpString(value);
Object? _encodeMcpServerHttpName(String value) => value;

String _decodeMcpServerHttpUrl(Object? value) => decodeAcpString(value);
Object? _encodeMcpServerHttpUrl(String value) => value;

List<HttpHeader> _decodeMcpServerHttpHeaders(Object? value) =>
    List<HttpHeader>.unmodifiable(
      (value as List<Object?>).map((item) => httpHeaderCodec.decode(item)),
    );
Object? _encodeMcpServerHttpHeaders(List<HttpHeader> value) => <Object?>[
  for (final item in value) httpHeaderCodec.encode(item),
];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// HTTP transport configuration for MCP.
final class McpServerHttp implements AcpJsonEncodable {
  /// Creates a McpServerHttp value.
  McpServerHttp({
    required this.name,
    required this.url,
    required List<HttpHeader> headers,
    this.meta,
  }) : headers = List<HttpHeader>.unmodifiable(headers);

  /// Human-readable name identifying this MCP server.
  @JsonKey(
    name: 'name',
    fromJson: _decodeMcpServerHttpName,
    toJson: _encodeMcpServerHttpName,
    includeIfNull: false,
    required: true,
  )
  final String name;

  /// URL to the MCP server.
  @JsonKey(
    name: 'url',
    fromJson: _decodeMcpServerHttpUrl,
    toJson: _encodeMcpServerHttpUrl,
    includeIfNull: false,
    required: true,
  )
  final String url;

  /// HTTP headers to set when making requests to the MCP server.
  @JsonKey(
    name: 'headers',
    fromJson: _decodeMcpServerHttpHeaders,
    toJson: _encodeMcpServerHttpHeaders,
    includeIfNull: false,
    required: true,
  )
  final List<HttpHeader> headers;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory McpServerHttp.fromJson(Map<String, Object?> json) =>
      _$McpServerHttpFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$McpServerHttpToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [McpServerHttp].
final class McpServerHttpCodec implements AcpCodec<McpServerHttp> {
  /// Creates the codec.
  const McpServerHttpCodec();

  @override
  McpServerHttp decode(Object? value) =>
      McpServerHttp.fromJson(decodeAcpObject(value));

  @override
  Object encode(McpServerHttp value) => value.toJson();
}

/// Shared codec for [McpServerHttp].
const McpServerHttpCodec mcpServerHttpCodec = McpServerHttpCodec();

String _decodeMcpServerSseName(Object? value) => decodeAcpString(value);
Object? _encodeMcpServerSseName(String value) => value;

String _decodeMcpServerSseUrl(Object? value) => decodeAcpString(value);
Object? _encodeMcpServerSseUrl(String value) => value;

List<HttpHeader> _decodeMcpServerSseHeaders(Object? value) =>
    List<HttpHeader>.unmodifiable(
      (value as List<Object?>).map((item) => httpHeaderCodec.decode(item)),
    );
Object? _encodeMcpServerSseHeaders(List<HttpHeader> value) => <Object?>[
  for (final item in value) httpHeaderCodec.encode(item),
];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// SSE transport configuration for MCP.
final class McpServerSse implements AcpJsonEncodable {
  /// Creates a McpServerSse value.
  McpServerSse({
    required this.name,
    required this.url,
    required List<HttpHeader> headers,
    this.meta,
  }) : headers = List<HttpHeader>.unmodifiable(headers);

  /// Human-readable name identifying this MCP server.
  @JsonKey(
    name: 'name',
    fromJson: _decodeMcpServerSseName,
    toJson: _encodeMcpServerSseName,
    includeIfNull: false,
    required: true,
  )
  final String name;

  /// URL to the MCP server.
  @JsonKey(
    name: 'url',
    fromJson: _decodeMcpServerSseUrl,
    toJson: _encodeMcpServerSseUrl,
    includeIfNull: false,
    required: true,
  )
  final String url;

  /// HTTP headers to set when making requests to the MCP server.
  @JsonKey(
    name: 'headers',
    fromJson: _decodeMcpServerSseHeaders,
    toJson: _encodeMcpServerSseHeaders,
    includeIfNull: false,
    required: true,
  )
  final List<HttpHeader> headers;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory McpServerSse.fromJson(Map<String, Object?> json) =>
      _$McpServerSseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$McpServerSseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [McpServerSse].
final class McpServerSseCodec implements AcpCodec<McpServerSse> {
  /// Creates the codec.
  const McpServerSseCodec();

  @override
  McpServerSse decode(Object? value) =>
      McpServerSse.fromJson(decodeAcpObject(value));

  @override
  Object encode(McpServerSse value) => value.toJson();
}

/// Shared codec for [McpServerSse].
const McpServerSseCodec mcpServerSseCodec = McpServerSseCodec();

String _decodeMcpServerStdioName(Object? value) => decodeAcpString(value);
Object? _encodeMcpServerStdioName(String value) => value;

String _decodeMcpServerStdioCommand(Object? value) => decodeAcpString(value);
Object? _encodeMcpServerStdioCommand(String value) => value;

List<String> _decodeMcpServerStdioArgs(Object? value) =>
    List<String>.unmodifiable(
      (value as List<Object?>).map((item) => decodeAcpString(item)),
    );
Object? _encodeMcpServerStdioArgs(List<String> value) => <Object?>[
  for (final item in value) item,
];

List<EnvVariable> _decodeMcpServerStdioEnv(Object? value) =>
    List<EnvVariable>.unmodifiable(
      (value as List<Object?>).map((item) => envVariableCodec.decode(item)),
    );
Object? _encodeMcpServerStdioEnv(List<EnvVariable> value) => <Object?>[
  for (final item in value) envVariableCodec.encode(item),
];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Stdio transport configuration for MCP.
final class McpServerStdio implements AcpJsonEncodable {
  /// Creates a McpServerStdio value.
  McpServerStdio({
    required this.name,
    required this.command,
    required List<String> args,
    required List<EnvVariable> env,
    this.meta,
  }) : args = List<String>.unmodifiable(args),
       env = List<EnvVariable>.unmodifiable(env);

  /// Human-readable name identifying this MCP server.
  @JsonKey(
    name: 'name',
    fromJson: _decodeMcpServerStdioName,
    toJson: _encodeMcpServerStdioName,
    includeIfNull: false,
    required: true,
  )
  final String name;

  /// Absolute path to the MCP server executable.
  @JsonKey(
    name: 'command',
    fromJson: _decodeMcpServerStdioCommand,
    toJson: _encodeMcpServerStdioCommand,
    includeIfNull: false,
    required: true,
  )
  final String command;

  /// Command-line arguments to pass to the MCP server.
  @JsonKey(
    name: 'args',
    fromJson: _decodeMcpServerStdioArgs,
    toJson: _encodeMcpServerStdioArgs,
    includeIfNull: false,
    required: true,
  )
  final List<String> args;

  /// Environment variables to set when launching the MCP server.
  @JsonKey(
    name: 'env',
    fromJson: _decodeMcpServerStdioEnv,
    toJson: _encodeMcpServerStdioEnv,
    includeIfNull: false,
    required: true,
  )
  final List<EnvVariable> env;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory McpServerStdio.fromJson(Map<String, Object?> json) =>
      _$McpServerStdioFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$McpServerStdioToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [McpServerStdio].
final class McpServerStdioCodec implements AcpCodec<McpServerStdio> {
  /// Creates the codec.
  const McpServerStdioCodec();

  @override
  McpServerStdio decode(Object? value) =>
      McpServerStdio.fromJson(decodeAcpObject(value));

  @override
  Object encode(McpServerStdio value) => value.toJson();
}

/// Shared codec for [McpServerStdio].
const McpServerStdioCodec mcpServerStdioCodec = McpServerStdioCodec();

/// Unique identifier for a message within a session.
final class MessageId implements AcpJsonEncodable {
  /// Validates and creates a MessageId value.
  factory MessageId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return MessageId._(value);
  }

  const MessageId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory MessageId.fromJson(Object? json) => MessageId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is MessageId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [MessageId].
final class MessageIdCodec implements AcpCodec<MessageId> {
  /// Creates the codec.
  const MessageIdCodec();

  @override
  MessageId decode(Object? value) => MessageId.fromJson(value);

  @override
  String encode(MessageId value) => value.toJson();
}

/// Shared codec for [MessageId].
const MessageIdCodec messageIdCodec = MessageIdCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Notification parameters for `mcp/message`.
///
/// This is used when the wrapped MCP message is a notification and the outer JSON-RPC
/// envelope has no `id`.
final class MessageMcpNotification implements AcpJsonEncodable {
  /// Creates a MessageMcpNotification value.
  MessageMcpNotification({
    required this.connectionId,
    required this.method,
    this.params,
    this.meta,
  });

  /// The MCP-over-ACP connection this message is sent on.
  final McpConnectionId connectionId;

  /// The inner MCP method name.
  final String method;

  /// Optional inner MCP params.
  ///
  /// If omitted or set to `null`, the inner MCP message has no params.
  final AcpJsonObject? params;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<MessageMcpNotification> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = MessageMcpNotification(
      connectionId: decoder.required(
        'connectionId',
        (value) => mcpConnectionIdCodec.decode(value),
      ),
      method: decoder.required('method', (value) => decodeAcpString(value)),
      params: decoder
          .optionalOnError('params', (value) => AcpJsonObject.fromObject(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory MessageMcpNotification.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['connectionId'] = mcpConnectionIdCodec.encode(connectionId);
    result['method'] = method;
    if (params != null) {
      result['params'] = params!.toObject();
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [MessageMcpNotification].
final class MessageMcpNotificationCodec
    implements AcpCodec<MessageMcpNotification> {
  /// Creates the codec.
  const MessageMcpNotificationCodec();

  @override
  MessageMcpNotification decode(Object? value) =>
      MessageMcpNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(MessageMcpNotification value) => value.toJson();
}

/// Shared codec for [MessageMcpNotification].
const MessageMcpNotificationCodec messageMcpNotificationCodec =
    MessageMcpNotificationCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `mcp/message`.
final class MessageMcpRequest implements AcpJsonEncodable {
  /// Creates a MessageMcpRequest value.
  MessageMcpRequest({
    required this.connectionId,
    required this.method,
    this.params,
    this.meta,
  });

  /// The MCP-over-ACP connection this message is sent on.
  final McpConnectionId connectionId;

  /// The inner MCP method name.
  final String method;

  /// Optional inner MCP params.
  ///
  /// If omitted or set to `null`, the inner MCP message has no params.
  final AcpJsonObject? params;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<MessageMcpRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = MessageMcpRequest(
      connectionId: decoder.required(
        'connectionId',
        (value) => mcpConnectionIdCodec.decode(value),
      ),
      method: decoder.required('method', (value) => decodeAcpString(value)),
      params: decoder.optional(
        'params',
        (value) => AcpJsonObject.fromObject(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory MessageMcpRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['connectionId'] = mcpConnectionIdCodec.encode(connectionId);
    result['method'] = method;
    if (params != null) {
      result['params'] = params!.toObject();
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [MessageMcpRequest].
final class MessageMcpRequestCodec implements AcpCodec<MessageMcpRequest> {
  /// Creates the codec.
  const MessageMcpRequestCodec();

  @override
  MessageMcpRequest decode(Object? value) =>
      MessageMcpRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(MessageMcpRequest value) => value.toJson();
}

/// Shared codec for [MessageMcpRequest].
const MessageMcpRequestCodec messageMcpRequestCodec = MessageMcpRequestCodec();

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Response to `mcp/message`.
///
/// This is the inner MCP response result payload. Any JSON value is valid.
final class MessageMcpResponse implements AcpJsonEncodable {
  /// Creates a raw-preserving schema union value.
  MessageMcpResponse(AcpJsonValue value) : value = value;

  /// The immutable union payload.
  final AcpJsonValue value;

  /// Decodes a union payload.
  factory MessageMcpResponse.fromJson(Object? json) =>
      MessageMcpResponse(AcpJsonValue.fromObject(json));

  /// Encodes the union payload.
  Object? toJson() => value.toObject();

  @override
  AcpJsonValue toAcpJson() => value;
}

/// Codec for [MessageMcpResponse].
final class MessageMcpResponseCodec implements AcpCodec<MessageMcpResponse> {
  /// Creates the codec.
  const MessageMcpResponseCodec();

  @override
  MessageMcpResponse decode(Object? value) =>
      MessageMcpResponse.fromJson(value);

  @override
  Object? encode(MessageMcpResponse value) => value.toJson();
}

/// Shared codec for [MessageMcpResponse].
const MessageMcpResponseCodec messageMcpResponseCodec =
    MessageMcpResponseCodec();

/// Items for a multi-select (array) property schema.
sealed class MultiSelectItems implements AcpJsonEncodable {
  const MultiSelectItems();

  /// Decodes one concrete union member.
  factory MultiSelectItems.fromJson(Object? json) =>
      multiSelectItemsCodec.decode(json);

  /// Encodes the concrete union member.
  Object? toJson();

  @override
  AcpJsonValue toAcpJson() => AcpJsonValue.fromObject(toJson());
}

/// Multi-select string items with plain string values.
final class MultiSelectItemsStringMultiSelectItems extends MultiSelectItems {
  /// Creates this concrete union member.
  const MultiSelectItemsStringMultiSelectItems(this.value);

  /// The typed union value.
  final StringMultiSelectItems value;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    ...decodeAcpObject(stringMultiSelectItemsCodec.encode(value)),
    'type': 'string',
  };
}

/// Custom or future typed multi-select items.
final class MultiSelectItemsOther extends MultiSelectItems {
  /// Creates this concrete union member.
  MultiSelectItemsOther(AcpJsonObject value)
    : value = value.without('__proto__');

  /// The typed union value.
  final AcpJsonObject value;

  @override
  Object? toJson() => value.toObject();
}

/// Titled multi-select items with human-readable labels.
final class MultiSelectItemsTitled extends MultiSelectItems {
  /// Creates this concrete union member.
  const MultiSelectItemsTitled(this.value);

  /// The typed union value.
  final TitledMultiSelectItems value;

  @override
  Object? toJson() => titledMultiSelectItemsCodec.encode(value);
}

/// Codec for [MultiSelectItems].
final class MultiSelectItemsCodec implements AcpCodec<MultiSelectItems> {
  /// Creates the codec.
  const MultiSelectItemsCodec();

  @override
  MultiSelectItems decode(Object? value) {
    if (value is Map<Object?, Object?>) {
      final payload = decodeAcpObject(value);
      if (payload['type'] == 'string') {
        return MultiSelectItemsStringMultiSelectItems(
          stringMultiSelectItemsCodec.decode(value),
        );
      }
    }
    try {
      return MultiSelectItemsTitled(titledMultiSelectItemsCodec.decode(value));
    } on Object {
      // Try the next structurally distinct member.
    }
    if (value is Map<Object?, Object?>) {
      return MultiSelectItemsOther(AcpJsonObject.fromObject(value));
    }
    throw const FormatException('Value does not match MultiSelectItems');
  }

  @override
  Object? encode(MultiSelectItems value) => value.toJson();
}

/// Shared codec for [MultiSelectItems].
const MultiSelectItemsCodec multiSelectItemsCodec = MultiSelectItemsCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Schema for multi-select (array) properties in an elicitation form.
final class MultiSelectPropertySchema implements AcpJsonEncodable {
  /// Creates a MultiSelectPropertySchema value.
  MultiSelectPropertySchema({
    required this.items,
    this.title,
    this.description,
    this.minItems,
    this.maxItems,
    List<String>? defaultValue,
    this.meta,
  }) : defaultValue = defaultValue == null
           ? null
           : List<String>.unmodifiable(defaultValue);

  /// Optional title for the property.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no title is provided.
  final String? title;

  /// Human-readable description.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no description is provided.
  final String? description;

  /// Minimum number of items to select.
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no minimum selection count.
  final AcpUint64? minItems;

  /// Maximum number of items to select.
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no maximum selection count.
  final AcpUint64? maxItems;

  /// The items definition describing allowed values.
  final MultiSelectItems items;

  /// Default selected values.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no default selections are provided.
  final List<String>? defaultValue;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<MultiSelectPropertySchema> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = MultiSelectPropertySchema(
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      minItems: decoder.optional('minItems', (value) => decodeAcpUint64(value)),
      maxItems: decoder.optional('maxItems', (value) => decodeAcpUint64(value)),
      items: decoder.required(
        'items',
        (value) => multiSelectItemsCodec.decode(value),
      ),
      defaultValue: decoder.listSkippingInvalid(
        'default',
        (value) => decodeAcpString(value),
        isRequired: false,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory MultiSelectPropertySchema.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (title != null) {
      result['title'] = title!;
    }
    if (description != null) {
      result['description'] = description!;
    }
    if (minItems != null) {
      result['minItems'] = encodeAcpUint64(minItems!);
    }
    if (maxItems != null) {
      result['maxItems'] = encodeAcpUint64(maxItems!);
    }
    result['items'] = multiSelectItemsCodec.encode(items);
    if (defaultValue != null) {
      result['default'] = <Object?>[for (final item in defaultValue!) item];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [MultiSelectPropertySchema].
final class MultiSelectPropertySchemaCodec
    implements AcpCodec<MultiSelectPropertySchema> {
  /// Creates the codec.
  const MultiSelectPropertySchemaCodec();

  @override
  MultiSelectPropertySchema decode(Object? value) =>
      MultiSelectPropertySchema.fromJson(decodeAcpObject(value));

  @override
  Object encode(MultiSelectPropertySchema value) => value.toJson();
}

/// Shared codec for [MultiSelectPropertySchema].
const MultiSelectPropertySchemaCodec multiSelectPropertySchemaCodec =
    MultiSelectPropertySchemaCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// NES capabilities advertised by the agent during initialization.
final class NesCapabilities implements AcpJsonEncodable {
  /// Creates a NesCapabilities value.
  NesCapabilities({this.events, this.context, this.meta});

  /// Events the agent wants to receive.
  final NesEventCapabilities? events;

  /// Context the agent wants attached to each suggestion request.
  final NesContextCapabilities? context;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesCapabilities(
      events: decoder
          .optionalOnError(
            'events',
            (value) => nesEventCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      context: decoder
          .optionalOnError(
            'context',
            (value) => nesContextCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (events != null) {
      result['events'] = nesEventCapabilitiesCodec.encode(events!);
    }
    if (context != null) {
      result['context'] = nesContextCapabilitiesCodec.encode(context!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesCapabilities].
final class NesCapabilitiesCodec implements AcpCodec<NesCapabilities> {
  /// Creates the codec.
  const NesCapabilitiesCodec();

  @override
  NesCapabilities decode(Object? value) =>
      NesCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesCapabilities value) => value.toJson();
}

/// Shared codec for [NesCapabilities].
const NesCapabilitiesCodec nesCapabilitiesCodec = NesCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Context capabilities the agent wants attached to each suggestion request.
final class NesContextCapabilities implements AcpJsonEncodable {
  /// Creates a NesContextCapabilities value.
  NesContextCapabilities({
    this.recentFiles,
    this.relatedSnippets,
    this.editHistory,
    this.userActions,
    this.openFiles,
    this.diagnostics,
    this.meta,
  });

  /// Whether the agent wants recent files context.
  final NesRecentFilesCapabilities? recentFiles;

  /// Whether the agent wants related snippets context.
  final NesRelatedSnippetsCapabilities? relatedSnippets;

  /// Whether the agent wants edit history context.
  final NesEditHistoryCapabilities? editHistory;

  /// Whether the agent wants user actions context.
  final NesUserActionsCapabilities? userActions;

  /// Whether the agent wants open files context.
  final NesOpenFilesCapabilities? openFiles;

  /// Whether the agent wants diagnostics context.
  final NesDiagnosticsCapabilities? diagnostics;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesContextCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesContextCapabilities(
      recentFiles: decoder
          .optionalOnError(
            'recentFiles',
            (value) => nesRecentFilesCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      relatedSnippets: decoder
          .optionalOnError(
            'relatedSnippets',
            (value) => nesRelatedSnippetsCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      editHistory: decoder
          .optionalOnError(
            'editHistory',
            (value) => nesEditHistoryCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      userActions: decoder
          .optionalOnError(
            'userActions',
            (value) => nesUserActionsCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      openFiles: decoder
          .optionalOnError(
            'openFiles',
            (value) => nesOpenFilesCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      diagnostics: decoder
          .optionalOnError(
            'diagnostics',
            (value) => nesDiagnosticsCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesContextCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (recentFiles != null) {
      result['recentFiles'] = nesRecentFilesCapabilitiesCodec.encode(
        recentFiles!,
      );
    }
    if (relatedSnippets != null) {
      result['relatedSnippets'] = nesRelatedSnippetsCapabilitiesCodec.encode(
        relatedSnippets!,
      );
    }
    if (editHistory != null) {
      result['editHistory'] = nesEditHistoryCapabilitiesCodec.encode(
        editHistory!,
      );
    }
    if (userActions != null) {
      result['userActions'] = nesUserActionsCapabilitiesCodec.encode(
        userActions!,
      );
    }
    if (openFiles != null) {
      result['openFiles'] = nesOpenFilesCapabilitiesCodec.encode(openFiles!);
    }
    if (diagnostics != null) {
      result['diagnostics'] = nesDiagnosticsCapabilitiesCodec.encode(
        diagnostics!,
      );
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesContextCapabilities].
final class NesContextCapabilitiesCodec
    implements AcpCodec<NesContextCapabilities> {
  /// Creates the codec.
  const NesContextCapabilitiesCodec();

  @override
  NesContextCapabilities decode(Object? value) =>
      NesContextCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesContextCapabilities value) => value.toJson();
}

/// Shared codec for [NesContextCapabilities].
const NesContextCapabilitiesCodec nesContextCapabilitiesCodec =
    NesContextCapabilitiesCodec();

String _decodeNesDiagnosticUri(Object? value) => decodeAcpString(value);
Object? _encodeNesDiagnosticUri(String value) => value;

Range _decodeNesDiagnosticRange(Object? value) => rangeCodec.decode(value);
Object? _encodeNesDiagnosticRange(Range value) => rangeCodec.encode(value);

NesDiagnosticSeverity _decodeNesDiagnosticSeverity(Object? value) =>
    nesDiagnosticSeverityCodec.decode(value);
Object? _encodeNesDiagnosticSeverity(NesDiagnosticSeverity value) =>
    nesDiagnosticSeverityCodec.encode(value);

String _decodeNesDiagnosticMessage(Object? value) => decodeAcpString(value);
Object? _encodeNesDiagnosticMessage(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A diagnostic (error, warning, etc.).
final class NesDiagnostic implements AcpJsonEncodable {
  /// Creates a NesDiagnostic value.
  NesDiagnostic({
    required this.uri,
    required this.range,
    required this.severity,
    required this.message,
    this.meta,
  });

  /// The URI of the file containing the diagnostic.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeNesDiagnosticUri,
    toJson: _encodeNesDiagnosticUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The range of the diagnostic.
  @JsonKey(
    name: 'range',
    fromJson: _decodeNesDiagnosticRange,
    toJson: _encodeNesDiagnosticRange,
    includeIfNull: false,
    required: true,
  )
  final Range range;

  /// The severity of the diagnostic.
  @JsonKey(
    name: 'severity',
    fromJson: _decodeNesDiagnosticSeverity,
    toJson: _encodeNesDiagnosticSeverity,
    includeIfNull: false,
    required: true,
  )
  final NesDiagnosticSeverity severity;

  /// The diagnostic message.
  @JsonKey(
    name: 'message',
    fromJson: _decodeNesDiagnosticMessage,
    toJson: _encodeNesDiagnosticMessage,
    includeIfNull: false,
    required: true,
  )
  final String message;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesDiagnostic.fromJson(Map<String, Object?> json) =>
      _$NesDiagnosticFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesDiagnosticToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesDiagnostic].
final class NesDiagnosticCodec implements AcpCodec<NesDiagnostic> {
  /// Creates the codec.
  const NesDiagnosticCodec();

  @override
  NesDiagnostic decode(Object? value) =>
      NesDiagnostic.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesDiagnostic value) => value.toJson();
}

/// Shared codec for [NesDiagnostic].
const NesDiagnosticCodec nesDiagnosticCodec = NesDiagnosticCodec();

/// Severity of a diagnostic.
final class NesDiagnosticSeverity implements AcpJsonEncodable {
  /// Validates and creates a NesDiagnosticSeverity value.
  factory NesDiagnosticSeverity(String value) {
    if (!const <String>{
      'error',
      'warning',
      'information',
      'hint',
    }.contains(value)) {
      throw FormatException('Unknown NesDiagnosticSeverity: $value');
    }
    return NesDiagnosticSeverity._(value);
  }

  const NesDiagnosticSeverity._(this.value);

  /// The exact wire string.
  final String value;

  /// The `error` schema value.
  static const NesDiagnosticSeverity error = NesDiagnosticSeverity._('error');

  /// The `warning` schema value.
  static const NesDiagnosticSeverity warning = NesDiagnosticSeverity._(
    'warning',
  );

  /// The `information` schema value.
  static const NesDiagnosticSeverity information = NesDiagnosticSeverity._(
    'information',
  );

  /// The `hint` schema value.
  static const NesDiagnosticSeverity hint = NesDiagnosticSeverity._('hint');

  /// Decodes a wire string.
  factory NesDiagnosticSeverity.fromJson(Object? json) =>
      NesDiagnosticSeverity(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is NesDiagnosticSeverity && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [NesDiagnosticSeverity].
final class NesDiagnosticSeverityCodec
    implements AcpCodec<NesDiagnosticSeverity> {
  /// Creates the codec.
  const NesDiagnosticSeverityCodec();

  @override
  NesDiagnosticSeverity decode(Object? value) =>
      NesDiagnosticSeverity.fromJson(value);

  @override
  String encode(NesDiagnosticSeverity value) => value.toJson();
}

/// Shared codec for [NesDiagnosticSeverity].
const NesDiagnosticSeverityCodec nesDiagnosticSeverityCodec =
    NesDiagnosticSeverityCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for diagnostics context.
final class NesDiagnosticsCapabilities implements AcpJsonEncodable {
  /// Creates a NesDiagnosticsCapabilities value.
  NesDiagnosticsCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesDiagnosticsCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesDiagnosticsCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesDiagnosticsCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesDiagnosticsCapabilities].
final class NesDiagnosticsCapabilitiesCodec
    implements AcpCodec<NesDiagnosticsCapabilities> {
  /// Creates the codec.
  const NesDiagnosticsCapabilitiesCodec();

  @override
  NesDiagnosticsCapabilities decode(Object? value) =>
      NesDiagnosticsCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesDiagnosticsCapabilities value) => value.toJson();
}

/// Shared codec for [NesDiagnosticsCapabilities].
const NesDiagnosticsCapabilitiesCodec nesDiagnosticsCapabilitiesCodec =
    NesDiagnosticsCapabilitiesCodec();

TextDocumentSyncKind _decodeNesDocumentDidChangeCapabilitiesSyncKind(
  Object? value,
) => textDocumentSyncKindCodec.decode(value);
Object? _encodeNesDocumentDidChangeCapabilitiesSyncKind(
  TextDocumentSyncKind value,
) => textDocumentSyncKindCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for `document/didChange` events.
final class NesDocumentDidChangeCapabilities implements AcpJsonEncodable {
  /// Creates a NesDocumentDidChangeCapabilities value.
  NesDocumentDidChangeCapabilities({required this.syncKind, this.meta});

  /// The sync kind the agent wants: `"full"` or `"incremental"`.
  @JsonKey(
    name: 'syncKind',
    fromJson: _decodeNesDocumentDidChangeCapabilitiesSyncKind,
    toJson: _encodeNesDocumentDidChangeCapabilitiesSyncKind,
    includeIfNull: false,
    required: true,
  )
  final TextDocumentSyncKind syncKind;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesDocumentDidChangeCapabilities.fromJson(
    Map<String, Object?> json,
  ) => _$NesDocumentDidChangeCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() =>
      _$NesDocumentDidChangeCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesDocumentDidChangeCapabilities].
final class NesDocumentDidChangeCapabilitiesCodec
    implements AcpCodec<NesDocumentDidChangeCapabilities> {
  /// Creates the codec.
  const NesDocumentDidChangeCapabilitiesCodec();

  @override
  NesDocumentDidChangeCapabilities decode(Object? value) =>
      NesDocumentDidChangeCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesDocumentDidChangeCapabilities value) => value.toJson();
}

/// Shared codec for [NesDocumentDidChangeCapabilities].
const NesDocumentDidChangeCapabilitiesCodec
nesDocumentDidChangeCapabilitiesCodec = NesDocumentDidChangeCapabilitiesCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Marker for `document/didClose` capability support.
final class NesDocumentDidCloseCapabilities implements AcpJsonEncodable {
  /// Creates a NesDocumentDidCloseCapabilities value.
  NesDocumentDidCloseCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesDocumentDidCloseCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesDocumentDidCloseCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() =>
      _$NesDocumentDidCloseCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesDocumentDidCloseCapabilities].
final class NesDocumentDidCloseCapabilitiesCodec
    implements AcpCodec<NesDocumentDidCloseCapabilities> {
  /// Creates the codec.
  const NesDocumentDidCloseCapabilitiesCodec();

  @override
  NesDocumentDidCloseCapabilities decode(Object? value) =>
      NesDocumentDidCloseCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesDocumentDidCloseCapabilities value) => value.toJson();
}

/// Shared codec for [NesDocumentDidCloseCapabilities].
const NesDocumentDidCloseCapabilitiesCodec
nesDocumentDidCloseCapabilitiesCodec = NesDocumentDidCloseCapabilitiesCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Marker for `document/didFocus` capability support.
final class NesDocumentDidFocusCapabilities implements AcpJsonEncodable {
  /// Creates a NesDocumentDidFocusCapabilities value.
  NesDocumentDidFocusCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesDocumentDidFocusCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesDocumentDidFocusCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() =>
      _$NesDocumentDidFocusCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesDocumentDidFocusCapabilities].
final class NesDocumentDidFocusCapabilitiesCodec
    implements AcpCodec<NesDocumentDidFocusCapabilities> {
  /// Creates the codec.
  const NesDocumentDidFocusCapabilitiesCodec();

  @override
  NesDocumentDidFocusCapabilities decode(Object? value) =>
      NesDocumentDidFocusCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesDocumentDidFocusCapabilities value) => value.toJson();
}

/// Shared codec for [NesDocumentDidFocusCapabilities].
const NesDocumentDidFocusCapabilitiesCodec
nesDocumentDidFocusCapabilitiesCodec = NesDocumentDidFocusCapabilitiesCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Marker for `document/didOpen` capability support.
final class NesDocumentDidOpenCapabilities implements AcpJsonEncodable {
  /// Creates a NesDocumentDidOpenCapabilities value.
  NesDocumentDidOpenCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesDocumentDidOpenCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesDocumentDidOpenCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesDocumentDidOpenCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesDocumentDidOpenCapabilities].
final class NesDocumentDidOpenCapabilitiesCodec
    implements AcpCodec<NesDocumentDidOpenCapabilities> {
  /// Creates the codec.
  const NesDocumentDidOpenCapabilitiesCodec();

  @override
  NesDocumentDidOpenCapabilities decode(Object? value) =>
      NesDocumentDidOpenCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesDocumentDidOpenCapabilities value) => value.toJson();
}

/// Shared codec for [NesDocumentDidOpenCapabilities].
const NesDocumentDidOpenCapabilitiesCodec nesDocumentDidOpenCapabilitiesCodec =
    NesDocumentDidOpenCapabilitiesCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Marker for `document/didSave` capability support.
final class NesDocumentDidSaveCapabilities implements AcpJsonEncodable {
  /// Creates a NesDocumentDidSaveCapabilities value.
  NesDocumentDidSaveCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesDocumentDidSaveCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesDocumentDidSaveCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesDocumentDidSaveCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesDocumentDidSaveCapabilities].
final class NesDocumentDidSaveCapabilitiesCodec
    implements AcpCodec<NesDocumentDidSaveCapabilities> {
  /// Creates the codec.
  const NesDocumentDidSaveCapabilitiesCodec();

  @override
  NesDocumentDidSaveCapabilities decode(Object? value) =>
      NesDocumentDidSaveCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesDocumentDidSaveCapabilities value) => value.toJson();
}

/// Shared codec for [NesDocumentDidSaveCapabilities].
const NesDocumentDidSaveCapabilitiesCodec nesDocumentDidSaveCapabilitiesCodec =
    NesDocumentDidSaveCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Document event capabilities the agent wants to receive.
final class NesDocumentEventCapabilities implements AcpJsonEncodable {
  /// Creates a NesDocumentEventCapabilities value.
  NesDocumentEventCapabilities({
    this.didOpen,
    this.didChange,
    this.didClose,
    this.didSave,
    this.didFocus,
    this.meta,
  });

  /// Whether the agent wants `document/didOpen` events.
  final NesDocumentDidOpenCapabilities? didOpen;

  /// Whether the agent wants `document/didChange` events, and the sync kind.
  final NesDocumentDidChangeCapabilities? didChange;

  /// Whether the agent wants `document/didClose` events.
  final NesDocumentDidCloseCapabilities? didClose;

  /// Whether the agent wants `document/didSave` events.
  final NesDocumentDidSaveCapabilities? didSave;

  /// Whether the agent wants `document/didFocus` events.
  final NesDocumentDidFocusCapabilities? didFocus;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesDocumentEventCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesDocumentEventCapabilities(
      didOpen: decoder
          .optionalOnError(
            'didOpen',
            (value) => nesDocumentDidOpenCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      didChange: decoder
          .optionalOnError(
            'didChange',
            (value) => nesDocumentDidChangeCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      didClose: decoder
          .optionalOnError(
            'didClose',
            (value) => nesDocumentDidCloseCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      didSave: decoder
          .optionalOnError(
            'didSave',
            (value) => nesDocumentDidSaveCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      didFocus: decoder
          .optionalOnError(
            'didFocus',
            (value) => nesDocumentDidFocusCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesDocumentEventCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (didOpen != null) {
      result['didOpen'] = nesDocumentDidOpenCapabilitiesCodec.encode(didOpen!);
    }
    if (didChange != null) {
      result['didChange'] = nesDocumentDidChangeCapabilitiesCodec.encode(
        didChange!,
      );
    }
    if (didClose != null) {
      result['didClose'] = nesDocumentDidCloseCapabilitiesCodec.encode(
        didClose!,
      );
    }
    if (didSave != null) {
      result['didSave'] = nesDocumentDidSaveCapabilitiesCodec.encode(didSave!);
    }
    if (didFocus != null) {
      result['didFocus'] = nesDocumentDidFocusCapabilitiesCodec.encode(
        didFocus!,
      );
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesDocumentEventCapabilities].
final class NesDocumentEventCapabilitiesCodec
    implements AcpCodec<NesDocumentEventCapabilities> {
  /// Creates the codec.
  const NesDocumentEventCapabilitiesCodec();

  @override
  NesDocumentEventCapabilities decode(Object? value) =>
      NesDocumentEventCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesDocumentEventCapabilities value) => value.toJson();
}

/// Shared codec for [NesDocumentEventCapabilities].
const NesDocumentEventCapabilitiesCodec nesDocumentEventCapabilitiesCodec =
    NesDocumentEventCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Capabilities for edit history context.
final class NesEditHistoryCapabilities implements AcpJsonEncodable {
  /// Creates a NesEditHistoryCapabilities value.
  NesEditHistoryCapabilities({this.maxCount, this.meta});

  /// Maximum number of edit history entries the agent can use.
  final int? maxCount;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesEditHistoryCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesEditHistoryCapabilities(
      maxCount: decoder
          .optionalOnError(
            'maxCount',
            (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesEditHistoryCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (maxCount != null) {
      result['maxCount'] = maxCount!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesEditHistoryCapabilities].
final class NesEditHistoryCapabilitiesCodec
    implements AcpCodec<NesEditHistoryCapabilities> {
  /// Creates the codec.
  const NesEditHistoryCapabilitiesCodec();

  @override
  NesEditHistoryCapabilities decode(Object? value) =>
      NesEditHistoryCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesEditHistoryCapabilities value) => value.toJson();
}

/// Shared codec for [NesEditHistoryCapabilities].
const NesEditHistoryCapabilitiesCodec nesEditHistoryCapabilitiesCodec =
    NesEditHistoryCapabilitiesCodec();

String _decodeNesEditHistoryEntryUri(Object? value) => decodeAcpString(value);
Object? _encodeNesEditHistoryEntryUri(String value) => value;

String _decodeNesEditHistoryEntryDiff(Object? value) => decodeAcpString(value);
Object? _encodeNesEditHistoryEntryDiff(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// An entry in the edit history.
final class NesEditHistoryEntry implements AcpJsonEncodable {
  /// Creates a NesEditHistoryEntry value.
  NesEditHistoryEntry({required this.uri, required this.diff, this.meta});

  /// The URI of the edited file.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeNesEditHistoryEntryUri,
    toJson: _encodeNesEditHistoryEntryUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// A diff representing the edit.
  @JsonKey(
    name: 'diff',
    fromJson: _decodeNesEditHistoryEntryDiff,
    toJson: _encodeNesEditHistoryEntryDiff,
    includeIfNull: false,
    required: true,
  )
  final String diff;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesEditHistoryEntry.fromJson(Map<String, Object?> json) =>
      _$NesEditHistoryEntryFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesEditHistoryEntryToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesEditHistoryEntry].
final class NesEditHistoryEntryCodec implements AcpCodec<NesEditHistoryEntry> {
  /// Creates the codec.
  const NesEditHistoryEntryCodec();

  @override
  NesEditHistoryEntry decode(Object? value) =>
      NesEditHistoryEntry.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesEditHistoryEntry value) => value.toJson();
}

/// Shared codec for [NesEditHistoryEntry].
const NesEditHistoryEntryCodec nesEditHistoryEntryCodec =
    NesEditHistoryEntryCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A text edit suggestion.
final class NesEditSuggestion implements AcpJsonEncodable {
  /// Creates a NesEditSuggestion value.
  NesEditSuggestion({
    required this.id,
    required this.uri,
    required List<NesTextEdit> edits,
    this.cursorPosition,
    this.meta,
  }) : edits = List<NesTextEdit>.unmodifiable(edits);

  /// Unique identifier for accept/reject tracking.
  final NesSuggestionId id;

  /// The URI of the file to edit.
  final String uri;

  /// The text edits to apply.
  final List<NesTextEdit> edits;

  /// Optional suggested cursor position after applying edits.
  final Position? cursorPosition;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesEditSuggestion> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesEditSuggestion(
      id: decoder.required('id', (value) => nesSuggestionIdCodec.decode(value)),
      uri: decoder.required('uri', (value) => decodeAcpString(value)),
      edits: decoder.required(
        'edits',
        (value) => List<NesTextEdit>.unmodifiable(
          (value as List<Object?>).map((item) => nesTextEditCodec.decode(item)),
        ),
      ),
      cursorPosition: decoder
          .optionalOnError(
            'cursorPosition',
            (value) => positionCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesEditSuggestion.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['id'] = nesSuggestionIdCodec.encode(id);
    result['uri'] = uri;
    result['edits'] = <Object?>[
      for (final item in edits) nesTextEditCodec.encode(item),
    ];
    if (cursorPosition != null) {
      result['cursorPosition'] = positionCodec.encode(cursorPosition!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesEditSuggestion].
final class NesEditSuggestionCodec implements AcpCodec<NesEditSuggestion> {
  /// Creates the codec.
  const NesEditSuggestionCodec();

  @override
  NesEditSuggestion decode(Object? value) =>
      NesEditSuggestion.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesEditSuggestion value) => value.toJson();
}

/// Shared codec for [NesEditSuggestion].
const NesEditSuggestionCodec nesEditSuggestionCodec = NesEditSuggestionCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Event capabilities the agent can consume.
final class NesEventCapabilities implements AcpJsonEncodable {
  /// Creates a NesEventCapabilities value.
  NesEventCapabilities({this.document, this.meta});

  /// Document event capabilities.
  final NesDocumentEventCapabilities? document;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesEventCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesEventCapabilities(
      document: decoder
          .optionalOnError(
            'document',
            (value) => nesDocumentEventCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesEventCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (document != null) {
      result['document'] = nesDocumentEventCapabilitiesCodec.encode(document!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesEventCapabilities].
final class NesEventCapabilitiesCodec
    implements AcpCodec<NesEventCapabilities> {
  /// Creates the codec.
  const NesEventCapabilitiesCodec();

  @override
  NesEventCapabilities decode(Object? value) =>
      NesEventCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesEventCapabilities value) => value.toJson();
}

/// Shared codec for [NesEventCapabilities].
const NesEventCapabilitiesCodec nesEventCapabilitiesCodec =
    NesEventCapabilitiesCodec();

int _decodeNesExcerptStartLine(Object? value) =>
    decodeAcpIntegerInRange(value, 0, 4294967295);
Object? _encodeNesExcerptStartLine(int value) => value;

int _decodeNesExcerptEndLine(Object? value) =>
    decodeAcpIntegerInRange(value, 0, 4294967295);
Object? _encodeNesExcerptEndLine(int value) => value;

String _decodeNesExcerptText(Object? value) => decodeAcpString(value);
Object? _encodeNesExcerptText(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A code excerpt from a file.
final class NesExcerpt implements AcpJsonEncodable {
  /// Creates a NesExcerpt value.
  NesExcerpt({
    required this.startLine,
    required this.endLine,
    required this.text,
    this.meta,
  });

  /// The start line of the excerpt (zero-based).
  @JsonKey(
    name: 'startLine',
    fromJson: _decodeNesExcerptStartLine,
    toJson: _encodeNesExcerptStartLine,
    includeIfNull: false,
    required: true,
  )
  final int startLine;

  /// The end line of the excerpt (zero-based).
  @JsonKey(
    name: 'endLine',
    fromJson: _decodeNesExcerptEndLine,
    toJson: _encodeNesExcerptEndLine,
    includeIfNull: false,
    required: true,
  )
  final int endLine;

  /// The text content of the excerpt.
  @JsonKey(
    name: 'text',
    fromJson: _decodeNesExcerptText,
    toJson: _encodeNesExcerptText,
    includeIfNull: false,
    required: true,
  )
  final String text;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesExcerpt.fromJson(Map<String, Object?> json) =>
      _$NesExcerptFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesExcerptToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesExcerpt].
final class NesExcerptCodec implements AcpCodec<NesExcerpt> {
  /// Creates the codec.
  const NesExcerptCodec();

  @override
  NesExcerpt decode(Object? value) =>
      NesExcerpt.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesExcerpt value) => value.toJson();
}

/// Shared codec for [NesExcerpt].
const NesExcerptCodec nesExcerptCodec = NesExcerptCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Marker for jump suggestion support.
final class NesJumpCapabilities implements AcpJsonEncodable {
  /// Creates a NesJumpCapabilities value.
  NesJumpCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesJumpCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesJumpCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesJumpCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesJumpCapabilities].
final class NesJumpCapabilitiesCodec implements AcpCodec<NesJumpCapabilities> {
  /// Creates the codec.
  const NesJumpCapabilitiesCodec();

  @override
  NesJumpCapabilities decode(Object? value) =>
      NesJumpCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesJumpCapabilities value) => value.toJson();
}

/// Shared codec for [NesJumpCapabilities].
const NesJumpCapabilitiesCodec nesJumpCapabilitiesCodec =
    NesJumpCapabilitiesCodec();

NesSuggestionId _decodeNesJumpSuggestionId(Object? value) =>
    nesSuggestionIdCodec.decode(value);
Object? _encodeNesJumpSuggestionId(NesSuggestionId value) =>
    nesSuggestionIdCodec.encode(value);

String _decodeNesJumpSuggestionUri(Object? value) => decodeAcpString(value);
Object? _encodeNesJumpSuggestionUri(String value) => value;

Position _decodeNesJumpSuggestionPosition(Object? value) =>
    positionCodec.decode(value);
Object? _encodeNesJumpSuggestionPosition(Position value) =>
    positionCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A jump-to-location suggestion.
final class NesJumpSuggestion implements AcpJsonEncodable {
  /// Creates a NesJumpSuggestion value.
  NesJumpSuggestion({
    required this.id,
    required this.uri,
    required this.position,
    this.meta,
  });

  /// Unique identifier for accept/reject tracking.
  @JsonKey(
    name: 'id',
    fromJson: _decodeNesJumpSuggestionId,
    toJson: _encodeNesJumpSuggestionId,
    includeIfNull: false,
    required: true,
  )
  final NesSuggestionId id;

  /// The file to navigate to.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeNesJumpSuggestionUri,
    toJson: _encodeNesJumpSuggestionUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The target position within the file.
  @JsonKey(
    name: 'position',
    fromJson: _decodeNesJumpSuggestionPosition,
    toJson: _encodeNesJumpSuggestionPosition,
    includeIfNull: false,
    required: true,
  )
  final Position position;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesJumpSuggestion.fromJson(Map<String, Object?> json) =>
      _$NesJumpSuggestionFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesJumpSuggestionToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesJumpSuggestion].
final class NesJumpSuggestionCodec implements AcpCodec<NesJumpSuggestion> {
  /// Creates the codec.
  const NesJumpSuggestionCodec();

  @override
  NesJumpSuggestion decode(Object? value) =>
      NesJumpSuggestion.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesJumpSuggestion value) => value.toJson();
}

/// Shared codec for [NesJumpSuggestion].
const NesJumpSuggestionCodec nesJumpSuggestionCodec = NesJumpSuggestionCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// An open file in the editor.
final class NesOpenFile implements AcpJsonEncodable {
  /// Creates a NesOpenFile value.
  NesOpenFile({
    required this.uri,
    required this.languageId,
    this.visibleRange,
    this.lastFocusedMs,
    this.meta,
  });

  /// The URI of the file.
  final String uri;

  /// The language identifier.
  final String languageId;

  /// The visible range in the editor, if any.
  final Range? visibleRange;

  /// Timestamp in milliseconds since epoch of when the file was last focused.
  final AcpUint64? lastFocusedMs;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesOpenFile> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesOpenFile(
      uri: decoder.required('uri', (value) => decodeAcpString(value)),
      languageId: decoder.required(
        'languageId',
        (value) => decodeAcpString(value),
      ),
      visibleRange: decoder
          .optionalOnError('visibleRange', (value) => rangeCodec.decode(value))
          .valueOrNull,
      lastFocusedMs: decoder
          .optionalOnError('lastFocusedMs', (value) => decodeAcpUint64(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesOpenFile.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['uri'] = uri;
    result['languageId'] = languageId;
    if (visibleRange != null) {
      result['visibleRange'] = rangeCodec.encode(visibleRange!);
    }
    if (lastFocusedMs != null) {
      result['lastFocusedMs'] = encodeAcpUint64(lastFocusedMs!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesOpenFile].
final class NesOpenFileCodec implements AcpCodec<NesOpenFile> {
  /// Creates the codec.
  const NesOpenFileCodec();

  @override
  NesOpenFile decode(Object? value) =>
      NesOpenFile.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesOpenFile value) => value.toJson();
}

/// Shared codec for [NesOpenFile].
const NesOpenFileCodec nesOpenFileCodec = NesOpenFileCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for open files context.
final class NesOpenFilesCapabilities implements AcpJsonEncodable {
  /// Creates a NesOpenFilesCapabilities value.
  NesOpenFilesCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesOpenFilesCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesOpenFilesCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesOpenFilesCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesOpenFilesCapabilities].
final class NesOpenFilesCapabilitiesCodec
    implements AcpCodec<NesOpenFilesCapabilities> {
  /// Creates the codec.
  const NesOpenFilesCapabilitiesCodec();

  @override
  NesOpenFilesCapabilities decode(Object? value) =>
      NesOpenFilesCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesOpenFilesCapabilities value) => value.toJson();
}

/// Shared codec for [NesOpenFilesCapabilities].
const NesOpenFilesCapabilitiesCodec nesOpenFilesCapabilitiesCodec =
    NesOpenFilesCapabilitiesCodec();

String _decodeNesRecentFileUri(Object? value) => decodeAcpString(value);
Object? _encodeNesRecentFileUri(String value) => value;

String _decodeNesRecentFileLanguageId(Object? value) => decodeAcpString(value);
Object? _encodeNesRecentFileLanguageId(String value) => value;

String _decodeNesRecentFileText(Object? value) => decodeAcpString(value);
Object? _encodeNesRecentFileText(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A recently accessed file.
final class NesRecentFile implements AcpJsonEncodable {
  /// Creates a NesRecentFile value.
  NesRecentFile({
    required this.uri,
    required this.languageId,
    required this.text,
    this.meta,
  });

  /// The URI of the file.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeNesRecentFileUri,
    toJson: _encodeNesRecentFileUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The language identifier.
  @JsonKey(
    name: 'languageId',
    fromJson: _decodeNesRecentFileLanguageId,
    toJson: _encodeNesRecentFileLanguageId,
    includeIfNull: false,
    required: true,
  )
  final String languageId;

  /// The full text content of the file.
  @JsonKey(
    name: 'text',
    fromJson: _decodeNesRecentFileText,
    toJson: _encodeNesRecentFileText,
    includeIfNull: false,
    required: true,
  )
  final String text;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesRecentFile.fromJson(Map<String, Object?> json) =>
      _$NesRecentFileFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesRecentFileToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesRecentFile].
final class NesRecentFileCodec implements AcpCodec<NesRecentFile> {
  /// Creates the codec.
  const NesRecentFileCodec();

  @override
  NesRecentFile decode(Object? value) =>
      NesRecentFile.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesRecentFile value) => value.toJson();
}

/// Shared codec for [NesRecentFile].
const NesRecentFileCodec nesRecentFileCodec = NesRecentFileCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Capabilities for recent files context.
final class NesRecentFilesCapabilities implements AcpJsonEncodable {
  /// Creates a NesRecentFilesCapabilities value.
  NesRecentFilesCapabilities({this.maxCount, this.meta});

  /// Maximum number of recent files the agent can use.
  final int? maxCount;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesRecentFilesCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesRecentFilesCapabilities(
      maxCount: decoder
          .optionalOnError(
            'maxCount',
            (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesRecentFilesCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (maxCount != null) {
      result['maxCount'] = maxCount!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesRecentFilesCapabilities].
final class NesRecentFilesCapabilitiesCodec
    implements AcpCodec<NesRecentFilesCapabilities> {
  /// Creates the codec.
  const NesRecentFilesCapabilitiesCodec();

  @override
  NesRecentFilesCapabilities decode(Object? value) =>
      NesRecentFilesCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesRecentFilesCapabilities value) => value.toJson();
}

/// Shared codec for [NesRecentFilesCapabilities].
const NesRecentFilesCapabilitiesCodec nesRecentFilesCapabilitiesCodec =
    NesRecentFilesCapabilitiesCodec();

/// The reason a suggestion was rejected.
final class NesRejectReason implements AcpJsonEncodable {
  /// Validates and creates a NesRejectReason value.
  factory NesRejectReason(String value) {
    if (!const <String>{
      'rejected',
      'ignored',
      'replaced',
      'cancelled',
    }.contains(value)) {
      throw FormatException('Unknown NesRejectReason: $value');
    }
    return NesRejectReason._(value);
  }

  const NesRejectReason._(this.value);

  /// The exact wire string.
  final String value;

  /// The `rejected` schema value.
  static const NesRejectReason rejected = NesRejectReason._('rejected');

  /// The `ignored` schema value.
  static const NesRejectReason ignored = NesRejectReason._('ignored');

  /// The `replaced` schema value.
  static const NesRejectReason replaced = NesRejectReason._('replaced');

  /// The `cancelled` schema value.
  static const NesRejectReason cancelled = NesRejectReason._('cancelled');

  /// Decodes a wire string.
  factory NesRejectReason.fromJson(Object? json) =>
      NesRejectReason(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is NesRejectReason && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [NesRejectReason].
final class NesRejectReasonCodec implements AcpCodec<NesRejectReason> {
  /// Creates the codec.
  const NesRejectReasonCodec();

  @override
  NesRejectReason decode(Object? value) => NesRejectReason.fromJson(value);

  @override
  String encode(NesRejectReason value) => value.toJson();
}

/// Shared codec for [NesRejectReason].
const NesRejectReasonCodec nesRejectReasonCodec = NesRejectReasonCodec();

String _decodeNesRelatedSnippetUri(Object? value) => decodeAcpString(value);
Object? _encodeNesRelatedSnippetUri(String value) => value;

List<NesExcerpt> _decodeNesRelatedSnippetExcerpts(Object? value) =>
    List<NesExcerpt>.unmodifiable(
      (value as List<Object?>).map((item) => nesExcerptCodec.decode(item)),
    );
Object? _encodeNesRelatedSnippetExcerpts(List<NesExcerpt> value) => <Object?>[
  for (final item in value) nesExcerptCodec.encode(item),
];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A related code snippet from a file.
final class NesRelatedSnippet implements AcpJsonEncodable {
  /// Creates a NesRelatedSnippet value.
  NesRelatedSnippet({
    required this.uri,
    required List<NesExcerpt> excerpts,
    this.meta,
  }) : excerpts = List<NesExcerpt>.unmodifiable(excerpts);

  /// The URI of the file containing the snippets.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeNesRelatedSnippetUri,
    toJson: _encodeNesRelatedSnippetUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The code excerpts.
  @JsonKey(
    name: 'excerpts',
    fromJson: _decodeNesRelatedSnippetExcerpts,
    toJson: _encodeNesRelatedSnippetExcerpts,
    includeIfNull: false,
    required: true,
  )
  final List<NesExcerpt> excerpts;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesRelatedSnippet.fromJson(Map<String, Object?> json) =>
      _$NesRelatedSnippetFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesRelatedSnippetToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesRelatedSnippet].
final class NesRelatedSnippetCodec implements AcpCodec<NesRelatedSnippet> {
  /// Creates the codec.
  const NesRelatedSnippetCodec();

  @override
  NesRelatedSnippet decode(Object? value) =>
      NesRelatedSnippet.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesRelatedSnippet value) => value.toJson();
}

/// Shared codec for [NesRelatedSnippet].
const NesRelatedSnippetCodec nesRelatedSnippetCodec = NesRelatedSnippetCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for related snippets context.
final class NesRelatedSnippetsCapabilities implements AcpJsonEncodable {
  /// Creates a NesRelatedSnippetsCapabilities value.
  NesRelatedSnippetsCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesRelatedSnippetsCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesRelatedSnippetsCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesRelatedSnippetsCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesRelatedSnippetsCapabilities].
final class NesRelatedSnippetsCapabilitiesCodec
    implements AcpCodec<NesRelatedSnippetsCapabilities> {
  /// Creates the codec.
  const NesRelatedSnippetsCapabilitiesCodec();

  @override
  NesRelatedSnippetsCapabilities decode(Object? value) =>
      NesRelatedSnippetsCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesRelatedSnippetsCapabilities value) => value.toJson();
}

/// Shared codec for [NesRelatedSnippetsCapabilities].
const NesRelatedSnippetsCapabilitiesCodec nesRelatedSnippetsCapabilitiesCodec =
    NesRelatedSnippetsCapabilitiesCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Marker for rename suggestion support.
final class NesRenameCapabilities implements AcpJsonEncodable {
  /// Creates a NesRenameCapabilities value.
  NesRenameCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesRenameCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesRenameCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesRenameCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesRenameCapabilities].
final class NesRenameCapabilitiesCodec
    implements AcpCodec<NesRenameCapabilities> {
  /// Creates the codec.
  const NesRenameCapabilitiesCodec();

  @override
  NesRenameCapabilities decode(Object? value) =>
      NesRenameCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesRenameCapabilities value) => value.toJson();
}

/// Shared codec for [NesRenameCapabilities].
const NesRenameCapabilitiesCodec nesRenameCapabilitiesCodec =
    NesRenameCapabilitiesCodec();

NesSuggestionId _decodeNesRenameSuggestionId(Object? value) =>
    nesSuggestionIdCodec.decode(value);
Object? _encodeNesRenameSuggestionId(NesSuggestionId value) =>
    nesSuggestionIdCodec.encode(value);

String _decodeNesRenameSuggestionUri(Object? value) => decodeAcpString(value);
Object? _encodeNesRenameSuggestionUri(String value) => value;

Position _decodeNesRenameSuggestionPosition(Object? value) =>
    positionCodec.decode(value);
Object? _encodeNesRenameSuggestionPosition(Position value) =>
    positionCodec.encode(value);

String _decodeNesRenameSuggestionNewName(Object? value) =>
    decodeAcpString(value);
Object? _encodeNesRenameSuggestionNewName(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A rename symbol suggestion.
final class NesRenameSuggestion implements AcpJsonEncodable {
  /// Creates a NesRenameSuggestion value.
  NesRenameSuggestion({
    required this.id,
    required this.uri,
    required this.position,
    required this.newName,
    this.meta,
  });

  /// Unique identifier for accept/reject tracking.
  @JsonKey(
    name: 'id',
    fromJson: _decodeNesRenameSuggestionId,
    toJson: _encodeNesRenameSuggestionId,
    includeIfNull: false,
    required: true,
  )
  final NesSuggestionId id;

  /// The file URI containing the symbol.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeNesRenameSuggestionUri,
    toJson: _encodeNesRenameSuggestionUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The position of the symbol to rename.
  @JsonKey(
    name: 'position',
    fromJson: _decodeNesRenameSuggestionPosition,
    toJson: _encodeNesRenameSuggestionPosition,
    includeIfNull: false,
    required: true,
  )
  final Position position;

  /// The new name for the symbol.
  @JsonKey(
    name: 'newName',
    fromJson: _decodeNesRenameSuggestionNewName,
    toJson: _encodeNesRenameSuggestionNewName,
    includeIfNull: false,
    required: true,
  )
  final String newName;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesRenameSuggestion.fromJson(Map<String, Object?> json) =>
      _$NesRenameSuggestionFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesRenameSuggestionToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesRenameSuggestion].
final class NesRenameSuggestionCodec implements AcpCodec<NesRenameSuggestion> {
  /// Creates the codec.
  const NesRenameSuggestionCodec();

  @override
  NesRenameSuggestion decode(Object? value) =>
      NesRenameSuggestion.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesRenameSuggestion value) => value.toJson();
}

/// Shared codec for [NesRenameSuggestion].
const NesRenameSuggestionCodec nesRenameSuggestionCodec =
    NesRenameSuggestionCodec();

String _decodeNesRepositoryName(Object? value) => decodeAcpString(value);
Object? _encodeNesRepositoryName(String value) => value;

String _decodeNesRepositoryOwner(Object? value) => decodeAcpString(value);
Object? _encodeNesRepositoryOwner(String value) => value;

String _decodeNesRepositoryRemoteUrl(Object? value) => decodeAcpString(value);
Object? _encodeNesRepositoryRemoteUrl(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Repository metadata for an NES session.
final class NesRepository implements AcpJsonEncodable {
  /// Creates a NesRepository value.
  NesRepository({
    required this.name,
    required this.owner,
    required this.remoteUrl,
    this.meta,
  });

  /// The repository name.
  @JsonKey(
    name: 'name',
    fromJson: _decodeNesRepositoryName,
    toJson: _encodeNesRepositoryName,
    includeIfNull: false,
    required: true,
  )
  final String name;

  /// The repository owner.
  @JsonKey(
    name: 'owner',
    fromJson: _decodeNesRepositoryOwner,
    toJson: _encodeNesRepositoryOwner,
    includeIfNull: false,
    required: true,
  )
  final String owner;

  /// The remote URL of the repository.
  @JsonKey(
    name: 'remoteUrl',
    fromJson: _decodeNesRepositoryRemoteUrl,
    toJson: _encodeNesRepositoryRemoteUrl,
    includeIfNull: false,
    required: true,
  )
  final String remoteUrl;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesRepository.fromJson(Map<String, Object?> json) =>
      _$NesRepositoryFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesRepositoryToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesRepository].
final class NesRepositoryCodec implements AcpCodec<NesRepository> {
  /// Creates the codec.
  const NesRepositoryCodec();

  @override
  NesRepository decode(Object? value) =>
      NesRepository.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesRepository value) => value.toJson();
}

/// Shared codec for [NesRepository].
const NesRepositoryCodec nesRepositoryCodec = NesRepositoryCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Marker for search and replace suggestion support.
final class NesSearchAndReplaceCapabilities implements AcpJsonEncodable {
  /// Creates a NesSearchAndReplaceCapabilities value.
  NesSearchAndReplaceCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesSearchAndReplaceCapabilities.fromJson(Map<String, Object?> json) =>
      _$NesSearchAndReplaceCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() =>
      _$NesSearchAndReplaceCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesSearchAndReplaceCapabilities].
final class NesSearchAndReplaceCapabilitiesCodec
    implements AcpCodec<NesSearchAndReplaceCapabilities> {
  /// Creates the codec.
  const NesSearchAndReplaceCapabilitiesCodec();

  @override
  NesSearchAndReplaceCapabilities decode(Object? value) =>
      NesSearchAndReplaceCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesSearchAndReplaceCapabilities value) => value.toJson();
}

/// Shared codec for [NesSearchAndReplaceCapabilities].
const NesSearchAndReplaceCapabilitiesCodec
nesSearchAndReplaceCapabilitiesCodec = NesSearchAndReplaceCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A search-and-replace suggestion.
final class NesSearchAndReplaceSuggestion implements AcpJsonEncodable {
  /// Creates a NesSearchAndReplaceSuggestion value.
  NesSearchAndReplaceSuggestion({
    required this.id,
    required this.uri,
    required this.search,
    required this.replace,
    this.isRegex,
    this.meta,
  });

  /// Unique identifier for accept/reject tracking.
  final NesSuggestionId id;

  /// The file URI to search within.
  final String uri;

  /// The text or pattern to find.
  final String search;

  /// The replacement text.
  final String replace;

  /// Whether `search` is a regular expression. Defaults to `false`.
  final bool? isRegex;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesSearchAndReplaceSuggestion> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesSearchAndReplaceSuggestion(
      id: decoder.required('id', (value) => nesSuggestionIdCodec.decode(value)),
      uri: decoder.required('uri', (value) => decodeAcpString(value)),
      search: decoder.required('search', (value) => decodeAcpString(value)),
      replace: decoder.required('replace', (value) => decodeAcpString(value)),
      isRegex: decoder.optional('isRegex', (value) => decodeAcpBoolean(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesSearchAndReplaceSuggestion.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['id'] = nesSuggestionIdCodec.encode(id);
    result['uri'] = uri;
    result['search'] = search;
    result['replace'] = replace;
    if (isRegex != null) {
      result['isRegex'] = isRegex!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesSearchAndReplaceSuggestion].
final class NesSearchAndReplaceSuggestionCodec
    implements AcpCodec<NesSearchAndReplaceSuggestion> {
  /// Creates the codec.
  const NesSearchAndReplaceSuggestionCodec();

  @override
  NesSearchAndReplaceSuggestion decode(Object? value) =>
      NesSearchAndReplaceSuggestion.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesSearchAndReplaceSuggestion value) => value.toJson();
}

/// Shared codec for [NesSearchAndReplaceSuggestion].
const NesSearchAndReplaceSuggestionCodec nesSearchAndReplaceSuggestionCodec =
    NesSearchAndReplaceSuggestionCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Context attached to a suggestion request.
final class NesSuggestContext implements AcpJsonEncodable {
  /// Creates a NesSuggestContext value.
  NesSuggestContext({
    List<NesRecentFile>? recentFiles,
    List<NesRelatedSnippet>? relatedSnippets,
    List<NesEditHistoryEntry>? editHistory,
    List<NesUserAction>? userActions,
    List<NesOpenFile>? openFiles,
    List<NesDiagnostic>? diagnostics,
    this.meta,
  }) : recentFiles = recentFiles == null
           ? null
           : List<NesRecentFile>.unmodifiable(recentFiles),
       relatedSnippets = relatedSnippets == null
           ? null
           : List<NesRelatedSnippet>.unmodifiable(relatedSnippets),
       editHistory = editHistory == null
           ? null
           : List<NesEditHistoryEntry>.unmodifiable(editHistory),
       userActions = userActions == null
           ? null
           : List<NesUserAction>.unmodifiable(userActions),
       openFiles = openFiles == null
           ? null
           : List<NesOpenFile>.unmodifiable(openFiles),
       diagnostics = diagnostics == null
           ? null
           : List<NesDiagnostic>.unmodifiable(diagnostics);

  /// Recently accessed files.
  final List<NesRecentFile>? recentFiles;

  /// Related code snippets.
  final List<NesRelatedSnippet>? relatedSnippets;

  /// Recent edit history.
  final List<NesEditHistoryEntry>? editHistory;

  /// Recent user actions (typing, navigation, etc.).
  final List<NesUserAction>? userActions;

  /// Currently open files in the editor.
  final List<NesOpenFile>? openFiles;

  /// Current diagnostics (errors, warnings).
  final List<NesDiagnostic>? diagnostics;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesSuggestContext> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesSuggestContext(
      recentFiles: decoder.optional(
        'recentFiles',
        (value) => List<NesRecentFile>.unmodifiable(
          (value as List<Object?>).map(
            (item) => nesRecentFileCodec.decode(item),
          ),
        ),
      ),
      relatedSnippets: decoder.optional(
        'relatedSnippets',
        (value) => List<NesRelatedSnippet>.unmodifiable(
          (value as List<Object?>).map(
            (item) => nesRelatedSnippetCodec.decode(item),
          ),
        ),
      ),
      editHistory: decoder.optional(
        'editHistory',
        (value) => List<NesEditHistoryEntry>.unmodifiable(
          (value as List<Object?>).map(
            (item) => nesEditHistoryEntryCodec.decode(item),
          ),
        ),
      ),
      userActions: decoder.optional(
        'userActions',
        (value) => List<NesUserAction>.unmodifiable(
          (value as List<Object?>).map(
            (item) => nesUserActionCodec.decode(item),
          ),
        ),
      ),
      openFiles: decoder.optional(
        'openFiles',
        (value) => List<NesOpenFile>.unmodifiable(
          (value as List<Object?>).map((item) => nesOpenFileCodec.decode(item)),
        ),
      ),
      diagnostics: decoder.optional(
        'diagnostics',
        (value) => List<NesDiagnostic>.unmodifiable(
          (value as List<Object?>).map(
            (item) => nesDiagnosticCodec.decode(item),
          ),
        ),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesSuggestContext.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (recentFiles != null) {
      result['recentFiles'] = <Object?>[
        for (final item in recentFiles!) nesRecentFileCodec.encode(item),
      ];
    }
    if (relatedSnippets != null) {
      result['relatedSnippets'] = <Object?>[
        for (final item in relatedSnippets!)
          nesRelatedSnippetCodec.encode(item),
      ];
    }
    if (editHistory != null) {
      result['editHistory'] = <Object?>[
        for (final item in editHistory!) nesEditHistoryEntryCodec.encode(item),
      ];
    }
    if (userActions != null) {
      result['userActions'] = <Object?>[
        for (final item in userActions!) nesUserActionCodec.encode(item),
      ];
    }
    if (openFiles != null) {
      result['openFiles'] = <Object?>[
        for (final item in openFiles!) nesOpenFileCodec.encode(item),
      ];
    }
    if (diagnostics != null) {
      result['diagnostics'] = <Object?>[
        for (final item in diagnostics!) nesDiagnosticCodec.encode(item),
      ];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesSuggestContext].
final class NesSuggestContextCodec implements AcpCodec<NesSuggestContext> {
  /// Creates the codec.
  const NesSuggestContextCodec();

  @override
  NesSuggestContext decode(Object? value) =>
      NesSuggestContext.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesSuggestContext value) => value.toJson();
}

/// Shared codec for [NesSuggestContext].
const NesSuggestContextCodec nesSuggestContextCodec = NesSuggestContextCodec();

/// A suggestion returned by the agent.
sealed class NesSuggestion implements AcpJsonEncodable {
  const NesSuggestion();

  /// Decodes the tagged union.
  factory NesSuggestion.fromJson(Object? json) =>
      nesSuggestionCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// A text edit suggestion.
final class NesSuggestionEdit extends NesSuggestion {
  /// Creates this known tagged-union variant.
  const NesSuggestionEdit(this.value);

  /// The typed variant payload.
  final NesEditSuggestion value;

  @override
  String get discriminator => 'edit';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(nesEditSuggestionCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['kind'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A jump-to-location suggestion.
final class NesSuggestionJump extends NesSuggestion {
  /// Creates this known tagged-union variant.
  const NesSuggestionJump(this.value);

  /// The typed variant payload.
  final NesJumpSuggestion value;

  @override
  String get discriminator => 'jump';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(nesJumpSuggestionCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['kind'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A rename symbol suggestion.
final class NesSuggestionRename extends NesSuggestion {
  /// Creates this known tagged-union variant.
  const NesSuggestionRename(this.value);

  /// The typed variant payload.
  final NesRenameSuggestion value;

  @override
  String get discriminator => 'rename';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(nesRenameSuggestionCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['kind'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A search-and-replace suggestion.
final class NesSuggestionSearchAndReplace extends NesSuggestion {
  /// Creates this known tagged-union variant.
  const NesSuggestionSearchAndReplace(this.value);

  /// The typed variant payload.
  final NesSearchAndReplaceSuggestion value;

  @override
  String get discriminator => 'searchAndReplace';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(
      nesSearchAndReplaceSuggestionCodec.encode(value),
    );
    final result = <String, Object?>{...payload};
    result['kind'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Codec for [NesSuggestion].
final class NesSuggestionCodec implements AcpCodec<NesSuggestion> {
  /// Creates the codec.
  const NesSuggestionCodec();

  @override
  NesSuggestion decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['kind']);
    switch (tag) {
      case 'edit':
        return NesSuggestionEdit(nesEditSuggestionCodec.decode(payload));
      case 'jump':
        return NesSuggestionJump(nesJumpSuggestionCodec.decode(payload));
      case 'rename':
        return NesSuggestionRename(nesRenameSuggestionCodec.decode(payload));
      case 'searchAndReplace':
        return NesSuggestionSearchAndReplace(
          nesSearchAndReplaceSuggestionCodec.decode(payload),
        );
      default:
        throw FormatException('Unknown NesSuggestion tag: $tag');
    }
  }

  @override
  Object encode(NesSuggestion value) => value.toJson();
}

/// Shared codec for [NesSuggestion].
const NesSuggestionCodec nesSuggestionCodec = NesSuggestionCodec();

/// Unique identifier for a next edit suggestion.
final class NesSuggestionId implements AcpJsonEncodable {
  /// Validates and creates a NesSuggestionId value.
  factory NesSuggestionId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return NesSuggestionId._(value);
  }

  const NesSuggestionId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory NesSuggestionId.fromJson(Object? json) =>
      NesSuggestionId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is NesSuggestionId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [NesSuggestionId].
final class NesSuggestionIdCodec implements AcpCodec<NesSuggestionId> {
  /// Creates the codec.
  const NesSuggestionIdCodec();

  @override
  NesSuggestionId decode(Object? value) => NesSuggestionId.fromJson(value);

  @override
  String encode(NesSuggestionId value) => value.toJson();
}

/// Shared codec for [NesSuggestionId].
const NesSuggestionIdCodec nesSuggestionIdCodec = NesSuggestionIdCodec();

Range _decodeNesTextEditRange(Object? value) => rangeCodec.decode(value);
Object? _encodeNesTextEditRange(Range value) => rangeCodec.encode(value);

String _decodeNesTextEditNewText(Object? value) => decodeAcpString(value);
Object? _encodeNesTextEditNewText(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A text edit within a suggestion.
final class NesTextEdit implements AcpJsonEncodable {
  /// Creates a NesTextEdit value.
  NesTextEdit({required this.range, required this.newText, this.meta});

  /// The range to replace.
  @JsonKey(
    name: 'range',
    fromJson: _decodeNesTextEditRange,
    toJson: _encodeNesTextEditRange,
    includeIfNull: false,
    required: true,
  )
  final Range range;

  /// The replacement text.
  @JsonKey(
    name: 'newText',
    fromJson: _decodeNesTextEditNewText,
    toJson: _encodeNesTextEditNewText,
    includeIfNull: false,
    required: true,
  )
  final String newText;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesTextEdit.fromJson(Map<String, Object?> json) =>
      _$NesTextEditFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesTextEditToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesTextEdit].
final class NesTextEditCodec implements AcpCodec<NesTextEdit> {
  /// Creates the codec.
  const NesTextEditCodec();

  @override
  NesTextEdit decode(Object? value) =>
      NesTextEdit.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesTextEdit value) => value.toJson();
}

/// Shared codec for [NesTextEdit].
const NesTextEditCodec nesTextEditCodec = NesTextEditCodec();

/// What triggered the suggestion request.
final class NesTriggerKind implements AcpJsonEncodable {
  /// Validates and creates a NesTriggerKind value.
  factory NesTriggerKind(String value) {
    if (!const <String>{'automatic', 'diagnostic', 'manual'}.contains(value)) {
      throw FormatException('Unknown NesTriggerKind: $value');
    }
    return NesTriggerKind._(value);
  }

  const NesTriggerKind._(this.value);

  /// The exact wire string.
  final String value;

  /// The `automatic` schema value.
  static const NesTriggerKind automatic = NesTriggerKind._('automatic');

  /// The `diagnostic` schema value.
  static const NesTriggerKind diagnostic = NesTriggerKind._('diagnostic');

  /// The `manual` schema value.
  static const NesTriggerKind manual = NesTriggerKind._('manual');

  /// Decodes a wire string.
  factory NesTriggerKind.fromJson(Object? json) =>
      NesTriggerKind(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is NesTriggerKind && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [NesTriggerKind].
final class NesTriggerKindCodec implements AcpCodec<NesTriggerKind> {
  /// Creates the codec.
  const NesTriggerKindCodec();

  @override
  NesTriggerKind decode(Object? value) => NesTriggerKind.fromJson(value);

  @override
  String encode(NesTriggerKind value) => value.toJson();
}

/// Shared codec for [NesTriggerKind].
const NesTriggerKindCodec nesTriggerKindCodec = NesTriggerKindCodec();

String _decodeNesUserActionAction(Object? value) => decodeAcpString(value);
Object? _encodeNesUserActionAction(String value) => value;

String _decodeNesUserActionUri(Object? value) => decodeAcpString(value);
Object? _encodeNesUserActionUri(String value) => value;

Position _decodeNesUserActionPosition(Object? value) =>
    positionCodec.decode(value);
Object? _encodeNesUserActionPosition(Position value) =>
    positionCodec.encode(value);

AcpUint64 _decodeNesUserActionTimestampMs(Object? value) =>
    decodeAcpUint64(value);
Object? _encodeNesUserActionTimestampMs(AcpUint64 value) =>
    encodeAcpUint64(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A user action (typing, cursor movement, etc.).
final class NesUserAction implements AcpJsonEncodable {
  /// Creates a NesUserAction value.
  NesUserAction({
    required this.action,
    required this.uri,
    required this.position,
    required this.timestampMs,
    this.meta,
  });

  /// The kind of action (e.g., "insertChar", "cursorMovement").
  @JsonKey(
    name: 'action',
    fromJson: _decodeNesUserActionAction,
    toJson: _encodeNesUserActionAction,
    includeIfNull: false,
    required: true,
  )
  final String action;

  /// The URI of the file where the action occurred.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeNesUserActionUri,
    toJson: _encodeNesUserActionUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The position where the action occurred.
  @JsonKey(
    name: 'position',
    fromJson: _decodeNesUserActionPosition,
    toJson: _encodeNesUserActionPosition,
    includeIfNull: false,
    required: true,
  )
  final Position position;

  /// Timestamp in milliseconds since epoch.
  @JsonKey(
    name: 'timestampMs',
    fromJson: _decodeNesUserActionTimestampMs,
    toJson: _encodeNesUserActionTimestampMs,
    includeIfNull: false,
    required: true,
  )
  final AcpUint64 timestampMs;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory NesUserAction.fromJson(Map<String, Object?> json) =>
      _$NesUserActionFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$NesUserActionToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesUserAction].
final class NesUserActionCodec implements AcpCodec<NesUserAction> {
  /// Creates the codec.
  const NesUserActionCodec();

  @override
  NesUserAction decode(Object? value) =>
      NesUserAction.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesUserAction value) => value.toJson();
}

/// Shared codec for [NesUserAction].
const NesUserActionCodec nesUserActionCodec = NesUserActionCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Capabilities for user actions context.
final class NesUserActionsCapabilities implements AcpJsonEncodable {
  /// Creates a NesUserActionsCapabilities value.
  NesUserActionsCapabilities({this.maxCount, this.meta});

  /// Maximum number of user actions the agent can use.
  final int? maxCount;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NesUserActionsCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NesUserActionsCapabilities(
      maxCount: decoder
          .optionalOnError(
            'maxCount',
            (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NesUserActionsCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (maxCount != null) {
      result['maxCount'] = maxCount!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NesUserActionsCapabilities].
final class NesUserActionsCapabilitiesCodec
    implements AcpCodec<NesUserActionsCapabilities> {
  /// Creates the codec.
  const NesUserActionsCapabilitiesCodec();

  @override
  NesUserActionsCapabilities decode(Object? value) =>
      NesUserActionsCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(NesUserActionsCapabilities value) => value.toJson();
}

/// Shared codec for [NesUserActionsCapabilities].
const NesUserActionsCapabilitiesCodec nesUserActionsCapabilitiesCodec =
    NesUserActionsCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request parameters for creating a new session.
///
/// See protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/session-setup#creating-a-session)
final class NewSessionRequest implements AcpJsonEncodable {
  /// Creates a NewSessionRequest value.
  NewSessionRequest({
    required this.cwd,
    required List<McpServer> mcpServers,
    List<String>? additionalDirectories,
    this.meta,
  }) : mcpServers = List<McpServer>.unmodifiable(mcpServers),
       additionalDirectories = additionalDirectories == null
           ? null
           : List<String>.unmodifiable(additionalDirectories);

  /// The working directory for this session. Must be an absolute path.
  final String cwd;

  /// Additional workspace roots for this session. Each path must be absolute.
  ///
  /// These expand the session's filesystem scope without changing `cwd`, which
  /// remains the base for relative paths. When omitted or empty, no
  /// additional roots are activated for the new session.
  final List<String>? additionalDirectories;

  /// List of MCP (Model Context Protocol) servers the agent should connect to.
  final List<McpServer> mcpServers;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NewSessionRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NewSessionRequest(
      cwd: decoder.required('cwd', (value) => decodeAcpString(value)),
      additionalDirectories: decoder.listSkippingInvalid(
        'additionalDirectories',
        (value) => decodeAcpString(value),
        isRequired: false,
      ),
      mcpServers: decoder.listSkippingInvalid(
        'mcpServers',
        (value) => mcpServerCodec.decode(value),
        isRequired: true,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NewSessionRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['cwd'] = cwd;
    if (additionalDirectories != null) {
      result['additionalDirectories'] = <Object?>[
        for (final item in additionalDirectories!) item,
      ];
    }
    result['mcpServers'] = <Object?>[
      for (final item in mcpServers) mcpServerCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NewSessionRequest].
final class NewSessionRequestCodec implements AcpCodec<NewSessionRequest> {
  /// Creates the codec.
  const NewSessionRequestCodec();

  @override
  NewSessionRequest decode(Object? value) =>
      NewSessionRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(NewSessionRequest value) => value.toJson();
}

/// Shared codec for [NewSessionRequest].
const NewSessionRequestCodec newSessionRequestCodec = NewSessionRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Response from creating a new session.
///
/// See protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/session-setup#creating-a-session)
final class NewSessionResponse implements AcpJsonEncodable {
  /// Creates a NewSessionResponse value.
  NewSessionResponse({
    required this.sessionId,
    this.modes,
    List<SessionConfigOption>? configOptions,
    this.meta,
  }) : configOptions = configOptions == null
           ? null
           : List<SessionConfigOption>.unmodifiable(configOptions);

  /// Unique identifier for the created session.
  ///
  /// Used in all subsequent requests for this conversation.
  final SessionId sessionId;

  /// Initial mode state if supported by the Agent
  ///
  /// See protocol docs: [Session Modes](https://agentclientprotocol.com/protocol/session-modes)
  final SessionModeState? modes;

  /// Initial session configuration options if supported by the Agent.
  final List<SessionConfigOption>? configOptions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NewSessionResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NewSessionResponse(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      modes: decoder
          .optionalOnError(
            'modes',
            (value) => sessionModeStateCodec.decode(value),
          )
          .valueOrNull,
      configOptions: decoder.listSkippingInvalid(
        'configOptions',
        (value) => sessionConfigOptionCodec.decode(value),
        isRequired: false,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NewSessionResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    if (modes != null) {
      result['modes'] = sessionModeStateCodec.encode(modes!);
    }
    if (configOptions != null) {
      result['configOptions'] = <Object?>[
        for (final item in configOptions!)
          sessionConfigOptionCodec.encode(item),
      ];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NewSessionResponse].
final class NewSessionResponseCodec implements AcpCodec<NewSessionResponse> {
  /// Creates the codec.
  const NewSessionResponseCodec();

  @override
  NewSessionResponse decode(Object? value) =>
      NewSessionResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(NewSessionResponse value) => value.toJson();
}

/// Shared codec for [NewSessionResponse].
const NewSessionResponseCodec newSessionResponseCodec =
    NewSessionResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Schema for number (floating-point) properties in an elicitation form.
final class NumberPropertySchema implements AcpJsonEncodable {
  /// Creates a NumberPropertySchema value.
  NumberPropertySchema({
    this.title,
    this.description,
    this.minimum,
    this.maximum,
    this.defaultValue,
    this.meta,
  });

  /// Optional title for the property.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no title is provided.
  final String? title;

  /// Human-readable description.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no description is provided.
  final String? description;

  /// Minimum value (inclusive).
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no inclusive lower bound.
  final num? minimum;

  /// Maximum value (inclusive).
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no inclusive upper bound.
  final num? maximum;

  /// Default value.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no default value is provided.
  final num? defaultValue;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NumberPropertySchema> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NumberPropertySchema(
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      minimum: decoder.optional('minimum', (value) => decodeAcpNumber(value)),
      maximum: decoder.optional('maximum', (value) => decodeAcpNumber(value)),
      defaultValue: decoder
          .optionalOnError('default', (value) => decodeAcpNumber(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory NumberPropertySchema.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (title != null) {
      result['title'] = title!;
    }
    if (description != null) {
      result['description'] = description!;
    }
    if (minimum != null) {
      result['minimum'] = minimum!;
    }
    if (maximum != null) {
      result['maximum'] = maximum!;
    }
    if (defaultValue != null) {
      result['default'] = defaultValue!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [NumberPropertySchema].
final class NumberPropertySchemaCodec
    implements AcpCodec<NumberPropertySchema> {
  /// Creates the codec.
  const NumberPropertySchemaCodec();

  @override
  NumberPropertySchema decode(Object? value) =>
      NumberPropertySchema.fromJson(decodeAcpObject(value));

  @override
  Object encode(NumberPropertySchema value) => value.toJson();
}

/// Shared codec for [NumberPropertySchema].
const NumberPropertySchemaCodec numberPropertySchemaCodec =
    NumberPropertySchemaCodec();

PermissionOptionId _decodePermissionOptionOptionId(Object? value) =>
    permissionOptionIdCodec.decode(value);
Object? _encodePermissionOptionOptionId(PermissionOptionId value) =>
    permissionOptionIdCodec.encode(value);

String _decodePermissionOptionName(Object? value) => decodeAcpString(value);
Object? _encodePermissionOptionName(String value) => value;

PermissionOptionKind _decodePermissionOptionKind(Object? value) =>
    permissionOptionKindCodec.decode(value);
Object? _encodePermissionOptionKind(PermissionOptionKind value) =>
    permissionOptionKindCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// An option presented to the user when requesting permission.
final class PermissionOption implements AcpJsonEncodable {
  /// Creates a PermissionOption value.
  PermissionOption({
    required this.optionId,
    required this.name,
    required this.kind,
    this.meta,
  });

  /// Unique identifier for this permission option.
  @JsonKey(
    name: 'optionId',
    fromJson: _decodePermissionOptionOptionId,
    toJson: _encodePermissionOptionOptionId,
    includeIfNull: false,
    required: true,
  )
  final PermissionOptionId optionId;

  /// Human-readable label to display to the user.
  @JsonKey(
    name: 'name',
    fromJson: _decodePermissionOptionName,
    toJson: _encodePermissionOptionName,
    includeIfNull: false,
    required: true,
  )
  final String name;

  /// Hint about the nature of this permission option.
  @JsonKey(
    name: 'kind',
    fromJson: _decodePermissionOptionKind,
    toJson: _encodePermissionOptionKind,
    includeIfNull: false,
    required: true,
  )
  final PermissionOptionKind kind;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PermissionOption.fromJson(Map<String, Object?> json) =>
      _$PermissionOptionFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PermissionOptionToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PermissionOption].
final class PermissionOptionCodec implements AcpCodec<PermissionOption> {
  /// Creates the codec.
  const PermissionOptionCodec();

  @override
  PermissionOption decode(Object? value) =>
      PermissionOption.fromJson(decodeAcpObject(value));

  @override
  Object encode(PermissionOption value) => value.toJson();
}

/// Shared codec for [PermissionOption].
const PermissionOptionCodec permissionOptionCodec = PermissionOptionCodec();

/// Unique identifier for a permission option.
final class PermissionOptionId implements AcpJsonEncodable {
  /// Validates and creates a PermissionOptionId value.
  factory PermissionOptionId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return PermissionOptionId._(value);
  }

  const PermissionOptionId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory PermissionOptionId.fromJson(Object? json) =>
      PermissionOptionId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is PermissionOptionId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [PermissionOptionId].
final class PermissionOptionIdCodec implements AcpCodec<PermissionOptionId> {
  /// Creates the codec.
  const PermissionOptionIdCodec();

  @override
  PermissionOptionId decode(Object? value) =>
      PermissionOptionId.fromJson(value);

  @override
  String encode(PermissionOptionId value) => value.toJson();
}

/// Shared codec for [PermissionOptionId].
const PermissionOptionIdCodec permissionOptionIdCodec =
    PermissionOptionIdCodec();

/// The type of permission option being presented to the user.
///
/// Helps clients choose appropriate icons and UI treatment.
final class PermissionOptionKind implements AcpJsonEncodable {
  /// Validates and creates a PermissionOptionKind value.
  factory PermissionOptionKind(String value) {
    if (!const <String>{
      'allow_once',
      'allow_always',
      'reject_once',
      'reject_always',
    }.contains(value)) {
      throw FormatException('Unknown PermissionOptionKind: $value');
    }
    return PermissionOptionKind._(value);
  }

  const PermissionOptionKind._(this.value);

  /// The exact wire string.
  final String value;

  /// The `allow_once` schema value.
  static const PermissionOptionKind allowOnce = PermissionOptionKind._(
    'allow_once',
  );

  /// The `allow_always` schema value.
  static const PermissionOptionKind allowAlways = PermissionOptionKind._(
    'allow_always',
  );

  /// The `reject_once` schema value.
  static const PermissionOptionKind rejectOnce = PermissionOptionKind._(
    'reject_once',
  );

  /// The `reject_always` schema value.
  static const PermissionOptionKind rejectAlways = PermissionOptionKind._(
    'reject_always',
  );

  /// Decodes a wire string.
  factory PermissionOptionKind.fromJson(Object? json) =>
      PermissionOptionKind(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is PermissionOptionKind && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [PermissionOptionKind].
final class PermissionOptionKindCodec
    implements AcpCodec<PermissionOptionKind> {
  /// Creates the codec.
  const PermissionOptionKindCodec();

  @override
  PermissionOptionKind decode(Object? value) =>
      PermissionOptionKind.fromJson(value);

  @override
  String encode(PermissionOptionKind value) => value.toJson();
}

/// Shared codec for [PermissionOptionKind].
const PermissionOptionKindCodec permissionOptionKindCodec =
    PermissionOptionKindCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// An execution plan for accomplishing complex tasks.
///
/// Plans consist of multiple entries representing individual tasks or goals.
/// Agents report plans to clients to provide visibility into their execution strategy.
/// Plans can evolve during execution as the agent discovers new requirements or completes tasks.
///
/// See protocol docs: [Agent Plan](https://agentclientprotocol.com/protocol/agent-plan)
final class Plan implements AcpJsonEncodable {
  /// Creates a Plan value.
  Plan({required List<PlanEntry> entries, this.meta})
    : entries = List<PlanEntry>.unmodifiable(entries);

  /// The list of tasks to be accomplished.
  ///
  /// When updating a plan, the agent must send a complete list of all entries
  /// with their current status. The client replaces the entire plan with each update.
  final List<PlanEntry> entries;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<Plan> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = Plan(
      entries: decoder.listSkippingInvalid(
        'entries',
        (value) => planEntryCodec.decode(value),
        isRequired: true,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory Plan.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['entries'] = <Object?>[
      for (final item in entries) planEntryCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Plan].
final class PlanCodec implements AcpCodec<Plan> {
  /// Creates the codec.
  const PlanCodec();

  @override
  Plan decode(Object? value) => Plan.fromJson(decodeAcpObject(value));

  @override
  Object encode(Plan value) => value.toJson();
}

/// Shared codec for [Plan].
const PlanCodec planCodec = PlanCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Capabilities for receiving `plan_update` and `plan_removed` session updates.
final class PlanCapabilities implements AcpJsonEncodable {
  /// Creates a PlanCapabilities value.
  PlanCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PlanCapabilities.fromJson(Map<String, Object?> json) =>
      _$PlanCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PlanCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PlanCapabilities].
final class PlanCapabilitiesCodec implements AcpCodec<PlanCapabilities> {
  /// Creates the codec.
  const PlanCapabilitiesCodec();

  @override
  PlanCapabilities decode(Object? value) =>
      PlanCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(PlanCapabilities value) => value.toJson();
}

/// Shared codec for [PlanCapabilities].
const PlanCapabilitiesCodec planCapabilitiesCodec = PlanCapabilitiesCodec();

String _decodePlanEntryContent(Object? value) => decodeAcpString(value);
Object? _encodePlanEntryContent(String value) => value;

PlanEntryPriority _decodePlanEntryPriority(Object? value) =>
    planEntryPriorityCodec.decode(value);
Object? _encodePlanEntryPriority(PlanEntryPriority value) =>
    planEntryPriorityCodec.encode(value);

PlanEntryStatus _decodePlanEntryStatus(Object? value) =>
    planEntryStatusCodec.decode(value);
Object? _encodePlanEntryStatus(PlanEntryStatus value) =>
    planEntryStatusCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A single entry in the execution plan.
///
/// Represents a task or goal that the assistant intends to accomplish
/// as part of fulfilling the user's request.
/// See protocol docs: [Plan Entries](https://agentclientprotocol.com/protocol/agent-plan#plan-entries)
final class PlanEntry implements AcpJsonEncodable {
  /// Creates a PlanEntry value.
  PlanEntry({
    required this.content,
    required this.priority,
    required this.status,
    this.meta,
  });

  /// Human-readable description of what this task aims to accomplish.
  @JsonKey(
    name: 'content',
    fromJson: _decodePlanEntryContent,
    toJson: _encodePlanEntryContent,
    includeIfNull: false,
    required: true,
  )
  final String content;

  /// The relative importance of this task.
  /// Used to indicate which tasks are most critical to the overall goal.
  @JsonKey(
    name: 'priority',
    fromJson: _decodePlanEntryPriority,
    toJson: _encodePlanEntryPriority,
    includeIfNull: false,
    required: true,
  )
  final PlanEntryPriority priority;

  /// Current execution status of this task.
  @JsonKey(
    name: 'status',
    fromJson: _decodePlanEntryStatus,
    toJson: _encodePlanEntryStatus,
    includeIfNull: false,
    required: true,
  )
  final PlanEntryStatus status;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PlanEntry.fromJson(Map<String, Object?> json) =>
      _$PlanEntryFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PlanEntryToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PlanEntry].
final class PlanEntryCodec implements AcpCodec<PlanEntry> {
  /// Creates the codec.
  const PlanEntryCodec();

  @override
  PlanEntry decode(Object? value) => PlanEntry.fromJson(decodeAcpObject(value));

  @override
  Object encode(PlanEntry value) => value.toJson();
}

/// Shared codec for [PlanEntry].
const PlanEntryCodec planEntryCodec = PlanEntryCodec();

/// Priority levels for plan entries.
///
/// Used to indicate the relative importance or urgency of different
/// tasks in the execution plan.
/// See protocol docs: [Plan Entries](https://agentclientprotocol.com/protocol/agent-plan#plan-entries)
final class PlanEntryPriority implements AcpJsonEncodable {
  /// Validates and creates a PlanEntryPriority value.
  factory PlanEntryPriority(String value) {
    if (!const <String>{'high', 'medium', 'low'}.contains(value)) {
      throw FormatException('Unknown PlanEntryPriority: $value');
    }
    return PlanEntryPriority._(value);
  }

  const PlanEntryPriority._(this.value);

  /// The exact wire string.
  final String value;

  /// The `high` schema value.
  static const PlanEntryPriority high = PlanEntryPriority._('high');

  /// The `medium` schema value.
  static const PlanEntryPriority medium = PlanEntryPriority._('medium');

  /// The `low` schema value.
  static const PlanEntryPriority low = PlanEntryPriority._('low');

  /// Decodes a wire string.
  factory PlanEntryPriority.fromJson(Object? json) =>
      PlanEntryPriority(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is PlanEntryPriority && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [PlanEntryPriority].
final class PlanEntryPriorityCodec implements AcpCodec<PlanEntryPriority> {
  /// Creates the codec.
  const PlanEntryPriorityCodec();

  @override
  PlanEntryPriority decode(Object? value) => PlanEntryPriority.fromJson(value);

  @override
  String encode(PlanEntryPriority value) => value.toJson();
}

/// Shared codec for [PlanEntryPriority].
const PlanEntryPriorityCodec planEntryPriorityCodec = PlanEntryPriorityCodec();

/// Status of a plan entry in the execution flow.
///
/// Tracks the lifecycle of each task from planning through completion.
/// See protocol docs: [Plan Entries](https://agentclientprotocol.com/protocol/agent-plan#plan-entries)
final class PlanEntryStatus implements AcpJsonEncodable {
  /// Validates and creates a PlanEntryStatus value.
  factory PlanEntryStatus(String value) {
    if (!const <String>{
      'pending',
      'in_progress',
      'completed',
    }.contains(value)) {
      throw FormatException('Unknown PlanEntryStatus: $value');
    }
    return PlanEntryStatus._(value);
  }

  const PlanEntryStatus._(this.value);

  /// The exact wire string.
  final String value;

  /// The `pending` schema value.
  static const PlanEntryStatus pending = PlanEntryStatus._('pending');

  /// The `in_progress` schema value.
  static const PlanEntryStatus inProgress = PlanEntryStatus._('in_progress');

  /// The `completed` schema value.
  static const PlanEntryStatus completed = PlanEntryStatus._('completed');

  /// Decodes a wire string.
  factory PlanEntryStatus.fromJson(Object? json) =>
      PlanEntryStatus(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is PlanEntryStatus && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [PlanEntryStatus].
final class PlanEntryStatusCodec implements AcpCodec<PlanEntryStatus> {
  /// Creates the codec.
  const PlanEntryStatusCodec();

  @override
  PlanEntryStatus decode(Object? value) => PlanEntryStatus.fromJson(value);

  @override
  String encode(PlanEntryStatus value) => value.toJson();
}

/// Shared codec for [PlanEntryStatus].
const PlanEntryStatusCodec planEntryStatusCodec = PlanEntryStatusCodec();

PlanId _decodePlanFilePlanId(Object? value) => planIdCodec.decode(value);
Object? _encodePlanFilePlanId(PlanId value) => planIdCodec.encode(value);

String _decodePlanFileUri(Object? value) => decodeAcpString(value);
Object? _encodePlanFileUri(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// A plan represented by a file URI.
final class PlanFile implements AcpJsonEncodable {
  /// Creates a PlanFile value.
  PlanFile({required this.planId, required this.uri, this.meta});

  /// The plan ID to update.
  @JsonKey(
    name: 'planId',
    fromJson: _decodePlanFilePlanId,
    toJson: _encodePlanFilePlanId,
    includeIfNull: false,
    required: true,
  )
  final PlanId planId;

  /// The URI of the file containing the plan.
  @JsonKey(
    name: 'uri',
    fromJson: _decodePlanFileUri,
    toJson: _encodePlanFileUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PlanFile.fromJson(Map<String, Object?> json) =>
      _$PlanFileFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PlanFileToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PlanFile].
final class PlanFileCodec implements AcpCodec<PlanFile> {
  /// Creates the codec.
  const PlanFileCodec();

  @override
  PlanFile decode(Object? value) => PlanFile.fromJson(decodeAcpObject(value));

  @override
  Object encode(PlanFile value) => value.toJson();
}

/// Shared codec for [PlanFile].
const PlanFileCodec planFileCodec = PlanFileCodec();

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Unique identifier for a plan within a session.
final class PlanId implements AcpJsonEncodable {
  /// Validates and creates a PlanId value.
  factory PlanId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return PlanId._(value);
  }

  const PlanId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory PlanId.fromJson(Object? json) => PlanId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is PlanId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [PlanId].
final class PlanIdCodec implements AcpCodec<PlanId> {
  /// Creates the codec.
  const PlanIdCodec();

  @override
  PlanId decode(Object? value) => PlanId.fromJson(value);

  @override
  String encode(PlanId value) => value.toJson();
}

/// Shared codec for [PlanId].
const PlanIdCodec planIdCodec = PlanIdCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// A plan represented as structured entries.
final class PlanItems implements AcpJsonEncodable {
  /// Creates a PlanItems value.
  PlanItems({required this.planId, required List<PlanEntry> entries, this.meta})
    : entries = List<PlanEntry>.unmodifiable(entries);

  /// The plan ID to update.
  final PlanId planId;

  /// The list of tasks to be accomplished.
  ///
  /// When updating an item-based plan, the agent must send a complete list of all entries
  /// with their current status. The client replaces that plan with each update.
  final List<PlanEntry> entries;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<PlanItems> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = PlanItems(
      planId: decoder.required('planId', (value) => planIdCodec.decode(value)),
      entries: decoder.listSkippingInvalid(
        'entries',
        (value) => planEntryCodec.decode(value),
        isRequired: true,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory PlanItems.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['planId'] = planIdCodec.encode(planId);
    result['entries'] = <Object?>[
      for (final item in entries) planEntryCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PlanItems].
final class PlanItemsCodec implements AcpCodec<PlanItems> {
  /// Creates the codec.
  const PlanItemsCodec();

  @override
  PlanItems decode(Object? value) => PlanItems.fromJson(decodeAcpObject(value));

  @override
  Object encode(PlanItems value) => value.toJson();
}

/// Shared codec for [PlanItems].
const PlanItemsCodec planItemsCodec = PlanItemsCodec();

PlanId _decodePlanMarkdownPlanId(Object? value) => planIdCodec.decode(value);
Object? _encodePlanMarkdownPlanId(PlanId value) => planIdCodec.encode(value);

String _decodePlanMarkdownContent(Object? value) => decodeAcpString(value);
Object? _encodePlanMarkdownContent(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// A plan represented as raw markdown content.
final class PlanMarkdown implements AcpJsonEncodable {
  /// Creates a PlanMarkdown value.
  PlanMarkdown({required this.planId, required this.content, this.meta});

  /// The plan ID to update.
  @JsonKey(
    name: 'planId',
    fromJson: _decodePlanMarkdownPlanId,
    toJson: _encodePlanMarkdownPlanId,
    includeIfNull: false,
    required: true,
  )
  final PlanId planId;

  /// Markdown content for the plan.
  @JsonKey(
    name: 'content',
    fromJson: _decodePlanMarkdownContent,
    toJson: _encodePlanMarkdownContent,
    includeIfNull: false,
    required: true,
  )
  final String content;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PlanMarkdown.fromJson(Map<String, Object?> json) =>
      _$PlanMarkdownFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PlanMarkdownToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PlanMarkdown].
final class PlanMarkdownCodec implements AcpCodec<PlanMarkdown> {
  /// Creates the codec.
  const PlanMarkdownCodec();

  @override
  PlanMarkdown decode(Object? value) =>
      PlanMarkdown.fromJson(decodeAcpObject(value));

  @override
  Object encode(PlanMarkdown value) => value.toJson();
}

/// Shared codec for [PlanMarkdown].
const PlanMarkdownCodec planMarkdownCodec = PlanMarkdownCodec();

PlanId _decodePlanRemovedPlanId(Object? value) => planIdCodec.decode(value);
Object? _encodePlanRemovedPlanId(PlanId value) => planIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Removal notice for a plan identified by ID.
final class PlanRemoved implements AcpJsonEncodable {
  /// Creates a PlanRemoved value.
  PlanRemoved({required this.planId, this.meta});

  /// The plan ID to remove.
  @JsonKey(
    name: 'planId',
    fromJson: _decodePlanRemovedPlanId,
    toJson: _encodePlanRemovedPlanId,
    includeIfNull: false,
    required: true,
  )
  final PlanId planId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PlanRemoved.fromJson(Map<String, Object?> json) =>
      _$PlanRemovedFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PlanRemovedToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PlanRemoved].
final class PlanRemovedCodec implements AcpCodec<PlanRemoved> {
  /// Creates the codec.
  const PlanRemovedCodec();

  @override
  PlanRemoved decode(Object? value) =>
      PlanRemoved.fromJson(decodeAcpObject(value));

  @override
  Object encode(PlanRemoved value) => value.toJson();
}

/// Shared codec for [PlanRemoved].
const PlanRemovedCodec planRemovedCodec = PlanRemovedCodec();

PlanUpdateContent _decodePlanUpdatePlan(Object? value) =>
    planUpdateContentCodec.decode(value);
Object? _encodePlanUpdatePlan(PlanUpdateContent value) =>
    planUpdateContentCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// A content update for a plan identified by ID.
final class PlanUpdate implements AcpJsonEncodable {
  /// Creates a PlanUpdate value.
  PlanUpdate({required this.plan, this.meta});

  /// The updated plan content.
  @JsonKey(
    name: 'plan',
    fromJson: _decodePlanUpdatePlan,
    toJson: _encodePlanUpdatePlan,
    includeIfNull: false,
    required: true,
  )
  final PlanUpdateContent plan;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PlanUpdate.fromJson(Map<String, Object?> json) =>
      _$PlanUpdateFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PlanUpdateToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PlanUpdate].
final class PlanUpdateCodec implements AcpCodec<PlanUpdate> {
  /// Creates the codec.
  const PlanUpdateCodec();

  @override
  PlanUpdate decode(Object? value) =>
      PlanUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(PlanUpdate value) => value.toJson();
}

/// Shared codec for [PlanUpdate].
const PlanUpdateCodec planUpdateCodec = PlanUpdateCodec();

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Updated content for a plan.
sealed class PlanUpdateContent implements AcpJsonEncodable {
  const PlanUpdateContent();

  /// Decodes the tagged union.
  factory PlanUpdateContent.fromJson(Object? json) =>
      planUpdateContentCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// Structured plan entries.
final class PlanUpdateContentItems extends PlanUpdateContent {
  /// Creates this known tagged-union variant.
  const PlanUpdateContentItems(this.value);

  /// The typed variant payload.
  final PlanItems value;

  @override
  String get discriminator => 'items';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(planItemsCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A URI pointing to a file containing the plan.
final class PlanUpdateContentFile extends PlanUpdateContent {
  /// Creates this known tagged-union variant.
  const PlanUpdateContentFile(this.value);

  /// The typed variant payload.
  final PlanFile value;

  @override
  String get discriminator => 'file';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(planFileCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Raw markdown content for the plan.
final class PlanUpdateContentMarkdown extends PlanUpdateContent {
  /// Creates this known tagged-union variant.
  const PlanUpdateContentMarkdown(this.value);

  /// The typed variant payload.
  final PlanMarkdown value;

  @override
  String get discriminator => 'markdown';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(planMarkdownCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Codec for [PlanUpdateContent].
final class PlanUpdateContentCodec implements AcpCodec<PlanUpdateContent> {
  /// Creates the codec.
  const PlanUpdateContentCodec();

  @override
  PlanUpdateContent decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'items':
        return PlanUpdateContentItems(planItemsCodec.decode(payload));
      case 'file':
        return PlanUpdateContentFile(planFileCodec.decode(payload));
      case 'markdown':
        return PlanUpdateContentMarkdown(planMarkdownCodec.decode(payload));
      default:
        throw FormatException('Unknown PlanUpdateContent tag: $tag');
    }
  }

  @override
  Object encode(PlanUpdateContent value) => value.toJson();
}

/// Shared codec for [PlanUpdateContent].
const PlanUpdateContentCodec planUpdateContentCodec = PlanUpdateContentCodec();

int _decodePositionLine(Object? value) =>
    decodeAcpIntegerInRange(value, 0, 4294967295);
Object? _encodePositionLine(int value) => value;

int _decodePositionCharacter(Object? value) =>
    decodeAcpIntegerInRange(value, 0, 4294967295);
Object? _encodePositionCharacter(int value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A zero-based position in a text document.
///
/// The meaning of `character` depends on the negotiated position encoding.
final class Position implements AcpJsonEncodable {
  /// Creates a Position value.
  Position({required this.line, required this.character, this.meta});

  /// Zero-based line number.
  @JsonKey(
    name: 'line',
    fromJson: _decodePositionLine,
    toJson: _encodePositionLine,
    includeIfNull: false,
    required: true,
  )
  final int line;

  /// Zero-based character offset (encoding-dependent).
  @JsonKey(
    name: 'character',
    fromJson: _decodePositionCharacter,
    toJson: _encodePositionCharacter,
    includeIfNull: false,
    required: true,
  )
  final int character;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory Position.fromJson(Map<String, Object?> json) =>
      _$PositionFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PositionToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Position].
final class PositionCodec implements AcpCodec<Position> {
  /// Creates the codec.
  const PositionCodec();

  @override
  Position decode(Object? value) => Position.fromJson(decodeAcpObject(value));

  @override
  Object encode(Position value) => value.toJson();
}

/// Shared codec for [Position].
const PositionCodec positionCodec = PositionCodec();

/// The encoding used for character offsets in positions.
///
/// Follows the same conventions as LSP 3.17. The default is UTF-16.
final class PositionEncodingKind implements AcpJsonEncodable {
  /// Validates and creates a PositionEncodingKind value.
  factory PositionEncodingKind(String value) {
    if (!const <String>{'utf-16', 'utf-32', 'utf-8'}.contains(value)) {
      throw FormatException('Unknown PositionEncodingKind: $value');
    }
    return PositionEncodingKind._(value);
  }

  const PositionEncodingKind._(this.value);

  /// The exact wire string.
  final String value;

  /// The `utf-16` schema value.
  static const PositionEncodingKind utf16 = PositionEncodingKind._('utf-16');

  /// The `utf-32` schema value.
  static const PositionEncodingKind utf32 = PositionEncodingKind._('utf-32');

  /// The `utf-8` schema value.
  static const PositionEncodingKind utf8 = PositionEncodingKind._('utf-8');

  /// Decodes a wire string.
  factory PositionEncodingKind.fromJson(Object? json) =>
      PositionEncodingKind(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is PositionEncodingKind && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [PositionEncodingKind].
final class PositionEncodingKindCodec
    implements AcpCodec<PositionEncodingKind> {
  /// Creates the codec.
  const PositionEncodingKindCodec();

  @override
  PositionEncodingKind decode(Object? value) =>
      PositionEncodingKind.fromJson(value);

  @override
  String encode(PositionEncodingKind value) => value.toJson();
}

/// Shared codec for [PositionEncodingKind].
const PositionEncodingKindCodec positionEncodingKindCodec =
    PositionEncodingKindCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Prompt capabilities supported by the agent in `session/prompt` requests.
///
/// Baseline agent functionality requires support for `ContentBlock::Text`
/// and `ContentBlock::ResourceLink` in prompt requests.
///
/// Other variants must be explicitly opted in to.
/// Capabilities for different types of content in prompt requests.
///
final class PromptCapabilities implements AcpJsonEncodable {
  /// Creates a PromptCapabilities value.
  PromptCapabilities({
    required this.image,
    required this.audio,
    required this.embeddedContext,
    this.meta,
  });

  /// Agent supports `ContentBlock::Image`.
  final bool image;

  /// Agent supports `ContentBlock::Audio`.
  final bool audio;

  /// Agent supports embedded context in `session/prompt` requests.
  ///
  /// When enabled, the Client is allowed to include `ContentBlock::Resource`
  /// in prompt requests for pieces of context that are referenced in the message.
  final bool embeddedContext;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<PromptCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = PromptCapabilities(
      image: decoder.defaultOnError(
        'image',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      audio: decoder.defaultOnError(
        'audio',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      embeddedContext: decoder.defaultOnError(
        'embeddedContext',
        decodeAcpBoolean(false),
        (value) => decodeAcpBoolean(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory PromptCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['image'] = image;
    result['audio'] = audio;
    result['embeddedContext'] = embeddedContext;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PromptCapabilities].
final class PromptCapabilitiesCodec implements AcpCodec<PromptCapabilities> {
  /// Creates the codec.
  const PromptCapabilitiesCodec();

  @override
  PromptCapabilities decode(Object? value) =>
      PromptCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(PromptCapabilities value) => value.toJson();
}

/// Shared codec for [PromptCapabilities].
const PromptCapabilitiesCodec promptCapabilitiesCodec =
    PromptCapabilitiesCodec();

SessionId _decodePromptRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodePromptRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

List<ContentBlock> _decodePromptRequestPrompt(Object? value) =>
    List<ContentBlock>.unmodifiable(
      (value as List<Object?>).map((item) => contentBlockCodec.decode(item)),
    );
Object? _encodePromptRequestPrompt(List<ContentBlock> value) => <Object?>[
  for (final item in value) contentBlockCodec.encode(item),
];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for sending a user prompt to the agent.
///
/// Contains the user's message and any additional context.
///
/// See protocol docs: [User Message](https://agentclientprotocol.com/protocol/prompt-turn#1-user-message)
final class PromptRequest implements AcpJsonEncodable {
  /// Creates a PromptRequest value.
  PromptRequest({
    required this.sessionId,
    required List<ContentBlock> prompt,
    this.meta,
  }) : prompt = List<ContentBlock>.unmodifiable(prompt);

  /// The ID of the session to send this user message to
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodePromptRequestSessionId,
    toJson: _encodePromptRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The blocks of content that compose the user's message.
  ///
  /// As a baseline, the Agent MUST support `ContentBlock::Text` and `ContentBlock::ResourceLink`,
  /// while other variants are optionally enabled via `PromptCapabilities`.
  ///
  /// The Client MUST adapt its interface according to `PromptCapabilities`.
  ///
  /// The client MAY include referenced pieces of context as either
  @JsonKey(
    name: 'prompt',
    fromJson: _decodePromptRequestPrompt,
    toJson: _encodePromptRequestPrompt,
    includeIfNull: false,
    required: true,
  )
  final List<ContentBlock> prompt;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PromptRequest.fromJson(Map<String, Object?> json) =>
      _$PromptRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PromptRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PromptRequest].
final class PromptRequestCodec implements AcpCodec<PromptRequest> {
  /// Creates the codec.
  const PromptRequestCodec();

  @override
  PromptRequest decode(Object? value) =>
      PromptRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(PromptRequest value) => value.toJson();
}

/// Shared codec for [PromptRequest].
const PromptRequestCodec promptRequestCodec = PromptRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Response from processing a user prompt.
///
/// See protocol docs: [Check for Completion](https://agentclientprotocol.com/protocol/prompt-turn#4-check-for-completion)
final class PromptResponse implements AcpJsonEncodable {
  /// Creates a PromptResponse value.
  PromptResponse({required this.stopReason, this.usage, this.meta});

  /// Indicates why the agent stopped processing the turn.
  final StopReason stopReason;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// Token usage for this turn (optional).
  final Usage? usage;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<PromptResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = PromptResponse(
      stopReason: decoder.required(
        'stopReason',
        (value) => stopReasonCodec.decode(value),
      ),
      usage: decoder
          .optionalOnError('usage', (value) => usageCodec.decode(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory PromptResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['stopReason'] = stopReasonCodec.encode(stopReason);
    if (usage != null) {
      result['usage'] = usageCodec.encode(usage!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PromptResponse].
final class PromptResponseCodec implements AcpCodec<PromptResponse> {
  /// Creates the codec.
  const PromptResponseCodec();

  @override
  PromptResponse decode(Object? value) =>
      PromptResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(PromptResponse value) => value.toJson();
}

/// Shared codec for [PromptResponse].
const PromptResponseCodec promptResponseCodec = PromptResponseCodec();

/// Protocol version identifier.
///
/// This version is only bumped for breaking changes.
/// Non-breaking changes should be introduced via capabilities.
final class ProtocolVersion implements AcpJsonEncodable {
  /// Validates and creates a ProtocolVersion value.
  factory ProtocolVersion(int value) {
    if (value < 0) {
      throw const FormatException('Number is below the schema minimum');
    }
    if (value > 65535) {
      throw const FormatException('Number exceeds the schema maximum');
    }
    return ProtocolVersion._(value);
  }

  const ProtocolVersion._(this.value);

  /// The exact wire number.
  final int value;

  /// Decodes a wire number.
  factory ProtocolVersion.fromJson(Object? json) =>
      ProtocolVersion(decodeAcpInteger(json));

  /// Encodes the wire number.
  int toJson() => value;

  @override
  AcpJsonNumber toAcpJson() => AcpJsonNumber(value);

  @override
  bool operator ==(Object other) =>
      other is ProtocolVersion && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [ProtocolVersion].
final class ProtocolVersionCodec implements AcpCodec<ProtocolVersion> {
  /// Creates the codec.
  const ProtocolVersionCodec();

  @override
  ProtocolVersion decode(Object? value) => ProtocolVersion.fromJson(value);

  @override
  int encode(ProtocolVersion value) => value.toJson();
}

/// Shared codec for [ProtocolVersion].
const ProtocolVersionCodec protocolVersionCodec = ProtocolVersionCodec();

LlmProtocol _decodeProviderCurrentConfigApiType(Object? value) =>
    llmProtocolCodec.decode(value);
Object? _encodeProviderCurrentConfigApiType(LlmProtocol value) =>
    llmProtocolCodec.encode(value);

String _decodeProviderCurrentConfigBaseUrl(Object? value) =>
    decodeAcpString(value);
Object? _encodeProviderCurrentConfigBaseUrl(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Current effective non-secret routing configuration for a provider.
final class ProviderCurrentConfig implements AcpJsonEncodable {
  /// Creates a ProviderCurrentConfig value.
  ProviderCurrentConfig({
    required this.apiType,
    required this.baseUrl,
    this.meta,
  });

  /// Protocol currently used by this provider.
  @JsonKey(
    name: 'apiType',
    fromJson: _decodeProviderCurrentConfigApiType,
    toJson: _encodeProviderCurrentConfigApiType,
    includeIfNull: false,
    required: true,
  )
  final LlmProtocol apiType;

  /// Base URL currently used by this provider.
  @JsonKey(
    name: 'baseUrl',
    fromJson: _decodeProviderCurrentConfigBaseUrl,
    toJson: _encodeProviderCurrentConfigBaseUrl,
    includeIfNull: false,
    required: true,
  )
  final String baseUrl;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ProviderCurrentConfig.fromJson(Map<String, Object?> json) =>
      _$ProviderCurrentConfigFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ProviderCurrentConfigToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ProviderCurrentConfig].
final class ProviderCurrentConfigCodec
    implements AcpCodec<ProviderCurrentConfig> {
  /// Creates the codec.
  const ProviderCurrentConfigCodec();

  @override
  ProviderCurrentConfig decode(Object? value) =>
      ProviderCurrentConfig.fromJson(decodeAcpObject(value));

  @override
  Object encode(ProviderCurrentConfig value) => value.toJson();
}

/// Shared codec for [ProviderCurrentConfig].
const ProviderCurrentConfigCodec providerCurrentConfigCodec =
    ProviderCurrentConfigCodec();

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Unique identifier for a configurable LLM provider.
final class ProviderId implements AcpJsonEncodable {
  /// Validates and creates a ProviderId value.
  factory ProviderId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return ProviderId._(value);
  }

  const ProviderId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory ProviderId.fromJson(Object? json) =>
      ProviderId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is ProviderId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [ProviderId].
final class ProviderIdCodec implements AcpCodec<ProviderId> {
  /// Creates the codec.
  const ProviderIdCodec();

  @override
  ProviderId decode(Object? value) => ProviderId.fromJson(value);

  @override
  String encode(ProviderId value) => value.toJson();
}

/// Shared codec for [ProviderId].
const ProviderIdCodec providerIdCodec = ProviderIdCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Information about a configurable LLM provider.
final class ProviderInfo implements AcpJsonEncodable {
  /// Creates a ProviderInfo value.
  ProviderInfo({
    required this.providerId,
    required List<LlmProtocol> supported,
    required this.requiredValue,
    this.current,
    this.meta,
  }) : supported = List<LlmProtocol>.unmodifiable(supported);

  /// Provider identifier, for example "main" or "openai".
  final ProviderId providerId;

  /// Supported protocol types for this provider.
  final List<LlmProtocol> supported;

  /// Whether this provider is mandatory and cannot be disabled via `providers/disable`.
  /// If true, clients must not call `providers/disable` for this provider ID.
  final bool requiredValue;

  /// Current effective non-secret routing config.
  /// Null or omitted means provider is disabled.
  final ProviderCurrentConfig? current;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ProviderInfo> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ProviderInfo(
      providerId: decoder.required(
        'providerId',
        (value) => providerIdCodec.decode(value),
      ),
      supported: decoder.listSkippingInvalid(
        'supported',
        (value) => llmProtocolCodec.decode(value),
        isRequired: true,
      ),
      requiredValue: decoder.required(
        'required',
        (value) => decodeAcpBoolean(value),
      ),
      current: decoder.optional(
        'current',
        (value) => providerCurrentConfigCodec.decode(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ProviderInfo.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['providerId'] = providerIdCodec.encode(providerId);
    result['supported'] = <Object?>[
      for (final item in supported) llmProtocolCodec.encode(item),
    ];
    result['required'] = requiredValue;
    if (current != null) {
      result['current'] = providerCurrentConfigCodec.encode(current!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ProviderInfo].
final class ProviderInfoCodec implements AcpCodec<ProviderInfo> {
  /// Creates the codec.
  const ProviderInfoCodec();

  @override
  ProviderInfo decode(Object? value) =>
      ProviderInfo.fromJson(decodeAcpObject(value));

  @override
  Object encode(ProviderInfo value) => value.toJson();
}

/// Shared codec for [ProviderInfo].
const ProviderInfoCodec providerInfoCodec = ProviderInfoCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Provider configuration capabilities supported by the agent.
///
/// Supplying `{}` means the agent supports provider configuration methods.
final class ProvidersCapabilities implements AcpJsonEncodable {
  /// Creates a ProvidersCapabilities value.
  ProvidersCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ProvidersCapabilities.fromJson(Map<String, Object?> json) =>
      _$ProvidersCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ProvidersCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ProvidersCapabilities].
final class ProvidersCapabilitiesCodec
    implements AcpCodec<ProvidersCapabilities> {
  /// Creates the codec.
  const ProvidersCapabilitiesCodec();

  @override
  ProvidersCapabilities decode(Object? value) =>
      ProvidersCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(ProvidersCapabilities value) => value.toJson();
}

/// Shared codec for [ProvidersCapabilities].
const ProvidersCapabilitiesCodec providersCapabilitiesCodec =
    ProvidersCapabilitiesCodec();

Position _decodeRangeStart(Object? value) => positionCodec.decode(value);
Object? _encodeRangeStart(Position value) => positionCodec.encode(value);

Position _decodeRangeEnd(Object? value) => positionCodec.decode(value);
Object? _encodeRangeEnd(Position value) => positionCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A range in a text document, expressed as start and end positions.
final class Range implements AcpJsonEncodable {
  /// Creates a Range value.
  Range({required this.start, required this.end, this.meta});

  /// The start position (inclusive).
  @JsonKey(
    name: 'start',
    fromJson: _decodeRangeStart,
    toJson: _encodeRangeStart,
    includeIfNull: false,
    required: true,
  )
  final Position start;

  /// The end position (exclusive).
  @JsonKey(
    name: 'end',
    fromJson: _decodeRangeEnd,
    toJson: _encodeRangeEnd,
    includeIfNull: false,
    required: true,
  )
  final Position end;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory Range.fromJson(Map<String, Object?> json) => _$RangeFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$RangeToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Range].
final class RangeCodec implements AcpCodec<Range> {
  /// Creates the codec.
  const RangeCodec();

  @override
  Range decode(Object? value) => Range.fromJson(decodeAcpObject(value));

  @override
  Object encode(Range value) => value.toJson();
}

/// Shared codec for [Range].
const RangeCodec rangeCodec = RangeCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request to read content from a text file.
///
/// Only available if the client supports the `fs.readTextFile` capability.
final class ReadTextFileRequest implements AcpJsonEncodable {
  /// Creates a ReadTextFileRequest value.
  ReadTextFileRequest({
    required this.sessionId,
    required this.path,
    this.line,
    this.limit,
    this.meta,
  });

  /// The session ID for this request.
  final SessionId sessionId;

  /// Absolute path to the file to read.
  final String path;

  /// Line number to start reading from (1-based).
  final int? line;

  /// Maximum number of lines to read.
  final int? limit;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ReadTextFileRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ReadTextFileRequest(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      path: decoder.required('path', (value) => decodeAcpString(value)),
      line: decoder
          .optionalOnError(
            'line',
            (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
          )
          .valueOrNull,
      limit: decoder
          .optionalOnError(
            'limit',
            (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ReadTextFileRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['path'] = path;
    if (line != null) {
      result['line'] = line!;
    }
    if (limit != null) {
      result['limit'] = limit!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ReadTextFileRequest].
final class ReadTextFileRequestCodec implements AcpCodec<ReadTextFileRequest> {
  /// Creates the codec.
  const ReadTextFileRequestCodec();

  @override
  ReadTextFileRequest decode(Object? value) =>
      ReadTextFileRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(ReadTextFileRequest value) => value.toJson();
}

/// Shared codec for [ReadTextFileRequest].
const ReadTextFileRequestCodec readTextFileRequestCodec =
    ReadTextFileRequestCodec();

String _decodeReadTextFileResponseContent(Object? value) =>
    decodeAcpString(value);
Object? _encodeReadTextFileResponseContent(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response containing the contents of a text file.
final class ReadTextFileResponse implements AcpJsonEncodable {
  /// Creates a ReadTextFileResponse value.
  ReadTextFileResponse({required this.content, this.meta});

  /// Content payload returned by this response.
  @JsonKey(
    name: 'content',
    fromJson: _decodeReadTextFileResponseContent,
    toJson: _encodeReadTextFileResponseContent,
    includeIfNull: false,
    required: true,
  )
  final String content;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ReadTextFileResponse.fromJson(Map<String, Object?> json) =>
      _$ReadTextFileResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ReadTextFileResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ReadTextFileResponse].
final class ReadTextFileResponseCodec
    implements AcpCodec<ReadTextFileResponse> {
  /// Creates the codec.
  const ReadTextFileResponseCodec();

  @override
  ReadTextFileResponse decode(Object? value) =>
      ReadTextFileResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(ReadTextFileResponse value) => value.toJson();
}

/// Shared codec for [ReadTextFileResponse].
const ReadTextFileResponseCodec readTextFileResponseCodec =
    ReadTextFileResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Notification sent when a suggestion is rejected.
final class RejectNesNotification implements AcpJsonEncodable {
  /// Creates a RejectNesNotification value.
  RejectNesNotification({
    required this.sessionId,
    required this.id,
    this.reason,
    this.meta,
  });

  /// The session ID for this notification.
  final SessionId sessionId;

  /// The ID of the rejected suggestion.
  final NesSuggestionId id;

  /// The reason for rejection.
  final NesRejectReason? reason;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<RejectNesNotification> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = RejectNesNotification(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      id: decoder.required('id', (value) => nesSuggestionIdCodec.decode(value)),
      reason: decoder
          .optionalOnError(
            'reason',
            (value) => nesRejectReasonCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory RejectNesNotification.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['id'] = nesSuggestionIdCodec.encode(id);
    if (reason != null) {
      result['reason'] = nesRejectReasonCodec.encode(reason!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [RejectNesNotification].
final class RejectNesNotificationCodec
    implements AcpCodec<RejectNesNotification> {
  /// Creates the codec.
  const RejectNesNotificationCodec();

  @override
  RejectNesNotification decode(Object? value) =>
      RejectNesNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(RejectNesNotification value) => value.toJson();
}

/// Shared codec for [RejectNesNotification].
const RejectNesNotificationCodec rejectNesNotificationCodec =
    RejectNesNotificationCodec();

SessionId _decodeReleaseTerminalRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeReleaseTerminalRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

TerminalId _decodeReleaseTerminalRequestTerminalId(Object? value) =>
    terminalIdCodec.decode(value);
Object? _encodeReleaseTerminalRequestTerminalId(TerminalId value) =>
    terminalIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request to release a terminal and free its resources.
final class ReleaseTerminalRequest implements AcpJsonEncodable {
  /// Creates a ReleaseTerminalRequest value.
  ReleaseTerminalRequest({
    required this.sessionId,
    required this.terminalId,
    this.meta,
  });

  /// The session ID for this request.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeReleaseTerminalRequestSessionId,
    toJson: _encodeReleaseTerminalRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The ID of the terminal to release.
  @JsonKey(
    name: 'terminalId',
    fromJson: _decodeReleaseTerminalRequestTerminalId,
    toJson: _encodeReleaseTerminalRequestTerminalId,
    includeIfNull: false,
    required: true,
  )
  final TerminalId terminalId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ReleaseTerminalRequest.fromJson(Map<String, Object?> json) =>
      _$ReleaseTerminalRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ReleaseTerminalRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ReleaseTerminalRequest].
final class ReleaseTerminalRequestCodec
    implements AcpCodec<ReleaseTerminalRequest> {
  /// Creates the codec.
  const ReleaseTerminalRequestCodec();

  @override
  ReleaseTerminalRequest decode(Object? value) =>
      ReleaseTerminalRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(ReleaseTerminalRequest value) => value.toJson();
}

/// Shared codec for [ReleaseTerminalRequest].
const ReleaseTerminalRequestCodec releaseTerminalRequestCodec =
    ReleaseTerminalRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to terminal/release method
final class ReleaseTerminalResponse implements AcpJsonEncodable {
  /// Creates a ReleaseTerminalResponse value.
  ReleaseTerminalResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ReleaseTerminalResponse.fromJson(Map<String, Object?> json) =>
      _$ReleaseTerminalResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ReleaseTerminalResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ReleaseTerminalResponse].
final class ReleaseTerminalResponseCodec
    implements AcpCodec<ReleaseTerminalResponse> {
  /// Creates the codec.
  const ReleaseTerminalResponseCodec();

  @override
  ReleaseTerminalResponse decode(Object? value) =>
      ReleaseTerminalResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(ReleaseTerminalResponse value) => value.toJson();
}

/// Shared codec for [ReleaseTerminalResponse].
const ReleaseTerminalResponseCodec releaseTerminalResponseCodec =
    ReleaseTerminalResponseCodec();

/// JSON RPC Request Id
///
/// An identifier established by the Client that MUST contain a String, Number, or NULL value if included. If it is not included it is assumed to be a notification. The value SHOULD normally not be Null \[1\] and Numbers SHOULD NOT contain fractional parts \[2\]
///
/// The Server MUST reply with the same value in the Response object if included. This member is used to correlate the context between the two objects.
///
/// \[1\] The use of Null as a value for the id member in a Request object is discouraged, because this specification uses a value of Null for Responses with an unknown id. Also, because JSON-RPC 1.0 uses an id value of Null for Notifications this could cause confusion in handling.
///
sealed class RequestId implements AcpJsonEncodable {
  const RequestId();

  /// Decodes one concrete union member.
  factory RequestId.fromJson(Object? json) => requestIdCodec.decode(json);

  /// Encodes the concrete union member.
  Object? toJson();

  @override
  AcpJsonValue toAcpJson() => AcpJsonValue.fromObject(toJson());
}

/// The JSON-RPC `null` request id.
final class RequestIdNull extends RequestId {
  /// Creates the JSON-null union member.
  const RequestIdNull();

  @override
  Object? toJson() => null;
}

/// A numeric JSON-RPC request id.
final class RequestIdNumber extends RequestId {
  /// Creates this concrete union member.
  const RequestIdNumber(this.value);

  /// The typed union value.
  final AcpInt64 value;

  @override
  Object? toJson() => encodeAcpInt64(value);
}

/// A string JSON-RPC request id.
final class RequestIdStr extends RequestId {
  /// Creates this concrete union member.
  const RequestIdStr(this.value);

  /// The typed union value.
  final String value;

  @override
  Object? toJson() => value;
}

/// Codec for [RequestId].
final class RequestIdCodec implements AcpCodec<RequestId> {
  /// Creates the codec.
  const RequestIdCodec();

  @override
  RequestId decode(Object? value) {
    if (value == null) {
      return const RequestIdNull();
    }
    try {
      return RequestIdNumber(decodeAcpInt64(value));
    } on Object {
      // Try the next structurally distinct member.
    }
    if (value is String) {
      return RequestIdStr(decodeAcpString(value));
    }
    throw const FormatException('Value does not match RequestId');
  }

  @override
  Object? encode(RequestId value) => value.toJson();
}

/// Shared codec for [RequestId].
const RequestIdCodec requestIdCodec = RequestIdCodec();

/// The outcome of a permission request.
sealed class RequestPermissionOutcome implements AcpJsonEncodable {
  const RequestPermissionOutcome();

  /// Decodes the tagged union.
  factory RequestPermissionOutcome.fromJson(Object? json) =>
      requestPermissionOutcomeCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// The prompt turn was cancelled before the user responded.
///
/// When a client sends a `session/cancel` notification to cancel an ongoing
/// prompt turn, it MUST respond to all pending `session/request_permission`
/// requests with this `Cancelled` outcome.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/prompt-turn#cancellation)
final class RequestPermissionOutcomeCancelled extends RequestPermissionOutcome {
  /// Creates this known tagged-union variant.
  const RequestPermissionOutcomeCancelled();

  @override
  String get discriminator => 'cancelled';

  @override
  AcpJsonObject toAcpJson() {
    final result = <String, Object?>{};
    result['outcome'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// The user selected one of the provided options.
final class RequestPermissionOutcomeSelected extends RequestPermissionOutcome {
  /// Creates this known tagged-union variant.
  const RequestPermissionOutcomeSelected(this.value);

  /// The typed variant payload.
  final SelectedPermissionOutcome value;

  @override
  String get discriminator => 'selected';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(
      selectedPermissionOutcomeCodec.encode(value),
    );
    final result = <String, Object?>{...payload};
    result['outcome'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Codec for [RequestPermissionOutcome].
final class RequestPermissionOutcomeCodec
    implements AcpCodec<RequestPermissionOutcome> {
  /// Creates the codec.
  const RequestPermissionOutcomeCodec();

  @override
  RequestPermissionOutcome decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['outcome']);
    switch (tag) {
      case 'cancelled':
        return RequestPermissionOutcomeCancelled();
      case 'selected':
        return RequestPermissionOutcomeSelected(
          selectedPermissionOutcomeCodec.decode(payload),
        );
      default:
        throw FormatException('Unknown RequestPermissionOutcome tag: $tag');
    }
  }

  @override
  Object encode(RequestPermissionOutcome value) => value.toJson();
}

/// Shared codec for [RequestPermissionOutcome].
const RequestPermissionOutcomeCodec requestPermissionOutcomeCodec =
    RequestPermissionOutcomeCodec();

SessionId _decodeRequestPermissionRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeRequestPermissionRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

ToolCallUpdate _decodeRequestPermissionRequestToolCall(Object? value) =>
    toolCallUpdateCodec.decode(value);
Object? _encodeRequestPermissionRequestToolCall(ToolCallUpdate value) =>
    toolCallUpdateCodec.encode(value);

List<PermissionOption> _decodeRequestPermissionRequestOptions(Object? value) =>
    List<PermissionOption>.unmodifiable(
      (value as List<Object?>).map(
        (item) => permissionOptionCodec.decode(item),
      ),
    );
Object? _encodeRequestPermissionRequestOptions(List<PermissionOption> value) =>
    <Object?>[for (final item in value) permissionOptionCodec.encode(item)];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request for user permission to execute a tool call.
///
/// Sent when the agent needs authorization before performing a sensitive operation.
///
/// See protocol docs: [Requesting Permission](https://agentclientprotocol.com/protocol/tool-calls#requesting-permission)
final class RequestPermissionRequest implements AcpJsonEncodable {
  /// Creates a RequestPermissionRequest value.
  RequestPermissionRequest({
    required this.sessionId,
    required this.toolCall,
    required List<PermissionOption> options,
    this.meta,
  }) : options = List<PermissionOption>.unmodifiable(options);

  /// The session ID for this request.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeRequestPermissionRequestSessionId,
    toJson: _encodeRequestPermissionRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// Details about the tool call requiring permission.
  @JsonKey(
    name: 'toolCall',
    fromJson: _decodeRequestPermissionRequestToolCall,
    toJson: _encodeRequestPermissionRequestToolCall,
    includeIfNull: false,
    required: true,
  )
  final ToolCallUpdate toolCall;

  /// Available permission options for the user to choose from.
  @JsonKey(
    name: 'options',
    fromJson: _decodeRequestPermissionRequestOptions,
    toJson: _encodeRequestPermissionRequestOptions,
    includeIfNull: false,
    required: true,
  )
  final List<PermissionOption> options;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory RequestPermissionRequest.fromJson(Map<String, Object?> json) =>
      _$RequestPermissionRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$RequestPermissionRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [RequestPermissionRequest].
final class RequestPermissionRequestCodec
    implements AcpCodec<RequestPermissionRequest> {
  /// Creates the codec.
  const RequestPermissionRequestCodec();

  @override
  RequestPermissionRequest decode(Object? value) =>
      RequestPermissionRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(RequestPermissionRequest value) => value.toJson();
}

/// Shared codec for [RequestPermissionRequest].
const RequestPermissionRequestCodec requestPermissionRequestCodec =
    RequestPermissionRequestCodec();

RequestPermissionOutcome _decodeRequestPermissionResponseOutcome(
  Object? value,
) => requestPermissionOutcomeCodec.decode(value);
Object? _encodeRequestPermissionResponseOutcome(
  RequestPermissionOutcome value,
) => requestPermissionOutcomeCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to a permission request.
final class RequestPermissionResponse implements AcpJsonEncodable {
  /// Creates a RequestPermissionResponse value.
  RequestPermissionResponse({required this.outcome, this.meta});

  /// The user's decision on the permission request.
  @JsonKey(
    name: 'outcome',
    fromJson: _decodeRequestPermissionResponseOutcome,
    toJson: _encodeRequestPermissionResponseOutcome,
    includeIfNull: false,
    required: true,
  )
  final RequestPermissionOutcome outcome;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory RequestPermissionResponse.fromJson(Map<String, Object?> json) =>
      _$RequestPermissionResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$RequestPermissionResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [RequestPermissionResponse].
final class RequestPermissionResponseCodec
    implements AcpCodec<RequestPermissionResponse> {
  /// Creates the codec.
  const RequestPermissionResponseCodec();

  @override
  RequestPermissionResponse decode(Object? value) =>
      RequestPermissionResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(RequestPermissionResponse value) => value.toJson();
}

/// Shared codec for [RequestPermissionResponse].
const RequestPermissionResponseCodec requestPermissionResponseCodec =
    RequestPermissionResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A resource that the server is capable of reading, included in a prompt or tool call result.
final class ResourceLink implements AcpJsonEncodable {
  /// Creates a ResourceLink value.
  ResourceLink({
    required this.name,
    required this.uri,
    this.annotations,
    this.description,
    this.mimeType,
    this.size,
    this.title,
    this.meta,
  });

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// Optional human-readable details shown with this protocol object.
  final String? description;

  /// MIME type describing the encoded media payload.
  final String? mimeType;

  /// Human-readable name shown for this protocol object.
  final String name;

  /// Optional size of the linked resource in bytes, if known.
  final AcpInt64? size;

  /// Optional display title for end-user UI.
  final String? title;

  /// URI associated with this resource or media payload.
  final String uri;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ResourceLink> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ResourceLink(
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
          .valueOrNull,
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      mimeType: decoder
          .optionalOnError('mimeType', (value) => decodeAcpString(value))
          .valueOrNull,
      name: decoder.required('name', (value) => decodeAcpString(value)),
      size: decoder
          .optionalOnError('size', (value) => decodeAcpInt64(value))
          .valueOrNull,
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      uri: decoder.required('uri', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ResourceLink.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
    }
    if (description != null) {
      result['description'] = description!;
    }
    if (mimeType != null) {
      result['mimeType'] = mimeType!;
    }
    result['name'] = name;
    if (size != null) {
      result['size'] = encodeAcpInt64(size!);
    }
    if (title != null) {
      result['title'] = title!;
    }
    result['uri'] = uri;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ResourceLink].
final class ResourceLinkCodec implements AcpCodec<ResourceLink> {
  /// Creates the codec.
  const ResourceLinkCodec();

  @override
  ResourceLink decode(Object? value) =>
      ResourceLink.fromJson(decodeAcpObject(value));

  @override
  Object encode(ResourceLink value) => value.toJson();
}

/// Shared codec for [ResourceLink].
const ResourceLinkCodec resourceLinkCodec = ResourceLinkCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request parameters for resuming an existing session.
///
/// Resumes an existing session without returning previous messages (unlike `session/load`).
/// This is useful for agents that can resume sessions but don't implement full session loading.
///
/// Only available if the Agent supports the `sessionCapabilities.resume` capability.
final class ResumeSessionRequest implements AcpJsonEncodable {
  /// Creates a ResumeSessionRequest value.
  ResumeSessionRequest({
    required this.sessionId,
    required this.cwd,
    List<String>? additionalDirectories,
    List<McpServer>? mcpServers,
    this.meta,
  }) : additionalDirectories = additionalDirectories == null
           ? null
           : List<String>.unmodifiable(additionalDirectories),
       mcpServers = mcpServers == null
           ? null
           : List<McpServer>.unmodifiable(mcpServers);

  /// The ID of the session to resume.
  final SessionId sessionId;

  /// The working directory for this session. Must be an absolute path.
  final String cwd;

  /// Additional workspace roots to activate for this session. Each path must be absolute.
  ///
  /// When omitted or empty, no additional roots are activated. When non-empty,
  /// this is the complete resulting additional-root list for the resumed
  /// session. It may differ from any previously used or reported list as long as
  /// the request `cwd` matches the session's `cwd`.
  final List<String>? additionalDirectories;

  /// List of MCP servers to connect to for this session.
  final List<McpServer>? mcpServers;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ResumeSessionRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ResumeSessionRequest(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      cwd: decoder.required('cwd', (value) => decodeAcpString(value)),
      additionalDirectories: decoder.listSkippingInvalid(
        'additionalDirectories',
        (value) => decodeAcpString(value),
        isRequired: false,
      ),
      mcpServers: decoder.listSkippingInvalid(
        'mcpServers',
        (value) => mcpServerCodec.decode(value),
        isRequired: false,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ResumeSessionRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['cwd'] = cwd;
    if (additionalDirectories != null) {
      result['additionalDirectories'] = <Object?>[
        for (final item in additionalDirectories!) item,
      ];
    }
    if (mcpServers != null) {
      result['mcpServers'] = <Object?>[
        for (final item in mcpServers!) mcpServerCodec.encode(item),
      ];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ResumeSessionRequest].
final class ResumeSessionRequestCodec
    implements AcpCodec<ResumeSessionRequest> {
  /// Creates the codec.
  const ResumeSessionRequestCodec();

  @override
  ResumeSessionRequest decode(Object? value) =>
      ResumeSessionRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(ResumeSessionRequest value) => value.toJson();
}

/// Shared codec for [ResumeSessionRequest].
const ResumeSessionRequestCodec resumeSessionRequestCodec =
    ResumeSessionRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Response from resuming an existing session.
final class ResumeSessionResponse implements AcpJsonEncodable {
  /// Creates a ResumeSessionResponse value.
  ResumeSessionResponse({
    this.modes,
    List<SessionConfigOption>? configOptions,
    this.meta,
  }) : configOptions = configOptions == null
           ? null
           : List<SessionConfigOption>.unmodifiable(configOptions);

  /// Initial mode state if supported by the Agent
  ///
  /// See protocol docs: [Session Modes](https://agentclientprotocol.com/protocol/session-modes)
  final SessionModeState? modes;

  /// Initial session configuration options if supported by the Agent.
  final List<SessionConfigOption>? configOptions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ResumeSessionResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ResumeSessionResponse(
      modes: decoder
          .optionalOnError(
            'modes',
            (value) => sessionModeStateCodec.decode(value),
          )
          .valueOrNull,
      configOptions: decoder.listSkippingInvalid(
        'configOptions',
        (value) => sessionConfigOptionCodec.decode(value),
        isRequired: false,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ResumeSessionResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (modes != null) {
      result['modes'] = sessionModeStateCodec.encode(modes!);
    }
    if (configOptions != null) {
      result['configOptions'] = <Object?>[
        for (final item in configOptions!)
          sessionConfigOptionCodec.encode(item),
      ];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ResumeSessionResponse].
final class ResumeSessionResponseCodec
    implements AcpCodec<ResumeSessionResponse> {
  /// Creates the codec.
  const ResumeSessionResponseCodec();

  @override
  ResumeSessionResponse decode(Object? value) =>
      ResumeSessionResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(ResumeSessionResponse value) => value.toJson();
}

/// Shared codec for [ResumeSessionResponse].
const ResumeSessionResponseCodec resumeSessionResponseCodec =
    ResumeSessionResponseCodec();

/// The sender or recipient of messages and data in a conversation.
final class Role implements AcpJsonEncodable {
  /// Validates and creates a Role value.
  factory Role(String value) {
    if (!const <String>{'assistant', 'user'}.contains(value)) {
      throw FormatException('Unknown Role: $value');
    }
    return Role._(value);
  }

  const Role._(this.value);

  /// The exact wire string.
  final String value;

  /// The `assistant` schema value.
  static const Role assistant = Role._('assistant');

  /// The `user` schema value.
  static const Role user = Role._('user');

  /// Decodes a wire string.
  factory Role.fromJson(Object? json) => Role(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is Role && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [Role].
final class RoleCodec implements AcpCodec<Role> {
  /// Creates the codec.
  const RoleCodec();

  @override
  Role decode(Object? value) => Role.fromJson(value);

  @override
  String encode(Role value) => value.toJson();
}

/// Shared codec for [Role].
const RoleCodec roleCodec = RoleCodec();

PermissionOptionId _decodeSelectedPermissionOutcomeOptionId(Object? value) =>
    permissionOptionIdCodec.decode(value);
Object? _encodeSelectedPermissionOutcomeOptionId(PermissionOptionId value) =>
    permissionOptionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// The user selected one of the provided options.
final class SelectedPermissionOutcome implements AcpJsonEncodable {
  /// Creates a SelectedPermissionOutcome value.
  SelectedPermissionOutcome({required this.optionId, this.meta});

  /// The ID of the option the user selected.
  @JsonKey(
    name: 'optionId',
    fromJson: _decodeSelectedPermissionOutcomeOptionId,
    toJson: _encodeSelectedPermissionOutcomeOptionId,
    includeIfNull: false,
    required: true,
  )
  final PermissionOptionId optionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SelectedPermissionOutcome.fromJson(Map<String, Object?> json) =>
      _$SelectedPermissionOutcomeFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SelectedPermissionOutcomeToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SelectedPermissionOutcome].
final class SelectedPermissionOutcomeCodec
    implements AcpCodec<SelectedPermissionOutcome> {
  /// Creates the codec.
  const SelectedPermissionOutcomeCodec();

  @override
  SelectedPermissionOutcome decode(Object? value) =>
      SelectedPermissionOutcome.fromJson(decodeAcpObject(value));

  @override
  Object encode(SelectedPermissionOutcome value) => value.toJson();
}

/// Shared codec for [SelectedPermissionOutcome].
const SelectedPermissionOutcomeCodec selectedPermissionOutcomeCodec =
    SelectedPermissionOutcomeCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for additional session directories support.
///
/// Supplying `{}` means the agent supports the `additionalDirectories` field on
/// supported session lifecycle requests. Agents that also support
/// `session/list` may return `SessionInfo.additionalDirectories` to report the
/// complete ordered additional-root list associated with a listed session.
final class SessionAdditionalDirectoriesCapabilities
    implements AcpJsonEncodable {
  /// Creates a SessionAdditionalDirectoriesCapabilities value.
  SessionAdditionalDirectoriesCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SessionAdditionalDirectoriesCapabilities.fromJson(
    Map<String, Object?> json,
  ) => _$SessionAdditionalDirectoriesCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() =>
      _$SessionAdditionalDirectoriesCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionAdditionalDirectoriesCapabilities].
final class SessionAdditionalDirectoriesCapabilitiesCodec
    implements AcpCodec<SessionAdditionalDirectoriesCapabilities> {
  /// Creates the codec.
  const SessionAdditionalDirectoriesCapabilitiesCodec();

  @override
  SessionAdditionalDirectoriesCapabilities decode(Object? value) =>
      SessionAdditionalDirectoriesCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionAdditionalDirectoriesCapabilities value) =>
      value.toJson();
}

/// Shared codec for [SessionAdditionalDirectoriesCapabilities].
const SessionAdditionalDirectoriesCapabilitiesCodec
sessionAdditionalDirectoriesCapabilitiesCodec =
    SessionAdditionalDirectoriesCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Session capabilities supported by the agent.
///
/// As a baseline, all Agents **MUST** support `session/new`, `session/prompt`, `session/cancel`, and `session/update`.
///
/// Optionally, they **MAY** support other session methods and notifications by specifying additional capabilities.
///
/// Note: `session/load` is still handled by the top-level `load_session` capability. This will be unified in future versions of the protocol.
///
final class SessionCapabilities implements AcpJsonEncodable {
  /// Creates a SessionCapabilities value.
  SessionCapabilities({
    this.list,
    this.delete,
    this.additionalDirectories,
    this.fork,
    this.resume,
    this.close,
    this.meta,
  });

  /// Whether the agent supports `session/list`.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports listing sessions.
  final SessionListCapabilities? list;

  /// Whether the agent supports `session/delete`.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports deleting sessions from `session/list`.
  final SessionDeleteCapabilities? delete;

  /// Whether the agent supports `additionalDirectories` on supported session lifecycle requests.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports `additionalDirectories` on
  /// supported session lifecycle requests.
  ///
  /// Agents that also support `session/list` may return
  /// `SessionInfo.additionalDirectories` to report the complete ordered
  final SessionAdditionalDirectoriesCapabilities? additionalDirectories;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// Whether the agent supports `session/fork`.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports forking sessions.
  final SessionForkCapabilities? fork;

  /// Whether the agent supports `session/resume`.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports resuming sessions.
  final SessionResumeCapabilities? resume;

  /// Whether the agent supports `session/close`.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports closing sessions.
  final SessionCloseCapabilities? close;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionCapabilities(
      list: decoder
          .optionalOnError(
            'list',
            (value) => sessionListCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      delete: decoder
          .optionalOnError(
            'delete',
            (value) => sessionDeleteCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      additionalDirectories: decoder
          .optionalOnError(
            'additionalDirectories',
            (value) =>
                sessionAdditionalDirectoriesCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      fork: decoder
          .optionalOnError(
            'fork',
            (value) => sessionForkCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      resume: decoder
          .optionalOnError(
            'resume',
            (value) => sessionResumeCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      close: decoder
          .optionalOnError(
            'close',
            (value) => sessionCloseCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SessionCapabilities.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (list != null) {
      result['list'] = sessionListCapabilitiesCodec.encode(list!);
    }
    if (delete != null) {
      result['delete'] = sessionDeleteCapabilitiesCodec.encode(delete!);
    }
    if (additionalDirectories != null) {
      result['additionalDirectories'] =
          sessionAdditionalDirectoriesCapabilitiesCodec.encode(
            additionalDirectories!,
          );
    }
    if (fork != null) {
      result['fork'] = sessionForkCapabilitiesCodec.encode(fork!);
    }
    if (resume != null) {
      result['resume'] = sessionResumeCapabilitiesCodec.encode(resume!);
    }
    if (close != null) {
      result['close'] = sessionCloseCapabilitiesCodec.encode(close!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionCapabilities].
final class SessionCapabilitiesCodec implements AcpCodec<SessionCapabilities> {
  /// Creates the codec.
  const SessionCapabilitiesCodec();

  @override
  SessionCapabilities decode(Object? value) =>
      SessionCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionCapabilities value) => value.toJson();
}

/// Shared codec for [SessionCapabilities].
const SessionCapabilitiesCodec sessionCapabilitiesCodec =
    SessionCapabilitiesCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for the `session/close` method.
///
/// Supplying `{}` means the agent supports closing sessions.
final class SessionCloseCapabilities implements AcpJsonEncodable {
  /// Creates a SessionCloseCapabilities value.
  SessionCloseCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SessionCloseCapabilities.fromJson(Map<String, Object?> json) =>
      _$SessionCloseCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SessionCloseCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionCloseCapabilities].
final class SessionCloseCapabilitiesCodec
    implements AcpCodec<SessionCloseCapabilities> {
  /// Creates the codec.
  const SessionCloseCapabilitiesCodec();

  @override
  SessionCloseCapabilities decode(Object? value) =>
      SessionCloseCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionCloseCapabilities value) => value.toJson();
}

/// Shared codec for [SessionCloseCapabilities].
const SessionCloseCapabilitiesCodec sessionCloseCapabilitiesCodec =
    SessionCloseCapabilitiesCodec();

bool _decodeSessionConfigBooleanCurrentValue(Object? value) =>
    decodeAcpBoolean(value);
Object? _encodeSessionConfigBooleanCurrentValue(bool value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A boolean on/off toggle session configuration option payload.
final class SessionConfigBoolean implements AcpJsonEncodable {
  /// Creates a SessionConfigBoolean value.
  SessionConfigBoolean({required this.currentValue});

  /// The current value of the boolean option.
  @JsonKey(
    name: 'currentValue',
    fromJson: _decodeSessionConfigBooleanCurrentValue,
    toJson: _encodeSessionConfigBooleanCurrentValue,
    includeIfNull: false,
    required: true,
  )
  final bool currentValue;

  /// Decodes a schema-validated JSON object.
  factory SessionConfigBoolean.fromJson(Map<String, Object?> json) =>
      _$SessionConfigBooleanFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SessionConfigBooleanToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionConfigBoolean].
final class SessionConfigBooleanCodec
    implements AcpCodec<SessionConfigBoolean> {
  /// Creates the codec.
  const SessionConfigBooleanCodec();

  @override
  SessionConfigBoolean decode(Object? value) =>
      SessionConfigBoolean.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionConfigBoolean value) => value.toJson();
}

/// Shared codec for [SessionConfigBoolean].
const SessionConfigBooleanCodec sessionConfigBooleanCodec =
    SessionConfigBooleanCodec();

/// Unique identifier for a session configuration option value group.
final class SessionConfigGroupId implements AcpJsonEncodable {
  /// Validates and creates a SessionConfigGroupId value.
  factory SessionConfigGroupId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return SessionConfigGroupId._(value);
  }

  const SessionConfigGroupId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory SessionConfigGroupId.fromJson(Object? json) =>
      SessionConfigGroupId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is SessionConfigGroupId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [SessionConfigGroupId].
final class SessionConfigGroupIdCodec
    implements AcpCodec<SessionConfigGroupId> {
  /// Creates the codec.
  const SessionConfigGroupIdCodec();

  @override
  SessionConfigGroupId decode(Object? value) =>
      SessionConfigGroupId.fromJson(value);

  @override
  String encode(SessionConfigGroupId value) => value.toJson();
}

/// Shared codec for [SessionConfigGroupId].
const SessionConfigGroupIdCodec sessionConfigGroupIdCodec =
    SessionConfigGroupIdCodec();

/// Unique identifier for a session configuration option.
final class SessionConfigId implements AcpJsonEncodable {
  /// Validates and creates a SessionConfigId value.
  factory SessionConfigId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return SessionConfigId._(value);
  }

  const SessionConfigId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory SessionConfigId.fromJson(Object? json) =>
      SessionConfigId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is SessionConfigId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [SessionConfigId].
final class SessionConfigIdCodec implements AcpCodec<SessionConfigId> {
  /// Creates the codec.
  const SessionConfigIdCodec();

  @override
  SessionConfigId decode(Object? value) => SessionConfigId.fromJson(value);

  @override
  String encode(SessionConfigId value) => value.toJson();
}

/// Shared codec for [SessionConfigId].
const SessionConfigIdCodec sessionConfigIdCodec = SessionConfigIdCodec();

/// A session configuration option selector and its current state.
sealed class SessionConfigOption implements AcpJsonEncodable {
  const SessionConfigOption();

  /// Decodes the tagged union.
  factory SessionConfigOption.fromJson(Object? json) =>
      sessionConfigOptionCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// Single-value selector (dropdown).
final class SessionConfigOptionSelect extends SessionConfigOption {
  /// Creates this known tagged-union variant.
  SessionConfigOptionSelect(
    this.value, {
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.meta,
  });

  /// The typed variant payload.
  final SessionConfigSelect value;

  /// Unique identifier for the configuration option.
  final SessionConfigId id;

  /// Human-readable label for the option.
  final String name;

  /// Optional description for the Client to display to the user.
  final String? description;

  /// Optional semantic category for this option (UX only).
  final SessionConfigOptionCategory? category;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'select';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(sessionConfigSelectCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['id'] = sessionConfigIdCodec.encode(id);
    result['name'] = name;
    if (description != null) {
      result['description'] = description!;
    }
    if (category != null) {
      result['category'] = sessionConfigOptionCategoryCodec.encode(category!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Boolean on/off toggle.
final class SessionConfigOptionBoolean extends SessionConfigOption {
  /// Creates this known tagged-union variant.
  SessionConfigOptionBoolean(
    this.value, {
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.meta,
  });

  /// The typed variant payload.
  final SessionConfigBoolean value;

  /// Unique identifier for the configuration option.
  final SessionConfigId id;

  /// Human-readable label for the option.
  final String name;

  /// Optional description for the Client to display to the user.
  final String? description;

  /// Optional semantic category for this option (UX only).
  final SessionConfigOptionCategory? category;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'boolean';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(sessionConfigBooleanCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['id'] = sessionConfigIdCodec.encode(id);
    result['name'] = name;
    if (description != null) {
      result['description'] = description!;
    }
    if (category != null) {
      result['category'] = sessionConfigOptionCategoryCodec.encode(category!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Codec for [SessionConfigOption].
final class SessionConfigOptionCodec implements AcpCodec<SessionConfigOption> {
  /// Creates the codec.
  const SessionConfigOptionCodec();

  @override
  SessionConfigOption decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'select':
        final decoder = AcpResilientDecoder(payload);
        return SessionConfigOptionSelect(
          sessionConfigSelectCodec.decode(payload),
          id: decoder.required(
            'id',
            (value) => sessionConfigIdCodec.decode(value),
          ),
          name: decoder.required('name', (value) => decodeAcpString(value)),
          description: decoder
              .optionalOnError('description', (value) => decodeAcpString(value))
              .valueOrNull,
          category: decoder
              .optionalOnError(
                'category',
                (value) => sessionConfigOptionCategoryCodec.decode(value),
              )
              .valueOrNull,
          meta: decoder.meta(),
        );
      case 'boolean':
        final decoder = AcpResilientDecoder(payload);
        return SessionConfigOptionBoolean(
          sessionConfigBooleanCodec.decode(payload),
          id: decoder.required(
            'id',
            (value) => sessionConfigIdCodec.decode(value),
          ),
          name: decoder.required('name', (value) => decodeAcpString(value)),
          description: decoder
              .optionalOnError('description', (value) => decodeAcpString(value))
              .valueOrNull,
          category: decoder
              .optionalOnError(
                'category',
                (value) => sessionConfigOptionCategoryCodec.decode(value),
              )
              .valueOrNull,
          meta: decoder.meta(),
        );
      default:
        throw FormatException('Unknown SessionConfigOption tag: $tag');
    }
  }

  @override
  Object encode(SessionConfigOption value) => value.toJson();
}

/// Shared codec for [SessionConfigOption].
const SessionConfigOptionCodec sessionConfigOptionCodec =
    SessionConfigOptionCodec();

/// Semantic category for a session configuration option.
///
/// This is intended to help Clients distinguish broadly common selectors (e.g. model selector vs
/// session mode selector vs thought/reasoning level) for UX purposes (keyboard shortcuts, icons,
/// placement). It MUST NOT be required for correctness. Clients MUST handle missing or unknown
/// categories gracefully.
///
/// Category names beginning with `_` are free for custom use, like other ACP extension methods.
final class SessionConfigOptionCategory implements AcpJsonEncodable {
  /// Validates and creates a SessionConfigOptionCategory value.
  factory SessionConfigOptionCategory(String value) {
    return SessionConfigOptionCategory._(value);
  }

  const SessionConfigOptionCategory._(this.value);

  /// The exact wire string.
  final String value;

  /// The `mode` schema value.
  static const SessionConfigOptionCategory mode = SessionConfigOptionCategory._(
    'mode',
  );

  /// The `model` schema value.
  static const SessionConfigOptionCategory model =
      SessionConfigOptionCategory._('model');

  /// The `model_config` schema value.
  static const SessionConfigOptionCategory modelConfig =
      SessionConfigOptionCategory._('model_config');

  /// The `thought_level` schema value.
  static const SessionConfigOptionCategory thoughtLevel =
      SessionConfigOptionCategory._('thought_level');

  /// Decodes a wire string.
  factory SessionConfigOptionCategory.fromJson(Object? json) =>
      SessionConfigOptionCategory(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is SessionConfigOptionCategory && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [SessionConfigOptionCategory].
final class SessionConfigOptionCategoryCodec
    implements AcpCodec<SessionConfigOptionCategory> {
  /// Creates the codec.
  const SessionConfigOptionCategoryCodec();

  @override
  SessionConfigOptionCategory decode(Object? value) =>
      SessionConfigOptionCategory.fromJson(value);

  @override
  String encode(SessionConfigOptionCategory value) => value.toJson();
}

/// Shared codec for [SessionConfigOptionCategory].
const SessionConfigOptionCategoryCodec sessionConfigOptionCategoryCodec =
    SessionConfigOptionCategoryCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Session configuration option capabilities supported by the client.
final class SessionConfigOptionsCapabilities implements AcpJsonEncodable {
  /// Creates a SessionConfigOptionsCapabilities value.
  SessionConfigOptionsCapabilities({this.boolean, this.meta});

  /// Whether the client supports boolean session configuration options.
  ///
  /// Optional. Omitted or `null` both mean the client does not advertise support.
  /// Supplying `{}` means agents may include `type: "boolean"` entries in
  /// `configOptions`, and the client may send `session/set_config_option`
  /// requests with `type: "boolean"` and a boolean `value`.
  final BooleanConfigOptionCapabilities? boolean;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionConfigOptionsCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionConfigOptionsCapabilities(
      boolean: decoder
          .optionalOnError(
            'boolean',
            (value) => booleanConfigOptionCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SessionConfigOptionsCapabilities.fromJson(
    Map<String, Object?> json,
  ) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (boolean != null) {
      result['boolean'] = booleanConfigOptionCapabilitiesCodec.encode(boolean!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionConfigOptionsCapabilities].
final class SessionConfigOptionsCapabilitiesCodec
    implements AcpCodec<SessionConfigOptionsCapabilities> {
  /// Creates the codec.
  const SessionConfigOptionsCapabilitiesCodec();

  @override
  SessionConfigOptionsCapabilities decode(Object? value) =>
      SessionConfigOptionsCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionConfigOptionsCapabilities value) => value.toJson();
}

/// Shared codec for [SessionConfigOptionsCapabilities].
const SessionConfigOptionsCapabilitiesCodec
sessionConfigOptionsCapabilitiesCodec = SessionConfigOptionsCapabilitiesCodec();

SessionConfigValueId _decodeSessionConfigSelectCurrentValue(Object? value) =>
    sessionConfigValueIdCodec.decode(value);
Object? _encodeSessionConfigSelectCurrentValue(SessionConfigValueId value) =>
    sessionConfigValueIdCodec.encode(value);

SessionConfigSelectOptions _decodeSessionConfigSelectOptions(Object? value) =>
    sessionConfigSelectOptionsCodec.decode(value);
Object? _encodeSessionConfigSelectOptions(SessionConfigSelectOptions value) =>
    sessionConfigSelectOptionsCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A single-value selector (dropdown) session configuration option payload.
final class SessionConfigSelect implements AcpJsonEncodable {
  /// Creates a SessionConfigSelect value.
  SessionConfigSelect({required this.currentValue, required this.options});

  /// The currently selected value.
  @JsonKey(
    name: 'currentValue',
    fromJson: _decodeSessionConfigSelectCurrentValue,
    toJson: _encodeSessionConfigSelectCurrentValue,
    includeIfNull: false,
    required: true,
  )
  final SessionConfigValueId currentValue;

  /// The set of selectable options.
  @JsonKey(
    name: 'options',
    fromJson: _decodeSessionConfigSelectOptions,
    toJson: _encodeSessionConfigSelectOptions,
    includeIfNull: false,
    required: true,
  )
  final SessionConfigSelectOptions options;

  /// Decodes a schema-validated JSON object.
  factory SessionConfigSelect.fromJson(Map<String, Object?> json) =>
      _$SessionConfigSelectFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SessionConfigSelectToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionConfigSelect].
final class SessionConfigSelectCodec implements AcpCodec<SessionConfigSelect> {
  /// Creates the codec.
  const SessionConfigSelectCodec();

  @override
  SessionConfigSelect decode(Object? value) =>
      SessionConfigSelect.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionConfigSelect value) => value.toJson();
}

/// Shared codec for [SessionConfigSelect].
const SessionConfigSelectCodec sessionConfigSelectCodec =
    SessionConfigSelectCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A group of possible values for a session configuration option.
final class SessionConfigSelectGroup implements AcpJsonEncodable {
  /// Creates a SessionConfigSelectGroup value.
  SessionConfigSelectGroup({
    required this.group,
    required this.name,
    required List<SessionConfigSelectOption> options,
    this.meta,
  }) : options = List<SessionConfigSelectOption>.unmodifiable(options);

  /// Unique identifier for this group.
  final SessionConfigGroupId group;

  /// Human-readable label for this group.
  final String name;

  /// The set of option values in this group.
  final List<SessionConfigSelectOption> options;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionConfigSelectGroup> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionConfigSelectGroup(
      group: decoder.required(
        'group',
        (value) => sessionConfigGroupIdCodec.decode(value),
      ),
      name: decoder.required('name', (value) => decodeAcpString(value)),
      options: decoder.listSkippingInvalid(
        'options',
        (value) => sessionConfigSelectOptionCodec.decode(value),
        isRequired: true,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SessionConfigSelectGroup.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['group'] = sessionConfigGroupIdCodec.encode(group);
    result['name'] = name;
    result['options'] = <Object?>[
      for (final item in options) sessionConfigSelectOptionCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionConfigSelectGroup].
final class SessionConfigSelectGroupCodec
    implements AcpCodec<SessionConfigSelectGroup> {
  /// Creates the codec.
  const SessionConfigSelectGroupCodec();

  @override
  SessionConfigSelectGroup decode(Object? value) =>
      SessionConfigSelectGroup.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionConfigSelectGroup value) => value.toJson();
}

/// Shared codec for [SessionConfigSelectGroup].
const SessionConfigSelectGroupCodec sessionConfigSelectGroupCodec =
    SessionConfigSelectGroupCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A possible value for a session configuration option.
final class SessionConfigSelectOption implements AcpJsonEncodable {
  /// Creates a SessionConfigSelectOption value.
  SessionConfigSelectOption({
    required this.value,
    required this.name,
    this.description,
    this.meta,
  });

  /// Unique identifier for this option value.
  final SessionConfigValueId value;

  /// Human-readable label for this option value.
  final String name;

  /// Optional description for this option value.
  final String? description;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionConfigSelectOption> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionConfigSelectOption(
      value: decoder.required(
        'value',
        (value) => sessionConfigValueIdCodec.decode(value),
      ),
      name: decoder.required('name', (value) => decodeAcpString(value)),
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SessionConfigSelectOption.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['value'] = sessionConfigValueIdCodec.encode(value);
    result['name'] = name;
    if (description != null) {
      result['description'] = description!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionConfigSelectOption].
final class SessionConfigSelectOptionCodec
    implements AcpCodec<SessionConfigSelectOption> {
  /// Creates the codec.
  const SessionConfigSelectOptionCodec();

  @override
  SessionConfigSelectOption decode(Object? value) =>
      SessionConfigSelectOption.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionConfigSelectOption value) => value.toJson();
}

/// Shared codec for [SessionConfigSelectOption].
const SessionConfigSelectOptionCodec sessionConfigSelectOptionCodec =
    SessionConfigSelectOptionCodec();

/// Possible values for a session configuration option.
sealed class SessionConfigSelectOptions implements AcpJsonEncodable {
  const SessionConfigSelectOptions();

  /// Decodes one concrete union member.
  factory SessionConfigSelectOptions.fromJson(Object? json) =>
      sessionConfigSelectOptionsCodec.decode(json);

  /// Encodes the concrete union member.
  Object? toJson();

  @override
  AcpJsonValue toAcpJson() => AcpJsonValue.fromObject(toJson());
}

/// A flat list of options with no grouping.
final class SessionConfigSelectOptionsUngrouped
    extends SessionConfigSelectOptions {
  /// Creates this concrete union member.
  const SessionConfigSelectOptionsUngrouped(this.value);

  /// The typed union value.
  final List<SessionConfigSelectOption> value;

  @override
  Object? toJson() => <Object?>[
    for (final item in value) sessionConfigSelectOptionCodec.encode(item),
  ];
}

/// A list of options grouped under headers.
final class SessionConfigSelectOptionsGrouped
    extends SessionConfigSelectOptions {
  /// Creates this concrete union member.
  const SessionConfigSelectOptionsGrouped(this.value);

  /// The typed union value.
  final List<SessionConfigSelectGroup> value;

  @override
  Object? toJson() => <Object?>[
    for (final item in value) sessionConfigSelectGroupCodec.encode(item),
  ];
}

/// Codec for [SessionConfigSelectOptions].
final class SessionConfigSelectOptionsCodec
    implements AcpCodec<SessionConfigSelectOptions> {
  /// Creates the codec.
  const SessionConfigSelectOptionsCodec();

  @override
  SessionConfigSelectOptions decode(Object? value) {
    if (value is List<Object?>) {
      try {
        return SessionConfigSelectOptionsUngrouped(
          List<SessionConfigSelectOption>.unmodifiable(
            value.map((item) => sessionConfigSelectOptionCodec.decode(item)),
          ),
        );
      } on Object {
        // Try the next array-shaped member.
      }
    }
    if (value is List<Object?>) {
      try {
        return SessionConfigSelectOptionsGrouped(
          List<SessionConfigSelectGroup>.unmodifiable(
            value.map((item) => sessionConfigSelectGroupCodec.decode(item)),
          ),
        );
      } on Object {
        // Try the next array-shaped member.
      }
    }
    throw const FormatException(
      'Value does not match SessionConfigSelectOptions',
    );
  }

  @override
  Object? encode(SessionConfigSelectOptions value) => value.toJson();
}

/// Shared codec for [SessionConfigSelectOptions].
const SessionConfigSelectOptionsCodec sessionConfigSelectOptionsCodec =
    SessionConfigSelectOptionsCodec();

/// Unique identifier for a session configuration option value.
final class SessionConfigValueId implements AcpJsonEncodable {
  /// Validates and creates a SessionConfigValueId value.
  factory SessionConfigValueId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return SessionConfigValueId._(value);
  }

  const SessionConfigValueId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory SessionConfigValueId.fromJson(Object? json) =>
      SessionConfigValueId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is SessionConfigValueId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [SessionConfigValueId].
final class SessionConfigValueIdCodec
    implements AcpCodec<SessionConfigValueId> {
  /// Creates the codec.
  const SessionConfigValueIdCodec();

  @override
  SessionConfigValueId decode(Object? value) =>
      SessionConfigValueId.fromJson(value);

  @override
  String encode(SessionConfigValueId value) => value.toJson();
}

/// Shared codec for [SessionConfigValueId].
const SessionConfigValueIdCodec sessionConfigValueIdCodec =
    SessionConfigValueIdCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for the `session/delete` method.
///
/// Supplying `{}` means the agent supports deleting sessions from `session/list`.
final class SessionDeleteCapabilities implements AcpJsonEncodable {
  /// Creates a SessionDeleteCapabilities value.
  SessionDeleteCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SessionDeleteCapabilities.fromJson(Map<String, Object?> json) =>
      _$SessionDeleteCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SessionDeleteCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionDeleteCapabilities].
final class SessionDeleteCapabilitiesCodec
    implements AcpCodec<SessionDeleteCapabilities> {
  /// Creates the codec.
  const SessionDeleteCapabilitiesCodec();

  @override
  SessionDeleteCapabilities decode(Object? value) =>
      SessionDeleteCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionDeleteCapabilities value) => value.toJson();
}

/// Shared codec for [SessionDeleteCapabilities].
const SessionDeleteCapabilitiesCodec sessionDeleteCapabilitiesCodec =
    SessionDeleteCapabilitiesCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Capabilities for the `session/fork` method.
///
/// Supplying `{}` means the agent supports forking sessions.
final class SessionForkCapabilities implements AcpJsonEncodable {
  /// Creates a SessionForkCapabilities value.
  SessionForkCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SessionForkCapabilities.fromJson(Map<String, Object?> json) =>
      _$SessionForkCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SessionForkCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionForkCapabilities].
final class SessionForkCapabilitiesCodec
    implements AcpCodec<SessionForkCapabilities> {
  /// Creates the codec.
  const SessionForkCapabilitiesCodec();

  @override
  SessionForkCapabilities decode(Object? value) =>
      SessionForkCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionForkCapabilities value) => value.toJson();
}

/// Shared codec for [SessionForkCapabilities].
const SessionForkCapabilitiesCodec sessionForkCapabilitiesCodec =
    SessionForkCapabilitiesCodec();

/// A unique identifier for a conversation session between a client and agent.
///
/// Sessions maintain their own context, conversation history, and state,
/// allowing multiple independent interactions with the same agent.
///
/// See protocol docs: [Session ID](https://agentclientprotocol.com/protocol/session-setup#session-id)
final class SessionId implements AcpJsonEncodable {
  /// Validates and creates a SessionId value.
  factory SessionId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return SessionId._(value);
  }

  const SessionId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory SessionId.fromJson(Object? json) => SessionId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is SessionId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [SessionId].
final class SessionIdCodec implements AcpCodec<SessionId> {
  /// Creates the codec.
  const SessionIdCodec();

  @override
  SessionId decode(Object? value) => SessionId.fromJson(value);

  @override
  String encode(SessionId value) => value.toJson();
}

/// Shared codec for [SessionId].
const SessionIdCodec sessionIdCodec = SessionIdCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Information about a session returned by session/list
final class SessionInfo implements AcpJsonEncodable {
  /// Creates a SessionInfo value.
  SessionInfo({
    required this.sessionId,
    required this.cwd,
    List<String>? additionalDirectories,
    this.title,
    this.updatedAt,
    this.meta,
  }) : additionalDirectories = additionalDirectories == null
           ? null
           : List<String>.unmodifiable(additionalDirectories);

  /// Unique identifier for the session
  final SessionId sessionId;

  /// The working directory for this session. Must be an absolute path.
  final String cwd;

  /// Additional workspace roots reported for this session. Each path must be absolute.
  ///
  /// When present, this is the complete ordered additional-root list reported
  /// by the Agent. Omitted and empty values are equivalent: the response
  /// reports no additional roots.
  final List<String>? additionalDirectories;

  /// Human-readable title for the session
  final String? title;

  /// ISO 8601 timestamp of last activity
  final String? updatedAt;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionInfo> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionInfo(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      cwd: decoder.required('cwd', (value) => decodeAcpString(value)),
      additionalDirectories: decoder.listSkippingInvalid(
        'additionalDirectories',
        (value) => decodeAcpString(value),
        isRequired: false,
      ),
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      updatedAt: decoder
          .optionalOnError('updatedAt', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SessionInfo.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['cwd'] = cwd;
    if (additionalDirectories != null) {
      result['additionalDirectories'] = <Object?>[
        for (final item in additionalDirectories!) item,
      ];
    }
    if (title != null) {
      result['title'] = title!;
    }
    if (updatedAt != null) {
      result['updatedAt'] = updatedAt!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionInfo].
final class SessionInfoCodec implements AcpCodec<SessionInfo> {
  /// Creates the codec.
  const SessionInfoCodec();

  @override
  SessionInfo decode(Object? value) =>
      SessionInfo.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionInfo value) => value.toJson();
}

/// Shared codec for [SessionInfo].
const SessionInfoCodec sessionInfoCodec = SessionInfoCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Update to session metadata. All fields are optional to support partial updates.
///
/// Agents send this notification to update session information like title or custom metadata.
/// This allows clients to display dynamic session names and track session state changes.
final class SessionInfoUpdate implements AcpJsonEncodable {
  /// Creates a SessionInfoUpdate value.
  SessionInfoUpdate({
    this.title = const AcpPatch<String>.unchanged(),
    this.updatedAt = const AcpPatch<String>.unchanged(),
    this.meta,
  });

  /// Human-readable title for the session. Set to null to clear.
  final AcpPatch<String> title;

  /// ISO 8601 timestamp of last activity. Set to null to clear.
  final AcpPatch<String> updatedAt;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionInfoUpdate> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionInfoUpdate(
      title: decoder.patch('title', (value) => decodeAcpString(value)),
      updatedAt: decoder.patch('updatedAt', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SessionInfoUpdate.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    title.writeTo(result, 'title', (value) => value);
    updatedAt.writeTo(result, 'updatedAt', (value) => value);
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionInfoUpdate].
final class SessionInfoUpdateCodec implements AcpCodec<SessionInfoUpdate> {
  /// Creates the codec.
  const SessionInfoUpdateCodec();

  @override
  SessionInfoUpdate decode(Object? value) =>
      SessionInfoUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionInfoUpdate value) => value.toJson();
}

/// Shared codec for [SessionInfoUpdate].
const SessionInfoUpdateCodec sessionInfoUpdateCodec = SessionInfoUpdateCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for the `session/list` method.
///
/// Supplying `{}` means the agent supports listing sessions.
final class SessionListCapabilities implements AcpJsonEncodable {
  /// Creates a SessionListCapabilities value.
  SessionListCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SessionListCapabilities.fromJson(Map<String, Object?> json) =>
      _$SessionListCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SessionListCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionListCapabilities].
final class SessionListCapabilitiesCodec
    implements AcpCodec<SessionListCapabilities> {
  /// Creates the codec.
  const SessionListCapabilitiesCodec();

  @override
  SessionListCapabilities decode(Object? value) =>
      SessionListCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionListCapabilities value) => value.toJson();
}

/// Shared codec for [SessionListCapabilities].
const SessionListCapabilitiesCodec sessionListCapabilitiesCodec =
    SessionListCapabilitiesCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A mode the agent can operate in.
///
/// See protocol docs: [Session Modes](https://agentclientprotocol.com/protocol/session-modes)
final class SessionMode implements AcpJsonEncodable {
  /// Creates a SessionMode value.
  SessionMode({
    required this.id,
    required this.name,
    this.description,
    this.meta,
  });

  /// Stable identifier used to refer to this protocol object in later messages.
  final SessionModeId id;

  /// Human-readable name shown for this protocol object.
  final String name;

  /// Optional human-readable details shown with this protocol object.
  final String? description;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionMode> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionMode(
      id: decoder.required('id', (value) => sessionModeIdCodec.decode(value)),
      name: decoder.required('name', (value) => decodeAcpString(value)),
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SessionMode.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['id'] = sessionModeIdCodec.encode(id);
    result['name'] = name;
    if (description != null) {
      result['description'] = description!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionMode].
final class SessionModeCodec implements AcpCodec<SessionMode> {
  /// Creates the codec.
  const SessionModeCodec();

  @override
  SessionMode decode(Object? value) =>
      SessionMode.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionMode value) => value.toJson();
}

/// Shared codec for [SessionMode].
const SessionModeCodec sessionModeCodec = SessionModeCodec();

/// Unique identifier for a Session Mode.
final class SessionModeId implements AcpJsonEncodable {
  /// Validates and creates a SessionModeId value.
  factory SessionModeId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return SessionModeId._(value);
  }

  const SessionModeId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory SessionModeId.fromJson(Object? json) =>
      SessionModeId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is SessionModeId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [SessionModeId].
final class SessionModeIdCodec implements AcpCodec<SessionModeId> {
  /// Creates the codec.
  const SessionModeIdCodec();

  @override
  SessionModeId decode(Object? value) => SessionModeId.fromJson(value);

  @override
  String encode(SessionModeId value) => value.toJson();
}

/// Shared codec for [SessionModeId].
const SessionModeIdCodec sessionModeIdCodec = SessionModeIdCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// The set of modes and the one currently active.
final class SessionModeState implements AcpJsonEncodable {
  /// Creates a SessionModeState value.
  SessionModeState({
    required this.currentModeId,
    required List<SessionMode> availableModes,
    this.meta,
  }) : availableModes = List<SessionMode>.unmodifiable(availableModes);

  /// The current mode the Agent is in.
  final SessionModeId currentModeId;

  /// The set of modes that the Agent can operate in
  final List<SessionMode> availableModes;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionModeState> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionModeState(
      currentModeId: decoder.required(
        'currentModeId',
        (value) => sessionModeIdCodec.decode(value),
      ),
      availableModes: decoder.listSkippingInvalid(
        'availableModes',
        (value) => sessionModeCodec.decode(value),
        isRequired: true,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SessionModeState.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['currentModeId'] = sessionModeIdCodec.encode(currentModeId);
    result['availableModes'] = <Object?>[
      for (final item in availableModes) sessionModeCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionModeState].
final class SessionModeStateCodec implements AcpCodec<SessionModeState> {
  /// Creates the codec.
  const SessionModeStateCodec();

  @override
  SessionModeState decode(Object? value) =>
      SessionModeState.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionModeState value) => value.toJson();
}

/// Shared codec for [SessionModeState].
const SessionModeStateCodec sessionModeStateCodec = SessionModeStateCodec();

SessionId _decodeSessionNotificationSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeSessionNotificationSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

SessionUpdate _decodeSessionNotificationUpdate(Object? value) =>
    sessionUpdateCodec.decode(value);
Object? _encodeSessionNotificationUpdate(SessionUpdate value) =>
    sessionUpdateCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification containing a session update from the agent.
///
/// Used to stream real-time progress and results during prompt processing.
///
/// See protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/prompt-turn#3-agent-reports-output)
final class SessionNotification implements AcpJsonEncodable {
  /// Creates a SessionNotification value.
  SessionNotification({
    required this.sessionId,
    required this.update,
    this.meta,
  });

  /// The ID of the session this update pertains to.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeSessionNotificationSessionId,
    toJson: _encodeSessionNotificationSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The actual update content.
  @JsonKey(
    name: 'update',
    fromJson: _decodeSessionNotificationUpdate,
    toJson: _encodeSessionNotificationUpdate,
    includeIfNull: false,
    required: true,
  )
  final SessionUpdate update;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SessionNotification.fromJson(Map<String, Object?> json) =>
      _$SessionNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SessionNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionNotification].
final class SessionNotificationCodec implements AcpCodec<SessionNotification> {
  /// Creates the codec.
  const SessionNotificationCodec();

  @override
  SessionNotification decode(Object? value) =>
      SessionNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionNotification value) => value.toJson();
}

/// Shared codec for [SessionNotification].
const SessionNotificationCodec sessionNotificationCodec =
    SessionNotificationCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for the `session/resume` method.
///
/// Supplying `{}` means the agent supports resuming sessions.
final class SessionResumeCapabilities implements AcpJsonEncodable {
  /// Creates a SessionResumeCapabilities value.
  SessionResumeCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SessionResumeCapabilities.fromJson(Map<String, Object?> json) =>
      _$SessionResumeCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SessionResumeCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SessionResumeCapabilities].
final class SessionResumeCapabilitiesCodec
    implements AcpCodec<SessionResumeCapabilities> {
  /// Creates the codec.
  const SessionResumeCapabilitiesCodec();

  @override
  SessionResumeCapabilities decode(Object? value) =>
      SessionResumeCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(SessionResumeCapabilities value) => value.toJson();
}

/// Shared codec for [SessionResumeCapabilities].
const SessionResumeCapabilitiesCodec sessionResumeCapabilitiesCodec =
    SessionResumeCapabilitiesCodec();

/// Different types of updates that can be sent during session processing.
///
/// These updates provide real-time feedback about the agent's progress.
///
/// See protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/prompt-turn#3-agent-reports-output)
sealed class SessionUpdate implements AcpJsonEncodable {
  const SessionUpdate();

  /// Decodes the tagged union.
  factory SessionUpdate.fromJson(Object? json) =>
      sessionUpdateCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// A chunk of the user's message being streamed.
final class SessionUpdateUserMessageChunk extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateUserMessageChunk(this.value);

  /// The typed variant payload.
  final ContentChunk value;

  @override
  String get discriminator => 'user_message_chunk';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(contentChunkCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A chunk of the agent's response being streamed.
final class SessionUpdateAgentMessageChunk extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateAgentMessageChunk(this.value);

  /// The typed variant payload.
  final ContentChunk value;

  @override
  String get discriminator => 'agent_message_chunk';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(contentChunkCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A chunk of the agent's internal reasoning being streamed.
final class SessionUpdateAgentThoughtChunk extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateAgentThoughtChunk(this.value);

  /// The typed variant payload.
  final ContentChunk value;

  @override
  String get discriminator => 'agent_thought_chunk';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(contentChunkCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Notification that a new tool call has been initiated.
final class SessionUpdateToolCall extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateToolCall(this.value);

  /// The typed variant payload.
  final ToolCall value;

  @override
  String get discriminator => 'tool_call';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(toolCallCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Update on the status or results of a tool call.
final class SessionUpdateToolCallUpdate extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateToolCallUpdate(this.value);

  /// The typed variant payload.
  final ToolCallUpdate value;

  @override
  String get discriminator => 'tool_call_update';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(toolCallUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// The agent's execution plan for complex tasks.
/// See protocol docs: [Agent Plan](https://agentclientprotocol.com/protocol/agent-plan)
final class SessionUpdatePlan extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdatePlan(this.value);

  /// The typed variant payload.
  final Plan value;

  @override
  String get discriminator => 'plan';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(planCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// A content update for a plan identified by ID.
final class SessionUpdatePlanUpdate extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdatePlanUpdate(this.value);

  /// The typed variant payload.
  final PlanUpdate value;

  @override
  String get discriminator => 'plan_update';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(planUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Removal notice for a plan identified by ID.
final class SessionUpdatePlanRemoved extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdatePlanRemoved(this.value);

  /// The typed variant payload.
  final PlanRemoved value;

  @override
  String get discriminator => 'plan_removed';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(planRemovedCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Available commands are ready or have changed
final class SessionUpdateAvailableCommandsUpdate extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateAvailableCommandsUpdate(this.value);

  /// The typed variant payload.
  final AvailableCommandsUpdate value;

  @override
  String get discriminator => 'available_commands_update';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(availableCommandsUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// The current mode of the session has changed
///
/// See protocol docs: [Session Modes](https://agentclientprotocol.com/protocol/session-modes)
final class SessionUpdateCurrentModeUpdate extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateCurrentModeUpdate(this.value);

  /// The typed variant payload.
  final CurrentModeUpdate value;

  @override
  String get discriminator => 'current_mode_update';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(currentModeUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Session configuration options have been updated.
final class SessionUpdateConfigOptionUpdate extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateConfigOptionUpdate(this.value);

  /// The typed variant payload.
  final ConfigOptionUpdate value;

  @override
  String get discriminator => 'config_option_update';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(configOptionUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Session metadata has been updated (title, timestamps, custom metadata)
final class SessionUpdateSessionInfoUpdate extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateSessionInfoUpdate(this.value);

  /// The typed variant payload.
  final SessionInfoUpdate value;

  @override
  String get discriminator => 'session_info_update';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(sessionInfoUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Context window and cost update for the session.
final class SessionUpdateUsageUpdate extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateUsageUpdate(this.value);

  /// The typed variant payload.
  final UsageUpdate value;

  @override
  String get discriminator => 'usage_update';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(usageUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Codec for [SessionUpdate].
final class SessionUpdateCodec implements AcpCodec<SessionUpdate> {
  /// Creates the codec.
  const SessionUpdateCodec();

  @override
  SessionUpdate decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['sessionUpdate']);
    switch (tag) {
      case 'user_message_chunk':
        return SessionUpdateUserMessageChunk(contentChunkCodec.decode(payload));
      case 'agent_message_chunk':
        return SessionUpdateAgentMessageChunk(
          contentChunkCodec.decode(payload),
        );
      case 'agent_thought_chunk':
        return SessionUpdateAgentThoughtChunk(
          contentChunkCodec.decode(payload),
        );
      case 'tool_call':
        return SessionUpdateToolCall(toolCallCodec.decode(payload));
      case 'tool_call_update':
        return SessionUpdateToolCallUpdate(toolCallUpdateCodec.decode(payload));
      case 'plan':
        return SessionUpdatePlan(planCodec.decode(payload));
      case 'plan_update':
        return SessionUpdatePlanUpdate(planUpdateCodec.decode(payload));
      case 'plan_removed':
        return SessionUpdatePlanRemoved(planRemovedCodec.decode(payload));
      case 'available_commands_update':
        return SessionUpdateAvailableCommandsUpdate(
          availableCommandsUpdateCodec.decode(payload),
        );
      case 'current_mode_update':
        return SessionUpdateCurrentModeUpdate(
          currentModeUpdateCodec.decode(payload),
        );
      case 'config_option_update':
        return SessionUpdateConfigOptionUpdate(
          configOptionUpdateCodec.decode(payload),
        );
      case 'session_info_update':
        return SessionUpdateSessionInfoUpdate(
          sessionInfoUpdateCodec.decode(payload),
        );
      case 'usage_update':
        return SessionUpdateUsageUpdate(usageUpdateCodec.decode(payload));
      default:
        throw FormatException('Unknown SessionUpdate tag: $tag');
    }
  }

  @override
  Object encode(SessionUpdate value) => value.toJson();
}

/// Shared codec for [SessionUpdate].
const SessionUpdateCodec sessionUpdateCodec = SessionUpdateCodec();

ProviderId _decodeSetProviderRequestProviderId(Object? value) =>
    providerIdCodec.decode(value);
Object? _encodeSetProviderRequestProviderId(ProviderId value) =>
    providerIdCodec.encode(value);

LlmProtocol _decodeSetProviderRequestApiType(Object? value) =>
    llmProtocolCodec.decode(value);
Object? _encodeSetProviderRequestApiType(LlmProtocol value) =>
    llmProtocolCodec.encode(value);

String _decodeSetProviderRequestBaseUrl(Object? value) =>
    decodeAcpString(value);
Object? _encodeSetProviderRequestBaseUrl(String value) => value;

Map<String, String>? _decodeSetProviderRequestHeaders(Object? value) =>
    value == null
    ? null
    : Map<String, String>.unmodifiable(<String, String>{
        for (final entry in decodeAcpObject(value).entries)
          entry.key: decodeAcpString(entry.value),
      });
Object? _encodeSetProviderRequestHeaders(Map<String, String>? value) =>
    value == null
    ? null
    : <String, Object?>{
        for (final entry in value.entries) entry.key: entry.value,
      };

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Request parameters for `providers/set`.
///
/// Replaces the full configuration for one provider ID.
final class SetProviderRequest implements AcpJsonEncodable {
  /// Creates a SetProviderRequest value.
  SetProviderRequest({
    required this.providerId,
    required this.apiType,
    required this.baseUrl,
    Map<String, String>? headers,
    this.meta,
  }) : headers = headers == null
           ? null
           : Map<String, String>.unmodifiable(headers);

  /// Provider ID to configure.
  @JsonKey(
    name: 'providerId',
    fromJson: _decodeSetProviderRequestProviderId,
    toJson: _encodeSetProviderRequestProviderId,
    includeIfNull: false,
    required: true,
  )
  final ProviderId providerId;

  /// Protocol type for this provider.
  @JsonKey(
    name: 'apiType',
    fromJson: _decodeSetProviderRequestApiType,
    toJson: _encodeSetProviderRequestApiType,
    includeIfNull: false,
    required: true,
  )
  final LlmProtocol apiType;

  /// Base URL for requests sent through this provider.
  @JsonKey(
    name: 'baseUrl',
    fromJson: _decodeSetProviderRequestBaseUrl,
    toJson: _encodeSetProviderRequestBaseUrl,
    includeIfNull: false,
    required: true,
  )
  final String baseUrl;

  /// Full headers map for this provider.
  /// May include authorization, routing, or other integration-specific headers.
  @JsonKey(
    name: 'headers',
    fromJson: _decodeSetProviderRequestHeaders,
    toJson: _encodeSetProviderRequestHeaders,
    includeIfNull: false,
    required: false,
  )
  final Map<String, String>? headers;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SetProviderRequest.fromJson(Map<String, Object?> json) =>
      _$SetProviderRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SetProviderRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SetProviderRequest].
final class SetProviderRequestCodec implements AcpCodec<SetProviderRequest> {
  /// Creates the codec.
  const SetProviderRequestCodec();

  @override
  SetProviderRequest decode(Object? value) =>
      SetProviderRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(SetProviderRequest value) => value.toJson();
}

/// Shared codec for [SetProviderRequest].
const SetProviderRequestCodec setProviderRequestCodec =
    SetProviderRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Response to `providers/set`.
final class SetProviderResponse implements AcpJsonEncodable {
  /// Creates a SetProviderResponse value.
  SetProviderResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SetProviderResponse.fromJson(Map<String, Object?> json) =>
      _$SetProviderResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SetProviderResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SetProviderResponse].
final class SetProviderResponseCodec implements AcpCodec<SetProviderResponse> {
  /// Creates the codec.
  const SetProviderResponseCodec();

  @override
  SetProviderResponse decode(Object? value) =>
      SetProviderResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(SetProviderResponse value) => value.toJson();
}

/// Shared codec for [SetProviderResponse].
const SetProviderResponseCodec setProviderResponseCodec =
    SetProviderResponseCodec();

/// Request parameters for setting a session configuration option.
final class SetSessionConfigOptionRequest implements AcpJsonEncodable {
  /// Creates a SetSessionConfigOptionRequest value.
  SetSessionConfigOptionRequest({
    required this.sessionId,
    required this.configId,
    required this.variant,
    this.meta,
  });

  /// The ID of the session to set the configuration option for.
  final SessionId sessionId;

  /// The ID of the configuration option to set.
  final SessionConfigId configId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// The concrete schema composition branch.
  final SetSessionConfigOptionRequestVariant variant;

  /// Decodes this composed model with resilient fields.
  static AcpDecoded<SetSessionConfigOptionRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SetSessionConfigOptionRequest(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      configId: decoder.required(
        'configId',
        (value) => sessionConfigIdCodec.decode(value),
      ),
      meta: decoder.meta(),
      variant: _decodeSetSessionConfigOptionRequestVariant(json),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SetSessionConfigOptionRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{...variant.toJson()};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['configId'] = sessionConfigIdCodec.encode(configId);
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// One concrete composition branch for [SetSessionConfigOptionRequest].
sealed class SetSessionConfigOptionRequestVariant {
  const SetSessionConfigOptionRequestVariant();

  /// Encodes the branch fields into their flattened object.
  Map<String, Object?> toJson();
}

/// A boolean value (`type: "boolean"`).
final class SetSessionConfigOptionRequestBoolean
    extends SetSessionConfigOptionRequestVariant {
  /// Creates a SetSessionConfigOptionRequestBoolean value.
  SetSessionConfigOptionRequestBoolean({required this.value});

  /// The boolean value.
  final bool value;

  @override
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['value'] = value;
    result['type'] = 'boolean';
    return result;
  }
}

/// A `SessionConfigValueId` string value.
///
/// This is the default when `type` is absent on the wire. Unknown `type`
/// values with string payloads also gracefully deserialize into this
/// variant.
final class SetSessionConfigOptionRequestValueId
    extends SetSessionConfigOptionRequestVariant {
  /// Creates a SetSessionConfigOptionRequestValueId value.
  SetSessionConfigOptionRequestValueId({required this.value});

  /// The value ID.
  final SessionConfigValueId value;

  @override
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['value'] = sessionConfigValueIdCodec.encode(value);
    return result;
  }
}

SetSessionConfigOptionRequestVariant
_decodeSetSessionConfigOptionRequestVariant(Object? value) {
  final payload = decodeAcpObject(value);
  if (payload['type'] == 'boolean') {
    return SetSessionConfigOptionRequestBoolean(
      value: decodeAcpBoolean(payload['value']),
    );
  }
  try {
    return SetSessionConfigOptionRequestValueId(
      value: sessionConfigValueIdCodec.decode(payload['value']),
    );
  } on Object {
    // Try the next structurally distinct branch.
  }
  throw const FormatException(
    'Value does not match SetSessionConfigOptionRequest',
  );
}

/// Codec for [SetSessionConfigOptionRequest].
final class SetSessionConfigOptionRequestCodec
    implements AcpCodec<SetSessionConfigOptionRequest> {
  /// Creates the codec.
  const SetSessionConfigOptionRequestCodec();

  @override
  SetSessionConfigOptionRequest decode(Object? value) =>
      SetSessionConfigOptionRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(SetSessionConfigOptionRequest value) => value.toJson();
}

/// Shared codec for [SetSessionConfigOptionRequest].
const SetSessionConfigOptionRequestCodec setSessionConfigOptionRequestCodec =
    SetSessionConfigOptionRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Response to `session/set_config_option` method.
final class SetSessionConfigOptionResponse implements AcpJsonEncodable {
  /// Creates a SetSessionConfigOptionResponse value.
  SetSessionConfigOptionResponse({
    required List<SessionConfigOption> configOptions,
    this.meta,
  }) : configOptions = List<SessionConfigOption>.unmodifiable(configOptions);

  /// The full set of configuration options and their current values.
  final List<SessionConfigOption> configOptions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SetSessionConfigOptionResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SetSessionConfigOptionResponse(
      configOptions: decoder.listSkippingInvalid(
        'configOptions',
        (value) => sessionConfigOptionCodec.decode(value),
        isRequired: true,
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SetSessionConfigOptionResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['configOptions'] = <Object?>[
      for (final item in configOptions) sessionConfigOptionCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SetSessionConfigOptionResponse].
final class SetSessionConfigOptionResponseCodec
    implements AcpCodec<SetSessionConfigOptionResponse> {
  /// Creates the codec.
  const SetSessionConfigOptionResponseCodec();

  @override
  SetSessionConfigOptionResponse decode(Object? value) =>
      SetSessionConfigOptionResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(SetSessionConfigOptionResponse value) => value.toJson();
}

/// Shared codec for [SetSessionConfigOptionResponse].
const SetSessionConfigOptionResponseCodec setSessionConfigOptionResponseCodec =
    SetSessionConfigOptionResponseCodec();

SessionId _decodeSetSessionModeRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeSetSessionModeRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

SessionModeId _decodeSetSessionModeRequestModeId(Object? value) =>
    sessionModeIdCodec.decode(value);
Object? _encodeSetSessionModeRequestModeId(SessionModeId value) =>
    sessionModeIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for setting a session mode.
final class SetSessionModeRequest implements AcpJsonEncodable {
  /// Creates a SetSessionModeRequest value.
  SetSessionModeRequest({
    required this.sessionId,
    required this.modeId,
    this.meta,
  });

  /// The ID of the session to set the mode for.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeSetSessionModeRequestSessionId,
    toJson: _encodeSetSessionModeRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The ID of the mode to set.
  @JsonKey(
    name: 'modeId',
    fromJson: _decodeSetSessionModeRequestModeId,
    toJson: _encodeSetSessionModeRequestModeId,
    includeIfNull: false,
    required: true,
  )
  final SessionModeId modeId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SetSessionModeRequest.fromJson(Map<String, Object?> json) =>
      _$SetSessionModeRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SetSessionModeRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SetSessionModeRequest].
final class SetSessionModeRequestCodec
    implements AcpCodec<SetSessionModeRequest> {
  /// Creates the codec.
  const SetSessionModeRequestCodec();

  @override
  SetSessionModeRequest decode(Object? value) =>
      SetSessionModeRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(SetSessionModeRequest value) => value.toJson();
}

/// Shared codec for [SetSessionModeRequest].
const SetSessionModeRequestCodec setSessionModeRequestCodec =
    SetSessionModeRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to `session/set_mode` method.
final class SetSessionModeResponse implements AcpJsonEncodable {
  /// Creates a SetSessionModeResponse value.
  SetSessionModeResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SetSessionModeResponse.fromJson(Map<String, Object?> json) =>
      _$SetSessionModeResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SetSessionModeResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SetSessionModeResponse].
final class SetSessionModeResponseCodec
    implements AcpCodec<SetSessionModeResponse> {
  /// Creates the codec.
  const SetSessionModeResponseCodec();

  @override
  SetSessionModeResponse decode(Object? value) =>
      SetSessionModeResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(SetSessionModeResponse value) => value.toJson();
}

/// Shared codec for [SetSessionModeResponse].
const SetSessionModeResponseCodec setSessionModeResponseCodec =
    SetSessionModeResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request to start an NES session.
final class StartNesRequest implements AcpJsonEncodable {
  /// Creates a StartNesRequest value.
  StartNesRequest({
    this.workspaceUri,
    List<WorkspaceFolder>? workspaceFolders,
    this.repository,
    this.meta,
  }) : workspaceFolders = workspaceFolders == null
           ? null
           : List<WorkspaceFolder>.unmodifiable(workspaceFolders);

  /// The root URI of the workspace.
  final String? workspaceUri;

  /// The workspace folders.
  final List<WorkspaceFolder>? workspaceFolders;

  /// Repository metadata, if the workspace is a git repository.
  final NesRepository? repository;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<StartNesRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = StartNesRequest(
      workspaceUri: decoder
          .optionalOnError('workspaceUri', (value) => decodeAcpString(value))
          .valueOrNull,
      workspaceFolders: decoder.optional(
        'workspaceFolders',
        (value) => List<WorkspaceFolder>.unmodifiable(
          (value as List<Object?>).map(
            (item) => workspaceFolderCodec.decode(item),
          ),
        ),
      ),
      repository: decoder
          .optionalOnError(
            'repository',
            (value) => nesRepositoryCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory StartNesRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (workspaceUri != null) {
      result['workspaceUri'] = workspaceUri!;
    }
    if (workspaceFolders != null) {
      result['workspaceFolders'] = <Object?>[
        for (final item in workspaceFolders!) workspaceFolderCodec.encode(item),
      ];
    }
    if (repository != null) {
      result['repository'] = nesRepositoryCodec.encode(repository!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [StartNesRequest].
final class StartNesRequestCodec implements AcpCodec<StartNesRequest> {
  /// Creates the codec.
  const StartNesRequestCodec();

  @override
  StartNesRequest decode(Object? value) =>
      StartNesRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(StartNesRequest value) => value.toJson();
}

/// Shared codec for [StartNesRequest].
const StartNesRequestCodec startNesRequestCodec = StartNesRequestCodec();

SessionId _decodeStartNesResponseSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeStartNesResponseSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to `nes/start`.
final class StartNesResponse implements AcpJsonEncodable {
  /// Creates a StartNesResponse value.
  StartNesResponse({required this.sessionId, this.meta});

  /// The session ID for the newly started NES session.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeStartNesResponseSessionId,
    toJson: _encodeStartNesResponseSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory StartNesResponse.fromJson(Map<String, Object?> json) =>
      _$StartNesResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$StartNesResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [StartNesResponse].
final class StartNesResponseCodec implements AcpCodec<StartNesResponse> {
  /// Creates the codec.
  const StartNesResponseCodec();

  @override
  StartNesResponse decode(Object? value) =>
      StartNesResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(StartNesResponse value) => value.toJson();
}

/// Shared codec for [StartNesResponse].
const StartNesResponseCodec startNesResponseCodec = StartNesResponseCodec();

/// Reasons why an agent stops processing a prompt turn.
///
/// See protocol docs: [Stop Reasons](https://agentclientprotocol.com/protocol/prompt-turn#stop-reasons)
final class StopReason implements AcpJsonEncodable {
  /// Validates and creates a StopReason value.
  factory StopReason(String value) {
    if (!const <String>{
      'end_turn',
      'max_tokens',
      'max_turn_requests',
      'refusal',
      'cancelled',
    }.contains(value)) {
      throw FormatException('Unknown StopReason: $value');
    }
    return StopReason._(value);
  }

  const StopReason._(this.value);

  /// The exact wire string.
  final String value;

  /// The `end_turn` schema value.
  static const StopReason endTurn = StopReason._('end_turn');

  /// The `max_tokens` schema value.
  static const StopReason maxTokens = StopReason._('max_tokens');

  /// The `max_turn_requests` schema value.
  static const StopReason maxTurnRequests = StopReason._('max_turn_requests');

  /// The `refusal` schema value.
  static const StopReason refusal = StopReason._('refusal');

  /// The `cancelled` schema value.
  static const StopReason cancelled = StopReason._('cancelled');

  /// Decodes a wire string.
  factory StopReason.fromJson(Object? json) =>
      StopReason(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is StopReason && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [StopReason].
final class StopReasonCodec implements AcpCodec<StopReason> {
  /// Creates the codec.
  const StopReasonCodec();

  @override
  StopReason decode(Object? value) => StopReason.fromJson(value);

  @override
  String encode(StopReason value) => value.toJson();
}

/// Shared codec for [StopReason].
const StopReasonCodec stopReasonCodec = StopReasonCodec();

/// String format types for string properties in elicitation schemas.
final class StringFormat implements AcpJsonEncodable {
  /// Validates and creates a StringFormat value.
  factory StringFormat(String value) {
    if (!const <String>{'email', 'uri', 'date', 'date-time'}.contains(value)) {
      throw FormatException('Unknown StringFormat: $value');
    }
    return StringFormat._(value);
  }

  const StringFormat._(this.value);

  /// The exact wire string.
  final String value;

  /// The `email` schema value.
  static const StringFormat email = StringFormat._('email');

  /// The `uri` schema value.
  static const StringFormat uri = StringFormat._('uri');

  /// The `date` schema value.
  static const StringFormat date = StringFormat._('date');

  /// The `date-time` schema value.
  static const StringFormat dateTime = StringFormat._('date-time');

  /// Decodes a wire string.
  factory StringFormat.fromJson(Object? json) =>
      StringFormat(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is StringFormat && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [StringFormat].
final class StringFormatCodec implements AcpCodec<StringFormat> {
  /// Creates the codec.
  const StringFormatCodec();

  @override
  StringFormat decode(Object? value) => StringFormat.fromJson(value);

  @override
  String encode(StringFormat value) => value.toJson();
}

/// Shared codec for [StringFormat].
const StringFormatCodec stringFormatCodec = StringFormatCodec();

List<String> _decodeStringMultiSelectItemsEnumValue(Object? value) =>
    List<String>.unmodifiable(
      (value as List<Object?>).map((item) => decodeAcpString(item)),
    );
Object? _encodeStringMultiSelectItemsEnumValue(List<String> value) => <Object?>[
  for (final item in value) item,
];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// String item schema for multi-select enum properties.
final class StringMultiSelectItems implements AcpJsonEncodable {
  /// Creates a StringMultiSelectItems value.
  StringMultiSelectItems({required List<String> enumValue, this.meta})
    : enumValue = List<String>.unmodifiable(enumValue);

  /// Allowed enum values.
  @JsonKey(
    name: 'enum',
    fromJson: _decodeStringMultiSelectItemsEnumValue,
    toJson: _encodeStringMultiSelectItemsEnumValue,
    includeIfNull: false,
    required: true,
  )
  final List<String> enumValue;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory StringMultiSelectItems.fromJson(Map<String, Object?> json) =>
      _$StringMultiSelectItemsFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$StringMultiSelectItemsToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [StringMultiSelectItems].
final class StringMultiSelectItemsCodec
    implements AcpCodec<StringMultiSelectItems> {
  /// Creates the codec.
  const StringMultiSelectItemsCodec();

  @override
  StringMultiSelectItems decode(Object? value) =>
      StringMultiSelectItems.fromJson(decodeAcpObject(value));

  @override
  Object encode(StringMultiSelectItems value) => value.toJson();
}

/// Shared codec for [StringMultiSelectItems].
const StringMultiSelectItemsCodec stringMultiSelectItemsCodec =
    StringMultiSelectItemsCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Schema for string properties in an elicitation form.
///
/// When `enum` or `oneOf` is set, this represents a single-select enum
/// with `"type": "string"`.
final class StringPropertySchema implements AcpJsonEncodable {
  /// Creates a StringPropertySchema value.
  StringPropertySchema({
    this.title,
    this.description,
    this.minLength,
    this.maxLength,
    this.pattern,
    this.format,
    this.defaultValue,
    List<String>? enumValue,
    List<EnumOption>? oneOf,
    this.meta,
  }) : enumValue = enumValue == null
           ? null
           : List<String>.unmodifiable(enumValue),
       oneOf = oneOf == null ? null : List<EnumOption>.unmodifiable(oneOf);

  /// Optional title for the property.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no title is provided.
  final String? title;

  /// Human-readable description.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no description is provided.
  final String? description;

  /// Minimum string length.
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no minimum length constraint.
  final int? minLength;

  /// Maximum string length.
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no maximum length constraint.
  final int? maxLength;

  /// Pattern the string must match.
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no pattern constraint.
  final String? pattern;

  /// String format.
  ///
  /// Optional. Omitted and `null` are equivalent and mean there is no format constraint.
  final StringFormat? format;

  /// Default value.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no default value is provided.
  final String? defaultValue;

  /// Enum values for untitled single-select enums.
  /// Optional. Omitted and `null` are equivalent and mean no untitled single-select choices are
  /// declared by `enum`.
  final List<String>? enumValue;

  /// Titled enum options for titled single-select enums.
  /// Optional. Omitted and `null` are equivalent and mean no titled single-select choices are
  /// declared by `oneOf`.
  final List<EnumOption>? oneOf;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<StringPropertySchema> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = StringPropertySchema(
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      minLength: decoder.optional(
        'minLength',
        (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
      ),
      maxLength: decoder.optional(
        'maxLength',
        (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
      ),
      pattern: decoder.optional('pattern', (value) => decodeAcpString(value)),
      format: decoder.optional(
        'format',
        (value) => stringFormatCodec.decode(value),
      ),
      defaultValue: decoder
          .optionalOnError('default', (value) => decodeAcpString(value))
          .valueOrNull,
      enumValue: decoder.optional(
        'enum',
        (value) => List<String>.unmodifiable(
          (value as List<Object?>).map((item) => decodeAcpString(item)),
        ),
      ),
      oneOf: decoder.optional(
        'oneOf',
        (value) => List<EnumOption>.unmodifiable(
          (value as List<Object?>).map((item) => enumOptionCodec.decode(item)),
        ),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory StringPropertySchema.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (title != null) {
      result['title'] = title!;
    }
    if (description != null) {
      result['description'] = description!;
    }
    if (minLength != null) {
      result['minLength'] = minLength!;
    }
    if (maxLength != null) {
      result['maxLength'] = maxLength!;
    }
    if (pattern != null) {
      result['pattern'] = pattern!;
    }
    if (format != null) {
      result['format'] = stringFormatCodec.encode(format!);
    }
    if (defaultValue != null) {
      result['default'] = defaultValue!;
    }
    if (enumValue != null) {
      result['enum'] = <Object?>[for (final item in enumValue!) item];
    }
    if (oneOf != null) {
      result['oneOf'] = <Object?>[
        for (final item in oneOf!) enumOptionCodec.encode(item),
      ];
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [StringPropertySchema].
final class StringPropertySchemaCodec
    implements AcpCodec<StringPropertySchema> {
  /// Creates the codec.
  const StringPropertySchemaCodec();

  @override
  StringPropertySchema decode(Object? value) =>
      StringPropertySchema.fromJson(decodeAcpObject(value));

  @override
  Object encode(StringPropertySchema value) => value.toJson();
}

/// Shared codec for [StringPropertySchema].
const StringPropertySchemaCodec stringPropertySchemaCodec =
    StringPropertySchemaCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request for a code suggestion.
final class SuggestNesRequest implements AcpJsonEncodable {
  /// Creates a SuggestNesRequest value.
  SuggestNesRequest({
    required this.sessionId,
    required this.uri,
    required this.version,
    required this.position,
    required this.triggerKind,
    this.selection,
    this.context,
    this.meta,
  });

  /// The session ID for this request.
  final SessionId sessionId;

  /// The URI of the document to suggest for.
  final String uri;

  /// The version number of the document.
  final AcpInt64 version;

  /// The current cursor position.
  final Position position;

  /// The current text selection range, if any.
  final Range? selection;

  /// What triggered this suggestion request.
  final NesTriggerKind triggerKind;

  /// Context for the suggestion, included based on agent capabilities.
  final NesSuggestContext? context;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SuggestNesRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SuggestNesRequest(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      uri: decoder.required('uri', (value) => decodeAcpString(value)),
      version: decoder.required('version', (value) => decodeAcpInt64(value)),
      position: decoder.required(
        'position',
        (value) => positionCodec.decode(value),
      ),
      selection: decoder.optional(
        'selection',
        (value) => rangeCodec.decode(value),
      ),
      triggerKind: decoder.required(
        'triggerKind',
        (value) => nesTriggerKindCodec.decode(value),
      ),
      context: decoder.optional(
        'context',
        (value) => nesSuggestContextCodec.decode(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory SuggestNesRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['uri'] = uri;
    result['version'] = encodeAcpInt64(version);
    result['position'] = positionCodec.encode(position);
    if (selection != null) {
      result['selection'] = rangeCodec.encode(selection!);
    }
    result['triggerKind'] = nesTriggerKindCodec.encode(triggerKind);
    if (context != null) {
      result['context'] = nesSuggestContextCodec.encode(context!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SuggestNesRequest].
final class SuggestNesRequestCodec implements AcpCodec<SuggestNesRequest> {
  /// Creates the codec.
  const SuggestNesRequestCodec();

  @override
  SuggestNesRequest decode(Object? value) =>
      SuggestNesRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(SuggestNesRequest value) => value.toJson();
}

/// Shared codec for [SuggestNesRequest].
const SuggestNesRequestCodec suggestNesRequestCodec = SuggestNesRequestCodec();

List<NesSuggestion> _decodeSuggestNesResponseSuggestions(Object? value) =>
    List<NesSuggestion>.unmodifiable(
      (value as List<Object?>).map((item) => nesSuggestionCodec.decode(item)),
    );
Object? _encodeSuggestNesResponseSuggestions(List<NesSuggestion> value) =>
    <Object?>[for (final item in value) nesSuggestionCodec.encode(item)];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to `nes/suggest`.
final class SuggestNesResponse implements AcpJsonEncodable {
  /// Creates a SuggestNesResponse value.
  SuggestNesResponse({required List<NesSuggestion> suggestions, this.meta})
    : suggestions = List<NesSuggestion>.unmodifiable(suggestions);

  /// The list of suggestions.
  @JsonKey(
    name: 'suggestions',
    fromJson: _decodeSuggestNesResponseSuggestions,
    toJson: _encodeSuggestNesResponseSuggestions,
    includeIfNull: false,
    required: true,
  )
  final List<NesSuggestion> suggestions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory SuggestNesResponse.fromJson(Map<String, Object?> json) =>
      _$SuggestNesResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$SuggestNesResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [SuggestNesResponse].
final class SuggestNesResponseCodec implements AcpCodec<SuggestNesResponse> {
  /// Creates the codec.
  const SuggestNesResponseCodec();

  @override
  SuggestNesResponse decode(Object? value) =>
      SuggestNesResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(SuggestNesResponse value) => value.toJson();
}

/// Shared codec for [SuggestNesResponse].
const SuggestNesResponseCodec suggestNesResponseCodec =
    SuggestNesResponseCodec();

TerminalId _decodeTerminalTerminalId(Object? value) =>
    terminalIdCodec.decode(value);
Object? _encodeTerminalTerminalId(TerminalId value) =>
    terminalIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Embed a terminal created with `terminal/create` by its id.
///
/// The terminal must be added before calling `terminal/release`.
///
/// See protocol docs: [Terminal](https://agentclientprotocol.com/protocol/terminals)
final class Terminal implements AcpJsonEncodable {
  /// Creates a Terminal value.
  Terminal({required this.terminalId, this.meta});

  /// Identifier of the terminal instance to embed in the content stream.
  @JsonKey(
    name: 'terminalId',
    fromJson: _decodeTerminalTerminalId,
    toJson: _encodeTerminalTerminalId,
    includeIfNull: false,
    required: true,
  )
  final TerminalId terminalId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory Terminal.fromJson(Map<String, Object?> json) =>
      _$TerminalFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$TerminalToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Terminal].
final class TerminalCodec implements AcpCodec<Terminal> {
  /// Creates the codec.
  const TerminalCodec();

  @override
  Terminal decode(Object? value) => Terminal.fromJson(decodeAcpObject(value));

  @override
  Object encode(Terminal value) => value.toJson();
}

/// Shared codec for [Terminal].
const TerminalCodec terminalCodec = TerminalCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Exit status of a terminal command.
final class TerminalExitStatus implements AcpJsonEncodable {
  /// Creates a TerminalExitStatus value.
  TerminalExitStatus({this.exitCode, this.signal, this.meta});

  /// The process exit code (may be null if terminated by signal).
  final int? exitCode;

  /// The signal that terminated the process (may be null if exited normally).
  final String? signal;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<TerminalExitStatus> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = TerminalExitStatus(
      exitCode: decoder
          .optionalOnError(
            'exitCode',
            (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
          )
          .valueOrNull,
      signal: decoder
          .optionalOnError('signal', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory TerminalExitStatus.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (exitCode != null) {
      result['exitCode'] = exitCode!;
    }
    if (signal != null) {
      result['signal'] = signal!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TerminalExitStatus].
final class TerminalExitStatusCodec implements AcpCodec<TerminalExitStatus> {
  /// Creates the codec.
  const TerminalExitStatusCodec();

  @override
  TerminalExitStatus decode(Object? value) =>
      TerminalExitStatus.fromJson(decodeAcpObject(value));

  @override
  Object encode(TerminalExitStatus value) => value.toJson();
}

/// Shared codec for [TerminalExitStatus].
const TerminalExitStatusCodec terminalExitStatusCodec =
    TerminalExitStatusCodec();

/// Typed identifier used for terminal values on the wire.
final class TerminalId implements AcpJsonEncodable {
  /// Validates and creates a TerminalId value.
  factory TerminalId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return TerminalId._(value);
  }

  const TerminalId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory TerminalId.fromJson(Object? json) =>
      TerminalId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is TerminalId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [TerminalId].
final class TerminalIdCodec implements AcpCodec<TerminalId> {
  /// Creates the codec.
  const TerminalIdCodec();

  @override
  TerminalId decode(Object? value) => TerminalId.fromJson(value);

  @override
  String encode(TerminalId value) => value.toJson();
}

/// Shared codec for [TerminalId].
const TerminalIdCodec terminalIdCodec = TerminalIdCodec();

SessionId _decodeTerminalOutputRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeTerminalOutputRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

TerminalId _decodeTerminalOutputRequestTerminalId(Object? value) =>
    terminalIdCodec.decode(value);
Object? _encodeTerminalOutputRequestTerminalId(TerminalId value) =>
    terminalIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request to get the current output and status of a terminal.
final class TerminalOutputRequest implements AcpJsonEncodable {
  /// Creates a TerminalOutputRequest value.
  TerminalOutputRequest({
    required this.sessionId,
    required this.terminalId,
    this.meta,
  });

  /// The session ID for this request.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeTerminalOutputRequestSessionId,
    toJson: _encodeTerminalOutputRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The ID of the terminal to get output from.
  @JsonKey(
    name: 'terminalId',
    fromJson: _decodeTerminalOutputRequestTerminalId,
    toJson: _encodeTerminalOutputRequestTerminalId,
    includeIfNull: false,
    required: true,
  )
  final TerminalId terminalId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory TerminalOutputRequest.fromJson(Map<String, Object?> json) =>
      _$TerminalOutputRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$TerminalOutputRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TerminalOutputRequest].
final class TerminalOutputRequestCodec
    implements AcpCodec<TerminalOutputRequest> {
  /// Creates the codec.
  const TerminalOutputRequestCodec();

  @override
  TerminalOutputRequest decode(Object? value) =>
      TerminalOutputRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(TerminalOutputRequest value) => value.toJson();
}

/// Shared codec for [TerminalOutputRequest].
const TerminalOutputRequestCodec terminalOutputRequestCodec =
    TerminalOutputRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Response containing the terminal output and exit status.
final class TerminalOutputResponse implements AcpJsonEncodable {
  /// Creates a TerminalOutputResponse value.
  TerminalOutputResponse({
    required this.output,
    required this.truncated,
    this.exitStatus,
    this.meta,
  });

  /// The terminal output captured so far.
  final String output;

  /// Whether the output was truncated due to byte limits.
  final bool truncated;

  /// Exit status if the command has completed.
  final TerminalExitStatus? exitStatus;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<TerminalOutputResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = TerminalOutputResponse(
      output: decoder.required('output', (value) => decodeAcpString(value)),
      truncated: decoder.required(
        'truncated',
        (value) => decodeAcpBoolean(value),
      ),
      exitStatus: decoder
          .optionalOnError(
            'exitStatus',
            (value) => terminalExitStatusCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory TerminalOutputResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['output'] = output;
    result['truncated'] = truncated;
    if (exitStatus != null) {
      result['exitStatus'] = terminalExitStatusCodec.encode(exitStatus!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TerminalOutputResponse].
final class TerminalOutputResponseCodec
    implements AcpCodec<TerminalOutputResponse> {
  /// Creates the codec.
  const TerminalOutputResponseCodec();

  @override
  TerminalOutputResponse decode(Object? value) =>
      TerminalOutputResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(TerminalOutputResponse value) => value.toJson();
}

/// Shared codec for [TerminalOutputResponse].
const TerminalOutputResponseCodec terminalOutputResponseCodec =
    TerminalOutputResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Text provided to or from an LLM.
final class TextContent implements AcpJsonEncodable {
  /// Creates a TextContent value.
  TextContent({required this.text, this.annotations, this.meta});

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// Text payload carried by this content block.
  final String text;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<TextContent> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = TextContent(
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
          .valueOrNull,
      text: decoder.required('text', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory TextContent.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
    }
    result['text'] = text;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TextContent].
final class TextContentCodec implements AcpCodec<TextContent> {
  /// Creates the codec.
  const TextContentCodec();

  @override
  TextContent decode(Object? value) =>
      TextContent.fromJson(decodeAcpObject(value));

  @override
  Object encode(TextContent value) => value.toJson();
}

/// Shared codec for [TextContent].
const TextContentCodec textContentCodec = TextContentCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A content change event for a document.
///
/// When `range` is `None`, `text` is the full content of the document.
/// When `range` is `Some`, `text` replaces the given range.
final class TextDocumentContentChangeEvent implements AcpJsonEncodable {
  /// Creates a TextDocumentContentChangeEvent value.
  TextDocumentContentChangeEvent({required this.text, this.range, this.meta});

  /// The range of the document that changed. If `None`, the entire content is replaced.
  final Range? range;

  /// The new text for the range, or the full document content if `range` is `None`.
  final String text;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<TextDocumentContentChangeEvent> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = TextDocumentContentChangeEvent(
      range: decoder.optional('range', (value) => rangeCodec.decode(value)),
      text: decoder.required('text', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory TextDocumentContentChangeEvent.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (range != null) {
      result['range'] = rangeCodec.encode(range!);
    }
    result['text'] = text;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TextDocumentContentChangeEvent].
final class TextDocumentContentChangeEventCodec
    implements AcpCodec<TextDocumentContentChangeEvent> {
  /// Creates the codec.
  const TextDocumentContentChangeEventCodec();

  @override
  TextDocumentContentChangeEvent decode(Object? value) =>
      TextDocumentContentChangeEvent.fromJson(decodeAcpObject(value));

  @override
  Object encode(TextDocumentContentChangeEvent value) => value.toJson();
}

/// Shared codec for [TextDocumentContentChangeEvent].
const TextDocumentContentChangeEventCodec textDocumentContentChangeEventCodec =
    TextDocumentContentChangeEventCodec();

/// How the agent wants document changes delivered.
final class TextDocumentSyncKind implements AcpJsonEncodable {
  /// Validates and creates a TextDocumentSyncKind value.
  factory TextDocumentSyncKind(String value) {
    if (!const <String>{'full', 'incremental'}.contains(value)) {
      throw FormatException('Unknown TextDocumentSyncKind: $value');
    }
    return TextDocumentSyncKind._(value);
  }

  const TextDocumentSyncKind._(this.value);

  /// The exact wire string.
  final String value;

  /// The `full` schema value.
  static const TextDocumentSyncKind full = TextDocumentSyncKind._('full');

  /// The `incremental` schema value.
  static const TextDocumentSyncKind incremental = TextDocumentSyncKind._(
    'incremental',
  );

  /// Decodes a wire string.
  factory TextDocumentSyncKind.fromJson(Object? json) =>
      TextDocumentSyncKind(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is TextDocumentSyncKind && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [TextDocumentSyncKind].
final class TextDocumentSyncKindCodec
    implements AcpCodec<TextDocumentSyncKind> {
  /// Creates the codec.
  const TextDocumentSyncKindCodec();

  @override
  TextDocumentSyncKind decode(Object? value) =>
      TextDocumentSyncKind.fromJson(value);

  @override
  String encode(TextDocumentSyncKind value) => value.toJson();
}

/// Shared codec for [TextDocumentSyncKind].
const TextDocumentSyncKindCodec textDocumentSyncKindCodec =
    TextDocumentSyncKindCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Text-based resource contents.
final class TextResourceContents implements AcpJsonEncodable {
  /// Creates a TextResourceContents value.
  TextResourceContents({
    required this.text,
    required this.uri,
    this.mimeType,
    this.meta,
  });

  /// MIME type describing the encoded media payload.
  final String? mimeType;

  /// Text payload carried by this content block.
  final String text;

  /// URI associated with this resource or media payload.
  final String uri;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<TextResourceContents> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = TextResourceContents(
      mimeType: decoder
          .optionalOnError('mimeType', (value) => decodeAcpString(value))
          .valueOrNull,
      text: decoder.required('text', (value) => decodeAcpString(value)),
      uri: decoder.required('uri', (value) => decodeAcpString(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory TextResourceContents.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (mimeType != null) {
      result['mimeType'] = mimeType!;
    }
    result['text'] = text;
    result['uri'] = uri;
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TextResourceContents].
final class TextResourceContentsCodec
    implements AcpCodec<TextResourceContents> {
  /// Creates the codec.
  const TextResourceContentsCodec();

  @override
  TextResourceContents decode(Object? value) =>
      TextResourceContents.fromJson(decodeAcpObject(value));

  @override
  Object encode(TextResourceContents value) => value.toJson();
}

/// Shared codec for [TextResourceContents].
const TextResourceContentsCodec textResourceContentsCodec =
    TextResourceContentsCodec();

List<EnumOption> _decodeTitledMultiSelectItemsAnyOf(Object? value) =>
    List<EnumOption>.unmodifiable(
      (value as List<Object?>).map((item) => enumOptionCodec.decode(item)),
    );
Object? _encodeTitledMultiSelectItemsAnyOf(List<EnumOption> value) => <Object?>[
  for (final item in value) enumOptionCodec.encode(item),
];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Items definition for titled multi-select enum properties.
final class TitledMultiSelectItems implements AcpJsonEncodable {
  /// Creates a TitledMultiSelectItems value.
  TitledMultiSelectItems({required List<EnumOption> anyOf, this.meta})
    : anyOf = List<EnumOption>.unmodifiable(anyOf);

  /// Titled enum options.
  @JsonKey(
    name: 'anyOf',
    fromJson: _decodeTitledMultiSelectItemsAnyOf,
    toJson: _encodeTitledMultiSelectItemsAnyOf,
    includeIfNull: false,
    required: true,
  )
  final List<EnumOption> anyOf;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory TitledMultiSelectItems.fromJson(Map<String, Object?> json) =>
      _$TitledMultiSelectItemsFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$TitledMultiSelectItemsToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TitledMultiSelectItems].
final class TitledMultiSelectItemsCodec
    implements AcpCodec<TitledMultiSelectItems> {
  /// Creates the codec.
  const TitledMultiSelectItemsCodec();

  @override
  TitledMultiSelectItems decode(Object? value) =>
      TitledMultiSelectItems.fromJson(decodeAcpObject(value));

  @override
  Object encode(TitledMultiSelectItems value) => value.toJson();
}

/// Shared codec for [TitledMultiSelectItems].
const TitledMultiSelectItemsCodec titledMultiSelectItemsCodec =
    TitledMultiSelectItemsCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Represents a tool call that the language model has requested.
///
/// Tool calls are actions that the agent executes on behalf of the language model,
/// such as reading files, executing code, or fetching data from external sources.
///
/// See protocol docs: [Tool Calls](https://agentclientprotocol.com/protocol/tool-calls)
final class ToolCall implements AcpJsonEncodable {
  /// Creates a ToolCall value.
  ToolCall({
    required this.toolCallId,
    required this.title,
    this.name,
    this.kind,
    this.status,
    List<ToolCallContent>? content,
    List<ToolCallLocation>? locations,
    this.rawInput,
    this.rawOutput,
    this.meta,
  }) : content = content == null
           ? null
           : List<ToolCallContent>.unmodifiable(content),
       locations = locations == null
           ? null
           : List<ToolCallLocation>.unmodifiable(locations);

  /// Unique identifier for this tool call within the session.
  final ToolCallId toolCallId;

  /// Human-readable title describing what the tool is doing.
  final String title;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// Programmatic name of the tool being invoked.
  ///
  /// This field is optional. Omitting it or sending `null` both mean that no
  /// tool name is available.
  final String? name;

  /// The category of tool being invoked.
  /// Helps clients choose appropriate icons and UI treatment.
  final ToolKind? kind;

  /// Current execution status of the tool call.
  final ToolCallStatus? status;

  /// Content produced by the tool call.
  final List<ToolCallContent>? content;

  /// File locations affected by this tool call.
  /// Enables "follow-along" features in clients.
  final List<ToolCallLocation>? locations;

  /// Raw input parameters sent to the tool.
  final AcpJsonValue? rawInput;

  /// Raw output returned by the tool.
  final AcpJsonValue? rawOutput;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ToolCall> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ToolCall(
      toolCallId: decoder.required(
        'toolCallId',
        (value) => toolCallIdCodec.decode(value),
      ),
      title: decoder.required('title', (value) => decodeAcpString(value)),
      name: decoder
          .optionalOnError('name', (value) => decodeAcpString(value))
          .valueOrNull,
      kind: decoder
          .optionalOnError('kind', (value) => toolKindCodec.decode(value))
          .valueOrNull,
      status: decoder
          .optionalOnError(
            'status',
            (value) => toolCallStatusCodec.decode(value),
          )
          .valueOrNull,
      content: decoder.listSkippingInvalid(
        'content',
        (value) => toolCallContentCodec.decode(value),
        isRequired: false,
      ),
      locations: decoder.listSkippingInvalid(
        'locations',
        (value) => toolCallLocationCodec.decode(value),
        isRequired: false,
      ),
      rawInput: decoder
          .optionalOnError(
            'rawInput',
            (value) => AcpJsonValue.fromObject(value),
          )
          .valueOrNull,
      rawOutput: decoder
          .optionalOnError(
            'rawOutput',
            (value) => AcpJsonValue.fromObject(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ToolCall.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['toolCallId'] = toolCallIdCodec.encode(toolCallId);
    result['title'] = title;
    if (name != null) {
      result['name'] = name!;
    }
    if (kind != null) {
      result['kind'] = toolKindCodec.encode(kind!);
    }
    if (status != null) {
      result['status'] = toolCallStatusCodec.encode(status!);
    }
    if (content != null) {
      result['content'] = <Object?>[
        for (final item in content!) toolCallContentCodec.encode(item),
      ];
    }
    if (locations != null) {
      result['locations'] = <Object?>[
        for (final item in locations!) toolCallLocationCodec.encode(item),
      ];
    }
    if (rawInput != null) {
      result['rawInput'] = rawInput!.toObject();
    }
    if (rawOutput != null) {
      result['rawOutput'] = rawOutput!.toObject();
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ToolCall].
final class ToolCallCodec implements AcpCodec<ToolCall> {
  /// Creates the codec.
  const ToolCallCodec();

  @override
  ToolCall decode(Object? value) => ToolCall.fromJson(decodeAcpObject(value));

  @override
  Object encode(ToolCall value) => value.toJson();
}

/// Shared codec for [ToolCall].
const ToolCallCodec toolCallCodec = ToolCallCodec();

/// Content produced by a tool call.
///
/// Tool calls can produce different types of content including
/// standard content blocks (text, images) or file diffs.
///
/// See protocol docs: [Content](https://agentclientprotocol.com/protocol/tool-calls#content)
sealed class ToolCallContent implements AcpJsonEncodable {
  const ToolCallContent();

  /// Decodes the tagged union.
  factory ToolCallContent.fromJson(Object? json) =>
      toolCallContentCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// Standard content block (text, images, resources).
final class ToolCallContentContent extends ToolCallContent {
  /// Creates this known tagged-union variant.
  const ToolCallContentContent(this.value);

  /// The typed variant payload.
  final Content value;

  @override
  String get discriminator => 'content';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(contentCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// File modification shown as a diff.
final class ToolCallContentDiff extends ToolCallContent {
  /// Creates this known tagged-union variant.
  const ToolCallContentDiff(this.value);

  /// The typed variant payload.
  final Diff value;

  @override
  String get discriminator => 'diff';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(diffCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Embed a terminal created with `terminal/create` by its id.
///
/// The terminal must be added before calling `terminal/release`.
///
/// See protocol docs: [Terminal](https://agentclientprotocol.com/protocol/terminals)
final class ToolCallContentTerminal extends ToolCallContent {
  /// Creates this known tagged-union variant.
  const ToolCallContentTerminal(this.value);

  /// The typed variant payload.
  final Terminal value;

  @override
  String get discriminator => 'terminal';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(terminalCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Codec for [ToolCallContent].
final class ToolCallContentCodec implements AcpCodec<ToolCallContent> {
  /// Creates the codec.
  const ToolCallContentCodec();

  @override
  ToolCallContent decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'content':
        return ToolCallContentContent(contentCodec.decode(payload));
      case 'diff':
        return ToolCallContentDiff(diffCodec.decode(payload));
      case 'terminal':
        return ToolCallContentTerminal(terminalCodec.decode(payload));
      default:
        throw FormatException('Unknown ToolCallContent tag: $tag');
    }
  }

  @override
  Object encode(ToolCallContent value) => value.toJson();
}

/// Shared codec for [ToolCallContent].
const ToolCallContentCodec toolCallContentCodec = ToolCallContentCodec();

/// Unique identifier for a tool call within a session.
final class ToolCallId implements AcpJsonEncodable {
  /// Validates and creates a ToolCallId value.
  factory ToolCallId(String value) {
    if (value.isEmpty) {
      throw const FormatException('Protocol identifiers must not be empty');
    }
    return ToolCallId._(value);
  }

  const ToolCallId._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory ToolCallId.fromJson(Object? json) =>
      ToolCallId(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is ToolCallId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [ToolCallId].
final class ToolCallIdCodec implements AcpCodec<ToolCallId> {
  /// Creates the codec.
  const ToolCallIdCodec();

  @override
  ToolCallId decode(Object? value) => ToolCallId.fromJson(value);

  @override
  String encode(ToolCallId value) => value.toJson();
}

/// Shared codec for [ToolCallId].
const ToolCallIdCodec toolCallIdCodec = ToolCallIdCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A file location being accessed or modified by a tool.
///
/// Enables clients to implement "follow-along" features that track
/// which files the agent is working with in real-time.
///
/// See protocol docs: [Following the Agent](https://agentclientprotocol.com/protocol/tool-calls#following-the-agent)
final class ToolCallLocation implements AcpJsonEncodable {
  /// Creates a ToolCallLocation value.
  ToolCallLocation({required this.path, this.line, this.meta});

  /// The absolute file path being accessed or modified.
  final String path;

  /// Optional line number within the file.
  final int? line;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ToolCallLocation> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ToolCallLocation(
      path: decoder.required('path', (value) => decodeAcpString(value)),
      line: decoder
          .optionalOnError(
            'line',
            (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ToolCallLocation.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['path'] = path;
    if (line != null) {
      result['line'] = line!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ToolCallLocation].
final class ToolCallLocationCodec implements AcpCodec<ToolCallLocation> {
  /// Creates the codec.
  const ToolCallLocationCodec();

  @override
  ToolCallLocation decode(Object? value) =>
      ToolCallLocation.fromJson(decodeAcpObject(value));

  @override
  Object encode(ToolCallLocation value) => value.toJson();
}

/// Shared codec for [ToolCallLocation].
const ToolCallLocationCodec toolCallLocationCodec = ToolCallLocationCodec();

/// Execution status of a tool call.
///
/// Tool calls progress through different statuses during their lifecycle.
///
/// See protocol docs: [Status](https://agentclientprotocol.com/protocol/tool-calls#status)
final class ToolCallStatus implements AcpJsonEncodable {
  /// Validates and creates a ToolCallStatus value.
  factory ToolCallStatus(String value) {
    if (!const <String>{
      'pending',
      'in_progress',
      'completed',
      'failed',
    }.contains(value)) {
      throw FormatException('Unknown ToolCallStatus: $value');
    }
    return ToolCallStatus._(value);
  }

  const ToolCallStatus._(this.value);

  /// The exact wire string.
  final String value;

  /// The `pending` schema value.
  static const ToolCallStatus pending = ToolCallStatus._('pending');

  /// The `in_progress` schema value.
  static const ToolCallStatus inProgress = ToolCallStatus._('in_progress');

  /// The `completed` schema value.
  static const ToolCallStatus completed = ToolCallStatus._('completed');

  /// The `failed` schema value.
  static const ToolCallStatus failed = ToolCallStatus._('failed');

  /// Decodes a wire string.
  factory ToolCallStatus.fromJson(Object? json) =>
      ToolCallStatus(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is ToolCallStatus && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [ToolCallStatus].
final class ToolCallStatusCodec implements AcpCodec<ToolCallStatus> {
  /// Creates the codec.
  const ToolCallStatusCodec();

  @override
  ToolCallStatus decode(Object? value) => ToolCallStatus.fromJson(value);

  @override
  String encode(ToolCallStatus value) => value.toJson();
}

/// Shared codec for [ToolCallStatus].
const ToolCallStatusCodec toolCallStatusCodec = ToolCallStatusCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// An update to an existing tool call.
///
/// Used to report progress and results as tools execute. All fields except
/// the tool call ID are optional - only changed fields need to be included.
///
/// See protocol docs: [Updating](https://agentclientprotocol.com/protocol/tool-calls#updating)
final class ToolCallUpdate implements AcpJsonEncodable {
  /// Creates a ToolCallUpdate value.
  ToolCallUpdate({
    required this.toolCallId,
    this.kind = const AcpPatch<ToolKind>.unchanged(),
    this.status = const AcpPatch<ToolCallStatus>.unchanged(),
    this.title = const AcpPatch<String>.unchanged(),
    this.name = const AcpPatch<String>.unchanged(),
    AcpPatch<List<ToolCallContent>> content =
        const AcpPatch<List<ToolCallContent>>.unchanged(),
    AcpPatch<List<ToolCallLocation>> locations =
        const AcpPatch<List<ToolCallLocation>>.unchanged(),
    this.rawInput = const AcpPatch<AcpJsonValue>.unchanged(),
    this.rawOutput = const AcpPatch<AcpJsonValue>.unchanged(),
    this.meta,
  }) : content = content.map(
         (value) => List<ToolCallContent>.unmodifiable(value),
       ),
       locations = locations.map(
         (value) => List<ToolCallLocation>.unmodifiable(value),
       );

  /// The ID of the tool call being updated.
  final ToolCallId toolCallId;

  /// Update the tool kind.
  final AcpPatch<ToolKind> kind;

  /// Update the execution status.
  final AcpPatch<ToolCallStatus> status;

  /// Update the human-readable title.
  final AcpPatch<String> title;

  /// **UNSTABLE**
  ///
  /// This capability is not part of the spec yet, and may be removed or changed at any point.
  ///
  /// Update the programmatic name of the tool being invoked.
  ///
  /// This field is optional. Omitting it or sending `null` both mean that
  /// the existing name is left unchanged.
  final AcpPatch<String> name;

  /// Replace the content collection.
  final AcpPatch<List<ToolCallContent>> content;

  /// Replace the locations collection.
  final AcpPatch<List<ToolCallLocation>> locations;

  /// Update the raw input.
  final AcpPatch<AcpJsonValue> rawInput;

  /// Update the raw output.
  final AcpPatch<AcpJsonValue> rawOutput;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ToolCallUpdate> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ToolCallUpdate(
      toolCallId: decoder.required(
        'toolCallId',
        (value) => toolCallIdCodec.decode(value),
      ),
      kind: decoder.patch('kind', (value) => toolKindCodec.decode(value)),
      status: decoder.patch(
        'status',
        (value) => toolCallStatusCodec.decode(value),
      ),
      title: decoder.patch('title', (value) => decodeAcpString(value)),
      name: decoder.patch('name', (value) => decodeAcpString(value)),
      content: decoder.patch(
        'content',
        (value) => List<ToolCallContent>.unmodifiable(
          (value as List<Object?>).map(
            (item) => toolCallContentCodec.decode(item),
          ),
        ),
      ),
      locations: decoder.patch(
        'locations',
        (value) => List<ToolCallLocation>.unmodifiable(
          (value as List<Object?>).map(
            (item) => toolCallLocationCodec.decode(item),
          ),
        ),
      ),
      rawInput: decoder.patch(
        'rawInput',
        (value) => AcpJsonValue.fromObject(value),
      ),
      rawOutput: decoder.patch(
        'rawOutput',
        (value) => AcpJsonValue.fromObject(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ToolCallUpdate.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['toolCallId'] = toolCallIdCodec.encode(toolCallId);
    kind.writeTo(result, 'kind', (value) => toolKindCodec.encode(value));
    status.writeTo(
      result,
      'status',
      (value) => toolCallStatusCodec.encode(value),
    );
    title.writeTo(result, 'title', (value) => value);
    name.writeTo(result, 'name', (value) => value);
    content.writeTo(
      result,
      'content',
      (value) => <Object?>[
        for (final item in value) toolCallContentCodec.encode(item),
      ],
    );
    locations.writeTo(
      result,
      'locations',
      (value) => <Object?>[
        for (final item in value) toolCallLocationCodec.encode(item),
      ],
    );
    rawInput.writeTo(result, 'rawInput', (value) => value.toObject());
    rawOutput.writeTo(result, 'rawOutput', (value) => value.toObject());
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ToolCallUpdate].
final class ToolCallUpdateCodec implements AcpCodec<ToolCallUpdate> {
  /// Creates the codec.
  const ToolCallUpdateCodec();

  @override
  ToolCallUpdate decode(Object? value) =>
      ToolCallUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(ToolCallUpdate value) => value.toJson();
}

/// Shared codec for [ToolCallUpdate].
const ToolCallUpdateCodec toolCallUpdateCodec = ToolCallUpdateCodec();

/// Categories of tools that can be invoked.
///
/// Tool kinds help clients choose appropriate icons and optimize how they
/// display tool execution progress.
///
/// See protocol docs: [Creating](https://agentclientprotocol.com/protocol/tool-calls#creating)
final class ToolKind implements AcpJsonEncodable {
  /// Validates and creates a ToolKind value.
  factory ToolKind(String value) {
    if (!const <String>{
      'read',
      'edit',
      'delete',
      'move',
      'search',
      'execute',
      'think',
      'fetch',
      'switch_mode',
      'other',
    }.contains(value)) {
      throw FormatException('Unknown ToolKind: $value');
    }
    return ToolKind._(value);
  }

  const ToolKind._(this.value);

  /// The exact wire string.
  final String value;

  /// The `read` schema value.
  static const ToolKind read = ToolKind._('read');

  /// The `edit` schema value.
  static const ToolKind edit = ToolKind._('edit');

  /// The `delete` schema value.
  static const ToolKind delete = ToolKind._('delete');

  /// The `move` schema value.
  static const ToolKind move = ToolKind._('move');

  /// The `search` schema value.
  static const ToolKind search = ToolKind._('search');

  /// The `execute` schema value.
  static const ToolKind execute = ToolKind._('execute');

  /// The `think` schema value.
  static const ToolKind think = ToolKind._('think');

  /// The `fetch` schema value.
  static const ToolKind fetch = ToolKind._('fetch');

  /// The `switch_mode` schema value.
  static const ToolKind switchMode = ToolKind._('switch_mode');

  /// The `other` schema value.
  static const ToolKind other = ToolKind._('other');

  /// Decodes a wire string.
  factory ToolKind.fromJson(Object? json) => ToolKind(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is ToolKind && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [ToolKind].
final class ToolKindCodec implements AcpCodec<ToolKind> {
  /// Creates the codec.
  const ToolKindCodec();

  @override
  ToolKind decode(Object? value) => ToolKind.fromJson(value);

  @override
  String encode(ToolKind value) => value.toJson();
}

/// Shared codec for [ToolKind].
const ToolKindCodec toolKindCodec = ToolKindCodec();

String _decodeUnstructuredCommandInputHint(Object? value) =>
    decodeAcpString(value);
Object? _encodeUnstructuredCommandInputHint(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// All text that was typed after the command name is provided as input.
final class UnstructuredCommandInput implements AcpJsonEncodable {
  /// Creates a UnstructuredCommandInput value.
  UnstructuredCommandInput({required this.hint, this.meta});

  /// A hint to display when the input hasn't been provided yet
  @JsonKey(
    name: 'hint',
    fromJson: _decodeUnstructuredCommandInputHint,
    toJson: _encodeUnstructuredCommandInputHint,
    includeIfNull: false,
    required: true,
  )
  final String hint;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory UnstructuredCommandInput.fromJson(Map<String, Object?> json) =>
      _$UnstructuredCommandInputFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$UnstructuredCommandInputToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [UnstructuredCommandInput].
final class UnstructuredCommandInputCodec
    implements AcpCodec<UnstructuredCommandInput> {
  /// Creates the codec.
  const UnstructuredCommandInputCodec();

  @override
  UnstructuredCommandInput decode(Object? value) =>
      UnstructuredCommandInput.fromJson(decodeAcpObject(value));

  @override
  Object encode(UnstructuredCommandInput value) => value.toJson();
}

/// Shared codec for [UnstructuredCommandInput].
const UnstructuredCommandInputCodec unstructuredCommandInputCodec =
    UnstructuredCommandInputCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// **UNSTABLE**
///
/// This capability is not part of the spec yet, and may be removed or changed at any point.
///
/// Token usage information for a prompt turn.
final class Usage implements AcpJsonEncodable {
  /// Creates a Usage value.
  Usage({
    required this.totalTokens,
    required this.inputTokens,
    required this.outputTokens,
    this.thoughtTokens,
    this.cachedReadTokens,
    this.cachedWriteTokens,
    this.meta,
  });

  /// Sum of all token types across session.
  final AcpUint64 totalTokens;

  /// Total input tokens across all turns.
  final AcpUint64 inputTokens;

  /// Total output tokens across all turns.
  final AcpUint64 outputTokens;

  /// Total thought/reasoning tokens
  final AcpUint64? thoughtTokens;

  /// Total cache read tokens.
  final AcpUint64? cachedReadTokens;

  /// Total cache write tokens.
  final AcpUint64? cachedWriteTokens;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<Usage> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = Usage(
      totalTokens: decoder.required(
        'totalTokens',
        (value) => decodeAcpUint64(value),
      ),
      inputTokens: decoder.required(
        'inputTokens',
        (value) => decodeAcpUint64(value),
      ),
      outputTokens: decoder.required(
        'outputTokens',
        (value) => decodeAcpUint64(value),
      ),
      thoughtTokens: decoder
          .optionalOnError('thoughtTokens', (value) => decodeAcpUint64(value))
          .valueOrNull,
      cachedReadTokens: decoder
          .optionalOnError(
            'cachedReadTokens',
            (value) => decodeAcpUint64(value),
          )
          .valueOrNull,
      cachedWriteTokens: decoder
          .optionalOnError(
            'cachedWriteTokens',
            (value) => decodeAcpUint64(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory Usage.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['totalTokens'] = encodeAcpUint64(totalTokens);
    result['inputTokens'] = encodeAcpUint64(inputTokens);
    result['outputTokens'] = encodeAcpUint64(outputTokens);
    if (thoughtTokens != null) {
      result['thoughtTokens'] = encodeAcpUint64(thoughtTokens!);
    }
    if (cachedReadTokens != null) {
      result['cachedReadTokens'] = encodeAcpUint64(cachedReadTokens!);
    }
    if (cachedWriteTokens != null) {
      result['cachedWriteTokens'] = encodeAcpUint64(cachedWriteTokens!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Usage].
final class UsageCodec implements AcpCodec<Usage> {
  /// Creates the codec.
  const UsageCodec();

  @override
  Usage decode(Object? value) => Usage.fromJson(decodeAcpObject(value));

  @override
  Object encode(Usage value) => value.toJson();
}

/// Shared codec for [Usage].
const UsageCodec usageCodec = UsageCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Context window and cost update for a session.
final class UsageUpdate implements AcpJsonEncodable {
  /// Creates a UsageUpdate value.
  UsageUpdate({
    required this.used,
    required this.size,
    this.cost = const AcpPatch<Cost>.unchanged(),
    this.meta,
  });

  /// Tokens currently in context.
  final AcpUint64 used;

  /// Total context window size in tokens.
  final AcpUint64 size;

  /// Cumulative session cost (optional).
  final AcpPatch<Cost> cost;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<UsageUpdate> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = UsageUpdate(
      used: decoder.required('used', (value) => decodeAcpUint64(value)),
      size: decoder.required('size', (value) => decodeAcpUint64(value)),
      cost: decoder.patch('cost', (value) => costCodec.decode(value)),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory UsageUpdate.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['used'] = encodeAcpUint64(used);
    result['size'] = encodeAcpUint64(size);
    cost.writeTo(result, 'cost', (value) => costCodec.encode(value));
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [UsageUpdate].
final class UsageUpdateCodec implements AcpCodec<UsageUpdate> {
  /// Creates the codec.
  const UsageUpdateCodec();

  @override
  UsageUpdate decode(Object? value) =>
      UsageUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(UsageUpdate value) => value.toJson();
}

/// Shared codec for [UsageUpdate].
const UsageUpdateCodec usageUpdateCodec = UsageUpdateCodec();

SessionId _decodeWaitForTerminalExitRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeWaitForTerminalExitRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

TerminalId _decodeWaitForTerminalExitRequestTerminalId(Object? value) =>
    terminalIdCodec.decode(value);
Object? _encodeWaitForTerminalExitRequestTerminalId(TerminalId value) =>
    terminalIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request to wait for a terminal command to exit.
final class WaitForTerminalExitRequest implements AcpJsonEncodable {
  /// Creates a WaitForTerminalExitRequest value.
  WaitForTerminalExitRequest({
    required this.sessionId,
    required this.terminalId,
    this.meta,
  });

  /// The session ID for this request.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeWaitForTerminalExitRequestSessionId,
    toJson: _encodeWaitForTerminalExitRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The ID of the terminal to wait for.
  @JsonKey(
    name: 'terminalId',
    fromJson: _decodeWaitForTerminalExitRequestTerminalId,
    toJson: _encodeWaitForTerminalExitRequestTerminalId,
    includeIfNull: false,
    required: true,
  )
  final TerminalId terminalId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory WaitForTerminalExitRequest.fromJson(Map<String, Object?> json) =>
      _$WaitForTerminalExitRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$WaitForTerminalExitRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [WaitForTerminalExitRequest].
final class WaitForTerminalExitRequestCodec
    implements AcpCodec<WaitForTerminalExitRequest> {
  /// Creates the codec.
  const WaitForTerminalExitRequestCodec();

  @override
  WaitForTerminalExitRequest decode(Object? value) =>
      WaitForTerminalExitRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(WaitForTerminalExitRequest value) => value.toJson();
}

/// Shared codec for [WaitForTerminalExitRequest].
const WaitForTerminalExitRequestCodec waitForTerminalExitRequestCodec =
    WaitForTerminalExitRequestCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Response containing the exit status of a terminal command.
final class WaitForTerminalExitResponse implements AcpJsonEncodable {
  /// Creates a WaitForTerminalExitResponse value.
  WaitForTerminalExitResponse({this.exitCode, this.signal, this.meta});

  /// The process exit code (may be null if terminated by signal).
  final int? exitCode;

  /// The signal that terminated the process (may be null if exited normally).
  final String? signal;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<WaitForTerminalExitResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = WaitForTerminalExitResponse(
      exitCode: decoder
          .optionalOnError(
            'exitCode',
            (value) => decodeAcpIntegerInRange(value, 0, 4294967295),
          )
          .valueOrNull,
      signal: decoder
          .optionalOnError('signal', (value) => decodeAcpString(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory WaitForTerminalExitResponse.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (exitCode != null) {
      result['exitCode'] = exitCode!;
    }
    if (signal != null) {
      result['signal'] = signal!;
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [WaitForTerminalExitResponse].
final class WaitForTerminalExitResponseCodec
    implements AcpCodec<WaitForTerminalExitResponse> {
  /// Creates the codec.
  const WaitForTerminalExitResponseCodec();

  @override
  WaitForTerminalExitResponse decode(Object? value) =>
      WaitForTerminalExitResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(WaitForTerminalExitResponse value) => value.toJson();
}

/// Shared codec for [WaitForTerminalExitResponse].
const WaitForTerminalExitResponseCodec waitForTerminalExitResponseCodec =
    WaitForTerminalExitResponseCodec();

String _decodeWorkspaceFolderUri(Object? value) => decodeAcpString(value);
Object? _encodeWorkspaceFolderUri(String value) => value;

String _decodeWorkspaceFolderName(Object? value) => decodeAcpString(value);
Object? _encodeWorkspaceFolderName(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A workspace folder.
final class WorkspaceFolder implements AcpJsonEncodable {
  /// Creates a WorkspaceFolder value.
  WorkspaceFolder({required this.uri, required this.name, this.meta});

  /// The URI of the folder.
  @JsonKey(
    name: 'uri',
    fromJson: _decodeWorkspaceFolderUri,
    toJson: _encodeWorkspaceFolderUri,
    includeIfNull: false,
    required: true,
  )
  final String uri;

  /// The display name of the folder.
  @JsonKey(
    name: 'name',
    fromJson: _decodeWorkspaceFolderName,
    toJson: _encodeWorkspaceFolderName,
    includeIfNull: false,
    required: true,
  )
  final String name;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory WorkspaceFolder.fromJson(Map<String, Object?> json) =>
      _$WorkspaceFolderFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$WorkspaceFolderToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [WorkspaceFolder].
final class WorkspaceFolderCodec implements AcpCodec<WorkspaceFolder> {
  /// Creates the codec.
  const WorkspaceFolderCodec();

  @override
  WorkspaceFolder decode(Object? value) =>
      WorkspaceFolder.fromJson(decodeAcpObject(value));

  @override
  Object encode(WorkspaceFolder value) => value.toJson();
}

/// Shared codec for [WorkspaceFolder].
const WorkspaceFolderCodec workspaceFolderCodec = WorkspaceFolderCodec();

SessionId _decodeWriteTextFileRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeWriteTextFileRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

String _decodeWriteTextFileRequestPath(Object? value) => decodeAcpString(value);
Object? _encodeWriteTextFileRequestPath(String value) => value;

String _decodeWriteTextFileRequestContent(Object? value) =>
    decodeAcpString(value);
Object? _encodeWriteTextFileRequestContent(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request to write content to a text file.
///
/// Only available if the client supports the `fs.writeTextFile` capability.
final class WriteTextFileRequest implements AcpJsonEncodable {
  /// Creates a WriteTextFileRequest value.
  WriteTextFileRequest({
    required this.sessionId,
    required this.path,
    required this.content,
    this.meta,
  });

  /// The session ID for this request.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeWriteTextFileRequestSessionId,
    toJson: _encodeWriteTextFileRequestSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// Absolute path to the file to write.
  @JsonKey(
    name: 'path',
    fromJson: _decodeWriteTextFileRequestPath,
    toJson: _encodeWriteTextFileRequestPath,
    includeIfNull: false,
    required: true,
  )
  final String path;

  /// The text content to write to the file.
  @JsonKey(
    name: 'content',
    fromJson: _decodeWriteTextFileRequestContent,
    toJson: _encodeWriteTextFileRequestContent,
    includeIfNull: false,
    required: true,
  )
  final String content;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory WriteTextFileRequest.fromJson(Map<String, Object?> json) =>
      _$WriteTextFileRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$WriteTextFileRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [WriteTextFileRequest].
final class WriteTextFileRequestCodec
    implements AcpCodec<WriteTextFileRequest> {
  /// Creates the codec.
  const WriteTextFileRequestCodec();

  @override
  WriteTextFileRequest decode(Object? value) =>
      WriteTextFileRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(WriteTextFileRequest value) => value.toJson();
}

/// Shared codec for [WriteTextFileRequest].
const WriteTextFileRequestCodec writeTextFileRequestCodec =
    WriteTextFileRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to `fs/write_text_file`
final class WriteTextFileResponse implements AcpJsonEncodable {
  /// Creates a WriteTextFileResponse value.
  WriteTextFileResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory WriteTextFileResponse.fromJson(Map<String, Object?> json) =>
      _$WriteTextFileResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$WriteTextFileResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [WriteTextFileResponse].
final class WriteTextFileResponseCodec
    implements AcpCodec<WriteTextFileResponse> {
  /// Creates the codec.
  const WriteTextFileResponseCodec();

  @override
  WriteTextFileResponse decode(Object? value) =>
      WriteTextFileResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(WriteTextFileResponse value) => value.toJson();
}

/// Shared codec for [WriteTextFileResponse].
const WriteTextFileResponseCodec writeTextFileResponseCodec =
    WriteTextFileResponseCodec();
