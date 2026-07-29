import 'dart:convert';
import 'dart:io';

const List<String> _laneNames = <String>[
  'v1Stable',
  'v1Unstable',
  'v2Stable',
  'v2Unstable',
];

void main(List<String> arguments) {
  var lcovPath = 'coverage/lcov.info';
  var minimum = 95.0;
  for (final String argument in arguments) {
    if (argument.startsWith('--lcov=')) {
      lcovPath = argument.substring('--lcov='.length);
    } else if (argument.startsWith('--minimum=')) {
      minimum =
          double.tryParse(argument.substring('--minimum='.length)) ??
          double.nan;
    } else {
      _usage('Unknown argument: $argument');
    }
  }
  if (!minimum.isFinite || minimum < 0 || minimum > 100) {
    _usage('Minimum must be a percentage from 0 through 100.');
  }

  final File lcov = File(lcovPath);
  if (!lcov.existsSync()) {
    stderr.writeln('Coverage input does not exist: ${lcov.path}');
    exitCode = 66;
    return;
  }
  final _Coverage coverage = _parseLcov(lcov);
  final Directory packageRoot = File.fromUri(
    Platform.script,
  ).parent.parent.parent;
  final List<String> errors = _checkIgnorePolicy(packageRoot);

  var aggregateFound = 0;
  var aggregateHit = 0;
  for (final String lane in _laneNames) {
    final Map<String, int> lines = coverage.linesByLane[lane]!;
    final int found = lines.length;
    final int hit = lines.values.where((int count) => count > 0).length;
    aggregateFound += found;
    aggregateHit += hit;
    final double percent = found == 0 ? 0 : 100 * hit / found;
    stdout.writeln('$lane $hit/$found ${percent.toStringAsFixed(2)}%');
    if (found == 0) {
      errors.add('$lane has no executable generated lines in LCOV.');
    } else if (percent + 1e-9 < minimum) {
      errors.add(
        '$lane generated coverage is ${percent.toStringAsFixed(2)}%; '
        'minimum is ${minimum.toStringAsFixed(2)}%.',
      );
    }
  }
  final double aggregate = aggregateFound == 0
      ? 0
      : 100 * aggregateHit / aggregateFound;
  stdout.writeln(
    'aggregate $aggregateHit/$aggregateFound '
    '${aggregate.toStringAsFixed(2)}%',
  );
  if (aggregate + 1e-9 < minimum) {
    errors.add(
      'Aggregate generated coverage is ${aggregate.toStringAsFixed(2)}%; '
      'minimum is ${minimum.toStringAsFixed(2)}%.',
    );
  }
  if (errors.isNotEmpty) {
    stderr.writeln('Generated coverage gate failed:');
    for (final String error in errors) {
      stderr.writeln('  $error');
    }
    exitCode = 1;
  }
}

_Coverage _parseLcov(File file) {
  final linesByLane = <String, Map<String, int>>{
    for (final String lane in _laneNames) lane: <String, int>{},
  };
  String? source;
  String? lane;
  for (final String line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      source = _packageRelative(line.substring(3));
      lane = _laneFor(source);
      continue;
    }
    if (lane == null || source == null || !line.startsWith('DA:')) {
      continue;
    }
    final List<String> fields = line.substring(3).split(',');
    if (fields.length < 2) {
      throw FormatException('Malformed LCOV DA record: $line');
    }
    final int? lineNumber = int.tryParse(fields[0]);
    final int? count = int.tryParse(fields[1]);
    if (lineNumber == null || count == null) {
      throw FormatException('Malformed LCOV DA record: $line');
    }
    final String key = '$source:$lineNumber';
    linesByLane[lane]!.update(
      key,
      (int previous) => previous + count,
      ifAbsent: () => count,
    );
  }
  return _Coverage(linesByLane);
}

List<String> _checkIgnorePolicy(Directory packageRoot) {
  final File reportFile = File(
    '${packageRoot.path}/tool/schema/conformance_report.json',
  );
  final Map<String, Object?> report = _map(
    jsonDecode(reportFile.readAsStringSync()),
  );
  final Map<String, Object?> policy = _map(report['coveragePolicy']);
  var lineIgnoreCount = 0;
  var wholeFileIgnoreCount = 0;
  final errors = <String>[];
  for (final int version in const <int>[1, 2]) {
    final Directory root = Directory(
      '${packageRoot.path}/lib/src/protocol/v$version/generated',
    );
    for (final File file
        in root
            .listSync(recursive: true)
            .whereType<File>()
            .where((File value) => value.path.endsWith('.dart'))) {
      final List<String> lines = file.readAsLinesSync();
      for (int index = 0; index < lines.length; index += 1) {
        final String line = lines[index];
        if (line.contains('coverage:ignore-file')) {
          wholeFileIgnoreCount += 1;
        }
        if (line.contains('coverage:ignore-start') ||
            line.contains('coverage:ignore-end')) {
          errors.add(
            '${_packageRelative(file.path)}:${index + 1} uses a range ignore.',
          );
        }
        if (line.contains('coverage:ignore-line')) {
          lineIgnoreCount += 1;
          if (!line.contains('coverage:ignore-line -- ')) {
            errors.add(
              '${_packageRelative(file.path)}:${index + 1} '
              'has no generator justification.',
            );
          }
        }
      }
    }
  }
  final int reportedLines = policy['lineIgnoreCount']! as int;
  final int reportedFiles = policy['wholeFileIgnoreCount']! as int;
  final int detailedLines = (policy['lineIgnores']! as List<Object?>).length;
  if (lineIgnoreCount != reportedLines || lineIgnoreCount != detailedLines) {
    errors.add(
      'Line ignores: source=$lineIgnoreCount, report=$reportedLines, '
      'details=$detailedLines.',
    );
  }
  if (wholeFileIgnoreCount != reportedFiles || wholeFileIgnoreCount != 0) {
    errors.add(
      'Whole-file ignores: source=$wholeFileIgnoreCount, '
      'report=$reportedFiles; expected zero.',
    );
  }
  return errors;
}

String _packageRelative(String path) {
  final String normalized = path.replaceAll(r'\', '/');
  final int index = normalized.indexOf('lib/src/protocol/');
  return index < 0 ? normalized : normalized.substring(index);
}

String? _laneFor(String source) {
  final RegExpMatch? match = RegExp(
    r'^lib/src/protocol/v([12])/generated/(stable|unstable)/.+\.dart$',
  ).firstMatch(source);
  if (match == null) {
    return null;
  }
  final String stability = match.group(2)!;
  return 'v${match.group(1)}'
      '${stability[0].toUpperCase()}${stability.substring(1)}';
}

Map<String, Object?> _map(Object? value) =>
    (value! as Map<Object?, Object?>).cast<String, Object?>();

Never _usage(String message) {
  stderr
    ..writeln(message)
    ..writeln(
      'Usage: dart run tool/schema/check_generated_coverage.dart '
      '[--lcov=coverage/lcov.info] [--minimum=95]',
    );
  exit(64);
}

final class _Coverage {
  const _Coverage(this.linesByLane);

  final Map<String, Map<String, int>> linesByLane;
}
