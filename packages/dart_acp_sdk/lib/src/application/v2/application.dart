// coverage-exempt: directives-only
/// Isolated application runtime for the experimental draft ACP v2 protocol.
library;

import 'dart:async';
import 'dart:convert';

import '../../common/json_value.dart';
import '../../common/patch.dart';
import '../../json_rpc/batch.dart';
import '../../json_rpc/cancellation.dart';
import '../../json_rpc/codec.dart';
import '../../json_rpc/connection.dart';
import '../../json_rpc/error.dart';
import '../../json_rpc/handler.dart';
import '../../json_rpc/id.dart';
import '../../json_rpc/params.dart';
import '../../protocol/method.dart';
import '../../protocol/v2/generated/stable/method_descriptors.dart'
    as v2_methods;
import '../../protocol/v2/generated/stable/models.dart' as v2;
import '../../transport/duplex_stream.dart';
import '../../transport/in_process.dart';

part 'agent_app.dart';
part 'batch.dart';
part 'client_app.dart';
part 'connection.dart';
part 'context.dart';
part 'handlers.dart';
part 'methods.dart';
part 'session.dart';
part 'session_runtime.dart';
