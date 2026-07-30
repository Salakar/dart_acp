import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:dart_acp_sdk/dart_acp_sdk.dart' as acp;

/// Converts ACP prompt content into Claude user-input blocks.
final class ClaudePromptMapper {
  /// Creates a prompt mapper.
  const ClaudePromptMapper();

  /// Converts [prompt], preserving text, images, links, and embedded context.
  UserInput map(
    Iterable<acp.ContentBlock> prompt, {
    String sessionId = 'default',
  }) {
    final blocks = <Object?>[];
    for (final block in prompt) {
      final mapped = _mapBlock(block);
      if (mapped != null) blocks.add(mapped);
    }
    if (blocks.isEmpty) {
      throw const FormatException('Prompt contains no supported content');
    }
    return UserInput(content: blocks, sessionId: sessionId);
  }

  Map<String, Object?>? _mapBlock(acp.ContentBlock block) {
    final json = block.toJson();
    return switch (block) {
      acp.ContentBlockText() => <String, Object?>{
        'type': 'text',
        'text': _rewriteCommand(json['text'] as String),
      },
      acp.ContentBlockImage() => _image(json),
      acp.ContentBlockAudio() => null,
      acp.ContentBlockResourceLink() => <String, Object?>{
        'type': 'text',
        'text': _resourceLink(json),
      },
      acp.ContentBlockResource() => _embedded(json),
    };
  }

  Map<String, Object?> _image(Map<String, Object?> json) {
    final mimeType = json['mimeType'];
    final data = json['data'];
    if (mimeType is String &&
        mimeType.startsWith('image/') &&
        data is String &&
        data.isNotEmpty) {
      return <String, Object?>{
        'type': 'image',
        'source': <String, Object?>{
          'type': 'base64',
          'media_type': mimeType,
          'data': data,
        },
      };
    }
    final uri = json['uri'];
    if (uri is String &&
        (uri.startsWith('http://') || uri.startsWith('https://'))) {
      return <String, Object?>{
        'type': 'image',
        'source': <String, Object?>{'type': 'url', 'url': uri},
      };
    }
    throw const FormatException(
      'ACP image must contain base64 data or an HTTP URL',
    );
  }

  Map<String, Object?> _embedded(Map<String, Object?> json) {
    final resource = json['resource'];
    if (resource is! Map<Object?, Object?>) {
      throw const FormatException('Embedded context is missing its resource');
    }
    final uri = resource['uri'];
    if (uri is! String || uri.isEmpty) {
      throw const FormatException('Embedded context is missing its URI');
    }
    final text = resource['text'];
    if (text is String) {
      return <String, Object?>{
        'type': 'text',
        'text': '<context ref="$uri">\n$text\n</context>',
      };
    }
    final blob = resource['blob'];
    final mimeType = resource['mimeType'];
    if (blob is String && mimeType is String && mimeType.startsWith('image/')) {
      return <String, Object?>{
        'type': 'image',
        'source': <String, Object?>{
          'type': 'base64',
          'media_type': mimeType,
          'data': blob,
        },
      };
    }
    if (blob is String) {
      return <String, Object?>{
        'type': 'text',
        'text':
            '<context ref="$uri" '
            'mimeType="${mimeType ?? 'application/octet-stream'}" '
            'encoding="base64">\n$blob\n</context>',
      };
    }
    throw const FormatException(
      'Embedded context must contain text or base64 data',
    );
  }

  String _resourceLink(Map<String, Object?> json) {
    final uri = json['uri'] as String;
    final name = json['name'];
    if (name is String && name.isNotEmpty) return '[@$name]($uri)';
    if (uri.startsWith('file://')) {
      final path = uri.substring('file://'.length);
      final slash = path.lastIndexOf('/');
      final fileName = slash < 0 ? path : path.substring(slash + 1);
      return '[@$fileName]($uri)';
    }
    return uri;
  }

  String _rewriteCommand(String text) {
    if (!text.startsWith('/mcp:')) return text;
    final boundary = text.indexOf(RegExp(r'\s'));
    final command = boundary < 0 ? text : text.substring(0, boundary);
    final arguments = boundary < 0 ? '' : text.substring(boundary);
    return '/${command.substring('/mcp:'.length)} (MCP)$arguments';
  }
}
