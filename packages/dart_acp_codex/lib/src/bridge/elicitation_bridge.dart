import 'dart:async';

import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../app_server/backend.dart';
import '../app_server/json_values.dart';
import '../session/state.dart';

/// Bridges Codex MCP elicitation and user-input requests to ACP.
final class CodexElicitationBridge {
  /// Creates a bridge for one client and session.
  CodexElicitationBridge({required this.client, required this.session});

  /// Client callback context.
  final AcpAgentContext client;

  /// Owning session.
  final CodexSessionState session;

  final Map<String, String> _pendingMcpCalls = <String, String>{};
  final Set<String> _pendingUrlElicitations = <String>{};

  /// Observes events used to correlate MCP calls and URL completion.
  Future<void> observe(CodexNotification notification) async {
    final item = notification.params.optionalObject('item');
    if (item?.optionalString('type') == 'mcpToolCall') {
      final server = item?.optionalString('server');
      final id = item?.optionalString('id');
      if (server != null && id != null) {
        if (notification.method == 'item/started') {
          _pendingMcpCalls[server] = id;
        } else if (notification.method == 'item/completed') {
          _pendingMcpCalls.remove(server);
        }
      }
    }
    if (notification.method == 'serverRequest/resolved') {
      final pending = List<String>.of(_pendingUrlElicitations);
      _pendingUrlElicitations.clear();
      for (final id in pending) {
        await client.completeElicitation(
          CompleteElicitationNotification(elicitationId: ElicitationId(id)),
        );
      }
    }
  }

  /// Handles one app-server elicitation or user-input request.
  Future<CodexJsonObject> handle(CodexServerRequest request) async {
    try {
      return switch (request) {
        CodexMcpElicitationRequest() => await _mcp(request),
        CodexUserInputRequest() => await _userInput(request),
        _ => throw ArgumentError.value(request, 'request'),
      };
    } on Object {
      return _safeDefault(request);
    }
  }

  Future<CodexJsonObject> _mcp(CodexMcpElicitationRequest request) async {
    final params = request.params;
    final mode = params.optionalString('mode');
    if (mode == 'openai/form') {
      return _mcpPermissionFallback(params);
    }
    final serverName = params.optionalString('serverName') ?? 'mcp';
    final correlatedId = _pendingMcpCalls.remove(serverName);
    final rawMeta = params['_meta'];
    final requestedSchema = params.optionalObject('requestedSchema');
    final payload = <String, Object?>{
      'mode': mode,
      'sessionId': session.sessionId.value,
      'toolCallId': ?correlatedId,
      'message': params.optionalString('message') ?? 'Input requested',
      '_meta': _metaWithServerName(rawMeta, serverName),
      if (mode == 'form')
        'requestedSchema': _normalizeSchema(
          requestedSchema?.toJson() ?? const <String, Object?>{},
        ),
      if (mode == 'url') 'url': params.requireString('url'),
      if (mode == 'url') 'elicitationId': params.requireString('elicitationId'),
    };
    final response = await client.createElicitation(
      CreateElicitationRequest.fromJson(payload),
    );
    final result = _elicitationResult(response);
    if (mode == 'url' && result['action'] == 'accept') {
      _pendingUrlElicitations.add(params.requireString('elicitationId'));
    }
    if (correlatedId != null && result['action'] == 'accept') {
      await client.updateSession(
        SessionNotification(
          sessionId: session.sessionId,
          update: SessionUpdate.fromJson(<String, Object?>{
            'sessionUpdate': 'tool_call_update',
            'toolCallId': correlatedId,
            'status': 'in_progress',
          }),
        ),
      );
    }
    return CodexJsonObject.from(result);
  }

  Future<CodexJsonObject> _mcpPermissionFallback(CodexJsonObject params) async {
    final server = params.optionalString('serverName') ?? 'MCP';
    final response = await client.requestPermission(
      RequestPermissionRequest.fromJson(<String, Object?>{
        'sessionId': session.sessionId.value,
        'toolCall': <String, Object?>{
          'toolCallId': 'elicitation-$server',
          'kind': 'other',
          'status': 'pending',
          'title': params.optionalString('message') ?? 'MCP input requested',
          'rawInput': params.toJson(),
        },
        'options': const <Object?>[
          <String, Object?>{
            'optionId': 'accept',
            'name': 'Accept',
            'kind': 'allow_once',
          },
          <String, Object?>{
            'optionId': 'decline',
            'name': 'Decline',
            'kind': 'reject_once',
          },
        ],
      }),
    );
    final outcome = response.outcome;
    final accepted =
        outcome is RequestPermissionOutcomeSelected &&
        outcome.value.optionId.value == 'accept';
    return CodexJsonObject.from(<String, Object?>{
      'action': accepted ? 'accept' : 'decline',
      'content': null,
      '_meta': null,
    });
  }

  Future<CodexJsonObject> _userInput(CodexUserInputRequest request) async {
    final params = request.params;
    final questions = params['questions'];
    if (questions is! List<Object?> || questions.isEmpty) {
      return _emptyAnswers;
    }
    final schema = _userInputSchema(questions);
    final first = questions.first;
    final message =
        questions.length == 1 &&
            first is Map<Object?, Object?> &&
            first['question'] is String
        ? first['question']! as String
        : 'Input requested';
    final create = CreateElicitationRequest.fromJson(<String, Object?>{
      'mode': 'form',
      'sessionId': session.sessionId.value,
      'toolCallId': params.optionalString('itemId'),
      'message': message,
      'requestedSchema': schema,
      '_meta': <String, Object?>{
        'codex': <String, Object?>{
          'autoResolutionMs': params.optionalInt('autoResolutionMs'),
        },
      },
    });
    final timeoutMs = params.optionalInt('autoResolutionMs');
    final response = await _createWithTimeout(create, timeoutMs);
    if (response == null || response is! CreateElicitationResponseAccept) {
      return _emptyAnswers;
    }
    final content = response.toJson()['content'];
    if (content is! Map<Object?, Object?>) {
      return _emptyAnswers;
    }
    return CodexJsonObject.from(<String, Object?>{
      'answers': _answers(questions, content),
    });
  }

  Future<CreateElicitationResponse?> _createWithTimeout(
    CreateElicitationRequest request,
    int? timeoutMs,
  ) async {
    if (timeoutMs == null) {
      return client.createElicitation(request);
    }
    final source = CancellationSource();
    final operation = client
        .createElicitation(request, cancellationToken: source.token)
        .then<CreateElicitationResponse?>((value) => value)
        .catchError((Object _) => null);
    final timeout = Future<CreateElicitationResponse?>.delayed(
      Duration(milliseconds: timeoutMs.clamp(0, 1 << 31)),
      () {
        source.cancel('auto-resolution timeout');
        return null;
      },
    );
    return Future.any<CreateElicitationResponse?>(
      <Future<CreateElicitationResponse?>>[operation, timeout],
    );
  }

  Map<String, Object?> _userInputSchema(List<Object?> questions) {
    final ids = <String>{
      for (final value in questions)
        if (value is Map<Object?, Object?> && value['id'] is String)
          value['id']! as String,
    };
    final properties = <String, Object?>{};
    final required = <Object?>[];
    for (final value in questions) {
      if (value is! Map<Object?, Object?> ||
          value['id'] is! String ||
          value['id'] == '') {
        continue;
      }
      final id = value['id']! as String;
      final options = value['options'];
      final hasOptions = options is List<Object?> && options.isNotEmpty;
      final hasOther = value['isOther'] == true && hasOptions;
      if (!hasOther) {
        required.add(id);
      }
      properties[id] = <String, Object?>{
        'type': 'string',
        'title': value['header'] is String && value['header'] != ''
            ? value['header']
            : id,
        'description': value['question'] is String ? value['question'] : null,
        if (hasOptions)
          'oneOf': <Object?>[
            for (final option in options)
              if (option is Map<Object?, Object?> && option['label'] is String)
                <String, Object?>{
                  'const': option['label'],
                  'title': option['label'],
                  if (option['description'] is String)
                    'description': option['description'],
                },
          ],
        '_meta': <String, Object?>{
          'codex': <String, Object?>{
            'isOther': value['isOther'] == true,
            'isSecret': value['isSecret'] == true,
          },
        },
      };
      if (hasOther) {
        properties[_otherFieldId(id, ids)] = <String, Object?>{
          'type': 'string',
          'title': 'Other',
          'description':
              'Type your own answer instead of choosing an option above.',
        };
      }
    }
    return <String, Object?>{
      'type': 'object',
      'properties': properties,
      'required': required,
    };
  }

  Map<String, Object?> _answers(
    List<Object?> questions,
    Map<Object?, Object?> content,
  ) {
    final ids = <String>{
      for (final value in questions)
        if (value is Map<Object?, Object?> && value['id'] is String)
          value['id']! as String,
    };
    final answers = <String, Object?>{};
    for (final value in questions) {
      if (value is! Map<Object?, Object?> || value['id'] is! String) {
        continue;
      }
      final id = value['id']! as String;
      final options = value['options'];
      final hasOther =
          value['isOther'] == true &&
          options is List<Object?> &&
          options.isNotEmpty;
      final answer = hasOther
          ? _nonEmpty(content[_otherFieldId(id, ids)]) ?? _nonEmpty(content[id])
          : _nonEmpty(content[id]);
      if (answer == null) {
        continue;
      }
      answers[id] = <String, Object?>{
        'answers': answer is List<Object?>
            ? <Object?>[for (final item in answer) item.toString()]
            : <Object?>[answer.toString()],
      };
    }
    return answers;
  }

  Object? _nonEmpty(Object? value) => switch (value) {
    String() when value.trim().isEmpty => null,
    List<Object?>() when value.isEmpty => null,
    _ => value,
  };

  String _otherFieldId(String id, Set<String> ids) {
    final base = '${id}__other';
    if (!ids.contains(base)) {
      return base;
    }
    var index = 1;
    while (ids.contains('$base$index')) {
      index += 1;
    }
    return '$base$index';
  }

  Map<String, Object?> _elicitationResult(CreateElicitationResponse response) {
    final json = response.toJson();
    final action = json['action'];
    if (action != 'accept' && action != 'decline' && action != 'cancel') {
      return <String, Object?>{
        'action': 'cancel',
        'content': null,
        '_meta': null,
      };
    }
    return <String, Object?>{
      'action': action,
      'content': action == 'accept' ? json['content'] : null,
      '_meta': json['_meta'],
    };
  }

  /// [rawMeta] with the MCP server that asked recorded under the adapter's own
  /// `codex` namespace.
  ///
  /// The elicitation itself carries `serverName`, but the ACP request keeps
  /// only the mode's own fields, `message` and `_meta` — so a client had no
  /// way to tell which server was asking, and could not, say, pre-approve a
  /// server it installed itself while still prompting for every other one.
  /// The server's own `_meta` is preserved; only the `codex` key is ours.
  Map<String, Object?> _metaWithServerName(Object? rawMeta, String serverName) {
    final meta = rawMeta is Map<Object?, Object?>
        ? <String, Object?>{
            for (final entry in rawMeta.entries)
              if (entry.key is String) entry.key! as String: entry.value,
          }
        : <String, Object?>{};
    final existing = meta['codex'];
    meta['codex'] = <String, Object?>{
      if (existing is Map<Object?, Object?>)
        for (final entry in existing.entries)
          if (entry.key is String) entry.key! as String: entry.value,
      'serverName': serverName,
    };
    return meta;
  }

  Map<String, Object?> _normalizeSchema(Map<String, Object?> value) {
    final normalized = _normalizeValue(value);
    if (normalized is! Map<String, Object?>) {
      return <String, Object?>{
        'type': 'object',
        'properties': <String, Object?>{},
      };
    }
    return <String, Object?>{...normalized, 'type': 'object'};
  }

  Object? _normalizeValue(Object? value) {
    if (value is List<Object?>) {
      return <Object?>[for (final item in value) _normalizeValue(item)];
    }
    if (value is! Map<Object?, Object?>) {
      return value;
    }
    final result = <String, Object?>{
      for (final entry in value.entries)
        if (entry.key is String)
          entry.key! as String: _normalizeValue(entry.value),
    };
    if (result['type'] == 'string' &&
        result['enum'] is List<Object?> &&
        result['enumNames'] is List<Object?> &&
        result['oneOf'] == null) {
      final values = result.remove('enum')! as List<Object?>;
      final names = result.remove('enumNames')! as List<Object?>;
      result['oneOf'] = <Object?>[
        for (var index = 0; index < values.length; index += 1)
          <String, Object?>{
            'const': values[index].toString(),
            'title': (index < names.length ? names[index] : values[index])
                .toString(),
          },
      ];
    }
    return result;
  }

  CodexJsonObject _safeDefault(CodexServerRequest request) =>
      request is CodexUserInputRequest
      ? _emptyAnswers
      : CodexJsonObject.from(<String, Object?>{
          'action': 'cancel',
          'content': null,
          '_meta': null,
        });

  CodexJsonObject get _emptyAnswers =>
      CodexJsonObject.from(<String, Object?>{'answers': <String, Object?>{}});
}
