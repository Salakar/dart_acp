import 'dart:convert';

/// Decodes JSON after enforcing an iterative structural nesting limit.
///
/// The pre-scan bounds parser recursion without recursively walking attacker-
/// controlled input. Brackets inside JSON strings are deliberately ignored.
Object? decodeBoundedJson(String source, {required int maximumNestingDepth}) {
  if (maximumNestingDepth <= 0) {
    throw ArgumentError.value(
      maximumNestingDepth,
      'maximumNestingDepth',
      'must be positive',
    );
  }
  var depth = 0;
  var inString = false;
  var escaped = false;
  for (var index = 0; index < source.length; index += 1) {
    final int character = source.codeUnitAt(index);
    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (character == 0x5c) {
        escaped = true;
      } else if (character == 0x22) {
        inString = false;
      }
      continue;
    }
    if (character == 0x22) {
      inString = true;
      continue;
    }
    if (character == 0x7b || character == 0x5b) {
      depth += 1;
      if (depth > maximumNestingDepth) {
        throw const FormatException('JSON exceeds maximum nesting depth');
      }
    } else if ((character == 0x7d || character == 0x5d) && depth > 0) {
      depth -= 1;
    }
  }
  return jsonDecode(source);
}
