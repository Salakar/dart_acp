import 'duplex_stream.dart';
import 'ndjson_stream.dart';

/// Whether process standard streams are available on this platform.
const bool isSupported = false;

/// Reports that process stdio is unavailable on this platform.
AcpDuplexStream<Object?> connect(NdJsonStreamOptions options) {
  throw UnsupportedError('ACP stdio transport is unavailable on this platform');
}
