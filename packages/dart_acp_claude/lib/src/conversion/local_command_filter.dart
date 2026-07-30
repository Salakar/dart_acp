/// Removes private local-command marker sections from transcript [content].
///
/// Returns `null` when no user-visible content remains.
Object? stripClaudeLocalCommandMetadata(Object? content) {
  if (content is String) {
    final stripped = _stripMarkers(content);
    return stripped.trim().isEmpty ? null : stripped;
  }
  if (content is! List<Object?>) return content;
  final kept = <Object?>[];
  for (final block in content) {
    if (block is Map<Object?, Object?> &&
        block['type'] == 'text' &&
        block['text'] is String) {
      final stripped = _stripMarkers(block['text']! as String);
      if (stripped.trim().isEmpty) continue;
      kept.add(<String, Object?>{
        for (final entry in block.entries)
          if (entry.key is String) entry.key! as String: entry.value,
        'text': stripped,
      });
    } else {
      kept.add(block);
    }
  }
  return kept.isEmpty ? null : List<Object?>.unmodifiable(kept);
}

/// Whether [content] consists only of local-command metadata.
bool isClaudeLocalCommandMetadata(Object? content) =>
    content != null && stripClaudeLocalCommandMetadata(content) == null;

String _stripMarkers(String value) {
  var result = value;
  for (final tag in _localCommandTags) {
    final open = '<$tag>';
    final close = '</$tag>';
    var from = 0;
    final output = StringBuffer();
    while (true) {
      final start = result.indexOf(open, from);
      if (start < 0) break;
      final end = result.indexOf(close, start + open.length);
      if (end < 0) break;
      output.write(result.substring(from, start));
      from = end + close.length;
    }
    if (from != 0) {
      output.write(result.substring(from));
      result = output.toString();
    }
  }
  return result;
}

const List<String> _localCommandTags = <String>[
  'command-name',
  'command-message',
  'command-args',
  'local-command-stdout',
  'local-command-stderr',
];
