import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

/// Dialog kind used when a declined model offers an explicit fallback.
const String claudeRefusalFallbackDialogKind = 'refusal_fallback_prompt';

/// Result of applying an AskUserQuestion form response.
sealed class ClaudeAskUserQuestionOutcome {
  const ClaudeAskUserQuestionOutcome();
}

/// The question was answered or skipped and carries replacement tool input.
final class ClaudeAskUserQuestionAnswered extends ClaudeAskUserQuestionOutcome {
  /// Creates an answered outcome.
  ClaudeAskUserQuestionAnswered(Map<String, Object?> updatedInput)
    : updatedInput = Map<String, Object?>.unmodifiable(updatedInput);

  /// Tool input with its `answers` field populated.
  final Map<String, Object?> updatedInput;
}

/// The question interaction was cancelled.
final class ClaudeAskUserQuestionCancelled
    extends ClaudeAskUserQuestionOutcome {
  /// Creates a cancelled outcome.
  const ClaudeAskUserQuestionCancelled();
}

/// Converts Claude interactive requests to ACP elicitations and back.
final class ClaudeElicitationMapper {
  /// Creates an elicitation mapper.
  const ClaudeElicitationMapper();

  /// Maps an MCP request, or returns `null` when it cannot be represented.
  CreateElicitationRequest? mapMcpRequest(
    claude.ClaudeElicitationRequest request, {
    required SessionId sessionId,
    required String Function() idGenerator,
  }) {
    switch (request.mode) {
      case claude.ClaudeElicitationMode.form:
        return CreateElicitationRequest.fromJson(<String, Object?>{
          'mode': 'form',
          'sessionId': sessionId.value,
          'message': request.message,
          'requestedSchema': _normalizeSchema(request.schema),
        });
      case claude.ClaudeElicitationMode.url:
        final rawUrl = request.url;
        if (rawUrl == null) return null;
        final url = Uri.tryParse(rawUrl);
        if (url == null || !url.hasScheme) return null;
        return CreateElicitationRequest.fromJson(<String, Object?>{
          'mode': 'url',
          'sessionId': sessionId.value,
          'message': request.message,
          'url': url.toString(),
          'elicitationId': request.elicitationId ?? idGenerator(),
        });
    }
  }

  /// Maps an ACP response to the result expected by the Claude runtime.
  claude.ClaudeElicitationResult mapMcpResponse(
    CreateElicitationResponse response,
  ) {
    return switch (response) {
      CreateElicitationResponseAccept() =>
        claude.ClaudeElicitationResult.accept(
          _jsonObject(response.toJson()['content']),
        ),
      CreateElicitationResponseDecline() =>
        const claude.ClaudeElicitationResult.decline(),
      CreateElicitationResponseCancel() || CreateElicitationResponseCustom() =>
        const claude.ClaudeElicitationResult.cancel(),
    };
  }

  /// Builds a form for the valid questions in [toolInput].
  ///
  /// Returns `null` when no usable question exists.
  CreateElicitationRequest? mapAskUserQuestion(
    Map<String, Object?> toolInput, {
    required SessionId sessionId,
    String? toolCallId,
  }) {
    final questions = _questions(toolInput);
    if (questions == null) return null;
    final properties = <String, Object?>{};
    final single = questions.length == 1;
    for (var index = 0; index < questions.length; index += 1) {
      final question = questions[index];
      final options = question.options
          .map(
            (option) => <String, Object?>{
              'const': option.label,
              'title': option.label,
              'description': ?option.description,
              '_meta': ?(option.preview == null
                  ? null
                  : <String, Object?>{
                      '_claude/askUserQuestionOption': <String, Object?>{
                        'preview': option.preview,
                      },
                    }),
            },
          )
          .toList(growable: false);
      properties['question_$index'] = question.multiSelect
          ? <String, Object?>{
              'type': 'array',
              'title': ?question.header,
              if (!single) 'description': question.question,
              'items': <String, Object?>{'anyOf': options},
            }
          : <String, Object?>{
              'type': 'string',
              'title': ?question.header,
              if (!single) 'description': question.question,
              'oneOf': options,
            };
      properties['question_${index}_custom'] = <String, Object?>{
        'type': 'string',
        'title': 'Other',
        'description':
            'Type your own answer instead of choosing an option above '
            '(optional).',
        '_meta': <String, Object?>{
          '_askUserQuestionCustomAnswer': <String, Object?>{
            'questionId': 'question_$index',
            'isCustomAnswer': true,
          },
        },
      };
    }
    return CreateElicitationRequest.fromJson(<String, Object?>{
      'mode': 'form',
      'sessionId': sessionId.value,
      'toolCallId': ?toolCallId,
      'message': single
          ? questions.single.question
          : 'Please answer the following questions.',
      'requestedSchema': <String, Object?>{
        'type': 'object',
        'properties': properties,
      },
    });
  }

  /// Applies an AskUserQuestion response to [toolInput].
  ClaudeAskUserQuestionOutcome applyAskUserQuestionResponse(
    CreateElicitationResponse response,
    Map<String, Object?> toolInput,
  ) {
    final questions = _questions(toolInput);
    if (questions == null) return const ClaudeAskUserQuestionCancelled();
    if (response is CreateElicitationResponseDecline) {
      return ClaudeAskUserQuestionAnswered(<String, Object?>{
        ...toolInput,
        'answers': <String, Object?>{},
      });
    }
    if (response is! CreateElicitationResponseAccept) {
      return const ClaudeAskUserQuestionCancelled();
    }
    final content = _jsonObject(response.toJson()['content']);
    final answers = <String, Object?>{};
    for (var index = 0; index < questions.length; index += 1) {
      final question = questions[index];
      final custom = content['question_${index}_custom'];
      if (custom is String && custom.trim().isNotEmpty) {
        answers[question.question] = custom.trim();
        continue;
      }
      final selected = content['question_$index'];
      final answer = switch (selected) {
        List<Object?>() => selected.map((value) => '$value').join(', '),
        null => '',
        _ => '$selected',
      };
      if (answer.isNotEmpty) answers[question.question] = answer;
    }
    return ClaudeAskUserQuestionAnswered(<String, Object?>{
      ...toolInput,
      'answers': answers,
    });
  }

  /// Builds the safe model-fallback consent form for a dialog request.
  CreateElicitationRequest? mapRefusalFallback(
    claude.ClaudeUserDialogRequest request, {
    required SessionId sessionId,
  }) {
    if (request.dialogKind != claudeRefusalFallbackDialogKind) return null;
    final original = request.payload['originalModel'];
    final fallback = request.payload['fallbackModel'];
    if (original is! String || fallback is! String) return null;
    final category = request.payload['apiRefusalCategory'];
    final guidance = request.payload['guidanceText'];
    final categoryText = category is String ? ' ($category)' : '';
    final guidanceText = guidance is String && guidance.isNotEmpty
        ? '\n\n$guidance'
        : '';
    return CreateElicitationRequest.fromJson(<String, Object?>{
      'mode': 'form',
      'sessionId': sessionId.value,
      'message':
          '$original declined this request$categoryText. '
          'Retry with $fallback?$guidanceText',
      'requestedSchema': <String, Object?>{
        'type': 'object',
        'properties': <String, Object?>{
          'choice': <String, Object?>{
            'type': 'string',
            'oneOf': <Object?>[
              <String, Object?>{
                'const': 'retry_fallback',
                'title': 'Retry with $fallback',
                'description': 'The session continues on $fallback.',
              },
              const <String, Object?>{
                'const': 'cancelled',
                'title': 'Keep the refusal',
                'description': 'You can send a new message.',
              },
            ],
          },
        },
      },
    });
  }

  /// Maps a fallback consent response to the runtime dialog result.
  claude.ClaudeUserDialogResult mapRefusalFallbackResponse(
    CreateElicitationResponse response,
  ) {
    final content = response is CreateElicitationResponseAccept
        ? _jsonObject(response.toJson()['content'])
        : const <String, Object?>{};
    final result = content['choice'] == 'retry_fallback'
        ? 'retry_fallback'
        : 'cancelled';
    return claude.ClaudeUserDialogResult.completed(result);
  }

  Map<String, Object?> _normalizeSchema(Map<String, Object?>? schema) {
    if (schema == null) {
      return <String, Object?>{
        'type': 'object',
        'properties': <String, Object?>{},
      };
    }
    return <String, Object?>{...schema, 'type': 'object'};
  }

  Map<String, Object?> _jsonObject(Object? value) {
    if (value is! Map<Object?, Object?>) return <String, Object?>{};
    return <String, Object?>{
      for (final entry in value.entries)
        if (entry.key is String) entry.key! as String: entry.value,
    };
  }

  List<_Question>? _questions(Map<String, Object?> input) {
    final rawQuestions = input['questions'];
    if (rawQuestions is! List<Object?>) return null;
    final questions = <_Question>[];
    for (final value in rawQuestions) {
      if (value is! Map<Object?, Object?> || value['question'] is! String) {
        continue;
      }
      final rawOptions = value['options'];
      if (rawOptions is! List<Object?> || rawOptions.isEmpty) continue;
      final options = <_QuestionOption>[];
      for (final option in rawOptions) {
        if (option is! Map<Object?, Object?> || option['label'] is! String) {
          continue;
        }
        options.add(
          _QuestionOption(
            label: option['label']! as String,
            description: option['description'] as String?,
            preview: option['preview'] as String?,
          ),
        );
      }
      if (options.isEmpty) continue;
      final rawHeader = value['header'];
      questions.add(
        _Question(
          question: value['question']! as String,
          header: rawHeader is String && rawHeader.isNotEmpty
              ? rawHeader
              : null,
          multiSelect: value['multiSelect'] == true,
          options: options,
        ),
      );
    }
    return questions.isEmpty ? null : questions;
  }
}

final class _Question {
  const _Question({
    required this.question,
    required this.header,
    required this.multiSelect,
    required this.options,
  });

  final String question;
  final String? header;
  final bool multiSelect;
  final List<_QuestionOption> options;
}

final class _QuestionOption {
  const _QuestionOption({
    required this.label,
    required this.description,
    required this.preview,
  });

  final String label;
  final String? description;
  final String? preview;
}
