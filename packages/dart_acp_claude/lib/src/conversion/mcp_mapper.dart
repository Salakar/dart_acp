import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_sdk/dart_acp_sdk.dart';

/// Converts ACP MCP server definitions into Claude SDK configurations.
final class ClaudeMcpMapper {
  /// Creates an MCP mapper.
  const ClaudeMcpMapper();

  /// Converts [servers] to an inline named server set.
  claude.McpConfiguration? map(Iterable<McpServer> servers) {
    final result = <String, claude.McpServerConfig>{};
    for (final server in servers) {
      switch (server) {
        case McpServerStdioVariant(:final value):
          result[value.name] = claude.McpStdioServerConfig(
            command: value.command,
            arguments: value.args,
            environment: <String, String>{
              for (final entry in value.env)
                entry.toJson()['name']! as String:
                    entry.toJson()['value']! as String,
            },
          );
        case McpServerMcpServerHttp(:final value):
          result[value.name] = claude.McpHttpServerConfig(
            url: value.url,
            headers: _headers(value.headers),
          );
        case McpServerMcpServerSse(:final value):
          result[value.name] = claude.McpSseServerConfig(
            url: value.url,
            headers: _headers(value.headers),
          );
      }
    }
    return result.isEmpty ? null : claude.McpServers(result);
  }

  Map<String, String> _headers(
    Iterable<HttpHeader> headers,
  ) => <String, String>{
    for (final header in headers)
      header.toJson()['name']! as String: header.toJson()['value']! as String,
  };
}
