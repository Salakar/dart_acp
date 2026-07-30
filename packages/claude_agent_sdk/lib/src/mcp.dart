import 'dart:async';

import 'json.dart';

/// Configuration for one Model Context Protocol server.
sealed class McpServerConfig {
  const McpServerConfig();

  /// Encodes the serializable configuration passed to the CLI.
  JsonMap toJson();
}

/// Permission policy for one tool exposed by an external MCP server.
final class McpServerToolPolicy {
  /// Creates an MCP tool policy.
  const McpServerToolPolicy({
    required this.name,
    this.permissionPolicy,
    this.organizationMaximumPermission,
  });

  /// Tool name.
  final String name;

  /// Open-set policy (`always_allow`, `always_ask`, or `always_deny`).
  final String? permissionPolicy;

  /// Organization ceiling (`allow`, `ask`, or `blocked`).
  final String? organizationMaximumPermission;

  JsonMap _toJson() => {
    'name': name,
    if (permissionPolicy != null) 'permission_policy': permissionPolicy,
    if (organizationMaximumPermission != null)
      'org_max_permission': organizationMaximumPermission,
  };
}

/// Starts an external MCP server over stdio.
final class McpStdioServerConfig extends McpServerConfig {
  /// Creates a stdio MCP configuration.
  McpStdioServerConfig({
    required this.command,
    List<String> arguments = const [],
    Map<String, String> environment = const {},
    this.timeout,
    this.alwaysLoad,
  }) : arguments = List<String>.unmodifiable(arguments),
       environment = Map<String, String>.unmodifiable(environment) {
    if (command.isEmpty) {
      throw ArgumentError.value(command, 'command', 'must not be empty');
    }
  }

  /// Executable to launch.
  final String command;

  /// Executable arguments.
  final List<String> arguments;

  /// Extra child environment values.
  final Map<String, String> environment;

  /// Per-call timeout.
  final Duration? timeout;

  /// Whether tools are eagerly loaded into every prompt.
  final bool? alwaysLoad;

  @override
  JsonMap toJson() => {
    'type': 'stdio',
    'command': command,
    if (arguments.isNotEmpty) 'args': arguments,
    if (environment.isNotEmpty) 'env': environment,
    if (timeout != null) 'timeout': timeout!.inMilliseconds,
    if (alwaysLoad != null) 'alwaysLoad': alwaysLoad,
  };
}

/// Connects to an MCP server using Server-Sent Events.
final class McpSseServerConfig extends McpServerConfig {
  /// Creates an SSE MCP configuration.
  McpSseServerConfig({
    required this.url,
    Map<String, String> headers = const {},
    List<McpServerToolPolicy> tools = const [],
    this.timeout,
    this.alwaysLoad,
  }) : headers = Map<String, String>.unmodifiable(headers),
       tools = List<McpServerToolPolicy>.unmodifiable(tools) {
    if (url.isEmpty) throw ArgumentError.value(url, 'url', 'must not be empty');
  }

  /// Server URL.
  final String url;

  /// Request headers.
  final Map<String, String> headers;

  /// Per-tool permission policies.
  final List<McpServerToolPolicy> tools;

  /// Per-call timeout.
  final Duration? timeout;

  /// Whether tools are eagerly loaded into every prompt.
  final bool? alwaysLoad;

  @override
  JsonMap toJson() => {
    'type': 'sse',
    'url': url,
    if (headers.isNotEmpty) 'headers': headers,
    if (tools.isNotEmpty)
      'tools': tools.map((tool) => tool._toJson()).toList(growable: false),
    if (timeout != null) 'timeout': timeout!.inMilliseconds,
    if (alwaysLoad != null) 'alwaysLoad': alwaysLoad,
  };
}

/// Connects to an MCP server using streamable HTTP.
final class McpHttpServerConfig extends McpServerConfig {
  /// Creates an HTTP MCP configuration.
  McpHttpServerConfig({
    required this.url,
    Map<String, String> headers = const {},
    List<McpServerToolPolicy> tools = const [],
    this.timeout,
    this.alwaysLoad,
  }) : headers = Map<String, String>.unmodifiable(headers),
       tools = List<McpServerToolPolicy>.unmodifiable(tools) {
    if (url.isEmpty) throw ArgumentError.value(url, 'url', 'must not be empty');
  }

  /// Server URL.
  final String url;

  /// Request headers.
  final Map<String, String> headers;

  /// Per-tool permission policies.
  final List<McpServerToolPolicy> tools;

  /// Per-call timeout.
  final Duration? timeout;

  /// Whether tools are eagerly loaded into every prompt.
  final bool? alwaysLoad;

  @override
  JsonMap toJson() => {
    'type': 'http',
    'url': url,
    if (headers.isNotEmpty) 'headers': headers,
    if (tools.isNotEmpty)
      'tools': tools.map((tool) => tool._toJson()).toList(growable: false),
    if (timeout != null) 'timeout': timeout!.inMilliseconds,
    if (alwaysLoad != null) 'alwaysLoad': alwaysLoad,
  };
}

/// Optional behavioral hints attached to an SDK MCP tool.
final class McpToolAnnotations {
  /// Creates tool annotations.
  const McpToolAnnotations({
    this.title,
    this.isReadOnly,
    this.isDestructive,
    this.isIdempotent,
    this.isOpenWorld,
    this.maxResultSizeChars,
  });

  /// Human-readable title.
  final String? title;

  /// Whether the tool leaves its environment unchanged.
  final bool? isReadOnly;

  /// Whether the tool may perform destructive updates.
  final bool? isDestructive;

  /// Whether repeated identical calls have no additional effect.
  final bool? isIdempotent;

  /// Whether the tool interacts with external entities.
  final bool? isOpenWorld;

  /// Preferred character threshold before the CLI spills a large result.
  final int? maxResultSizeChars;

  JsonMap _toJson() => {
    if (title != null) 'title': title,
    if (isReadOnly != null) 'readOnlyHint': isReadOnly,
    if (isDestructive != null) 'destructiveHint': isDestructive,
    if (isIdempotent != null) 'idempotentHint': isIdempotent,
    if (isOpenWorld != null) 'openWorldHint': isOpenWorld,
  };
}

/// One content item returned by an SDK MCP tool.
sealed class McpToolContent {
  const McpToolContent();

  /// Encodes this item as MCP content.
  JsonMap toJson();
}

/// Text returned by an SDK MCP tool.
final class McpTextContent extends McpToolContent {
  /// Creates text content.
  const McpTextContent(this.text);

  /// Returned text.
  final String text;

  @override
  JsonMap toJson() => {'type': 'text', 'text': text};
}

/// Base64-encoded image returned by an SDK MCP tool.
final class McpImageContent extends McpToolContent {
  /// Creates image content.
  const McpImageContent({required this.data, required this.mimeType});

  /// Base64 data.
  final String data;

  /// Media type.
  final String mimeType;

  @override
  JsonMap toJson() => {'type': 'image', 'data': data, 'mimeType': mimeType};
}

/// Base64-encoded audio returned by an SDK MCP tool.
final class McpAudioContent extends McpToolContent {
  /// Creates audio content.
  const McpAudioContent({required this.data, required this.mimeType});

  /// Base64 data.
  final String data;

  /// Media type.
  final String mimeType;

  @override
  JsonMap toJson() => {'type': 'audio', 'data': data, 'mimeType': mimeType};
}

/// Link to an MCP resource.
final class McpResourceLinkContent extends McpToolContent {
  /// Creates a resource link.
  const McpResourceLinkContent({
    required this.uri,
    this.name,
    this.description,
    this.mimeType,
  });

  /// Resource URI.
  final String uri;

  /// Optional display name.
  final String? name;

  /// Optional description.
  final String? description;

  /// Optional media type.
  final String? mimeType;

  @override
  JsonMap toJson() => {
    'type': 'resource_link',
    'uri': uri,
    if (name != null) 'name': name,
    if (description != null) 'description': description,
    if (mimeType != null) 'mimeType': mimeType,
  };
}

/// Embedded textual MCP resource.
final class McpEmbeddedResourceContent extends McpToolContent {
  /// Creates an embedded textual resource.
  const McpEmbeddedResourceContent({
    required this.uri,
    required this.text,
    this.mimeType,
  });

  /// Resource URI.
  final String uri;

  /// Embedded text.
  final String text;

  /// Optional media type.
  final String? mimeType;

  @override
  JsonMap toJson() => {
    'type': 'resource',
    'resource': {
      'uri': uri,
      'text': text,
      if (mimeType != null) 'mimeType': mimeType,
    },
  };
}

/// Result returned by an [SdkMcpTool] handler.
final class McpToolResult {
  /// Creates a tool result.
  McpToolResult({required List<McpToolContent> content, this.isError = false})
    : content = List<McpToolContent>.unmodifiable(content);

  /// Result content.
  final List<McpToolContent> content;

  /// Whether the content describes an expected tool error.
  final bool isError;

  JsonMap _toJson() => {
    'content': content.map((item) => item.toJson()).toList(growable: false),
    if (isError) 'isError': true,
  };
}

/// Executes one in-process MCP tool.
typedef McpToolHandler = Future<McpToolResult> Function(JsonMap input);

/// Definition of one in-process MCP tool.
final class SdkMcpTool {
  /// Creates an SDK MCP tool.
  SdkMcpTool({
    required this.name,
    required this.description,
    required JsonMap inputSchema,
    required this.handler,
    this.annotations,
  }) : inputSchema = immutableJsonMap(inputSchema) {
    if (name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
  }

  /// Tool identifier exposed to the model.
  final String name;

  /// Human-readable tool description.
  final String description;

  /// JSON Schema accepted by the handler.
  final JsonMap inputSchema;

  /// Tool implementation.
  final McpToolHandler handler;

  /// Optional tool hints.
  final McpToolAnnotations? annotations;
}

/// An in-process tools-only MCP server bridged over the CLI control channel.
final class SdkMcpServer extends McpServerConfig {
  /// Creates an SDK MCP server.
  SdkMcpServer({
    required this.name,
    this.version = '1.0.0',
    List<SdkMcpTool> tools = const [],
  }) : tools = List<SdkMcpTool>.unmodifiable(tools) {
    if (name.isEmpty || version.isEmpty) {
      throw ArgumentError('MCP server name and version must not be empty');
    }
    final names = <String>{};
    for (final tool in tools) {
      if (!names.add(tool.name)) {
        throw ArgumentError.value(
          tool.name,
          'tools',
          'duplicate MCP tool name',
        );
      }
    }
  }

  /// Server name.
  final String name;

  /// Informational server version.
  final String version;

  /// Tools exposed by this server.
  final List<SdkMcpTool> tools;

  @override
  JsonMap toJson() => {'type': 'sdk', 'name': name};

  /// Handles one MCP JSON-RPC request from the CLI.
  Future<JsonMap> handle(JsonMap message) async {
    final id = message['id'];
    final method = message['method'];
    if (method is! String) {
      return _error(id, -32600, 'Invalid MCP request');
    }
    try {
      switch (method) {
        case 'initialize':
          return {
            'jsonrpc': '2.0',
            'id': id,
            'result': {
              'protocolVersion': '2024-11-05',
              'capabilities': {'tools': <String, Object?>{}},
              'serverInfo': {'name': name, 'version': version},
            },
          };
        case 'notifications/initialized':
          return {'jsonrpc': '2.0', 'result': <String, Object?>{}};
        case 'tools/list':
          return {
            'jsonrpc': '2.0',
            'id': id,
            'result': {
              'tools': tools
                  .map(
                    (tool) => <String, Object?>{
                      'name': tool.name,
                      'description': tool.description,
                      'inputSchema': tool.inputSchema,
                      if (tool.annotations != null)
                        'annotations': tool.annotations!._toJson(),
                      if (tool.annotations?.maxResultSizeChars != null)
                        '_meta': {
                          'anthropic/maxResultSizeChars':
                              tool.annotations!.maxResultSizeChars,
                        },
                    },
                  )
                  .toList(growable: false),
            },
          };
        case 'tools/call':
          final params = asJsonMap(message['params'], 'MCP tools/call params');
          final toolName = requiredString(params, 'name', 'MCP tools/call');
          final arguments = params['arguments'] == null
              ? <String, Object?>{}
              : asJsonMap(params['arguments'], 'MCP tools/call arguments');
          final tool = tools.where((item) => item.name == toolName).firstOrNull;
          if (tool == null) {
            return _error(id, -32602, "Tool '$toolName' not found");
          }
          final result = await tool.handler(arguments);
          return {'jsonrpc': '2.0', 'id': id, 'result': result._toJson()};
        default:
          return _error(id, -32601, "Method '$method' not found");
      }
    } catch (error) {
      return _error(id, -32603, error.toString());
    }
  }

  JsonMap _error(Object? id, int code, String message) => {
    'jsonrpc': '2.0',
    'id': id,
    'error': {'code': code, 'message': message},
  };
}

/// Either an inline set of MCP servers or a CLI-readable config value.
sealed class McpConfiguration {
  const McpConfiguration();
}

/// Inline named MCP server configurations.
final class McpServers extends McpConfiguration {
  /// Creates an inline server set.
  McpServers(Map<String, McpServerConfig> servers)
    : servers = Map<String, McpServerConfig>.unmodifiable(servers) {
    if (servers.keys.any((name) => name.isEmpty)) {
      throw ArgumentError.value(servers, 'servers', 'names must not be empty');
    }
  }

  /// Servers keyed by the name visible to the CLI.
  final Map<String, McpServerConfig> servers;
}

/// A path or JSON value accepted by the CLI's MCP config flag.
final class McpConfigSource extends McpConfiguration {
  /// Creates a config source.
  const McpConfigSource(this.value);

  /// File path or JSON string passed verbatim.
  final String value;
}

/// Live connection status of an MCP server.
enum McpConnectionStatus {
  /// The server is usable.
  connected('connected'),

  /// Connection failed.
  failed('failed'),

  /// Authentication is required.
  needsAuth('needs-auth'),

  /// Connection is still starting.
  pending('pending'),

  /// The server is disabled.
  disabled('disabled');

  const McpConnectionStatus(this.wireValue);

  /// CLI status value.
  final String wireValue;

  static McpConnectionStatus _fromWire(String value) => values.firstWhere(
    (status) => status.wireValue == value,
    orElse: () => throw FormatException('Unknown MCP status: $value'),
  );
}

/// Information returned by an MCP initialize handshake.
final class McpServerInfo {
  /// Creates server information.
  const McpServerInfo({required this.name, required this.version});

  /// Reported server name.
  final String name;

  /// Reported server version.
  final String version;
}

/// Tool advertised by a connected MCP server.
final class McpToolInfo {
  /// Creates tool information.
  const McpToolInfo({required this.name, this.description, this.annotations});

  /// Tool name.
  final String name;

  /// Tool description.
  final String? description;

  /// Raw status annotations.
  final JsonMap? annotations;
}

/// Live status for one configured MCP server.
final class McpServerStatus {
  /// Creates server status.
  McpServerStatus({
    required this.name,
    required this.status,
    this.serverInfo,
    this.error,
    JsonMap? config,
    this.scope,
    List<McpToolInfo> tools = const [],
  }) : config = config == null ? null : immutableJsonMap(config),
       tools = List<McpToolInfo>.unmodifiable(tools);

  /// Configured server name.
  final String name;

  /// Current connection state.
  final McpConnectionStatus status;

  /// Handshake information, when connected.
  final McpServerInfo? serverInfo;

  /// Connection error, when failed.
  final String? error;

  /// Serializable effective config.
  final JsonMap? config;

  /// Configuration scope.
  final String? scope;

  /// Tools currently advertised by the server.
  final List<McpToolInfo> tools;

  /// Decodes one server status.
  factory McpServerStatus.fromJson(JsonMap json) {
    final rawInfo = optionalMap(json, 'serverInfo', 'MCP server status');
    final rawTools = json['tools'];
    return McpServerStatus(
      name: requiredString(json, 'name', 'MCP server status'),
      status: McpConnectionStatus._fromWire(
        requiredString(json, 'status', 'MCP server status'),
      ),
      serverInfo: rawInfo == null
          ? null
          : McpServerInfo(
              name: requiredString(rawInfo, 'name', 'MCP server info'),
              version: requiredString(rawInfo, 'version', 'MCP server info'),
            ),
      error: optionalString(json, 'error', 'MCP server status'),
      config: optionalMap(json, 'config', 'MCP server status'),
      scope: optionalString(json, 'scope', 'MCP server status'),
      tools: rawTools is List<Object?>
          ? rawTools
                .map((value) {
                  final tool = asJsonMap(value, 'MCP tool info');
                  return McpToolInfo(
                    name: requiredString(tool, 'name', 'MCP tool info'),
                    description: optionalString(
                      tool,
                      'description',
                      'MCP tool info',
                    ),
                    annotations: optionalMap(
                      tool,
                      'annotations',
                      'MCP tool info',
                    ),
                  );
                })
                .toList(growable: false)
          : const [],
    );
  }
}

/// Status response for all configured MCP servers.
final class McpStatus {
  /// Creates an MCP status response.
  McpStatus(List<McpServerStatus> servers)
    : servers = List<McpServerStatus>.unmodifiable(servers);

  /// Server statuses.
  final List<McpServerStatus> servers;

  /// Decodes a CLI MCP status response.
  factory McpStatus.fromJson(JsonMap json) {
    final values = json['mcpServers'];
    if (values is! List<Object?>) {
      throw const FormatException('MCP status requires mcpServers');
    }
    return McpStatus(
      values
          .map(
            (value) =>
                McpServerStatus.fromJson(asJsonMap(value, 'MCP server status')),
          )
          .toList(growable: false),
    );
  }
}

/// Result of replacing dynamically managed MCP servers.
final class McpSetServersResult {
  /// Decodes a dynamic MCP update.
  McpSetServersResult.fromJson(JsonMap json)
    : added = _stringValues(json['added'], 'MCP servers added'),
      removed = _stringValues(json['removed'], 'MCP servers removed'),
      errors = _stringMap(json['errors'], 'MCP server errors'),
      raw = immutableJsonMap(json);

  /// Newly added server names.
  final List<String> added;

  /// Removed server names.
  final List<String> removed;

  /// Connection errors keyed by server name.
  final Map<String, String> errors;

  /// Complete forward-compatible response.
  final JsonMap raw;
}

List<String> _stringValues(Object? value, String context) {
  if (value == null) return const <String>[];
  if (value is! List<Object?> || value.any((item) => item is! String)) {
    throw FormatException('$context must contain strings');
  }
  return List<String>.unmodifiable(value.cast<String>());
}

Map<String, String> _stringMap(Object? value, String context) {
  if (value == null) return const <String, String>{};
  final json = asJsonMap(value, context);
  if (json.values.any((item) => item is! String)) {
    throw FormatException('$context must contain string values');
  }
  return Map<String, String>.unmodifiable(
    json.map((key, value) => MapEntry(key, value! as String)),
  );
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
