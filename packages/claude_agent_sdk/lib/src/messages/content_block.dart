import '../json.dart';

/// One typed block in a user or assistant message.
sealed class ContentBlock {
  const ContentBlock();

  /// Encodes this block at the CLI JSON boundary.
  JsonMap toJson();
}

/// Plain text content.
final class TextBlock extends ContentBlock {
  /// Creates a text block.
  const TextBlock(this.text);

  /// Block text.
  final String text;

  @override
  JsonMap toJson() => {'type': 'text', 'text': text};
}

/// Signed model thinking content.
final class ThinkingBlock extends ContentBlock {
  /// Creates a thinking block.
  const ThinkingBlock({required this.thinking, required this.signature});

  /// Thinking text, possibly empty when omitted by configuration.
  final String thinking;

  /// Provider signature for the thinking block.
  final String signature;

  @override
  JsonMap toJson() => {
    'type': 'thinking',
    'thinking': thinking,
    'signature': signature,
  };
}

/// Image content returned in a message.
final class ImageBlock extends ContentBlock {
  /// Creates an image block from a provider [source].
  ImageBlock({required JsonMap source}) : source = immutableJsonMap(source);

  /// Provider image source (`base64` or URL).
  final JsonMap source;

  /// Source media type, when present.
  String? get mediaType =>
      source['media_type'] as String? ?? source['mediaType'] as String?;

  /// Base64 source data, when present.
  String? get data => source['data'] as String?;

  /// Source URL, when present.
  String? get url => source['url'] as String?;

  @override
  JsonMap toJson() => <String, Object?>{'type': 'image', 'source': source};
}

/// A client-executed tool invocation.
final class ToolUseBlock extends ContentBlock {
  /// Creates a tool-use block.
  ToolUseBlock({required this.id, required this.name, required JsonMap input})
    : input = immutableJsonMap(input);

  /// Invocation identifier.
  final String id;

  /// Tool name.
  final String name;

  /// Tool input.
  final JsonMap input;

  @override
  JsonMap toJson() => {
    'type': 'tool_use',
    'id': id,
    'name': name,
    'input': input,
  };
}

/// Result of a client-executed tool invocation.
final class ToolResultBlock extends ContentBlock {
  /// Creates a tool-result block.
  ToolResultBlock({required this.toolUseId, JsonValue content, this.isError})
    : content = immutableJsonValue(content);

  /// Invocation identifier to which this result belongs.
  final String toolUseId;

  /// Text, structured content blocks, or `null`.
  final JsonValue content;

  /// Whether the tool reported an expected error.
  final bool? isError;

  @override
  JsonMap toJson() => {
    'type': 'tool_result',
    'tool_use_id': toolUseId,
    if (content != null) 'content': content,
    if (isError != null) 'is_error': isError,
  };
}

/// A server-side tool known to current CLI versions.
enum ServerToolName {
  /// Advisor tool.
  advisor('advisor'),

  /// Web search.
  webSearch('web_search'),

  /// Web fetch.
  webFetch('web_fetch'),

  /// General code execution.
  codeExecution('code_execution'),

  /// Bash code execution.
  bashCodeExecution('bash_code_execution'),

  /// Text editor code execution.
  textEditorCodeExecution('text_editor_code_execution'),

  /// Regex tool search.
  toolSearchRegex('tool_search_tool_regex'),

  /// BM25 tool search.
  toolSearchBm25('tool_search_tool_bm25');

  const ServerToolName(this.wireValue);

  /// API discriminator value.
  final String wireValue;

  /// Returns a known value or `null` for a newer server tool.
  static ServerToolName? tryFromWire(String value) {
    for (final candidate in values) {
      if (candidate.wireValue == value) return candidate;
    }
    return null;
  }
}

/// A tool invocation executed by the model provider.
final class ServerToolUseBlock extends ContentBlock {
  /// Creates a server tool-use block.
  ServerToolUseBlock({
    required this.id,
    required this.name,
    required JsonMap input,
  }) : input = immutableJsonMap(input);

  /// Invocation identifier.
  final String id;

  /// Wire tool name.
  final String name;

  /// Typed known tool name, or `null` for a newer value.
  ServerToolName? get knownName => ServerToolName.tryFromWire(name);

  /// Provider-side tool input.
  final JsonMap input;

  @override
  JsonMap toJson() => {
    'type': 'server_tool_use',
    'id': id,
    'name': name,
    'input': input,
  };
}

/// Result of a provider-executed server tool.
final class ServerToolResultBlock extends ContentBlock {
  /// Creates a server tool result.
  ServerToolResultBlock({
    required this.toolUseId,
    required JsonValue content,
    this.type = 'advisor_tool_result',
  }) : content = immutableJsonValue(content);

  /// Invocation identifier.
  final String toolUseId;

  /// Exact block discriminator.
  final String type;

  /// Opaque provider result.
  final JsonValue content;

  @override
  JsonMap toJson() => {
    'type': type,
    'tool_use_id': toolUseId,
    'content': content,
  };
}

/// A block introduced by a newer CLI version.
final class UnknownContentBlock extends ContentBlock {
  /// Preserves an unrecognized content block.
  UnknownContentBlock(JsonMap raw) : raw = immutableJsonMap(raw);

  /// Full unrecognized block.
  final JsonMap raw;

  /// Unrecognized discriminator.
  String? get type => raw['type'] as String?;

  @override
  JsonMap toJson() => raw;
}
