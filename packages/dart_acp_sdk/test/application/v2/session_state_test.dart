import 'dart:convert';

import 'package:dart_acp_sdk/experimental/v2.dart';
import 'package:test/test.dart';

void main() {
  test('terminal replacement and output chunks are independent', () async {
    final agent = AcpV2AgentApp(
      implementation: Implementation(name: 'agent', version: '1'),
      capabilities: AgentCapabilities(session: SessionCapabilities()),
    ).onNewSession((_) => NewSessionResponse(sessionId: SessionId('s')));
    final client = AcpV2ClientApp(
      implementation: Implementation(name: 'client', version: '1'),
      capabilities: ClientCapabilities(),
    );
    final pair = await client.connectWith(agent);
    final session = await pair.client.agent.sessions
        .newSession(cwd: AbsolutePath('/tmp'))
        .start();
    final terminalId = TerminalId('terminal');

    final chunkObserved = session.events
        .where(
          (AcpV2SessionEvent event) =>
              event is AcpV2SessionUpdateEvent &&
              event.update is SessionUpdateTerminalOutputChunk,
        )
        .first;
    await pair.agent.client.updateSession(
      UpdateSessionNotification(
        sessionId: SessionId('s'),
        update: SessionUpdateTerminalUpdate(
          TerminalUpdate(
            terminalId: terminalId,
            output: AcpPatch<TerminalOutput>.set(
              TerminalOutput(data: base64Encode(<int>[1, 2])),
            ),
          ),
        ),
      ),
    );
    await pair.agent.client.updateSession(
      UpdateSessionNotification(
        sessionId: SessionId('s'),
        update: SessionUpdateTerminalOutputChunk(
          TerminalOutputChunk(
            terminalId: terminalId,
            data: base64Encode(<int>[3, 4]),
          ),
        ),
      ),
    );
    await chunkObserved;

    expect(session.snapshot.terminals['terminal']!.output, <int>[1, 2, 3, 4]);
    await pair.close();
  });

  test(
    'resume routes replay before response including custom variants',
    () async {
      late AcpV2AgentContext peer;
      final agent =
          AcpV2AgentApp(
            implementation: Implementation(name: 'agent', version: '1'),
            capabilities: AgentCapabilities(session: SessionCapabilities()),
          ).onConnect((connection) => peer = connection.client).onResumeSession(
            (context) async {
              await context.client.updateSession(
                UpdateSessionNotification(
                  sessionId: context.params.sessionId,
                  update: SessionUpdateStateUpdate(
                    StateUpdateCustom(
                      discriminator: '_vendor_replay',
                      payload: AcpJsonObject.fromObject(<String, Object?>{
                        'value': 7,
                      }),
                    ),
                  ),
                ),
              );
              return ResumeSessionResponse();
            },
          );
      final client = AcpV2ClientApp(
        implementation: Implementation(name: 'client', version: '1'),
        capabilities: ClientCapabilities(),
      );
      final pair = await client.connectWith(agent);
      expect(peer, isNotNull);

      final session = await pair.client.agent.sessions.resume(
        ResumeSessionRequest(
          sessionId: SessionId('s'),
          cwd: AbsolutePath('/tmp'),
          replayFrom: ReplayFromStartVariant(ReplayFromStart()),
        ),
      );
      expect(
        session.snapshot.state,
        isA<StateUpdateCustom>().having(
          (StateUpdateCustom value) => value.discriminator,
          'discriminator',
          '_vendor_replay',
        ),
      );
      await pair.close();
    },
  );
}
