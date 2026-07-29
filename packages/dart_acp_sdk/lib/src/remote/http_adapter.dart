import '../json_rpc/cancellation.dart';

/// Whether a remote HTTP adapter should use its platform cookie facilities.
enum AcpHttpCookiePolicy {
  /// Include cookies managed by the transport or browser.
  include,

  /// Omit managed cookies.
  omit,
}

/// Immutable, case-insensitive HTTP headers with preserved repeated values.
final class AcpHttpHeaders {
  /// Creates empty headers.
  const AcpHttpHeaders() : _entries = const <String, _HeaderValues>{};

  AcpHttpHeaders._(this._entries);

  /// Creates headers from single-value entries.
  factory AcpHttpHeaders.fromMap(Map<String, String> values) {
    var headers = const AcpHttpHeaders();
    for (final entry in values.entries) {
      headers = headers.withHeader(entry.key, entry.value);
    }
    return headers;
  }

  /// Creates headers from repeated-value entries.
  factory AcpHttpHeaders.fromValues(
    Iterable<MapEntry<String, List<String>>> values,
  ) {
    var headers = const AcpHttpHeaders();
    for (final entry in values) {
      for (final value in entry.value) {
        headers = headers.withAddedHeader(entry.key, value);
      }
    }
    return headers;
  }

  final Map<String, _HeaderValues> _entries;

  /// Whether no headers are present.
  bool get isEmpty => _entries.isEmpty;

  /// Returns all values for [name].
  List<String> values(String name) =>
      _entries[name.toLowerCase()]?.values ?? const <String>[];

  /// Returns the comma-joined value for [name], or `null`.
  String? value(String name) {
    final all = values(name);
    return all.isEmpty ? null : all.join(', ');
  }

  /// Whether [name] is present.
  bool contains(String name) => _entries.containsKey(name.toLowerCase());

  /// Returns a copy with [name] replaced by one [value].
  AcpHttpHeaders withHeader(String name, String value) {
    _validateHeader(name, value);
    final copy = Map<String, _HeaderValues>.of(_entries);
    copy[name.toLowerCase()] = _HeaderValues(name, <String>[value]);
    return AcpHttpHeaders._(Map<String, _HeaderValues>.unmodifiable(copy));
  }

  /// Returns a copy with [value] appended under [name].
  AcpHttpHeaders withAddedHeader(String name, String value) {
    _validateHeader(name, value);
    final key = name.toLowerCase();
    final existing = _entries[key];
    final copy = Map<String, _HeaderValues>.of(_entries);
    copy[key] = _HeaderValues(existing?.name ?? name, <String>[
      ...?existing?.values,
      value,
    ]);
    return AcpHttpHeaders._(Map<String, _HeaderValues>.unmodifiable(copy));
  }

  /// Returns a copy without [name].
  AcpHttpHeaders without(String name) {
    final copy = Map<String, _HeaderValues>.of(_entries)
      ..remove(name.toLowerCase());
    return AcpHttpHeaders._(Map<String, _HeaderValues>.unmodifiable(copy));
  }

  /// Overlays every header in [other], replacing matching names.
  AcpHttpHeaders overlay(AcpHttpHeaders other) {
    final copy = Map<String, _HeaderValues>.of(_entries)
      ..addAll(other._entries);
    return AcpHttpHeaders._(Map<String, _HeaderValues>.unmodifiable(copy));
  }

  /// Calls [visitor] once for every individual header value.
  void forEach(void Function(String name, String value) visitor) {
    for (final entry in _entries.values) {
      for (final value in entry.values) {
        visitor(entry.name, value);
      }
    }
  }

  /// Returns a redacted diagnostic view containing header names only.
  String get redactedSummary {
    final names = _entries.values.map((entry) => entry.name).toList()..sort();
    return 'AcpHttpHeaders(${names.join(', ')})';
  }

  @override
  String toString() => redactedSummary;
}

/// One platform-neutral streaming HTTP request.
final class AcpHttpRequest {
  /// Creates a request.
  const AcpHttpRequest({
    required this.uri,
    required this.method,
    required this.cancellationToken,
    this.headers = const AcpHttpHeaders(),
    this.body,
    this.cookiePolicy = AcpHttpCookiePolicy.include,
  });

  /// Request URI.
  final Uri uri;

  /// Uppercase HTTP method.
  final String method;

  /// Immutable request headers.
  final AcpHttpHeaders headers;

  /// Optional request body bytes.
  final List<int>? body;

  /// Cookie behavior requested from the platform.
  final AcpHttpCookiePolicy cookiePolicy;

  /// Cancels the request and response body.
  final CancellationToken cancellationToken;
}

/// One platform-neutral streaming HTTP response.
final class AcpHttpResponse {
  /// Creates a response.
  const AcpHttpResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
    this.reasonPhrase = '',
  });

  /// HTTP status code.
  final int statusCode;

  /// Safe status description when supplied by the platform.
  final String reasonPhrase;

  /// Immutable response headers, including repeated `Set-Cookie` values.
  final AcpHttpHeaders headers;

  /// Response body chunks. Cancellation must stop platform reads.
  final Stream<List<int>> body;

  /// Whether the response is a 2xx success.
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}

/// Platform boundary used by the experimental HTTP/SSE client.
abstract interface class AcpHttpAdapter {
  /// Sends [request] and resolves when response headers are available.
  Future<AcpHttpResponse> send(AcpHttpRequest request);

  /// Releases adapter-owned resources. Calls are idempotent.
  Future<void> close();
}

void _validateHeader(String name, String value) {
  if (name.isEmpty ||
      RegExp(r'[\x00-\x20\x7f()<>@,;:\\"/\[\]?={}]').hasMatch(name)) {
    throw ArgumentError.value(name, 'name', 'invalid HTTP header name');
  }
  if (value.contains('\r') || value.contains('\n')) {
    throw ArgumentError.value(value, 'value', 'invalid HTTP header value');
  }
}

final class _HeaderValues {
  _HeaderValues(this.name, List<String> values)
    : values = List<String>.unmodifiable(values);

  final String name;
  final List<String> values;
}
