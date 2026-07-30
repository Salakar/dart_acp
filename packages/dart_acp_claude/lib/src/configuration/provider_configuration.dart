import 'dart:collection';

/// Client-managed routing for newly created Claude sessions.
final class ClaudeProviderConfiguration {
  /// Creates and validates a provider configuration.
  ClaudeProviderConfiguration({
    required this.apiType,
    required this.baseUrl,
    Map<String, String> headers = const <String, String>{},
    this.vertexProjectId,
    this.vertexRegion,
  }) : headers = UnmodifiableMapView<String, String>(
         Map<String, String>.of(headers),
       ) {
    if (!const <String>{'anthropic', 'bedrock', 'vertex'}.contains(apiType)) {
      throw const FormatException('Unsupported provider protocol');
    }
    if (!baseUrl.hasScheme ||
        (baseUrl.scheme != 'http' && baseUrl.scheme != 'https') ||
        baseUrl.host.isEmpty) {
      throw const FormatException(
        'Provider base URL must be an absolute HTTP(S) URL',
      );
    }
    if (apiType == 'vertex' &&
        ((vertexProjectId?.trim().isEmpty ?? true) ||
            (vertexRegion?.trim().isEmpty ?? true))) {
      throw const FormatException(
        'Vertex requires a project identifier and region',
      );
    }
  }

  /// Provider protocol.
  final String apiType;

  /// Provider base URL.
  final Uri baseUrl;

  /// Secret request headers.
  final Map<String, String> headers;

  /// Vertex project identifier.
  final String? vertexProjectId;

  /// Vertex region.
  final String? vertexRegion;

  /// Environment additions understood by Claude Code.
  Map<String, String> get environment {
    final customHeaders = headers.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
    return switch (apiType) {
      'bedrock' => <String, String>{
        'CLAUDE_CODE_USE_BEDROCK': '1',
        'AWS_BEARER_TOKEN_BEDROCK': ' ',
        'ANTHROPIC_BEDROCK_BASE_URL': '$baseUrl',
        'ANTHROPIC_CUSTOM_HEADERS': customHeaders,
      },
      'vertex' => <String, String>{
        'CLAUDE_CODE_USE_VERTEX': '1',
        'ANTHROPIC_VERTEX_BASE_URL': '$baseUrl',
        'ANTHROPIC_VERTEX_PROJECT_ID': vertexProjectId!,
        'CLOUD_ML_REGION': vertexRegion!,
        'ANTHROPIC_CUSTOM_HEADERS': customHeaders,
      },
      _ => <String, String>{
        'ANTHROPIC_BASE_URL': '$baseUrl',
        'ANTHROPIC_CUSTOM_HEADERS': customHeaders,
        'ANTHROPIC_AUTH_TOKEN': ' ',
      },
    };
  }

  @override
  String toString() =>
      'ClaudeProviderConfiguration(apiType: $apiType, '
      'baseUrl: $baseUrl, headers: <redacted>)';
}
