import 'dart:convert';

import 'package:dart_acp_sdk/src/common/json_value.dart';
import 'package:dart_acp_sdk/src/protocol/method.dart';
import 'package:test/test.dart';

/// Expected handling for the generated unknown-property sentinel.
enum AcpUnknownBehavior {
  /// The case has no object unknown-field assertion.
  none,

  /// A closed generated model drops the sentinel.
  dropped,

  /// An explicit open boundary preserves the sentinel.
  preserved,
}

/// One executable generated conformance case.
final class AcpConformanceCase {
  /// Creates a conformance case.
  const AcpConformanceCase(this.id, this._body);

  /// Stable, globally unique case identifier.
  final String id;
  final void Function() _body;

  /// Executes this case.
  void run() => _body();
}

/// Creates a codec decode/encode/redecode exercise.
AcpConformanceCase codecCase<T>(
  String id,
  AcpCodec<T> codec,
  String fixtureJson, {
  Object? Function(Object?)? directDecode,
  AcpUnknownBehavior unknownBehavior = AcpUnknownBehavior.none,
  bool prototypeDropped = false,
  List<String> absentFields = const <String>[],
  List<String> nullFields = const <String>[],
  List<String> presentFields = const <String>[],
  String? listField,
  int? listLength,
}) => AcpConformanceCase(id, () {
  final Object? fixture = jsonDecode(fixtureJson);
  final T value = codec.decode(fixture);
  directDecode?.call(fixture);
  final Object? encoded = codec.encode(value);
  final Object? jsonRoundTrip = jsonDecode(jsonEncode(encoded));
  final T decodedAgain = codec.decode(jsonRoundTrip);

  if (value is AcpJsonEncodable) {
    final Object? acpEncoded = value.toAcpJson().toObject();
    codec.decode(jsonDecode(jsonEncode(acpEncoded)));
  }
  if (value is Iterable<Object?>) {
    value.toList(growable: false);
  }
  expect(value == decodedAgain, isA<bool>(), reason: id);
  expect(value.hashCode, isA<int>(), reason: id);

  if (unknownBehavior != AcpUnknownBehavior.none) {
    final Map<String, Object?> object = _object(encoded, id);
    switch (unknownBehavior) {
      case AcpUnknownBehavior.none:
        break;
      case AcpUnknownBehavior.dropped:
        expect(object, isNot(contains('__acp_unknown_fixture__')), reason: id);
      case AcpUnknownBehavior.preserved:
        expect(
          object,
          containsPair('__acp_unknown_fixture__', 'preserved'),
          reason: id,
        );
    }
  }
  if (prototypeDropped) {
    expect(_object(encoded, id), isNot(contains('__proto__')), reason: id);
  }
  if (absentFields.isNotEmpty) {
    final Map<String, Object?> object = _object(encoded, id);
    for (final String field in absentFields) {
      expect(object, isNot(contains(field)), reason: '$id field=$field');
    }
  }
  if (nullFields.isNotEmpty) {
    final Map<String, Object?> object = _object(encoded, id);
    for (final String field in nullFields) {
      expect(object, containsPair(field, null), reason: '$id field=$field');
    }
  }
  if (presentFields.isNotEmpty) {
    final Map<String, Object?> object = _object(encoded, id);
    for (final String field in presentFields) {
      expect(object, contains(field), reason: '$id field=$field');
    }
  }
  if (listField != null) {
    final Object? list = _object(encoded, id)[listField];
    expect(list, isA<List<Object?>>(), reason: '$id field=$listField');
    expect(
      (list! as List<Object?>),
      hasLength(listLength!),
      reason: '$id field=$listField',
    );
  }
});

/// Creates a case whose codec must reject the fixture.
AcpConformanceCase rejectingCodecCase<T>(
  String id,
  AcpCodec<T> codec,
  String fixtureJson,
) => AcpConformanceCase(id, () {
  expect(
    () => codec.decode(jsonDecode(fixtureJson)),
    throwsA(anything),
    reason: id,
  );
});

/// Creates a descriptor metadata and registry-identity exercise.
AcpConformanceCase descriptorCase<P, R>(
  String id,
  AcpMethodDescriptor<P, R> descriptor,
  AcpMethodRegistry registry, {
  required String name,
  required String paramsDefinition,
  required String? resultDefinition,
  required AcpMethodDirection direction,
  required AcpMethodKind kind,
  required String paramsFixtureJson,
  required String resultFixtureJson,
}) => AcpConformanceCase(id, () {
  expect(descriptor.name, name, reason: id);
  expect(descriptor.paramsDefinition, paramsDefinition, reason: id);
  expect(descriptor.resultDefinition, resultDefinition, reason: id);
  expect(descriptor.direction, direction, reason: id);
  expect(descriptor.kind, kind, reason: id);
  expect(
    registry.lookup(name: name, direction: direction, kind: kind),
    same(descriptor),
    reason: id,
  );
  final P params = descriptor.paramsCodec.decode(jsonDecode(paramsFixtureJson));
  descriptor.paramsCodec.decode(
    jsonDecode(jsonEncode(descriptor.paramsCodec.encode(params))),
  );
  final R result = descriptor.resultCodec.decode(jsonDecode(resultFixtureJson));
  descriptor.resultCodec.decode(
    jsonDecode(jsonEncode(descriptor.resultCodec.encode(result))),
  );
});

/// Runs a complete lane and annotates failures with the generated case ID.
void runConformanceCases(Iterable<AcpConformanceCase> cases) {
  final ids = <String>{};
  final failures = <String>[];
  for (final AcpConformanceCase value in cases) {
    expect(ids.add(value.id), isTrue, reason: 'duplicate case ${value.id}');
    try {
      value.run();
    } on Object catch (error) {
      failures.add('${value.id}: $error');
    }
  }
  if (failures.isNotEmpty) {
    fail(
      '${failures.length} conformance case(s) failed:\n'
      '${failures.take(40).join('\n')}',
    );
  }
}

Map<String, Object?> _object(Object? value, String id) {
  if (value is! Map<Object?, Object?>) {
    throw StateError('$id encoded a non-object value');
  }
  return <String, Object?>{
    for (final MapEntry<Object?, Object?> entry in value.entries)
      if (entry.key is String) entry.key! as String: entry.value,
  };
}
