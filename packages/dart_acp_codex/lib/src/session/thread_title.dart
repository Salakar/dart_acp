import 'package:dart_acp_sdk/dart_acp_sdk.dart';

/// Derives a compact native Codex thread name from an ACP prompt.
final class CodexThreadTitle {
  const CodexThreadTitle._();

  /// Maximum number of Unicode code points retained in a derived title.
  static const int maxCodePoints = 80;

  /// Returns the normalized text portions of [prompt], or `null` when absent.
  static String? fromPrompt(Iterable<ContentBlock> prompt) {
    final text = prompt
        .whereType<ContentBlockText>()
        .map((block) => block.toJson()['text'])
        .whereType<String>()
        .join(' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (text.isEmpty) {
      return null;
    }
    final codePoints = text.runes;
    if (codePoints.length <= maxCodePoints) {
      return text;
    }
    return String.fromCharCodes(codePoints.take(maxCodePoints));
  }
}
