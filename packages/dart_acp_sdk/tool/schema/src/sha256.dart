import 'dart:typed_data';

const List<int> _roundConstants = <int>[
  0x428a2f98,
  0x71374491,
  0xb5c0fbcf,
  0xe9b5dba5,
  0x3956c25b,
  0x59f111f1,
  0x923f82a4,
  0xab1c5ed5,
  0xd807aa98,
  0x12835b01,
  0x243185be,
  0x550c7dc3,
  0x72be5d74,
  0x80deb1fe,
  0x9bdc06a7,
  0xc19bf174,
  0xe49b69c1,
  0xefbe4786,
  0x0fc19dc6,
  0x240ca1cc,
  0x2de92c6f,
  0x4a7484aa,
  0x5cb0a9dc,
  0x76f988da,
  0x983e5152,
  0xa831c66d,
  0xb00327c8,
  0xbf597fc7,
  0xc6e00bf3,
  0xd5a79147,
  0x06ca6351,
  0x14292967,
  0x27b70a85,
  0x2e1b2138,
  0x4d2c6dfc,
  0x53380d13,
  0x650a7354,
  0x766a0abb,
  0x81c2c92e,
  0x92722c85,
  0xa2bfe8a1,
  0xa81a664b,
  0xc24b8b70,
  0xc76c51a3,
  0xd192e819,
  0xd6990624,
  0xf40e3585,
  0x106aa070,
  0x19a4c116,
  0x1e376c08,
  0x2748774c,
  0x34b0bcb5,
  0x391c0cb3,
  0x4ed8aa4a,
  0x5b9cca4f,
  0x682e6ff3,
  0x748f82ee,
  0x78a5636f,
  0x84c87814,
  0x8cc70208,
  0x90befffa,
  0xa4506ceb,
  0xbef9a3f7,
  0xc67178f2,
];

/// Computes the lowercase SHA-256 digest for [input].
String sha256Hex(List<int> input) {
  final int messageLength = input.length;
  final int paddedLength = ((messageLength + 9 + 63) ~/ 64) * 64;
  final bytes = Uint8List(paddedLength);
  for (int index = 0; index < messageLength; index += 1) {
    final int byte = input[index];
    if (byte < 0 || byte > 255) {
      throw RangeError.range(byte, 0, 255, 'input[$index]');
    }
    bytes[index] = byte;
  }
  bytes[messageLength] = 0x80;

  final int bitLength = messageLength * 8;
  final data = ByteData.sublistView(bytes);
  data.setUint32(paddedLength - 8, bitLength ~/ 0x100000000);
  data.setUint32(paddedLength - 4, bitLength & 0xffffffff);

  int h0 = 0x6a09e667;
  int h1 = 0xbb67ae85;
  int h2 = 0x3c6ef372;
  int h3 = 0xa54ff53a;
  int h4 = 0x510e527f;
  int h5 = 0x9b05688c;
  int h6 = 0x1f83d9ab;
  int h7 = 0x5be0cd19;
  final schedule = Uint32List(64);

  for (int offset = 0; offset < paddedLength; offset += 64) {
    for (int index = 0; index < 16; index += 1) {
      schedule[index] = data.getUint32(offset + index * 4);
    }
    for (int index = 16; index < 64; index += 1) {
      final int s0 =
          _rotateRight(schedule[index - 15], 7) ^
          _rotateRight(schedule[index - 15], 18) ^
          (schedule[index - 15] >> 3);
      final int s1 =
          _rotateRight(schedule[index - 2], 17) ^
          _rotateRight(schedule[index - 2], 19) ^
          (schedule[index - 2] >> 10);
      schedule[index] =
          (schedule[index - 16] + s0 + schedule[index - 7] + s1) & 0xffffffff;
    }

    int a = h0;
    int b = h1;
    int c = h2;
    int d = h3;
    int e = h4;
    int f = h5;
    int g = h6;
    int h = h7;

    for (int index = 0; index < 64; index += 1) {
      final int sum1 =
          _rotateRight(e, 6) ^ _rotateRight(e, 11) ^ _rotateRight(e, 25);
      final int choose = (e & f) ^ ((~e) & g);
      final int temp1 =
          (h + sum1 + choose + _roundConstants[index] + schedule[index]) &
          0xffffffff;
      final int sum0 =
          _rotateRight(a, 2) ^ _rotateRight(a, 13) ^ _rotateRight(a, 22);
      final int majority = (a & b) ^ (a & c) ^ (b & c);
      final int temp2 = (sum0 + majority) & 0xffffffff;

      h = g;
      g = f;
      f = e;
      e = (d + temp1) & 0xffffffff;
      d = c;
      c = b;
      b = a;
      a = (temp1 + temp2) & 0xffffffff;
    }

    h0 = (h0 + a) & 0xffffffff;
    h1 = (h1 + b) & 0xffffffff;
    h2 = (h2 + c) & 0xffffffff;
    h3 = (h3 + d) & 0xffffffff;
    h4 = (h4 + e) & 0xffffffff;
    h5 = (h5 + f) & 0xffffffff;
    h6 = (h6 + g) & 0xffffffff;
    h7 = (h7 + h) & 0xffffffff;
  }

  return <int>[
    h0,
    h1,
    h2,
    h3,
    h4,
    h5,
    h6,
    h7,
  ].map((int word) => word.toRadixString(16).padLeft(8, '0')).join();
}

int _rotateRight(int value, int count) =>
    ((value >> count) | (value << (32 - count))) & 0xffffffff;
