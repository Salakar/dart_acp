import 'dart:collection';

import '../runtime/diagnostics.dart';

/// Supported gateway wire protocol.
enum CodexGatewayProtocol {
  /// OpenAI Responses-compatible API.
  openai('openai', 'responses');

  const CodexGatewayProtocol(this.id, this.wireApi);

  /// ACP protocol id.
  final String id;

  /// App-server wire API id.
  final String wireApi;
}

/// Configuration for an OpenAI-compatible model gateway.
final class CodexGatewayConfiguration {
  /// Creates and validates gateway configuration.
  CodexGatewayConfiguration({
    required this.baseUrl,
    required Map<String, String> headers,
    this.providerName = 'Custom model gateway',
    this.protocol = CodexGatewayProtocol.openai,
  }) : headers = UnmodifiableMapView<String, String>(
         Map<String, String>.of(headers),
       ) {
    if (!baseUrl.hasScheme ||
        (baseUrl.scheme != 'http' && baseUrl.scheme != 'https') ||
        baseUrl.host.isEmpty) {
      throw const CodexConfigurationException(
        'Gateway base URL must be an absolute HTTP(S) URL.',
      );
    }
    if (providerName.trim().isEmpty) {
      throw const CodexConfigurationException(
        'Gateway provider name must not be empty.',
      );
    }
  }

  /// Gateway base URL.
  final Uri baseUrl;

  /// Secret headers sent to the gateway.
  final Map<String, String> headers;

  /// Human-readable provider name.
  final String providerName;

  /// Wire protocol.
  final CodexGatewayProtocol protocol;

  @override
  String toString() =>
      'CodexGatewayConfiguration(baseUrl: $baseUrl, '
      'providerName: $providerName, headers: <redacted>)';
}
