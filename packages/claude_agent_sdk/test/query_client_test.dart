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
      Future<void> checked(String name, Future<void> operation) =>
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

    test('decodes MCP and context status', () async {
      final status = await client.getMcpStatus();
      final context = await client.getContextUsage();

      expect(status.servers, isEmpty);
      expect(context.totalTokens, 10);
      expect(context.percentage, 10);
      expect(client.serverInfo, containsPair('commands', isEmpty));
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
                  (input, toolUseId) async {
                    expect(input, isA<PreToolUseHookInput>());
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
