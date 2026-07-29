import '../json_rpc/codec.dart';
import '../json_rpc/message.dart';
import '../transport/duplex_stream.dart';

/// Adapts a typed remote wire stream for an ACP agent or client application.
///
/// Remote transports expose validated [JsonRpcWireMessage] values, while the
/// application runtime owns envelope decoding and therefore consumes JSON-like
/// objects. This adapter preserves that ownership boundary in both directions.
///
/// The returned readable stream and [stream] share one underlying
/// single-subscription source. Connect exactly one application to either view.
AcpDuplexStream<Object?> acpApplicationStream(
  AcpDuplexStream<JsonRpcWireMessage> stream, {
  JsonRpcCodec codec = const JsonRpcCodec(),
}) {
  return AcpDuplexStream<Object?>(
    readable: stream.readable.map<Object?>(
      (JsonRpcWireMessage message) => message.toJson(),
    ),
    writable: AcpWritable<Object?>(
      write: (Object? value) =>
          stream.writable.write(codec.decodeWireMessage(value)),
      close: stream.writable.close,
    ),
  );
}
