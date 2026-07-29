// coverage-exempt: directives-only
/// Explicit opt-in surface for the experimental draft ACP v2 baseline.
///
/// This library is versioned independently from the stable-v1 API contract and
/// may change incompatibly while ACP v2 remains a draft.
library;

export '../src/application/v2/application.dart';
export '../src/common/json_value.dart';
export '../src/common/patch.dart';
export '../src/common/value_types.dart';
export '../src/json_rpc/cancellation.dart';
export '../src/json_rpc/connection.dart'
    show
        JsonRpcConnectionOptions,
        JsonRpcDiagnostic,
        JsonRpcDiagnosticError,
        JsonRpcDiagnosticLevel;
export '../src/json_rpc/error.dart';
export '../src/json_rpc/id.dart';
export '../src/json_rpc/params.dart';
export '../src/protocol/method.dart';
export '../src/protocol/v2/generated/stable/protocol.dart';
export '../src/transport/duplex_stream.dart';
export '../src/transport/in_process.dart';
export '../src/transport/ndjson_stream.dart';
export '../src/transport/stdio.dart';
