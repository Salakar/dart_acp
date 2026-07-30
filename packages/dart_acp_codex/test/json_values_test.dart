import 'package:dart_acp_codex/src/app_server/json_values.dart';
import 'package:dart_acp_codex/src/runtime/diagnostics.dart';
import 'package:test/test.dart';

void main() {
  test('JSON objects are deeply immutable and detached', () {
    final nested = <Object?>['value'];
    final source = <Object?, Object?>{
      'name': 'adapter',
      'nested': <Object?, Object?>{'items': nested},
    };
    final value = CodexJsonObject.from(source);
    nested.add('mutated');
    source['name'] = 'changed';

    expect(value.requireString('name'), 'adapter');
    expect(value.requireObject('nested').requireList('items'), <Object?>[
      'value',
    ]);
    expect(
      () => value.requireObject('nested').requireList('items').add('x'),
      throwsUnsupportedError,
    );
  });

  test('JSON validation reports malformed values safely', () {
    expect(
      () => CodexJsonObject.from(<Object?, Object?>{1: 'bad'}),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => CodexJsonObject.from(<Object?, Object?>{'number': double.infinity}),
      throwsA(isA<CodexProtocolException>()),
    );
  });

  test('preview is bounded', () {
    final value = CodexJsonObject.from(<Object?, Object?>{
      'text': 'abcdefghijklmnopqrstuvwxyz',
    });
    expect(value.preview(maximumCharacters: 8).length, 9);
    expect(
      value.preview(maximumCharacters: 100),
      contains('abcdefghijklmnopqrstuvwxyz'),
    );
    expect(() => value.preview(maximumCharacters: -1), throwsArgumentError);
  });

  test('typed readers distinguish absent, null, valid, and invalid values', () {
    final value = CodexJsonObject.from(<Object?, Object?>{
      'string': 'value',
      'bool': true,
      'number': 1.5,
      'integer': 2.0,
      'object': <String, Object?>{'nested': true},
      'list': <Object?>[1, 'two'],
      'null': null,
      'wrong': <Object?>[],
    });

    expect(value.containsKey('null'), isTrue);
    expect(value.containsKey('absent'), isFalse);
    expect(value.optionalString('absent'), isNull);
    expect(value.optionalString('null'), isNull);
    expect(value.requireString('string'), 'value');
    expect(value.requireBool('bool'), isTrue);
    expect(value.optionalNumber('number'), 1.5);
    expect(value.optionalInt('integer'), 2);
    expect(value.requireObject('object').requireBool('nested'), isTrue);
    expect(value.optionalObject('object'), isNotNull);
    expect(value.optionalObject('null'), isNull);
    expect(value.requireList('list'), <Object?>[1, 'two']);

    expect(
      () => value.requireString('wrong'),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => value.optionalString('wrong'),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => value.requireBool('wrong'),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => value.optionalNumber('wrong'),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => CodexJsonObject.from(<Object?, Object?>{
        'fraction': 1.5,
      }).optionalInt('fraction'),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => value.requireObject('wrong'),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => value.optionalObject('wrong'),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => value.requireList('string'),
      throwsA(isA<CodexProtocolException>()),
    );
  });

  test('validation rejects unsupported nested values and detaches toJson', () {
    expect(
      () => CodexJsonObject.from(<Object?, Object?>{
        'nested': <Object?>[DateTime(2026)],
      }),
      throwsA(isA<CodexProtocolException>()),
    );
    final value = CodexJsonObject.from(<Object?, Object?>{
      'nested': <String, Object?>{'value': 1},
    });
    final detached = value.toJson();
    expect(() => detached['other'] = true, throwsUnsupportedError);
    expect(
      () => (detached['nested']! as Map<String, Object?>)['value'] = 2,
      throwsUnsupportedError,
    );
  });
}
