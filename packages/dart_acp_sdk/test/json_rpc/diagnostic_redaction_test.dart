import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

import 'test_stream_pair.dart';

void main() {
  test(
    'diagnostics retain safe category and type but not raw exceptions',
    () async {
      final diagnostics = <JsonRpcDiagnostic>[];
      final input = StreamController<Object?>();
      final connection = JsonRpcConnection(
        stream: AcpDuplexStream<Object?>(
          readable: input.stream,
          writable: AcpWritable<Object?>(
            write: (_) => Future<void>.value(),
            close: () => Future<void>.value(),
          ),
        ),
        options: JsonRpcConnectionOptions(onDiagnostic: diagnostics.add),
      );

      input.addError(_SecretException('customer-token-123'));
      await connection.done;

      expect(diagnostics, hasLength(1));
      expect(diagnostics.single.error?.category, 'runtime');
      expect(diagnostics.single.error?.type, '_SecretException');
      expect(
        diagnostics.single.error.toString(),
        isNot(contains('customer-token')),
      );
      await input.close();
    },
  );

  test(
    'throwing diagnostic callbacks cannot alter protocol lifecycle',
    () async {
      final pair = TestStreamPair.create();
      final server = JsonRpcConnectionBuilder()
          .onRequest<Object?>(
            method: 'example/ping',
            parse: (Object? value) => value,
            handler: (_, JsonRpcRequestResponder responder, _) async {
              await responder.respond('pong');
              return const JsonRpcHandled();
            },
          )
          .connect(
            stream: pair.right,
            options: JsonRpcConnectionOptions(
              onDiagnostic: (_) => throw StateError('observer failed'),
            ),
          );
      final client = JsonRpcConnection(stream: pair.left);

      await pair.left.writable.write(42);
      expect(await client.sendRequest<String>(method: 'example/ping'), 'pong');

      client.close();
      server.close();
      await pair.close();
    },
  );

  test('cancellation exception details are redacted by default', () async {
    final pair = TestStreamPair.create();
    final server = JsonRpcConnectionBuilder()
        .onRequest<Object?>(
          method: 'example/cancelled',
          parse: (Object? value) => value,
          handler: (_, _, _) {
            throw const CancellationException('secret cancellation detail');
          },
        )
        .connect(stream: pair.right);
    final client = JsonRpcConnection(stream: pair.left);

    await expectLater(
      client.sendRequest<Object?>(method: 'example/cancelled'),
      throwsA(
        isA<JsonRpcRequestException>()
            .having((error) => error.code, 'code', -32800)
            .having((error) => error.data, 'redacted data', isNull),
      ),
    );

    client.close();
    server.close();
    await pair.close();
  });
}

final class _SecretException implements Exception {
  const _SecretException(this.secret);

  final String secret;

  @override
  String toString() => 'secret=$secret';
}
