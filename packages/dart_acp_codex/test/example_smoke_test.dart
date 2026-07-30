import 'package:test/test.dart';

import '../example/main.dart' as example;

void main() {
  test('deterministic example initializes, prompts, and closes', () async {
    final lines = await example.runExample();

    expect(lines, contains('Session: example-session'));
    expect(
      lines.any((line) => line.startsWith('Permission requested:')),
      isTrue,
    );
    expect(
      lines,
      contains('Agent: Hello from the deterministic Codex backend.'),
    );
    expect(lines, contains('Stop reason: end_turn'));
  });
}
