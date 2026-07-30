import '../initialization.dart';
import '../json.dart';
import '../mcp.dart';
import '../options.dart';

/// Session-scoped CLI flag updates.
final class ClaudeFlagSettings {
  /// Creates a partial flag update.
  const ClaudeFlagSettings({
    this.effortLevel,
    this.clearEffortLevel = false,
    this.agent,
    this.clearAgent = false,
    this.fastMode,
    this.additional = const <String, Object?>{},
  }) : assert(
         !(effortLevel != null && clearEffortLevel),
         'effortLevel and clearEffortLevel are mutually exclusive',
       ),
       assert(
         !(agent != null && clearAgent),
         'agent and clearAgent are mutually exclusive',
       );

  /// Selected effort, when changing it.
  final EffortLevel? effortLevel;

  /// Whether to clear a previously selected effort.
  final bool clearEffortLevel;

  /// Selected main-thread agent, when changing it.
  final String? agent;

  /// Whether to restore the default main-thread agent.
  final bool clearAgent;

  /// Fast-mode preference, when changing it.
  final bool? fastMode;

  /// Additional current settings keys to shallow-merge into the flag tier.
  ///
  /// This explicit JSON boundary keeps the API forward-compatible with
  /// settings added by newer Claude Code releases.
  final JsonMap additional;

  /// Encodes only fields explicitly selected by this update.
  JsonMap toJson() => <String, Object?>{
    ...additional,
    if (effortLevel != null) 'effortLevel': effortLevel!.name,
    if (clearEffortLevel) 'effortLevel': null,
    if (agent != null) 'agent': agent,
    if (clearAgent) 'agent': null,
    if (fastMode != null) 'fastMode': fastMode,
  };
}

/// Receipt returned by runtimes that support interrupt receipts.
final class ClaudeInterruptReceipt {
  /// Decodes an interrupt response.
  ClaudeInterruptReceipt.fromJson(JsonMap json)
    : stillQueued = _queued(json['still_queued']),
      cancelled = _queued(json['cancelled']),
      receiptSupported = json.containsKey('still_queued'),
      raw = immutableJsonMap(json);

  /// Creates a receipt for an older runtime that returned no payload.
  const ClaudeInterruptReceipt.unsupported()
    : stillQueued = const <String>[],
      cancelled = const <String>[],
      receiptSupported = false,
      raw = const <String, Object?>{};

  /// UUIDs of messages that remain queued after interruption.
  final List<String> stillQueued;

  /// UUIDs cancelled by an interrupt that requested queued cancellation.
  final List<String> cancelled;

  /// Whether the runtime supplied the receipt field.
  final bool receiptSupported;

  /// Complete forward-compatible payload.
  final JsonMap raw;
}

/// Tighten-only permission policy for one MCP server.
enum McpPermissionModeOverride {
  /// Force ordinary per-action permission checks.
  standard('default'),

  /// Route decisions through the autonomous permission classifier.
  auto('auto');

  const McpPermissionModeOverride(this.wireValue);

  /// Control-protocol value.
  final String wireValue;
}

/// Informational result of changing an MCP permission override.
final class McpPermissionModeOverrideResult {
  /// Decodes an override response.
  McpPermissionModeOverrideResult.fromJson(JsonMap json)
    : warning = optionalString(json, 'warning', 'MCP permission override'),
      raw = immutableJsonMap(json);

  /// Warning emitted when the named server is not currently known.
  final String? warning;

  /// Complete forward-compatible response.
  final JsonMap raw;
}

/// Result of rewinding checkpointed files.
final class RewindFilesResult {
  /// Decodes a rewind response.
  RewindFilesResult.fromJson(JsonMap json)
    : canRewind = requiredBool(json, 'canRewind', 'rewind files'),
      error = optionalString(json, 'error', 'rewind files'),
      filesChanged = _strings(json['filesChanged'], 'rewind files'),
      insertions = optionalInt(json, 'insertions', 'rewind files'),
      deletions = optionalInt(json, 'deletions', 'rewind files'),
      skippedLinks = optionalInt(json, 'skippedLinks', 'rewind files'),
      raw = immutableJsonMap(json);

  /// Whether rewind can proceed or completed.
  final bool canRewind;

  /// Failure or refusal reason.
  final String? error;

  /// Files affected or that would be affected.
  final List<String> filesChanged;

  /// Inserted-line count.
  final int? insertions;

  /// Deleted-line count.
  final int? deletions;

  /// Unsafe linked paths skipped by a real rewind.
  final int? skippedLinks;

  /// Complete forward-compatible response.
  final JsonMap raw;
}

/// Encoding used by [ClaudeReadFileResult].
enum ClaudeReadFileEncoding {
  /// UTF-8 text.
  utf8('utf-8'),

  /// Base64-encoded bytes.
  base64('base64');

  const ClaudeReadFileEncoding(this.wireValue);

  /// Control-protocol value.
  final String wireValue;
}

/// File data returned by the live session filesystem.
final class ClaudeReadFileResult {
  /// Decodes a read-file response.
  ClaudeReadFileResult.fromJson(JsonMap json)
    : contents = requiredString(json, 'contents', 'read file'),
      absolutePath = requiredString(json, 'absPath', 'read file'),
      isTruncated = optionalBool(json, 'truncated', 'read file') ?? false,
      encoding = json['encoding'] == 'base64'
          ? ClaudeReadFileEncoding.base64
          : ClaudeReadFileEncoding.utf8,
      raw = immutableJsonMap(json);

  /// Text or base64-encoded contents.
  final String contents;

  /// Resolved absolute path.
  final String absolutePath;

  /// Whether the byte cap truncated the result.
  final bool isTruncated;

  /// Returned content encoding.
  final ClaudeReadFileEncoding encoding;

  /// Complete forward-compatible response.
  final JsonMap raw;
}

/// One plugin reported by a live reload.
final class ClaudePluginInfo {
  /// Decodes plugin information.
  ClaudePluginInfo.fromJson(JsonMap json)
    : name = requiredString(json, 'name', 'plugin'),
      path = requiredString(json, 'path', 'plugin'),
      source = optionalString(json, 'source', 'plugin'),
      version = optionalString(json, 'version', 'plugin'),
      raw = immutableJsonMap(json);

  /// Plugin name.
  final String name;

  /// Plugin directory.
  final String path;

  /// Discovery source.
  final String? source;

  /// Manifest version, when declared.
  final String? version;

  /// Complete forward-compatible payload.
  final JsonMap raw;
}

/// Refreshed components returned after reloading plugins.
final class ReloadPluginsResult {
  /// Decodes a plugin reload response.
  ReloadPluginsResult.fromJson(JsonMap json)
    : commands = _objects(
        json['commands'],
        'reload plugins commands',
        ClaudeCommandInfo.fromJson,
      ),
      agents = _objects(
        json['agents'],
        'reload plugins agents',
        ClaudeAgentInfo.fromJson,
      ),
      plugins = _objects(
        json['plugins'],
        'reload plugins plugins',
        ClaudePluginInfo.fromJson,
      ),
      mcpServers = _objects(
        json['mcpServers'],
        'reload plugins MCP servers',
        McpServerStatus.fromJson,
      ),
      errorCount = requiredInt(json, 'error_count', 'reload plugins'),
      raw = immutableJsonMap(json);

  /// Refreshed slash commands.
  final List<ClaudeCommandInfo> commands;

  /// Refreshed agent definitions.
  final List<ClaudeAgentInfo> agents;

  /// Loaded plugins.
  final List<ClaudePluginInfo> plugins;

  /// Current MCP server status.
  final List<McpServerStatus> mcpServers;

  /// Number of reload errors.
  final int errorCount;

  /// Complete forward-compatible response.
  final JsonMap raw;
}

/// Refreshed skills returned after reloading skill files.
final class ReloadSkillsResult {
  /// Decodes a skill reload response.
  ReloadSkillsResult.fromJson(JsonMap json)
    : skills = _objects(
        json['skills'],
        'reload skills',
        ClaudeCommandInfo.fromJson,
      ),
      raw = immutableJsonMap(json);

  /// Refreshed skill commands.
  final List<ClaudeCommandInfo> skills;

  /// Complete forward-compatible response.
  final JsonMap raw;
}

/// Experimental structured usage response from the running session.
final class ClaudeUsageSnapshot {
  /// Decodes an experimental usage response.
  ClaudeUsageSnapshot.fromJson(JsonMap json)
    : session = immutableJsonMap(asJsonMap(json['session'], 'usage session')),
      subscriptionType = optionalString(json, 'subscription_type', 'usage'),
      rateLimitsAvailable =
          optionalBool(json, 'rate_limits_available', 'usage') ?? false,
      rateLimits = json['rate_limits'] == null
          ? null
          : immutableJsonMap(
              asJsonMap(json['rate_limits'], 'usage rate limits'),
            ),
      raw = immutableJsonMap(json);

  /// Session cost and token totals.
  final JsonMap session;

  /// Claude.ai subscription tier, when applicable.
  final String? subscriptionType;

  /// Whether subscription rate-limit windows apply.
  final bool rateLimitsAvailable;

  /// Open-set subscription rate-limit details.
  final JsonMap? rateLimits;

  /// Complete forward-compatible response.
  final JsonMap raw;
}

List<String> _queued(Object? value) {
  if (value == null) return const <String>[];
  if (value is! List<Object?> || value.any((item) => item is! String)) {
    throw const FormatException('interrupt.still_queued must contain strings');
  }
  return List<String>.unmodifiable(value.cast<String>());
}

List<String> _strings(Object? value, String context) {
  if (value == null) return const <String>[];
  if (value is! List<Object?> || value.any((item) => item is! String)) {
    throw FormatException('$context must contain strings');
  }
  return List<String>.unmodifiable(value.cast<String>());
}

List<T> _objects<T>(Object? value, String context, T Function(JsonMap) decode) {
  if (value == null) return const [];
  if (value is! List<Object?>) throw FormatException('$context must be a list');
  return List<T>.unmodifiable(
    value.map((item) => decode(asJsonMap(item, '$context item'))),
  );
}
