import 'dart:io';

const Set<String> _processExceptions = <String>{
  'lib/src/app_server/process_transport.dart',
  'lib/src/runtime/cli.dart',
  'lib/src/runtime/runtime.dart',
};

void main(List<String> arguments) {
  final path = arguments.firstOrNull ?? 'coverage/lcov.info';
  final threshold = arguments.length > 1 ? double.tryParse(arguments[1]) : 95.0;
  if (threshold == null || threshold <= 0 || threshold > 100) {
    stderr.writeln('Coverage threshold must be in the range (0, 100].');
    exitCode = 64;
    return;
  }

  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Coverage report not found: $path');
    exitCode = 66;
    return;
  }

  var source = '';
  var measuredFound = 0;
  var measuredHit = 0;
  var processFound = 0;
  var processHit = 0;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      source = line.substring(3).replaceAll(r'\', '/');
      continue;
    }
    if (line.startsWith('LF:')) {
      final value = int.parse(line.substring(3));
      if (_processExceptions.any(source.endsWith)) {
        processFound += value;
      } else {
        measuredFound += value;
      }
      continue;
    }
    if (line.startsWith('LH:')) {
      final value = int.parse(line.substring(3));
      if (_processExceptions.any(source.endsWith)) {
        processHit += value;
      } else {
        measuredHit += value;
      }
    }
  }

  if (measuredFound == 0) {
    stderr.writeln('Coverage report contains no measured Dart lines.');
    exitCode = 65;
    return;
  }
  final measuredPercent = measuredHit * 100 / measuredFound;
  final processPercent = processFound == 0
      ? 100.0
      : processHit * 100 / processFound;
  stdout
    ..writeln(
      'Measured library coverage: '
      '${measuredPercent.toStringAsFixed(2)}% '
      '($measuredHit/$measuredFound)',
    )
    ..writeln(
      'Process/signal exception coverage: '
      '${processPercent.toStringAsFixed(2)}% '
      '($processHit/$processFound)',
    );
  if (measuredPercent < threshold) {
    stderr.writeln(
      'Measured coverage is below ${threshold.toStringAsFixed(2)}%.',
    );
    exitCode = 1;
  }
}
