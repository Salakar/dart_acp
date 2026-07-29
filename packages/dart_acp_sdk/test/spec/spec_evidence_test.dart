@TestOn('vm')
library;

import 'dart:io';

import 'package:test/test.dart';

import '../../tool/spec/src/verifier.dart';

void main() {
  test('offline evidence traces the live docs and every schema lane', () {
    final SpecVerificationResult result = SpecEvidenceVerifier(
      Directory.current,
    ).verify();

    expect(result.indexPages, 122);
    expect(result.protocolPages, 38);
    expect(result.schemaLanes, 4);
    expect(result.schemaDefinitions, 861);
    expect(result.schemaDeclarations, 2922);
    expect(result.schemaCodecCases, 4438);
    expect(result.schemaMethods, 122);
    expect(result.indexDispositions['traced'], 38);
    expect(result.indexDispositions.values.reduce((a, b) => a + b), 122);
    expect(
      result.requirementRationales.values.reduce((a, b) => a + b),
      result.requirements,
    );
  });
}
