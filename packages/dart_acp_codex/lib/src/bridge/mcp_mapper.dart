import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../runtime/diagnostics.dart';

/// Converts ACP MCP server declarations to Codex configuration entries.
final class CodexMcpMapper {
  /// Creates a mapper.
  const CodexMcpMapper();

  /// Returns a Codex `mcp_servers` configuration object.
  Map<String, Object?> map(Iterable<McpServer> servers) {
    final result = <String, Object?>{};
    for (final server in servers) {
      final json = server.toJson();
      if (json is! Map<Object?, Object?>) {
        throw const CodexProtocolException(
          'ACP MCP server must encode as an object.',
        );
      }
      final name = json['name'];
      if (name is! String || name.isEmpty) {
        throw const CodexProtocolException(
          'ACP MCP server name must not be empty.',
        );
      }
      switch (json['type']) {
        case 'http':
          result[name] = <String, Object?>{
            'url': json['url'],
            'http_headers': _namedValues(json['headers'], 'name', 'value'),
          };
        case 'sse':
          throw const CodexConfigurationException(
            'Codex app-server does not support ACP SSE MCP declarations.',
          );
        default:
          result[name] = <String, Object?>{
            'command': json['command'],
            'args': json['args'] ?? <Object?>[],
            'env': _namedValues(json['env'], 'name', 'value'),
          };
      }
    }
    return result;
  }

  Map<String, Object?> _namedValues(
    Object? value,
    String nameKey,
    String valueKey,
  ) {
    if (value == null) {
      return <String, Object?>{};
    }
    if (value is! List<Object?>) {
      throw const CodexProtocolException(
        'ACP MCP headers and environment must be arrays.',
      );
    }
    final result = <String, Object?>{};
    for (final entry in value) {
      if (entry is! Map<Object?, Object?> ||
          entry[nameKey] is! String ||
          entry[valueKey] is! String) {
        throw const CodexProtocolException(
          'ACP MCP header or environment entry is invalid.',
        );
      }
      result[entry[nameKey]! as String] = entry[valueKey];
    }
    return result;
  }
}
