import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

Future<void> main() async {
  for (final line in await runInProcessExample()) {
    // Example output belongs on stdout; stdio transport examples use stderr.
    // ignore: avoid_print
    print(line);
  }
}

/// Runs a deterministic stable-v1 agent/client conversation in one process.
Future<List<String>> runInProcessExample() async {
  final output = <String>[];
  final sessionId = SessionId('example-session');
  final toolCallId = ToolCallId('read-readme');
  final allowOnceId = PermissionOptionId('allow-once');
  final cancelPromptStarted = Completer<void>();
  final cancelObserved = Completer<void>();
  var promptNumber = 0;

  final agent =
      AcpAgentApp.v1(
            implementation: Implementation(
              name: 'example-agent',
              version: '1.0.0',
            ),
            capabilities: AgentCapabilities(
              loadSession: false,
              promptCapabilities: PromptCapabilities(
                image: false,
                audio: false,
                embeddedContext: false,
              ),
              mcpCapabilities: McpCapabilities(http: false, sse: false),
              sessionCapabilities: SessionCapabilities(
                close: SessionCloseCapabilities(),
              ),
              auth: AgentAuthCapabilities(),
            ),
          )
          .onNewSession((context) {
            output.add('agent: session/new ${context.params.cwd}');
            return NewSessionResponse(sessionId: sessionId);
          })
          .onPrompt((context) async {
            promptNumber += 1;
            if (promptNumber == 2) {
              cancelPromptStarted.complete();
              await cancelObserved.future;
              return PromptResponse(stopReason: StopReason.cancelled);
            }
            if (promptNumber == 3) {
              throw JsonRpcRequestException.internalError(
                data: <String, Object?>{'kind': 'example'},
              );
            }

            await context.client.updateSession(
              SessionNotification(
                sessionId: sessionId,
                update: SessionUpdatePlan(
                  Plan(
                    entries: <PlanEntry>[
                      PlanEntry(
                        content: 'Read the project README',
                        priority: PlanEntryPriority.high,
                        status: PlanEntryStatus.inProgress,
                      ),
                    ],
                  ),
                ),
              ),
            );
            await context.client.updateSession(
              SessionNotification(
                sessionId: sessionId,
                update: SessionUpdateToolCall(
                  ToolCall(
                    toolCallId: toolCallId,
                    title: 'Read README.md',
                    kind: ToolKind.read,
                    status: ToolCallStatus.inProgress,
                  ),
                ),
              ),
            );

            final permission = await context.client.requestPermission(
              RequestPermissionRequest(
                sessionId: sessionId,
                toolCall: ToolCallUpdate(
                  toolCallId: toolCallId,
                  status: const AcpPatch<ToolCallStatus>.set(
                    ToolCallStatus.inProgress,
                  ),
                ),
                options: <PermissionOption>[
                  PermissionOption(
                    optionId: allowOnceId,
                    name: 'Allow once',
                    kind: PermissionOptionKind.allowOnce,
                  ),
                  PermissionOption(
                    optionId: PermissionOptionId('reject-once'),
                    name: 'Reject',
                    kind: PermissionOptionKind.rejectOnce,
                  ),
                ],
              ),
            );
            final outcome = permission.outcome;
            if (outcome is! RequestPermissionOutcomeSelected ||
                outcome.value.optionId != allowOnceId) {
              return PromptResponse(stopReason: StopReason.refusal);
            }

            await context.client.updateSession(
              SessionNotification(
                sessionId: sessionId,
                update: SessionUpdateToolCallUpdate(
                  ToolCallUpdate(
                    toolCallId: toolCallId,
                    status: const AcpPatch<ToolCallStatus>.set(
                      ToolCallStatus.completed,
                    ),
                  ),
                ),
              ),
            );
            for (final text in <String>['Hello from ', 'ACP.']) {
              await context.client.updateSession(
                SessionNotification(
                  sessionId: sessionId,
                  update: SessionUpdateAgentMessageChunk(
                    ContentChunk(
                      content: ContentBlockText(TextContent(text: text)),
                    ),
                  ),
                ),
              );
            }
            await context.client.updateSession(
              SessionNotification(
                sessionId: sessionId,
                update: SessionUpdateUsageUpdate(
                  UsageUpdate(
                    used: AcpUint64(BigInt.from(24)),
                    size: AcpUint64(BigInt.from(4096)),
                    cost: AcpPatch<Cost>.set(
                      Cost(amount: 0.001, currency: 'USD'),
                    ),
                  ),
                ),
              ),
            );
            return PromptResponse(stopReason: StopReason.endTurn);
          })
          .onCancelSession((context) {
            output.add(
              'agent: session/cancel ${context.params.sessionId.value}',
            );
            if (!cancelObserved.isCompleted) {
              cancelObserved.complete();
            }
          })
          .onCloseSession((context) {
            output.add(
              'agent: session/close ${context.params.sessionId.value}',
            );
            return CloseSessionResponse();
          });

  final client =
      AcpClientApp.v1(
            implementation: Implementation(
              name: 'example-client',
              version: '1.0.0',
            ),
            capabilities: ClientCapabilities(
              fs: FileSystemCapabilities(
                readTextFile: false,
                writeTextFile: false,
              ),
              terminal: false,
            ),
          )
          .onRequestPermission((context) {
            output.add(
              'client: permission ${context.params.toolCall.toolCallId.value}',
            );
            return RequestPermissionResponse(
              outcome: RequestPermissionOutcomeSelected(
                SelectedPermissionOutcome(optionId: allowOnceId),
              ),
            );
          })
          .onSessionUpdate((context) {
            output.add(_describeUpdate(context.params.update));
          });

  final pair = await client.connectWith(agent);
  try {
    output.add('client: initialized v1');
    final session = await pair.client.agent
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start();

    final completed = await session
        .prompt(
          content: <ContentBlock>[
            ContentBlockText(TextContent(text: 'Say hello')),
          ],
        )
        .collectText();
    output.add(
      'client: prompt ${completed.response.stopReason.value} '
      '"${completed.text}"',
    );

    final cancelled = session.prompt(
      content: <ContentBlock>[
        ContentBlockText(TextContent(text: 'Wait until cancelled')),
      ],
    );
    await cancelPromptStarted.future;
    await cancelled.cancel();
    output.add(
      'client: prompt ${(await cancelled.completed).stopReason.value}',
    );

    final failed = session.prompt(
      content: <ContentBlock>[
        ContentBlockText(TextContent(text: 'Demonstrate an error')),
      ],
    );
    try {
      await failed.completed;
    } on JsonRpcRequestException catch (error) {
      output.add('client: error ${error.code}');
    }

    await session.close();
    output.add('client: closed');
  } finally {
    await pair.close();
  }
  return List<String>.unmodifiable(output);
}

String _describeUpdate(SessionUpdate update) => switch (update) {
  SessionUpdatePlan(:final value) =>
    'update: plan ${value.entries.single.status.value}',
  SessionUpdateToolCall(:final value) =>
    'update: tool ${value.toolCallId.value} ${value.status?.value}',
  SessionUpdateToolCallUpdate(:final value) =>
    'update: tool ${value.toolCallId.value} '
        '${value.status.valueOrNull?.value}',
  SessionUpdateAgentMessageChunk(
    value: ContentChunk(content: ContentBlockText(value: final text)),
  ) =>
    'update: text "${text.text}"',
  SessionUpdateUsageUpdate(:final value) =>
    'update: usage ${value.used.value}/${value.size.value}',
  _ => 'update: ${update.discriminator}',
};
