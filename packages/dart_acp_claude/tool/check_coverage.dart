import 'dart:io';

const Set<String> _orchestrationExceptions = <String>{
  'lib/src/agent/claude_acp_agent.dart',
  'lib/src/application/runtime.dart',
  'lib/src/runtime/cli.dart',
  'lib/src/runtime/contracts.dart',
};

void main(List<String> arguments) {
  final path = arguments.firstOrNull ?? 'coverage/lcov.info';
  final measuredThreshold = arguments.length > 1
      ? double.tryParse(arguments[1])
      : 95.0;
  final orchestrationThreshold = arguments.length > 2
      ? double.tryParse(arguments[2])
      : 75.0;
  if (!_valid(measuredThreshold) || !_valid(orchestrationThreshold)) {
    stderr.writeln('Coverage thresholds must be in the range (0, 100].');
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
  var orchestrationFound = 0;
  var orchestrationHit = 0;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      source = line.substring(3).replaceAll(r'\', '/');
    } else if (line.startsWith('LF:')) {
      final value = int.parse(line.substring(3));
      if (_isOrchestration(source)) {
        orchestrationFound += value;
      } else {
        measuredFound += value;
      }
    } else if (line.startsWith('LH:')) {
      final value = int.parse(line.substring(3));
      if (_isOrchestration(source)) {
        orchestrationHit += value;
      } else {
        measuredHit += value;
      }
    }
  }
  if (measuredFound == 0 || orchestrationFound == 0) {
    stderr.writeln('Coverage report is missing expected library records.');
    exitCode = 65;
    return;
  }
  final measured = measuredHit * 100 / measuredFound;
  final orchestration = orchestrationHit * 100 / orchestrationFound;
  stdout
    ..writeln(
      'Measured library coverage: ${measured.toStringAsFixed(2)}% '
      '($measuredHit/$measuredFound)',
    )
    ..writeln(
      'Process/orchestration coverage: ${orchestration.toStringAsFixed(2)}% '
      '($orchestrationHit/$orchestrationFound)',
    );
  if (measured < measuredThreshold! ||
      orchestration < orchestrationThreshold!) {
    stderr.writeln('Coverage is below a required threshold.');
    exitCode = 1;
  }
}

bool _valid(double? value) => value != null && value > 0 && value <= 100;

bool _isOrchestration(String source) =>
    _orchestrationExceptions.any(source.endsWith);
