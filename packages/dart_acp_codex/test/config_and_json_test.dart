import 'package:dart_acp_codex/dart_acp_codex.dart';
import 'package:test/test.dart';

void main() {
  group('public configuration', () {
    test('mode ids round trip', () {
      for (final mode in CodexAgentMode.values) {
        expect(CodexAgentMode.tryParse(mode.id), same(mode));
      }
      expect(CodexAgentMode.tryParse('unknown'), isNull);
    });

    test('approval reviewer defaults to human review', () {
      final options = CodexAdapterOptions(
        environment: const <String, String>{},
      );

      expect(
        options.resolveApprovalsReviewer(
          agentMode: CodexAgentMode.workspaceWrite,
          collaborationMode: CodexCollaborationMode.standard,
        ),
        CodexApprovalsReviewer.user,
      );
    });

    test('automatic review is limited to standard workspace work', () {
      final options = CodexAdapterOptions(
        environment: const <String, String>{},
        workspaceWriteApprovalsReviewer: CodexApprovalsReviewer.autoReview,
      );

      expect(
        options.resolveApprovalsReviewer(
          agentMode: CodexAgentMode.workspaceWrite,
          collaborationMode: CodexCollaborationMode.standard,
        ),
        CodexApprovalsReviewer.autoReview,
      );
      expect(
        options.resolveApprovalsReviewer(
          agentMode: CodexAgentMode.readOnly,
          collaborationMode: CodexCollaborationMode.standard,
        ),
        CodexApprovalsReviewer.user,
      );
      expect(
        options.resolveApprovalsReviewer(
          agentMode: CodexAgentMode.workspaceWrite,
          collaborationMode: CodexCollaborationMode.plan,
        ),
        CodexApprovalsReviewer.user,
      );
    });

    test('model selection parses the final effort component', () {
      final selection = CodexModelSelection.parse('gpt/custom/high');
      expect(selection.model, 'gpt/custom');
      expect(selection.effort, CodexReasoningEffort.high);
      expect(selection.combinedId, 'gpt/custom/high');
    });

    test('model effort falls back to the model default', () {
      final model = CodexModel(
        id: 'model',
        name: 'Model',
        description: 'Model',
        isDefault: true,
        defaultReasoningEffort: CodexReasoningEffort.medium,
        reasoningEfforts: const <CodexReasoningEffort>[
          CodexReasoningEffort.low,
          CodexReasoningEffort.medium,
        ],
        inputModalities: const <CodexInputModality>[CodexInputModality.text],
      );
      expect(
        model.resolveEffort(CodexReasoningEffort.high),
        CodexReasoningEffort.medium,
      );
    });

    test('gateway validates URLs and redacts headers', () {
      expect(
        () => CodexGatewayConfiguration(
          baseUrl: Uri.parse('/relative'),
          headers: const <String, String>{},
        ),
        throwsA(isA<CodexConfigurationException>()),
      );
      final gateway = CodexGatewayConfiguration(
        baseUrl: Uri.parse('https://example.test/v1'),
        headers: const <String, String>{'Authorization': 'secret'},
      );
      expect(gateway.toString(), isNot(contains('secret')));
    });

    test('API key diagnostics redact the secret', () {
      const auth = CodexApiKeyAuthentication('super-secret');
      expect(auth.toString(), isNot(contains('super-secret')));
      expect(const CodexChatGptAuthentication(), isA<CodexAuthentication>());
      final headers = <String, String>{'Authorization': 'secret'};
      final gateway = CodexGatewayAuthentication(
        baseUrl: Uri.parse('https://example.test'),
        headers: headers,
        providerName: 'Gateway',
      );
      headers['Authorization'] = 'changed';
      expect(gateway.headers['Authorization'], 'secret');
      expect(gateway.toString(), isNot(contains('secret')));
      expect(const CodexUnauthenticated(), isA<CodexAuthenticationStatus>());
      expect(
        const CodexApiKeyAuthenticated(),
        isA<CodexAuthenticationStatus>(),
      );
      expect(
        const CodexChatGptAuthenticated(email: 'a@example.test').email,
        'a@example.test',
      );
      expect(const CodexGatewayAuthenticated(name: 'gateway').name, 'gateway');
    });

    test('inclusive input usage subtracts cached tokens', () {
      final usage = CodexUsage.fromInclusiveInput(
        totalTokens: 20,
        inputTokens: 12,
        cachedInputTokens: 5,
        outputTokens: 8,
        reasoningOutputTokens: 2,
      );
      expect(usage.inputTokens, 7);
      expect(usage.cachedInputTokens, 5);
      expect(
        () => CodexUsage.fromInclusiveInput(
          totalTokens: 1,
          inputTokens: 1,
          cachedInputTokens: 2,
          outputTokens: 0,
          reasoningOutputTokens: 0,
        ),
        throwsArgumentError,
      );
      final limit = CodexRateLimit(
        usedPercent: 25,
        windowDuration: const Duration(hours: 5),
        resetsAt: DateTime.utc(2026),
      );
      expect(limit.usedPercent, 25);
      expect(limit.windowDuration, const Duration(hours: 5));
    });

    test('diagnostics and every public exception are payload-safe', () {
      const diagnostic = CodexDiagnostic(
        level: CodexDiagnosticLevel.warning,
        category: CodexDiagnosticCategory.configuration,
        message: 'Invalid option.',
        exitCode: 2,
      );
      expect(diagnostic.exitCode, 2);
      expect(
        const <CodexAdapterException>[
          CodexConfigurationException('configuration'),
          CodexProtocolException('protocol'),
          CodexProcessException('process', exitCode: 3),
          CodexAuthenticationException('authentication'),
          CodexSessionException('session'),
          CodexUnsupportedFeatureException('unsupported'),
        ].map((error) => error.toString()),
        everyElement(isNot(contains('secret'))),
      );
    });
  });

  group('goal snapshots', () {
    test('creation time distinguishes replacement goals', () {
      final first = CodexGoalSnapshot(
        objective: 'Ship it',
        status: CodexGoalStatus.active,
        timeUsed: Duration.zero,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1),
      );
      final replacement = CodexGoalSnapshot(
        objective: 'Ship it',
        status: CodexGoalStatus.active,
        timeUsed: const Duration(seconds: 3),
        createdAt: DateTime.fromMillisecondsSinceEpoch(2),
      );
      expect(first.sameState(replacement), isFalse);
    });
  });
}
