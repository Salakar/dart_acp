import 'dart:async';

import 'control/control_channel.dart';
import 'input.dart';
import 'messages/message.dart';
import 'messages/message_codec.dart';
import 'options.dart';
import 'sessions/session_resume.dart';
import 'transport/subprocess_cli_transport.dart';
import 'transport/transport.dart';

/// Runs a one-shot prompt through Claude Code.
///
/// The returned stream owns the transport and closes it when iteration ends.
Stream<AgentMessage> query(
  String prompt, {
  ClaudeAgentOptions? options,
  Transport? transport,
}) => _runQuery(
  Stream<UserInput>.value(UserInput.text(prompt, sessionId: '')),
  options ?? ClaudeAgentOptions(),
  transport,
);

/// Runs a finite stream of typed user inputs through Claude Code.
///
/// Inputs are sent in order. The CLI input side closes after the terminal
/// result while control callbacks remain available for deferring tasks.
Stream<AgentMessage> queryStream(
  Stream<UserInput> input, {
  ClaudeAgentOptions? options,
  Transport? transport,
}) => _runQuery(input, options ?? ClaudeAgentOptions(), transport);

Stream<AgentMessage> _runQuery(
  Stream<UserInput> input,
  ClaudeAgentOptions options,
  Transport? customTransport,
) async* {
  validateSessionStoreOptions(options);
  final materialized = customTransport == null
      ? await materializeResumeSession(options)
      : null;
  final effectiveOptions = materialized == null
      ? options
      : options.withMaterializedResume(
          configDirectory: materialized.configDirectory,
          resumeSessionId: materialized.sessionId,
        );
  final chosenTransport =
      customTransport ?? SubprocessCliTransport(effectiveOptions);
  final channel = ControlChannel(
    transport: chosenTransport,
    options: effectiveOptions,
  );
  final codec = const MessageCodec();
  try {
    await chosenTransport.connect();
    await channel.start();
    await channel.initialize();
    unawaited(
      channel
          .streamInput(input.map((message) => message.toJson()))
          .catchError((Object _) {}),
    );
    await for (final data in channel.messages) {
      final message = codec.decode(data);
      if (message != null) yield message;
    }
  } finally {
    await channel.close();
    await materialized?.cleanup();
  }
}
