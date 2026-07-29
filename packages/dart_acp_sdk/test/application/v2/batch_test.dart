import 'dart:async';

import 'package:dart_acp_sdk/experimental/v2.dart';
import 'package:test/test.dart';

const _StringCodec _stringCodec = _StringCodec();

final AcpMethodDescriptor<String, String> _slow =
    acpV2CustomRequestMethod<String, String>(
      name: '_slow',
      direction: AcpMethodDirection.clientToAgent,
      paramsCodec: _stringCodec,
      resultCodec: _stringCodec,
    );
final AcpMethodDescriptor<String, String> _fast =
    acpV2CustomRequestMethod<String, String>(
      name: '_fast',
      direction: AcpMethodDirection.clientToAgent,
      paramsCodec: _stringCodec,
      resultCodec: _stringCodec,
    );
final AcpMethodDescriptor<String, AcpNoResult> _note =
    acpV2CustomNotificationMethod<String>(
      name: '_note',
      direction: AcpMethodDirection.clientToAgent,
      paramsCodec: _stringCodec,
    );

Future<AcpV2DirectConnectionPair> _open({
  void Function()? onNote,
  AuthMethodId? authMethodId,
}) {
  final agent =
      AcpV2AgentApp(
            implementation: Implementation(name: 'agent', version: '1'),
            capabilities: AgentCapabilities(session: SessionCapabilities()),
            authMethods: <AuthMethod>[
              if (authMethodId != null)
                AuthMethodAgentVariant(
                  AuthMethodAgent(
                    methodId: authMethodId,
                    name: 'test authentication',
                  ),
                ),
            ],
          )
          .onRequest(_slow, (context) async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return 'slow:${context.params}';
          })
          .onRequest(_fast, (context) => 'fast:${context.params}')
          .onNotification(_note, (_) => onNote?.call());
  final client = AcpV2ClientApp(
    implementation: Implementation(name: 'client', version: '1'),
    capabilities: ClientCapabilities(),
  );
  return client.connectWith(agent);
}

void main() {
  group('draft-v2 heterogeneous batch', () {
    test('typed record preserves input order, not completion order', () async {
      final pair = await _open();
      final result = await (
        _slow.call('a'),
        _fast.call('b'),
      ).sendWith(pair.client.agent);

      expect(result.$1, 'slow:a');
      expect(result.$2, 'fast:b');
      await pair.close();
    });

    test('notification occupies a void record slot', () async {
      var notifications = 0;
      final pair = await _open(onNote: () => notifications++);
      final result = await (
        _fast.call('value'),
        _note.notify('event'),
      ).sendWith(pair.client.agent);

      expect(result.$1, 'fast:value');
      await Future<void>.delayed(Duration.zero);
      expect(notifications, 1);
      await pair.close();
    });

    test('rejects auth/login after it was advertised', () async {
      final methodId = AuthMethodId('test-auth');
      final pair = await _open(authMethodId: methodId);
      final batch = AcpV2Batch(<AcpV2BatchEntry<Object?>>[
        AcpV2Methods.authLogin.call(LoginAuthRequest(methodId: methodId)),
      ]);

      await expectLater(
        pair.client.agent.sendBatch(batch),
        throwsA(
          isA<ArgumentError>().having(
            (ArgumentError error) => error.message,
            'message',
            contains('lifecycle-sensitive'),
          ),
        ),
      );
      await pair.close();
    });

    test('advanced list rejects empty construction', () {
      expect(
        () => AcpV2Batch(const <AcpV2BatchEntry<Object?>>[]),
        throwsArgumentError,
      );
    });

    test('high-level builder rejects lifecycle-sensitive methods', () async {
      final pair = await _open();
      final batch = AcpV2Batch(<AcpV2BatchEntry<Object?>>[
        AcpV2Methods.prompt.call(
          PromptRequest(
            sessionId: SessionId('s'),
            prompt: const <ContentBlock>[],
          ),
        ),
      ]);

      await expectLater(
        pair.client.agent.sendBatch(batch),
        throwsArgumentError,
      );
      await pair.close();
    });
  });
}

final class _StringCodec implements AcpCodec<String> {
  const _StringCodec();

  @override
  String decode(Object? value) {
    if (value is! String) {
      throw const FormatException('expected string');
    }
    return value;
  }

  @override
  String encode(String value) => value;
}
