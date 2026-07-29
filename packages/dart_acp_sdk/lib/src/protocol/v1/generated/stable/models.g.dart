// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateRequest _$AuthenticateRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthenticateRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['methodId']);
      final val = AuthenticateRequest(
        methodId: $checkedConvert(
          'methodId',
          (v) => _decodeAuthenticateRequestMethodId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$AuthenticateRequestToJson(
  AuthenticateRequest instance,
) => <String, dynamic>{
  'methodId': ?_encodeAuthenticateRequestMethodId(instance.methodId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

AuthenticateResponse _$AuthenticateResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthenticateResponse', json, ($checkedConvert) {
  final val = AuthenticateResponse(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$AuthenticateResponseToJson(
  AuthenticateResponse instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

BooleanConfigOptionCapabilities _$BooleanConfigOptionCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('BooleanConfigOptionCapabilities', json, ($checkedConvert) {
  final val = BooleanConfigOptionCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$BooleanConfigOptionCapabilitiesToJson(
  BooleanConfigOptionCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

CancelNotification _$CancelNotificationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CancelNotification', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sessionId']);
      final val = CancelNotification(
        sessionId: $checkedConvert(
          'sessionId',
          (v) => _decodeCancelNotificationSessionId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CancelNotificationToJson(CancelNotification instance) =>
    <String, dynamic>{
      'sessionId': ?_encodeCancelNotificationSessionId(instance.sessionId),
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

CreateTerminalResponse _$CreateTerminalResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateTerminalResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['terminalId']);
  final val = CreateTerminalResponse(
    terminalId: $checkedConvert(
      'terminalId',
      (v) => _decodeCreateTerminalResponseTerminalId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CreateTerminalResponseToJson(
  CreateTerminalResponse instance,
) => <String, dynamic>{
  'terminalId': ?_encodeCreateTerminalResponseTerminalId(instance.terminalId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

CurrentModeUpdate _$CurrentModeUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CurrentModeUpdate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['currentModeId']);
      final val = CurrentModeUpdate(
        currentModeId: $checkedConvert(
          'currentModeId',
          (v) => _decodeCurrentModeUpdateCurrentModeId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CurrentModeUpdateToJson(CurrentModeUpdate instance) =>
    <String, dynamic>{
      'currentModeId': ?_encodeCurrentModeUpdateCurrentModeId(
        instance.currentModeId,
      ),
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

KillTerminalRequest _$KillTerminalRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('KillTerminalRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sessionId', 'terminalId']);
      final val = KillTerminalRequest(
        sessionId: $checkedConvert(
          'sessionId',
          (v) => _decodeKillTerminalRequestSessionId(v),
        ),
        terminalId: $checkedConvert(
          'terminalId',
          (v) => _decodeKillTerminalRequestTerminalId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$KillTerminalRequestToJson(
  KillTerminalRequest instance,
) => <String, dynamic>{
  'sessionId': ?_encodeKillTerminalRequestSessionId(instance.sessionId),
  'terminalId': ?_encodeKillTerminalRequestTerminalId(instance.terminalId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

KillTerminalResponse _$KillTerminalResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('KillTerminalResponse', json, ($checkedConvert) {
  final val = KillTerminalResponse(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$KillTerminalResponseToJson(
  KillTerminalResponse instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

LogoutCapabilities _$LogoutCapabilitiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LogoutCapabilities', json, ($checkedConvert) {
      final val = LogoutCapabilities(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$LogoutCapabilitiesToJson(LogoutCapabilities instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

LogoutRequest _$LogoutRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LogoutRequest', json, ($checkedConvert) {
      final val = LogoutRequest(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$LogoutRequestToJson(LogoutRequest instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

LogoutResponse _$LogoutResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LogoutResponse', json, ($checkedConvert) {
      final val = LogoutResponse(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$LogoutResponseToJson(LogoutResponse instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

McpServerHttp _$McpServerHttpFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('McpServerHttp', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name', 'url', 'headers']);
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

McpServerSse _$McpServerSseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('McpServerSse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name', 'url', 'headers']);
  final val = McpServerSse(
    name: $checkedConvert('name', (v) => _decodeMcpServerSseName(v)),
    url: $checkedConvert('url', (v) => _decodeMcpServerSseUrl(v)),
    headers: $checkedConvert('headers', (v) => _decodeMcpServerSseHeaders(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$McpServerSseToJson(McpServerSse instance) =>
    <String, dynamic>{
      'name': ?_encodeMcpServerSseName(instance.name),
      'url': ?_encodeMcpServerSseUrl(instance.url),
      'headers': ?_encodeMcpServerSseHeaders(instance.headers),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

McpServerStdio _$McpServerStdioFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('McpServerStdio', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name', 'command', 'args', 'env']);
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
      $checkKeys(json, requiredKeys: const ['stopReason']);
      final val = PromptResponse(
        stopReason: $checkedConvert(
          'stopReason',
          (v) => _decodePromptResponseStopReason(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PromptResponseToJson(PromptResponse instance) =>
    <String, dynamic>{
      'stopReason': ?_encodePromptResponseStopReason(instance.stopReason),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

ReadTextFileResponse _$ReadTextFileResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReadTextFileResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['content']);
  final val = ReadTextFileResponse(
    content: $checkedConvert(
      'content',
      (v) => _decodeReadTextFileResponseContent(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ReadTextFileResponseToJson(
  ReadTextFileResponse instance,
) => <String, dynamic>{
  'content': ?_encodeReadTextFileResponseContent(instance.content),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

ReleaseTerminalRequest _$ReleaseTerminalRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReleaseTerminalRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'terminalId']);
  final val = ReleaseTerminalRequest(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeReleaseTerminalRequestSessionId(v),
    ),
    terminalId: $checkedConvert(
      'terminalId',
      (v) => _decodeReleaseTerminalRequestTerminalId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ReleaseTerminalRequestToJson(
  ReleaseTerminalRequest instance,
) => <String, dynamic>{
  'sessionId': ?_encodeReleaseTerminalRequestSessionId(instance.sessionId),
  'terminalId': ?_encodeReleaseTerminalRequestTerminalId(instance.terminalId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

ReleaseTerminalResponse _$ReleaseTerminalResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReleaseTerminalResponse', json, ($checkedConvert) {
  final val = ReleaseTerminalResponse(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ReleaseTerminalResponseToJson(
  ReleaseTerminalResponse instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

RequestPermissionRequest _$RequestPermissionRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RequestPermissionRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'toolCall', 'options']);
  final val = RequestPermissionRequest(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeRequestPermissionRequestSessionId(v),
    ),
    toolCall: $checkedConvert(
      'toolCall',
      (v) => _decodeRequestPermissionRequestToolCall(v),
    ),
    options: $checkedConvert(
      'options',
      (v) => _decodeRequestPermissionRequestOptions(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$RequestPermissionRequestToJson(
  RequestPermissionRequest instance,
) => <String, dynamic>{
  'sessionId': ?_encodeRequestPermissionRequestSessionId(instance.sessionId),
  'toolCall': ?_encodeRequestPermissionRequestToolCall(instance.toolCall),
  'options': ?_encodeRequestPermissionRequestOptions(instance.options),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

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

SessionCloseCapabilities _$SessionCloseCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SessionCloseCapabilities', json, ($checkedConvert) {
  final val = SessionCloseCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SessionCloseCapabilitiesToJson(
  SessionCloseCapabilities instance,
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

SessionListCapabilities _$SessionListCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SessionListCapabilities', json, ($checkedConvert) {
  final val = SessionListCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SessionListCapabilitiesToJson(
  SessionListCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

SessionNotification _$SessionNotificationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SessionNotification', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sessionId', 'update']);
      final val = SessionNotification(
        sessionId: $checkedConvert(
          'sessionId',
          (v) => _decodeSessionNotificationSessionId(v),
        ),
        update: $checkedConvert(
          'update',
          (v) => _decodeSessionNotificationUpdate(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SessionNotificationToJson(
  SessionNotification instance,
) => <String, dynamic>{
  'sessionId': ?_encodeSessionNotificationSessionId(instance.sessionId),
  'update': ?_encodeSessionNotificationUpdate(instance.update),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

SessionResumeCapabilities _$SessionResumeCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SessionResumeCapabilities', json, ($checkedConvert) {
  final val = SessionResumeCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SessionResumeCapabilitiesToJson(
  SessionResumeCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

SetSessionModeRequest _$SetSessionModeRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SetSessionModeRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'modeId']);
  final val = SetSessionModeRequest(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeSetSessionModeRequestSessionId(v),
    ),
    modeId: $checkedConvert(
      'modeId',
      (v) => _decodeSetSessionModeRequestModeId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SetSessionModeRequestToJson(
  SetSessionModeRequest instance,
) => <String, dynamic>{
  'sessionId': ?_encodeSetSessionModeRequestSessionId(instance.sessionId),
  'modeId': ?_encodeSetSessionModeRequestModeId(instance.modeId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

SetSessionModeResponse _$SetSessionModeResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SetSessionModeResponse', json, ($checkedConvert) {
  final val = SetSessionModeResponse(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SetSessionModeResponseToJson(
  SetSessionModeResponse instance,
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

TerminalOutputRequest _$TerminalOutputRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TerminalOutputRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'terminalId']);
  final val = TerminalOutputRequest(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeTerminalOutputRequestSessionId(v),
    ),
    terminalId: $checkedConvert(
      'terminalId',
      (v) => _decodeTerminalOutputRequestTerminalId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$TerminalOutputRequestToJson(
  TerminalOutputRequest instance,
) => <String, dynamic>{
  'sessionId': ?_encodeTerminalOutputRequestSessionId(instance.sessionId),
  'terminalId': ?_encodeTerminalOutputRequestTerminalId(instance.terminalId),
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

UnstructuredCommandInput _$UnstructuredCommandInputFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UnstructuredCommandInput', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['hint']);
  final val = UnstructuredCommandInput(
    hint: $checkedConvert(
      'hint',
      (v) => _decodeUnstructuredCommandInputHint(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$UnstructuredCommandInputToJson(
  UnstructuredCommandInput instance,
) => <String, dynamic>{
  'hint': ?_encodeUnstructuredCommandInputHint(instance.hint),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

WaitForTerminalExitRequest _$WaitForTerminalExitRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WaitForTerminalExitRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'terminalId']);
  final val = WaitForTerminalExitRequest(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeWaitForTerminalExitRequestSessionId(v),
    ),
    terminalId: $checkedConvert(
      'terminalId',
      (v) => _decodeWaitForTerminalExitRequestTerminalId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$WaitForTerminalExitRequestToJson(
  WaitForTerminalExitRequest instance,
) => <String, dynamic>{
  'sessionId': ?_encodeWaitForTerminalExitRequestSessionId(instance.sessionId),
  'terminalId': ?_encodeWaitForTerminalExitRequestTerminalId(
    instance.terminalId,
  ),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

WriteTextFileRequest _$WriteTextFileRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WriteTextFileRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'path', 'content']);
  final val = WriteTextFileRequest(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeWriteTextFileRequestSessionId(v),
    ),
    path: $checkedConvert('path', (v) => _decodeWriteTextFileRequestPath(v)),
    content: $checkedConvert(
      'content',
      (v) => _decodeWriteTextFileRequestContent(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$WriteTextFileRequestToJson(
  WriteTextFileRequest instance,
) => <String, dynamic>{
  'sessionId': ?_encodeWriteTextFileRequestSessionId(instance.sessionId),
  'path': ?_encodeWriteTextFileRequestPath(instance.path),
  'content': ?_encodeWriteTextFileRequestContent(instance.content),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

WriteTextFileResponse _$WriteTextFileResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WriteTextFileResponse', json, ($checkedConvert) {
  final val = WriteTextFileResponse(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$WriteTextFileResponseToJson(
  WriteTextFileResponse instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};
