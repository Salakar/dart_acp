import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../tool/src/reference_test_matrix.dart';

void main() {
  final repositoryRoot = Directory.current.absolute;
  final matrix = File(
    '${repositoryRoot.path}${Platform.pathSeparator}tool'
    '${Platform.pathSeparator}reference_test_matrix.json',
  );

  test('checked reference matrix is complete without its source clone', () {
    final result = verifyReferenceTestMatrix(repositoryRoot: repositoryRoot);

    expect(result.errors, isEmpty, reason: result.errors.join('\n'));
    expect(
      result.dispositionCounts.values.fold<int>(0, (sum, value) => sum + value),
      referenceTestCaseCount,
    );
    expect(result.dispositionCounts, referenceTestDispositionCounts);
    expect(result.targetCount, referenceTestTargetCount);
  });

  test('inventory and Dart target drift are both rejected', () {
    final temporary = Directory.systemTemp.createTempSync(
      'dart_acp_reference_matrix_',
    );
    addTearDown(() => temporary.deleteSync(recursive: true));
    final decoded =
        jsonDecode(matrix.readAsStringSync())! as Map<String, Object?>;
    final cases = decoded['cases']! as List<Object?>;
    final first = cases.first! as Map<String, Object?>;
    final source = first['source']! as Map<String, Object?>;
    source['test'] = '${source['test']} changed';
    final disposition = first['disposition']! as Map<String, Object?>;
    disposition['kind'] = 'dart_test';
    final targets = disposition['targets']! as List<Object?>;
    final target = targets.first! as Map<String, Object?>;
    target['testId'] = 'missing Dart test ID';
    final changed = File(
      '${temporary.path}${Platform.pathSeparator}matrix.json',
    )..writeAsStringSync(jsonEncode(decoded));

    final result = verifyReferenceTestMatrix(
      repositoryRoot: repositoryRoot,
      matrixFile: changed,
    );

    expect(result.isValid, isFalse);
    expect(result.errors, anyElement(contains('inventory digest')));
    expect(result.errors, anyElement(contains('must occur exactly once')));
    expect(result.errors, anyElement(contains('Disposition')));
  });
}
