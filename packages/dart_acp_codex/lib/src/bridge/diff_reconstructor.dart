import 'dart:io';

import '../app_server/json_values.dart';

/// Reconstructs ACP diff content from an app-server file change.
final class CodexDiffReconstructor {
  /// Creates a reconstructor.
  const CodexDiffReconstructor();

  /// Returns an ACP `diff` content object, or `null` for an unusable patch.
  Map<String, Object?>? reconstruct(CodexJsonObject change) {
    final path = change.optionalString('path');
    final diff = change.optionalString('diff');
    final kind = change.optionalObject('kind');
    final type = kind?.optionalString('type');
    if (path == null || diff == null || type == null) {
      return null;
    }
    return switch (type) {
      'add' => _content(path: path, oldText: null, newText: diff, kind: type),
      'delete' => _content(path: path, oldText: diff, newText: '', kind: type),
      'update' => _update(
        path: path,
        movePath: kind?.optionalString('move_path'),
        diff: diff.replaceFirst(RegExp(r'\n\nMoved to: .*$'), '\n'),
      ),
      _ => null,
    };
  }

  Map<String, Object?>? _update({
    required String path,
    required String? movePath,
    required String diff,
  }) {
    final source = _read(path);
    if (source != null) {
      final patched = _apply(source, diff);
      if (patched != null) {
        return _content(
          path: movePath ?? path,
          oldText: source,
          newText: patched,
          kind: 'update',
        );
      }
      final reverted = _apply(source, diff, reverse: true);
      if (reverted != null) {
        return _content(
          path: movePath ?? path,
          oldText: reverted,
          newText: source,
          kind: 'update',
        );
      }
    }
    if (movePath == null) {
      return null;
    }
    final moved = _read(movePath);
    final reverted = moved == null ? null : _apply(moved, diff, reverse: true);
    if (moved == null || reverted == null) {
      return null;
    }
    return _content(
      path: movePath,
      oldText: reverted,
      newText: moved,
      kind: 'update',
    );
  }

  String? _read(String path) {
    try {
      return File(path).readAsStringSync();
    } on FileSystemException {
      return null;
    }
  }

  String? _apply(String input, String patch, {bool reverse = false}) {
    final inputLines = _lines(input);
    final patchLines = _lines(patch);
    final output = <String>[];
    var inputIndex = 0;
    var index = 0;
    var delta = 0;
    var sawHunk = false;
    while (index < patchLines.length) {
      final header = patchLines[index];
      final match = RegExp(
        r'^@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@',
      ).firstMatch(header);
      if (match == null) {
        index += 1;
        continue;
      }
      sawHunk = true;
      final oldStart = int.parse(match.group(1)!);
      final newStart = int.parse(match.group(2)!);
      final target = ((reverse ? newStart : oldStart) - 1 + delta).clamp(
        inputIndex,
        inputLines.length,
      );
      output.addAll(inputLines.getRange(inputIndex, target));
      inputIndex = target;
      index += 1;
      while (index < patchLines.length &&
          !patchLines[index].startsWith('@@ ')) {
        final line = patchLines[index];
        index += 1;
        if (line.startsWith(r'\ No newline at end of file')) {
          continue;
        }
        if (line.isEmpty) {
          continue;
        }
        final marker = line[0];
        final value = line.substring(1);
        final effective = reverse
            ? switch (marker) {
                '+' => '-',
                '-' => '+',
                _ => marker,
              }
            : marker;
        switch (effective) {
          case ' ':
            if (inputIndex >= inputLines.length ||
                inputLines[inputIndex] != value) {
              return null;
            }
            output.add(value);
            inputIndex += 1;
          case '-':
            if (inputIndex >= inputLines.length ||
                inputLines[inputIndex] != value) {
              return null;
            }
            inputIndex += 1;
            delta -= 1;
          case '+':
            output.add(value);
            delta += 1;
          default:
            return null;
        }
      }
    }
    if (!sawHunk) {
      return null;
    }
    output.addAll(inputLines.skip(inputIndex));
    return output.join();
  }

  List<String> _lines(String value) => RegExp(r'.*(?:\n|$)', multiLine: true)
      .allMatches(value)
      .map((match) => match.group(0)!)
      .where((line) {
        return line.isNotEmpty;
      })
      .toList(growable: false);

  Map<String, Object?> _content({
    required String path,
    required String? oldText,
    required String newText,
    required String kind,
  }) => <String, Object?>{
    'type': 'diff',
    'oldText': oldText,
    'newText': newText,
    'path': path,
    '_meta': <String, Object?>{'kind': kind},
  };
}
