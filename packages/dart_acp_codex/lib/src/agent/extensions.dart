import 'package:dart_acp_sdk/dart_acp_sdk.dart';

/// Typed parameters for `_session/steering`.
final class CodexSteeringRequest {
  /// Creates a steering request.
  CodexSteeringRequest({
    required this.sessionId,
    required Iterable<ContentBlock> prompt,
  }) : prompt = List<ContentBlock>.unmodifiable(prompt);

  /// Session to steer.
  final SessionId sessionId;

  /// Additional prompt content.
  final List<ContentBlock> prompt;
}

/// Outcome returned by `_session/steering`.
enum CodexSteeringResponse {
  /// Input joined the active turn.
  injected('injected'),

  /// Input began a new turn.
  startedNewTurn('startedNewTurn'),

  /// Input could not be applied.
  failed('failed');

  const CodexSteeringResponse(this.wireName);

  /// Wire outcome.
  final String wireName;
}

/// Typed Codex steering extension descriptor.
final AcpMethodDescriptor<CodexSteeringRequest, CodexSteeringResponse>
codexSteeringMethod =
    acpCustomRequestMethod<CodexSteeringRequest, CodexSteeringResponse>(
      name: '_session/steering',
      direction: AcpMethodDirection.clientToAgent,
      paramsCodec: const _CodexSteeringRequestCodec(),
      resultCodec: const _CodexSteeringResponseCodec(),
    );

final class _CodexSteeringRequestCodec
    implements AcpCodec<CodexSteeringRequest> {
  const _CodexSteeringRequestCodec();

  @override
  CodexSteeringRequest decode(Object? value) {
    final json = _object(value);
    final session = json['sessionId'];
    final prompt = json['prompt'];
    if (session is! String || session.isEmpty || prompt is! List<Object?>) {
      throw const FormatException('Invalid Codex steering request');
    }
    return CodexSteeringRequest(
      sessionId: SessionId(session),
      prompt: <ContentBlock>[
        for (final block in prompt) ContentBlock.fromJson(block),
      ],
    );
  }

  @override
  Object encode(CodexSteeringRequest value) => <String, Object?>{
    'sessionId': value.sessionId.value,
    'prompt': <Object?>[for (final block in value.prompt) block.toJson()],
  };
}

final class _CodexSteeringResponseCodec
    implements AcpCodec<CodexSteeringResponse> {
  const _CodexSteeringResponseCodec();

  @override
  CodexSteeringResponse decode(Object? value) {
    final json = _object(value);
    final outcome = json['outcome'];
    return CodexSteeringResponse.values.firstWhere(
      (candidate) => candidate.wireName == outcome,
      orElse: () =>
          throw const FormatException('Invalid Codex steering outcome'),
    );
  }

  @override
  Object encode(CodexSteeringResponse value) => <String, Object?>{
    'outcome': value.wireName,
  };
}

Map<Object?, Object?> _object(Object? value) {
  if (value is! Map<Object?, Object?>) {
    throw const FormatException('Expected a JSON object');
  }
  return value;
}
