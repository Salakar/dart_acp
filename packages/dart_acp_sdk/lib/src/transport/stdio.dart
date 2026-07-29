import 'duplex_stream.dart';
import 'ndjson_stream.dart';
import 'stdio_stub.dart' if (dart.library.io) 'stdio_io.dart' as platform;

/// Platform-neutral entry point for ACP's NDJSON stdio transport.
abstract final class AcpStdioTransport {
  /// Whether the current platform provides process standard streams.
  static bool get isSupported => platform.isSupported;

  /// Connects the current process's stdin and stdout as an ACP transport.
  ///
  /// On web this throws [UnsupportedError]. Merely importing this library is
  /// always safe.
  static AcpDuplexStream<Object?> connect({
    NdJsonStreamOptions options = const NdJsonStreamOptions(),
  }) => platform.connect(options);
}

/// Connects the current process's stdin and stdout as an ACP transport.
AcpDuplexStream<Object?> acpStdioTransport({
  NdJsonStreamOptions options = const NdJsonStreamOptions(),
}) => AcpStdioTransport.connect(options: options);
