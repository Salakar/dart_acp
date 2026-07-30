import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

/// Mutable selections for one live session.
final class ClaudeSessionConfiguration {
  /// Creates configuration from initialization metadata.
  ClaudeSessionConfiguration({
    required ClaudeInitializationResult initialization,
    PermissionMode initialMode = PermissionMode.standard,
    String? requestedModel,
    List<String>? availableModels,
    Map<String, String> modelOverrides = const <String, String>{},
    String? customModelOption,
    this.useBooleanFastMode = false,
    bool preserveUnknownRequestedModel = false,
    String? requestedAgent,
    EffortLevel? requestedEffort,
    this.allowBypassPermissions = false,
  }) : models = _filterModels(
         initialization.models,
         availableModels,
         modelOverrides,
         customModelOption,
       ),
       agents = initialization.agents,
       mode = initialMode,
       model = _resolveModel(
         _filterModels(
           initialization.models,
           availableModels,
           modelOverrides,
           customModelOption,
         ),
         requestedModel,
         preserveUnknownRequestedModel,
       ),
       _capabilityModels = initialization.models,
       effort = requestedEffort,
       agent =
           initialization.agents.any(
             (candidate) => candidate.name == requestedAgent,
           )
           ? requestedAgent
           : null,
       fastMode =
           initialization.fastModeState != null &&
           initialization.fastModeState != 'off' {
    fastModeDisabledReason = fastMode
        ? null
        : _normalizeFastModeReason(initialization.fastModeDisabledReason);
    final selected = _selectedModel;
    if (mode == PermissionMode.auto && !(selected?.supportsAutoMode ?? false)) {
      mode = PermissionMode.standard;
    }
    if (effort != null &&
        !(selected?.supportedEffortLevels.contains(effort!.name) ?? false)) {
      effort = null;
    }
  }

  /// Discovered models.
  final List<ClaudeModelInfo> models;

  final List<ClaudeModelInfo> _capabilityModels;

  /// Discovered main-thread agents.
  final List<ClaudeAgentInfo> agents;

  /// Current permission mode.
  PermissionMode mode;

  /// Current model picker value.
  String model;

  /// Explicit effort, or `null` for the runtime default.
  EffortLevel? effort;

  /// Selected main-thread agent, or `null` for default.
  String? agent;

  /// Fast-mode preference.
  bool fastMode;

  /// Whether the ACP client accepts boolean configuration options.
  final bool useBooleanFastMode;

  /// Whether the embedding client explicitly enabled unrestricted mode.
  ///
  /// Claude Code rejects bypass mode unless its process was started with the
  /// matching opt-in flag. Advertising it only under the same opt-in keeps the
  /// ACP mode inventory truthful.
  final bool allowBypassPermissions;

  /// Last runtime reason Fast mode was unavailable.
  String? fastModeDisabledReason;

  /// Best synchronous context-window estimate for the selected model.
  int get inferredContextWindow {
    final selected = _selectedModel;
    final descriptor = <String>[
      model,
      if (selected case final value?) ...[
        value.value,
        value.displayName,
        value.description,
        ?value.resolvedModel,
      ],
    ].join(' ').toLowerCase();
    return RegExp(r'(?:\[|-|\b)1m(?:\]|-|\b)').hasMatch(descriptor)
        ? 1000000
        : 200000;
  }

  /// ACP session modes supported for the selected model.
  SessionModeState get modes => SessionModeState(
    currentModeId: SessionModeId(mode.wireValue),
    availableModes: <SessionMode>[
      for (final candidate in PermissionMode.values)
        if (_modeAvailable(candidate))
          SessionMode(
            id: SessionModeId(candidate.wireValue),
            name: _modeName(candidate),
            description: _modeDescription(candidate),
          ),
    ],
  );

  /// ACP configuration options for model, effort, agent, and Fast mode.
  List<SessionConfigOption> get options {
    final current = _selectedModel;
    final efforts = current?.supportedEffortLevels ?? const <String>[];
    return <SessionConfigOption>[
      if (models.isNotEmpty)
        _select(
          id: 'model',
          name: 'Model',
          category: 'model',
          current: model,
          values: <(String, String, String?)>[
            for (final model in models)
              (model.value, model.displayName, model.description),
          ],
        ),
      if (current?.supportsEffort ?? false)
        _select(
          id: 'effort',
          name: 'Effort',
          category: 'thought_level',
          current: effort?.name ?? 'default',
          values: <(String, String, String?)>[
            ('default', 'Default', 'Use the model default.'),
            for (final value in efforts) (value, _title(value), null),
          ],
        ),
      if (_customAgents.isNotEmpty)
        _select(
          id: 'agent',
          name: 'Agent',
          category: 'mode',
          current: agent ?? 'default',
          values: <(String, String, String?)>[
            ('default', 'Default', 'Use the standard agent.'),
            for (final value in _customAgents)
              (value.name, value.name, value.description),
          ],
        ),
      if (current?.supportsFastMode ?? false)
        if (useBooleanFastMode)
          SessionConfigOption.fromJson(<String, Object?>{
            'type': 'boolean',
            'id': 'fast',
            'name': 'Fast mode',
            'description': _fastModeDescription,
            'category': 'model_config',
            'currentValue': fastMode,
          })
        else
          _select(
            id: 'fast',
            name: 'Fast mode',
            category: 'model_config',
            current: fastMode ? 'on' : 'off',
            values: const <(String, String, String?)>[
              ('on', 'On', null),
              ('off', 'Off', null),
            ],
            description: _fastModeDescription,
          ),
    ];
  }

  List<ClaudeAgentInfo> get _customAgents => agents
      .where(
        (value) =>
            value.name != 'default' &&
            !const <String>{
              'claude',
              'general-purpose',
              'Explore',
              'Plan',
              'statusline-setup',
            }.contains(value.name),
      )
      .toList(growable: false);

  bool _modeAvailable(PermissionMode candidate) {
    if (candidate == PermissionMode.bypassPermissions) {
      return allowBypassPermissions;
    }
    if (candidate != PermissionMode.auto) return true;
    return _selectedModel?.supportsAutoMode ?? false;
  }

  ClaudeModelInfo? get _selectedModel =>
      models.where((candidate) => candidate.value == model).firstOrNull ??
      _matchModel(_capabilityModels, model);

  String get _fastModeDescription {
    final explanation = fastMode
        ? null
        : switch (fastModeDisabledReason) {
            'free' => 'not available on the free plan',
            'extra_usage_disabled' =>
              'requires extra usage to be enabled for this account',
            'model_not_allowed' => 'not available for the selected model',
            'not_first_party' => 'not available on this API provider',
            'disabled_by_env' => 'disabled by environment configuration',
            'network_error' =>
              'eligibility could not be verified (network error)',
            _ => null,
          };
    return explanation == null
        ? 'Faster responses on supported models.'
        : 'Faster responses on supported models — $explanation.';
  }

  /// Applies [value] to [id], throwing for unsupported selections.
  Future<void> apply(String id, Object value, ClaudeAgentClient client) async {
    switch (id) {
      case 'model':
        if (value is! String ||
            !models.any((candidate) => candidate.value == value)) {
          throw const FormatException('Unsupported model');
        }
        await client.setModel(value);
        model = value;
        final selected = models.firstWhere(
          (candidate) => candidate.value == value,
        );
        if (mode == PermissionMode.auto && !selected.supportsAutoMode) {
          await client.setPermissionMode(PermissionMode.standard);
          mode = PermissionMode.standard;
        }
        if (effort != null &&
            !selected.supportedEffortLevels.contains(effort!.name)) {
          await client.applyFlagSettings(
            const ClaudeFlagSettings(clearEffortLevel: true),
          );
          effort = null;
        }
        if (!selected.supportsFastMode) fastMode = false;
        if (selected.supportsFastMode &&
            fastModeDisabledReason == 'model_not_allowed') {
          fastModeDisabledReason = null;
        }
      case 'effort':
        if (value is! String) throw const FormatException('Invalid effort');
        if (value == 'default') {
          await client.applyFlagSettings(
            const ClaudeFlagSettings(clearEffortLevel: true),
          );
          effort = null;
          return;
        }
        final selected = EffortLevel.values
            .where((candidate) => candidate.name == value)
            .firstOrNull;
        final modelInfo = models
            .where((candidate) => candidate.value == model)
            .firstOrNull;
        if (selected == null ||
            !(modelInfo?.supportedEffortLevels.contains(value) ?? false)) {
          throw const FormatException('Unsupported effort');
        }
        await client.applyFlagSettings(
          ClaudeFlagSettings(effortLevel: selected),
        );
        effort = selected;
      case 'agent':
        if (value is! String) throw const FormatException('Invalid agent');
        if (value == 'default') {
          await client.applyFlagSettings(
            const ClaudeFlagSettings(clearAgent: true),
          );
          agent = null;
          return;
        }
        if (!_customAgents.any((candidate) => candidate.name == value)) {
          throw const FormatException('Unsupported agent');
        }
        await client.applyFlagSettings(ClaudeFlagSettings(agent: value));
        agent = value;
      case 'fast':
        final enabled = switch (value) {
          true => true,
          false => false,
          'on' => true,
          'off' => false,
          _ => throw const FormatException('Invalid Fast mode'),
        };
        final supports = _selectedModel?.supportsFastMode ?? false;
        if (!supports) throw const FormatException('Fast mode is unavailable');
        await client.applyFlagSettings(ClaudeFlagSettings(fastMode: enabled));
        fastMode = enabled;
        fastModeDisabledReason = null;
      default:
        throw FormatException('Unknown configuration option: $id');
    }
  }

  /// Reconciles a runtime Fast-mode state, returning whether ACP changed.
  bool reconcileFastMode(String? state, {String? disabledReason}) {
    if (state == null) return false;
    final previous = fastMode;
    final previousReason = fastModeDisabledReason;
    if (state == 'on') {
      fastMode = true;
      fastModeDisabledReason = null;
    } else if (state == 'off') {
      fastMode = false;
      fastModeDisabledReason = _normalizeFastModeReason(disabledReason);
    } else if (state == 'cooldown') {
      fastMode = true;
      fastModeDisabledReason = null;
    }
    return previous != fastMode || previousReason != fastModeDisabledReason;
  }

  /// Reconciles a runtime model swap, returning whether ACP changed.
  bool reconcileModel(String value) {
    if (value.isEmpty) return false;
    final matched = _matchModel(models, value);
    final next = matched?.value ?? value;
    if (next == model) return false;
    model = next;
    return true;
  }

  /// Reconciles a runtime permission-mode swap, returning whether ACP changed.
  bool reconcileMode(String? value) {
    if (value == null || value.isEmpty) return false;
    final next = PermissionMode.values
        .where((candidate) => candidate.wireValue == value)
        .firstOrNull;
    if (next == null) return false;
    if (!_modeAvailable(next) || next == mode) return false;
    mode = next;
    return true;
  }

  static SessionConfigOption _select({
    required String id,
    required String name,
    required String category,
    required String current,
    required List<(String, String, String?)> values,
    String? description,
  }) => SessionConfigOption.fromJson(<String, Object?>{
    'type': 'select',
    'id': id,
    'name': name,
    'description': ?description,
    'category': category,
    'currentValue': current,
    'options': <Object?>[
      for (final value in values)
        <String, Object?>{
          'value': value.$1,
          'name': value.$2,
          if (value.$3 case final description?)
            if (description.isNotEmpty) 'description': description,
        },
    ],
  });
  static String _resolveModel(
    List<ClaudeModelInfo> models,
    String? requested,
    bool preserveUnknown,
  ) {
    if (requested != null) {
      final matched = _matchModel(models, requested);
      if (matched != null) return matched.value;
      if (preserveUnknown && requested.trim().isNotEmpty) return requested;
    }
    if (models.isEmpty) return requested ?? 'default';
    return models.first.value;
  }

  static List<ClaudeModelInfo> _filterModels(
    List<ClaudeModelInfo> models,
    List<String>? available,
    Map<String, String> overrides,
    String? customModelOption,
  ) {
    if (available == null) return models;
    final defaultModel =
        models.where((model) => model.value == 'default').firstOrNull ??
        ClaudeModelInfo.fromJson(const <String, Object?>{
          'value': 'default',
          'displayName': 'Default',
          'description': '',
        });
    final result = <ClaudeModelInfo>[defaultModel];
    final seen = <String>{'default'};
    final candidates = models
        .where((model) => model.value != 'default')
        .toList(growable: false);
    for (final entry in available) {
      final trimmed = entry.trim();
      if (trimmed.isEmpty) continue;
      final effective = overrides[trimmed] ?? trimmed;
      if (!seen.add(effective)) continue;
      final match = _matchModel(candidates, trimmed);
      result.add(
        ClaudeModelInfo.fromJson(<String, Object?>{
          ...?match?.raw,
          'value': effective,
          'displayName': match?.displayName ?? trimmed,
          'description': match?.description ?? '',
        }),
      );
    }
    final custom = customModelOption?.trim();
    if (custom != null && custom.isNotEmpty && seen.add(custom)) {
      final match = models.where((model) => model.value == custom).firstOrNull;
      if (match != null) result.add(match);
    }
    return List<ClaudeModelInfo>.unmodifiable(result);
  }

  static ClaudeModelInfo? _matchModel(
    List<ClaudeModelInfo> models,
    String preference,
  ) {
    final trimmed = preference.trim();
    if (trimmed.isEmpty) return null;
    final lower = trimmed.toLowerCase();
    final canonical = _canonicalModel(trimmed);
    final direct = models
        .where(
          (model) =>
              model.value == trimmed ||
              _canonicalModel(model.value) == canonical ||
              model.displayName.toLowerCase() == lower,
        )
        .firstOrNull;
    if (direct != null) return direct;

    bool resolvedMatches(ClaudeModelInfo model) =>
        model.resolvedModel != null &&
        _canonicalModel(model.resolvedModel!) == canonical;
    final namedResolved = models
        .where((model) => model.value != 'default' && resolvedMatches(model))
        .firstOrNull;
    if (namedResolved != null) return namedResolved;
    final anyResolved = models.where(resolvedMatches).firstOrNull;
    if (anyResolved != null) return anyResolved;

    final hint = _contextHint(trimmed);
    final includes = models
        .where(
          (model) =>
              _versionsCompatible(trimmed, model) &&
              _contextHint(model.value) == hint &&
              (model.value.toLowerCase().contains(lower) ||
                  model.displayName.toLowerCase().contains(lower) ||
                  lower.contains(model.value.toLowerCase())),
        )
        .firstOrNull;
    if (includes != null) return includes;

    final tokens = _modelTokens(trimmed);
    if (tokens.isEmpty) return null;
    ClaudeModelInfo? best;
    var bestScore = 0;
    for (final model in models) {
      if (!_versionsCompatible(trimmed, model)) continue;
      final haystack = '${model.value} ${model.displayName}'.toLowerCase();
      var score = 0;
      var matchedIdentity = false;
      for (final token in tokens) {
        if (!haystack.contains(token)) continue;
        if (token != hint) matchedIdentity = true;
        score += token == hint ? 3 : 1;
      }
      if (hint != null && !matchedIdentity) score = 0;
      if (score > bestScore) {
        best = model;
        bestScore = score;
      }
    }
    return best;
  }

  static String _canonicalModel(String value) => value
      .trim()
      .toLowerCase()
      .replaceFirst(RegExp(r'-(\d+m)$', caseSensitive: false), r'[$1]');

  static String? _contextHint(String value) => RegExp(
    r'\[(\d+m)\]$',
    caseSensitive: false,
  ).firstMatch(_canonicalModel(value))?.group(1)?.toLowerCase();

  static String? _modelVersion(String value) {
    final withoutHint = value
        .replaceAll(RegExp(r'\[\d+m\]', caseSensitive: false), '')
        .replaceFirst(RegExp(r'-\d+m$', caseSensitive: false), '');
    final match = RegExp(r'\b(\d+)(?:[-.](\d+))?\b').firstMatch(withoutHint);
    if (match == null) return null;
    return match.group(2) == null
        ? match.group(1)
        : '${match.group(1)}.${match.group(2)}';
  }

  static bool _versionsCompatible(
    String preference,
    ClaudeModelInfo candidate,
  ) {
    final preferred = _modelVersion(preference);
    if (preferred == null) return true;
    final candidateVersion =
        _modelVersion(candidate.value) ??
        _modelVersion(candidate.displayName) ??
        _modelVersion(candidate.description);
    return candidateVersion == null || candidateVersion == preferred;
  }

  static List<String> _modelTokens(String value) {
    final canonical = _canonicalModel(value);
    final hint = _contextHint(value);
    final normalized = hint == null
        ? canonical
        : canonical.replaceFirst('[$hint]', ' $hint ');
    return normalized
        .split(RegExp('[^a-z0-9]+'))
        .map(
          (token) => token == 'opusplan'
              ? 'opus'
              : token == 'best' || token == 'default'
              ? ''
              : token,
        )
        .where(
          (token) =>
              token.isNotEmpty &&
              token != 'claude' &&
              (RegExp('[a-z]').hasMatch(token) || token.endsWith('m')),
        )
        .toList(growable: false);
  }

  static String _modeName(PermissionMode mode) => switch (mode) {
    PermissionMode.standard => 'Default',
    PermissionMode.acceptEdits => 'Accept edits',
    PermissionMode.plan => 'Plan',
    PermissionMode.bypassPermissions => 'Bypass permissions',
    PermissionMode.dontAsk => "Don't ask",
    PermissionMode.auto => 'Auto',
  };

  static String _modeDescription(PermissionMode mode) => switch (mode) {
    PermissionMode.standard => 'Ask before potentially unsafe actions.',
    PermissionMode.acceptEdits => 'Automatically approve file edits.',
    PermissionMode.plan => 'Plan without making changes.',
    PermissionMode.bypassPermissions => 'Skip permission checks.',
    PermissionMode.dontAsk => 'Deny actions that require a prompt.',
    PermissionMode.auto => 'Let a model review permission requests.',
  };

  static String _title(String value) =>
      '${value[0].toUpperCase()}${value.substring(1)}';

  static String? _normalizeFastModeReason(String? reason) =>
      const <String>{
        'free',
        'extra_usage_disabled',
        'model_not_allowed',
        'not_first_party',
        'disabled_by_env',
        'network_error',
      }.contains(reason)
      ? reason
      : null;
}
