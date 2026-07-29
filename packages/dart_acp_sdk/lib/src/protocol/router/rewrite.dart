part of 'router.dart';

Map<String, Object?> _rewriteInitializeParams(
  Map<String, Object?> params,
  int requested,
  int selected,
) {
  if (selected == 1) {
    if (requested >= 2) {
      final v2.InitializeRequest initialize = v2.initializeRequestCodec.decode(
        params,
      );
      return _v2InitializeToV1(initialize);
    }
    final v1.InitializeRequest initialize = v1.initializeRequestCodec.decode(
      params,
    );
    return _canonicalJsonObject(<String, Object?>{
      ...initialize.toJson(),
      'protocolVersion': 1,
    });
  }
  if (requested < 2) {
    final v1.InitializeRequest initialize = v1.initializeRequestCodec.decode(
      params,
    );
    return _v1InitializeToV2(initialize);
  }
  final v2.InitializeRequest initialize = v2.initializeRequestCodec.decode(
    params,
  );
  return _canonicalJsonObject(<String, Object?>{
    ...initialize.toJson(),
    'protocolVersion': 2,
  });
}

Map<String, Object?> _v1InitializeToV2(v1.InitializeRequest initialize) {
  final Map<String, Object?> v1Capabilities = initialize.clientCapabilities
      .toJson();
  final Map<String, Object?> capabilities = <String, Object?>{
    if (v1Capabilities['elicitation'] != null)
      'elicitation': v1Capabilities['elicitation'],
    if (v1Capabilities['_meta'] != null) '_meta': v1Capabilities['_meta'],
  };
  return _canonicalJsonObject(<String, Object?>{
    'protocolVersion': 2,
    'info':
        initialize.clientInfo?.toJson() ??
        const <String, Object?>{
          'name': 'unknown-acp-client',
          'version': 'unknown',
        },
    'capabilities': capabilities,
    if (initialize.meta != null) '_meta': initialize.meta!.toObject(),
  });
}

Map<String, Object?> _v2InitializeToV1(v2.InitializeRequest initialize) {
  final Map<String, Object?> capabilities = initialize.capabilities.toJson();
  final Map<String, Object?>? auth = _jsonObject(capabilities['auth']);
  final Map<String, Object?>? terminal = _jsonObject(auth?['terminal']);
  if (terminal?['_meta'] != null) {
    throw const FormatException(
      'v2 AuthCapabilities.terminal metadata cannot be represented in v1',
    );
  }
  final Map<String, Object?> v1Capabilities = <String, Object?>{
    'fs': <String, Object?>{'readTextFile': false, 'writeTextFile': false},
    'terminal': false,
    'session': <String, Object?>{
      'configOptions': <String, Object?>{'boolean': <String, Object?>{}},
    },
    'plan': <String, Object?>{},
    'auth': <String, Object?>{
      'terminal': terminal != null,
      if (auth?['_meta'] != null) '_meta': auth!['_meta'],
    },
    if (capabilities['elicitation'] != null)
      'elicitation': capabilities['elicitation'],
    if (capabilities['nes'] != null) 'nes': capabilities['nes'],
    if (capabilities['positionEncodings'] != null)
      'positionEncodings': capabilities['positionEncodings'],
    if (capabilities['_meta'] != null) '_meta': capabilities['_meta'],
  };
  return _canonicalJsonObject(<String, Object?>{
    'protocolVersion': 1,
    'clientCapabilities': v1Capabilities,
    'clientInfo': initialize.info.toJson(),
    if (initialize.meta != null) '_meta': initialize.meta!.toObject(),
  });
}

Map<String, Object?> _canonicalJsonObject(Map<String, Object?> value) {
  final Map<String, Object?> result = <String, Object?>{};
  for (final MapEntry<String, Object?> entry in value.entries) {
    final Object? member = entry.value;
    if (member == null) {
      continue;
    }
    if (member is List<Object?>) {
      if (member.isNotEmpty) {
        result[entry.key] = <Object?>[
          for (final Object? item in member) _canonicalJsonValue(item),
        ];
      }
      continue;
    }
    final Map<String, Object?>? object = _jsonObject(member);
    result[entry.key] = object == null ? member : _canonicalJsonObject(object);
  }
  return result;
}

Object? _canonicalJsonValue(Object? value) {
  if (value is List<Object?>) {
    return <Object?>[
      for (final Object? item in value) _canonicalJsonValue(item),
    ];
  }
  final Map<String, Object?>? object = _jsonObject(value);
  return object == null ? value : _canonicalJsonObject(object);
}

Map<String, Object?>? _jsonObject(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is! Map<Object?, Object?>) {
    return null;
  }
  final Map<String, Object?> result = <String, Object?>{};
  for (final MapEntry<Object?, Object?> entry in value.entries) {
    if (entry.key is! String) {
      return null;
    }
    result[entry.key! as String] = entry.value;
  }
  return result;
}
