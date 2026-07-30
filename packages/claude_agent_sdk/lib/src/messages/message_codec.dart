import '../errors.dart';
import '../json.dart';
import '../sessions/session_store.dart';
import 'content_block.dart';
import 'message.dart';

/// Decodes CLI stream-json frames into immutable message models.
final class MessageCodec {
  /// Creates a message codec.
  const MessageCodec();

  /// Decodes [data], returning `null` for a forward-compatible unknown type.
  ///
  /// Known message types with missing or invalid fields throw
  /// [MessageParseException] and retain the raw object.
  AgentMessage? decode(JsonMap data) {
    try {
      if (data['type'] == 'system' &&
          (data['subtype'] == 'hook_started' ||
              data['subtype'] == 'hook_response')) {
        return _hookEvent(data);
      }
      final type = data['type'];
      if (type is! String || type.isEmpty) {
        throw const FormatException("Message missing 'type' field");
      }
      return switch (type) {
        'user' => _user(data),
        'assistant' => _assistant(data),
        'system' => _system(data),
        'result' => _result(data),
        'stream_event' => _streamEvent(data),
        'rate_limit_event' => _rateLimit(data),
        _ => null,
      };
    } on MessageParseException {
      rethrow;
    } catch (error) {
      throw MessageParseException(
        'Unable to parse ${data['type'] ?? 'unknown'} message: $error',
        data: immutableJsonMap(data),
        cause: error,
      );
    }
  }

  UserMessage _user(JsonMap data) {
    final message = asJsonMap(data['message'], 'user.message');
    final content = message['content'];
    final uuid = optionalString(data, 'uuid', 'user');
    final parent = optionalString(data, 'parent_tool_use_id', 'user');
    final toolResult = optionalMap(data, 'tool_use_result', 'user');
    if (content is String) {
      return UserMessage.text(
        content,
        uuid: uuid,
        parentToolUseId: parent,
        toolUseResult: toolResult,
      );
    }
    if (content is! List<Object?>) {
      throw const FormatException(
        'user.message.content must be text or an array',
      );
    }
    return UserMessage.blocks(
      content
          .map((block) => _content(asJsonMap(block, 'user content block')))
          .toList(growable: false),
      uuid: uuid,
      parentToolUseId: parent,
      toolUseResult: toolResult,
    );
  }

  AssistantMessage _assistant(JsonMap data) {
    final message = asJsonMap(data['message'], 'assistant.message');
    final content = message['content'];
    if (content is! List<Object?>) {
      throw const FormatException('assistant.message.content must be an array');
    }
    final errorValue = optionalString(data, 'error', 'assistant');
    return AssistantMessage(
      content: content
          .map((block) => _content(asJsonMap(block, 'assistant content block')))
          .toList(growable: false),
      model: requiredString(message, 'model', 'assistant.message'),
      parentToolUseId: optionalString(data, 'parent_tool_use_id', 'assistant'),
      error: errorValue == null
          ? null
          : AssistantMessageError.fromWire(errorValue),
      usage: optionalMap(message, 'usage', 'assistant.message'),
      messageId: optionalString(message, 'id', 'assistant.message'),
      stopReason: optionalString(message, 'stop_reason', 'assistant.message'),
      sessionId: optionalString(data, 'session_id', 'assistant'),
      uuid: optionalString(data, 'uuid', 'assistant'),
    );
  }

  ContentBlock _content(JsonMap block) {
    final type = requiredString(block, 'type', 'content block');
    return switch (type) {
      'text' => TextBlock(requiredString(block, 'text', 'text block')),
      'thinking' => ThinkingBlock(
        thinking: requiredString(block, 'thinking', 'thinking block'),
        signature: requiredString(block, 'signature', 'thinking block'),
      ),
      'tool_use' => ToolUseBlock(
        id: requiredString(block, 'id', 'tool_use block'),
        name: requiredString(block, 'name', 'tool_use block'),
        input: asJsonMap(block['input'], 'tool_use.input'),
      ),
      'tool_result' => ToolResultBlock(
        toolUseId: requiredString(block, 'tool_use_id', 'tool_result block'),
        content: immutableJsonValue(block['content']),
        isError: optionalBool(block, 'is_error', 'tool_result block'),
      ),
      'server_tool_use' => ServerToolUseBlock(
        id: requiredString(block, 'id', 'server_tool_use block'),
        name: requiredString(block, 'name', 'server_tool_use block'),
        input: asJsonMap(block['input'], 'server_tool_use.input'),
      ),
      'advisor_tool_result' => ServerToolResultBlock(
        toolUseId: requiredString(block, 'tool_use_id', 'server tool result'),
        content: asJsonMap(block['content'], 'server tool result.content'),
      ),
      _ => UnknownContentBlock(block),
    };
  }

  SystemMessage _system(JsonMap data) {
    final subtype = requiredString(data, 'subtype', 'system');
    return switch (subtype) {
      'task_started' => TaskStartedMessage(
        data: data,
        taskId: requiredString(data, 'task_id', 'task_started'),
        description: requiredString(data, 'description', 'task_started'),
        uuid: requiredString(data, 'uuid', 'task_started'),
        sessionId: requiredString(data, 'session_id', 'task_started'),
        toolUseId: optionalString(data, 'tool_use_id', 'task_started'),
        taskType: optionalString(data, 'task_type', 'task_started'),
      ),
      'task_progress' => TaskProgressMessage(
        data: data,
        taskId: requiredString(data, 'task_id', 'task_progress'),
        description: requiredString(data, 'description', 'task_progress'),
        usage: _taskUsage(asJsonMap(data['usage'], 'task_progress.usage')),
        uuid: requiredString(data, 'uuid', 'task_progress'),
        sessionId: requiredString(data, 'session_id', 'task_progress'),
        toolUseId: optionalString(data, 'tool_use_id', 'task_progress'),
        lastToolName: optionalString(data, 'last_tool_name', 'task_progress'),
      ),
      'task_notification' => _taskNotification(data),
      'task_updated' => TaskUpdatedMessage(
        data: data,
        taskId: optionalString(data, 'task_id', 'task_updated') ?? '',
        patch: data['patch'] is Map<Object?, Object?>
            ? asJsonMap(data['patch'], 'task_updated.patch')
            : const {},
        sessionId: optionalString(data, 'session_id', 'task_updated'),
        uuid: optionalString(data, 'uuid', 'task_updated'),
      ),
      'mirror_error' => MirrorErrorMessage(
        data: data,
        key: _sessionKey(data['key']),
        error: optionalString(data, 'error', 'mirror_error') ?? '',
      ),
      _ => SystemMessage(subtype: subtype, data: data),
    };
  }

  TaskNotificationMessage _taskNotification(JsonMap data) {
    final status = TaskStatus.tryFromWire(data['status']);
    if (status == null || !status.isTerminal) {
      throw FormatException(
        'task_notification.status must be terminal: ${data['status']}',
      );
    }
    final rawUsage = data['usage'];
    return TaskNotificationMessage(
      data: data,
      taskId: requiredString(data, 'task_id', 'task_notification'),
      status: status,
      outputFile: requiredString(data, 'output_file', 'task_notification'),
      summary: requiredString(data, 'summary', 'task_notification'),
      uuid: requiredString(data, 'uuid', 'task_notification'),
      sessionId: requiredString(data, 'session_id', 'task_notification'),
      toolUseId: optionalString(data, 'tool_use_id', 'task_notification'),
      usage: rawUsage == null
          ? null
          : _taskUsage(asJsonMap(rawUsage, 'task_notification.usage')),
    );
  }

  TaskUsage _taskUsage(JsonMap json) => TaskUsage(
    totalTokens: requiredInt(json, 'total_tokens', 'task usage'),
    toolUses: requiredInt(json, 'tool_uses', 'task usage'),
    duration: Duration(
      milliseconds: requiredInt(json, 'duration_ms', 'task usage'),
    ),
  );

  HookEventMessage _hookEvent(JsonMap data) => HookEventMessage(
    subtype: requiredString(data, 'subtype', 'hook event'),
    data: data,
    hookEventName:
        optionalString(data, 'hook_event', 'hook event') ??
        optionalString(data, 'hook_name', 'hook event') ??
        optionalString(data, 'hook_event_name', 'hook event') ??
        '',
    sessionId: optionalString(data, 'session_id', 'hook event'),
    uuid: optionalString(data, 'uuid', 'hook event'),
  );

  ResultMessage _result(JsonMap data) {
    final deferred = optionalMap(data, 'deferred_tool_use', 'result');
    final rawModels = optionalMap(data, 'modelUsage', 'result');
    final rawDenials = data['permission_denials'];
    final rawErrors = data['errors'];
    return ResultMessage(
      subtype: requiredString(data, 'subtype', 'result'),
      duration: Duration(
        milliseconds: requiredInt(data, 'duration_ms', 'result'),
      ),
      apiDuration: Duration(
        milliseconds: requiredInt(data, 'duration_api_ms', 'result'),
      ),
      isError: requiredBool(data, 'is_error', 'result'),
      turns: requiredInt(data, 'num_turns', 'result'),
      sessionId: requiredString(data, 'session_id', 'result'),
      stopReason: optionalString(data, 'stop_reason', 'result'),
      totalCostUsd: optionalDouble(data, 'total_cost_usd', 'result'),
      usage: optionalMap(data, 'usage', 'result'),
      result: optionalString(data, 'result', 'result'),
      structuredOutput: immutableJsonValue(data['structured_output']),
      modelUsage: rawModels?.map(
        (model, raw) => MapEntry(
          model,
          _modelUsage(asJsonMap(raw, 'result.modelUsage.$model')),
        ),
      ),
      permissionDenials: rawDenials is List<Object?> ? rawDenials : null,
      deferredToolUse: deferred == null
          ? null
          : DeferredToolUse(
              id: requiredString(deferred, 'id', 'deferred tool'),
              name: requiredString(deferred, 'name', 'deferred tool'),
              input: asJsonMap(deferred['input'], 'deferred tool.input'),
            ),
      errors: rawErrors is List<Object?>
          ? rawErrors
                .map((value) {
                  if (value is! String) {
                    throw const FormatException(
                      'result.errors must contain strings',
                    );
                  }
                  return value;
                })
                .toList(growable: false)
          : null,
      apiErrorStatus: optionalInt(data, 'api_error_status', 'result'),
      uuid: optionalString(data, 'uuid', 'result'),
      terminalReason: optionalString(data, 'terminal_reason', 'result'),
    );
  }

  ModelUsage _modelUsage(JsonMap json) => ModelUsage(
    inputTokens: requiredInt(json, 'inputTokens', 'model usage'),
    outputTokens: requiredInt(json, 'outputTokens', 'model usage'),
    cacheReadInputTokens: requiredInt(
      json,
      'cacheReadInputTokens',
      'model usage',
    ),
    cacheCreationInputTokens: requiredInt(
      json,
      'cacheCreationInputTokens',
      'model usage',
    ),
    webSearchRequests: requiredInt(json, 'webSearchRequests', 'model usage'),
    costUsd: requiredNum(json, 'costUSD', 'model usage').toDouble(),
    contextWindow: requiredInt(json, 'contextWindow', 'model usage'),
    maxOutputTokens: requiredInt(json, 'maxOutputTokens', 'model usage'),
    canonicalModel: optionalString(json, 'canonicalModel', 'model usage'),
    provider: optionalString(json, 'provider', 'model usage'),
  );

  StreamEventMessage _streamEvent(JsonMap data) => StreamEventMessage(
    uuid: requiredString(data, 'uuid', 'stream_event'),
    sessionId: requiredString(data, 'session_id', 'stream_event'),
    event: asJsonMap(data['event'], 'stream_event.event'),
    parentToolUseId: optionalString(data, 'parent_tool_use_id', 'stream_event'),
  );

  RateLimitEventMessage _rateLimit(JsonMap data) {
    final raw = asJsonMap(
      data['rate_limit_info'],
      'rate_limit_event.rate_limit_info',
    );
    final resetsAt = optionalInt(raw, 'resetsAt', 'rate limit');
    final overageResetsAt = optionalInt(raw, 'overageResetsAt', 'rate limit');
    final overageStatus = optionalString(raw, 'overageStatus', 'rate limit');
    return RateLimitEventMessage(
      info: RateLimitInfo(
        status: rateLimitStatusFromWire(
          requiredString(raw, 'status', 'rate limit'),
        ),
        resetsAt: resetsAt == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(resetsAt * 1000, isUtc: true),
        type: rateLimitTypeFromWire(raw['rateLimitType']),
        utilization: optionalDouble(raw, 'utilization', 'rate limit'),
        overageStatus: overageStatus == null
            ? null
            : rateLimitStatusFromWire(overageStatus),
        overageResetsAt: overageResetsAt == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                overageResetsAt * 1000,
                isUtc: true,
              ),
        overageDisabledReason: optionalString(
          raw,
          'overageDisabledReason',
          'rate limit',
        ),
        raw: raw,
      ),
      uuid: requiredString(data, 'uuid', 'rate_limit_event'),
      sessionId: requiredString(data, 'session_id', 'rate_limit_event'),
    );
  }

  SessionKey? _sessionKey(Object? raw) {
    if (raw == null) return null;
    final json = asJsonMap(raw, 'mirror_error.key');
    return SessionKey(
      projectKey: requiredString(json, 'project_key', 'session key'),
      sessionId: requiredString(json, 'session_id', 'session key'),
      subpath: optionalString(json, 'subpath', 'session key'),
    );
  }
}
