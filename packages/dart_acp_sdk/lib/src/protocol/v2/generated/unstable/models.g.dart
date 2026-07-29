// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptNesNotification _$AcceptNesNotificationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AcceptNesNotification', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'suggestionId']);
  final val = AcceptNesNotification(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeAcceptNesNotificationSessionId(v),
    ),
    suggestionId: $checkedConvert(
      'suggestionId',
      (v) => _decodeAcceptNesNotificationSuggestionId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$AcceptNesNotificationToJson(
  AcceptNesNotification instance,
) => <String, dynamic>{
  'sessionId': ?_encodeAcceptNesNotificationSessionId(instance.sessionId),
  'suggestionId': ?_encodeAcceptNesNotificationSuggestionId(
    instance.suggestionId,
  ),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

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

CloseNesRequest _$CloseNesRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CloseNesRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sessionId']);
      final val = CloseNesRequest(
        sessionId: $checkedConvert(
          'sessionId',
          (v) => _decodeCloseNesRequestSessionId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CloseNesRequestToJson(CloseNesRequest instance) =>
    <String, dynamic>{
      'sessionId': ?_encodeCloseNesRequestSessionId(instance.sessionId),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

CloseNesResponse _$CloseNesResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CloseNesResponse', json, ($checkedConvert) {
      final val = CloseNesResponse(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$CloseNesResponseToJson(CloseNesResponse instance) =>
    <String, dynamic>{'_meta': ?const AcpMetaConverter().toJson(instance.meta)};

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

ConnectMcpRequest _$ConnectMcpRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConnectMcpRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['serverId']);
      final val = ConnectMcpRequest(
        serverId: $checkedConvert(
          'serverId',
          (v) => _decodeConnectMcpRequestServerId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ConnectMcpRequestToJson(ConnectMcpRequest instance) =>
    <String, dynamic>{
      'serverId': ?_encodeConnectMcpRequestServerId(instance.serverId),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

ConnectMcpResponse _$ConnectMcpResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConnectMcpResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['connectionId']);
      final val = ConnectMcpResponse(
        connectionId: $checkedConvert(
          'connectionId',
          (v) => _decodeConnectMcpResponseConnectionId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ConnectMcpResponseToJson(
  ConnectMcpResponse instance,
) => <String, dynamic>{
  'connectionId': ?_encodeConnectMcpResponseConnectionId(instance.connectionId),
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

DidCloseDocumentNotification _$DidCloseDocumentNotificationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DidCloseDocumentNotification', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'uri']);
  final val = DidCloseDocumentNotification(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeDidCloseDocumentNotificationSessionId(v),
    ),
    uri: $checkedConvert(
      'uri',
      (v) => _decodeDidCloseDocumentNotificationUri(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DidCloseDocumentNotificationToJson(
  DidCloseDocumentNotification instance,
) => <String, dynamic>{
  'sessionId': ?_encodeDidCloseDocumentNotificationSessionId(
    instance.sessionId,
  ),
  'uri': ?_encodeDidCloseDocumentNotificationUri(instance.uri),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

DidFocusDocumentNotification _$DidFocusDocumentNotificationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DidFocusDocumentNotification', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'sessionId',
      'uri',
      'version',
      'position',
      'visibleRange',
    ],
  );
  final val = DidFocusDocumentNotification(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeDidFocusDocumentNotificationSessionId(v),
    ),
    uri: $checkedConvert(
      'uri',
      (v) => _decodeDidFocusDocumentNotificationUri(v),
    ),
    version: $checkedConvert(
      'version',
      (v) => _decodeDidFocusDocumentNotificationVersion(v),
    ),
    position: $checkedConvert(
      'position',
      (v) => _decodeDidFocusDocumentNotificationPosition(v),
    ),
    visibleRange: $checkedConvert(
      'visibleRange',
      (v) => _decodeDidFocusDocumentNotificationVisibleRange(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DidFocusDocumentNotificationToJson(
  DidFocusDocumentNotification instance,
) => <String, dynamic>{
  'sessionId': ?_encodeDidFocusDocumentNotificationSessionId(
    instance.sessionId,
  ),
  'uri': ?_encodeDidFocusDocumentNotificationUri(instance.uri),
  'version': ?_encodeDidFocusDocumentNotificationVersion(instance.version),
  'position': ?_encodeDidFocusDocumentNotificationPosition(instance.position),
  'visibleRange': ?_encodeDidFocusDocumentNotificationVisibleRange(
    instance.visibleRange,
  ),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

DidOpenDocumentNotification _$DidOpenDocumentNotificationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DidOpenDocumentNotification', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['sessionId', 'uri', 'languageId', 'version', 'text'],
  );
  final val = DidOpenDocumentNotification(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeDidOpenDocumentNotificationSessionId(v),
    ),
    uri: $checkedConvert(
      'uri',
      (v) => _decodeDidOpenDocumentNotificationUri(v),
    ),
    languageId: $checkedConvert(
      'languageId',
      (v) => _decodeDidOpenDocumentNotificationLanguageId(v),
    ),
    version: $checkedConvert(
      'version',
      (v) => _decodeDidOpenDocumentNotificationVersion(v),
    ),
    text: $checkedConvert(
      'text',
      (v) => _decodeDidOpenDocumentNotificationText(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DidOpenDocumentNotificationToJson(
  DidOpenDocumentNotification instance,
) => <String, dynamic>{
  'sessionId': ?_encodeDidOpenDocumentNotificationSessionId(instance.sessionId),
  'uri': ?_encodeDidOpenDocumentNotificationUri(instance.uri),
  'languageId': ?_encodeDidOpenDocumentNotificationLanguageId(
    instance.languageId,
  ),
  'version': ?_encodeDidOpenDocumentNotificationVersion(instance.version),
  'text': ?_encodeDidOpenDocumentNotificationText(instance.text),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

DidSaveDocumentNotification _$DidSaveDocumentNotificationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DidSaveDocumentNotification', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionId', 'uri']);
  final val = DidSaveDocumentNotification(
    sessionId: $checkedConvert(
      'sessionId',
      (v) => _decodeDidSaveDocumentNotificationSessionId(v),
    ),
    uri: $checkedConvert(
      'uri',
      (v) => _decodeDidSaveDocumentNotificationUri(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DidSaveDocumentNotificationToJson(
  DidSaveDocumentNotification instance,
) => <String, dynamic>{
  'sessionId': ?_encodeDidSaveDocumentNotificationSessionId(instance.sessionId),
  'uri': ?_encodeDidSaveDocumentNotificationUri(instance.uri),
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

DisableProviderRequest _$DisableProviderRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DisableProviderRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['providerId']);
  final val = DisableProviderRequest(
    providerId: $checkedConvert(
      'providerId',
      (v) => _decodeDisableProviderRequestProviderId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DisableProviderRequestToJson(
  DisableProviderRequest instance,
) => <String, dynamic>{
  'providerId': ?_encodeDisableProviderRequestProviderId(instance.providerId),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

DisableProviderResponse _$DisableProviderResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DisableProviderResponse', json, ($checkedConvert) {
  final val = DisableProviderResponse(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DisableProviderResponseToJson(
  DisableProviderResponse instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

DisconnectMcpRequest _$DisconnectMcpRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DisconnectMcpRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['connectionId']);
  final val = DisconnectMcpRequest(
    connectionId: $checkedConvert(
      'connectionId',
      (v) => _decodeDisconnectMcpRequestConnectionId(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DisconnectMcpRequestToJson(
  DisconnectMcpRequest instance,
) => <String, dynamic>{
  'connectionId': ?_encodeDisconnectMcpRequestConnectionId(
    instance.connectionId,
  ),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

DisconnectMcpResponse _$DisconnectMcpResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DisconnectMcpResponse', json, ($checkedConvert) {
  final val = DisconnectMcpResponse(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$DisconnectMcpResponseToJson(
  DisconnectMcpResponse instance,
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

ListProvidersRequest _$ListProvidersRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ListProvidersRequest', json, ($checkedConvert) {
  final val = ListProvidersRequest(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ListProvidersRequestToJson(
  ListProvidersRequest instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

ListProvidersResponse _$ListProvidersResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ListProvidersResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['providers']);
  final val = ListProvidersResponse(
    providers: $checkedConvert(
      'providers',
      (v) => _decodeListProvidersResponseProviders(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ListProvidersResponseToJson(
  ListProvidersResponse instance,
) => <String, dynamic>{
  'providers': ?_encodeListProvidersResponseProviders(instance.providers),
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

McpAcpCapabilities _$McpAcpCapabilitiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('McpAcpCapabilities', json, ($checkedConvert) {
      final val = McpAcpCapabilities(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$McpAcpCapabilitiesToJson(McpAcpCapabilities instance) =>
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

McpServerAcp _$McpServerAcpFromJson(Map<String, dynamic> json) =>
    $checkedCreate('McpServerAcp', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'serverId']);
      final val = McpServerAcp(
        name: $checkedConvert('name', (v) => _decodeMcpServerAcpName(v)),
        serverId: $checkedConvert(
          'serverId',
          (v) => _decodeMcpServerAcpServerId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$McpServerAcpToJson(McpServerAcp instance) =>
    <String, dynamic>{
      'name': ?_encodeMcpServerAcpName(instance.name),
      'serverId': ?_encodeMcpServerAcpServerId(instance.serverId),
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

NesDiagnostic _$NesDiagnosticFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesDiagnostic', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['uri', 'range', 'severity', 'message']);
  final val = NesDiagnostic(
    uri: $checkedConvert('uri', (v) => _decodeNesDiagnosticUri(v)),
    range: $checkedConvert('range', (v) => _decodeNesDiagnosticRange(v)),
    severity: $checkedConvert(
      'severity',
      (v) => _decodeNesDiagnosticSeverity(v),
    ),
    message: $checkedConvert('message', (v) => _decodeNesDiagnosticMessage(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesDiagnosticToJson(NesDiagnostic instance) =>
    <String, dynamic>{
      'uri': ?_encodeNesDiagnosticUri(instance.uri),
      'range': ?_encodeNesDiagnosticRange(instance.range),
      'severity': ?_encodeNesDiagnosticSeverity(instance.severity),
      'message': ?_encodeNesDiagnosticMessage(instance.message),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

NesDiagnosticsCapabilities _$NesDiagnosticsCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesDiagnosticsCapabilities', json, ($checkedConvert) {
  final val = NesDiagnosticsCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesDiagnosticsCapabilitiesToJson(
  NesDiagnosticsCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesDocumentDidChangeCapabilities _$NesDocumentDidChangeCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesDocumentDidChangeCapabilities', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['syncKind']);
  final val = NesDocumentDidChangeCapabilities(
    syncKind: $checkedConvert(
      'syncKind',
      (v) => _decodeNesDocumentDidChangeCapabilitiesSyncKind(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesDocumentDidChangeCapabilitiesToJson(
  NesDocumentDidChangeCapabilities instance,
) => <String, dynamic>{
  'syncKind': ?_encodeNesDocumentDidChangeCapabilitiesSyncKind(
    instance.syncKind,
  ),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesDocumentDidCloseCapabilities _$NesDocumentDidCloseCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesDocumentDidCloseCapabilities', json, ($checkedConvert) {
  final val = NesDocumentDidCloseCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesDocumentDidCloseCapabilitiesToJson(
  NesDocumentDidCloseCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesDocumentDidFocusCapabilities _$NesDocumentDidFocusCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesDocumentDidFocusCapabilities', json, ($checkedConvert) {
  final val = NesDocumentDidFocusCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesDocumentDidFocusCapabilitiesToJson(
  NesDocumentDidFocusCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesDocumentDidOpenCapabilities _$NesDocumentDidOpenCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesDocumentDidOpenCapabilities', json, ($checkedConvert) {
  final val = NesDocumentDidOpenCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesDocumentDidOpenCapabilitiesToJson(
  NesDocumentDidOpenCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesDocumentDidSaveCapabilities _$NesDocumentDidSaveCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesDocumentDidSaveCapabilities', json, ($checkedConvert) {
  final val = NesDocumentDidSaveCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesDocumentDidSaveCapabilitiesToJson(
  NesDocumentDidSaveCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesEditHistoryEntry _$NesEditHistoryEntryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NesEditHistoryEntry', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['uri', 'diff']);
      final val = NesEditHistoryEntry(
        uri: $checkedConvert('uri', (v) => _decodeNesEditHistoryEntryUri(v)),
        diff: $checkedConvert('diff', (v) => _decodeNesEditHistoryEntryDiff(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesEditHistoryEntryToJson(
  NesEditHistoryEntry instance,
) => <String, dynamic>{
  'uri': ?_encodeNesEditHistoryEntryUri(instance.uri),
  'diff': ?_encodeNesEditHistoryEntryDiff(instance.diff),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesExcerpt _$NesExcerptFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NesExcerpt', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['startLine', 'endLine', 'text']);
      final val = NesExcerpt(
        startLine: $checkedConvert(
          'startLine',
          (v) => _decodeNesExcerptStartLine(v),
        ),
        endLine: $checkedConvert('endLine', (v) => _decodeNesExcerptEndLine(v)),
        text: $checkedConvert('text', (v) => _decodeNesExcerptText(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesExcerptToJson(NesExcerpt instance) =>
    <String, dynamic>{
      'startLine': ?_encodeNesExcerptStartLine(instance.startLine),
      'endLine': ?_encodeNesExcerptEndLine(instance.endLine),
      'text': ?_encodeNesExcerptText(instance.text),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

NesJumpCapabilities _$NesJumpCapabilitiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NesJumpCapabilities', json, ($checkedConvert) {
      final val = NesJumpCapabilities(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesJumpCapabilitiesToJson(
  NesJumpCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesJumpSuggestion _$NesJumpSuggestionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NesJumpSuggestion', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['suggestionId', 'uri', 'position']);
      final val = NesJumpSuggestion(
        suggestionId: $checkedConvert(
          'suggestionId',
          (v) => _decodeNesJumpSuggestionSuggestionId(v),
        ),
        uri: $checkedConvert('uri', (v) => _decodeNesJumpSuggestionUri(v)),
        position: $checkedConvert(
          'position',
          (v) => _decodeNesJumpSuggestionPosition(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesJumpSuggestionToJson(
  NesJumpSuggestion instance,
) => <String, dynamic>{
  'suggestionId': ?_encodeNesJumpSuggestionSuggestionId(instance.suggestionId),
  'uri': ?_encodeNesJumpSuggestionUri(instance.uri),
  'position': ?_encodeNesJumpSuggestionPosition(instance.position),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesOpenFilesCapabilities _$NesOpenFilesCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesOpenFilesCapabilities', json, ($checkedConvert) {
  final val = NesOpenFilesCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesOpenFilesCapabilitiesToJson(
  NesOpenFilesCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesRecentFile _$NesRecentFileFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NesRecentFile', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['uri', 'languageId', 'text']);
      final val = NesRecentFile(
        uri: $checkedConvert('uri', (v) => _decodeNesRecentFileUri(v)),
        languageId: $checkedConvert(
          'languageId',
          (v) => _decodeNesRecentFileLanguageId(v),
        ),
        text: $checkedConvert('text', (v) => _decodeNesRecentFileText(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesRecentFileToJson(NesRecentFile instance) =>
    <String, dynamic>{
      'uri': ?_encodeNesRecentFileUri(instance.uri),
      'languageId': ?_encodeNesRecentFileLanguageId(instance.languageId),
      'text': ?_encodeNesRecentFileText(instance.text),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

NesRelatedSnippet _$NesRelatedSnippetFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NesRelatedSnippet', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['uri', 'excerpts']);
      final val = NesRelatedSnippet(
        uri: $checkedConvert('uri', (v) => _decodeNesRelatedSnippetUri(v)),
        excerpts: $checkedConvert(
          'excerpts',
          (v) => _decodeNesRelatedSnippetExcerpts(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesRelatedSnippetToJson(NesRelatedSnippet instance) =>
    <String, dynamic>{
      'uri': ?_encodeNesRelatedSnippetUri(instance.uri),
      'excerpts': ?_encodeNesRelatedSnippetExcerpts(instance.excerpts),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

NesRelatedSnippetsCapabilities _$NesRelatedSnippetsCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesRelatedSnippetsCapabilities', json, ($checkedConvert) {
  final val = NesRelatedSnippetsCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesRelatedSnippetsCapabilitiesToJson(
  NesRelatedSnippetsCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesRenameCapabilities _$NesRenameCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesRenameCapabilities', json, ($checkedConvert) {
  final val = NesRenameCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesRenameCapabilitiesToJson(
  NesRenameCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesRenameSuggestion _$NesRenameSuggestionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NesRenameSuggestion', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['suggestionId', 'uri', 'position', 'newName'],
      );
      final val = NesRenameSuggestion(
        suggestionId: $checkedConvert(
          'suggestionId',
          (v) => _decodeNesRenameSuggestionSuggestionId(v),
        ),
        uri: $checkedConvert('uri', (v) => _decodeNesRenameSuggestionUri(v)),
        position: $checkedConvert(
          'position',
          (v) => _decodeNesRenameSuggestionPosition(v),
        ),
        newName: $checkedConvert(
          'newName',
          (v) => _decodeNesRenameSuggestionNewName(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesRenameSuggestionToJson(
  NesRenameSuggestion instance,
) => <String, dynamic>{
  'suggestionId': ?_encodeNesRenameSuggestionSuggestionId(
    instance.suggestionId,
  ),
  'uri': ?_encodeNesRenameSuggestionUri(instance.uri),
  'position': ?_encodeNesRenameSuggestionPosition(instance.position),
  'newName': ?_encodeNesRenameSuggestionNewName(instance.newName),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesRepository _$NesRepositoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NesRepository', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'owner', 'remoteUrl']);
      final val = NesRepository(
        name: $checkedConvert('name', (v) => _decodeNesRepositoryName(v)),
        owner: $checkedConvert('owner', (v) => _decodeNesRepositoryOwner(v)),
        remoteUrl: $checkedConvert(
          'remoteUrl',
          (v) => _decodeNesRepositoryRemoteUrl(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesRepositoryToJson(NesRepository instance) =>
    <String, dynamic>{
      'name': ?_encodeNesRepositoryName(instance.name),
      'owner': ?_encodeNesRepositoryOwner(instance.owner),
      'remoteUrl': ?_encodeNesRepositoryRemoteUrl(instance.remoteUrl),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

NesSearchAndReplaceCapabilities _$NesSearchAndReplaceCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesSearchAndReplaceCapabilities', json, ($checkedConvert) {
  final val = NesSearchAndReplaceCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesSearchAndReplaceCapabilitiesToJson(
  NesSearchAndReplaceCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

NesTextEdit _$NesTextEditFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NesTextEdit', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['range', 'newText']);
  final val = NesTextEdit(
    range: $checkedConvert('range', (v) => _decodeNesTextEditRange(v)),
    newText: $checkedConvert('newText', (v) => _decodeNesTextEditNewText(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesTextEditToJson(NesTextEdit instance) =>
    <String, dynamic>{
      'range': ?_encodeNesTextEditRange(instance.range),
      'newText': ?_encodeNesTextEditNewText(instance.newText),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

NesUserAction _$NesUserActionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NesUserAction', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['action', 'uri', 'position', 'timestampMs'],
      );
      final val = NesUserAction(
        action: $checkedConvert('action', (v) => _decodeNesUserActionAction(v)),
        uri: $checkedConvert('uri', (v) => _decodeNesUserActionUri(v)),
        position: $checkedConvert(
          'position',
          (v) => _decodeNesUserActionPosition(v),
        ),
        timestampMs: $checkedConvert(
          'timestampMs',
          (v) => _decodeNesUserActionTimestampMs(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$NesUserActionToJson(NesUserAction instance) =>
    <String, dynamic>{
      'action': ?_encodeNesUserActionAction(instance.action),
      'uri': ?_encodeNesUserActionUri(instance.uri),
      'position': ?_encodeNesUserActionPosition(instance.position),
      'timestampMs': ?_encodeNesUserActionTimestampMs(instance.timestampMs),
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

PlanFile _$PlanFileFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlanFile', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['planId', 'uri']);
      final val = PlanFile(
        planId: $checkedConvert('planId', (v) => _decodePlanFilePlanId(v)),
        uri: $checkedConvert('uri', (v) => _decodePlanFileUri(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PlanFileToJson(PlanFile instance) => <String, dynamic>{
  'planId': ?_encodePlanFilePlanId(instance.planId),
  'uri': ?_encodePlanFileUri(instance.uri),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

PlanMarkdown _$PlanMarkdownFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PlanMarkdown', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['planId', 'content']);
  final val = PlanMarkdown(
    planId: $checkedConvert('planId', (v) => _decodePlanMarkdownPlanId(v)),
    content: $checkedConvert('content', (v) => _decodePlanMarkdownContent(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PlanMarkdownToJson(PlanMarkdown instance) =>
    <String, dynamic>{
      'planId': ?_encodePlanMarkdownPlanId(instance.planId),
      'content': ?_encodePlanMarkdownContent(instance.content),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

PlanRemoved _$PlanRemovedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlanRemoved', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['planId']);
      final val = PlanRemoved(
        planId: $checkedConvert('planId', (v) => _decodePlanRemovedPlanId(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PlanRemovedToJson(PlanRemoved instance) =>
    <String, dynamic>{
      'planId': ?_encodePlanRemovedPlanId(instance.planId),
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

Position _$PositionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('Position', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['line', 'character']);
  final val = Position(
    line: $checkedConvert('line', (v) => _decodePositionLine(v)),
    character: $checkedConvert('character', (v) => _decodePositionCharacter(v)),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
  'line': ?_encodePositionLine(instance.line),
  'character': ?_encodePositionCharacter(instance.character),
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

ProviderCurrentConfig _$ProviderCurrentConfigFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ProviderCurrentConfig', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['apiType', 'baseUrl']);
  final val = ProviderCurrentConfig(
    apiType: $checkedConvert(
      'apiType',
      (v) => _decodeProviderCurrentConfigApiType(v),
    ),
    baseUrl: $checkedConvert(
      'baseUrl',
      (v) => _decodeProviderCurrentConfigBaseUrl(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ProviderCurrentConfigToJson(
  ProviderCurrentConfig instance,
) => <String, dynamic>{
  'apiType': ?_encodeProviderCurrentConfigApiType(instance.apiType),
  'baseUrl': ?_encodeProviderCurrentConfigBaseUrl(instance.baseUrl),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

ProvidersCapabilities _$ProvidersCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ProvidersCapabilities', json, ($checkedConvert) {
  final val = ProvidersCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$ProvidersCapabilitiesToJson(
  ProvidersCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

Range _$RangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Range', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['start', 'end']);
      final val = Range(
        start: $checkedConvert('start', (v) => _decodeRangeStart(v)),
        end: $checkedConvert('end', (v) => _decodeRangeEnd(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$RangeToJson(Range instance) => <String, dynamic>{
  'start': ?_encodeRangeStart(instance.start),
  'end': ?_encodeRangeEnd(instance.end),
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

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

SessionForkCapabilities _$SessionForkCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SessionForkCapabilities', json, ($checkedConvert) {
  final val = SessionForkCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SessionForkCapabilitiesToJson(
  SessionForkCapabilities instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

SetProviderRequest _$SetProviderRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SetProviderRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['providerId', 'apiType', 'baseUrl']);
  final val = SetProviderRequest(
    providerId: $checkedConvert(
      'providerId',
      (v) => _decodeSetProviderRequestProviderId(v),
    ),
    apiType: $checkedConvert(
      'apiType',
      (v) => _decodeSetProviderRequestApiType(v),
    ),
    baseUrl: $checkedConvert(
      'baseUrl',
      (v) => _decodeSetProviderRequestBaseUrl(v),
    ),
    headers: $checkedConvert(
      'headers',
      (v) => _decodeSetProviderRequestHeaders(v),
    ),
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SetProviderRequestToJson(SetProviderRequest instance) =>
    <String, dynamic>{
      'providerId': ?_encodeSetProviderRequestProviderId(instance.providerId),
      'apiType': ?_encodeSetProviderRequestApiType(instance.apiType),
      'baseUrl': ?_encodeSetProviderRequestBaseUrl(instance.baseUrl),
      'headers': ?_encodeSetProviderRequestHeaders(instance.headers),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };

SetProviderResponse _$SetProviderResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SetProviderResponse', json, ($checkedConvert) {
      final val = SetProviderResponse(
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SetProviderResponseToJson(
  SetProviderResponse instance,
) => <String, dynamic>{
  '_meta': ?const AcpMetaConverter().toJson(instance.meta),
};

StartNesResponse _$StartNesResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StartNesResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sessionId']);
      final val = StartNesResponse(
        sessionId: $checkedConvert(
          'sessionId',
          (v) => _decodeStartNesResponseSessionId(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$StartNesResponseToJson(StartNesResponse instance) =>
    <String, dynamic>{
      'sessionId': ?_encodeStartNesResponseSessionId(instance.sessionId),
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

SuggestNesResponse _$SuggestNesResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SuggestNesResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['suggestions']);
      final val = SuggestNesResponse(
        suggestions: $checkedConvert(
          'suggestions',
          (v) => _decodeSuggestNesResponseSuggestions(v),
        ),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$SuggestNesResponseToJson(
  SuggestNesResponse instance,
) => <String, dynamic>{
  'suggestions': ?_encodeSuggestNesResponseSuggestions(instance.suggestions),
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

TerminalAuthCapabilities _$TerminalAuthCapabilitiesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TerminalAuthCapabilities', json, ($checkedConvert) {
  final val = TerminalAuthCapabilities(
    meta: $checkedConvert('_meta', (v) => const AcpMetaConverter().fromJson(v)),
  );
  return val;
}, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$TerminalAuthCapabilitiesToJson(
  TerminalAuthCapabilities instance,
) => <String, dynamic>{
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

WorkspaceFolder _$WorkspaceFolderFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WorkspaceFolder', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['uri', 'name']);
      final val = WorkspaceFolder(
        uri: $checkedConvert('uri', (v) => _decodeWorkspaceFolderUri(v)),
        name: $checkedConvert('name', (v) => _decodeWorkspaceFolderName(v)),
        meta: $checkedConvert(
          '_meta',
          (v) => const AcpMetaConverter().fromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'meta': '_meta'});

Map<String, dynamic> _$WorkspaceFolderToJson(WorkspaceFolder instance) =>
    <String, dynamic>{
      'uri': ?_encodeWorkspaceFolderUri(instance.uri),
      'name': ?_encodeWorkspaceFolderName(instance.name),
      '_meta': ?const AcpMetaConverter().toJson(instance.meta),
    };
