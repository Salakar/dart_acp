const Set<String> _reservedWords = <String>{
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};

/// Converts a schema definition name to a valid Dart type name.
String dartTypeName(String source) {
  final words = _words(source);
  if (words.isEmpty) {
    throw FormatException('Cannot derive a Dart type name from "$source"');
  }
  final result = words.map(_upperCamelWord).join();
  return _startsWithDigit(result) ? 'Value$result' : result;
}

/// Converts a JSON property name to a valid Dart member name.
String dartMemberName(String source) {
  if (source == '_meta') {
    return 'meta';
  }
  final words = _words(source);
  if (words.isEmpty) {
    throw FormatException('Cannot derive a Dart member name from "$source"');
  }
  final String first = words.first.toLowerCase();
  final String result = <String>[
    first,
    for (final String word in words.skip(1)) _upperCamelWord(word),
  ].join();
  final normalized = _startsWithDigit(result) ? 'value$result' : result;
  return _reservedWords.contains(normalized)
      ? '${normalized}Value'
      : normalized;
}

/// Converts an exact wire method to a deterministic Dart identifier.
String dartMethodName(String method) {
  final cleaned = method.startsWith(r'$/') ? method.substring(2) : method;
  return dartMemberName(cleaned);
}

/// Converts a tagged-union discriminator to a class-name suffix.
String dartVariantSuffix(String tag) => dartTypeName(tag);

/// Escapes [value] as a single-quoted Dart string literal.
String dartStringLiteral(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$')
      .replaceAll('\r', r'\r')
      .replaceAll('\n', r'\n');
  return "'$escaped'";
}

/// Makes upstream prose safe for a Dart documentation comment.
///
/// Rustdoc-style code references such as ``[`ContentBlock::Text`]`` look like
/// Dartdoc element links but cannot resolve to Dart identifiers. They remain
/// readable code spans, while actual Markdown links are left intact.
String sanitizeDartdoc(String value) => value
    .replaceAllMapped(
      RegExp(r'\[`([^`\r\n]+)`\](?![\(\[])'),
      (Match match) => '`${match.group(1)}`',
    )
    .replaceAll('///', '')
    .replaceAll('*/', '* /')
    .trimRight();

List<String> _words(String source) {
  final separated = source
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (Match match) => '${match.group(1)} ${match.group(2)}',
      )
      .replaceAll(RegExp('[^A-Za-z0-9]+'), ' ')
      .trim();
  if (separated.isEmpty) {
    return const <String>[];
  }
  return separated
      .split(RegExp(r'\s+'))
      .where((String word) => word.isNotEmpty)
      .toList(growable: false);
}

String _upperCamelWord(String word) {
  final lower = word.toLowerCase();
  return '${lower.substring(0, 1).toUpperCase()}${lower.substring(1)}';
}

bool _startsWithDigit(String value) {
  final int first = value.codeUnitAt(0);
  return first >= 48 && first <= 57;
}
