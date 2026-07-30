import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('goal capabilities preserve provider action subsets', () {
    final capabilities = AcpGoalControlCapabilities(<AcpGoalControlAction>[
      AcpGoalControlAction.update,
      AcpGoalControlAction.clear,
    ]);

    expect(capabilities.supported, isTrue);
    expect(capabilities.supports(AcpGoalControlAction.update), isTrue);
    expect(capabilities.supports(AcpGoalControlAction.pause), isFalse);
    expect(
      AcpGoalControlCapabilities.fromJson(capabilities.toJson()).actions,
      capabilities.actions,
    );
  });

  test('goal snapshot round-trips provider-neutral metadata', () {
    const goal = AcpGoalSnapshot(
      objective: 'Ship goal support',
      status: AcpGoalStatus.paused,
    );

    final decoded = AcpGoalSnapshot.fromJson(goal.toJson());

    expect(decoded.objective, goal.objective);
    expect(decoded.status, goal.status);
  });

  test('goal control validates objectives by action', () {
    final codec = acpSessionGoalControlMethod.paramsCodec;
    final request = AcpGoalControlRequest(
      sessionId: SessionId('session-1'),
      action: AcpGoalControlAction.update,
      objective: '  Ship it  ',
    );

    expect(codec.encode(request), <String, Object?>{
      'sessionId': 'session-1',
      'action': 'update',
      'objective': 'Ship it',
    });
    expect(
      () => codec.encode(
        AcpGoalControlRequest(
          sessionId: SessionId('session-1'),
          action: AcpGoalControlAction.pause,
          objective: 'not allowed',
        ),
      ),
      throwsFormatException,
    );
    expect(
      () => codec.decode(<String, Object?>{
        'sessionId': 'session-1',
        'action': 'update',
      }),
      throwsFormatException,
    );
  });
}
