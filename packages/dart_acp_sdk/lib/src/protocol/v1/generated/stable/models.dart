// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: prefer_initializing_formals, prefer_null_aware_operators, prefer_if_null_operators
// Source: snapshots/official/schema/v1/schema.json
// SHA-256: 7f1fba1561163729115247df75b67aeed02085115fbc7ef0131fb01d456c08f9

import 'package:json_annotation/json_annotation.dart';

import '../../../../common/json_value.dart';
import '../../../../common/patch.dart';
import '../../../../common/value_types.dart';
import '../../../method.dart';
import '../../../resilient_decoder.dart';

part 'models.g.dart';

/// Every schema definition generated for ACP v1 baseline.
const Set<String> schemaDefinitionNames = <String>{
  'AgentAuthCapabilities',
  'AgentCapabilities',
  'AgentNotification',
  'AgentRequest',
  'AgentResponse',
  'Annotations',
  'AudioContent',
  'AuthMethod',
  'AuthMethodAgent',
  'AuthMethodId',
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
  'ClientNotification',
  'ClientRequest',
  'ClientResponse',
  'ClientSessionCapabilities',
  'CloseSessionRequest',
  'CloseSessionResponse',
  'CompleteElicitationNotification',
  'ConfigOptionUpdate',
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
  'Diff',
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
  'HttpHeader',
  'ImageContent',
  'Implementation',
  'InitializeRequest',
  'InitializeResponse',
  'IntegerPropertySchema',
  'KillTerminalRequest',
  'KillTerminalResponse',
  'ListSessionsRequest',
  'ListSessionsResponse',
  'LoadSessionRequest',
  'LoadSessionResponse',
  'LogoutCapabilities',
  'LogoutRequest',
  'LogoutResponse',
  'McpCapabilities',
  'McpServer',
  'McpServerHttp',
  'McpServerSse',
  'McpServerStdio',
  'MessageId',
  'MultiSelectItems',
  'MultiSelectPropertySchema',
  'NewSessionRequest',
  'NewSessionResponse',
  'NumberPropertySchema',
  'PermissionOption',
  'PermissionOptionId',
  'PermissionOptionKind',
  'Plan',
  'PlanEntry',
  'PlanEntryPriority',
  'PlanEntryStatus',
  'PromptCapabilities',
  'PromptRequest',
  'PromptResponse',
  'ProtocolVersion',
  'ReadTextFileRequest',
  'ReadTextFileResponse',
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
  'SetSessionConfigOptionRequest',
  'SetSessionConfigOptionResponse',
  'SetSessionModeRequest',
  'SetSessionModeResponse',
  'StopReason',
  'StringFormat',
  'StringMultiSelectItems',
  'StringPropertySchema',
  'Terminal',
  'TerminalExitStatus',
  'TerminalId',
  'TerminalOutputRequest',
  'TerminalOutputResponse',
  'TextContent',
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
  'UsageUpdate',
  'WaitForTerminalExitRequest',
  'WaitForTerminalExitResponse',
  'WriteTextFileRequest',
  'WriteTextFileResponse',
};

/// SHA-256 of the schema that produced this library.
const String schemaSourceSha256 =
    '7f1fba1561163729115247df75b67aeed02085115fbc7ef0131fb01d456c08f9';

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
    this.session,
    this.elicitation,
    this.meta,
  });

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

  /// Elicitation capabilities supported by the client.
  /// Determines which elicitation modes the agent may use.
  ///
  /// Optional. Omitted or `null` both mean the client does not advertise
  /// elicitation support.
  final ElicitationCapabilities? elicitation;

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
      elicitation: decoder
          .optionalOnError(
            'elicitation',
            (value) => elicitationCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
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
    if (elicitation != null) {
      result['elicitation'] = elicitationCapabilitiesCodec.encode(elicitation!);
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
          'mcpCapabilities': <String, Object?>{'http': false, 'sse': false},
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
  McpCapabilities({required this.http, required this.sse, this.meta});

  /// Agent supports `McpServer::Http`.
  final bool http;

  /// Agent supports `McpServer::Sse`.
  final bool sse;

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

StopReason _decodePromptResponseStopReason(Object? value) =>
    stopReasonCodec.decode(value);
Object? _encodePromptResponseStopReason(StopReason value) =>
    stopReasonCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response from processing a user prompt.
///
/// See protocol docs: [Check for Completion](https://agentclientprotocol.com/protocol/prompt-turn#4-check-for-completion)
final class PromptResponse implements AcpJsonEncodable {
  /// Creates a PromptResponse value.
  PromptResponse({required this.stopReason, this.meta});

  /// Indicates why the agent stopped processing the turn.
  @JsonKey(
    name: 'stopReason',
    fromJson: _decodePromptResponseStopReason,
    toJson: _encodePromptResponseStopReason,
    includeIfNull: false,
    required: true,
  )
  final StopReason stopReason;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PromptResponse.fromJson(Map<String, Object?> json) =>
      _$PromptResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PromptResponseToJson(this);

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
