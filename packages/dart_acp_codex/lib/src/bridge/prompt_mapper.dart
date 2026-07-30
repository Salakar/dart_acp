import 'package:dart_acp_sdk/dart_acp_sdk.dart';

import '../runtime/diagnostics.dart';

/// Converts typed ACP prompt content into Codex app-server user input.
final class CodexPromptMapper {
  /// Creates a mapper.
  const CodexPromptMapper();

  /// Maps a prompt, omitting audio because the app server has no audio input.
  List<Map<String, Object?>> map(Iterable<ContentBlock> prompt) {
    return <Map<String, Object?>>[
      for (final block in prompt)
        if (_mapBlock(block) case final Map<String, Object?> input) input,
    ];
  }

  Map<String, Object?>? _mapBlock(ContentBlock block) {
    final json = block.toJson();
    return switch (block) {
      ContentBlockText() => _text(json['text'] as String),
      ContentBlockImage() => <String, Object?>{
        'type': 'image',
        'url': _imageUrl(json),
      },
      ContentBlockAudio() => null,
      ContentBlockResourceLink() => _text(
        _formatLink(json['name'] as String?, json['uri'] as String),
      ),
      ContentBlockResource() => _embeddedResource(json),
    };
  }

  Map<String, Object?> _embeddedResource(Map<String, Object?> block) {
    final resource = block['resource'];
    if (resource is! Map<Object?, Object?>) {
      throw const CodexProtocolException(
        'Embedded ACP resource must contain a resource object.',
      );
    }
    final uri = resource['uri'];
    if (uri is! String || uri.isEmpty) {
      throw const CodexProtocolException(
        'Embedded ACP resource must contain a URI.',
      );
    }
    final mimeType = resource['mimeType'];
    final text = resource['text'];
    if (text is String) {
      return _text(
        '${_formatLink(null, uri)}\n'
        '<context ref="$uri">\n$text\n</context>',
      );
    }
    final blob = resource['blob'];
    if (blob is! String) {
      throw const CodexProtocolException(
        'Embedded ACP resource must contain text or a base64 blob.',
      );
    }
    if (mimeType is String && mimeType.startsWith('image/')) {
      return <String, Object?>{
        'type': 'image',
        'url': 'data:$mimeType;base64,$blob',
      };
    }
    final resolvedMimeType = mimeType is String
        ? mimeType
        : 'application/octet-stream';
    return _text(
      '${_formatLink(null, uri)}\n'
      '<context ref="$uri" mimeType="$resolvedMimeType" encoding="base64">\n'
      '$blob\n'
      '</context>',
    );
  }

  String _imageUrl(Map<String, Object?> block) {
    final uri = block['uri'];
    if (uri is String && _isSupportedImageUri(uri)) {
      return uri;
    }
    final mimeType = block['mimeType'];
    final data = block['data'];
    if (mimeType is! String || data is! String) {
      throw const CodexProtocolException(
        'ACP image must contain a supported URI or base64 data.',
      );
    }
    return 'data:$mimeType;base64,$data';
  }

  bool _isSupportedImageUri(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'data');
  }

  String _formatLink(String? name, String uri) {
    if (name != null && name.isNotEmpty) {
      return '[@$name]($uri)';
    }
    if (uri.startsWith('file://')) {
      final path = uri.substring('file://'.length);
      final separator = path.lastIndexOf('/');
      final fileName = separator < 0 ? path : path.substring(separator + 1);
      return '[@$fileName]($uri)';
    }
    return uri;
  }

  Map<String, Object?> _text(String text) => <String, Object?>{
    'type': 'text',
    'text': text,
    'text_elements': <Object?>[],
  };
}
