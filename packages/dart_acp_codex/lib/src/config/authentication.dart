import 'dart:collection';

/// Authentication selected for the local service.
sealed class CodexAuthentication {
  const CodexAuthentication();
}

/// API-key authentication.
final class CodexApiKeyAuthentication extends CodexAuthentication {
  /// Creates API-key authentication.
  const CodexApiKeyAuthentication(this.apiKey);

  /// Secret API key.
  final String apiKey;

  @override
  String toString() => 'CodexApiKeyAuthentication(<redacted>)';
}

/// Browser-backed ChatGPT authentication.
final class CodexChatGptAuthentication extends CodexAuthentication {
  /// Creates ChatGPT authentication.
  const CodexChatGptAuthentication();
}

/// OpenAI-compatible gateway authentication.
final class CodexGatewayAuthentication extends CodexAuthentication {
  /// Creates gateway authentication.
  CodexGatewayAuthentication({
    required this.baseUrl,
    required Map<String, String> headers,
    this.providerName,
  }) : headers = UnmodifiableMapView<String, String>(
         Map<String, String>.of(headers),
       );

  /// Gateway base URL.
  final Uri baseUrl;

  /// Secret request headers.
  final Map<String, String> headers;

  /// Optional display name.
  final String? providerName;

  @override
  String toString() =>
      'CodexGatewayAuthentication(baseUrl: $baseUrl, headers: <redacted>)';
}

/// Current authentication state.
sealed class CodexAuthenticationStatus {
  const CodexAuthenticationStatus();
}

/// No usable authentication is configured.
final class CodexUnauthenticated extends CodexAuthenticationStatus {
  /// Creates an unauthenticated status.
  const CodexUnauthenticated();
}

/// API-key authentication is configured.
final class CodexApiKeyAuthenticated extends CodexAuthenticationStatus {
  /// Creates an API-key status.
  const CodexApiKeyAuthenticated();
}

/// A ChatGPT account is authenticated.
final class CodexChatGptAuthenticated extends CodexAuthenticationStatus {
  /// Creates a ChatGPT account status.
  const CodexChatGptAuthenticated({required this.email});

  /// Account email.
  final String email;
}

/// A gateway is configured.
final class CodexGatewayAuthenticated extends CodexAuthenticationStatus {
  /// Creates a gateway status.
  const CodexGatewayAuthenticated({required this.name});

  /// Provider display name.
  final String name;
}
