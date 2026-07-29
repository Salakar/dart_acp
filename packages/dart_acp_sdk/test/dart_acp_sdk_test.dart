import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('stable barrel composes typed v1 apps and transports', () {
    final implementation = Implementation(name: 'test', version: '1.0.0');
    final pair = acpInProcessTransportPair<Object?>();
    final method = acpCustomNotificationMethod<AcpJsonObject>(
      name: '_test/ping',
      direction: AcpMethodDirection.clientToAgent,
      paramsCodec: _JsonObjectCodec(),
    );

    expect(implementation.name, 'test');
    expect(pair.left, isA<AcpDuplexStream<Object?>>());
    expect(method.protocol, AcpProtocolGeneration.v1);
    expect(AcpStdioTransport.isSupported, isA<bool>());
  });
}

final class _JsonObjectCodec implements AcpCodec<AcpJsonObject> {
  @override
  AcpJsonObject decode(Object? value) =>
      AcpJsonValue.fromObject(value) as AcpJsonObject;

  @override
  Object? encode(AcpJsonObject value) => value.toObject();
}
