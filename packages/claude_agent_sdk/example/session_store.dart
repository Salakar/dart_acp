import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';

Future<void> main() async {
  const sessionId = '11111111-1111-4111-8111-111111111111';
  final store = InMemorySessionStore();
  final projectKey = projectKeyForDirectory();
  await store.append(
    const SessionKey(projectKey: 'example', sessionId: sessionId),
    [
      {
        'type': 'user',
        'uuid': '22222222-2222-4222-8222-222222222222',
        'sessionId': sessionId,
        'message': {'role': 'user', 'content': 'Hello'},
      },
    ],
  );

  final loaded = await store.load(
    const SessionKey(projectKey: 'example', sessionId: sessionId),
  );
  stdout.writeln(
    'Stored ${loaded?.length ?? 0} entry for project key $projectKey.',
  );
}
