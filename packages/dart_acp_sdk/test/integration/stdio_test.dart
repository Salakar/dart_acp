@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:dart_acp_sdk/src/application/application.dart';
import 'package:dart_acp_sdk/src/common/value_types.dart';
import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';
import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:dart_acp_sdk/src/transport/ndjson_stream.dart';
import 'package:dart_acp_sdk/src/transport/stdio.dart';
import 'package:test/test.dart';

void main() {
  test('VM stdio transport is available', () {
    expect(AcpStdioTransport.isSupported, isTrue);
  });

  test('client initializes and creates a session in a child agent', () async {
    final Process child = await Process.start(
      Platform.resolvedExecutable,
      <String>['run', 'test/integration/stdio_agent_fixture.dart'],
      workingDirectory: Directory.current.path,
    );
    final Future<String> stderr = utf8.decodeStream(child.stderr);
    final AcpDuplexStream<Object?> transport = ndJsonStream(
      input: child.stdout,
      output: AcpWritable<List<int>>.fromStreamSink(child.stdin),
      options: const NdJsonStreamOptions(closeOutput: true),
    );
    final AcpClientApp client = AcpClientApp.v1(
      implementation: Implementation(name: 'stdio-client', version: '1.0.0'),
      capabilities: ClientCapabilities.decode(<String, Object?>{}).value,
    );
    final AcpClientConnection connection = client.connect(transport);

    await connection.lifecycle.ready.timeout(const Duration(seconds: 10));
    final AcpActiveSession session = await connection.agent
        .newSession(cwd: AcpAbsolutePath('/workspace'))
        .start()
        .timeout(const Duration(seconds: 10));
    expect(session.sessionId, SessionId('stdio-session'));

    session.dispose();
    connection.close();
    await transport.writable.close();
    expect(await child.exitCode.timeout(const Duration(seconds: 10)), 0);
    expect(await stderr, isEmpty);
  });
}
