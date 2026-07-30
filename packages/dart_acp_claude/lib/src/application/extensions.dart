import 'package:dart_acp_sdk/dart_acp_sdk.dart';

/// Typed parameters for `_session/steering`.
final class ClaudeSteeringRequest {
  /// Creates a steering request.
  ClaudeSteeringRequest({
    required this.sessionId,
    required Iterable<ContentBlock> prompt,
  }) : prompt = List<ContentBlock>.unmodifiable(prompt);

  /// Session to steer.
  final SessionId sessionId;

  /// Additional prompt content.
  final List<ContentBlock> prompt;
}

/// Steering request outcome.
enum ClaudeSteeringOutcome {
  /// Input joined the active turn.
  injected('injected'),

  /// Input started a new turn.
  startedNewTurn('startedNewTurn'),

  /// Input could not be delivered.
  failed('failed');

  const ClaudeSteeringOutcome(this.wireName);

  /// Wire value.
  final String wireName;
}

/// Typed response for `_session/steering`.
final class ClaudeSteeringResponse {
  /// Creates a response with [outcome].
  const ClaudeSteeringResponse(this.outcome);

  /// Steering outcome.
  final ClaudeSteeringOutcome outcome;
}

/// Typed steering extension descriptor.
final AcpMethodDescriptor<ClaudeSteeringRequest, ClaudeSteeringResponse>
claudeSteeringMethod =
    acpCustomRequestMethod<ClaudeSteeringRequest, ClaudeSteeringResponse>(
      name: '_session/steering',
      direction: AcpMethodDirection.clientToAgent,
      paramsCodec: const _ClaudeSteeringRequestCodec(),
      resultCodec: const _ClaudeSteeringResponseCodec(),
    );

/// Raw-preserving runtime frame forwarded for diagnostic integrations.
final class ClaudeSdkMessageNotification {
  /// Creates a forwarded message notification.
  ClaudeSdkMessageNotification({
    required this.sessionId,
    required this.message,
  });

  /// Session that produced the frame.
  final SessionId sessionId;

  /// Immutable original runtime frame.
  final AcpJsonObject message;
}

/// Typed `_claude/sdkMessage` notification descriptor.
final AcpMethodDescriptor<ClaudeSdkMessageNotification, AcpNoResult>
claudeSdkMessageMethod =
    acpCustomNotificationMethod<ClaudeSdkMessageNotification>(
      name: '_claude/sdkMessage',
      direction: AcpMethodDirection.agentToClient,
      paramsCodec: const _ClaudeSdkMessageNotificationCodec(),
    );

final class _ClaudeSteeringRequestCodec
    implements AcpCodec<ClaudeSteeringRequest> {
  const _ClaudeSteeringRequestCodec();

  @override
  ClaudeSteeringRequest decode(Object? value) {
    final json = _object(value);
    final sessionId = json['sessionId'];
    final prompt = json['prompt'];
    if (sessionId is! String ||
        sessionId.isEmpty ||
        prompt is! List<Object?> ||
        prompt.isEmpty) {
      throw const FormatException('Invalid steering request');
    }
    return ClaudeSteeringRequest(
      sessionId: SessionId(sessionId),
      prompt: <ContentBlock>[
        for (final block in prompt) ContentBlock.fromJson(block),
      ],
    );
  }

  @override
  Object encode(ClaudeSteeringRequest value) => <String, Object?>{
    'sessionId': value.sessionId.value,
    'prompt': <Object?>[for (final block in value.prompt) block.toJson()],
  };
}

final class _ClaudeSteeringResponseCodec
    implements AcpCodec<ClaudeSteeringResponse> {
  const _ClaudeSteeringResponseCodec();

  @override
  ClaudeSteeringResponse decode(Object? value) {
    final outcome = _object(value)['outcome'];
    return ClaudeSteeringResponse(
      ClaudeSteeringOutcome.values.firstWhere(
        (candidate) => candidate.wireName == outcome,
        orElse: () => throw const FormatException('Invalid steering response'),
      ),
    );
  }

  @override
  Object encode(ClaudeSteeringResponse value) => <String, Object?>{
    'outcome': value.outcome.wireName,
  };
}

final class _ClaudeSdkMessageNotificationCodec
    implements AcpCodec<ClaudeSdkMessageNotification> {
  const _ClaudeSdkMessageNotificationCodec();

  @override
  ClaudeSdkMessageNotification decode(Object? value) {
    final json = _object(value);
    final sessionId = json['sessionId'];
    final message = json['message'];
    if (sessionId is! String ||
        sessionId.isEmpty ||
        message is! Map<Object?, Object?>) {
      throw const FormatException('Invalid SDK message notification');
    }
    return ClaudeSdkMessageNotification(
      sessionId: SessionId(sessionId),
      message: AcpJsonObject.fromObject(<String, Object?>{
        for (final entry in message.entries)
          if (entry.key is String) entry.key! as String: entry.value,
      }),
    );
  }

  @override
  Object encode(ClaudeSdkMessageNotification value) => <String, Object?>{
    'sessionId': value.sessionId.value,
    'message': value.message.toObject(),
  };
}

Map<Object?, Object?> _object(Object? value) {
  if (value is! Map<Object?, Object?>) {
    throw const FormatException('Expected a JSON object');
  }
  return value;
}
