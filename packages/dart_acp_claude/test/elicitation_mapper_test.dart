import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

void main() {
  const mapper = ClaudeElicitationMapper();
  final sessionId = SessionId('session');

  test('maps form and URL MCP elicitations in both directions', () {
    final form = mapper.mapMcpRequest(
      claude.ClaudeElicitationRequest.fromJson(<String, Object?>{
        'mode': 'form',
        'message': 'Choose',
        'requestedSchema': <String, Object?>{
          'properties': <String, Object?>{
            'answer': <String, Object?>{'type': 'string'},
          },
        },
      }),
      sessionId: sessionId,
      idGenerator: () => 'generated',
    );
    expect(form, isA<CreateElicitationRequestForm>());
    expect(form!.toJson()['requestedSchema'], containsPair('type', 'object'));

    final url = mapper.mapMcpRequest(
      claude.ClaudeElicitationRequest.fromJson(<String, Object?>{
        'mode': 'url',
        'message': 'Authorize',
        'url': 'https://example.test/auth',
      }),
      sessionId: sessionId,
      idGenerator: () => 'generated',
    );
    expect(url, isA<CreateElicitationRequestUrl>());
    expect(url!.toJson(), containsPair('elicitationId', 'generated'));

    expect(
      mapper
          .mapMcpResponse(
            CreateElicitationResponse.fromJson(<String, Object?>{
              'action': 'accept',
              'content': <String, Object?>{'answer': 'yes'},
            }),
          )
          .toJson(),
      <String, Object?>{
        'action': 'accept',
        'content': <String, Object?>{'answer': 'yes'},
      },
    );
    expect(
      mapper
          .mapMcpResponse(
            CreateElicitationResponse.fromJson(<String, Object?>{
              'action': '_future',
            }),
          )
          .action,
      claude.ClaudeElicitationAction.cancel,
    );
  });

  test('maps AskUserQuestion selections, custom answers, and cancellation', () {
    final input = <String, Object?>{
      'questions': <Object?>[
        <String, Object?>{
          'question': 'Which target?',
          'header': 'Target',
          'multiSelect': false,
          'options': <Object?>[
            <String, Object?>{
              'label': 'VM',
              'description': 'Run on the VM',
              'preview': 'dart run',
            },
          ],
        },
        <String, Object?>{
          'question': 'Which checks?',
          'multiSelect': true,
          'options': <Object?>[
            <String, Object?>{'label': 'Analyze'},
            <String, Object?>{'label': 'Test'},
          ],
        },
      ],
    };
    final request = mapper.mapAskUserQuestion(
      input,
      sessionId: sessionId,
      toolCallId: 'tool',
    );
    expect(request, isA<CreateElicitationRequestForm>());
    final json = request!.toJson();
    expect(json, containsPair('toolCallId', 'tool'));
    expect(json.toString(), contains('_askUserQuestionCustomAnswer'));

    final outcome = mapper.applyAskUserQuestionResponse(
      CreateElicitationResponse.fromJson(<String, Object?>{
        'action': 'accept',
        'content': <String, Object?>{
          'question_0_custom': 'Browser',
          'question_1': <Object?>['Analyze', 'Test'],
        },
      }),
      input,
    );
    expect(outcome, isA<ClaudeAskUserQuestionAnswered>());
    final updated = (outcome as ClaudeAskUserQuestionAnswered).updatedInput;
    expect(updated['answers'], <String, Object?>{
      'Which target?': 'Browser',
      'Which checks?': 'Analyze, Test',
    });

    expect(
      mapper.applyAskUserQuestionResponse(
        CreateElicitationResponse.fromJson(<String, Object?>{
          'action': 'cancel',
        }),
        input,
      ),
      isA<ClaudeAskUserQuestionCancelled>(),
    );
    expect(
      mapper.mapAskUserQuestion(
        const <String, Object?>{},
        sessionId: sessionId,
      ),
      isNull,
    );
  });

  test('requires explicit consent before retrying a refused model', () {
    final request = claude.ClaudeUserDialogRequest.fromJson(<String, Object?>{
      'dialog_kind': claudeRefusalFallbackDialogKind,
      'payload': <String, Object?>{
        'originalModel': 'Model A',
        'fallbackModel': 'Model B',
        'apiRefusalCategory': 'policy',
        'guidanceText': 'Review the request.',
      },
    });
    final form = mapper.mapRefusalFallback(request, sessionId: sessionId);
    expect(form, isA<CreateElicitationRequestForm>());
    expect(form!.toJson()['message'], contains('Model B'));

    expect(
      mapper
          .mapRefusalFallbackResponse(
            CreateElicitationResponse.fromJson(<String, Object?>{
              'action': 'accept',
              'content': <String, Object?>{'choice': 'retry_fallback'},
            }),
          )
          .toJson(),
      <String, Object?>{'behavior': 'completed', 'result': 'retry_fallback'},
    );
    expect(
      mapper
          .mapRefusalFallbackResponse(
            CreateElicitationResponse.fromJson(<String, Object?>{
              'action': 'decline',
            }),
          )
          .result,
      'cancelled',
    );
  });
}
