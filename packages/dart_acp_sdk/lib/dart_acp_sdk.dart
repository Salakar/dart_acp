// coverage-exempt: directives-only
/// Stable ACP v1 application, protocol, JSON, and transport APIs.
///
/// Draft v2, unstable schema overlays, and remote HTTP/WebSocket transports
/// are available only through explicit `experimental/` entrypoints.
library;

export 'src/application/application.dart';
export 'src/common/json_value.dart';
export 'src/common/patch.dart';
export 'src/common/value_types.dart';
export 'src/json_rpc/batch.dart';
export 'src/json_rpc/cancellation.dart';
export 'src/json_rpc/codec.dart';
export 'src/json_rpc/connection.dart';
export 'src/json_rpc/error.dart';
export 'src/json_rpc/handler.dart';
export 'src/json_rpc/id.dart';
export 'src/json_rpc/message.dart';
export 'src/json_rpc/params.dart';
export 'src/protocol/method.dart';
export 'src/protocol/v1/generated/stable/protocol.dart';
export 'src/transport/duplex_stream.dart';
export 'src/transport/in_process.dart';
export 'src/transport/ndjson_stream.dart';
export 'src/transport/stdio.dart';
