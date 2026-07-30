import 'package:dart_acp_codex/src/app_server/backend.dart';
import 'package:dart_acp_codex/src/app_server/notifications.dart';
import 'package:dart_acp_codex/src/runtime/diagnostics.dart';
import 'package:test/test.dart';

void main() {
  test('extracts direct and nested notification routing identities', () {
    final direct = decodeCodexNotification('event', <String, Object?>{
      'conversationId': 'conversation',
      'turnId': 'turn',
      'itemId': 'item',
    });
    expect(direct.threadId?.value, 'conversation');
    expect(direct.turnId?.value, 'turn');
    expect(direct.itemId?.value, 'item');

    final nested = decodeCodexNotification('event', <String, Object?>{
      'threadId': 'thread',
      'turn': <String, Object?>{'id': 'nested-turn'},
      'item': <String, Object?>{'id': 'nested-item'},
    });
    expect(nested.threadId?.value, 'thread');
    expect(nested.turnId?.value, 'nested-turn');
    expect(nested.itemId?.value, 'nested-item');

    final empty = decodeCodexNotification('event', null);
    expect(empty.threadId, isNull);
    expect(empty.turnId, isNull);
    expect(empty.itemId, isNull);
  });

  test('decodes every supported server-request variant', () {
    final cases = <String, Type>{
      'item/commandExecution/requestApproval': CodexCommandApprovalRequest,
      'item/fileChange/requestApproval': CodexFileChangeApprovalRequest,
      'item/permissions/requestApproval': CodexPermissionsRequest,
      'mcpServer/elicitation/request': CodexMcpElicitationRequest,
      'item/tool/requestUserInput': CodexUserInputRequest,
    };
    for (final entry in cases.entries) {
      final request = decodeCodexServerRequest(entry.key, <String, Object?>{
        'threadId': 'thread',
        if (entry.key != 'mcpServer/elicitation/request') 'turnId': 'turn',
      });
      expect(request.runtimeType, entry.value);
      expect(request.threadId.value, 'thread');
      expect(isCodexServerRequestMethod(entry.key), isTrue);
    }
    final mcp = decodeCodexServerRequest(
      'mcpServer/elicitation/request',
      <String, Object?>{'threadId': 'thread', 'turnId': 'optional'},
    );
    expect(mcp.turnId?.value, 'optional');
    expect(isCodexServerRequestMethod('unknown'), isFalse);
  });

  test('rejects malformed notification and request params', () {
    expect(
      () => decodeCodexNotification('event', <Object?>[]),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => decodeCodexServerRequest(
        'item/commandExecution/requestApproval',
        <String, Object?>{'threadId': 'thread'},
      ),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => decodeCodexServerRequest('unknown', <String, Object?>{
        'threadId': 'thread',
      }),
      throwsA(isA<CodexProtocolException>()),
    );
    expect(
      () => decodeCodexServerRequest('mcpServer/elicitation/request', null),
      throwsA(isA<CodexProtocolException>()),
    );
  });
}
