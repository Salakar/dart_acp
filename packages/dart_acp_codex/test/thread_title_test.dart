import 'package:dart_acp_codex/src/session/thread_title.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

ContentBlock _text(String value) => ContentBlockText(TextContent(text: value));

void main() {
  test('normalizes and joins prompt text', () {
    expect(
      CodexThreadTitle.fromPrompt(<ContentBlock>[
        _text('  Review\n\tthe  '),
        _text('agent title '),
      ]),
      'Review the agent title',
    );
  });

  test('truncates to 80 Unicode code points without an ellipsis', () {
    final emoji79 = List<String>.filled(79, '😀').join();
    final title = CodexThreadTitle.fromPrompt(<ContentBlock>[
      _text('${emoji79}AB'),
    ]);

    expect(title?.runes.length, CodexThreadTitle.maxCodePoints);
    expect(title, '${emoji79}A');
  });

  test('returns null without text content', () {
    expect(CodexThreadTitle.fromPrompt(const <ContentBlock>[]), isNull);
  });

  test('normalizes a client-authored title hint independently', () {
    expect(CodexThreadTitle.fromText('  User\n prompt  '), 'User prompt');
    expect(CodexThreadTitle.fromText('   '), isNull);
    expect(CodexThreadTitle.fromText(42), isNull);
  });
}
