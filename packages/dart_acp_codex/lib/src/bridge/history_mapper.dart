import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../app_server/backend.dart';
import '../app_server/json_values.dart';
import 'event_mapper.dart';

/// Replays current app-server thread history through the live event mapper.
final class CodexHistoryMapper {
  /// Creates a history mapper.
  CodexHistoryMapper({CodexEventMapper? events})
    : _events = events ?? CodexEventMapper();

  final CodexEventMapper _events;

  /// Maps the turns present in a `thread/resume` or `thread/read` result.
  List<SessionUpdate> map(CodexJsonObject thread) {
    final turns = thread['turns'];
    if (turns is! List<Object?>) {
      return const <SessionUpdate>[];
    }
    final updates = <SessionUpdate>[];
    for (final rawTurn in turns) {
      if (rawTurn is! Map<Object?, Object?>) {
        continue;
      }
      final turn = CodexJsonObject.from(rawTurn);
      final turnId = turn.optionalString('id');
      final items = turn['items'];
      if (items is! List<Object?>) {
        continue;
      }
      for (final rawItem in items) {
        if (rawItem is! Map<Object?, Object?>) {
          continue;
        }
        final item = CodexJsonObject.from(rawItem);
        final id = item.optionalString('id');
        final type = item.optionalString('type');
        if (type == 'userMessage') {
          updates.addAll(_message(item, 'user_message_chunk'));
          continue;
        }
        if (type == 'agentMessage') {
          updates.addAll(_message(item, 'agent_message_chunk'));
          continue;
        }
        updates.addAll(
          _events.map(
            CodexNotification(
              method: 'item/completed',
              params: CodexJsonObject.from(<String, Object?>{
                'turnId': ?turnId,
                'item': item.toJson(),
              }),
              turnId: turnId == null ? null : CodexTurnId(turnId),
              itemId: id == null ? null : CodexItemId(id),
            ),
          ),
        );
      }
    }
    return updates;
  }

  List<SessionUpdate> _message(CodexJsonObject item, String discriminator) {
    final id = item.optionalString('id');
    final content = item['content'];
    final texts = <String>[];
    if (content is List<Object?>) {
      for (final value in content) {
        if (value is String) {
          texts.add(value);
        } else if (value is Map<Object?, Object?> && value['text'] is String) {
          texts.add(value['text']! as String);
        }
      }
    }
    final direct = item.optionalString('text');
    if (texts.isEmpty && direct != null) {
      texts.add(direct);
    }
    return <SessionUpdate>[
      for (final text in texts)
        SessionUpdate.fromJson(<String, Object?>{
          'sessionUpdate': discriminator,
          'content': <String, Object?>{'type': 'text', 'text': text},
          'messageId': ?id,
        }),
    ];
  }
}
