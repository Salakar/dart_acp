import 'package:dart_acp_sdk/dart_acp_sdk.dart';

/// ACP prompt metadata key for a client-authored native Codex thread title.
///
/// Clients that prepend hidden instructions or context to the text prompt can
/// provide the original user-visible text here. An empty string deliberately
/// suppresses naming for that prompt, allowing a later substantive prompt to
/// name the thread.
const String codexThreadTitlePromptMetaKey = 'dart_acp_codex/threadTitle';

/// Derives a compact native Codex thread name from an ACP prompt.
final class CodexThreadTitle {
  const CodexThreadTitle._();

  /// Maximum number of Unicode code points retained in a derived title.
  static const int maxCodePoints = 80;

  /// Normalizes and bounds a client-authored title hint.
  static String? fromText(Object? value) {
    if (value is! String) {
      return null;
    }
    return _normalize(value);
  }

  /// Returns the normalized text portions of [prompt], or `null` when absent.
  static String? fromPrompt(Iterable<ContentBlock> prompt) {
    final text = prompt
        .whereType<ContentBlockText>()
        .map((block) => block.toJson()['text'])
        .whereType<String>()
        .join(' ')
        .trim();
    return _normalize(text);
  }

  static String? _normalize(String value) {
    final text = value.replaceAll(RegExp(r'\s+'), ' ').trim();
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
