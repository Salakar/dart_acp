import 'dart:convert';
import 'dart:math';

import 'package:dart_acp_sdk/src/common/json_value.dart';
import 'package:dart_acp_sdk/src/json_rpc/id.dart';
import 'package:test/test.dart';

void main() {
  test('seeded recursive JSON values round-trip with deep equality', () {
    const seeds = <int>[2, 17, 0x414350, 0x7fffffff];
    for (final seed in seeds) {
      final random = Random(seed);
      for (var caseIndex = 0; caseIndex < 250; caseIndex += 1) {
        final source = _jsonValue(random, depth: 0);
        final value = AcpJsonValue.fromObject(source);
        final wireRoundTrip = jsonDecode(jsonEncode(value.toObject()));
        final decoded = AcpJsonValue.fromObject(wireRoundTrip);

        expect(
          decoded,
          value,
          reason: 'seed=$seed case=$caseIndex source=$source',
        );
        expect(
          decoded.hashCode,
          value.hashCode,
          reason: 'equal hashes seed=$seed case=$caseIndex',
        );
      }
    }
  });

  test('JSON collection budget and depth fail without partial acceptance', () {
    final deeplyNested = <Object?>[
      <Object?>[
        <Object?>[
          <String, Object?>{'value': true},
        ],
      ],
    ];
    expect(
      () => AcpJsonValue.fromObject(deeplyNested, maxDepth: 2),
      throwsFormatException,
    );
    expect(
      () => AcpJsonValue.fromObject(<Object?>[
        <Object?>[1, 2],
        <Object?>[3, 4],
      ], maxCollectionEntries: 5),
      throwsFormatException,
    );
    expect(
      AcpJsonValue.fromObject(<Object?>[
        <Object?>[1, 2],
        <Object?>[3, 4],
      ], maxCollectionEntries: 6),
      isA<AcpJsonArray>(),
    );
  });

  test('string, signed integer, and null request IDs never collide', () {
    final ids = <JsonRpcId>{const JsonRpcId.nullValue()};
    for (var value = -1000; value <= 1000; value += 1) {
      ids
        ..add(JsonRpcId.number(value))
        ..add(JsonRpcId.string('$value'));
    }
    expect(ids, hasLength(4003));
    expect(ids.map((id) => id.correlationKey).toSet(), hasLength(ids.length));
  });
}

Object? _jsonValue(Random random, {required int depth}) {
  final scalarOnly = depth >= 5;
  final choice = random.nextInt(scalarOnly ? 5 : 7);
  return switch (choice) {
    0 => null,
    1 => random.nextBool(),
    2 => random.nextInt(2000000) - 1000000,
    3 => (random.nextInt(2000000) - 1000000) / 100,
    4 => _randomString(random),
    5 => <Object?>[
      for (var index = 0; index < random.nextInt(6); index += 1)
        _jsonValue(random, depth: depth + 1),
    ],
    _ => <String, Object?>{
      for (var index = 0; index < random.nextInt(6); index += 1)
        'k${index}_${random.nextInt(10)}': _jsonValue(random, depth: depth + 1),
    },
  };
}

String _randomString(Random random) {
  const fragments = <String>[
    '',
    'ascii',
    'é',
    '😀',
    'नमस्ते',
    '\u0000',
    '\n',
    r'\quoted"',
  ];
  return List<String>.generate(
    random.nextInt(6),
    (_) => fragments[random.nextInt(fragments.length)],
  ).join();
}
