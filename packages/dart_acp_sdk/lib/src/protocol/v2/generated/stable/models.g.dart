// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentAuthCapabilities _$AgentAuthCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AgentAuthCapabilities', json, ($checkedConvert) {
  final val = AgentAuthCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$AgentAuthCapabilitiesToJson(
  AgentAuthCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

CancelRequestNotification _$CancelRequestNotificationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CancelRequestNotification', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['requestId']);
  final val = CancelRequestNotification(
    requestId: $checkedConvert(
      'requestId',
      (v) => _decodeCancelRequestNotificationRequestId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CancelRequestNotificationToJson(
  CancelRequestNotification instance,
) => <String, dynamic>{
  'requestId': _encodeCancelRequestNotificationRequestId(instance.requestId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

CancelSessionNotification _$CancelSessionNotificationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CancelSessionNotification', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId']);
  final val = CancelSessionNotification(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeCancelSessionNotificationSessionId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CancelSessionNotificationToJson(
  CancelSessionNotification instance,
) => <String, dynamic>{
  'sessionId': ?_encodeCancelSessionNotificationSessionId(instance.sessionId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

CloseSessionRequest _$CloseSessionRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CloseSessionRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sessionId']);
      final val = CloseSessionRequest(
        sessionId: $checkedConvert(
          'sessionId',
          (v) => _decodeCloseSessionRequestSessionId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CloseSessionRequestToJson(
  CloseSessionRequest instance,
) => <String, dynamic>{
  'sessionId': ?_encodeCloseSessionRequestSessionId(instance.sessionId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

CloseSessionResponse _$CloseSessionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CloseSessionResponse', json, ($checkedConvert) {
  final val = CloseSessionResponse(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CloseSessionResponseToJson(
  CloseSessionResponse instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

CompleteElicitationNotification _$CompleteElicitationNotificationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CompleteElicitationNotification', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['elicitationId']);
  final val = CompleteElicitationNotification(
    elicitationId: $checkedConvert(
      'elicitationId',
      (v) => _decodeCompleteElicitationNotificationElicitationId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CompleteElicitationNotificationToJson(
  CompleteElicitationNotification instance,
) => <String, dynamic>{
  'elicitationId': ?_encodeCompleteElicitationNotificationElicitationId(
    instance.elicitationId,
  ),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

Content _$ContentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Content', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['content']);
      final val = Content(
        content: $checkedConvert('content', (v) => _decodeContentContent(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
  'content': ?_encodeContentContent(instance.content),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

ContentChunk _$ContentChunkFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ContentChunk', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['messageId', 'content']);
  final val = ContentChunk(
    messageId: $checkedConvert(
      'messageId',
      (v) => _decodeContentChunkMessageId(v),
    ),
    content: $checkedConvert('content', (v) => _decodeContentChunkContent(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ContentChunkToJson(ContentChunk instance) =>
    <String, dynamic>{
      'messageId': ?_encodeContentChunkMessageId(instance.messageId),
      'content': ?_encodeContentChunkContent(instance.content),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

Cost _$CostFromJson(Map<String, dynamic> json) => $checkedCreate('Cost', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['amount', 'currency']);
  final val = Cost(
    amount: $checkedConvert('amount', (v) => _decodeCostAmount(v)),
    currency: $checkedConvert('currency', (v) => _decodeCostCurrency(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
  'amount': ?_encodeCostAmount(instance.amount),
  'currency': ?_encodeCostCurrency(instance.currency),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

DeleteSessionRequest _$DeleteSessionRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeleteSessionRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId']);
  final val = DeleteSessionRequest(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeDeleteSessionRequestSessionId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DeleteSessionRequestToJson(
  DeleteSessionRequest instance,
) => <String, dynamic>{
  'sessionId': ?_encodeDeleteSessionRequestSessionId(instance.sessionId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

DeleteSessionResponse _$DeleteSessionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeleteSessionResponse', json, ($checkedConvert) {
  final val = DeleteSessionResponse(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DeleteSessionResponseToJson(
  DeleteSessionResponse instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

DiffPatch _$DiffPatchFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DiffPatch', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['format', 'text']);
      final val = DiffPatch(
        format: $checkedConvert('format', (v) => _decodeDiffPatchFormat(v)),
        text: $checkedConvert('text', (v) => _decodeDiffPatchText(v)),
      );
      return val;
    });

Map<String, dynamic> _$DiffPatchToJson(DiffPatch instance) => <String, dynamic>{
  'format': ?_encodeDiffPatchFormat(instance.format),
  'text': ?_encodeDiffPatchText(instance.text),
};

DiffPathChange _$DiffPathChangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DiffPathChange', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['path']);
      final val = DiffPathChange(
        path: $checkedConvert('path', (v) => _decodeDiffPathChangePath(v)),
      );
      return val;
    });

Map<String, dynamic> _$DiffPathChangeToJson(DiffPathChange instance) =>
    <String, dynamic>{'path': ?_encodeDiffPathChangePath(instance.path)};

DiffPathPairChange _$DiffPathPairChangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DiffPathPairChange', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['oldPath', 'path']);
      final val = DiffPathPairChange(
        oldPath: $checkedConvert(
          'oldPath',
          (v) => _decodeDiffPathPairChangeOldPath(v),
        ),
        path: $checkedConvert('path', (v) => _decodeDiffPathPairChangePath(v)),
      );
      return val;
    });

Map<String, dynamic> _$DiffPathPairChangeToJson(DiffPathPairChange instance) =>
    <String, dynamic>{
      'oldPath': ?_encodeDiffPathPairChangeOldPath(instance.oldPath),
      'path': ?_encodeDiffPathPairChangePath(instance.path),
    };

ElicitationFormCapabilities _$ElicitationFormCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ElicitationFormCapabilities', json, ($checkedConvert) {
  final val = ElicitationFormCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ElicitationFormCapabilitiesToJson(
  ElicitationFormCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

ElicitationRequestScope _$ElicitationRequestScopeFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ElicitationRequestScope', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['requestId']);
  final val = ElicitationRequestScope(
    requestId: $checkedConvert(
      'requestId',
      (v) => _decodeElicitationRequestScopeRequestId(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$ElicitationRequestScopeToJson(
  ElicitationRequestScope instance,
) => <String, dynamic>{
  'requestId': _encodeElicitationRequestScopeRequestId(instance.requestId),
};

ElicitationUrlCapabilities _$ElicitationUrlCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ElicitationUrlCapabilities', json, ($checkedConvert) {
  final val = ElicitationUrlCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ElicitationUrlCapabilitiesToJson(
  ElicitationUrlCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

EnvVariable _$EnvVariableFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EnvVariable', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'value']);
      final val = EnvVariable(
        name: $checkedConvert('name', (v) => _decodeEnvVariableName(v)),
        value: $checkedConvert('value', (v) => _decodeEnvVariableValue(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$EnvVariableToJson(EnvVariable instance) =>
    <String, dynamic>{
      'name': ?_encodeEnvVariableName(instance.name),
      'value': ?_encodeEnvVariableValue(instance.value),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

HttpHeader _$HttpHeaderFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HttpHeader', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'value']);
      final val = HttpHeader(
        name: $checkedConvert('name', (v) => _decodeHttpHeaderName(v)),
        value: $checkedConvert('value', (v) => _decodeHttpHeaderValue(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$HttpHeaderToJson(HttpHeader instance) =>
    <String, dynamic>{
      'name': ?_encodeHttpHeaderName(instance.name),
      'value': ?_encodeHttpHeaderValue(instance.value),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

LoginAuthRequest _$LoginAuthRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoginAuthRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['methodId']);
      final val = LoginAuthRequest(
        methodId: $checkedConvert(
          'methodId',
          (v) => _decodeLoginAuthRequestMethodId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$LoginAuthRequestToJson(LoginAuthRequest instance) =>
    <String, dynamic>{
      'methodId': ?_encodeLoginAuthRequestMethodId(instance.methodId),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

LoginAuthResponse _$LoginAuthResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoginAuthResponse', json, ($checkedConvert) {
      final val = LoginAuthResponse(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$LoginAuthResponseToJson(LoginAuthResponse instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

LogoutAuthRequest _$LogoutAuthRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LogoutAuthRequest', json, ($checkedConvert) {
      final val = LogoutAuthRequest(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$LogoutAuthRequestToJson(LogoutAuthRequest instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

LogoutAuthResponse _$LogoutAuthResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LogoutAuthResponse', json, ($checkedConvert) {
      final val = LogoutAuthResponse(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$LogoutAuthResponseToJson(LogoutAuthResponse instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

McpHttpCapabilities _$McpHttpCapabilitiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('McpHttpCapabilities', json, ($checkedConvert) {
      final val = McpHttpCapabilities(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$McpHttpCapabilitiesToJson(
  McpHttpCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

McpServerHttp _$McpServerHttpFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('McpServerHttp', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name', 'url']);
  final val = McpServerHttp(
    name: $checkedConvert('name', (v) => _decodeMcpServerHttpName(v)),
    url: $checkedConvert('url', (v) => _decodeMcpServerHttpUrl(v)),
    headers: $checkedConvert('headers', (v) => _decodeMcpServerHttpHeaders(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$McpServerHttpToJson(McpServerHttp instance) =>
    <String, dynamic>{
      'name': ?_encodeMcpServerHttpName(instance.name),
      'url': ?_encodeMcpServerHttpUrl(instance.url),
      'headers': ?_encodeMcpServerHttpHeaders(instance.headers),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

McpServerStdio _$McpServerStdioFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('McpServerStdio', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name', 'command']);
  final val = McpServerStdio(
    name: $checkedConvert('name', (v) => _decodeMcpServerStdioName(v)),
    command: $checkedConvert('command', (v) => _decodeMcpServerStdioCommand(v)),
    args: $checkedConvert('args', (v) => _decodeMcpServerStdioArgs(v)),
    env: $checkedConvert('env', (v) => _decodeMcpServerStdioEnv(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$McpServerStdioToJson(McpServerStdio instance) =>
    <String, dynamic>{
      'name': ?_encodeMcpServerStdioName(instance.name),
      'command': ?_encodeMcpServerStdioCommand(instance.command),
      'args': ?_encodeMcpServerStdioArgs(instance.args),
      'env': ?_encodeMcpServerStdioEnv(instance.env),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

McpStdioCapabilities _$McpStdioCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('McpStdioCapabilities', json, ($checkedConvert) {
  final val = McpStdioCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$McpStdioCapabilitiesToJson(
  McpStdioCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

PermissionOption _$PermissionOptionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PermissionOption', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['optionId', 'name', 'kind']);
      final val = PermissionOption(
        optionId: $checkedConvert(
          'optionId',
          (v) => _decodePermissionOptionOptionId(v),
        ),
        name: $checkedConvert('name', (v) => _decodePermissionOptionName(v)),
        kind: $checkedConvert('kind', (v) => _decodePermissionOptionKind(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PermissionOptionToJson(PermissionOption instance) =>
    <String, dynamic>{
      'optionId': ?_encodePermissionOptionOptionId(instance.optionId),
      'name': ?_encodePermissionOptionName(instance.name),
      'kind': ?_encodePermissionOptionKind(instance.kind),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

PlanEntry _$PlanEntryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PlanEntry', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['content', 'priority', 'status']);
  final val = PlanEntry(
    content: $checkedConvert('content', (v) => _decodePlanEntryContent(v)),
    priority: $checkedConvert('priority', (v) => _decodePlanEntryPriority(v)),
    status: $checkedConvert('status', (v) => _decodePlanEntryStatus(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PlanEntryToJson(PlanEntry instance) => <String, dynamic>{
  'content': ?_encodePlanEntryContent(instance.content),
  'priority': ?_encodePlanEntryPriority(instance.priority),
  'status': ?_encodePlanEntryStatus(instance.status),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

PlanUpdate _$PlanUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlanUpdate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['plan']);
      final val = PlanUpdate(
        plan: $checkedConvert('plan', (v) => _decodePlanUpdatePlan(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PlanUpdateToJson(PlanUpdate instance) =>
    <String, dynamic>{
      'plan': ?_encodePlanUpdatePlan(instance.plan),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

PromptAudioCapabilities _$PromptAudioCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PromptAudioCapabilities', json, ($checkedConvert) {
  final val = PromptAudioCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PromptAudioCapabilitiesToJson(
  PromptAudioCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

PromptEmbeddedContextCapabilities _$PromptEmbeddedContextCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PromptEmbeddedContextCapabilities', json, (
  $checkedConvert,
) {
  final val = PromptEmbeddedContextCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PromptEmbeddedContextCapabilitiesToJson(
  PromptEmbeddedContextCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

PromptImageCapabilities _$PromptImageCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PromptImageCapabilities', json, ($checkedConvert) {
  final val = PromptImageCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PromptImageCapabilitiesToJson(
  PromptImageCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

PromptRequest _$PromptRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PromptRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sessionId', 'prompt']);
      final val = PromptRequest(
        sessionId: $checkedConvert(
          'sessionId',
          (v) => _decodePromptRequestSessionId(v),
        ),
        prompt: $checkedConvert('prompt', (v) => _decodePromptRequestPrompt(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PromptRequestToJson(PromptRequest instance) =>
    <String, dynamic>{
      'sessionId': ?_encodePromptRequestSessionId(instance.sessionId),
      'prompt': ?_encodePromptRequestPrompt(instance.prompt),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

PromptResponse _$PromptResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PromptResponse', json, ($checkedConvert) {
      final val = PromptResponse(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PromptResponseToJson(PromptResponse instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

ReplayFromStart _$ReplayFromStartFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReplayFromStart', json, ($checkedConvert) {
      final val = ReplayFromStart(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ReplayFromStartToJson(ReplayFromStart instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

RequestPermissionResponse _$RequestPermissionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RequestPermissionResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['outcome']);
  final val = RequestPermissionResponse(
    outcome: $checkedConvert(
      'outcome',
      (v) => _decodeRequestPermissionResponseOutcome(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$RequestPermissionResponseToJson(
  RequestPermissionResponse instance,
) => <String, dynamic>{
  'outcome': ?_encodeRequestPermissionResponseOutcome(instance.outcome),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

RequiresActionStateUpdate _$RequiresActionStateUpdateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RequiresActionStateUpdate', json, ($checkedConvert) {
  final val = RequiresActionStateUpdate(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$RequiresActionStateUpdateToJson(
  RequiresActionStateUpdate instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

RunningStateUpdate _$RunningStateUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RunningStateUpdate', json, ($checkedConvert) {
      final val = RunningStateUpdate(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$RunningStateUpdateToJson(RunningStateUpdate instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

SelectedPermissionOutcome _$SelectedPermissionOutcomeFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SelectedPermissionOutcome', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['optionId']);
  final val = SelectedPermissionOutcome(
    optionId: $checkedConvert(
      'optionId',
      (v) => _decodeSelectedPermissionOutcomeOptionId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SelectedPermissionOutcomeToJson(
  SelectedPermissionOutcome instance,
) => <String, dynamic>{
  'optionId': ?_encodeSelectedPermissionOutcomeOptionId(instance.optionId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

SessionAdditionalDirectoriesCapabilities
_$SessionAdditionalDirectoriesCapabilitiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SessionAdditionalDirectoriesCapabilities',
      json,
      ($checkedConvert) {
        final val = SessionAdditionalDirectoriesCapabilities(
          meta: $checkedConvert(
            '_meta',
            (v) => const AcpMetaConverter().fromJson(v),
          ),
        );
        return val;
      },
      fieldKeyMap: const {'meta': '_meta'},
    );

Map<String, dynamic> _$SessionAdditionalDirectoriesCapabilitiesToJson(
  SessionAdditionalDirectoriesCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

SessionConfigBoolean _$SessionConfigBooleanFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SessionConfigBoolean', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['currentValue']);
  final val = SessionConfigBoolean(
    currentValue: $checkedConvert(
      'currentValue',
      (v) => _decodeSessionConfigBooleanCurrentValue(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$SessionConfigBooleanToJson(
  SessionConfigBoolean instance,
) => <String, dynamic>{
  'currentValue': ?_encodeSessionConfigBooleanCurrentValue(
    instance.currentValue,
  ),
};

SessionConfigSelect _$SessionConfigSelectFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SessionConfigSelect', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['currentValue', 'options']);
      final val = SessionConfigSelect(
        currentValue: $checkedConvert(
          'currentValue',
          (v) => _decodeSessionConfigSelectCurrentValue(v),
        ),
        options: $checkedConvert(
          'options',
          (v) => _decodeSessionConfigSelectOptions(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SessionConfigSelectToJson(
  SessionConfigSelect instance,
) => <String, dynamic>{
  'currentValue': ?_encodeSessionConfigSelectCurrentValue(
    instance.currentValue,
  ),
  'options': ?_encodeSessionConfigSelectOptions(instance.options),
};

SessionDeleteCapabilities _$SessionDeleteCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SessionDeleteCapabilities', json, ($checkedConvert) {
  final val = SessionDeleteCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SessionDeleteCapabilitiesToJson(
  SessionDeleteCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

StringMultiSelectItems _$StringMultiSelectItemsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'StringMultiSelectItems',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['enum']);
    final val = StringMultiSelectItems(
      enumValue: $checkedConvert(
        'enum',
        (v) => _decodeStringMultiSelectItemsEnumValue(v),
      ),
      meta: $checkedConvert(
        '_meta',
        (v) => const AcpMetaConverter().fromJson(v),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'enumValue': 'enum', 'meta': '_meta'},
);

Map<String, dynamic> _$StringMultiSelectItemsToJson(
  StringMultiSelectItems instance,
) => <String, dynamic>{
  'enum': ?_encodeStringMultiSelectItemsEnumValue(instance.enumValue),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

Terminal _$TerminalFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Terminal', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['terminalId']);
      final val = Terminal(
        terminalId: $checkedConvert(
          'terminalId',
          (v) => _decodeTerminalTerminalId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$TerminalToJson(Terminal instance) => <String, dynamic>{
  'terminalId': ?_encodeTerminalTerminalId(instance.terminalId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

TerminalOutput _$TerminalOutputFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TerminalOutput', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data']);
      final val = TerminalOutput(
        data: $checkedConvert('data', (v) => _decodeTerminalOutputData(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$TerminalOutputToJson(TerminalOutput instance) =>
    <String, dynamic>{
      'data': ?_encodeTerminalOutputData(instance.data),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

TerminalOutputChunk _$TerminalOutputChunkFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TerminalOutputChunk', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['terminalId', 'data']);
      final val = TerminalOutputChunk(
        terminalId: $checkedConvert(
          'terminalId',
          (v) => _decodeTerminalOutputChunkTerminalId(v),
        ),
        data: $checkedConvert('data', (v) => _decodeTerminalOutputChunkData(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$TerminalOutputChunkToJson(
  TerminalOutputChunk instance,
) => <String, dynamic>{
  'terminalId': ?_encodeTerminalOutputChunkTerminalId(instance.terminalId),
  'data': ?_encodeTerminalOutputChunkData(instance.data),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

TextCommandInput _$TextCommandInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TextCommandInput', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['hint']);
      final val = TextCommandInput(
        hint: $checkedConvert('hint', (v) => _decodeTextCommandInputHint(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$TextCommandInputToJson(TextCommandInput instance) =>
    <String, dynamic>{
      'hint': ?_encodeTextCommandInputHint(instance.hint),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

TitledMultiSelectItems _$TitledMultiSelectItemsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TitledMultiSelectItems', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['anyOf']);
  final val = TitledMultiSelectItems(
    anyOf: $checkedConvert(
      'anyOf',
      (v) => _decodeTitledMultiSelectItemsAnyOf(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$TitledMultiSelectItemsToJson(
  TitledMultiSelectItems instance,
) => <String, dynamic>{
  'anyOf': ?_encodeTitledMultiSelectItemsAnyOf(instance.anyOf),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

ToolCallContentChunk _$ToolCallContentChunkFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ToolCallContentChunk', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['toolCallId', 'content']);
  final val = ToolCallContentChunk(
    toolCallId: $checkedConvert(
      'toolCallId',
      (v) => _decodeToolCallContentChunkToolCallId(v),
    ),
    content: $checkedConvert(
      'content',
      (v) => _decodeToolCallContentChunkContent(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ToolCallContentChunkToJson(
  ToolCallContentChunk instance,
) => <String, dynamic>{
  'toolCallId': ?_encodeToolCallContentChunkToolCallId(instance.toolCallId),
  'content': ?_encodeToolCallContentChunkContent(instance.content),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

ToolCallPermissionSubject _$ToolCallPermissionSubjectFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ToolCallPermissionSubject', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['toolCall']);
  final val = ToolCallPermissionSubject(
    toolCall: $checkedConvert(
      'toolCall',
      (v) => _decodeToolCallPermissionSubjectToolCall(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$ToolCallPermissionSubjectToJson(
  ToolCallPermissionSubject instance,
) => <String, dynamic>{
  'toolCall': ?_encodeToolCallPermissionSubjectToolCall(instance.toolCall),
};

UpdateSessionNotification _$UpdateSessionNotificationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateSessionNotification', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'update']);
  final val = UpdateSessionNotification(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeUpdateSessionNotificationSessionId(v),
    ),
    update: $checkedConvert(
      'update',
      (v) => _decodeUpdateSessionNotificationUpdate(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$UpdateSessionNotificationToJson(
  UpdateSessionNotification instance,
) => <String, dynamic>{
  'sessionId': ?_encodeUpdateSessionNotificationSessionId(instance.sessionId),
  'update': ?_encodeUpdateSessionNotificationUpdate(instance.update),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};
