import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/common/value_types.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';
import 'package:test/test.dart';

import 'test_values.dart';

Matcher _missing(String method) => isA<AcpCapabilityUnavailableException>()
    .having(
      (AcpCapabilityUnavailableException error) => error.method,
      'method',
      method,
    )
    .having(
      (AcpCapabilityUnavailableException error) => error.capabilityPath,
      'capabilityPath',
      'agentCapabilities.sessionCapabilities.additionalDirectories',
    );

AgentCapabilities _capabilities({required bool additionalDirectories}) =>
    agentCapabilities(
      loadSession: true,
      sessions: SessionCapabilities(
        additionalDirectories: additionalDirectories
            ? SessionAdditionalDirectoriesCapabilities()
            : null,
        resume: SessionResumeCapabilities(),
      ),
    );

Future<AcpDirectConnectionPair> _connect({
  required bool additionalDirectories,
  void Function()? onNew,
  void Function()? onLoad,
  void Function()? onResume,
}) {
  final agent =
      AcpAgentApp.v1(
            implementation: implementation('agent'),
            capabilities: _capabilities(
              additionalDirectories: additionalDirectories,
            ),
          )
          .onNewSession((_) {
            onNew?.call();
            return NewSessionResponse(sessionId: SessionId('session-1'));
          })
          .onLoadSession((_) {
            onLoad?.call();
            return LoadSessionResponse();
          })
          .onResumeSession((_) {
            onResume?.call();
            return ResumeSessionResponse();
          });
  final client = AcpClientApp.v1(
    implementation: implementation('client'),
    capabilities: clientCapabilities(),
  );
  return client.connectWith(agent);
}

LoadSessionRequest _load(List<String>? additionalDirectories) =>
    LoadSessionRequest(
      mcpServers: const <McpServer>[],
      cwd: '/workspace',
      sessionId: SessionId('session-1'),
      additionalDirectories: additionalDirectories,
    );

ResumeSessionRequest _resume(List<String>? additionalDirectories) =>
    ResumeSessionRequest(
      sessionId: SessionId('session-1'),
      cwd: '/workspace',
      additionalDirectories: additionalDirectories,
    );

void main() {
  test('new, load, and resume reject unadvertised nonempty roots', () async {
    var calls = 0;
    final pair = await _connect(
      additionalDirectories: false,
      onNew: () => calls++,
      onLoad: () => calls++,
      onResume: () => calls++,
    );

    await expectLater(
      pair.client.agent
          .newSession(
            cwd: AcpAbsolutePath('/workspace'),
            additionalDirectories: <AcpAbsolutePath>[
              AcpAbsolutePath('/workspace/extra'),
            ],
          )
          .start(),
      throwsA(_missing('session/new')),
    );
    await expectLater(
      pair.client.agent.sessions.load(_load(<String>['/workspace/extra'])),
      throwsA(_missing('session/load')),
    );
    await expectLater(
      pair.client.agent.sessions.resume(_resume(<String>['/workspace/extra'])),
      throwsA(_missing('session/resume')),
    );

    expect(calls, 0);
    await pair.close();
  });

  test('empty roots remain baseline-compatible', () async {
    var calls = 0;
    final pair = await _connect(
      additionalDirectories: false,
      onNew: () => calls++,
      onLoad: () => calls++,
      onResume: () => calls++,
    );

    final created = await pair.client.agent
        .newSession(
          cwd: AcpAbsolutePath('/workspace'),
          additionalDirectories: const <AcpAbsolutePath>[],
        )
        .start();
    created.dispose();
    final loaded = await pair.client.agent.sessions.load(
      _load(const <String>[]),
    );
    loaded.dispose();
    final resumed = await pair.client.agent.sessions.resume(
      _resume(const <String>[]),
    );
    resumed.dispose();

    expect(calls, 3);
    await pair.close();
  });

  test('load and resume reject relative roots before transport', () async {
    var calls = 0;
    final pair = await _connect(
      additionalDirectories: true,
      onLoad: () => calls++,
      onResume: () => calls++,
    );

    await expectLater(
      pair.client.agent.sessions.load(
        _load(<String>['/workspace/extra', 'relative/load']),
      ),
      throwsA(
        isA<FormatException>().having(
          (FormatException error) => error.message,
          'message',
          contains('relative/load'),
        ),
      ),
    );
    await expectLater(
      pair.client.agent.sessions.resume(_resume(<String>['relative/resume'])),
      throwsA(
        isA<FormatException>().having(
          (FormatException error) => error.message,
          'message',
          contains('relative/resume'),
        ),
      ),
    );

    expect(calls, 0);
    await pair.close();
  });

  test('load and resume accept supported absolute root forms', () async {
    var calls = 0;
    final pair = await _connect(
      additionalDirectories: true,
      onLoad: () => calls++,
      onResume: () => calls++,
    );
    final roots = <String>[
      '/workspace/extra',
      r'C:\workspace\extra',
      r'\\server\share',
    ];

    final loaded = await pair.client.agent.sessions.load(_load(roots));
    loaded.dispose();
    final resumed = await pair.client.agent.sessions.resume(_resume(roots));
    resumed.dispose();

    expect(calls, 2);
    await pair.close();
  });

  test('advertised nonempty roots reach all lifecycle handlers', () async {
    var calls = 0;
    final pair = await _connect(
      additionalDirectories: true,
      onNew: () => calls++,
      onLoad: () => calls++,
      onResume: () => calls++,
    );

    final created = await pair.client.agent
        .newSession(
          cwd: AcpAbsolutePath('/workspace'),
          additionalDirectories: <AcpAbsolutePath>[
            AcpAbsolutePath('/workspace/extra'),
          ],
        )
        .start();
    created.dispose();
    final loaded = await pair.client.agent.sessions.load(
      _load(<String>['/workspace/extra']),
    );
    loaded.dispose();
    final resumed = await pair.client.agent.sessions.resume(
      _resume(<String>['/workspace/extra']),
    );
    resumed.dispose();

    expect(calls, 3);
    await pair.close();
  });
}
