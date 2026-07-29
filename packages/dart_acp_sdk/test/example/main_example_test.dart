import 'package:test/test.dart';

import '../../example/main.dart' as example;

void main() {
  test('in-process example completes with deterministic output', () async {
    final output = await example.runInProcessExample().timeout(
      const Duration(seconds: 5),
    );

    expect(output, <String>[
      'client: initialized v1',
      'agent: session/new /workspace',
      'update: plan in_progress',
      'update: tool read-readme in_progress',
      'client: permission read-readme',
      'update: tool read-readme completed',
      'update: text "Hello from "',
      'update: text "ACP."',
      'update: usage 24/4096',
      'client: prompt end_turn "Hello from ACP."',
      'agent: session/cancel example-session',
      'client: prompt cancelled',
      'client: error -32603',
      'agent: session/close example-session',
      'client: closed',
    ]);
  });
}
