import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../app_server/backend.dart';
import '../app_server/json_values.dart';
import '../session/state.dart';

/// Bridges Codex approval requests to typed ACP permission requests.
final class CodexApprovalBridge {
  /// Creates a bridge for one client and session.
  const CodexApprovalBridge({required this.client, required this.session});

  /// Client callback context.
  final AcpAgentContext client;

  /// Owning session.
  final CodexSessionState session;

  /// Requests a decision and maps it to the app-server response.
  Future<CodexJsonObject> handle(CodexServerRequest request) async {
    try {
      return switch (request) {
        CodexCommandApprovalRequest() => await _command(request),
        CodexFileChangeApprovalRequest() => await _fileChange(request),
        CodexPermissionsRequest() => await _permissions(request),
        _ => throw ArgumentError.value(request, 'request'),
      };
    } on Object {
      return _safeDefault(request);
    }
  }

  Future<CodexJsonObject> _command(CodexCommandApprovalRequest request) async {
    final params = request.params;
    final options = <_DecisionOption>[
      _DecisionOption('allow-once', 'Allow Once', 'allow_once', 'accept'),
      _DecisionOption(
        'allow-always',
        params.optionalObject('networkApprovalContext') == null
            ? 'Allow for Session'
            : 'Allow Host for Session',
        'allow_always',
        'acceptForSession',
      ),
    ];
    final amendment = _stringList(params['proposedExecpolicyAmendment']);
    if (amendment.isNotEmpty) {
      options.add(
        _DecisionOption(
          'accept-with-execpolicy-amendment',
          _amendmentLabel(amendment),
          'allow_always',
          <String, Object?>{
            'acceptWithExecpolicyAmendment': <String, Object?>{
              'execpolicy_amendment': amendment,
            },
          },
        ),
      );
    }
    final networkAmendments = params['proposedNetworkPolicyAmendments'];
    if (networkAmendments is List<Object?>) {
      for (var index = 0; index < networkAmendments.length; index += 1) {
        final raw = networkAmendments[index];
        if (raw is! Map<Object?, Object?>) {
          continue;
        }
        final amendment = CodexJsonObject.from(raw);
        final host = amendment.optionalString('host') ?? 'host';
        final action = amendment.optionalString('action') ?? 'allow';
        options.add(
          _DecisionOption(
            'apply-network-policy-amendment:$index',
            action == 'allow'
                ? 'Allow $host in the Future'
                : 'Block $host in the Future',
            action == 'allow' ? 'allow_always' : 'reject_always',
            <String, Object?>{
              'applyNetworkPolicyAmendment': <String, Object?>{
                'network_policy_amendment': amendment.toJson(),
              },
            },
          ),
        );
      }
    }
    options.add(
      _DecisionOption('reject-once', 'Reject', 'reject_once', 'decline'),
    );
    final selected = await _request(
      params: params,
      itemId: _itemId(params),
      kind: 'execute',
      title: params.optionalString('command') ?? 'Run command',
      rawInput: <String, Object?>{
        'command': params.optionalString('command'),
        'cwd': params.optionalString('cwd'),
      },
      options: options,
    );
    return CodexJsonObject.from(<String, Object?>{
      'decision': selected ?? 'decline',
    });
  }

  Future<CodexJsonObject> _fileChange(
    CodexFileChangeApprovalRequest request,
  ) async {
    final params = request.params;
    final grantRoot = params.optionalString('grantRoot');
    final options = <_DecisionOption>[
      _DecisionOption('allow-once', 'Allow Once', 'allow_once', 'accept'),
      _DecisionOption(
        'allow-always',
        grantRoot == null ? 'Allow for Session' : 'Allow Root for Session',
        'allow_always',
        'acceptForSession',
      ),
      _DecisionOption('reject-once', 'Reject', 'reject_once', 'decline'),
    ];
    final selected = await _request(
      params: params,
      itemId: _itemId(params),
      kind: 'edit',
      title: params.optionalString('reason') ?? 'Edit files',
      locations: grantRoot == null
          ? const <Map<String, Object?>>[]
          : <Map<String, Object?>>[
              <String, Object?>{'path': grantRoot},
            ],
      options: options,
    );
    return CodexJsonObject.from(<String, Object?>{
      'decision': selected ?? 'decline',
    });
  }

  Future<CodexJsonObject> _permissions(CodexPermissionsRequest request) async {
    final params = request.params;
    final permissions =
        params.optionalObject('permissions')?.toJson() ?? <String, Object?>{};
    final options = <_DecisionOption>[
      _DecisionOption(
        'allow-permissions-for-session',
        'Allow for Session',
        'allow_always',
        'session',
      ),
      _DecisionOption(
        'allow-permissions-for-turn',
        'Allow Once',
        'allow_once',
        'turn',
      ),
      _DecisionOption('reject-permissions', 'Reject', 'reject_once', null),
    ];
    final selected = await _request(
      params: params,
      itemId: _itemId(params),
      kind: 'other',
      title: params.optionalString('reason') ?? 'Permissions Request',
      rawInput: params.toJson(),
      options: options,
    );
    if (selected == 'session' || selected == 'turn') {
      return CodexJsonObject.from(<String, Object?>{
        'permissions': permissions,
        'scope': selected,
        'strictAutoReview': false,
      });
    }
    return _rejectPermissions;
  }

  Future<Object?> _request({
    required CodexJsonObject params,
    required String itemId,
    required String kind,
    required String title,
    required List<_DecisionOption> options,
    Object? rawInput,
    List<Map<String, Object?>> locations = const <Map<String, Object?>>[],
  }) async {
    final response = await client.requestPermission(
      RequestPermissionRequest.fromJson(<String, Object?>{
        'sessionId': session.sessionId.value,
        'toolCall': <String, Object?>{
          'toolCallId': itemId,
          'kind': kind,
          'status': 'pending',
          'title': title,
          'rawInput': ?rawInput,
          if (locations.isNotEmpty) 'locations': locations,
        },
        'options': <Object?>[for (final option in options) option.toJson()],
        '_meta': <String, Object?>{
          'codex': <String, Object?>{'params': params.toJson()},
        },
      }),
    );
    final outcome = response.outcome;
    if (outcome is! RequestPermissionOutcomeSelected) {
      return null;
    }
    final id = outcome.value.optionId.value;
    return options.where((option) => option.id == id).firstOrNull?.decision;
  }

  String _itemId(CodexJsonObject params) {
    final id = params.optionalString('itemId');
    return id == null || id.isEmpty ? 'approval' : id;
  }

  List<String> _stringList(Object? value) => value is List<Object?>
      ? <String>[
          for (final item in value)
            if (item is String) item,
        ]
      : const <String>[];

  String _amendmentLabel(List<String> amendment) {
    final prefix = amendment.join(' ');
    if (prefix.isEmpty || prefix.contains('\n') || prefix.contains('\r')) {
      return 'Allow and Remember Command Pattern';
    }
    return 'Allow Commands Starting With `$prefix`';
  }

  CodexJsonObject _safeDefault(CodexServerRequest request) =>
      request is CodexPermissionsRequest
      ? _rejectPermissions
      : CodexJsonObject.from(<String, Object?>{'decision': 'cancel'});

  CodexJsonObject get _rejectPermissions =>
      CodexJsonObject.from(<String, Object?>{
        'permissions': <String, Object?>{},
        'scope': 'turn',
        'strictAutoReview': true,
      });
}

final class _DecisionOption {
  const _DecisionOption(this.id, this.name, this.kind, this.decision);

  final String id;
  final String name;
  final String kind;
  final Object? decision;

  Map<String, Object?> toJson() => <String, Object?>{
    'optionId': id,
    'name': name,
    'kind': kind,
    '_meta': <String, Object?>{
      'codex': <String, Object?>{'decision': decision},
    },
  };
}
