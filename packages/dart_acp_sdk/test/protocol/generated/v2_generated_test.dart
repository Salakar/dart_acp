import 'package:dart_acp_sdk/src/protocol/method.dart';
import 'package:dart_acp_sdk/src/protocol/v2/generated/stable/method_descriptors.dart';
import 'package:dart_acp_sdk/src/protocol/v2/generated/stable/models.dart';
import 'package:test/test.dart';

void main() {
  test('v2 descriptors stay in the draft baseline lane', () {
    expect(initializeMethod.protocol, AcpProtocolGeneration.v2);
    expect(initializeMethod.stability, AcpMethodStability.draft);
    expect(
      v2StableMethodDescriptors,
      everyElement(
        isA<AcpMethodDescriptorBase>().having(
          (AcpMethodDescriptorBase descriptor) => descriptor.stability,
          'stability',
          AcpMethodStability.draft,
        ),
      ),
    );
  });

  test('v2 baseline session capability paths match sender semantics', () {
    const sessionMethods = <AcpMethodDescriptorBase>[
      sessionNewMethod,
      sessionListMethod,
      sessionResumeMethod,
      sessionCloseMethod,
      sessionPromptMethod,
      sessionCancelMethod,
      sessionSetConfigOptionMethod,
    ];

    expect(
      sessionMethods,
      everyElement(
        isA<AcpMethodDescriptorBase>().having(
          (AcpMethodDescriptorBase descriptor) => descriptor.capabilityPath,
          'capabilityPath',
          'agentCapabilities.session',
        ),
      ),
    );
    expect(
      sessionDeleteMethod.capabilityPath,
      'agentCapabilities.session.delete',
    );
    expect(sessionRequestPermissionMethod.capabilityPath, isNull);
    expect(sessionUpdateMethod.capabilityPath, isNull);
    expect(authLoginMethod.capabilityPath, 'agentCapabilities.authMethods');
    expect(authLogoutMethod.capabilityPath, 'agentCapabilities.authMethods');
  });

  test('open tagged unions preserve extension fields safely', () {
    final SessionUpdate value = sessionUpdateCodec.decode(<String, Object?>{
      'sessionUpdate': '_vendor/progress',
      'percentage': 42,
      '__proto__': <String, Object?>{'polluted': true},
    });

    expect(value, isA<SessionUpdateCustom>());
    expect(value.toJson(), containsPair('percentage', 42));
    expect(value.toJson(), isNot(contains('__proto__')));
    expect(value.toJson(), containsPair('sessionUpdate', '_vendor/progress'));
  });

  test('removed environment-variable auth does not leak into v2 inventory', () {
    expect(schemaDefinitionNames, isNot(contains('AuthEnvVar')));
    expect(schemaDefinitionNames, isNot(contains('AuthMethodEnvVar')));
    expect(schemaDefinitionNames, isNot(contains('TerminalAuthCapabilities')));
  });

  test('schema formats use validated web-safe value types', () {
    final Icon icon = iconCodec.decode(<String, Object?>{
      'src': 'https://example.test/icon.svg',
    });
    final decodedSession = SessionInfo.decode(<String, Object?>{
      'sessionId': 'session-1',
      'cwd': '/workspace',
      'updatedAt': 'not-a-date',
    });

    expect(icon.src, Uri.parse('https://example.test/icon.svg'));
    expect(
      () => iconCodec.decode(<String, Object?>{'src': 'relative/icon.svg'}),
      throwsFormatException,
    );
    expect(
      () => absolutePathCodec.decode('relative/path'),
      throwsFormatException,
    );
    expect(decodedSession.value.updatedAt, isNull);
    expect(decodedSession.issues, hasLength(1));
  });
}
