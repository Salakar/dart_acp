import 'dart:async';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:test/test.dart';

import 'helpers/fake_transport.dart';

const _assistant = <String, Object?>{
  'type': 'assistant',
  'message': {
    'id': 'msg_1',
    'model': 'test-model',
    'content': [
      {'type': 'text', 'text': 'hello'},
    ],
  },
  'session_id': 'session',
};

const _result = <String, Object?>{
  'type': 'result',
  'subtype': 'success',
  'duration_ms': 10,
  'duration_api_ms': 5,
  'is_error': false,
  'num_turns': 1,
  'session_id': 'session',
  'result': 'hello',
};

void main() {
  group('query', () {
    test('sends typed input and yields decoded messages', () async {
      final transport = FakeTransport();
      transport.onWrite = (message) {
        transport.autoRespondToControl(message);
        if (message['type'] == 'user') {
          scheduleMicrotask(() {
            transport.emit(_assistant);
            transport.emit(_result);
          });
        }
      };

      final messages = await query('hi', transport: transport).toList();

      expect(messages, hasLength(2));
      expect(messages.first, isA<AssistantMessage>());
      expect(
        (messages.first as AssistantMessage).content.single,
        isA<TextBlock>(),
      );
      expect(messages.last, isA<ResultMessage>());
      expect(transport.inputEnded, isTrue);
      expect(transport.closed, isTrue);
    });
  });

  group('startup', () {
    test(
      'pre-warms once and sends the prompt to the initialized process',
      () async {
        final transport = FakeTransport();
        transport.onWrite = (message) {
          transport.autoRespondToControl(message);
          if (message['type'] == 'user') {
            scheduleMicrotask(() {
              transport.emit(_assistant);
              transport.emit(_result);
            });
          }
        };

        final warm = await startup(
          transport: transport,
          initializeTimeout: const Duration(seconds: 2),
        );
        expect(
          transport.written.where(
            (message) =>
                message['type'] == 'control_request' &&
                (message['request'] as Map)['subtype'] == 'initialize',
          ),
          hasLength(1),
        );

        final messages = await warm.query('ready').toList();
        expect(messages, hasLength(2));
        expect(transport.closed, isTrue);
        expect(
          () => warm.query('again').drain<void>(),
          throwsA(isA<CliConnectionException>()),
        );
      },
    );
  });

  group('ClaudeAgentClient', () {
    late FakeTransport transport;
    late ClaudeAgentClient client;

    setUp(() async {
      transport = FakeTransport();
      transport.onWrite = transport.autoRespondToControl;
      client = ClaudeAgentClient(transport: transport);
      await client.connect();
    });

    tearDown(() => client.disconnect());

    test('supports repeated interactive turns', () async {
      await client.send('hi');
      transport.emit(_assistant);
      transport.emit(_result);

      final first = await client.receiveResponse().toList();
      expect(first, hasLength(2));
      expect(first.last, isA<ResultMessage>());

      await client.send('again');
      transport.emit({..._assistant, 'uuid': 'second'});
      transport.emit({..._result, 'result': 'again'});

      final second = await client.receiveResponse().toList();
      expect(second, hasLength(2));
      expect((second.last as ResultMessage).result, 'again');
    });

    test('routes outgoing control operations', () async {
      Future<void> checked(String name, Future<Object?> operation) =>
          operation.timeout(
            const Duration(seconds: 2),
            onTimeout: () => throw TimeoutException(name),
          );

      await checked(
        'setPermissionMode',
        client.setPermissionMode(PermissionMode.plan),
      );
      await checked('setModel', client.setModel('model-x'));
      await checked('interrupt', client.interrupt());
      await checked('rewindFiles', client.rewindFiles('message-id'));
      await checked('reconnectMcpServer', client.reconnectMcpServer('server'));
      await checked(
        'toggleMcpServer',
        client.toggleMcpServer('server', enabled: false),
      );
      await checked('stopTask', client.stopTask('task'));

      final subtypes = transport.written
          .where((message) => message['type'] == 'control_request')
          .map((message) => (message['request']! as Map)['subtype'])
          .toList();
      expect(
        subtypes,
        containsAll([
          'set_permission_mode',
          'set_model',
          'interrupt',
          'rewind_files',
          'mcp_reconnect',
          'mcp_toggle',
          'stop_task',
        ]),
      );
    });

    test(
      'exposes typed initialization, discovery, flags, and receipt',
      () async {
        final initialization = client.initializationResult;
        expect(initialization.models.single.value, 'test-model');
        expect(initialization.models.single.supportedEffortLevels, [
          'low',
          'high',
        ]);

        final commands = await client.supportedCommands();
        final agents = await client.supportedAgents();
        expect(commands.single.argumentHint, 'path focus');
        expect(agents.single.name, 'reviewer');

        await client.applyFlagSettings(
          const ClaudeFlagSettings(
            effortLevel: EffortLevel.high,
            clearAgent: true,
            fastMode: true,
          ),
        );
        final flagRequest = transport.written.lastWhere(
          (message) =>
              message['type'] == 'control_request' &&
              (message['request'] as Map)['subtype'] == 'apply_flag_settings',
        );
        expect((flagRequest['request'] as Map)['settings'], <String, Object?>{
          'effortLevel': 'high',
          'agent': null,
          'fastMode': true,
        });

        final receipt = await client.interrupt();
        expect(receipt.receiptSupported, isTrue);
        expect(receipt.stillQueued, ['queued-id']);
      },
    );

    test('decodes MCP and context status', () async {
      final status = await client.getMcpStatus();
      final context = await client.getContextUsage();

      expect(status.servers, isEmpty);
      expect(context.totalTokens, 10);
      expect(context.percentage, 10);
      expect(client.serverInfo, containsPair('commands', isNotEmpty));
    });

    test('supports current live controls and typed responses', () async {
      final fresh = await client.reinitialize();
      expect(fresh.outputStyle, 'default');
      expect((await client.supportedModels()).single.value, 'test-model');
      expect((await client.accountInfo())?.email, 'sdk@example.com');

      final override = await client.setMcpPermissionModeOverride(
        'server',
        McpPermissionModeOverride.auto,
      );
      expect(override.warning, 'test warning');

      final rewind = await client.rewindFiles('message-id', dryRun: true);
      expect(rewind.canRewind, isTrue);
      await client.seedReadState('/tmp/file', 123);

      final setServers = await client.setMcpServers({
        'dynamic': McpHttpServerConfig(url: 'https://example.com/mcp'),
      });
      expect(setServers.added, ['dynamic']);
      expect(await client.backgroundTasks('tool-use'), isTrue);

      final usage = await client.getUsage();
      expect(usage.subscriptionType, 'pro');
      final file = await client.readFile(
        '/tmp/example.png',
        encoding: ClaudeReadFileEncoding.base64,
      );
      expect(file?.encoding, ClaudeReadFileEncoding.base64);

      final plugins = await client.reloadPlugins();
      expect(plugins.plugins.single.version, '1.2.3');
      expect((await client.reloadSkills()).skills.single.name, 'review');

      final requests = transport.written
          .where((message) => message['type'] == 'control_request')
          .map((message) => message['request']! as Map<Object?, Object?>)
          .toList();
      expect(
        requests.firstWhere(
          (request) => request['subtype'] == 'rewind_files',
        )['dry_run'],
        isTrue,
      );
      expect(
        requests.firstWhere(
          (request) => request['subtype'] == 'read_file',
        )['encoding'],
        'base64',
      );
    });

    test('sends complete programmatic-agent initialization', () async {
      await client.close();
      transport = FakeTransport();
      transport.onWrite = transport.autoRespondToControl;
      client = ClaudeAgentClient(
        options: ClaudeAgentOptions(
          systemPrompt: SystemPrompt.blocks([
            'static',
            systemPromptDynamicBoundary,
            'dynamic',
          ]),
          agents: {
            'reviewer': AgentDefinition(
              description: 'Reviews code',
              prompt: 'Review carefully',
            ),
          },
          toolAliases: const {'Bash': 'mcp__workspace__bash'},
          title: 'Review session',
          planModeInstructions: 'Produce a review plan.',
          forwardSubagentText: true,
          promptSuggestions: true,
          agentProgressSummaries: true,
        ),
        transport: transport,
      );
      await client.connect();

      final initialize = transport.written.firstWhere(
        (message) =>
            message['type'] == 'control_request' &&
            (message['request'] as Map)['subtype'] == 'initialize',
      );
      final request = initialize['request']! as Map<Object?, Object?>;
      expect(request['agents'], contains('reviewer'));
      expect(request['systemPrompt'], [
        'static',
        systemPromptDynamicBoundary,
        'dynamic',
      ]);
      expect(request['toolAliases'], {'Bash': 'mcp__workspace__bash'});
      expect(request['title'], 'Review session');
      expect(request['forwardSubagentText'], isTrue);
      expect(request['promptSuggestions'], isTrue);
      expect(request['agentProgressSummaries'], isTrue);
    });

    test('fails controls before connection', () async {
      final disconnected = ClaudeAgentClient(transport: FakeTransport());
      expect(disconnected.interrupt, throwsA(isA<CliConnectionException>()));
    });

    test(
      'supports aliases, adjusted stream IDs, and idempotent lifecycle',
      () async {
        expect(client.isConnected, isTrue);
        await client.query('alias');
        await client.sendStream(
          Stream.fromIterable([
            UserInput.text('defaulted', sessionId: ''),
            UserInput.text('explicit', sessionId: 'session-2'),
          ]),
          defaultSessionId: 'session-1',
        );

        final inputs = transport.written
            .where((message) => message['type'] == 'user')
            .toList();
        expect(inputs.map((message) => message['session_id']), [
          'default',
          'session-1',
          'session-2',
        ]);

        await client.close();
        await client.disconnect();
        expect(client.isConnected, isFalse);
      },
    );

    test(
      'rejects conflicting initial inputs and string permission prompt',
      () async {
        final conflicting = ClaudeAgentClient(transport: FakeTransport());
        expect(
          () => conflicting.connect(
            prompt: 'text',
            promptStream: const Stream<UserInput>.empty(),
          ),
          throwsArgumentError,
        );

        final callback = ClaudeAgentClient(
          options: ClaudeAgentOptions(
            canUseTool: (_, _, _) async => PermissionAllowed(),
          ),
          transport: FakeTransport(),
        );
        expect(() => callback.connect(prompt: 'text'), throwsArgumentError);
      },
    );
  });

  group('incoming control requests', () {
    test('routes elicitation and declared user-dialog callbacks', () async {
      final transport = FakeTransport();
      transport.onWrite = transport.autoRespondToControl;
      final client = ClaudeAgentClient(
        options: ClaudeAgentOptions(
          onElicitation: (request, context) async {
            expect(request.mode, ClaudeElicitationMode.form);
            expect(request.schema, containsPair('type', 'object'));
            expect(context.cancellation.isCancelled, isFalse);
            return ClaudeElicitationResult.accept(<String, Object?>{
              'answer': 'yes',
            });
          },
          onUserDialog: (request, context) async {
            expect(request.dialogKind, 'refusal_fallback');
            return const ClaudeUserDialogResult.completed('retry');
          },
          supportedDialogKinds: const <String>['refusal_fallback'],
        ),
        transport: transport,
      );
      await client.connect();

      transport.emit(<String, Object?>{
        'type': 'control_request',
        'request_id': 'elicit-1',
        'request': <String, Object?>{
          'subtype': 'mcp_elicitation',
          'mode': 'form',
          'message': 'Choose',
          'requestedSchema': <String, Object?>{'type': 'object'},
        },
      });
      final elicitation = await transport.nextWriteWhere(
        (value) =>
            value['type'] == 'control_response' &&
            (value['response'] as Map)['request_id'] == 'elicit-1',
      );
      expect(
        ((elicitation['response'] as Map)['response'] as Map)['action'],
        'accept',
      );

      transport.emit(<String, Object?>{
        'type': 'control_request',
        'request_id': 'dialog-1',
        'request': <String, Object?>{
          'subtype': 'user_dialog',
          'kind': 'refusal_fallback',
          'message': 'Try fallback?',
        },
      });
      final dialog = await transport.nextWriteWhere(
        (value) =>
            value['type'] == 'control_response' &&
            (value['response'] as Map)['request_id'] == 'dialog-1',
      );
      expect(
        ((dialog['response'] as Map)['response'] as Map)['behavior'],
        'completed',
      );
      expect(
        ((dialog['response'] as Map)['response'] as Map)['result'],
        'retry',
      );
      await client.close();
    });

    test('invokes permission callback', () async {
      final transport = FakeTransport();
      transport.onWrite = transport.autoRespondToControl;
      final client = ClaudeAgentClient(
        options: ClaudeAgentOptions(
          canUseTool: (name, input, context) async {
            expect(name, 'Bash');
            expect(input, containsPair('command', 'pwd'));
            expect(context.toolUseId, 'tool-1');
            return PermissionAllowed(updatedInput: {'command': 'pwd -P'});
          },
        ),
        transport: transport,
      );
      await client.connect();
      transport.emit({
        'type': 'control_request',
        'request_id': 'incoming-1',
        'request': {
          'subtype': 'can_use_tool',
          'tool_name': 'Bash',
          'input': {'command': 'pwd'},
          'tool_use_id': 'tool-1',
        },
      });

      final response = await transport.nextWriteWhere(
        (value) =>
            value['type'] == 'control_response' &&
            (value['response'] as Map)['request_id'] == 'incoming-1',
      );
      final payload = (response['response'] as Map)['response'] as Map;
      expect(payload['behavior'], 'allow');
      expect(payload['updatedInput'], containsPair('command', 'pwd -P'));
      await client.disconnect();
    });

    test('invokes hooks and SDK MCP tools', () async {
      final transport = FakeTransport();
      transport.onWrite = transport.autoRespondToControl;
      final cancelledHook = Completer<ControlCallbackContext>();
      final server = SdkMcpServer(
        name: 'local',
        tools: [
          SdkMcpTool(
            name: 'echo',
            description: 'Echo input',
            inputSchema: {'type': 'object', 'properties': <String, Object?>{}},
            handler: (input) async =>
                McpToolResult(content: [McpTextContent('${input['value']}')]),
          ),
        ],
      );
      final client = ClaudeAgentClient(
        options: ClaudeAgentOptions(
          hooks: {
            HookEvent.preToolUse: [
              HookMatcher(
                hooks: [
                  (input, toolUseId, context) async {
                    expect(input, isA<PreToolUseHookInput>());
                    expect(context.cancellation.isCancelled, isFalse);
                    if ((input as PreToolUseHookInput).toolName == 'Write') {
                      cancelledHook.complete(context);
                      await context.cancellation.whenCancelled;
                    }
                    return const HookOutput(systemMessage: 'checked');
                  },
                ],
              ),
            ],
          },
          mcp: McpServers({'local': server}),
        ),
        transport: transport,
      );
      await client.connect();
      final initialize = transport.written.firstWhere(
        (value) =>
            value['type'] == 'control_request' &&
            (value['request'] as Map)['subtype'] == 'initialize',
      );
      final hooks =
          ((initialize['request'] as Map)['hooks'] as Map)['PreToolUse']
              as List;
      final callbackIds =
          (hooks.single as Map<Object?, Object?>)['hookCallbackIds']! as List;
      final callbackId = callbackIds.first as String;

      transport.emit({
        'type': 'control_request',
        'request_id': 'hook-1',
        'request': {
          'subtype': 'hook_callback',
          'callback_id': callbackId,
          'input': {
            'hook_event_name': 'PreToolUse',
            'session_id': 's',
            'transcript_path': '/tmp/s.jsonl',
            'cwd': '/tmp',
            'tool_name': 'Read',
            'tool_input': {'file_path': '/tmp/a'},
            'tool_use_id': 'tool',
          },
        },
      });
      final hookResponse = await transport.nextWriteWhere(
        (value) =>
            value['type'] == 'control_response' &&
            (value['response'] as Map)['request_id'] == 'hook-1',
      );
      expect(
        ((hookResponse['response'] as Map)['response'] as Map)['systemMessage'],
        'checked',
      );

      transport.emit({
        'type': 'control_request',
        'request_id': 'hook-cancelled',
        'request': {
          'subtype': 'hook_callback',
          'callback_id': callbackId,
          'input': {
            'hook_event_name': 'PreToolUse',
            'session_id': 's',
            'transcript_path': '/tmp/s.jsonl',
            'cwd': '/tmp',
            'tool_name': 'Write',
            'tool_input': {'file_path': '/tmp/a'},
            'tool_use_id': 'tool-cancelled',
          },
        },
      });
      final hookContext = await cancelledHook.future;
      expect(hookContext.cancellation.requestId, 'hook-cancelled');
      transport.emit({
        'type': 'control_cancel_request',
        'request_id': 'hook-cancelled',
      });
      await hookContext.cancellation.whenCancelled;
      await Future<void>.delayed(Duration.zero);
      expect(
        transport.written.where(
          (value) =>
              value['type'] == 'control_response' &&
              (value['response'] as Map)['request_id'] == 'hook-cancelled',
        ),
        isEmpty,
      );

      transport.emit({
        'type': 'control_request',
        'request_id': 'mcp-1',
        'request': {
          'subtype': 'mcp_message',
          'server_name': 'local',
          'message': {
            'jsonrpc': '2.0',
            'id': 1,
            'method': 'tools/call',
            'params': {
              'name': 'echo',
              'arguments': {'value': 'ok'},
            },
          },
        },
      });
      final mcpResponse = await transport.nextWriteWhere(
        (value) =>
            value['type'] == 'control_response' &&
            (value['response'] as Map)['request_id'] == 'mcp-1',
      );
      final mcp =
          ((mcpResponse['response'] as Map)['response'] as Map)['mcp_response']
              as Map;
      expect(((mcp['result'] as Map)['content'] as List), isNotEmpty);
      await client.disconnect();
    });
  });
}
