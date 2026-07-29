import 'dart:io';

/// Merges VM and browser LCOV reports into one deterministic report.
void main(List<String> arguments) {
  final options = _MergeOptions.parse(arguments);
  if (options == null) {
    exitCode = 64;
    return;
  }
  if (options.showHelp) {
    _printUsage();
    return;
  }

  final records = <String, _LcovRecord>{};
  for (final inputPath in options.inputs) {
    final input = File(inputPath).absolute;
    if (!input.existsSync()) {
      stderr.writeln('LCOV input does not exist: ${input.path}');
      exitCode = 66;
      return;
    }
    final parsed = _parseReport(input.readAsStringSync(), input.path);
    if (parsed.error case final error?) {
      stderr.writeln(error);
      exitCode = 65;
      return;
    }
    for (final entry in parsed.records.entries) {
      records
          .putIfAbsent(entry.key, () => _LcovRecord(entry.key))
          .merge(entry.value);
    }
  }

  final output = File(options.output).absolute;
  output.parent.createSync(recursive: true);
  final sourcePaths = records.keys.toList()..sort();
  final buffer = StringBuffer();
  for (final sourcePath in sourcePaths) {
    buffer.write(records[sourcePath]!.encode());
  }
  output.writeAsStringSync(buffer.toString());
  stdout.writeln(
    'Merged ${options.inputs.length} LCOV reports '
    'covering ${records.length} sources into ${output.path}.',
  );
}

_ParseResult _parseReport(String contents, String inputPath) {
  final records = <String, _LcovRecord>{};
  _LcovRecord? current;
  final lines = contents.split(RegExp(r'\r?\n'));
  for (var index = 0; index < lines.length; index += 1) {
    final line = lines[index].trim();
    if (line.isEmpty || line.startsWith('TN:')) {
      continue;
    }
    if (line.startsWith('SF:')) {
      if (current != null) {
        return _ParseResult.error(
          '$inputPath:${index + 1}: source record was not terminated.',
        );
      }
      final source = line.substring(3);
      if (source.isEmpty) {
        return _ParseResult.error(
          '$inputPath:${index + 1}: empty LCOV source path.',
        );
      }
      current = _LcovRecord(source);
      continue;
    }
    if (line == 'end_of_record') {
      if (current == null) {
        return _ParseResult.error(
          '$inputPath:${index + 1}: unexpected end_of_record.',
        );
      }
      records
          .putIfAbsent(current.source, () => _LcovRecord(current!.source))
          .merge(current);
      current = null;
      continue;
    }
    if (current == null) {
      return _ParseResult.error(
        '$inputPath:${index + 1}: LCOV data appeared before SF.',
      );
    }
    final error = current.addLine(line);
    if (error != null) {
      return _ParseResult.error('$inputPath:${index + 1}: $error');
    }
  }
  if (current != null) {
    return _ParseResult.error(
      '$inputPath: final source record was not closed.',
    );
  }
  return _ParseResult(records);
}

final class _LcovRecord {
  _LcovRecord(this.source);

  final String source;
  final Map<String, String> functions = <String, String>{};
  final Map<String, int> functionHits = <String, int>{};
  final Map<String, int?> branchHits = <String, int?>{};
  final Map<int, _LineHit> lineHits = <int, _LineHit>{};
  final Set<String> otherLines = <String>{};

  String? addLine(String line) {
    final separator = line.indexOf(':');
    if (separator < 0) {
      return 'malformed LCOV record "$line".';
    }
    final tag = line.substring(0, separator);
    final value = line.substring(separator + 1);
    switch (tag) {
      case 'FN':
        final comma = value.indexOf(',');
        if (comma < 1 || comma == value.length - 1) {
          return 'malformed FN record.';
        }
        functions[value.substring(comma + 1)] = value.substring(0, comma);
      case 'FNDA':
        final comma = value.indexOf(',');
        final hits = comma < 1 ? null : int.tryParse(value.substring(0, comma));
        if (hits == null || comma == value.length - 1) {
          return 'malformed FNDA record.';
        }
        _keepMaximum(functionHits, value.substring(comma + 1), hits);
      case 'BRDA':
        final fields = value.split(',');
        if (fields.length != 4 ||
            int.tryParse(fields[0]) == null ||
            int.tryParse(fields[1]) == null ||
            int.tryParse(fields[2]) == null) {
          return 'malformed BRDA record.';
        }
        final key = '${fields[0]},${fields[1]},${fields[2]}';
        final hits = fields[3] == '-' ? null : int.tryParse(fields[3]);
        if (fields[3] != '-' && hits == null) {
          return 'malformed BRDA hit count.';
        }
        final previous = branchHits[key];
        if (!branchHits.containsKey(key) ||
            (hits != null && (previous == null || hits > previous))) {
          branchHits[key] = hits;
        }
      case 'DA':
        final fields = value.split(',');
        if (fields.length < 2 || fields.length > 3) {
          return 'malformed DA record.';
        }
        final lineNumber = int.tryParse(fields[0]);
        final hits = int.tryParse(fields[1]);
        if (lineNumber == null || lineNumber < 1 || hits == null || hits < 0) {
          return 'malformed DA values.';
        }
        final checksum = fields.length == 3 ? fields[2] : null;
        final previous = lineHits[lineNumber];
        if (previous == null || hits > previous.hits) {
          lineHits[lineNumber] = _LineHit(hits, checksum ?? previous?.checksum);
        }
      case 'FNF':
      case 'FNH':
      case 'BRF':
      case 'BRH':
      case 'LF':
      case 'LH':
        break;
      default:
        otherLines.add(line);
    }
    return null;
  }

  void merge(_LcovRecord other) {
    functions.addAll(other.functions);
    for (final entry in other.functionHits.entries) {
      _keepMaximum(functionHits, entry.key, entry.value);
    }
    for (final entry in other.branchHits.entries) {
      final previous = branchHits[entry.key];
      if (!branchHits.containsKey(entry.key) ||
          (entry.value != null &&
              (previous == null || entry.value! > previous))) {
        branchHits[entry.key] = entry.value;
      }
    }
    for (final entry in other.lineHits.entries) {
      final previous = lineHits[entry.key];
      if (previous == null || entry.value.hits > previous.hits) {
        lineHits[entry.key] = entry.value;
      }
    }
    otherLines.addAll(other.otherLines);
  }

  String encode() {
    final buffer = StringBuffer()..writeln('SF:$source');
    final functionNames = functions.keys.toList()..sort();
    for (final name in functionNames) {
      buffer.writeln('FN:${functions[name]},$name');
    }
    final functionHitNames = functionHits.keys.toList()..sort();
    for (final name in functionHitNames) {
      buffer.writeln('FNDA:${functionHits[name]},$name');
    }
    if (functions.isNotEmpty || functionHits.isNotEmpty) {
      final allFunctionNames = <String>{
        ...functions.keys,
        ...functionHits.keys,
      };
      buffer
        ..writeln('FNF:${allFunctionNames.length}')
        ..writeln(
          'FNH:${allFunctionNames.where((name) {
            return (functionHits[name] ?? 0) > 0;
          }).length}',
        );
    }

    final branchKeys = branchHits.keys.toList()..sort(_compareBranchKeys);
    for (final key in branchKeys) {
      buffer.writeln('BRDA:$key,${branchHits[key] ?? '-'}');
    }
    if (branchKeys.isNotEmpty) {
      buffer
        ..writeln('BRF:${branchKeys.length}')
        ..writeln(
          'BRH:${branchKeys.where((key) => (branchHits[key] ?? 0) > 0).length}',
        );
    }

    final lineNumbers = lineHits.keys.toList()..sort();
    for (final lineNumber in lineNumbers) {
      final hit = lineHits[lineNumber]!;
      buffer.write('DA:$lineNumber,${hit.hits}');
      if (hit.checksum case final checksum?) {
        buffer.write(',$checksum');
      }
      buffer.writeln();
    }
    if (lineNumbers.isNotEmpty) {
      buffer
        ..writeln('LF:${lineNumbers.length}')
        ..writeln(
          'LH:${lineNumbers.where((line) => lineHits[line]!.hits > 0).length}',
        );
    }
    final sortedOther = otherLines.toList()..sort();
    for (final line in sortedOther) {
      buffer.writeln(line);
    }
    buffer.writeln('end_of_record');
    return buffer.toString();
  }
}

void _keepMaximum(Map<String, int> values, String key, int value) {
  final previous = values[key];
  if (previous == null || value > previous) {
    values[key] = value;
  }
}

int _compareBranchKeys(String left, String right) {
  final leftValues = left.split(',').map(int.parse).toList();
  final rightValues = right.split(',').map(int.parse).toList();
  for (var index = 0; index < leftValues.length; index += 1) {
    final result = leftValues[index].compareTo(rightValues[index]);
    if (result != 0) {
      return result;
    }
  }
  return 0;
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run tool/merge_coverage.dart '
    '--output=<merged-lcov> <input-lcov> <input-lcov> [...].',
  );
}

final class _MergeOptions {
  const _MergeOptions({
    required this.output,
    required this.inputs,
    required this.showHelp,
  });

  final String output;
  final List<String> inputs;
  final bool showHelp;

  static _MergeOptions? parse(List<String> arguments) {
    String? output;
    var showHelp = false;
    final inputs = <String>[];
    for (final argument in arguments) {
      if (argument == '--help' || argument == '-h') {
        showHelp = true;
      } else if (argument.startsWith('--output=')) {
        output = argument.substring('--output='.length);
      } else if (argument.startsWith('-')) {
        stderr.writeln('Unknown argument: $argument');
        return null;
      } else {
        inputs.add(argument);
      }
    }
    if (showHelp) {
      return const _MergeOptions(
        output: '',
        inputs: <String>[],
        showHelp: true,
      );
    }
    if (output == null || output.isEmpty || inputs.length < 2) {
      _printUsage();
      return null;
    }
    return _MergeOptions(output: output, inputs: inputs, showHelp: false);
  }
}

final class _LineHit {
  const _LineHit(this.hits, this.checksum);

  final int hits;
  final String? checksum;
}

final class _ParseResult {
  const _ParseResult(this.records) : error = null;

  const _ParseResult.error(String message)
    : records = const <String, _LcovRecord>{},
      error = message;

  final Map<String, _LcovRecord> records;
  final String? error;
}
