import 'dart:io';

import 'duplex_stream.dart';
import 'ndjson_stream.dart';

/// Whether process standard streams are available on this platform.
const bool isSupported = true;

/// Connects the current process's stdin and stdout through NDJSON.
AcpDuplexStream<Object?> connect(NdJsonStreamOptions options) => ndJsonStream(
  input: stdin,
  output: AcpWritable<List<int>>(
    write: (List<int> bytes) async {
      stdout.add(bytes);
      await stdout.flush();
    },
    close: stdout.flush,
  ),
  options: options,
);
