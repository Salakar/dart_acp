import 'dart:convert';
import 'dart:io';

import 'json.dart';
import 'options.dart';

/// Effective settings resolved from managed, user, project, and local tiers.
final class ClaudeResolvedSettings {
  /// Creates an immutable resolved-settings snapshot.
  ClaudeResolvedSettings(
    JsonMap effective, {
    Map<String, ClaudeSettingsProvenance> provenance = const {},
    List<ClaudeSettingsSourceSnapshot> sources = const [],
  }) : effective = immutableJsonMap(effective),
       provenance = Map<String, ClaudeSettingsProvenance>.unmodifiable(
         provenance,
       ),
       sources = List<ClaudeSettingsSourceSnapshot>.unmodifiable(sources);

  /// Fully merged settings.
  final JsonMap effective;

  /// Winning source for every top-level effective key.
  final Map<String, ClaudeSettingsProvenance> provenance;

  /// Raw settings layers in increasing precedence order.
  final List<ClaudeSettingsSourceSnapshot> sources;

  /// Selected model identifier, when configured.
  String? get model => effective['model'] as String?;

  /// Configured reasoning effort, when it names a supported SDK level.
  EffortLevel? get effortLevel {
    final value = effective['effortLevel'];
    if (value is! String) return null;
    return EffortLevel.values
        .where((candidate) => candidate.name == value)
        .firstOrNull;
  }

  /// Model allowlist accumulated across settings tiers.
  List<String> get availableModels {
    final values = effective['availableModels'];
    if (values is! List<Object?>) return const <String>[];
    return List<String>.unmodifiable(values.whereType<String>());
  }

  /// Provider-specific model IDs keyed by the aliases they replace.
  Map<String, String> get modelOverrides {
    final values = effective['modelOverrides'];
    if (values is! Map<Object?, Object?>) return const <String, String>{};
    return Map<String, String>.unmodifiable(<String, String>{
      for (final entry in values.entries)
        if (entry.key is String && entry.value is String)
          entry.key! as String: entry.value! as String,
    });
  }

  /// Default permission mode after project trust filtering.
  String? get defaultPermissionMode {
    final permissions = effective['permissions'];
    return permissions is Map<Object?, Object?>
        ? permissions['defaultMode'] as String?
        : null;
  }

  /// Environment policy contributed by effective settings.
  Map<String, String> get environment {
    final value = effective['env'];
    if (value is! Map<Object?, Object?>) return const <String, String>{};
    return Map<String, String>.unmodifiable(<String, String>{
      for (final entry in value.entries)
        if (entry.key is String && entry.value is String)
          entry.key! as String: entry.value! as String,
    });
  }
}

/// Provenance of one effective top-level settings key.
final class ClaudeSettingsProvenance {
  /// Creates settings provenance.
  const ClaudeSettingsProvenance({
    required this.source,
    this.path,
    this.policyOrigin,
  });

  /// `user`, `project`, `local`, `managed`, or `flag`.
  final String source;

  /// Source file, when the source is file-backed.
  final String? path;

  /// Managed policy sub-source such as `parent`, `remote`, or `file`.
  final String? policyOrigin;
}

/// One raw settings layer participating in resolution.
final class ClaudeSettingsSourceSnapshot {
  /// Creates an immutable source snapshot.
  ClaudeSettingsSourceSnapshot({
    required this.source,
    required JsonMap settings,
    this.path,
    this.policyOrigin,
  }) : settings = immutableJsonMap(settings);

  /// `user`, `project`, `local`, `managed`, or `flag`.
  final String source;

  /// Complete settings contributed by this layer.
  final JsonMap settings;

  /// Source file, when file-backed.
  final String? path;

  /// Managed policy sub-source.
  final String? policyOrigin;
}

/// Resolves the raw current settings cascade without spawning Claude Code.
///
/// Unlike [resolveClaudeSettings], this does not remove escalating project
/// permission modes. Call [filterEscalatingDefaultMode] before making a trust
/// decision from `permissions.defaultMode`.
Future<ClaudeResolvedSettings> resolveSettings({
  String? workingDirectory,
  List<SettingSource> settingSources = SettingSource.values,
  Map<String, String>? environment,
  String? operatingSystem,
  String? managedSettingsPath,
  String? userConfigDirectory,
  JsonMap? managedSettings,
  JsonMap? serverManagedSettings,
}) async {
  final variables = environment ?? Platform.environment;
  final os = operatingSystem ?? Platform.operatingSystem;
  final cwd = workingDirectory ?? Directory.current.path;
  final userDirectory =
      userConfigDirectory ??
      variables['CLAUDE_CONFIG_DIR'] ??
      _join(variables['HOME'] ?? variables['USERPROFILE'] ?? '', '.claude');
  final layers = <ClaudeSettingsSourceSnapshot>[];

  Future<void> addFile(SettingSource source, String path) async {
    final settings = await _readSettings(path);
    if (settings.isEmpty) return;
    layers.add(
      ClaudeSettingsSourceSnapshot(
        source: source.name,
        settings: settings,
        path: path,
      ),
    );
  }

  if (settingSources.contains(SettingSource.user)) {
    await addFile(SettingSource.user, _join(userDirectory, 'settings.json'));
  }
  if (settingSources.contains(SettingSource.project)) {
    await addFile(
      SettingSource.project,
      _join(_join(cwd, '.claude'), 'settings.json'),
    );
  }
  if (settingSources.contains(SettingSource.local)) {
    await addFile(
      SettingSource.local,
      _join(_join(cwd, '.claude'), 'settings.local.json'),
    );
  }
  if (managedSettings != null) {
    final restricted = _restrictParentManagedSettings(managedSettings);
    if (restricted.isNotEmpty) {
      layers.add(
        ClaudeSettingsSourceSnapshot(
          source: 'managed',
          settings: restricted,
          policyOrigin: 'parent',
        ),
      );
    }
  }
  final remote =
      serverManagedSettings ??
      await _readSettings(_join(userDirectory, 'remote-settings.json'));
  if (remote.isNotEmpty) {
    layers.add(
      ClaudeSettingsSourceSnapshot(
        source: 'managed',
        settings: remote,
        path: serverManagedSettings == null
            ? _join(userDirectory, 'remote-settings.json')
            : null,
        policyOrigin: 'remote',
      ),
    );
  }
  final managedPath = managedSettingsPath ?? _managedSettingsPath(os);
  final managedFile = await _readSettings(managedPath);
  if (managedFile.isNotEmpty) {
    layers.add(
      ClaudeSettingsSourceSnapshot(
        source: 'managed',
        settings: managedFile,
        path: managedPath,
        policyOrigin: 'file',
      ),
    );
  }

  var effective = <String, Object?>{};
  final provenance = <String, ClaudeSettingsProvenance>{};
  for (final layer in layers) {
    effective = _merge(effective, layer.settings);
    for (final key in layer.settings.keys) {
      provenance[key] = ClaudeSettingsProvenance(
        source: layer.source,
        path: layer.path,
        policyOrigin: layer.policyOrigin,
      );
    }
  }
  return ClaudeResolvedSettings(
    effective,
    provenance: provenance,
    sources: layers,
  );
}

/// Applies the CLI trust filter for escalating project default modes.
JsonMap filterEscalatingDefaultMode(ClaudeResolvedSettings resolved) {
  String? defaultModeSource;
  for (final layer in resolved.sources) {
    final permissions = layer.settings['permissions'];
    if (permissions is Map<Object?, Object?> &&
        permissions.containsKey('defaultMode')) {
      defaultModeSource = layer.source;
    }
  }
  return immutableJsonMap(
    defaultModeSource == SettingSource.project.name
        ? _filterProjectEscalation(resolved.effective)
        : resolved.effective,
  );
}

/// Resolves Claude settings with the runtime's tier precedence.
///
/// Later tiers override earlier scalar/map values. Arrays are unioned and
/// deduplicated in tier order. Managed policy is always applied last; passing
/// an empty [settingSources] therefore resolves managed policy only.
Future<ClaudeResolvedSettings> resolveClaudeSettings({
  String? workingDirectory,
  List<SettingSource> settingSources = SettingSource.values,
  Map<String, String>? environment,
  String? operatingSystem,
  String? managedSettingsPath,
  String? userConfigDirectory,
}) async {
  final variables = environment ?? Platform.environment;
  final os = operatingSystem ?? Platform.operatingSystem;
  final cwd = workingDirectory ?? Directory.current.path;
  final userDirectory =
      userConfigDirectory ??
      variables['CLAUDE_CONFIG_DIR'] ??
      _join(variables['HOME'] ?? variables['USERPROFILE'] ?? '', '.claude');
  final managedPath = managedSettingsPath ?? _managedSettingsPath(os);
  var effective = <String, Object?>{};
  if (settingSources.contains(SettingSource.user)) {
    effective = _merge(
      effective,
      await _readSettings(_join(userDirectory, 'settings.json')),
    );
  }
  if (settingSources.contains(SettingSource.project)) {
    final project = await _readSettings(
      _join(_join(cwd, '.claude'), 'settings.json'),
    );
    effective = _merge(effective, _filterProjectEscalation(project));
  }
  if (settingSources.contains(SettingSource.local)) {
    effective = _merge(
      effective,
      await _readSettings(_join(_join(cwd, '.claude'), 'settings.local.json')),
    );
  }
  effective = _merge(effective, await _readSettings(managedPath));
  return ClaudeResolvedSettings(effective);
}

String _managedSettingsPath(String operatingSystem) =>
    switch (operatingSystem) {
      'macos' =>
        '/Library/Application Support/ClaudeCode/managed-settings.json',
      'windows' => r'C:\Program Files\ClaudeCode\managed-settings.json',
      _ => '/etc/claude-code/managed-settings.json',
    };

String _join(String parent, String child) {
  if (parent.isEmpty) return child;
  final separator = parent.contains(r'\') && !parent.contains('/') ? '\\' : '/';
  if (parent.endsWith('/') || parent.endsWith(r'\')) return '$parent$child';
  return '$parent$separator$child';
}

Future<JsonMap> _readSettings(String path) async {
  final file = File(path);
  if (!await file.exists()) return const <String, Object?>{};
  Object? decoded;
  try {
    decoded = jsonDecode(await file.readAsString());
  } on FormatException catch (error) {
    throw FormatException('Invalid Claude settings at $path: ${error.message}');
  }
  if (decoded is! Map<Object?, Object?>) {
    throw FormatException('Claude settings at $path must be a JSON object');
  }
  return <String, Object?>{
    for (final entry in decoded.entries)
      if (entry.key is String) entry.key! as String: entry.value,
  };
}

JsonMap _filterProjectEscalation(JsonMap value) {
  final permissions = value['permissions'];
  if (permissions is! Map<Object?, Object?>) return value;
  final mode = permissions['defaultMode'];
  if (!const <String>{
    'acceptEdits',
    'auto',
    'bypassPermissions',
  }.contains(mode)) {
    return value;
  }
  final filteredPermissions = <String, Object?>{
    for (final entry in permissions.entries)
      if (entry.key is String && entry.key != 'defaultMode')
        entry.key! as String: entry.value,
  };
  return <String, Object?>{...value, 'permissions': filteredPermissions};
}

JsonMap _merge(JsonMap earlier, JsonMap later) {
  final result = <String, Object?>{...earlier};
  for (final entry in later.entries) {
    final previous = result[entry.key];
    final next = entry.value;
    if (previous is Map<Object?, Object?> && next is Map<Object?, Object?>) {
      result[entry.key] = _merge(_stringMap(previous), _stringMap(next));
    } else if (previous is List<Object?> && next is List<Object?>) {
      result[entry.key] = _union(previous, next);
    } else {
      result[entry.key] = next;
    }
  }
  return result;
}

JsonMap _stringMap(Map<Object?, Object?> value) => <String, Object?>{
  for (final entry in value.entries)
    if (entry.key is String) entry.key! as String: entry.value,
};

List<Object?> _union(List<Object?> earlier, List<Object?> later) {
  final result = <Object?>[];
  final seen = <String>{};
  for (final value in <Object?>[...earlier, ...later]) {
    final key = jsonEncode(value);
    if (seen.add(key)) result.add(value);
  }
  return result;
}

JsonMap _restrictParentManagedSettings(JsonMap settings) {
  final result = <String, Object?>{};
  const restrictiveKeys = <String>{
    'allowedChannelPlugins',
    'allowedHttpHookUrls',
    'allowedMcpServers',
    'deniedMcpServers',
    'disabledMcpjsonServers',
  };
  for (final entry in settings.entries) {
    if (entry.key.startsWith('allowManaged') ||
        entry.key.startsWith('disable') ||
        entry.key.startsWith('blocked') ||
        restrictiveKeys.contains(entry.key)) {
      result[entry.key] = entry.value;
    }
  }
  final permissions = settings['permissions'];
  if (permissions is Map<Object?, Object?>) {
    final restricted = <String, Object?>{
      if (permissions['deny'] != null) 'deny': permissions['deny'],
      if (permissions['ask'] != null) 'ask': permissions['ask'],
    };
    if (restricted.isNotEmpty) result['permissions'] = restricted;
  }
  final sandbox = settings['sandbox'];
  if (sandbox is Map<Object?, Object?>) {
    final restricted = _restrictParentSandbox(_stringMap(sandbox));
    if (restricted.isNotEmpty) result['sandbox'] = restricted;
  }
  return result;
}

JsonMap _restrictParentSandbox(JsonMap sandbox) {
  final restricted = <String, Object?>{
    if (sandbox['enabled'] == true) 'enabled': true,
    if (sandbox['failIfUnavailable'] == true) 'failIfUnavailable': true,
    if (sandbox['autoAllowBashIfSandboxed'] == false)
      'autoAllowBashIfSandboxed': false,
    if (sandbox['allowUnsandboxedCommands'] == false)
      'allowUnsandboxedCommands': false,
    if (sandbox['allowAppleEvents'] == false) 'allowAppleEvents': false,
  };
  final credentials = sandbox['credentials'];
  if (credentials is Map<Object?, Object?>) {
    final policy = <String, Object?>{
      if (credentials['files'] != null) 'files': credentials['files'],
      if (credentials['envVars'] != null) 'envVars': credentials['envVars'],
    };
    if (policy.isNotEmpty) restricted['credentials'] = policy;
  }
  final network = sandbox['network'];
  if (network is Map<Object?, Object?>) {
    final policy = <String, Object?>{
      if (network['allowedDomains'] != null)
        'allowedDomains': network['allowedDomains'],
      if (network['deniedDomains'] != null)
        'deniedDomains': network['deniedDomains'],
      if (network['strictAllowlist'] == true) 'strictAllowlist': true,
      if (network['allowManagedDomainsOnly'] == true)
        'allowManagedDomainsOnly': true,
    };
    if (policy.isNotEmpty) restricted['network'] = policy;
  }
  final filesystem = sandbox['filesystem'];
  if (filesystem is Map<Object?, Object?>) {
    final policy = <String, Object?>{
      if (filesystem['denyWrite'] != null) 'denyWrite': filesystem['denyWrite'],
      if (filesystem['denyRead'] != null) 'denyRead': filesystem['denyRead'],
      if (filesystem['allowManagedReadPathsOnly'] == true)
        'allowManagedReadPathsOnly': true,
    };
    if (policy.isNotEmpty) restricted['filesystem'] = policy;
  }
  return restricted;
}
