import 'package:dart_acp_sdk/src/common/patch.dart';
import 'package:dart_acp_sdk/src/protocol/method.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/method_descriptors.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';
import 'package:test/test.dart';

void main() {
  test('method descriptors retain exact concrete correlations', () {
    const AcpMethodDescriptor<InitializeRequest, InitializeResponse>
    typedInitialize = initializeMethod;
    const AcpMethodDescriptor<CancelNotification, AcpNoResult> typedCancel =
        sessionCancelMethod;

    expect(typedInitialize.name, 'initialize');
    expect(typedInitialize.dartName, 'initialize');
    expect(typedInitialize.paramsDefinition, 'InitializeRequest');
    expect(typedInitialize.resultDefinition, 'InitializeResponse');
    expect(typedInitialize.direction, AcpMethodDirection.clientToAgent);
    expect(typedCancel.name, 'session/cancel');
    expect(typedCancel.kind, AcpMethodKind.notification);
    expect(typedCancel.resultDefinition, isNull);
    expect(
      () => typedCancel.resultCodec.decode(<String, Object?>{}),
      throwsFormatException,
    );
    expect(
      v1StableMethodRegistry.lookup(
        name: 'initialize',
        direction: AcpMethodDirection.clientToAgent,
        kind: AcpMethodKind.request,
      ),
      same(initializeMethod),
    );
  });

  test('initialize applies schema defaults and round trips', () {
    final decoded = InitializeRequest.decode(<String, Object?>{
      'protocolVersion': 1,
    });

    expect(decoded.issues, isEmpty);
    expect(decoded.value.protocolVersion.value, 1);
    final Object? encoded = initializeMethod.paramsCodec.encode(decoded.value);
    expect(
      encoded,
      containsPair('clientCapabilities', isA<Map<String, Object?>>()),
    );
    expect(
      initializeMethod.paramsCodec.decode(encoded),
      isA<InitializeRequest>(),
    );
  });

  test('auth descriptors reflect v1 advertisement semantics', () {
    expect(authenticateMethod.capabilityPath, 'agentCapabilities.authMethods');
    expect(logoutMethod.capabilityPath, 'agentCapabilities.auth.logout');
    expect(sessionSetModeMethod.capabilityPath, isNull);
    expect(sessionSetConfigOptionMethod.capabilityPath, isNull);
    expect(sessionRequestPermissionMethod.capabilityPath, isNull);
  });

  test('resilient list decoding skips malformed entries', () {
    final decoded = InitializeResponse.decode(<String, Object?>{
      'protocolVersion': 1,
      'authMethods': <Object?>[42, false],
    });

    expect(decoded.value.authMethods, isEmpty);
    expect(decoded.issues, hasLength(2));
    expect(decoded.issues.first.displayPath, r'$.authMethods[0]');
  });

  test('update fields preserve omitted null and set patch states', () {
    final ToolCallUpdate omitted = ToolCallUpdate.decode(<String, Object?>{
      'toolCallId': 'call-1',
    }).value;
    final ToolCallUpdate cleared = ToolCallUpdate.decode(<String, Object?>{
      'toolCallId': 'call-1',
      'title': null,
      'rawInput': null,
    }).value;
    final ToolCallUpdate set = ToolCallUpdate.decode(<String, Object?>{
      'toolCallId': 'call-1',
      'title': 'Reading',
      'rawInput': <String, Object?>{'path': '/workspace/readme.md'},
    }).value;

    expect(omitted.title, const AcpPatch<String>.unchanged());
    expect(omitted.rawInput.isUnchanged, isTrue);
    expect(cleared.title, const AcpPatch<String>.clear());
    expect(cleared.rawInput.isClear, isTrue);
    expect(set.title.valueOrNull, 'Reading');
    expect(set.rawInput.valueOrNull?.toObject(), <String, Object?>{
      'path': '/workspace/readme.md',
    });
    expect(omitted.toJson(), isNot(contains('title')));
    expect(cleared.toJson(), containsPair('title', null));
  });
}
