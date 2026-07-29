import 'dart:async';
import 'dart:io';

import 'package:dart_acp_sdk/dart_acp_sdk.dart' as v1;
import 'package:dart_acp_sdk/experimental/protocol_router.dart';
import 'package:dart_acp_sdk/experimental/v2.dart' as v2;

Future<void> main(List<String> arguments) async {
  final stableSessionId = v1.SessionId('stable-session');
  final stableAgent =
      v1.AcpAgentApp.v1(
            implementation: v1.Implementation(
              name: 'dual-version-agent',
              version: '1.0.0',
            ),
            capabilities: v1.AgentCapabilities.fromJson(<String, Object?>{}),
          )
          .onNewSession(
            (_) => v1.NewSessionResponse(sessionId: stableSessionId),
          )
          .onPrompt(
            (_) => v1.PromptResponse(stopReason: v1.StopReason.endTurn),
          );

  final draftSessionId = v2.SessionId('draft-session');
  final draftAgent =
      v2.AcpV2AgentApp(
            implementation: v2.Implementation(
              name: 'dual-version-agent',
              version: '1.0.0',
            ),
            capabilities: v2.AgentCapabilities(
              session: v2.SessionCapabilities(),
            ),
          )
          .onNewSession((_) => v2.NewSessionResponse(sessionId: draftSessionId))
          .onPrompt((context) async {
            await context.client.updateSession(
              v2.UpdateSessionNotification(
                sessionId: draftSessionId,
                update: v2.SessionUpdateAgentMessageChunk(
                  v2.ContentChunk(
                    messageId: v2.MessageId('welcome'),
                    content: v2.ContentBlockText(
                      v2.TextContent(text: 'Hello from draft ACP v2.'),
                    ),
                  ),
                ),
              ),
            );
            unawaited(
              Future<void>(() async {
                await context.client.updateSession(
                  v2.UpdateSessionNotification(
                    sessionId: draftSessionId,
                    update: v2.SessionUpdateStateUpdate(
                      v2.StateUpdateIdle(
                        v2.IdleStateUpdate(
                          stopReason: const v2.AcpPatch<v2.StopReason>.set(
                            v2.StopReason.endTurn,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
            return v2.PromptResponse();
          });

  final router = AcpProtocolRouter(v1: stableAgent, v2: draftAgent);
  if (arguments.contains('--smoke')) {
    await _runRouterSmoke(router);
    stdout.writeln('dual-version router smoke passed');
    return;
  }
  stderr.writeln('Serving ACP v1 and draft v2 on stdio');
  final connection = router.connect(v1.AcpStdioTransport.connect());
  await connection.closed;
}

Future<void> _runRouterSmoke(AcpProtocolRouter router) async {
  for (final version in const <int>[1, 2]) {
    final pair = v1.acpInProcessTransportPair<Object?>();
    final connection = router.connect(pair.left);
    final responses = StreamIterator<Object?>(pair.right.readable);
    try {
      await pair.right.writable.write(_initializeRequest(version));
      if (!await responses.moveNext().timeout(const Duration(seconds: 5))) {
        throw StateError('Router closed before v$version initialization');
      }
      final response = (responses.current as Map<Object?, Object?>)
          .cast<String, Object?>();
      final result = (response['result'] as Map<Object?, Object?>)
          .cast<String, Object?>();
      if (result['protocolVersion'] != version) {
        throw StateError(
          'Router selected ${result['protocolVersion']} for requested v$version',
        );
      }
    } finally {
      await pair.right.writable.close();
      connection.close();
      await connection.closed;
      await responses.cancel();
    }
  }
}

Map<String, Object?> _initializeRequest(int version) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': version,
  'method': 'initialize',
  'params': <String, Object?>{
    'protocolVersion': version,
    if (version == 1) ...<String, Object?>{
      'clientInfo': <String, Object?>{
        'name': 'smoke-client',
        'version': '1.0.0',
      },
      'clientCapabilities': <String, Object?>{},
    } else ...<String, Object?>{
      'info': <String, Object?>{'name': 'smoke-client', 'version': '1.0.0'},
      'capabilities': <String, Object?>{},
    },
  },
};
