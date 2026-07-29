import 'dart:async';
import 'dart:math';

import 'package:dart_acp_sdk/src/json_rpc/cancellation.dart';
import 'package:dart_acp_sdk/src/json_rpc/connection.dart';
import 'package:dart_acp_sdk/src/json_rpc/handler.dart';
import 'package:dart_acp_sdk/src/json_rpc/params.dart';
import 'package:test/test.dart';

import '../json_rpc/test_stream_pair.dart';

void main() {
  test(
    'seeded response, cancellation, and close races always settle',
    () async {
      const seeds = <int>[3, 19, 0x414350, 0x6fffffff];
      for (final seed in seeds) {
        await _runRace(seed).timeout(
          const Duration(seconds: 5),
          onTimeout: () =>
              throw TimeoutException('race seed=$seed did not settle'),
        );
      }
    },
  );
}

Future<void> _runRace(int seed) async {
  const requestCount = 40;
  final random = Random(seed);
  final pair = TestStreamPair.create();
  final responders = <int, JsonRpcRequestResponder>{};
  final allReceived = Completer<void>();
  final server = JsonRpcConnectionBuilder()
      .onRequest<int>(
        method: '_property/race',
        parse: (value) => (value! as Map<String, Object?>)['index']! as int,
        handler: (index, responder, _) {
          responders[index] = responder;
          if (responders.length == requestCount) {
            allReceived.complete();
          }
          return const JsonRpcHandled();
        },
      )
      .connect(stream: pair.right);
  final client = JsonRpcConnection(stream: pair.left);
  final cancellations = List<CancellationSource>.generate(
    requestCount,
    (_) => CancellationSource(),
  );
  final outcomes = <int, Object>{};

  final requests = <Future<void>>[
    for (var index = 0; index < requestCount; index += 1)
      client
          .sendRequest<int>(
            method: '_property/race',
            params: JsonRpcParams.value(<String, Object?>{'index': index}),
            cancellationToken: cancellations[index].token,
          )
          .then<void>(
            (value) => outcomes[index] = value,
            onError: (Object error, StackTrace _) => outcomes[index] = error,
          ),
  ];
  await allReceived.future;

  final operations = <Future<void> Function()>[];
  for (var index = 0; index < requestCount; index += 1) {
    if (random.nextBool()) {
      operations.add(() async {
        cancellations[index].cancel('seed=$seed index=$index');
        await Future<void>.delayed(Duration.zero);
      });
    }
    operations.add(() async {
      await Future<void>.delayed(Duration(microseconds: random.nextInt(50)));
      try {
        await responders[index]!.respond(index);
      } on Object {
        // A close may win. Settlement is asserted through the client future.
      }
    });
  }
  operations
    ..add(() async {
      await Future<void>.delayed(Duration(microseconds: random.nextInt(50)));
      client.close(StateError('seed=$seed close'));
    })
    ..shuffle(random);

  await Future.wait<void>(<Future<void>>[
    for (final operation in operations) operation(),
  ]);
  await Future.wait<void>(requests);

  expect(
    outcomes,
    hasLength(requestCount),
    reason:
        'seed=$seed missing=${<int>[for (var index = 0; index < requestCount; index += 1)
          if (!outcomes.containsKey(index)) index]}',
  );
  for (var index = 0; index < requestCount; index += 1) {
    expect(
      outcomes[index],
      anyOf(index, isA<StateError>()),
      reason: 'seed=$seed index=$index outcome=${outcomes[index]}',
    );
  }

  server.close();
  await pair.close();
}
