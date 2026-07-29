import 'package:dart_acp_sdk/src/common/bounded_json.dart';
import 'package:test/test.dart';

void main() {
  test('enforces structural depth without counting brackets in strings', () {
    expect(
      decodeBoundedJson(
        '{"text":"[{\\"nested\\":true}]","value":[{}]}',
        maximumNestingDepth: 3,
      ),
      <String, Object?>{
        'text': '[{"nested":true}]',
        'value': <Object?>[<String, Object?>{}],
      },
    );
    expect(
      () => decodeBoundedJson('{"value":[[{}]]}', maximumNestingDepth: 3),
      throwsFormatException,
    );
  });

  test('rejects a nonpositive nesting limit', () {
    expect(
      () => decodeBoundedJson('{}', maximumNestingDepth: 0),
      throwsArgumentError,
    );
  });
}
