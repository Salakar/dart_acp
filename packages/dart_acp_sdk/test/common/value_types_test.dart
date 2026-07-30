import 'package:dart_acp_sdk/src/common/value_types.dart';
import 'package:dart_acp_sdk/src/protocol/resilient_decoder.dart';
import 'package:test/test.dart';

void main() {
  group('64-bit integer wire encoding', () {
    test('preserves the IEEE-754 safe-integer boundaries', () {
      final minimum = AcpInt64(BigInt.from(-9007199254740991));
      final maximum = AcpInt64(BigInt.from(9007199254740991));
      final unsignedMaximum = AcpUint64(BigInt.from(9007199254740991));

      expect(encodeAcpInt64(minimum), -9007199254740991);
      expect(encodeAcpInt64(maximum), 9007199254740991);
      expect(encodeAcpUint64(unsignedMaximum), 9007199254740991);
    });

    test('rejects outbound values that a browser would round', () {
      final belowSafeRange = AcpInt64(BigInt.from(-9007199254740992));
      final aboveSafeRange = AcpInt64(BigInt.from(9007199254740992));
      final unsignedAboveSafeRange = AcpUint64(BigInt.from(9007199254740992));

      expect(() => encodeAcpInt64(belowSafeRange), throwsRangeError);
      expect(() => encodeAcpInt64(aboveSafeRange), throwsRangeError);
      expect(() => encodeAcpUint64(unsignedAboveSafeRange), throwsRangeError);
    });

    test('keeps the full schema ranges exact in model values', () {
      expect(AcpInt64(AcpInt64.minValue).value, AcpInt64.minValue);
      expect(AcpInt64(AcpInt64.maxValue).value, AcpInt64.maxValue);
      expect(AcpUint64(AcpUint64.maxValue).value, AcpUint64.maxValue);
    });
  });
}
