import 'dart:io';

import 'package:path/path.dart' as p;

const _defaultMinimum = 80.0;

void main(List<String> arguments) {
  final minimum = _minimumFrom(arguments);
  final explicitPath = arguments
      .where((argument) => !argument.startsWith('--minimum='))
      .firstOrNull;
  final path = explicitPath ?? _defaultCoveragePath();
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln(
      'Coverage file not found: $path\n'
      'Run `dart test --coverage=coverage` and convert it to LCOV first.',
    );
    exitCode = 2;
    return;
  }

  var found = 0;
  var hit = 0;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('LF:')) {
      found += int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      hit += int.parse(line.substring(3));
    }
  }
  if (found == 0) {
    stderr.writeln('No line-coverage records found in $path.');
    exitCode = 2;
    return;
  }

  final percentage = hit * 100 / found;
  stdout.writeln(
    'Line coverage: ${percentage.toStringAsFixed(2)}% '
    '($hit/$found; required ${minimum.toStringAsFixed(2)}%)',
  );
  if (percentage < minimum) {
    stderr.writeln('Coverage is below the required minimum.');
    exitCode = 1;
  }
}

double _minimumFrom(List<String> arguments) {
  final option = arguments
      .where((argument) => argument.startsWith('--minimum='))
      .firstOrNull;
  if (option == null) return _defaultMinimum;
  final value = double.tryParse(option.substring('--minimum='.length));
  if (value == null || value < 0 || value > 100) {
    throw ArgumentError.value(option, 'minimum', 'must be between 0 and 100');
  }
  return value;
}

String _defaultCoveragePath() {
  final local = p.join('coverage', 'vm.info');
  if (File(local).existsSync()) return local;
  return p.join('packages', 'claude_agent_sdk', local);
}
