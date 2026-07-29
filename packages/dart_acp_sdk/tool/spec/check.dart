import 'dart:io';

import 'src/verifier.dart';

void main() {
  final SpecVerificationResult result = SpecEvidenceVerifier(
    Directory.current,
  ).verify();
  stdout.writeln(result.summary);
}
