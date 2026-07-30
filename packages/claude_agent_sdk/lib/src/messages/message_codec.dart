import '../errors.dart';
import '../initialization.dart';
import '../json.dart';
import '../sessions/session_store.dart';
import 'content_block.dart';
import 'message.dart';

/// Decodes CLI stream-json frames into immutable message models.
final class MessageCodec {
  /// Creates a message codec.
  const MessageCodec();

  /// Decodes [data], preserving a newer top-level type as
  /// [UnknownAgentMessage].
  ///
  /// Known message types with missing or invalid fields throw
  /// [MessageParseException] and retain the raw object.
  AgentMessage? decode(JsonMap data) {
    try {
      if (data['type'] == 'system' &&
          (data['subtype'] == 'hook_started' ||
              data['subtype'] == 'hook_progress' ||
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
        'auth_status' => _authStatus(data),
        'tool_progress' => _toolProgress(data),
        'tool_use_summary' => _toolUseSummary(data),
        'prompt_suggestion' => PromptSuggestionMessage(
          suggestion: requiredString(data, 'suggestion', 'prompt suggestion'),
          uuid: requiredString(data, 'uuid', 'prompt suggestion'),
          sessionId: requiredString(data, 'session_id', 'prompt suggestion'),
        ),
        'conversation_reset' => ConversationResetMessage(
          newConversationId: requiredString(
            data,
            'new_conversation_id',
            'conversation reset',
          ),
          uuid: requiredString(data, 'uuid', 'conversation reset'),
          sessionId: requiredString(data, 'session_id', 'conversation reset'),
        ),
        'active_goal' => ActiveGoalMessage(
          value: data['value'] == null
              ? null
              : asJsonMap(data['value'], 'active goal'),
          uuid: requiredString(data, 'uuid', 'active goal'),
          sessionId: requiredString(data, 'session_id', 'active goal'),
        ),
        _ => UnknownAgentMessage(type: type, raw: data),
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
    final origin = optionalMap(data, 'origin', 'user');
    final timestamp = _timestamp(data['timestamp'], 'user.timestamp');
    final toolResultMetadata = _toolResultMetadata(data['tool_result_meta']);
    if (content is String) {
      return UserMessage.text(
        content,
        uuid: uuid,
        sessionId: optionalString(data, 'session_id', 'user'),
        parentToolUseId: parent,
        toolUseResult: toolResult,
        isSynthetic: optionalBool(data, 'isSynthetic', 'user'),
        priority: optionalString(data, 'priority', 'user'),
        shouldQuery: optionalBool(data, 'shouldQuery', 'user'),
        timestamp: timestamp,
        subagentType: optionalString(data, 'subagent_type', 'user'),
        taskDescription: optionalString(data, 'task_description', 'user'),
        origin: origin,
        isReplay: optionalBool(data, 'isReplay', 'user') ?? false,
        fileAttachments: _jsonList(
          data['file_attachments'],
          'user.file_attachments',
        ),
        toolResultMetadata: toolResultMetadata,
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
      sessionId: optionalString(data, 'session_id', 'user'),
      parentToolUseId: parent,
      toolUseResult: toolResult,
      isSynthetic: optionalBool(data, 'isSynthetic', 'user'),
      priority: optionalString(data, 'priority', 'user'),
      shouldQuery: optionalBool(data, 'shouldQuery', 'user'),
      timestamp: timestamp,
      subagentType: optionalString(data, 'subagent_type', 'user'),
      taskDescription: optionalString(data, 'task_description', 'user'),
      origin: origin,
      isReplay: optionalBool(data, 'isReplay', 'user') ?? false,
      fileAttachments: _jsonList(
        data['file_attachments'],
        'user.file_attachments',
      ),
      toolResultMetadata: toolResultMetadata,
    );
  }

  List<ToolResultMetadata> _toolResultMetadata(Object? value) {
    if (value is! List<Object?>) return const <ToolResultMetadata>[];
    final result = <ToolResultMetadata>[];
    for (final item in value) {
      if (item is! Map<Object?, Object?>) continue;
      try {
        result.add(
          ToolResultMetadata.fromJson(<String, Object?>{
            for (final entry in item.entries)
              if (entry.key is String) entry.key! as String: entry.value,
          }),
        );
      } on FormatException {
        // This sidecar can ship ahead of the public declaration file. Ignore
        // bad entries instead of rejecting an otherwise valid user message.
      }
    }
    return List<ToolResultMetadata>.unmodifiable(result);
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
      requestId: optionalString(data, 'request_id', 'assistant'),
      resumedFromIncompleteThinking:
          optionalBool(data, 'resumed_from_incomplete_thinking', 'assistant') ??
          false,
      supersedes: _stringList(data['supersedes'], 'assistant.supersedes'),
      isAborted: optionalBool(data, 'aborted', 'assistant') ?? false,
      subagentType: optionalString(data, 'subagent_type', 'assistant'),
      taskDescription: optionalString(data, 'task_description', 'assistant'),
      timestamp: _timestamp(data['timestamp'], 'assistant.timestamp'),
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
      'image' => ImageBlock(source: asJsonMap(block['source'], 'image.source')),
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
      'advisor_tool_result' ||
      'web_search_tool_result' ||
      'web_fetch_tool_result' ||
      'code_execution_tool_result' ||
      'bash_code_execution_tool_result' ||
      'text_editor_code_execution_tool_result' ||
      'tool_search_tool_result' => ServerToolResultBlock(
        toolUseId: requiredString(block, 'tool_use_id', 'server tool result'),
        content: immutableJsonValue(block['content']),
        type: type,
      ),
      _ => UnknownContentBlock(block),
    };
  }

  SystemMessage _system(JsonMap data) {
    final subtype = requiredString(data, 'subtype', 'system');
    return switch (subtype) {
      'init' => RuntimeInitializationMessage(
        data: data,
        claudeCodeVersion: requiredString(data, 'claude_code_version', 'init'),
        cwd: requiredString(data, 'cwd', 'init'),
        tools: _stringList(data['tools'], 'init.tools'),
        model: requiredString(data, 'model', 'init'),
        permissionMode: requiredString(data, 'permissionMode', 'init'),
        slashCommands: _stringList(
          data['slash_commands'],
          'init.slash_commands',
        ),
        skills: _stringList(data['skills'], 'init.skills'),
        capabilities: _stringList(data['capabilities'], 'init.capabilities'),
        agents: _stringList(data['agents'], 'init.agents'),
        betas: _stringList(data['betas'], 'init.betas'),
        mcpServers: _objectListOrEmpty(data['mcp_servers'], 'init.mcp_servers')
            .map(
              (server) => RuntimeMcpServer(
                name: requiredString(server, 'name', 'init MCP server'),
                status: requiredString(server, 'status', 'init MCP server'),
              ),
            )
            .toList(growable: false),
        plugins: _objectListOrEmpty(data['plugins'], 'init.plugins')
            .map(
              (plugin) => RuntimePlugin(
                name: requiredString(plugin, 'name', 'init plugin'),
                path: requiredString(plugin, 'path', 'init plugin'),
                version: optionalString(plugin, 'version', 'init plugin'),
              ),
            )
            .toList(growable: false),
        apiKeySource: optionalString(data, 'apiKeySource', 'init'),
        outputStyle: optionalString(data, 'output_style', 'init'),
        fastModeState: optionalString(data, 'fast_mode_state', 'init'),
        fastModeDisabledReason: optionalString(
          data,
          'fast_mode_disabled_reason',
          'init',
        ),
        uuid: requiredString(data, 'uuid', 'init'),
        sessionId: requiredString(data, 'session_id', 'init'),
      ),
      'api_retry' => ApiRetryMessage(
        data: data,
        attempt: requiredInt(data, 'attempt', 'api_retry'),
        maximumRetries: requiredInt(data, 'max_retries', 'api_retry'),
        retryDelay: Duration(
          milliseconds: requiredInt(data, 'retry_delay_ms', 'api_retry'),
        ),
        errorStatus: optionalInt(data, 'error_status', 'api_retry'),
        error: AssistantMessageError.fromWire(
          requiredString(data, 'error', 'api_retry'),
        ),
        uuid: requiredString(data, 'uuid', 'api_retry'),
        sessionId: requiredString(data, 'session_id', 'api_retry'),
      ),
      'background_tasks_changed' => BackgroundTasksChangedMessage(
        data: data,
        tasks: _objectList(data['tasks'], 'background_tasks_changed.tasks')
            .map(
              (task) => BackgroundTaskSummary(
                taskId: requiredString(task, 'task_id', 'background task'),
                taskType: requiredString(task, 'task_type', 'background task'),
                description: requiredString(
                  task,
                  'description',
                  'background task',
                ),
              ),
            )
            .toList(growable: false),
        uuid: requiredString(data, 'uuid', 'background_tasks_changed'),
        sessionId: requiredString(
          data,
          'session_id',
          'background_tasks_changed',
        ),
      ),
      'compact_boundary' => CompactBoundaryMessage(
        data: data,
        metadata: asJsonMap(
          data['compact_metadata'],
          'compact_boundary.compact_metadata',
        ),
        uuid: requiredString(data, 'uuid', 'compact_boundary'),
        sessionId: requiredString(data, 'session_id', 'compact_boundary'),
      ),
      'control_request_progress' => ControlRequestProgressMessage(
        data: data,
        requestId: requiredString(
          data,
          'request_id',
          'control_request_progress',
        ),
        status: requiredString(data, 'status', 'control_request_progress'),
        attempt: optionalInt(data, 'attempt', 'control_request_progress'),
        maximumRetries: optionalInt(
          data,
          'max_retries',
          'control_request_progress',
        ),
        retryDelay: data['retry_delay_ms'] == null
            ? null
            : Duration(
                milliseconds: requiredInt(
                  data,
                  'retry_delay_ms',
                  'control_request_progress',
                ),
              ),
        errorStatus: optionalInt(
          data,
          'error_status',
          'control_request_progress',
        ),
        uuid: requiredString(data, 'uuid', 'control_request_progress'),
        sessionId: requiredString(
          data,
          'session_id',
          'control_request_progress',
        ),
      ),
      'task_started' => TaskStartedMessage(
        data: data,
        taskId: requiredString(data, 'task_id', 'task_started'),
        description: requiredString(data, 'description', 'task_started'),
        uuid: requiredString(data, 'uuid', 'task_started'),
        sessionId: requiredString(data, 'session_id', 'task_started'),
        toolUseId: optionalString(data, 'tool_use_id', 'task_started'),
        taskType: optionalString(data, 'task_type', 'task_started'),
        subagentType: optionalString(data, 'subagent_type', 'task_started'),
        workflowName: optionalString(data, 'workflow_name', 'task_started'),
        prompt: optionalString(data, 'prompt', 'task_started'),
        skipTranscript:
            optionalBool(data, 'skip_transcript', 'task_started') ?? false,
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
        subagentType: optionalString(data, 'subagent_type', 'task_progress'),
        summary: optionalString(data, 'summary', 'task_progress'),
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
        uuid: optionalString(data, 'uuid', 'mirror_error'),
        sessionId: optionalString(data, 'session_id', 'mirror_error'),
      ),
      'files_persisted' => FilesPersistedMessage(
        data: data,
        files: _objectList(data['files'], 'files_persisted.files'),
        failed: _objectList(data['failed'], 'files_persisted.failed'),
        processedAt: _requiredTimestamp(
          data['processed_at'],
          'files_persisted.processed_at',
        ),
        uuid: requiredString(data, 'uuid', 'files_persisted'),
        sessionId: requiredString(data, 'session_id', 'files_persisted'),
      ),
      'informational' => InformationalMessage(
        data: data,
        content: requiredString(data, 'content', 'informational'),
        level: requiredString(data, 'level', 'informational'),
        toolUseId: optionalString(data, 'tool_use_id', 'informational'),
        preventsContinuation:
            optionalBool(data, 'prevent_continuation', 'informational') ??
            false,
        uuid: requiredString(data, 'uuid', 'informational'),
        sessionId: requiredString(data, 'session_id', 'informational'),
      ),
      'local_command_output' => LocalCommandOutputMessage(
        data: data,
        content: requiredString(data, 'content', 'local_command_output'),
        uuid: requiredString(data, 'uuid', 'local_command_output'),
        sessionId: requiredString(data, 'session_id', 'local_command_output'),
      ),
      'memory_recall' => MemoryRecallMessage(
        data: data,
        mode: requiredString(data, 'mode', 'memory_recall'),
        memories: _objectList(data['memories'], 'memory_recall.memories')
            .map(
              (memory) => RecalledMemory(
                path: requiredString(memory, 'path', 'recalled memory'),
                scope: requiredString(memory, 'scope', 'recalled memory'),
                content: optionalString(memory, 'content', 'recalled memory'),
              ),
            )
            .toList(growable: false),
        uuid: requiredString(data, 'uuid', 'memory_recall'),
        sessionId: requiredString(data, 'session_id', 'memory_recall'),
      ),
      'model_refusal_fallback' => ModelRefusalFallbackMessage(
        data: data,
        direction: requiredString(data, 'direction', subtype),
        originalModel: requiredString(data, 'original_model', subtype),
        fallbackModel: requiredString(data, 'fallback_model', subtype),
        requestId: optionalString(data, 'request_id', subtype),
        category: optionalString(data, 'api_refusal_category', subtype),
        explanation: optionalString(data, 'api_refusal_explanation', subtype),
        refusedUserMessageId: optionalString(
          data,
          'refused_user_message_uuid',
          subtype,
        ),
        retractedMessageIds: _stringList(
          data['retracted_message_uuids'],
          '$subtype.retracted_message_uuids',
        ),
        content: requiredString(data, 'content', subtype),
        uuid: requiredString(data, 'uuid', subtype),
        sessionId: requiredString(data, 'session_id', subtype),
      ),
      'model_refusal_no_fallback' => ModelRefusalNoFallbackMessage(
        data: data,
        originalModel: requiredString(data, 'original_model', subtype),
        requestId: optionalString(data, 'request_id', subtype),
        category: optionalString(data, 'api_refusal_category', subtype),
        explanation: optionalString(data, 'api_refusal_explanation', subtype),
        refusedUserMessageId: optionalString(
          data,
          'refused_user_message_uuid',
          subtype,
        ),
        content: requiredString(data, 'content', subtype),
        uuid: requiredString(data, 'uuid', subtype),
        sessionId: requiredString(data, 'session_id', subtype),
      ),
      'notification' => RuntimeNotificationMessage(
        data: data,
        key: requiredString(data, 'key', 'notification'),
        text: requiredString(data, 'text', 'notification'),
        priority: requiredString(data, 'priority', 'notification'),
        color: optionalString(data, 'color', 'notification'),
        timeout: data['timeout_ms'] == null
            ? null
            : Duration(
                milliseconds: requiredInt(data, 'timeout_ms', 'notification'),
              ),
        uuid: requiredString(data, 'uuid', 'notification'),
        sessionId: requiredString(data, 'session_id', 'notification'),
      ),
      'permission_denied' => PermissionDeniedMessage(
        data: data,
        toolName: requiredString(data, 'tool_name', 'permission_denied'),
        toolUseId: requiredString(data, 'tool_use_id', 'permission_denied'),
        agentId: optionalString(data, 'agent_id', 'permission_denied'),
        decisionReasonType: optionalString(
          data,
          'decision_reason_type',
          'permission_denied',
        ),
        decisionReason: optionalString(
          data,
          'decision_reason',
          'permission_denied',
        ),
        message: requiredString(data, 'message', 'permission_denied'),
        uuid: requiredString(data, 'uuid', 'permission_denied'),
        sessionId: requiredString(data, 'session_id', 'permission_denied'),
      ),
      'plugin_install' => PluginInstallMessage(
        data: data,
        status: requiredString(data, 'status', 'plugin_install'),
        name: optionalString(data, 'name', 'plugin_install'),
        error: optionalString(data, 'error', 'plugin_install'),
        uuid: requiredString(data, 'uuid', 'plugin_install'),
        sessionId: requiredString(data, 'session_id', 'plugin_install'),
      ),
      'session_state_changed' => SessionStateChangedMessage(
        data: data,
        state: requiredString(data, 'state', 'session_state_changed'),
        uuid: requiredString(data, 'uuid', 'session_state_changed'),
        sessionId: requiredString(data, 'session_id', 'session_state_changed'),
      ),
      'status' => RuntimeStatusMessage(
        data: data,
        status: optionalString(data, 'status', 'status'),
        permissionMode: optionalString(data, 'permissionMode', 'status'),
        compactResult: optionalString(data, 'compact_result', 'status'),
        compactError: optionalString(data, 'compact_error', 'status'),
        uuid: requiredString(data, 'uuid', 'status'),
        sessionId: requiredString(data, 'session_id', 'status'),
      ),
      'thinking_tokens' => ThinkingTokensMessage(
        data: data,
        estimatedTokens: requiredInt(
          data,
          'estimated_tokens',
          'thinking_tokens',
        ),
        estimatedTokenDelta: requiredInt(
          data,
          'estimated_tokens_delta',
          'thinking_tokens',
        ),
        uuid: requiredString(data, 'uuid', 'thinking_tokens'),
        sessionId: requiredString(data, 'session_id', 'thinking_tokens'),
      ),
      'worker_shutting_down' => WorkerShuttingDownMessage(
        data: data,
        reason: requiredString(data, 'reason', 'worker_shutting_down'),
        uuid: requiredString(data, 'uuid', 'worker_shutting_down'),
        sessionId: requiredString(data, 'session_id', 'worker_shutting_down'),
      ),
      'commands_changed' => CommandsChangedMessage(
        data: data,
        commands: _objectList(
          data['commands'],
          'commands_changed.commands',
        ).map(ClaudeCommandInfo.fromJson).toList(growable: false),
        uuid: optionalString(data, 'uuid', 'commands_changed'),
        sessionId: optionalString(data, 'session_id', 'commands_changed'),
      ),
      'elicitation_complete' => ElicitationCompleteMessage(
        data: data,
        elicitationId: requiredString(
          data,
          'elicitation_id',
          'elicitation_complete',
        ),
        mcpServerName: optionalString(
          data,
          'mcp_server_name',
          'elicitation_complete',
        ),
        uuid: optionalString(data, 'uuid', 'elicitation_complete'),
        sessionId: optionalString(data, 'session_id', 'elicitation_complete'),
      ),
      'fast_mode_state' || 'fast_mode_changed' => FastModeStateMessage(
        subtype: subtype,
        data: data,
        state: requiredString(data, 'fast_mode_state', subtype),
        disabledReason: optionalString(
          data,
          'fast_mode_disabled_reason',
          subtype,
        ),
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
      skipTranscript:
          optionalBool(data, 'skip_transcript', 'task_notification') ?? false,
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
    hookId: optionalString(data, 'hook_id', 'hook event'),
    hookName: optionalString(data, 'hook_name', 'hook event'),
    stdout: optionalString(data, 'stdout', 'hook event'),
    stderr: optionalString(data, 'stderr', 'hook event'),
    output: optionalString(data, 'output', 'hook event'),
    exitCode: optionalInt(data, 'exit_code', 'hook event'),
    outcome: optionalString(data, 'outcome', 'hook event'),
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
      timeToFirstToken: _durationMilliseconds(data, 'ttft_ms', 'result'),
      streamTimeToFirstToken: _durationMilliseconds(
        data,
        'ttft_stream_ms',
        'result',
      ),
      timeToRequest: _durationMilliseconds(
        data,
        'time_to_request_ms',
        'result',
      ),
      userMessageId: optionalString(data, 'user_message_uuid', 'result'),
      requestSentAtMilliseconds: optionalInt(
        data,
        'request_sent_wall_ms',
        'result',
      ),
      timeToRequestFromSpawn: _durationMilliseconds(
        data,
        'time_to_request_from_spawn_ms',
        'result',
      ),
      warmSpareClaimed: optionalBool(data, 'warm_spare_claimed', 'result'),
      timeOriginMilliseconds: optionalInt(data, 'time_origin_ms', 'result'),
      fastModeState: optionalString(data, 'fast_mode_state', 'result'),
      fastModeDisabledReason: optionalString(
        data,
        'fast_mode_disabled_reason',
        'result',
      ),
      origin: optionalMap(data, 'origin', 'result'),
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
    timeToFirstToken: _durationMilliseconds(data, 'ttft_ms', 'stream_event'),
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
        isUsingOverage: optionalBool(raw, 'isUsingOverage', 'rate limit'),
        overageInUse: optionalBool(raw, 'overageInUse', 'rate limit'),
        surpassedThreshold: optionalDouble(
          raw,
          'surpassedThreshold',
          'rate limit',
        ),
        errorCode: optionalString(raw, 'errorCode', 'rate limit'),
        canUserPurchaseCredits: optionalBool(
          raw,
          'canUserPurchaseCredits',
          'rate limit',
        ),
        hasChargeableSavedPaymentMethod: optionalBool(
          raw,
          'hasChargeableSavedPaymentMethod',
          'rate limit',
        ),
        raw: raw,
      ),
      uuid: requiredString(data, 'uuid', 'rate_limit_event'),
      sessionId: requiredString(data, 'session_id', 'rate_limit_event'),
    );
  }

  AuthStatusMessage _authStatus(JsonMap data) => AuthStatusMessage(
    isAuthenticating: requiredBool(data, 'isAuthenticating', 'auth status'),
    output: _stringList(data['output'], 'auth status output'),
    error: optionalString(data, 'error', 'auth status'),
    uuid: requiredString(data, 'uuid', 'auth status'),
    sessionId: requiredString(data, 'session_id', 'auth status'),
  );

  ToolProgressMessage _toolProgress(JsonMap data) => ToolProgressMessage(
    toolUseId: requiredString(data, 'tool_use_id', 'tool progress'),
    toolName: requiredString(data, 'tool_name', 'tool progress'),
    parentToolUseId: optionalString(
      data,
      'parent_tool_use_id',
      'tool progress',
    ),
    elapsed: Duration(
      milliseconds:
          (requiredNum(
                    data,
                    'elapsed_time_seconds',
                    'tool progress',
                  ).toDouble() *
                  1000)
              .round(),
    ),
    taskId: optionalString(data, 'task_id', 'tool progress'),
    isHeartbeat: optionalBool(data, 'heartbeat', 'tool progress') ?? false,
    subagentType: optionalString(data, 'subagent_type', 'tool progress'),
    subagentRetry: optionalMap(data, 'subagent_retry', 'tool progress'),
    uuid: requiredString(data, 'uuid', 'tool progress'),
    sessionId: requiredString(data, 'session_id', 'tool progress'),
  );

  ToolUseSummaryMessage _toolUseSummary(JsonMap data) => ToolUseSummaryMessage(
    summary: requiredString(data, 'summary', 'tool use summary'),
    precedingToolUseIds: _stringList(
      data['preceding_tool_use_ids'],
      'tool use summary IDs',
    ),
    uuid: requiredString(data, 'uuid', 'tool use summary'),
    sessionId: requiredString(data, 'session_id', 'tool use summary'),
  );

  SessionKey? _sessionKey(Object? raw) {
    if (raw == null) return null;
    final json = asJsonMap(raw, 'mirror_error.key');
    return SessionKey(
      projectKey: requiredString(json, 'project_key', 'session key'),
      sessionId: requiredString(json, 'session_id', 'session key'),
      subpath: optionalString(json, 'subpath', 'session key'),
    );
  }

  List<JsonMap> _objectList(Object? raw, String context) {
    if (raw is! List<Object?>) {
      throw FormatException('$context must be an array');
    }
    return raw
        .map((value) => asJsonMap(value, '$context item'))
        .toList(growable: false);
  }

  List<JsonMap> _objectListOrEmpty(Object? raw, String context) =>
      raw == null ? const <JsonMap>[] : _objectList(raw, context);

  List<JsonValue> _jsonList(Object? raw, String context) {
    if (raw == null) return const <JsonValue>[];
    if (raw is! List<Object?>) {
      throw FormatException('$context must be an array');
    }
    return List<JsonValue>.unmodifiable(raw.map(immutableJsonValue));
  }

  Duration? _durationMilliseconds(JsonMap data, String key, String context) {
    final value = optionalInt(data, key, context);
    return value == null ? null : Duration(milliseconds: value);
  }

  List<String> _stringList(Object? raw, String context) {
    if (raw == null) return const <String>[];
    if (raw is! List<Object?> || raw.any((value) => value is! String)) {
      throw FormatException('$context must contain strings');
    }
    return List<String>.unmodifiable(raw.cast<String>());
  }

  DateTime? _timestamp(Object? raw, String context) {
    if (raw == null) return null;
    if (raw is! String) throw FormatException('$context must be a string');
    final value = DateTime.tryParse(raw);
    if (value == null) throw FormatException('$context must be ISO-8601');
    return value;
  }

  DateTime _requiredTimestamp(Object? raw, String context) {
    final value = _timestamp(raw, context);
    if (value == null) throw FormatException('$context is required');
    return value;
  }
}
