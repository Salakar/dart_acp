import 'json.dart';

/// One category in the current context-window allocation.
final class ContextCategory {
  /// Creates a context category.
  const ContextCategory({
    required this.name,
    required this.tokens,
    required this.color,
    this.isDeferred = false,
  });

  /// Display name reported by Claude Code.
  final String name;

  /// Tokens attributed to this category.
  final int tokens;

  /// CLI display color.
  final String color;

  /// Whether the category is loaded only when needed.
  final bool isDeferred;

  static ContextCategory _fromJson(JsonMap json) => ContextCategory(
    name: requiredString(json, 'name', 'context category'),
    tokens: requiredInt(json, 'tokens', 'context category'),
    color: requiredString(json, 'color', 'context category'),
    isDeferred: optionalBool(json, 'isDeferred', 'context category') ?? false,
  );
}

/// Token contribution of an individual MCP tool, memory file, or agent.
final class ContextBreakdown {
  /// Creates a context breakdown item.
  ContextBreakdown({
    this.name,
    required this.tokens,
    this.serverName,
    this.path,
    this.type,
    this.agentType,
    this.source,
    this.isLoaded,
    JsonMap raw = const {},
  }) : raw = immutableJsonMap(raw);

  /// Item or tool display name.
  final String? name;

  /// Tokens attributed to this item.
  final int tokens;

  /// MCP server name when this is an MCP tool.
  final String? serverName;

  /// Source path when this is a memory file.
  final String? path;

  /// Memory-file source type.
  final String? type;

  /// Agent type when this entry describes an agent definition.
  final String? agentType;

  /// Agent-definition source.
  final String? source;

  /// Whether an MCP tool is currently loaded into context.
  final bool? isLoaded;

  /// Full forward-compatible breakdown payload.
  final JsonMap raw;

  static ContextBreakdown _fromJson(JsonMap json) => ContextBreakdown(
    name: optionalString(json, 'name', 'context breakdown'),
    tokens: requiredInt(json, 'tokens', 'context breakdown'),
    serverName: optionalString(json, 'serverName', 'context breakdown'),
    path: optionalString(json, 'path', 'context breakdown'),
    type: optionalString(json, 'type', 'context breakdown'),
    agentType: optionalString(json, 'agentType', 'context breakdown'),
    source: optionalString(json, 'source', 'context breakdown'),
    isLoaded: optionalBool(json, 'isLoaded', 'context breakdown'),
    raw: json,
  );
}

/// Current Claude context-window usage.
final class ContextUsage {
  /// Creates a context usage result.
  ContextUsage({
    required List<ContextCategory> categories,
    required this.totalTokens,
    required this.maxTokens,
    this.rawMaxTokens,
    required this.percentage,
    required this.model,
    this.isAutoCompactEnabled,
    List<ContextBreakdown> mcpTools = const [],
    List<ContextBreakdown> memoryFiles = const [],
    List<ContextBreakdown> agents = const [],
    List<List<JsonMap>> gridRows = const [],
    this.autoCompactThreshold,
    List<JsonMap> deferredBuiltinTools = const [],
    List<JsonMap> systemTools = const [],
    List<JsonMap> systemPromptSections = const [],
    JsonMap? slashCommands,
    JsonMap? skills,
    JsonMap? messageBreakdown,
    JsonValue apiUsage,
    JsonMap raw = const {},
  }) : categories = List<ContextCategory>.unmodifiable(categories),
       mcpTools = List<ContextBreakdown>.unmodifiable(mcpTools),
       memoryFiles = List<ContextBreakdown>.unmodifiable(memoryFiles),
       agents = List<ContextBreakdown>.unmodifiable(agents),
       gridRows = List<List<JsonMap>>.unmodifiable(
         gridRows.map(
           (row) => List<JsonMap>.unmodifiable(row.map(immutableJsonMap)),
         ),
       ),
       deferredBuiltinTools = List<JsonMap>.unmodifiable(
         deferredBuiltinTools.map(immutableJsonMap),
       ),
       systemTools = List<JsonMap>.unmodifiable(
         systemTools.map(immutableJsonMap),
       ),
       systemPromptSections = List<JsonMap>.unmodifiable(
         systemPromptSections.map(immutableJsonMap),
       ),
       slashCommands = slashCommands == null
           ? null
           : immutableJsonMap(slashCommands),
       skills = skills == null ? null : immutableJsonMap(skills),
       messageBreakdown = messageBreakdown == null
           ? null
           : immutableJsonMap(messageBreakdown),
       apiUsage = immutableJsonValue(apiUsage),
       raw = immutableJsonMap(raw);

  /// Usage categories.
  final List<ContextCategory> categories;

  /// Tokens currently used.
  final int totalTokens;

  /// Effective context-window size.
  final int maxTokens;

  /// Model's context-window size before the autocompact reserve.
  final int? rawMaxTokens;

  /// Percentage of the window in use.
  final double percentage;

  /// Model for which the calculation was made.
  final String model;

  /// Whether automatic compaction is active.
  final bool? isAutoCompactEnabled;

  /// Per-MCP-tool usage.
  final List<ContextBreakdown> mcpTools;

  /// Per-memory-file usage.
  final List<ContextBreakdown> memoryFiles;

  /// Per-agent usage.
  final List<ContextBreakdown> agents;

  /// CLI context-grid cells, retained as typed JSON boundaries.
  final List<List<JsonMap>> gridRows;

  /// Token threshold at which automatic compaction begins.
  final int? autoCompactThreshold;

  /// Deferred built-in tool records.
  final List<JsonMap> deferredBuiltinTools;

  /// Built-in system tool records.
  final List<JsonMap> systemTools;

  /// System-prompt section records.
  final List<JsonMap> systemPromptSections;

  /// Slash-command usage summary.
  final JsonMap? slashCommands;

  /// Skill usage summary.
  final JsonMap? skills;

  /// Detailed message-token breakdown.
  final JsonMap? messageBreakdown;

  /// Cumulative API usage, when the CLI provides it.
  final JsonValue apiUsage;

  /// Full forward-compatible control response.
  final JsonMap raw;

  /// Decodes a control-protocol response.
  factory ContextUsage.fromJson(JsonMap json) => ContextUsage(
    categories: _decodeList(json, 'categories', ContextCategory._fromJson),
    totalTokens: requiredInt(json, 'totalTokens', 'context usage'),
    maxTokens: requiredInt(json, 'maxTokens', 'context usage'),
    rawMaxTokens: optionalInt(json, 'rawMaxTokens', 'context usage'),
    percentage: requiredNum(json, 'percentage', 'context usage').toDouble(),
    model: requiredString(json, 'model', 'context usage'),
    isAutoCompactEnabled: optionalBool(
      json,
      'isAutoCompactEnabled',
      'context usage',
    ),
    mcpTools: _decodeList(json, 'mcpTools', ContextBreakdown._fromJson),
    memoryFiles: _decodeList(json, 'memoryFiles', ContextBreakdown._fromJson),
    agents: _decodeList(json, 'agents', ContextBreakdown._fromJson),
    gridRows: _decodeGridRows(json),
    autoCompactThreshold: optionalInt(
      json,
      'autoCompactThreshold',
      'context usage',
    ),
    deferredBuiltinTools: _decodeJsonMaps(json, 'deferredBuiltinTools'),
    systemTools: _decodeJsonMaps(json, 'systemTools'),
    systemPromptSections: _decodeJsonMaps(json, 'systemPromptSections'),
    slashCommands: optionalMap(json, 'slashCommands', 'context usage'),
    skills: optionalMap(json, 'skills', 'context usage'),
    messageBreakdown: optionalMap(json, 'messageBreakdown', 'context usage'),
    apiUsage: immutableJsonValue(json['apiUsage']),
    raw: json,
  );
}

List<T> _decodeList<T>(JsonMap json, String key, T Function(JsonMap) decode) {
  final value = json[key];
  if (value == null) return const [];
  if (value is! List<Object?>) {
    throw FormatException('context usage.$key must be an array');
  }
  return List<T>.unmodifiable(
    value.map((item) => decode(asJsonMap(item, 'context usage.$key'))),
  );
}

List<JsonMap> _decodeJsonMaps(JsonMap json, String key) =>
    _decodeList(json, key, (value) => immutableJsonMap(value));

List<List<JsonMap>> _decodeGridRows(JsonMap json) {
  final value = json['gridRows'];
  if (value == null) return const [];
  if (value is! List<Object?>) {
    throw const FormatException('context usage.gridRows must be an array');
  }
  return List<List<JsonMap>>.unmodifiable(
    value.map((row) {
      if (row is! List<Object?>) {
        throw const FormatException(
          'context usage.gridRows entries must be arrays',
        );
      }
      return List<JsonMap>.unmodifiable(
        row.map((cell) => asJsonMap(cell, 'context usage.gridRows cell')),
      );
    }),
  );
}
