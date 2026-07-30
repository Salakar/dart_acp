import 'package:test/test.dart';

import '../example/main.dart' as example;

void main() {
  test('deterministic example exercises the documented flow', () async {
    final lines = await example.runExample();
    expect(lines, contains(startsWith('Session: ')));
    expect(lines, contains('Steering: injected'));
    expect(lines, contains('Permission: Run the package tests?'));
    expect(lines, contains('Agent: I will run the requested verification.'));
    expect(lines, contains('Stop reason: end_turn'));
  });
}
