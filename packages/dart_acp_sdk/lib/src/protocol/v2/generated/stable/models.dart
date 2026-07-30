// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: prefer_initializing_formals, prefer_null_aware_operators, prefer_if_null_operators
// Source: snapshots/official/schema/v2/schema.json
// SHA-256: 9480f7224002f60725e2bd509725c40cd76bd391627a95d62d08d1b2e948e43c

import 'package:json_annotation/json_annotation.dart';

import '../../../../common/json_value.dart';
import '../../../../common/patch.dart';
import '../../../../common/value_types.dart';
import '../../../method.dart';
import '../../../resilient_decoder.dart';

part 'models.g.dart';

/// Every schema definition generated for ACP v2 baseline.
const Set<String> schemaDefinitionNames = <String>{
  'AbsolutePath',
  'AgentAuthCapabilities',
  'AgentCapabilities',
  'AgentMessage',
  'AgentNotification',
  'AgentRequest',
  'AgentResponse',
  'AgentThought',
  'Annotations',
  'AudioContent',
  'AuthMethod',
  'AuthMethodAgent',
  'AuthMethodId',
  'AvailableCommand',
  'AvailableCommandInput',
  'AvailableCommandsUpdate',
  'BlobResourceContents',
  'BooleanPropertySchema',
  'CancelRequestNotification',
  'CancelSessionNotification',
  'ClientCapabilities',
  'ClientNotification',
  'ClientRequest',
  'ClientResponse',
  'CloseSessionRequest',
  'CloseSessionResponse',
  'CommandPermissionSubject',
  'CompleteElicitationNotification',
  'ConfigOptionUpdate',
  'Content',
  'ContentBlock',
  'ContentChunk',
  'Cost',
  'CreateElicitationRequest',
  'CreateElicitationResponse',
  'DeleteSessionRequest',
  'DeleteSessionResponse',
  'Diff',
  'DiffChange',
  'DiffFileType',
  'DiffPatch',
  'DiffPatchFormat',
  'DiffPathChange',
  'DiffPathPairChange',
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
  'HttpHeader',
  'Icon',
  'IconTheme',
  'IdleStateUpdate',
  'ImageContent',
  'Implementation',
  'InitializeRequest',
  'InitializeResponse',
  'IntegerPropertySchema',
  'ListSessionsRequest',
  'ListSessionsResponse',
  'LoginAuthRequest',
  'LoginAuthResponse',
  'LogoutAuthRequest',
  'LogoutAuthResponse',
  'McpCapabilities',
  'McpHttpCapabilities',
  'McpServer',
  'McpServerHttp',
  'McpServerStdio',
  'McpStdioCapabilities',
  'MediaType',
  'MessageId',
  'MultiSelectItems',
  'MultiSelectPropertySchema',
  'NewSessionRequest',
  'NewSessionResponse',
  'NumberPropertySchema',
  'PermissionOption',
  'PermissionOptionId',
  'PermissionOptionKind',
  'PlanEntry',
  'PlanEntryPriority',
  'PlanEntryStatus',
  'PlanId',
  'PlanItems',
  'PlanUpdate',
  'PlanUpdateContent',
  'PromptAudioCapabilities',
  'PromptCapabilities',
  'PromptEmbeddedContextCapabilities',
  'PromptImageCapabilities',
  'PromptRequest',
  'PromptResponse',
  'ProtocolLevelNotification',
  'ProtocolVersion',
  'ReplayFrom',
  'ReplayFromStart',
  'RequestId',
  'RequestPermissionOutcome',
  'RequestPermissionRequest',
  'RequestPermissionResponse',
  'RequestPermissionSubject',
  'RequiresActionStateUpdate',
  'ResourceLink',
  'ResumeSessionRequest',
  'ResumeSessionResponse',
  'Role',
  'RunningStateUpdate',
  'SelectedPermissionOutcome',
  'SessionAdditionalDirectoriesCapabilities',
  'SessionCapabilities',
  'SessionConfigBoolean',
  'SessionConfigGroupId',
  'SessionConfigId',
  'SessionConfigOption',
  'SessionConfigOptionCategory',
  'SessionConfigSelect',
  'SessionConfigSelectGroup',
  'SessionConfigSelectOption',
  'SessionConfigSelectOptions',
  'SessionConfigValueId',
  'SessionDeleteCapabilities',
  'SessionId',
  'SessionInfo',
  'SessionInfoUpdate',
  'SessionListCursor',
  'SessionUpdate',
  'SetSessionConfigOptionRequest',
  'SetSessionConfigOptionResponse',
  'StateUpdate',
  'StopReason',
  'StringFormat',
  'StringMultiSelectItems',
  'StringPropertySchema',
  'Terminal',
  'TerminalExitStatus',
  'TerminalId',
  'TerminalOutput',
  'TerminalOutputChunk',
  'TerminalUpdate',
  'TextCommandInput',
  'TextContent',
  'TextResourceContents',
  'TitledMultiSelectItems',
  'ToolCallContent',
  'ToolCallContentChunk',
  'ToolCallId',
  'ToolCallLocation',
  'ToolCallPermissionSubject',
  'ToolCallStatus',
  'ToolCallUpdate',
  'ToolKind',
  'UpdateSessionNotification',
  'UsageUpdate',
  'UserMessage',
};

/// SHA-256 of the schema that produced this library.
const String schemaSourceSha256 =
    '9480f7224002f60725e2bd509725c40cd76bd391627a95d62d08d1b2e948e43c';

/// An absolute filesystem path used by the protocol.
final class AbsolutePath implements AcpJsonEncodable {
  /// Validates and creates a AbsolutePath value.
  factory AbsolutePath(String value) {
    AcpAbsolutePath(value);
    return AbsolutePath._(value);
  }

  const AbsolutePath._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory AbsolutePath.fromJson(Object? json) =>
      AbsolutePath(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is AbsolutePath && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [AbsolutePath].
final class AbsolutePathCodec implements AcpCodec<AbsolutePath> {
  /// Creates the codec.
  const AbsolutePathCodec();

  @override
  AbsolutePath decode(Object? value) => AbsolutePath.fromJson(value);

  @override
  String encode(AbsolutePath value) => value.toJson();
}

/// Shared codec for [AbsolutePath].
const AbsolutePathCodec absolutePathCodec = AbsolutePathCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Authentication-related extension capabilities supported by the agent.
///
/// This object does not advertise support for `auth/login` or `auth/logout`.
/// Those methods are advertised by a non-empty `authMethods` list in the
/// `initialize` response.
final class AgentAuthCapabilities implements AcpJsonEncodable {
  /// Creates a AgentAuthCapabilities value.
  AgentAuthCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory AgentAuthCapabilities.fromJson(Map<String, Object?> json) =>
      _$AgentAuthCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$AgentAuthCapabilitiesToJson(this);

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
/// See protocol docs: [Agent Capabilities](https://agentclientprotocol.com/protocol/v2/initialization#agent-capabilities)
final class AgentCapabilities implements AcpJsonEncodable {
  /// Creates a AgentCapabilities value.
  AgentCapabilities({this.session, this.auth, this.meta});

  /// Session capabilities supported by the agent.
  ///
  /// Optional. Omitted or `null` both mean the agent does not support the
  /// `session/*` method surface. Supplying `{}` means the agent supports the
  /// baseline session methods: `session/new`, `session/prompt`,
  /// `session/cancel`, and `session/update`.
  final SessionCapabilities? session;

  /// Authentication-related extension capabilities supported by the agent.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise any
  /// authentication-related extensions. This field does not advertise support
  /// for `auth/login` or `auth/logout`; those methods are advertised by a
  /// non-empty `authMethods` list in the `initialize` response.
  final AgentAuthCapabilities? auth;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AgentCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AgentCapabilities(
      session: decoder
          .optionalOnError(
            'session',
            (value) => sessionCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      auth: decoder
          .optionalOnError(
            'auth',
            (value) => agentAuthCapabilitiesCodec.decode(value),
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
    if (session != null) {
      result['session'] = sessionCapabilitiesCodec.encode(session!);
    }
    if (auth != null) {
      result['auth'] = agentAuthCapabilitiesCodec.encode(auth!);
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
/// An agent message upsert.
///
/// Only `AgentMessage::message_id` is required. `content` has patch semantics:
/// an omitted field leaves existing message content unchanged, `null` clears the
/// value, and a concrete array replaces the previous value. For a new
/// `messageId`, omitted fields use client defaults. `content` is replaced as a
/// whole array; send `[]` or `null` to clear it.
///
final class AgentMessage implements AcpJsonEncodable {
  /// Creates a AgentMessage value.
  AgentMessage({
    required this.messageId,
    AcpPatch<List<ContentBlock>> content =
        const AcpPatch<List<ContentBlock>>.unchanged(),
    this.meta,
  }) : content = content.map((value) => List<ContentBlock>.unmodifiable(value));

  /// A unique identifier for the message.
  final MessageId messageId;

  /// Complete replacement content for this message.
  final AcpPatch<List<ContentBlock>> content;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys. Omitted means no metadata update; `null` is an explicit clear signal.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AgentMessage> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AgentMessage(
      messageId: decoder.required(
        'messageId',
        (value) => messageIdCodec.decode(value),
      ),
      content: decoder.patch(
        'content',
        (value) => List<ContentBlock>.unmodifiable(
          (value as List<Object?>).map(
            (item) => contentBlockCodec.decode(item),
          ),
        ),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AgentMessage.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['messageId'] = messageIdCodec.encode(messageId);
    content.writeTo(
      result,
      'content',
      (value) => <Object?>[
        for (final item in value) contentBlockCodec.encode(item),
      ],
    );
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AgentMessage].
final class AgentMessageCodec implements AcpCodec<AgentMessage> {
  /// Creates the codec.
  const AgentMessageCodec();

  @override
  AgentMessage decode(Object? value) =>
      AgentMessage.fromJson(decodeAcpObject(value));

  @override
  Object encode(AgentMessage value) => value.toJson();
}

/// Shared codec for [AgentMessage].
const AgentMessageCodec agentMessageCodec = AgentMessageCodec();

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
/// An agent thought or reasoning message upsert.
///
/// Only `AgentThought::message_id` is required. `content` has patch semantics:
/// an omitted field leaves existing thought content unchanged, `null` clears the
/// value, and a concrete array replaces the previous value. For a new
/// `messageId`, omitted fields use client defaults. `content` is replaced as a
/// whole array; send `[]` or `null` to clear it.
///
final class AgentThought implements AcpJsonEncodable {
  /// Creates a AgentThought value.
  AgentThought({
    required this.messageId,
    AcpPatch<List<ContentBlock>> content =
        const AcpPatch<List<ContentBlock>>.unchanged(),
    this.meta,
  }) : content = content.map((value) => List<ContentBlock>.unmodifiable(value));

  /// A unique identifier for the thought message.
  final MessageId messageId;

  /// Complete replacement content for this thought message.
  final AcpPatch<List<ContentBlock>> content;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys. Omitted means no metadata update; `null` is an explicit clear signal.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AgentThought> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AgentThought(
      messageId: decoder.required(
        'messageId',
        (value) => messageIdCodec.decode(value),
      ),
      content: decoder.patch(
        'content',
        (value) => List<ContentBlock>.unmodifiable(
          (value as List<Object?>).map(
            (item) => contentBlockCodec.decode(item),
          ),
        ),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory AgentThought.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['messageId'] = messageIdCodec.encode(messageId);
    content.writeTo(
      result,
      'content',
      (value) => <Object?>[
        for (final item in value) contentBlockCodec.encode(item),
      ],
    );
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [AgentThought].
final class AgentThoughtCodec implements AcpCodec<AgentThought> {
  /// Creates the codec.
  const AgentThoughtCodec();

  @override
  AgentThought decode(Object? value) =>
      AgentThought.fromJson(decodeAcpObject(value));

  @override
  Object encode(AgentThought value) => value.toJson();
}

/// Shared codec for [AgentThought].
const AgentThoughtCodec agentThoughtCodec = AgentThoughtCodec();

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
  ///
  /// Must be an RFC 3339 formatted string (e.g., "2025-01-12T15:00:58Z").
  final AcpDateTimeString? lastModified;

  /// Relative importance of this content when clients choose what to surface.
  final num? priority;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
          .optionalOnError('lastModified', (value) => decodeAcpDateTime(value))
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
      result['lastModified'] = lastModified!.value;
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

  /// Base64-encoded media payload.
  final String data;

  /// MIME type describing the encoded media payload.
  final MediaType mimeType;

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AudioContent> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AudioContent(
      data: decoder.required('data', (value) => decodeAcpString(value)),
      mimeType: decoder.required(
        'mimeType',
        (value) => mediaTypeCodec.decode(value),
      ),
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
          .valueOrNull,
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
    result['data'] = data;
    result['mimeType'] = mediaTypeCodec.encode(mimeType);
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
    }
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
sealed class AuthMethod implements AcpJsonEncodable {
  const AuthMethod();

  /// Decodes the tagged union.
  factory AuthMethod.fromJson(Object? json) => authMethodCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// Agent handles authentication itself through `auth/login`.
///
/// The `type` discriminator value is `agent`.
final class AuthMethodAgentVariant extends AuthMethod {
  /// Creates this known tagged-union variant.
  const AuthMethodAgentVariant(this.value);

  /// The typed variant payload.
  final AuthMethodAgent value;

  @override
  String get discriminator => 'agent';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(authMethodAgentCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [AuthMethod] variant.
final class AuthMethodCustom extends AuthMethod {
  /// Creates a raw-preserving custom variant.
  AuthMethodCustom({
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

/// Codec for [AuthMethod].
final class AuthMethodCodec implements AcpCodec<AuthMethod> {
  /// Creates the codec.
  const AuthMethodCodec();

  @override
  AuthMethod decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'agent':
        return AuthMethodAgentVariant(authMethodAgentCodec.decode(payload));
      default:
        return AuthMethodCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(AuthMethod value) => value.toJson();
}

/// Shared codec for [AuthMethod].
const AuthMethodCodec authMethodCodec = AuthMethodCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Agent handles authentication itself through `auth/login`.
///
/// The `type` discriminator value is `agent`.
final class AuthMethodAgent implements AcpJsonEncodable {
  /// Creates a AuthMethodAgent value.
  AuthMethodAgent({
    required this.methodId,
    required this.name,
    this.description,
    this.meta,
  });

  /// Unique identifier for this authentication method.
  final AuthMethodId methodId;

  /// Human-readable name of the authentication method.
  final String name;

  /// Optional description providing more details about this authentication method.
  final String? description;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<AuthMethodAgent> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = AuthMethodAgent(
      methodId: decoder.required(
        'methodId',
        (value) => authMethodIdCodec.decode(value),
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
  factory AuthMethodAgent.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['methodId'] = authMethodIdCodec.encode(methodId);
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

  /// Decodes the tagged union.
  factory AvailableCommandInput.fromJson(Object? json) =>
      availableCommandInputCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// All text that was typed after the command name is provided as input.
final class AvailableCommandInputText extends AvailableCommandInput {
  /// Creates this known tagged-union variant.
  const AvailableCommandInputText(this.value);

  /// The typed variant payload.
  final TextCommandInput value;

  @override
  String get discriminator => 'text';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(textCommandInputCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [AvailableCommandInput] variant.
final class AvailableCommandInputCustom extends AvailableCommandInput {
  /// Creates a raw-preserving custom variant.
  AvailableCommandInputCustom({
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

/// Codec for [AvailableCommandInput].
final class AvailableCommandInputCodec
    implements AcpCodec<AvailableCommandInput> {
  /// Creates the codec.
  const AvailableCommandInputCodec();

  @override
  AvailableCommandInput decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'text':
        return AvailableCommandInputText(textCommandInputCodec.decode(payload));
      default:
        return AvailableCommandInputCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(AvailableCommandInput value) => value.toJson();
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

  /// Commands the agent can execute.
  final List<AvailableCommand> availableCommands;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

  /// URI associated with this resource or media payload.
  final Uri uri;

  /// MIME type describing the encoded media payload.
  final MediaType? mimeType;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<BlobResourceContents> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = BlobResourceContents(
      blob: decoder.required('blob', (value) => decodeAcpString(value)),
      uri: decoder.required('uri', (value) => decodeAcpUri(value)),
      mimeType: decoder
          .optionalOnError('mimeType', (value) => mediaTypeCodec.decode(value))
          .valueOrNull,
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
    result['uri'] = uri.toString();
    if (mimeType != null) {
      result['mimeType'] = mediaTypeCodec.encode(mimeType!);
    }
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

RequestId _decodeCancelRequestNotificationRequestId(Object? value) =>
    requestIdCodec.decode(value);
Object? _encodeCancelRequestNotificationRequestId(RequestId value) =>
    requestIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification to cancel an ongoing request.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/cancellation)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

SessionId _decodeCancelSessionNotificationSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeCancelSessionNotificationSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification to cancel ongoing operations for a session.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#cancellation)
final class CancelSessionNotification implements AcpJsonEncodable {
  /// Creates a CancelSessionNotification value.
  CancelSessionNotification({required this.sessionId, this.meta});

  /// The ID of the session to cancel operations for.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeCancelSessionNotificationSessionId,
    toJson: _encodeCancelSessionNotificationSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory CancelSessionNotification.fromJson(Map<String, Object?> json) =>
      _$CancelSessionNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$CancelSessionNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CancelSessionNotification].
final class CancelSessionNotificationCodec
    implements AcpCodec<CancelSessionNotification> {
  /// Creates the codec.
  const CancelSessionNotificationCodec();

  @override
  CancelSessionNotification decode(Object? value) =>
      CancelSessionNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(CancelSessionNotification value) => value.toJson();
}

/// Shared codec for [CancelSessionNotification].
const CancelSessionNotificationCodec cancelSessionNotificationCodec =
    CancelSessionNotificationCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Capabilities supported by the client.
///
/// Advertised during initialization to inform the agent about
/// available features and methods.
///
/// See protocol docs: [Client Capabilities](https://agentclientprotocol.com/protocol/v2/initialization#client-capabilities)
final class ClientCapabilities implements AcpJsonEncodable {
  /// Creates a ClientCapabilities value.
  ClientCapabilities({this.elicitation, this.meta});

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ClientCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ClientCapabilities(
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

SessionId _decodeCloseSessionRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeCloseSessionRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for closing an active session.
///
/// The agent **must** cancel any ongoing work related to the session (treat it
/// as if `session/cancel` was called) and then free up any resources associated
/// with the session.
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

@JsonSerializable(createFactory: false, createToJson: false)
/// Permission request details for a command.
final class CommandPermissionSubject implements AcpJsonEncodable {
  /// Creates a CommandPermissionSubject value.
  CommandPermissionSubject({
    required this.command,
    required this.cwd,
    this.toolCallId,
    this.terminalId,
    this.meta,
  });

  /// The command that would be run if permission is granted.
  final String command;

  /// The absolute working directory for the command.
  final AbsolutePath cwd;

  /// The associated tool call, when known. Omitted and `null` are equivalent.
  final ToolCallId? toolCallId;

  /// The associated terminal, when already known. Omitted and `null` are equivalent.
  final TerminalId? terminalId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys. Omitted and `null` are equivalent and mean no subject metadata was provided.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<CommandPermissionSubject> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = CommandPermissionSubject(
      command: decoder.required('command', (value) => decodeAcpString(value)),
      cwd: decoder.required('cwd', (value) => absolutePathCodec.decode(value)),
      toolCallId: decoder
          .optionalOnError(
            'toolCallId',
            (value) => toolCallIdCodec.decode(value),
          )
          .valueOrNull,
      terminalId: decoder
          .optionalOnError(
            'terminalId',
            (value) => terminalIdCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory CommandPermissionSubject.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['command'] = command;
    result['cwd'] = absolutePathCodec.encode(cwd);
    if (toolCallId != null) {
      result['toolCallId'] = toolCallIdCodec.encode(toolCallId!);
    }
    if (terminalId != null) {
      result['terminalId'] = terminalIdCodec.encode(terminalId!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [CommandPermissionSubject].
final class CommandPermissionSubjectCodec
    implements AcpCodec<CommandPermissionSubject> {
  /// Creates the codec.
  const CommandPermissionSubjectCodec();

  @override
  CommandPermissionSubject decode(Object? value) =>
      CommandPermissionSubject.fromJson(decodeAcpObject(value));

  @override
  Object encode(CommandPermissionSubject value) => value.toJson();
}

/// Shared codec for [CommandPermissionSubject].
const CommandPermissionSubjectCodec commandPermissionSubjectCodec =
    CommandPermissionSubjectCodec();

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// - Language model output reported through `session/update` notifications as
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

/// An unknown future or `_`-prefixed [ContentBlock] variant.
final class ContentBlockCustom extends ContentBlock {
  /// Creates a raw-preserving custom variant.
  ContentBlockCustom({
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
        return ContentBlockCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(ContentBlock value) => value.toJson();
}

/// Shared codec for [ContentBlock].
const ContentBlockCodec contentBlockCodec = ContentBlockCodec();

MessageId _decodeContentChunkMessageId(Object? value) =>
    messageIdCodec.decode(value);
Object? _encodeContentChunkMessageId(MessageId value) =>
    messageIdCodec.encode(value);

ContentBlock _decodeContentChunkContent(Object? value) =>
    contentBlockCodec.decode(value);
Object? _encodeContentChunkContent(ContentBlock value) =>
    contentBlockCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A streamed item of message content.
final class ContentChunk implements AcpJsonEncodable {
  /// Creates a ContentChunk value.
  ContentChunk({required this.messageId, required this.content, this.meta});

  /// A unique identifier for the message this chunk belongs to.
  ///
  /// All chunks belonging to the same message share the same `messageId`.
  /// A change in `messageId` indicates a new message has started.
  @JsonKey(
    name: 'messageId',
    fromJson: _decodeContentChunkMessageId,
    toJson: _encodeContentChunkMessageId,
    includeIfNull: false,
    required: true,
  )
  final MessageId messageId;

  /// A single item of content
  @JsonKey(
    name: 'content',
    fromJson: _decodeContentChunkContent,
    toJson: _encodeContentChunkContent,
    includeIfNull: false,
    required: true,
  )
  final ContentBlock content;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys. This field is chunk-scoped.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ContentChunk.fromJson(Map<String, Object?> json) =>
      _$ContentChunkFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ContentChunkToJson(this);

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

SessionId _decodeDeleteSessionRequestSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeDeleteSessionRequestSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for deleting an existing session from `session/list`.
///
/// Only available if the Agent supports the `session.delete` capability.
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// File changes produced by a tool call.
///
/// `changes` is authoritative for affected absolute paths and operations.
/// `patch` optionally carries renderable text for some or all of those changes
/// and MUST be consistent with `changes`. Agents SHOULD provide `patch` whenever
/// feasible. Clients MUST handle diffs where `patch` is omitted or `null`.
///
/// See protocol docs: [Content](https://agentclientprotocol.com/protocol/v2/tool-calls#content)
final class Diff implements AcpJsonEncodable {
  /// Creates a Diff value.
  Diff({required List<DiffChange> changes, this.patch, this.meta})
    : changes = List<DiffChange>.unmodifiable(changes);

  /// Structured file changes described by this diff.
  ///
  /// Clients can use this field without parsing patch text to determine affected paths.
  final List<DiffChange> changes;

  /// Renderable patch text for some or all of the structured changes.
  ///
  /// Agents SHOULD provide patch text whenever feasible. Omitted or `null`
  /// means no renderable patch text was provided.
  final DiffPatch? patch;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<Diff> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = Diff(
      changes: decoder.listSkippingInvalid(
        'changes',
        (value) => diffChangeCodec.decode(value),
        isRequired: true,
      ),
      patch: decoder
          .optionalOnError('patch', (value) => diffPatchCodec.decode(value))
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory Diff.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['changes'] = <Object?>[
      for (final item in changes) diffChangeCodec.encode(item),
    ];
    if (patch != null) {
      result['patch'] = diffPatchCodec.encode(patch!);
    }
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

/// One file-level change described by a `Diff`.
///
/// Structured change metadata lets clients identify affected files and
/// operations without parsing the text patch.
sealed class DiffChange implements AcpJsonEncodable {
  const DiffChange();

  /// Decodes the tagged union.
  factory DiffChange.fromJson(Object? json) => diffChangeCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// A file was added.
final class DiffChangeAdd extends DiffChange {
  /// Creates this known tagged-union variant.
  DiffChangeAdd(this.value, {this.fileType, this.mimeType, this.meta});

  /// The typed variant payload.
  final DiffPathChange value;

  /// File content kind.
  ///
  /// Omitted or `null` means the content kind is unknown.
  final DiffFileType? fileType;

  /// MIME type of the file contents.
  ///
  /// Omitted or `null` means the MIME type is unknown.
  final MediaType? mimeType;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'add';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(diffPathChangeCodec.encode(value));
    final result = <String, Object?>{...payload};
    if (fileType != null) {
      result['fileType'] = diffFileTypeCodec.encode(fileType!);
    }
    if (mimeType != null) {
      result['mimeType'] = mediaTypeCodec.encode(mimeType!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['operation'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A file was deleted.
final class DiffChangeDelete extends DiffChange {
  /// Creates this known tagged-union variant.
  DiffChangeDelete(this.value, {this.fileType, this.mimeType, this.meta});

  /// The typed variant payload.
  final DiffPathChange value;

  /// File content kind.
  ///
  /// Omitted or `null` means the content kind is unknown.
  final DiffFileType? fileType;

  /// MIME type of the file contents.
  ///
  /// Omitted or `null` means the MIME type is unknown.
  final MediaType? mimeType;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'delete';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(diffPathChangeCodec.encode(value));
    final result = <String, Object?>{...payload};
    if (fileType != null) {
      result['fileType'] = diffFileTypeCodec.encode(fileType!);
    }
    if (mimeType != null) {
      result['mimeType'] = mediaTypeCodec.encode(mimeType!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['operation'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A file was modified in place.
final class DiffChangeModify extends DiffChange {
  /// Creates this known tagged-union variant.
  DiffChangeModify(this.value, {this.fileType, this.mimeType, this.meta});

  /// The typed variant payload.
  final DiffPathChange value;

  /// File content kind.
  ///
  /// Omitted or `null` means the content kind is unknown.
  final DiffFileType? fileType;

  /// MIME type of the file contents.
  ///
  /// Omitted or `null` means the MIME type is unknown.
  final MediaType? mimeType;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'modify';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(diffPathChangeCodec.encode(value));
    final result = <String, Object?>{...payload};
    if (fileType != null) {
      result['fileType'] = diffFileTypeCodec.encode(fileType!);
    }
    if (mimeType != null) {
      result['mimeType'] = mediaTypeCodec.encode(mimeType!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['operation'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A file was moved or renamed.
final class DiffChangeMove extends DiffChange {
  /// Creates this known tagged-union variant.
  DiffChangeMove(this.value, {this.fileType, this.mimeType, this.meta});

  /// The typed variant payload.
  final DiffPathPairChange value;

  /// File content kind.
  ///
  /// Omitted or `null` means the content kind is unknown.
  final DiffFileType? fileType;

  /// MIME type of the file contents.
  ///
  /// Omitted or `null` means the MIME type is unknown.
  final MediaType? mimeType;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'move';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(diffPathPairChangeCodec.encode(value));
    final result = <String, Object?>{...payload};
    if (fileType != null) {
      result['fileType'] = diffFileTypeCodec.encode(fileType!);
    }
    if (mimeType != null) {
      result['mimeType'] = mediaTypeCodec.encode(mimeType!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['operation'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A file was copied.
final class DiffChangeCopy extends DiffChange {
  /// Creates this known tagged-union variant.
  DiffChangeCopy(this.value, {this.fileType, this.mimeType, this.meta});

  /// The typed variant payload.
  final DiffPathPairChange value;

  /// File content kind.
  ///
  /// Omitted or `null` means the content kind is unknown.
  final DiffFileType? fileType;

  /// MIME type of the file contents.
  ///
  /// Omitted or `null` means the MIME type is unknown.
  final MediaType? mimeType;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'copy';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(diffPathPairChangeCodec.encode(value));
    final result = <String, Object?>{...payload};
    if (fileType != null) {
      result['fileType'] = diffFileTypeCodec.encode(fileType!);
    }
    if (mimeType != null) {
      result['mimeType'] = mediaTypeCodec.encode(mimeType!);
    }
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['operation'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [DiffChange] variant.
final class DiffChangeCustom extends DiffChange {
  /// Creates a raw-preserving custom variant.
  DiffChangeCustom({
    required this.discriminator,
    required AcpJsonObject payload,
  }) : payload = payload.without('__proto__');

  @override
  final String discriminator;

  /// Opaque extension fields.
  final AcpJsonObject payload;

  @override
  AcpJsonObject toAcpJson() =>
      payload.withValue('operation', AcpJsonString(discriminator));
}

/// Codec for [DiffChange].
final class DiffChangeCodec implements AcpCodec<DiffChange> {
  /// Creates the codec.
  const DiffChangeCodec();

  @override
  DiffChange decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['operation']);
    switch (tag) {
      case 'add':
        final decoder = AcpResilientDecoder(payload);
        return DiffChangeAdd(
          diffPathChangeCodec.decode(payload),
          fileType: decoder
              .optionalOnError(
                'fileType',
                (value) => diffFileTypeCodec.decode(value),
              )
              .valueOrNull,
          mimeType: decoder
              .optionalOnError(
                'mimeType',
                (value) => mediaTypeCodec.decode(value),
              )
              .valueOrNull,
          meta: decoder.meta(),
        );
      case 'delete':
        final decoder = AcpResilientDecoder(payload);
        return DiffChangeDelete(
          diffPathChangeCodec.decode(payload),
          fileType: decoder
              .optionalOnError(
                'fileType',
                (value) => diffFileTypeCodec.decode(value),
              )
              .valueOrNull,
          mimeType: decoder
              .optionalOnError(
                'mimeType',
                (value) => mediaTypeCodec.decode(value),
              )
              .valueOrNull,
          meta: decoder.meta(),
        );
      case 'modify':
        final decoder = AcpResilientDecoder(payload);
        return DiffChangeModify(
          diffPathChangeCodec.decode(payload),
          fileType: decoder
              .optionalOnError(
                'fileType',
                (value) => diffFileTypeCodec.decode(value),
              )
              .valueOrNull,
          mimeType: decoder
              .optionalOnError(
                'mimeType',
                (value) => mediaTypeCodec.decode(value),
              )
              .valueOrNull,
          meta: decoder.meta(),
        );
      case 'move':
        final decoder = AcpResilientDecoder(payload);
        return DiffChangeMove(
          diffPathPairChangeCodec.decode(payload),
          fileType: decoder
              .optionalOnError(
                'fileType',
                (value) => diffFileTypeCodec.decode(value),
              )
              .valueOrNull,
          mimeType: decoder
              .optionalOnError(
                'mimeType',
                (value) => mediaTypeCodec.decode(value),
              )
              .valueOrNull,
          meta: decoder.meta(),
        );
      case 'copy':
        final decoder = AcpResilientDecoder(payload);
        return DiffChangeCopy(
          diffPathPairChangeCodec.decode(payload),
          fileType: decoder
              .optionalOnError(
                'fileType',
                (value) => diffFileTypeCodec.decode(value),
              )
              .valueOrNull,
          mimeType: decoder
              .optionalOnError(
                'mimeType',
                (value) => mediaTypeCodec.decode(value),
              )
              .valueOrNull,
          meta: decoder.meta(),
        );
      default:
        return DiffChangeCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(DiffChange value) => value.toJson();
}

/// Shared codec for [DiffChange].
const DiffChangeCodec diffChangeCodec = DiffChangeCodec();

/// Kind of file content represented by a diff change.
final class DiffFileType implements AcpJsonEncodable {
  /// Validates and creates a DiffFileType value.
  factory DiffFileType(String value) {
    return DiffFileType._(value);
  }

  const DiffFileType._(this.value);

  /// The exact wire string.
  final String value;

  /// The `text` schema value.
  static const DiffFileType text = DiffFileType._('text');

  /// The `binary` schema value.
  static const DiffFileType binary = DiffFileType._('binary');

  /// The `directory` schema value.
  static const DiffFileType directory = DiffFileType._('directory');

  /// The `symlink` schema value.
  static const DiffFileType symlink = DiffFileType._('symlink');

  /// Decodes a wire string.
  factory DiffFileType.fromJson(Object? json) =>
      DiffFileType(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is DiffFileType && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [DiffFileType].
final class DiffFileTypeCodec implements AcpCodec<DiffFileType> {
  /// Creates the codec.
  const DiffFileTypeCodec();

  @override
  DiffFileType decode(Object? value) => DiffFileType.fromJson(value);

  @override
  String encode(DiffFileType value) => value.toJson();
}

/// Shared codec for [DiffFileType].
const DiffFileTypeCodec diffFileTypeCodec = DiffFileTypeCodec();

DiffPatchFormat _decodeDiffPatchFormat(Object? value) =>
    diffPatchFormatCodec.decode(value);
Object? _encodeDiffPatchFormat(DiffPatchFormat value) =>
    diffPatchFormatCodec.encode(value);

String _decodeDiffPatchText(Object? value) => decodeAcpString(value);
Object? _encodeDiffPatchText(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Renderable patch text and its format.
final class DiffPatch implements AcpJsonEncodable {
  /// Creates a DiffPatch value.
  DiffPatch({required this.format, required this.text});

  /// Patch format. The only ACP-defined value is `git_patch`.
  @JsonKey(
    name: 'format',
    fromJson: _decodeDiffPatchFormat,
    toJson: _encodeDiffPatchFormat,
    includeIfNull: false,
    required: true,
  )
  final DiffPatchFormat format;

  /// Patch text in the format named by `format`.
  @JsonKey(
    name: 'text',
    fromJson: _decodeDiffPatchText,
    toJson: _encodeDiffPatchText,
    includeIfNull: false,
    required: true,
  )
  final String text;

  /// Decodes a schema-validated JSON object.
  factory DiffPatch.fromJson(Map<String, Object?> json) =>
      _$DiffPatchFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DiffPatchToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DiffPatch].
final class DiffPatchCodec implements AcpCodec<DiffPatch> {
  /// Creates the codec.
  const DiffPatchCodec();

  @override
  DiffPatch decode(Object? value) => DiffPatch.fromJson(decodeAcpObject(value));

  @override
  Object encode(DiffPatch value) => value.toJson();
}

/// Shared codec for [DiffPatch].
const DiffPatchCodec diffPatchCodec = DiffPatchCodec();

/// Text patch format used by `DiffPatch`.
final class DiffPatchFormat implements AcpJsonEncodable {
  /// Validates and creates a DiffPatchFormat value.
  factory DiffPatchFormat(String value) {
    return DiffPatchFormat._(value);
  }

  const DiffPatchFormat._(this.value);

  /// The exact wire string.
  final String value;

  /// The `git_patch` schema value.
  static const DiffPatchFormat gitPatch = DiffPatchFormat._('git_patch');

  /// Decodes a wire string.
  factory DiffPatchFormat.fromJson(Object? json) =>
      DiffPatchFormat(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is DiffPatchFormat && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [DiffPatchFormat].
final class DiffPatchFormatCodec implements AcpCodec<DiffPatchFormat> {
  /// Creates the codec.
  const DiffPatchFormatCodec();

  @override
  DiffPatchFormat decode(Object? value) => DiffPatchFormat.fromJson(value);

  @override
  String encode(DiffPatchFormat value) => value.toJson();
}

/// Shared codec for [DiffPatchFormat].
const DiffPatchFormatCodec diffPatchFormatCodec = DiffPatchFormatCodec();

AbsolutePath _decodeDiffPathChangePath(Object? value) =>
    absolutePathCodec.decode(value);
Object? _encodeDiffPathChangePath(AbsolutePath value) =>
    absolutePathCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Operation metadata for add, delete, and modify changes.
final class DiffPathChange implements AcpJsonEncodable {
  /// Creates a DiffPathChange value.
  DiffPathChange({required this.path});

  /// Absolute path for the operation.
  @JsonKey(
    name: 'path',
    fromJson: _decodeDiffPathChangePath,
    toJson: _encodeDiffPathChangePath,
    includeIfNull: false,
    required: true,
  )
  final AbsolutePath path;

  /// Decodes a schema-validated JSON object.
  factory DiffPathChange.fromJson(Map<String, Object?> json) =>
      _$DiffPathChangeFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DiffPathChangeToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DiffPathChange].
final class DiffPathChangeCodec implements AcpCodec<DiffPathChange> {
  /// Creates the codec.
  const DiffPathChangeCodec();

  @override
  DiffPathChange decode(Object? value) =>
      DiffPathChange.fromJson(decodeAcpObject(value));

  @override
  Object encode(DiffPathChange value) => value.toJson();
}

/// Shared codec for [DiffPathChange].
const DiffPathChangeCodec diffPathChangeCodec = DiffPathChangeCodec();

AbsolutePath _decodeDiffPathPairChangeOldPath(Object? value) =>
    absolutePathCodec.decode(value);
Object? _encodeDiffPathPairChangeOldPath(AbsolutePath value) =>
    absolutePathCodec.encode(value);

AbsolutePath _decodeDiffPathPairChangePath(Object? value) =>
    absolutePathCodec.decode(value);
Object? _encodeDiffPathPairChangePath(AbsolutePath value) =>
    absolutePathCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Operation metadata for move and copy changes.
final class DiffPathPairChange implements AcpJsonEncodable {
  /// Creates a DiffPathPairChange value.
  DiffPathPairChange({required this.oldPath, required this.path});

  /// Absolute path before the operation.
  @JsonKey(
    name: 'oldPath',
    fromJson: _decodeDiffPathPairChangeOldPath,
    toJson: _encodeDiffPathPairChangeOldPath,
    includeIfNull: false,
    required: true,
  )
  final AbsolutePath oldPath;

  /// Absolute path after the operation.
  @JsonKey(
    name: 'path',
    fromJson: _decodeDiffPathPairChangePath,
    toJson: _encodeDiffPathPairChangePath,
    includeIfNull: false,
    required: true,
  )
  final AbsolutePath path;

  /// Decodes a schema-validated JSON object.
  factory DiffPathPairChange.fromJson(Map<String, Object?> json) =>
      _$DiffPathPairChangeFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$DiffPathPairChangeToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [DiffPathPairChange].
final class DiffPathPairChangeCodec implements AcpCodec<DiffPathPairChange> {
  /// Creates the codec.
  const DiffPathPairChangeCodec();

  @override
  DiffPathPairChange decode(Object? value) =>
      DiffPathPairChange.fromJson(decodeAcpObject(value));

  @override
  Object encode(DiffPathPairChange value) => value.toJson();
}

/// Shared codec for [DiffPathPairChange].
const DiffPathPairChangeCodec diffPathPairChangeCodec =
    DiffPathPairChangeCodec();

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

  /// Embedded resource payload, either text or binary data.
  final EmbeddedResourceResource resource;

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<EmbeddedResource> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = EmbeddedResource(
      resource: decoder.required(
        'resource',
        (value) => embeddedResourceResourceCodec.decode(value),
      ),
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
          .valueOrNull,
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
    result['resource'] = embeddedResourceResourceCodec.encode(resource);
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
    }
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// An environment variable to set when launching a process.
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// An optionally-sized icon that can be displayed in a user interface.
final class Icon implements AcpJsonEncodable {
  /// Creates a Icon value.
  Icon({required this.src, this.mimeType, List<String>? sizes, this.theme})
    : sizes = sizes == null ? null : List<String>.unmodifiable(sizes);

  /// A standard URI pointing to an icon resource.
  final Uri src;

  /// Optional MIME type override if the source MIME type is missing or generic.
  final MediaType? mimeType;

  /// Optional array of strings that specify sizes at which the icon can be used.
  /// Each string should be in `WxH` format (e.g., `"48x48"`, `"96x96"`) or
  /// `"any"` for scalable formats like SVG.
  ///
  /// If not provided, the client should assume that the icon can be used at any size.
  final List<String>? sizes;

  /// Optional theme this icon is designed for.
  final IconTheme? theme;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<Icon> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = Icon(
      src: decoder.required('src', (value) => decodeAcpUri(value)),
      mimeType: decoder
          .optionalOnError('mimeType', (value) => mediaTypeCodec.decode(value))
          .valueOrNull,
      sizes: decoder.listSkippingInvalid(
        'sizes',
        (value) => decodeAcpString(value),
        isRequired: false,
      ),
      theme: decoder
          .optionalOnError('theme', (value) => iconThemeCodec.decode(value))
          .valueOrNull,
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory Icon.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['src'] = src.toString();
    if (mimeType != null) {
      result['mimeType'] = mediaTypeCodec.encode(mimeType!);
    }
    if (sizes != null) {
      result['sizes'] = <Object?>[for (final item in sizes!) item];
    }
    if (theme != null) {
      result['theme'] = iconThemeCodec.encode(theme!);
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [Icon].
final class IconCodec implements AcpCodec<Icon> {
  /// Creates the codec.
  const IconCodec();

  @override
  Icon decode(Object? value) => Icon.fromJson(decodeAcpObject(value));

  @override
  Object encode(Icon value) => value.toJson();
}

/// Shared codec for [Icon].
const IconCodec iconCodec = IconCodec();

/// Theme an icon is designed for.
final class IconTheme implements AcpJsonEncodable {
  /// Validates and creates a IconTheme value.
  factory IconTheme(String value) {
    return IconTheme._(value);
  }

  const IconTheme._(this.value);

  /// The exact wire string.
  final String value;

  /// The `light` schema value.
  static const IconTheme light = IconTheme._('light');

  /// The `dark` schema value.
  static const IconTheme dark = IconTheme._('dark');

  /// Decodes a wire string.
  factory IconTheme.fromJson(Object? json) => IconTheme(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is IconTheme && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [IconTheme].
final class IconThemeCodec implements AcpCodec<IconTheme> {
  /// Creates the codec.
  const IconThemeCodec();

  @override
  IconTheme decode(Object? value) => IconTheme.fromJson(value);

  @override
  String encode(IconTheme value) => value.toJson();
}

/// Shared codec for [IconTheme].
const IconThemeCodec iconThemeCodec = IconThemeCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// The agent is ready to process a new prompt.
final class IdleStateUpdate implements AcpJsonEncodable {
  /// Creates a IdleStateUpdate value.
  IdleStateUpdate({
    this.stopReason = const AcpPatch<StopReason>.unchanged(),
    this.meta,
  });

  /// Indicates why foreground work stopped.
  ///
  /// Optional. Omitted or `null` both mean the agent is not reporting a stop reason.
  /// Agents SHOULD include this when the idle transition ends foreground work.
  final AcpPatch<StopReason> stopReason;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<IdleStateUpdate> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = IdleStateUpdate(
      stopReason: decoder.patch(
        'stopReason',
        (value) => stopReasonCodec.decode(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory IdleStateUpdate.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    stopReason.writeTo(
      result,
      'stopReason',
      (value) => stopReasonCodec.encode(value),
    );
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [IdleStateUpdate].
final class IdleStateUpdateCodec implements AcpCodec<IdleStateUpdate> {
  /// Creates the codec.
  const IdleStateUpdateCodec();

  @override
  IdleStateUpdate decode(Object? value) =>
      IdleStateUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(IdleStateUpdate value) => value.toJson();
}

/// Shared codec for [IdleStateUpdate].
const IdleStateUpdateCodec idleStateUpdateCodec = IdleStateUpdateCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// An image provided to or from an LLM.
final class ImageContent implements AcpJsonEncodable {
  /// Creates a ImageContent value.
  ImageContent({
    required this.data,
    required this.mimeType,
    this.uri,
    this.annotations,
    this.meta,
  });

  /// Base64-encoded media payload.
  final String data;

  /// MIME type describing the encoded media payload.
  final MediaType mimeType;

  /// URI associated with this resource or media payload.
  final Uri? uri;

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ImageContent> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ImageContent(
      data: decoder.required('data', (value) => decodeAcpString(value)),
      mimeType: decoder.required(
        'mimeType',
        (value) => mediaTypeCodec.decode(value),
      ),
      uri: decoder
          .optionalOnError('uri', (value) => decodeAcpUri(value))
          .valueOrNull,
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
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
    result['data'] = data;
    result['mimeType'] = mediaTypeCodec.encode(mimeType);
    if (uri != null) {
      result['uri'] = uri!.toString();
    }
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// See protocol docs: [Initialization](https://agentclientprotocol.com/protocol/v2/initialization)
final class InitializeRequest implements AcpJsonEncodable {
  /// Creates a InitializeRequest value.
  InitializeRequest({
    required this.protocolVersion,
    required this.info,
    required this.capabilities,
    this.meta,
  });

  /// The latest protocol version supported by the client.
  final ProtocolVersion protocolVersion;

  /// Information about the implementation sending this initialize request.
  final Implementation info;

  /// Capabilities supported by the client.
  final ClientCapabilities capabilities;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<InitializeRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = InitializeRequest(
      protocolVersion: decoder.required(
        'protocolVersion',
        (value) => protocolVersionCodec.decode(value),
      ),
      info: decoder.required(
        'info',
        (value) => implementationCodec.decode(value),
      ),
      capabilities: decoder.defaultOnError(
        'capabilities',
        clientCapabilitiesCodec.decode(<String, Object?>{}),
        (value) => clientCapabilitiesCodec.decode(value),
      ),
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
    result['info'] = implementationCodec.encode(info);
    result['capabilities'] = clientCapabilitiesCodec.encode(capabilities);
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
/// See protocol docs: [Initialization](https://agentclientprotocol.com/protocol/v2/initialization)
final class InitializeResponse implements AcpJsonEncodable {
  /// Creates a InitializeResponse value.
  InitializeResponse({
    required this.protocolVersion,
    required this.info,
    required this.capabilities,
    List<AuthMethod>? authMethods,
    this.meta,
  }) : authMethods = authMethods == null
           ? null
           : List<AuthMethod>.unmodifiable(authMethods);

  /// The protocol version the client specified if supported by the agent,
  /// or the latest protocol version supported by the agent.
  ///
  /// The client should disconnect, if it doesn't support this version.
  final ProtocolVersion protocolVersion;

  /// Information about the implementation sending this initialize response.
  final Implementation info;

  /// Capabilities supported by the agent.
  final AgentCapabilities capabilities;

  /// Authentication methods supported by the agent.
  ///
  /// Optional. Omitted or empty means the agent does not advertise the
  /// authentication method surface. Supplying one or more valid methods means
  /// the agent MUST support both `auth/login` and `auth/logout`.
  final List<AuthMethod>? authMethods;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<InitializeResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = InitializeResponse(
      protocolVersion: decoder.required(
        'protocolVersion',
        (value) => protocolVersionCodec.decode(value),
      ),
      info: decoder.required(
        'info',
        (value) => implementationCodec.decode(value),
      ),
      capabilities: decoder.defaultOnError(
        'capabilities',
        agentCapabilitiesCodec.decode(<String, Object?>{}),
        (value) => agentCapabilitiesCodec.decode(value),
      ),
      authMethods: decoder.listSkippingInvalid(
        'authMethods',
        (value) => authMethodCodec.decode(value),
        isRequired: false,
      ),
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
    result['info'] = implementationCodec.encode(info);
    result['capabilities'] = agentCapabilitiesCodec.encode(capabilities);
    if (authMethods != null) {
      result['authMethods'] = <Object?>[
        for (final item in authMethods!) authMethodCodec.encode(item),
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

@JsonSerializable(createFactory: false, createToJson: false)
/// Request parameters for listing existing sessions.
final class ListSessionsRequest implements AcpJsonEncodable {
  /// Creates a ListSessionsRequest value.
  ListSessionsRequest({this.cwd, this.cursor, this.meta});

  /// Filter sessions by working directory. Must be an absolute path.
  final AbsolutePath? cwd;

  /// Opaque cursor token from a previous response's nextCursor field for cursor-based pagination
  final SessionListCursor? cursor;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ListSessionsRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ListSessionsRequest(
      cwd: decoder.optional('cwd', (value) => absolutePathCodec.decode(value)),
      cursor: decoder.optional(
        'cursor',
        (value) => sessionListCursorCodec.decode(value),
      ),
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
      result['cwd'] = absolutePathCodec.encode(cwd!);
    }
    if (cursor != null) {
      result['cursor'] = sessionListCursorCodec.encode(cursor!);
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

  /// Array of session information objects.
  final List<SessionInfo> sessions;

  /// Opaque cursor token. If present, pass this in the next request's cursor parameter
  /// to fetch the next page. If absent, there are no more results.
  final SessionListCursor? nextCursor;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
          .optionalOnError(
            'nextCursor',
            (value) => sessionListCursorCodec.decode(value),
          )
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
      result['nextCursor'] = sessionListCursorCodec.encode(nextCursor!);
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

AuthMethodId _decodeLoginAuthRequestMethodId(Object? value) =>
    authMethodIdCodec.decode(value);
Object? _encodeLoginAuthRequestMethodId(AuthMethodId value) =>
    authMethodIdCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for the `auth/login` method.
///
/// Specifies which authentication method to use.
///
/// Agents MUST support this method when their `initialize` response advertised
/// at least one valid authentication method. Clients MUST NOT call this method
/// when `authMethods` was omitted or empty.
final class LoginAuthRequest implements AcpJsonEncodable {
  /// Creates a LoginAuthRequest value.
  LoginAuthRequest({required this.methodId, this.meta});

  /// The ID of the authentication method to use.
  /// Must be one of the methods advertised in the initialize response.
  @JsonKey(
    name: 'methodId',
    fromJson: _decodeLoginAuthRequestMethodId,
    toJson: _encodeLoginAuthRequestMethodId,
    includeIfNull: false,
    required: true,
  )
  final AuthMethodId methodId;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory LoginAuthRequest.fromJson(Map<String, Object?> json) =>
      _$LoginAuthRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$LoginAuthRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [LoginAuthRequest].
final class LoginAuthRequestCodec implements AcpCodec<LoginAuthRequest> {
  /// Creates the codec.
  const LoginAuthRequestCodec();

  @override
  LoginAuthRequest decode(Object? value) =>
      LoginAuthRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(LoginAuthRequest value) => value.toJson();
}

/// Shared codec for [LoginAuthRequest].
const LoginAuthRequestCodec loginAuthRequestCodec = LoginAuthRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to the `auth/login` method.
final class LoginAuthResponse implements AcpJsonEncodable {
  /// Creates a LoginAuthResponse value.
  LoginAuthResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory LoginAuthResponse.fromJson(Map<String, Object?> json) =>
      _$LoginAuthResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$LoginAuthResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [LoginAuthResponse].
final class LoginAuthResponseCodec implements AcpCodec<LoginAuthResponse> {
  /// Creates the codec.
  const LoginAuthResponseCodec();

  @override
  LoginAuthResponse decode(Object? value) =>
      LoginAuthResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(LoginAuthResponse value) => value.toJson();
}

/// Shared codec for [LoginAuthResponse].
const LoginAuthResponseCodec loginAuthResponseCodec = LoginAuthResponseCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Request parameters for the `auth/logout` method.
///
/// Terminates the current authenticated session.
///
/// Agents MUST support this method when their `initialize` response advertised
/// at least one valid authentication method. Clients MUST NOT call this method
/// when `authMethods` was omitted or empty.
final class LogoutAuthRequest implements AcpJsonEncodable {
  /// Creates a LogoutAuthRequest value.
  LogoutAuthRequest({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory LogoutAuthRequest.fromJson(Map<String, Object?> json) =>
      _$LogoutAuthRequestFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$LogoutAuthRequestToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [LogoutAuthRequest].
final class LogoutAuthRequestCodec implements AcpCodec<LogoutAuthRequest> {
  /// Creates the codec.
  const LogoutAuthRequestCodec();

  @override
  LogoutAuthRequest decode(Object? value) =>
      LogoutAuthRequest.fromJson(decodeAcpObject(value));

  @override
  Object encode(LogoutAuthRequest value) => value.toJson();
}

/// Shared codec for [LogoutAuthRequest].
const LogoutAuthRequestCodec logoutAuthRequestCodec = LogoutAuthRequestCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response to the `auth/logout` method.
final class LogoutAuthResponse implements AcpJsonEncodable {
  /// Creates a LogoutAuthResponse value.
  LogoutAuthResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory LogoutAuthResponse.fromJson(Map<String, Object?> json) =>
      _$LogoutAuthResponseFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$LogoutAuthResponseToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [LogoutAuthResponse].
final class LogoutAuthResponseCodec implements AcpCodec<LogoutAuthResponse> {
  /// Creates the codec.
  const LogoutAuthResponseCodec();

  @override
  LogoutAuthResponse decode(Object? value) =>
      LogoutAuthResponse.fromJson(decodeAcpObject(value));

  @override
  Object encode(LogoutAuthResponse value) => value.toJson();
}

/// Shared codec for [LogoutAuthResponse].
const LogoutAuthResponseCodec logoutAuthResponseCodec =
    LogoutAuthResponseCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// MCP capabilities supported by the agent for session lifecycle requests.
final class McpCapabilities implements AcpJsonEncodable {
  /// Creates a McpCapabilities value.
  McpCapabilities({this.stdio, this.http, this.meta});

  /// Agent supports `McpServer::Stdio`.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports stdio MCP server transports.
  final McpStdioCapabilities? stdio;

  /// Agent supports `McpServer::Http`.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports HTTP MCP server transports.
  final McpHttpCapabilities? http;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<McpCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = McpCapabilities(
      stdio: decoder
          .optionalOnError(
            'stdio',
            (value) => mcpStdioCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      http: decoder
          .optionalOnError(
            'http',
            (value) => mcpHttpCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
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
    if (stdio != null) {
      result['stdio'] = mcpStdioCapabilitiesCodec.encode(stdio!);
    }
    if (http != null) {
      result['http'] = mcpHttpCapabilitiesCodec.encode(http!);
    }
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

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for HTTP MCP server transports.
///
/// Supplying `{}` means the agent supports HTTP MCP server transports.
final class McpHttpCapabilities implements AcpJsonEncodable {
  /// Creates a McpHttpCapabilities value.
  McpHttpCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory McpHttpCapabilities.fromJson(Map<String, Object?> json) =>
      _$McpHttpCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$McpHttpCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [McpHttpCapabilities].
final class McpHttpCapabilitiesCodec implements AcpCodec<McpHttpCapabilities> {
  /// Creates the codec.
  const McpHttpCapabilitiesCodec();

  @override
  McpHttpCapabilities decode(Object? value) =>
      McpHttpCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(McpHttpCapabilities value) => value.toJson();
}

/// Shared codec for [McpHttpCapabilities].
const McpHttpCapabilitiesCodec mcpHttpCapabilitiesCodec =
    McpHttpCapabilitiesCodec();

/// Configuration for connecting to an MCP (Model Context Protocol) server.
///
/// MCP servers provide tools and context that the agent can use when
/// processing prompts.
///
/// See protocol docs: [MCP Servers](https://agentclientprotocol.com/protocol/v2/session-setup#mcp-servers)
sealed class McpServer implements AcpJsonEncodable {
  const McpServer();

  /// Decodes the tagged union.
  factory McpServer.fromJson(Object? json) => mcpServerCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// HTTP transport configuration
///
/// Only available when the Agent capabilities include `session.mcp.http`.
final class McpServerHttpVariant extends McpServer {
  /// Creates this known tagged-union variant.
  const McpServerHttpVariant(this.value);

  /// The typed variant payload.
  final McpServerHttp value;

  @override
  String get discriminator => 'http';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(mcpServerHttpCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Stdio transport configuration
///
/// Only available when the Agent capabilities include `session.mcp.stdio`.
final class McpServerStdioVariant extends McpServer {
  /// Creates this known tagged-union variant.
  const McpServerStdioVariant(this.value);

  /// The typed variant payload.
  final McpServerStdio value;

  @override
  String get discriminator => 'stdio';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(mcpServerStdioCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [McpServer] variant.
final class McpServerCustom extends McpServer {
  /// Creates a raw-preserving custom variant.
  McpServerCustom({required this.discriminator, required AcpJsonObject payload})
    : payload = payload.without('__proto__');

  @override
  final String discriminator;

  /// Opaque extension fields.
  final AcpJsonObject payload;

  @override
  AcpJsonObject toAcpJson() =>
      payload.withValue('type', AcpJsonString(discriminator));
}

/// Codec for [McpServer].
final class McpServerCodec implements AcpCodec<McpServer> {
  /// Creates the codec.
  const McpServerCodec();

  @override
  McpServer decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'http':
        return McpServerHttpVariant(mcpServerHttpCodec.decode(payload));
      case 'stdio':
        return McpServerStdioVariant(mcpServerStdioCodec.decode(payload));
      default:
        return McpServerCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(McpServer value) => value.toJson();
}

/// Shared codec for [McpServer].
const McpServerCodec mcpServerCodec = McpServerCodec();

String _decodeMcpServerHttpName(Object? value) => decodeAcpString(value);
Object? _encodeMcpServerHttpName(String value) => value;

Uri _decodeMcpServerHttpUrl(Object? value) => decodeAcpUri(value);
Object? _encodeMcpServerHttpUrl(Uri value) => value.toString();

List<HttpHeader>? _decodeMcpServerHttpHeaders(Object? value) => value == null
    ? null
    : List<HttpHeader>.unmodifiable(
        (value as List<Object?>).map((item) => httpHeaderCodec.decode(item)),
      );
Object? _encodeMcpServerHttpHeaders(List<HttpHeader>? value) => value == null
    ? null
    : <Object?>[for (final item in value) httpHeaderCodec.encode(item)];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// HTTP transport configuration for MCP.
final class McpServerHttp implements AcpJsonEncodable {
  /// Creates a McpServerHttp value.
  McpServerHttp({
    required this.name,
    required this.url,
    List<HttpHeader>? headers,
    this.meta,
  }) : headers = headers == null
           ? null
           : List<HttpHeader>.unmodifiable(headers);

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
  final Uri url;

  /// HTTP headers to set when making requests to the MCP server.
  @JsonKey(
    name: 'headers',
    fromJson: _decodeMcpServerHttpHeaders,
    toJson: _encodeMcpServerHttpHeaders,
    includeIfNull: false,
    required: false,
  )
  final List<HttpHeader>? headers;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

String _decodeMcpServerStdioName(Object? value) => decodeAcpString(value);
Object? _encodeMcpServerStdioName(String value) => value;

AbsolutePath _decodeMcpServerStdioCommand(Object? value) =>
    absolutePathCodec.decode(value);
Object? _encodeMcpServerStdioCommand(AbsolutePath value) =>
    absolutePathCodec.encode(value);

List<String>? _decodeMcpServerStdioArgs(Object? value) => value == null
    ? null
    : List<String>.unmodifiable(
        (value as List<Object?>).map((item) => decodeAcpString(item)),
      );
Object? _encodeMcpServerStdioArgs(List<String>? value) =>
    value == null ? null : <Object?>[for (final item in value) item];

List<EnvVariable>? _decodeMcpServerStdioEnv(Object? value) => value == null
    ? null
    : List<EnvVariable>.unmodifiable(
        (value as List<Object?>).map((item) => envVariableCodec.decode(item)),
      );
Object? _encodeMcpServerStdioEnv(List<EnvVariable>? value) => value == null
    ? null
    : <Object?>[for (final item in value) envVariableCodec.encode(item)];

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Stdio transport configuration for MCP.
final class McpServerStdio implements AcpJsonEncodable {
  /// Creates a McpServerStdio value.
  McpServerStdio({
    required this.name,
    required this.command,
    List<String>? args,
    List<EnvVariable>? env,
    this.meta,
  }) : args = args == null ? null : List<String>.unmodifiable(args),
       env = env == null ? null : List<EnvVariable>.unmodifiable(env);

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
  final AbsolutePath command;

  /// Command-line arguments to pass to the MCP server.
  @JsonKey(
    name: 'args',
    fromJson: _decodeMcpServerStdioArgs,
    toJson: _encodeMcpServerStdioArgs,
    includeIfNull: false,
    required: false,
  )
  final List<String>? args;

  /// Environment variables to set when launching the MCP server.
  @JsonKey(
    name: 'env',
    fromJson: _decodeMcpServerStdioEnv,
    toJson: _encodeMcpServerStdioEnv,
    includeIfNull: false,
    required: false,
  )
  final List<EnvVariable>? env;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for stdio MCP server transports.
///
/// Supplying `{}` means the agent supports stdio MCP server transports.
final class McpStdioCapabilities implements AcpJsonEncodable {
  /// Creates a McpStdioCapabilities value.
  McpStdioCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory McpStdioCapabilities.fromJson(Map<String, Object?> json) =>
      _$McpStdioCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$McpStdioCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [McpStdioCapabilities].
final class McpStdioCapabilitiesCodec
    implements AcpCodec<McpStdioCapabilities> {
  /// Creates the codec.
  const McpStdioCapabilitiesCodec();

  @override
  McpStdioCapabilities decode(Object? value) =>
      McpStdioCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(McpStdioCapabilities value) => value.toJson();
}

/// Shared codec for [McpStdioCapabilities].
const McpStdioCapabilitiesCodec mcpStdioCapabilitiesCodec =
    McpStdioCapabilitiesCodec();

/// An Internet media type identifying the format of protocol content.
final class MediaType implements AcpJsonEncodable {
  /// Validates and creates a MediaType value.
  factory MediaType(String value) {
    return MediaType._(value);
  }

  const MediaType._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory MediaType.fromJson(Object? json) => MediaType(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) => other is MediaType && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [MediaType].
final class MediaTypeCodec implements AcpCodec<MediaType> {
  /// Creates the codec.
  const MediaTypeCodec();

  @override
  MediaType decode(Object? value) => MediaType.fromJson(value);

  @override
  String encode(MediaType value) => value.toJson();
}

/// Shared codec for [MediaType].
const MediaTypeCodec mediaTypeCodec = MediaTypeCodec();

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// See protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/v2/session-setup#creating-a-session)
final class NewSessionRequest implements AcpJsonEncodable {
  /// Creates a NewSessionRequest value.
  NewSessionRequest({
    required this.cwd,
    List<AbsolutePath>? additionalDirectories,
    List<McpServer>? mcpServers,
    this.meta,
  }) : additionalDirectories = additionalDirectories == null
           ? null
           : List<AbsolutePath>.unmodifiable(additionalDirectories),
       mcpServers = mcpServers == null
           ? null
           : List<McpServer>.unmodifiable(mcpServers);

  /// The working directory for this session. Must be an absolute path.
  final AbsolutePath cwd;

  /// Additional workspace roots for this session. Each path must be absolute.
  ///
  /// These expand the session's workspace scope without changing `cwd`, which
  /// remains the base for relative paths. When omitted or empty, no
  /// additional roots are activated for the new session.
  final List<AbsolutePath>? additionalDirectories;

  /// List of MCP (Model Context Protocol) servers the agent should connect to.
  final List<McpServer>? mcpServers;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NewSessionRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NewSessionRequest(
      cwd: decoder.required('cwd', (value) => absolutePathCodec.decode(value)),
      additionalDirectories: decoder.listSkippingInvalid(
        'additionalDirectories',
        (value) => absolutePathCodec.decode(value),
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
  factory NewSessionRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['cwd'] = absolutePathCodec.encode(cwd);
    if (additionalDirectories != null) {
      result['additionalDirectories'] = <Object?>[
        for (final item in additionalDirectories!)
          absolutePathCodec.encode(item),
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
/// See protocol docs: [Creating a Session](https://agentclientprotocol.com/protocol/v2/session-setup#creating-a-session)
final class NewSessionResponse implements AcpJsonEncodable {
  /// Creates a NewSessionResponse value.
  NewSessionResponse({
    required this.sessionId,
    List<SessionConfigOption>? configOptions,
    this.meta,
  }) : configOptions = configOptions == null
           ? null
           : List<SessionConfigOption>.unmodifiable(configOptions);

  /// Unique identifier for the created session.
  ///
  /// Used in all subsequent requests for this conversation.
  final SessionId sessionId;

  /// Initial session configuration options.
  final List<SessionConfigOption>? configOptions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<NewSessionResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = NewSessionResponse(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// See protocol docs: [Plan Entries](https://agentclientprotocol.com/protocol/v2/agent-plan#plan-entries)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// See protocol docs: [Plan Entries](https://agentclientprotocol.com/protocol/v2/agent-plan#plan-entries)
final class PlanEntryPriority implements AcpJsonEncodable {
  /// Validates and creates a PlanEntryPriority value.
  factory PlanEntryPriority(String value) {
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
/// See protocol docs: [Plan Entries](https://agentclientprotocol.com/protocol/v2/agent-plan#plan-entries)
final class PlanEntryStatus implements AcpJsonEncodable {
  /// Validates and creates a PlanEntryStatus value.
  factory PlanEntryStatus(String value) {
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

  /// The `cancelled` schema value.
  static const PlanEntryStatus cancelled = PlanEntryStatus._('cancelled');

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

PlanUpdateContent _decodePlanUpdatePlan(Object? value) =>
    planUpdateContentCodec.decode(value);
Object? _encodePlanUpdatePlan(PlanUpdateContent value) =>
    planUpdateContentCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

/// An unknown future or `_`-prefixed [PlanUpdateContent] variant.
final class PlanUpdateContentCustom extends PlanUpdateContent {
  /// Creates a raw-preserving custom variant.
  PlanUpdateContentCustom({
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
      default:
        return PlanUpdateContentCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(PlanUpdateContent value) => value.toJson();
}

/// Shared codec for [PlanUpdateContent].
const PlanUpdateContentCodec planUpdateContentCodec = PlanUpdateContentCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for audio content in prompt requests.
///
/// Supplying `{}` means the agent supports audio content in prompts.
final class PromptAudioCapabilities implements AcpJsonEncodable {
  /// Creates a PromptAudioCapabilities value.
  PromptAudioCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PromptAudioCapabilities.fromJson(Map<String, Object?> json) =>
      _$PromptAudioCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PromptAudioCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PromptAudioCapabilities].
final class PromptAudioCapabilitiesCodec
    implements AcpCodec<PromptAudioCapabilities> {
  /// Creates the codec.
  const PromptAudioCapabilitiesCodec();

  @override
  PromptAudioCapabilities decode(Object? value) =>
      PromptAudioCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(PromptAudioCapabilities value) => value.toJson();
}

/// Shared codec for [PromptAudioCapabilities].
const PromptAudioCapabilitiesCodec promptAudioCapabilitiesCodec =
    PromptAudioCapabilitiesCodec();

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
  PromptCapabilities({this.image, this.audio, this.embeddedContext, this.meta});

  /// Agent supports `ContentBlock::Image`.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports image content in prompts.
  final PromptImageCapabilities? image;

  /// Agent supports `ContentBlock::Audio`.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports audio content in prompts.
  final PromptAudioCapabilities? audio;

  /// Agent supports embedded context in `session/prompt` requests.
  ///
  /// When enabled, the Client is allowed to include `ContentBlock::Resource`
  /// in prompt requests for pieces of context that are referenced in the message.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise support.
  /// Supplying `{}` means the agent supports embedded context in prompts.
  final PromptEmbeddedContextCapabilities? embeddedContext;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<PromptCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = PromptCapabilities(
      image: decoder
          .optionalOnError(
            'image',
            (value) => promptImageCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      audio: decoder
          .optionalOnError(
            'audio',
            (value) => promptAudioCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      embeddedContext: decoder
          .optionalOnError(
            'embeddedContext',
            (value) => promptEmbeddedContextCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
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
    if (image != null) {
      result['image'] = promptImageCapabilitiesCodec.encode(image!);
    }
    if (audio != null) {
      result['audio'] = promptAudioCapabilitiesCodec.encode(audio!);
    }
    if (embeddedContext != null) {
      result['embeddedContext'] = promptEmbeddedContextCapabilitiesCodec.encode(
        embeddedContext!,
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

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for embedded context in prompt requests.
///
/// Supplying `{}` means the agent supports embedded context in prompts.
final class PromptEmbeddedContextCapabilities implements AcpJsonEncodable {
  /// Creates a PromptEmbeddedContextCapabilities value.
  PromptEmbeddedContextCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PromptEmbeddedContextCapabilities.fromJson(
    Map<String, Object?> json,
  ) => _$PromptEmbeddedContextCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() =>
      _$PromptEmbeddedContextCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PromptEmbeddedContextCapabilities].
final class PromptEmbeddedContextCapabilitiesCodec
    implements AcpCodec<PromptEmbeddedContextCapabilities> {
  /// Creates the codec.
  const PromptEmbeddedContextCapabilitiesCodec();

  @override
  PromptEmbeddedContextCapabilities decode(Object? value) =>
      PromptEmbeddedContextCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(PromptEmbeddedContextCapabilities value) => value.toJson();
}

/// Shared codec for [PromptEmbeddedContextCapabilities].
const PromptEmbeddedContextCapabilitiesCodec
promptEmbeddedContextCapabilitiesCodec =
    PromptEmbeddedContextCapabilitiesCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Capabilities for image content in prompt requests.
///
/// Supplying `{}` means the agent supports image content in prompts.
final class PromptImageCapabilities implements AcpJsonEncodable {
  /// Creates a PromptImageCapabilities value.
  PromptImageCapabilities({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory PromptImageCapabilities.fromJson(Map<String, Object?> json) =>
      _$PromptImageCapabilitiesFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$PromptImageCapabilitiesToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [PromptImageCapabilities].
final class PromptImageCapabilitiesCodec
    implements AcpCodec<PromptImageCapabilities> {
  /// Creates the codec.
  const PromptImageCapabilitiesCodec();

  @override
  PromptImageCapabilities decode(Object? value) =>
      PromptImageCapabilities.fromJson(decodeAcpObject(value));

  @override
  Object encode(PromptImageCapabilities value) => value.toJson();
}

/// Shared codec for [PromptImageCapabilities].
const PromptImageCapabilitiesCodec promptImageCapabilitiesCodec =
    PromptImageCapabilitiesCodec();

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
/// See protocol docs: [User Message](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#1-user-message)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Response acknowledging that a user prompt was accepted.
///
/// This response does not indicate that the agent has finished processing.
/// Processing and completion are reported through `state_update` session updates.
///
/// See protocol docs: [Prompt Accepted](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#2-prompt-accepted)
final class PromptResponse implements AcpJsonEncodable {
  /// Creates a PromptResponse value.
  PromptResponse({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

@JsonSerializable(createFactory: false, createToJson: false)
/// A JSON-RPC notification object.
final class ProtocolLevelNotification implements AcpJsonEncodable {
  /// Creates a ProtocolLevelNotification value.
  ProtocolLevelNotification({required this.method, this.params});

  /// The notification method name.
  final String method;

  /// Method-specific notification parameters.
  final CancelRequestNotification? params;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ProtocolLevelNotification> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ProtocolLevelNotification(
      method: decoder.required('method', (value) => decodeAcpString(value)),
      params: decoder.optional(
        'params',
        (value) => cancelRequestNotificationCodec.decode(value),
      ),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory ProtocolLevelNotification.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['method'] = method;
    if (params != null) {
      result['params'] = cancelRequestNotificationCodec.encode(params!);
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ProtocolLevelNotification].
final class ProtocolLevelNotificationCodec
    implements AcpCodec<ProtocolLevelNotification> {
  /// Creates the codec.
  const ProtocolLevelNotificationCodec();

  @override
  ProtocolLevelNotification decode(Object? value) =>
      ProtocolLevelNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(ProtocolLevelNotification value) => value.toJson();
}

/// Shared codec for [ProtocolLevelNotification].
const ProtocolLevelNotificationCodec protocolLevelNotificationCodec =
    ProtocolLevelNotificationCodec();

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

/// Inclusive cursor describing where replayed session history should begin.
///
/// Replay includes the position identified by the cursor.
sealed class ReplayFrom implements AcpJsonEncodable {
  const ReplayFrom();

  /// Decodes the tagged union.
  factory ReplayFrom.fromJson(Object? json) => replayFromCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// Replay the whole conversation from its first replayable entry.
final class ReplayFromStartVariant extends ReplayFrom {
  /// Creates this known tagged-union variant.
  const ReplayFromStartVariant(this.value);

  /// The typed variant payload.
  final ReplayFromStart value;

  @override
  String get discriminator => 'start';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(replayFromStartCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [ReplayFrom] variant.
final class ReplayFromCustom extends ReplayFrom {
  /// Creates a raw-preserving custom variant.
  ReplayFromCustom({
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

/// Codec for [ReplayFrom].
final class ReplayFromCodec implements AcpCodec<ReplayFrom> {
  /// Creates the codec.
  const ReplayFromCodec();

  @override
  ReplayFrom decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'start':
        return ReplayFromStartVariant(replayFromStartCodec.decode(payload));
      default:
        return ReplayFromCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(ReplayFrom value) => value.toJson();
}

/// Shared codec for [ReplayFrom].
const ReplayFromCodec replayFromCodec = ReplayFromCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Inclusive replay cursor requesting replay from the start of the conversation.
final class ReplayFromStart implements AcpJsonEncodable {
  /// Creates a ReplayFromStart value.
  ReplayFromStart({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ReplayFromStart.fromJson(Map<String, Object?> json) =>
      _$ReplayFromStartFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ReplayFromStartToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ReplayFromStart].
final class ReplayFromStartCodec implements AcpCodec<ReplayFromStart> {
  /// Creates the codec.
  const ReplayFromStartCodec();

  @override
  ReplayFromStart decode(Object? value) =>
      ReplayFromStart.fromJson(decodeAcpObject(value));

  @override
  Object encode(ReplayFromStart value) => value.toJson();
}

/// Shared codec for [ReplayFromStart].
const ReplayFromStartCodec replayFromStartCodec = ReplayFromStartCodec();

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

/// Active session work was cancelled before the user responded.
///
/// When a client sends a `session/cancel` notification to cancel active
/// session work, it MUST respond to all pending `session/request_permission`
/// requests with this `Cancelled` outcome.
///
/// See protocol docs: [Cancellation](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#cancellation)
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

/// An unknown future or `_`-prefixed [RequestPermissionOutcome] variant.
final class RequestPermissionOutcomeCustom extends RequestPermissionOutcome {
  /// Creates a raw-preserving custom variant.
  RequestPermissionOutcomeCustom({
    required this.discriminator,
    required AcpJsonObject payload,
  }) : payload = payload.without('__proto__');

  @override
  final String discriminator;

  /// Opaque extension fields.
  final AcpJsonObject payload;

  @override
  AcpJsonObject toAcpJson() =>
      payload.withValue('outcome', AcpJsonString(discriminator));
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
        return RequestPermissionOutcomeCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(RequestPermissionOutcome value) => value.toJson();
}

/// Shared codec for [RequestPermissionOutcome].
const RequestPermissionOutcomeCodec requestPermissionOutcomeCodec =
    RequestPermissionOutcomeCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Request for user permission to proceed with an operation.
///
/// Sent when the agent needs authorization before performing a sensitive operation.
///
/// See protocol docs: [Requesting Permission](https://agentclientprotocol.com/protocol/v2/tool-calls#requesting-permission)
final class RequestPermissionRequest implements AcpJsonEncodable {
  /// Creates a RequestPermissionRequest value.
  RequestPermissionRequest({
    required this.sessionId,
    required this.title,
    required List<PermissionOption> options,
    this.description,
    this.subject,
    this.meta,
  }) : options = List<PermissionOption>.unmodifiable(options);

  /// The session ID for this request.
  final SessionId sessionId;

  /// Human-readable title for the permission prompt.
  ///
  /// This title is specific to the permission prompt and does not update any
  /// subject's displayed title.
  final String title;

  /// Optional human-readable explanation of why permission is needed.
  ///
  /// This text is specific to the permission prompt and does not update any
  /// subject's displayed content. Omitted or `null` both mean no separate
  /// permission description was provided.
  final String? description;

  /// Optional structured context about the operation requiring permission.
  ///
  /// Omitted or `null` both mean no structured subject was provided.
  final RequestPermissionSubject? subject;

  /// Available permission options for the user to choose from.
  /// Must contain at least one option.
  final List<PermissionOption> options;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<RequestPermissionRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = RequestPermissionRequest(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      title: decoder.required('title', (value) => decodeAcpString(value)),
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      subject: decoder.optional(
        'subject',
        (value) => requestPermissionSubjectCodec.decode(value),
      ),
      options: decoder.required(
        'options',
        (value) => List<PermissionOption>.unmodifiable(
          (value as List<Object?>).map(
            (item) => permissionOptionCodec.decode(item),
          ),
        ),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory RequestPermissionRequest.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['title'] = title;
    if (description != null) {
      result['description'] = description!;
    }
    if (subject != null) {
      result['subject'] = requestPermissionSubjectCodec.encode(subject!);
    }
    result['options'] = <Object?>[
      for (final item in options) permissionOptionCodec.encode(item),
    ];
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

/// The operation requiring permission.
sealed class RequestPermissionSubject implements AcpJsonEncodable {
  const RequestPermissionSubject();

  /// Decodes the tagged union.
  factory RequestPermissionSubject.fromJson(Object? json) =>
      requestPermissionSubjectCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// Permission is requested before executing a tool call.
final class RequestPermissionSubjectToolCall extends RequestPermissionSubject {
  /// Creates this known tagged-union variant.
  const RequestPermissionSubjectToolCall(this.value);

  /// The typed variant payload.
  final ToolCallPermissionSubject value;

  @override
  String get discriminator => 'tool_call';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(
      toolCallPermissionSubjectCodec.encode(value),
    );
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Permission is requested before running a command.
final class RequestPermissionSubjectCommand extends RequestPermissionSubject {
  /// Creates this known tagged-union variant.
  const RequestPermissionSubjectCommand(this.value);

  /// The typed variant payload.
  final CommandPermissionSubject value;

  @override
  String get discriminator => 'command';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(
      commandPermissionSubjectCodec.encode(value),
    );
    final result = <String, Object?>{...payload};
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [RequestPermissionSubject] variant.
final class RequestPermissionSubjectCustom extends RequestPermissionSubject {
  /// Creates a raw-preserving custom variant.
  RequestPermissionSubjectCustom({
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

/// Codec for [RequestPermissionSubject].
final class RequestPermissionSubjectCodec
    implements AcpCodec<RequestPermissionSubject> {
  /// Creates the codec.
  const RequestPermissionSubjectCodec();

  @override
  RequestPermissionSubject decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'tool_call':
        return RequestPermissionSubjectToolCall(
          toolCallPermissionSubjectCodec.decode(payload),
        );
      case 'command':
        return RequestPermissionSubjectCommand(
          commandPermissionSubjectCodec.decode(payload),
        );
      default:
        return RequestPermissionSubjectCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(RequestPermissionSubject value) => value.toJson();
}

/// Shared codec for [RequestPermissionSubject].
const RequestPermissionSubjectCodec requestPermissionSubjectCodec =
    RequestPermissionSubjectCodec();

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Foreground work is blocked on user action.
final class RequiresActionStateUpdate implements AcpJsonEncodable {
  /// Creates a RequiresActionStateUpdate value.
  RequiresActionStateUpdate({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory RequiresActionStateUpdate.fromJson(Map<String, Object?> json) =>
      _$RequiresActionStateUpdateFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$RequiresActionStateUpdateToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [RequiresActionStateUpdate].
final class RequiresActionStateUpdateCodec
    implements AcpCodec<RequiresActionStateUpdate> {
  /// Creates the codec.
  const RequiresActionStateUpdateCodec();

  @override
  RequiresActionStateUpdate decode(Object? value) =>
      RequiresActionStateUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(RequiresActionStateUpdate value) => value.toJson();
}

/// Shared codec for [RequiresActionStateUpdate].
const RequiresActionStateUpdateCodec requiresActionStateUpdateCodec =
    RequiresActionStateUpdateCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// A resource that the server is capable of reading, included in a prompt or tool call result.
final class ResourceLink implements AcpJsonEncodable {
  /// Creates a ResourceLink value.
  ResourceLink({
    required this.name,
    required this.uri,
    this.title,
    this.description,
    List<Icon>? icons,
    this.mimeType,
    this.size,
    this.annotations,
    this.meta,
  }) : icons = icons == null ? null : List<Icon>.unmodifiable(icons);

  /// Human-readable name shown for this protocol object.
  final String name;

  /// URI associated with this resource or media payload.
  final Uri uri;

  /// Optional display title for end-user UI.
  final String? title;

  /// Optional human-readable details shown with this protocol object.
  final String? description;

  /// Optional set of sized icons that the client can display in a user interface.
  final List<Icon>? icons;

  /// MIME type describing the encoded media payload.
  final MediaType? mimeType;

  /// Optional size of the linked resource in bytes, if known.
  final AcpInt64? size;

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ResourceLink> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ResourceLink(
      name: decoder.required('name', (value) => decodeAcpString(value)),
      uri: decoder.required('uri', (value) => decodeAcpUri(value)),
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      description: decoder
          .optionalOnError('description', (value) => decodeAcpString(value))
          .valueOrNull,
      icons: decoder.listSkippingInvalid(
        'icons',
        (value) => iconCodec.decode(value),
        isRequired: false,
      ),
      mimeType: decoder
          .optionalOnError('mimeType', (value) => mediaTypeCodec.decode(value))
          .valueOrNull,
      size: decoder
          .optionalOnError('size', (value) => decodeAcpInt64(value))
          .valueOrNull,
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
          .valueOrNull,
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
    result['name'] = name;
    result['uri'] = uri.toString();
    if (title != null) {
      result['title'] = title!;
    }
    if (description != null) {
      result['description'] = description!;
    }
    if (icons != null) {
      result['icons'] = <Object?>[
        for (final item in icons!) iconCodec.encode(item),
      ];
    }
    if (mimeType != null) {
      result['mimeType'] = mediaTypeCodec.encode(mimeType!);
    }
    if (size != null) {
      result['size'] = encodeAcpInt64(size!);
    }
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
    }
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
/// Resumes an existing session and optionally replays prior conversation
/// history according to `replayFrom`.
final class ResumeSessionRequest implements AcpJsonEncodable {
  /// Creates a ResumeSessionRequest value.
  ResumeSessionRequest({
    required this.sessionId,
    required this.cwd,
    List<AbsolutePath>? additionalDirectories,
    List<McpServer>? mcpServers,
    this.replayFrom,
    this.meta,
  }) : additionalDirectories = additionalDirectories == null
           ? null
           : List<AbsolutePath>.unmodifiable(additionalDirectories),
       mcpServers = mcpServers == null
           ? null
           : List<McpServer>.unmodifiable(mcpServers);

  /// The ID of the session to resume.
  final SessionId sessionId;

  /// The working directory for this session. Must be an absolute path.
  final AbsolutePath cwd;

  /// Additional workspace roots to activate for this session. Each path must be absolute.
  ///
  /// When omitted or empty, no additional roots are activated. When non-empty,
  /// this is the complete resulting additional-root list for the resumed
  /// session. It may differ from any previously used or reported list as long as
  /// the request `cwd` matches the session's `cwd`.
  final List<AbsolutePath>? additionalDirectories;

  /// List of MCP servers to connect to for this session.
  final List<McpServer>? mcpServers;

  /// Inclusive cursor describing where conversation replay should begin.
  ///
  /// Optional. Omitted or `null` both mean the Agent should resume without
  /// replaying previous conversation history. Replay cursors are inclusive:
  /// replay includes the position identified by the cursor. Supplying
  /// `{ "type": "start" }` means the Agent should replay the whole
  /// conversation before responding.
  final ReplayFrom? replayFrom;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ResumeSessionRequest> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ResumeSessionRequest(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      cwd: decoder.required('cwd', (value) => absolutePathCodec.decode(value)),
      additionalDirectories: decoder.listSkippingInvalid(
        'additionalDirectories',
        (value) => absolutePathCodec.decode(value),
        isRequired: false,
      ),
      mcpServers: decoder.listSkippingInvalid(
        'mcpServers',
        (value) => mcpServerCodec.decode(value),
        isRequired: false,
      ),
      replayFrom: decoder
          .optionalOnError(
            'replayFrom',
            (value) => replayFromCodec.decode(value),
          )
          .valueOrNull,
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
    result['cwd'] = absolutePathCodec.encode(cwd);
    if (additionalDirectories != null) {
      result['additionalDirectories'] = <Object?>[
        for (final item in additionalDirectories!)
          absolutePathCodec.encode(item),
      ];
    }
    if (mcpServers != null) {
      result['mcpServers'] = <Object?>[
        for (final item in mcpServers!) mcpServerCodec.encode(item),
      ];
    }
    if (replayFrom != null) {
      result['replayFrom'] = replayFromCodec.encode(replayFrom!);
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
  ResumeSessionResponse({List<SessionConfigOption>? configOptions, this.meta})
    : configOptions = configOptions == null
          ? null
          : List<SessionConfigOption>.unmodifiable(configOptions);

  /// Initial session configuration options.
  final List<SessionConfigOption>? configOptions;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ResumeSessionResponse> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ResumeSessionResponse(
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

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Foreground work is in progress.
final class RunningStateUpdate implements AcpJsonEncodable {
  /// Creates a RunningStateUpdate value.
  RunningStateUpdate({this.meta});

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory RunningStateUpdate.fromJson(Map<String, Object?> json) =>
      _$RunningStateUpdateFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$RunningStateUpdateToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [RunningStateUpdate].
final class RunningStateUpdateCodec implements AcpCodec<RunningStateUpdate> {
  /// Creates the codec.
  const RunningStateUpdateCodec();

  @override
  RunningStateUpdate decode(Object? value) =>
      RunningStateUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(RunningStateUpdate value) => value.toJson();
}

/// Shared codec for [RunningStateUpdate].
const RunningStateUpdateCodec runningStateUpdateCodec =
    RunningStateUpdateCodec();

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// Supplying `{}` means the agent supports the baseline session methods:
/// `session/new`, `session/list`, `session/resume`, `session/close`,
/// `session/prompt`, `session/cancel`, and `session/update`.
///
/// Agents that support sessions **MAY** support additional session methods,
/// prompt content types, and MCP transports by specifying additional
final class SessionCapabilities implements AcpJsonEncodable {
  /// Creates a SessionCapabilities value.
  SessionCapabilities({
    this.prompt,
    this.mcp,
    this.delete,
    this.additionalDirectories,
    this.meta,
  });

  /// Prompt capabilities supported by the agent in `session/prompt` requests.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise any
  /// prompt extensions beyond the baseline text and resource-link content
  /// required by `session/prompt`.
  final PromptCapabilities? prompt;

  /// MCP capabilities supported by the agent for session lifecycle requests.
  ///
  /// Optional. Omitted or `null` both mean the agent does not advertise MCP
  /// server transport support for sessions.
  final McpCapabilities? mcp;

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
  /// Agents may return `SessionInfo.additionalDirectories` to report the
  /// complete ordered additional-root list associated with a listed session.
  final SessionAdditionalDirectoriesCapabilities? additionalDirectories;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionCapabilities> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionCapabilities(
      prompt: decoder
          .optionalOnError(
            'prompt',
            (value) => promptCapabilitiesCodec.decode(value),
          )
          .valueOrNull,
      mcp: decoder
          .optionalOnError('mcp', (value) => mcpCapabilitiesCodec.decode(value))
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
    if (prompt != null) {
      result['prompt'] = promptCapabilitiesCodec.encode(prompt!);
    }
    if (mcp != null) {
      result['mcp'] = mcpCapabilitiesCodec.encode(mcp!);
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
    required this.configId,
    required this.name,
    this.description,
    this.category,
    this.meta,
  });

  /// The typed variant payload.
  final SessionConfigSelect value;

  /// Unique identifier for the configuration option.
  final SessionConfigId configId;

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'select';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(sessionConfigSelectCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['configId'] = sessionConfigIdCodec.encode(configId);
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
    required this.configId,
    required this.name,
    this.description,
    this.category,
    this.meta,
  });

  /// The typed variant payload.
  final SessionConfigBoolean value;

  /// Unique identifier for the configuration option.
  final SessionConfigId configId;

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  @override
  String get discriminator => 'boolean';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(sessionConfigBooleanCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['configId'] = sessionConfigIdCodec.encode(configId);
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

/// An unknown future or `_`-prefixed [SessionConfigOption] variant.
final class SessionConfigOptionCustom extends SessionConfigOption {
  /// Creates a raw-preserving custom variant.
  SessionConfigOptionCustom({
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
          configId: decoder.required(
            'configId',
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
          configId: decoder.required(
            'configId',
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
        final decoder = AcpResilientDecoder(payload);
        decoder.required(
          'configId',
          (value) => sessionConfigIdCodec.decode(value),
        );
        decoder.required('name', (value) => decodeAcpString(value));
        return SessionConfigOptionCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
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
    required this.groupId,
    required this.name,
    required List<SessionConfigSelectOption> options,
    this.meta,
  }) : options = List<SessionConfigSelectOption>.unmodifiable(options);

  /// Unique identifier for this group.
  final SessionConfigGroupId groupId;

  /// Human-readable label for this group.
  final String name;

  /// The set of option values in this group.
  final List<SessionConfigSelectOption> options;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionConfigSelectGroup> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionConfigSelectGroup(
      groupId: decoder.required(
        'groupId',
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
    result['groupId'] = sessionConfigGroupIdCodec.encode(groupId);
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// See protocol docs: [Session ID](https://agentclientprotocol.com/protocol/v2/session-setup#session-id)
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
    List<AbsolutePath>? additionalDirectories,
    this.title,
    this.updatedAt,
    this.meta,
  }) : additionalDirectories = additionalDirectories == null
           ? null
           : List<AbsolutePath>.unmodifiable(additionalDirectories);

  /// Unique identifier for the session
  final SessionId sessionId;

  /// The working directory for this session. Must be an absolute path.
  final AbsolutePath cwd;

  /// Additional workspace roots reported for this session. Each path must be absolute.
  ///
  /// When present, this is the complete ordered additional-root list reported
  /// by the Agent. Omitted and empty values are equivalent: the response
  /// reports no additional roots.
  final List<AbsolutePath>? additionalDirectories;

  /// Human-readable title for the session
  final String? title;

  /// RFC 3339 timestamp of last activity.
  final AcpDateTimeString? updatedAt;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionInfo> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionInfo(
      sessionId: decoder.required(
        'sessionId',
        (value) => sessionIdCodec.decode(value),
      ),
      cwd: decoder.required('cwd', (value) => absolutePathCodec.decode(value)),
      additionalDirectories: decoder.listSkippingInvalid(
        'additionalDirectories',
        (value) => absolutePathCodec.decode(value),
        isRequired: false,
      ),
      title: decoder
          .optionalOnError('title', (value) => decodeAcpString(value))
          .valueOrNull,
      updatedAt: decoder
          .optionalOnError('updatedAt', (value) => decodeAcpDateTime(value))
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
    result['cwd'] = absolutePathCodec.encode(cwd);
    if (additionalDirectories != null) {
      result['additionalDirectories'] = <Object?>[
        for (final item in additionalDirectories!)
          absolutePathCodec.encode(item),
      ];
    }
    if (title != null) {
      result['title'] = title!;
    }
    if (updatedAt != null) {
      result['updatedAt'] = updatedAt!.value;
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
///
/// Omitted fields leave the existing session info unchanged. `null` clears the
/// corresponding value.
final class SessionInfoUpdate implements AcpJsonEncodable {
  /// Creates a SessionInfoUpdate value.
  SessionInfoUpdate({
    this.title = const AcpPatch<String>.unchanged(),
    this.updatedAt = const AcpPatch<AcpDateTimeString>.unchanged(),
    this.meta,
  });

  /// Human-readable title for the session. Set to null to clear.
  final AcpPatch<String> title;

  /// RFC 3339 timestamp of last activity. Set to null to clear.
  final AcpPatch<AcpDateTimeString> updatedAt;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Omitted means no metadata update; `null` is an
  /// explicit clear signal. Implementations MUST NOT make assumptions about values at these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<SessionInfoUpdate> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = SessionInfoUpdate(
      title: decoder.patch('title', (value) => decodeAcpString(value)),
      updatedAt: decoder.patch(
        'updatedAt',
        (value) => decodeAcpDateTime(value),
      ),
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
    updatedAt.writeTo(result, 'updatedAt', (value) => value.value);
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

/// An opaque cursor used to paginate `session/list` results.
final class SessionListCursor implements AcpJsonEncodable {
  /// Validates and creates a SessionListCursor value.
  factory SessionListCursor(String value) {
    return SessionListCursor._(value);
  }

  const SessionListCursor._(this.value);

  /// The exact wire string.
  final String value;

  /// Decodes a wire string.
  factory SessionListCursor.fromJson(Object? json) =>
      SessionListCursor(decodeAcpString(json));

  /// Encodes the wire string.
  String toJson() => value;

  @override
  AcpJsonString toAcpJson() => AcpJsonString(value);

  @override
  bool operator ==(Object other) =>
      other is SessionListCursor && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Codec for [SessionListCursor].
final class SessionListCursorCodec implements AcpCodec<SessionListCursor> {
  /// Creates the codec.
  const SessionListCursorCodec();

  @override
  SessionListCursor decode(Object? value) => SessionListCursor.fromJson(value);

  @override
  String encode(SessionListCursor value) => value.toJson();
}

/// Shared codec for [SessionListCursor].
const SessionListCursorCodec sessionListCursorCodec = SessionListCursorCodec();

/// Different types of updates that can be sent while a session exists.
///
/// These updates report messages, progress, and other session activity.
///
/// See protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#3-agent-reports-output)
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

/// A user message has been created or updated.
///
/// Agents can send this when they accept or replay a user message. When a
/// client receives another `user_message` update with the same `messageId`,
/// fields in the new update patch the previous fields for that message.
final class SessionUpdateUserMessage extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateUserMessage(this.value);

  /// The typed variant payload.
  final UserMessage value;

  @override
  String get discriminator => 'user_message';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(userMessageCodec.encode(value));
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

/// An agent message has been created or updated.
///
/// Agents can send this in addition to streamed chunks. When a client
/// receives another `agent_message` update with the same `messageId`,
/// fields in the new update patch the previous fields for that message.
final class SessionUpdateAgentMessage extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateAgentMessage(this.value);

  /// The typed variant payload.
  final AgentMessage value;

  @override
  String get discriminator => 'agent_message';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(agentMessageCodec.encode(value));
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

/// An agent thought or reasoning message has been created or updated.
///
/// Agents can send this in addition to streamed chunks. When a client
/// receives another `agent_thought` update with the same `messageId`,
/// fields in the new update patch the previous fields for that message.
final class SessionUpdateAgentThought extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateAgentThought(this.value);

  /// The typed variant payload.
  final AgentThought value;

  @override
  String get discriminator => 'agent_thought';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(agentThoughtCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// The state of the agent's foreground work has changed.
final class SessionUpdateStateUpdate extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateStateUpdate(this.value);

  /// The typed variant payload.
  final StateUpdate value;

  @override
  String get discriminator => 'state_update';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(stateUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A chunk of tool-call content being streamed.
final class SessionUpdateToolCallContentChunk extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateToolCallContentChunk(this.value);

  /// The typed variant payload.
  final ToolCallContentChunk value;

  @override
  String get discriminator => 'tool_call_content_chunk';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(toolCallContentChunkCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A tool call has been created or updated.
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

/// An agent-owned terminal has been created or updated.
final class SessionUpdateTerminalUpdate extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateTerminalUpdate(this.value);

  /// The typed variant payload.
  final TerminalUpdate value;

  @override
  String get discriminator => 'terminal_update';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(terminalUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A chunk of bytes appended to an agent-owned terminal's output.
final class SessionUpdateTerminalOutputChunk extends SessionUpdate {
  /// Creates this known tagged-union variant.
  const SessionUpdateTerminalOutputChunk(this.value);

  /// The typed variant payload.
  final TerminalOutputChunk value;

  @override
  String get discriminator => 'terminal_output_chunk';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(terminalOutputChunkCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['sessionUpdate'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A content update for a plan identified by ID.
/// See protocol docs: [Agent Plan](https://agentclientprotocol.com/protocol/v2/agent-plan)
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

/// An unknown future or `_`-prefixed [SessionUpdate] variant.
final class SessionUpdateCustom extends SessionUpdate {
  /// Creates a raw-preserving custom variant.
  SessionUpdateCustom({
    required this.discriminator,
    required AcpJsonObject payload,
  }) : payload = payload.without('__proto__');

  @override
  final String discriminator;

  /// Opaque extension fields.
  final AcpJsonObject payload;

  @override
  AcpJsonObject toAcpJson() =>
      payload.withValue('sessionUpdate', AcpJsonString(discriminator));
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
      case 'user_message':
        return SessionUpdateUserMessage(userMessageCodec.decode(payload));
      case 'agent_message_chunk':
        return SessionUpdateAgentMessageChunk(
          contentChunkCodec.decode(payload),
        );
      case 'agent_message':
        return SessionUpdateAgentMessage(agentMessageCodec.decode(payload));
      case 'agent_thought_chunk':
        return SessionUpdateAgentThoughtChunk(
          contentChunkCodec.decode(payload),
        );
      case 'agent_thought':
        return SessionUpdateAgentThought(agentThoughtCodec.decode(payload));
      case 'state_update':
        return SessionUpdateStateUpdate(stateUpdateCodec.decode(payload));
      case 'tool_call_content_chunk':
        return SessionUpdateToolCallContentChunk(
          toolCallContentChunkCodec.decode(payload),
        );
      case 'tool_call_update':
        return SessionUpdateToolCallUpdate(toolCallUpdateCodec.decode(payload));
      case 'terminal_update':
        return SessionUpdateTerminalUpdate(terminalUpdateCodec.decode(payload));
      case 'terminal_output_chunk':
        return SessionUpdateTerminalOutputChunk(
          terminalOutputChunkCodec.decode(payload),
        );
      case 'plan_update':
        return SessionUpdatePlanUpdate(planUpdateCodec.decode(payload));
      case 'available_commands_update':
        return SessionUpdateAvailableCommandsUpdate(
          availableCommandsUpdateCodec.decode(payload),
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
        return SessionUpdateCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(SessionUpdate value) => value.toJson();
}

/// Shared codec for [SessionUpdate].
const SessionUpdateCodec sessionUpdateCodec = SessionUpdateCodec();

/// Request parameters for setting a session configuration option.
sealed class SetSessionConfigOptionRequest implements AcpJsonEncodable {
  const SetSessionConfigOptionRequest();

  /// Decodes the tagged union.
  factory SetSessionConfigOptionRequest.fromJson(Object? json) =>
      setSessionConfigOptionRequestCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// A `SessionConfigValueId` string value (`type: "id"`).
final class SetSessionConfigOptionRequestId
    extends SetSessionConfigOptionRequest {
  /// Creates this known tagged-union variant.
  /// Creates a SetSessionConfigOptionRequestId value.
  SetSessionConfigOptionRequestId({
    required this.sessionId,
    required this.configId,
    required this.value,
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// The value ID.
  final SessionConfigValueId value;

  @override
  String get discriminator => 'id';

  @override
  AcpJsonObject toAcpJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['configId'] = sessionConfigIdCodec.encode(configId);
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['value'] = sessionConfigValueIdCodec.encode(value);
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// A boolean value (`type: "boolean"`).
final class SetSessionConfigOptionRequestBoolean
    extends SetSessionConfigOptionRequest {
  /// Creates this known tagged-union variant.
  /// Creates a SetSessionConfigOptionRequestBoolean value.
  SetSessionConfigOptionRequestBoolean({
    required this.sessionId,
    required this.configId,
    required this.value,
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// The boolean value.
  final bool value;

  @override
  String get discriminator => 'boolean';

  @override
  AcpJsonObject toAcpJson() {
    final result = <String, Object?>{};
    result['sessionId'] = sessionIdCodec.encode(sessionId);
    result['configId'] = sessionConfigIdCodec.encode(configId);
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    result['value'] = value;
    result['type'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [SetSessionConfigOptionRequest] variant.
final class SetSessionConfigOptionRequestCustom
    extends SetSessionConfigOptionRequest {
  /// Creates a raw-preserving custom variant.
  SetSessionConfigOptionRequestCustom({
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

/// Codec for [SetSessionConfigOptionRequest].
final class SetSessionConfigOptionRequestCodec
    implements AcpCodec<SetSessionConfigOptionRequest> {
  /// Creates the codec.
  const SetSessionConfigOptionRequestCodec();

  @override
  SetSessionConfigOptionRequest decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['type']);
    switch (tag) {
      case 'id':
        final decoder = AcpResilientDecoder(payload);
        return SetSessionConfigOptionRequestId(
          sessionId: decoder.required(
            'sessionId',
            (value) => sessionIdCodec.decode(value),
          ),
          configId: decoder.required(
            'configId',
            (value) => sessionConfigIdCodec.decode(value),
          ),
          meta: decoder.meta(),
          value: decoder.required(
            'value',
            (value) => sessionConfigValueIdCodec.decode(value),
          ),
        );
      case 'boolean':
        final decoder = AcpResilientDecoder(payload);
        return SetSessionConfigOptionRequestBoolean(
          sessionId: decoder.required(
            'sessionId',
            (value) => sessionIdCodec.decode(value),
          ),
          configId: decoder.required(
            'configId',
            (value) => sessionConfigIdCodec.decode(value),
          ),
          meta: decoder.meta(),
          value: decoder.required('value', (value) => decodeAcpBoolean(value)),
        );
      default:
        final decoder = AcpResilientDecoder(payload);
        decoder.required('sessionId', (value) => sessionIdCodec.decode(value));
        decoder.required(
          'configId',
          (value) => sessionConfigIdCodec.decode(value),
        );
        return SetSessionConfigOptionRequestCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

/// The state of the agent's foreground work has changed.
///
/// Background activity can continue and emit other `session/update` notifications
/// while `idle`. Those notifications do not change this state.
sealed class StateUpdate implements AcpJsonEncodable {
  const StateUpdate();

  /// Decodes the tagged union.
  factory StateUpdate.fromJson(Object? json) => stateUpdateCodec.decode(json);

  /// The exact discriminator string.
  String get discriminator;

  /// Encodes the tagged union.
  Map<String, Object?> toJson() => decodeAcpObject(toAcpJson().toObject());
}

/// Foreground work is in progress.
final class StateUpdateRunning extends StateUpdate {
  /// Creates this known tagged-union variant.
  const StateUpdateRunning(this.value);

  /// The typed variant payload.
  final RunningStateUpdate value;

  @override
  String get discriminator => 'running';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(runningStateUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['state'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// The agent is ready to process a new prompt.
final class StateUpdateIdle extends StateUpdate {
  /// Creates this known tagged-union variant.
  const StateUpdateIdle(this.value);

  /// The typed variant payload.
  final IdleStateUpdate value;

  @override
  String get discriminator => 'idle';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(idleStateUpdateCodec.encode(value));
    final result = <String, Object?>{...payload};
    result['state'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// Foreground work is blocked on user action.
final class StateUpdateRequiresAction extends StateUpdate {
  /// Creates this known tagged-union variant.
  const StateUpdateRequiresAction(this.value);

  /// The typed variant payload.
  final RequiresActionStateUpdate value;

  @override
  String get discriminator => 'requires_action';

  @override
  AcpJsonObject toAcpJson() {
    final payload = decodeAcpObject(
      requiresActionStateUpdateCodec.encode(value),
    );
    final result = <String, Object?>{...payload};
    result['state'] = discriminator;
    return AcpJsonObject.fromObject(result);
  }
}

/// An unknown future or `_`-prefixed [StateUpdate] variant.
final class StateUpdateCustom extends StateUpdate {
  /// Creates a raw-preserving custom variant.
  StateUpdateCustom({
    required this.discriminator,
    required AcpJsonObject payload,
  }) : payload = payload.without('__proto__');

  @override
  final String discriminator;

  /// Opaque extension fields.
  final AcpJsonObject payload;

  @override
  AcpJsonObject toAcpJson() =>
      payload.withValue('state', AcpJsonString(discriminator));
}

/// Codec for [StateUpdate].
final class StateUpdateCodec implements AcpCodec<StateUpdate> {
  /// Creates the codec.
  const StateUpdateCodec();

  @override
  StateUpdate decode(Object? value) {
    final payload = decodeAcpObject(value);
    final tag = decodeAcpString(payload['state']);
    switch (tag) {
      case 'running':
        return StateUpdateRunning(runningStateUpdateCodec.decode(payload));
      case 'idle':
        return StateUpdateIdle(idleStateUpdateCodec.decode(payload));
      case 'requires_action':
        return StateUpdateRequiresAction(
          requiresActionStateUpdateCodec.decode(payload),
        );
      default:
        return StateUpdateCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(StateUpdate value) => value.toJson();
}

/// Shared codec for [StateUpdate].
const StateUpdateCodec stateUpdateCodec = StateUpdateCodec();

/// Reasons why an agent stops active session work.
///
/// See protocol docs: [Stop Reasons](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#stop-reasons)
final class StopReason implements AcpJsonEncodable {
  /// Validates and creates a StopReason value.
  factory StopReason(String value) {
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

  /// Allowed enum values. Must contain at least one value.
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
  /// Must contain at least one value when present.
  /// Optional. Omitted and `null` are equivalent and mean no untitled single-select choices are
  /// declared by `enum`.
  final List<String>? enumValue;

  /// Titled enum options for titled single-select enums.
  /// Must contain at least one option when present.
  /// Optional. Omitted and `null` are equivalent and mean no titled single-select choices are
  /// declared by `oneOf`.
  final List<EnumOption>? oneOf;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// Optional. Omitted and `null` are equivalent and mean no metadata.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
      pattern: decoder.optional(
        'pattern',
        (value) => decodeAcpRegexString(value),
      ),
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
/// A display-only reference to an agent-owned terminal.
///
/// Terminal state and output are delivered separately through
/// `TerminalUpdate` and `TerminalOutputChunk`.
final class Terminal implements AcpJsonEncodable {
  /// Creates a Terminal value.
  Terminal({required this.terminalId, this.meta});

  /// The ID of the terminal to display.
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
  /// these keys. This metadata is scoped to the content reference. Omitted
  /// and `null` are equivalent and mean no item metadata was provided.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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
/// Exit information for an agent-owned terminal.
///
/// The presence of this object marks the terminal as exited, even when neither
/// an exit code nor a signal is known.
final class TerminalExitStatus implements AcpJsonEncodable {
  /// Creates a TerminalExitStatus value.
  TerminalExitStatus({this.exitCode, this.signal, this.meta});

  /// Process exit code, when known. Omitted and `null` are equivalent.
  final int? exitCode;

  /// Signal that terminated the process, when known.
  ///
  /// Agents should use the conventional platform signal name. POSIX examples
  /// include `SIGTERM`, `SIGKILL`, and `SIGINT`. Other platforms may use a
  /// platform-specific name. Omitted and `null` are equivalent.
  final String? signal;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys. This metadata is scoped to the exit information. Omitted
  /// and `null` are equivalent and mean no exit metadata was provided.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

/// Unique identifier for an agent-owned terminal within a session.
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

String _decodeTerminalOutputData(Object? value) => decodeAcpString(value);
Object? _encodeTerminalOutputData(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// An authoritative replacement snapshot of terminal output bytes.
final class TerminalOutput implements AcpJsonEncodable {
  /// Creates a TerminalOutput value.
  TerminalOutput({required this.data, this.meta});

  /// Base64-encoded replacement terminal output bytes.
  @JsonKey(
    name: 'data',
    fromJson: _decodeTerminalOutputData,
    toJson: _encodeTerminalOutputData,
    includeIfNull: false,
    required: true,
  )
  final String data;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys. This metadata is scoped to the replacement snapshot. Omitted
  /// and `null` are equivalent and mean no snapshot metadata was provided.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory TerminalOutput.fromJson(Map<String, Object?> json) =>
      _$TerminalOutputFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$TerminalOutputToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TerminalOutput].
final class TerminalOutputCodec implements AcpCodec<TerminalOutput> {
  /// Creates the codec.
  const TerminalOutputCodec();

  @override
  TerminalOutput decode(Object? value) =>
      TerminalOutput.fromJson(decodeAcpObject(value));

  @override
  Object encode(TerminalOutput value) => value.toJson();
}

/// Shared codec for [TerminalOutput].
const TerminalOutputCodec terminalOutputCodec = TerminalOutputCodec();

TerminalId _decodeTerminalOutputChunkTerminalId(Object? value) =>
    terminalIdCodec.decode(value);
Object? _encodeTerminalOutputChunkTerminalId(TerminalId value) =>
    terminalIdCodec.encode(value);

String _decodeTerminalOutputChunkData(Object? value) => decodeAcpString(value);
Object? _encodeTerminalOutputChunkData(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A chunk of bytes appended to an agent-owned terminal's output.
final class TerminalOutputChunk implements AcpJsonEncodable {
  /// Creates a TerminalOutputChunk value.
  TerminalOutputChunk({
    required this.terminalId,
    required this.data,
    this.meta,
  });

  /// The terminal receiving these bytes.
  @JsonKey(
    name: 'terminalId',
    fromJson: _decodeTerminalOutputChunkTerminalId,
    toJson: _encodeTerminalOutputChunkTerminalId,
    includeIfNull: false,
    required: true,
  )
  final TerminalId terminalId;

  /// Independently base64-encoded terminal output bytes.
  @JsonKey(
    name: 'data',
    fromJson: _decodeTerminalOutputChunkData,
    toJson: _encodeTerminalOutputChunkData,
    includeIfNull: false,
    required: true,
  )
  final String data;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys. This field is chunk-scoped. Omitted and `null` are
  /// equivalent and mean no chunk metadata was provided.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory TerminalOutputChunk.fromJson(Map<String, Object?> json) =>
      _$TerminalOutputChunkFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$TerminalOutputChunkToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TerminalOutputChunk].
final class TerminalOutputChunkCodec implements AcpCodec<TerminalOutputChunk> {
  /// Creates the codec.
  const TerminalOutputChunkCodec();

  @override
  TerminalOutputChunk decode(Object? value) =>
      TerminalOutputChunk.fromJson(decodeAcpObject(value));

  @override
  Object encode(TerminalOutputChunk value) => value.toJson();
}

/// Shared codec for [TerminalOutputChunk].
const TerminalOutputChunkCodec terminalOutputChunkCodec =
    TerminalOutputChunkCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// An upsert for the stored state of an agent-owned terminal.
///
/// Only `TerminalUpdate::terminal_id` is required. Other fields have patch
/// semantics: omitted fields leave the stored value unchanged, `null` clears
/// it, and concrete values replace it. When the terminal ID is new, omitted
/// fields start unknown.
final class TerminalUpdate implements AcpJsonEncodable {
  /// Creates a TerminalUpdate value.
  TerminalUpdate({
    required this.terminalId,
    this.command = const AcpPatch<String>.unchanged(),
    this.cwd = const AcpPatch<AbsolutePath>.unchanged(),
    this.output = const AcpPatch<TerminalOutput>.unchanged(),
    this.exitStatus = const AcpPatch<TerminalExitStatus>.unchanged(),
    this.meta,
  });

  /// Unique identifier for this terminal within the session.
  final TerminalId terminalId;

  /// The command being run.
  final AcpPatch<String> command;

  /// The absolute working directory of the command.
  final AcpPatch<AbsolutePath> cwd;

  /// An authoritative replacement snapshot of terminal output bytes.
  final AcpPatch<TerminalOutput> output;

  /// Exit information. A concrete object marks the terminal as exited.
  final AcpPatch<TerminalExitStatus> exitStatus;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Omitted means no metadata update; `null` is an
  /// explicit clear signal. Implementations MUST NOT make assumptions about values at these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<TerminalUpdate> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = TerminalUpdate(
      terminalId: decoder.required(
        'terminalId',
        (value) => terminalIdCodec.decode(value),
      ),
      command: decoder.patch('command', (value) => decodeAcpString(value)),
      cwd: decoder.patch('cwd', (value) => absolutePathCodec.decode(value)),
      output: decoder.patch(
        'output',
        (value) => terminalOutputCodec.decode(value),
      ),
      exitStatus: decoder.patch(
        'exitStatus',
        (value) => terminalExitStatusCodec.decode(value),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory TerminalUpdate.fromJson(Map<String, Object?> json) =>
      decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['terminalId'] = terminalIdCodec.encode(terminalId);
    command.writeTo(result, 'command', (value) => value);
    cwd.writeTo(result, 'cwd', (value) => absolutePathCodec.encode(value));
    output.writeTo(
      result,
      'output',
      (value) => terminalOutputCodec.encode(value),
    );
    exitStatus.writeTo(
      result,
      'exitStatus',
      (value) => terminalExitStatusCodec.encode(value),
    );
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TerminalUpdate].
final class TerminalUpdateCodec implements AcpCodec<TerminalUpdate> {
  /// Creates the codec.
  const TerminalUpdateCodec();

  @override
  TerminalUpdate decode(Object? value) =>
      TerminalUpdate.fromJson(decodeAcpObject(value));

  @override
  Object encode(TerminalUpdate value) => value.toJson();
}

/// Shared codec for [TerminalUpdate].
const TerminalUpdateCodec terminalUpdateCodec = TerminalUpdateCodec();

String _decodeTextCommandInputHint(Object? value) => decodeAcpString(value);
Object? _encodeTextCommandInputHint(String value) => value;

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// All text that was typed after the command name is provided as input.
final class TextCommandInput implements AcpJsonEncodable {
  /// Creates a TextCommandInput value.
  TextCommandInput({required this.hint, this.meta});

  /// A hint to display when the input hasn't been provided yet
  @JsonKey(
    name: 'hint',
    fromJson: _decodeTextCommandInputHint,
    toJson: _encodeTextCommandInputHint,
    includeIfNull: false,
    required: true,
  )
  final String hint;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory TextCommandInput.fromJson(Map<String, Object?> json) =>
      _$TextCommandInputFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$TextCommandInputToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [TextCommandInput].
final class TextCommandInputCodec implements AcpCodec<TextCommandInput> {
  /// Creates the codec.
  const TextCommandInputCodec();

  @override
  TextCommandInput decode(Object? value) =>
      TextCommandInput.fromJson(decodeAcpObject(value));

  @override
  Object encode(TextCommandInput value) => value.toJson();
}

/// Shared codec for [TextCommandInput].
const TextCommandInputCodec textCommandInputCodec = TextCommandInputCodec();

@JsonSerializable(createFactory: false, createToJson: false)
/// Text provided to or from an LLM.
final class TextContent implements AcpJsonEncodable {
  /// Creates a TextContent value.
  TextContent({required this.text, this.annotations, this.meta});

  /// Text payload carried by this content block.
  final String text;

  /// Optional annotations that help clients decide how to display or route this content.
  final Annotations? annotations;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<TextContent> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = TextContent(
      text: decoder.required('text', (value) => decodeAcpString(value)),
      annotations: decoder
          .optionalOnError(
            'annotations',
            (value) => annotationsCodec.decode(value),
          )
          .valueOrNull,
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory TextContent.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['text'] = text;
    if (annotations != null) {
      result['annotations'] = annotationsCodec.encode(annotations!);
    }
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

  /// Text payload carried by this content block.
  final String text;

  /// URI associated with this resource or media payload.
  final Uri uri;

  /// MIME type describing the encoded media payload.
  final MediaType? mimeType;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<TextResourceContents> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = TextResourceContents(
      text: decoder.required('text', (value) => decodeAcpString(value)),
      uri: decoder.required('uri', (value) => decodeAcpUri(value)),
      mimeType: decoder
          .optionalOnError('mimeType', (value) => mediaTypeCodec.decode(value))
          .valueOrNull,
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
    result['text'] = text;
    result['uri'] = uri.toString();
    if (mimeType != null) {
      result['mimeType'] = mediaTypeCodec.encode(mimeType!);
    }
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

  /// Titled enum options. Must contain at least one option.
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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

/// Content produced by a tool call.
///
/// Tool calls can produce different types of content including standard
/// content blocks (text, images), file diffs, or display-only terminals.
///
/// See protocol docs: [Content](https://agentclientprotocol.com/protocol/v2/tool-calls#content)
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

/// A display-only reference to an agent-owned terminal.
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

/// An unknown future or `_`-prefixed [ToolCallContent] variant.
final class ToolCallContentCustom extends ToolCallContent {
  /// Creates a raw-preserving custom variant.
  ToolCallContentCustom({
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
        return ToolCallContentCustom(
          discriminator: tag,
          payload: AcpJsonObject.fromObject(payload),
        );
    }
  }

  @override
  Object encode(ToolCallContent value) => value.toJson();
}

/// Shared codec for [ToolCallContent].
const ToolCallContentCodec toolCallContentCodec = ToolCallContentCodec();

ToolCallId _decodeToolCallContentChunkToolCallId(Object? value) =>
    toolCallIdCodec.decode(value);
Object? _encodeToolCallContentChunkToolCallId(ToolCallId value) =>
    toolCallIdCodec.encode(value);

ToolCallContent _decodeToolCallContentChunkContent(Object? value) =>
    toolCallContentCodec.decode(value);
Object? _encodeToolCallContentChunkContent(ToolCallContent value) =>
    toolCallContentCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// A streamed item of tool-call content.
///
/// Tool-call content chunks append one `ToolCallContent` item to the current
/// content for the matching `ToolCallId`. Agents can use
/// `ToolCallUpdate::content` when they need to replace the whole content
/// collection instead.
final class ToolCallContentChunk implements AcpJsonEncodable {
  /// Creates a ToolCallContentChunk value.
  ToolCallContentChunk({
    required this.toolCallId,
    required this.content,
    this.meta,
  });

  /// The ID of the tool call this content belongs to.
  @JsonKey(
    name: 'toolCallId',
    fromJson: _decodeToolCallContentChunkToolCallId,
    toJson: _encodeToolCallContentChunkToolCallId,
    includeIfNull: false,
    required: true,
  )
  final ToolCallId toolCallId;

  /// A single item of content produced by the tool call.
  @JsonKey(
    name: 'content',
    fromJson: _decodeToolCallContentChunkContent,
    toJson: _encodeToolCallContentChunkContent,
    includeIfNull: false,
    required: true,
  )
  final ToolCallContent content;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys. This field is chunk-scoped.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory ToolCallContentChunk.fromJson(Map<String, Object?> json) =>
      _$ToolCallContentChunkFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ToolCallContentChunkToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ToolCallContentChunk].
final class ToolCallContentChunkCodec
    implements AcpCodec<ToolCallContentChunk> {
  /// Creates the codec.
  const ToolCallContentChunkCodec();

  @override
  ToolCallContentChunk decode(Object? value) =>
      ToolCallContentChunk.fromJson(decodeAcpObject(value));

  @override
  Object encode(ToolCallContentChunk value) => value.toJson();
}

/// Shared codec for [ToolCallContentChunk].
const ToolCallContentChunkCodec toolCallContentChunkCodec =
    ToolCallContentChunkCodec();

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
/// See protocol docs: [Following the Agent](https://agentclientprotocol.com/protocol/v2/tool-calls#following-the-agent)
final class ToolCallLocation implements AcpJsonEncodable {
  /// Creates a ToolCallLocation value.
  ToolCallLocation({required this.path, this.line, this.meta});

  /// The absolute file path being accessed or modified.
  final AbsolutePath path;

  /// Optional line number within the file.
  final int? line;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ToolCallLocation> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ToolCallLocation(
      path: decoder.required(
        'path',
        (value) => absolutePathCodec.decode(value),
      ),
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
    result['path'] = absolutePathCodec.encode(path);
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

ToolCallUpdate _decodeToolCallPermissionSubjectToolCall(Object? value) =>
    toolCallUpdateCodec.decode(value);
Object? _encodeToolCallPermissionSubjectToolCall(ToolCallUpdate value) =>
    toolCallUpdateCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Permission request details for a tool call.
final class ToolCallPermissionSubject implements AcpJsonEncodable {
  /// Creates a ToolCallPermissionSubject value.
  ToolCallPermissionSubject({required this.toolCall});

  /// Details about the tool call requiring permission.
  @JsonKey(
    name: 'toolCall',
    fromJson: _decodeToolCallPermissionSubjectToolCall,
    toJson: _encodeToolCallPermissionSubjectToolCall,
    includeIfNull: false,
    required: true,
  )
  final ToolCallUpdate toolCall;

  /// Decodes a schema-validated JSON object.
  factory ToolCallPermissionSubject.fromJson(Map<String, Object?> json) =>
      _$ToolCallPermissionSubjectFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$ToolCallPermissionSubjectToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [ToolCallPermissionSubject].
final class ToolCallPermissionSubjectCodec
    implements AcpCodec<ToolCallPermissionSubject> {
  /// Creates the codec.
  const ToolCallPermissionSubjectCodec();

  @override
  ToolCallPermissionSubject decode(Object? value) =>
      ToolCallPermissionSubject.fromJson(decodeAcpObject(value));

  @override
  Object encode(ToolCallPermissionSubject value) => value.toJson();
}

/// Shared codec for [ToolCallPermissionSubject].
const ToolCallPermissionSubjectCodec toolCallPermissionSubjectCodec =
    ToolCallPermissionSubjectCodec();

/// Execution status of a tool call.
///
/// Tool calls progress through different statuses during their lifecycle.
///
/// See protocol docs: [Status](https://agentclientprotocol.com/protocol/v2/tool-calls#status)
final class ToolCallStatus implements AcpJsonEncodable {
  /// Validates and creates a ToolCallStatus value.
  factory ToolCallStatus(String value) {
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

  /// The `cancelled` schema value.
  static const ToolCallStatus cancelled = ToolCallStatus._('cancelled');

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
/// Represents an upsert for a tool call that the language model has requested.
///
/// Tool calls are actions that the agent executes on behalf of the language model,
/// such as reading files, executing code, or fetching data from external sources.
///
/// Only `ToolCallUpdate::tool_call_id` is required. Other fields have patch semantics:
/// omitted fields leave the existing tool call value unchanged, `null` clears or
/// unsets the value, and concrete values replace the previous value. For
final class ToolCallUpdate implements AcpJsonEncodable {
  /// Creates a ToolCallUpdate value.
  ToolCallUpdate({
    required this.toolCallId,
    this.title = const AcpPatch<String>.unchanged(),
    this.kind = const AcpPatch<ToolKind>.unchanged(),
    this.status = const AcpPatch<ToolCallStatus>.unchanged(),
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

  /// Unique identifier for this tool call within the session.
  final ToolCallId toolCallId;

  /// Human-readable title describing what the tool is doing.
  final AcpPatch<String> title;

  /// The category of tool being invoked.
  /// Helps clients choose appropriate icons and UI treatment.
  final AcpPatch<ToolKind> kind;

  /// Current execution status of the tool call.
  final AcpPatch<ToolCallStatus> status;

  /// Content produced by the tool call.
  final AcpPatch<List<ToolCallContent>> content;

  /// File locations affected by this tool call.
  /// Enables "follow-along" features in clients.
  final AcpPatch<List<ToolCallLocation>> locations;

  /// Raw input parameters sent to the tool.
  final AcpPatch<AcpJsonValue> rawInput;

  /// Raw output returned by the tool.
  final AcpPatch<AcpJsonValue> rawOutput;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Omitted means no metadata update; `null` is an
  /// explicit clear signal. Implementations MUST NOT make assumptions about values at these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<ToolCallUpdate> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = ToolCallUpdate(
      toolCallId: decoder.required(
        'toolCallId',
        (value) => toolCallIdCodec.decode(value),
      ),
      title: decoder.patch('title', (value) => decodeAcpString(value)),
      kind: decoder.patch('kind', (value) => toolKindCodec.decode(value)),
      status: decoder.patch(
        'status',
        (value) => toolCallStatusCodec.decode(value),
      ),
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
    title.writeTo(result, 'title', (value) => value);
    kind.writeTo(result, 'kind', (value) => toolKindCodec.encode(value));
    status.writeTo(
      result,
      'status',
      (value) => toolCallStatusCodec.encode(value),
    );
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
/// See protocol docs: [Creating](https://agentclientprotocol.com/protocol/v2/tool-calls#creating)
final class ToolKind implements AcpJsonEncodable {
  /// Validates and creates a ToolKind value.
  factory ToolKind(String value) {
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

SessionId _decodeUpdateSessionNotificationSessionId(Object? value) =>
    sessionIdCodec.decode(value);
Object? _encodeUpdateSessionNotificationSessionId(SessionId value) =>
    sessionIdCodec.encode(value);

SessionUpdate _decodeUpdateSessionNotificationUpdate(Object? value) =>
    sessionUpdateCodec.decode(value);
Object? _encodeUpdateSessionNotificationUpdate(SessionUpdate value) =>
    sessionUpdateCodec.encode(value);

@JsonSerializable(checked: true, explicitToJson: true, includeIfNull: false)
/// Notification containing a session update from the agent.
///
/// Agents can send session updates at any point while the session exists.
///
/// See protocol docs: [Agent Reports Output](https://agentclientprotocol.com/protocol/v2/prompt-lifecycle#3-agent-reports-output)
final class UpdateSessionNotification implements AcpJsonEncodable {
  /// Creates a UpdateSessionNotification value.
  UpdateSessionNotification({
    required this.sessionId,
    required this.update,
    this.meta,
  });

  /// The ID of the session this update pertains to.
  @JsonKey(
    name: 'sessionId',
    fromJson: _decodeUpdateSessionNotificationSessionId,
    toJson: _encodeUpdateSessionNotificationSessionId,
    includeIfNull: false,
    required: true,
  )
  final SessionId sessionId;

  /// The actual update content.
  @JsonKey(
    name: 'update',
    fromJson: _decodeUpdateSessionNotificationUpdate,
    toJson: _encodeUpdateSessionNotificationUpdate,
    includeIfNull: false,
    required: true,
  )
  final SessionUpdate update;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  @JsonKey(name: '_meta')
  @AcpMetaConverter()
  final AcpJsonObject? meta;

  /// Decodes a schema-validated JSON object.
  factory UpdateSessionNotification.fromJson(Map<String, Object?> json) =>
      _$UpdateSessionNotificationFromJson(json);

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() => _$UpdateSessionNotificationToJson(this);

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [UpdateSessionNotification].
final class UpdateSessionNotificationCodec
    implements AcpCodec<UpdateSessionNotification> {
  /// Creates the codec.
  const UpdateSessionNotificationCodec();

  @override
  UpdateSessionNotification decode(Object? value) =>
      UpdateSessionNotification.fromJson(decodeAcpObject(value));

  @override
  Object encode(UpdateSessionNotification value) => value.toJson();
}

/// Shared codec for [UpdateSessionNotification].
const UpdateSessionNotificationCodec updateSessionNotificationCodec =
    UpdateSessionNotificationCodec();

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
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
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

@JsonSerializable(createFactory: false, createToJson: false)
/// A user message upsert.
///
/// Only `UserMessage::message_id` is required. `content` has patch semantics:
/// an omitted field leaves existing message content unchanged, `null` clears the
/// value, and a concrete array replaces the previous value. For a new
/// `messageId`, omitted fields use client defaults. `content` is replaced as a
/// whole array; send `[]` or `null` to clear it.
///
final class UserMessage implements AcpJsonEncodable {
  /// Creates a UserMessage value.
  UserMessage({
    required this.messageId,
    AcpPatch<List<ContentBlock>> content =
        const AcpPatch<List<ContentBlock>>.unchanged(),
    this.meta,
  }) : content = content.map((value) => List<ContentBlock>.unmodifiable(value));

  /// A unique identifier for the message.
  final MessageId messageId;

  /// Complete replacement content for this message.
  final AcpPatch<List<ContentBlock>> content;

  /// The _meta property is reserved by ACP to allow clients and agents to attach additional
  /// metadata to their interactions. Implementations MUST NOT make assumptions about values at
  /// these keys. Omitted means no metadata update; `null` is an explicit clear signal.
  ///
  /// See protocol docs: [Extensibility](https://agentclientprotocol.com/protocol/v2/extensibility)
  final AcpJsonObject? meta;

  /// Decodes this model and reports recoverable issues.
  static AcpDecoded<UserMessage> decode(Object? json) {
    final decoder = AcpResilientDecoder(decodeAcpObject(json));
    final value = UserMessage(
      messageId: decoder.required(
        'messageId',
        (value) => messageIdCodec.decode(value),
      ),
      content: decoder.patch(
        'content',
        (value) => List<ContentBlock>.unmodifiable(
          (value as List<Object?>).map(
            (item) => contentBlockCodec.decode(item),
          ),
        ),
      ),
      meta: decoder.meta(),
    );
    return decoder.finish(value);
  }

  /// Decodes a JSON object, discarding recoverable issues.
  factory UserMessage.fromJson(Map<String, Object?> json) => decode(json).value;

  /// Encodes this value to its wire object.
  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    result['messageId'] = messageIdCodec.encode(messageId);
    content.writeTo(
      result,
      'content',
      (value) => <Object?>[
        for (final item in value) contentBlockCodec.encode(item),
      ],
    );
    if (meta != null) {
      result['_meta'] = meta!.toObject();
    }
    return result;
  }

  @override
  AcpJsonObject toAcpJson() => AcpJsonObject.fromObject(toJson());
}

/// Codec for [UserMessage].
final class UserMessageCodec implements AcpCodec<UserMessage> {
  /// Creates the codec.
  const UserMessageCodec();

  @override
  UserMessage decode(Object? value) =>
      UserMessage.fromJson(decodeAcpObject(value));

  @override
  Object encode(UserMessage value) => value.toJson();
}

/// Shared codec for [UserMessage].
const UserMessageCodec userMessageCodec = UserMessageCodec();
