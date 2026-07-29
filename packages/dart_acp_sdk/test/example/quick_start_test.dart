import 'package:test/test.dart';

import '../../example/quick_start.dart' as example;

void main() {
  test('quick-start example completes with streamed text', () async {
    expect(
      await example.runQuickStartExample().timeout(const Duration(seconds: 5)),
      'Hello from Dart ACP.',
    );
  });
}
