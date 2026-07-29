import 'package:test/test.dart';

import 'conformance/conformance_support.dart';
import 'conformance/generated/v1_stable_matrix.dart';
import 'conformance/generated/v1_unstable_matrix.dart';
import 'conformance/generated/v2_stable_matrix.dart';
import 'conformance/generated/v2_unstable_matrix.dart';

void main() {
  test('v1 stable generated conformance matrix', () {
    runConformanceCases(v1StableConformanceCases);
  });

  test('v1 unstable generated conformance matrix', () {
    runConformanceCases(v1UnstableConformanceCases);
  });

  test('v2 stable generated conformance matrix', () {
    runConformanceCases(v2StableConformanceCases);
  });

  test('v2 unstable generated conformance matrix', () {
    runConformanceCases(v2UnstableConformanceCases);
  });
}
