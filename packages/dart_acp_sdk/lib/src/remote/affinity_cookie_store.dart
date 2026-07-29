/// Decides whether an explicit server `Domain` attribute may widen cookie
/// scope beyond the response origin.
///
/// Implementations should use a current public-suffix list before allowing
/// parent domains. Throwing rejects the cookie.
typedef AcpAffinityCookieDomainPolicy =
    bool Function(Uri responseUri, String cookieDomain);

/// Minimal URI-scoped storage for server-issued ACP routing-affinity cookies.
///
/// This store is deliberately not an authentication cookie jar. It implements
/// the scope and expiry rules needed to avoid sending routing cookies to an
/// unrelated URI, but it does not expose cookie values, persist them, execute
/// browser cookie policy, or turn cookies into authorization decisions.
final class AcpAffinityCookieStore {
  /// Creates an empty in-memory store.
  ///
  /// [clock] exists for deterministic expiry tests. Applications normally use
  /// the default UTC clock.
  ///
  /// Explicit `Domain` attributes are rejected by default. Supply
  /// [domainPolicy] only when cross-host affinity is required and the policy
  /// can reject public suffixes.
  AcpAffinityCookieStore({
    DateTime Function()? clock,
    AcpAffinityCookieDomainPolicy? domainPolicy,
    this.maximumCookies = 64,
    this.maximumCookieCharacters = 4096,
  }) : _clock = clock ?? _utcNow,
       _domainPolicy = domainPolicy ?? _rejectDomainAttribute {
    if (maximumCookies <= 0) {
      throw ArgumentError.value(
        maximumCookies,
        'maximumCookies',
        'must be positive',
      );
    }
    if (maximumCookieCharacters <= 0) {
      throw ArgumentError.value(
        maximumCookieCharacters,
        'maximumCookieCharacters',
        'must be positive',
      );
    }
  }

  final DateTime Function() _clock;
  final AcpAffinityCookieDomainPolicy _domainPolicy;

  /// Maximum managed cookies retained by this store.
  final int maximumCookies;

  /// Maximum characters accepted in one server cookie header value.
  final int maximumCookieCharacters;
  final Map<_CookieKey, _StoredCookie> _cookies = <_CookieKey, _StoredCookie>{};

  /// The number of currently unexpired cookies.
  int get length {
    _removeExpired();
    return _cookies.length;
  }

  /// Stores one or more `Set-Cookie` header values received from [responseUri].
  ///
  /// Invalid cookies and cookies whose `Domain` does not match [responseUri]
  /// are ignored. A zero or negative `Max-Age`, or an expired `Expires`,
  /// removes an existing cookie with the same name and scope.
  void store(Uri responseUri, Iterable<String> setCookieHeaders) {
    final host = responseUri.host.toLowerCase();
    if (host.isEmpty) {
      return;
    }
    for (final header in setCookieHeaders.expand(splitSetCookieHeader)) {
      if (header.length > maximumCookieCharacters) {
        continue;
      }
      final parsed = _parseSetCookie(responseUri, header);
      if (parsed == null) {
        continue;
      }
      if (!_domainMatches(host, parsed.domain, hostOnly: parsed.hostOnly)) {
        continue;
      }
      final key = _CookieKey(parsed.name, parsed.domain, parsed.path);
      if (parsed.isExpired(_clock().toUtc())) {
        _cookies.remove(key);
      } else {
        if (!_cookies.containsKey(key) && _cookies.length >= maximumCookies) {
          continue;
        }
        _cookies[key] = parsed;
      }
    }
    _removeExpired();
  }

  /// Builds a `Cookie` request header for [requestUri].
  ///
  /// [callerCookieHeader] is merged last, so explicitly supplied caller values
  /// replace managed values with the same cookie name.
  String? cookieHeader(Uri requestUri, {String? callerCookieHeader}) {
    _removeExpired();
    final host = requestUri.host.toLowerCase();
    final path = requestUri.path.isEmpty ? '/' : requestUri.path;
    final isSecure = requestUri.scheme == 'https' || requestUri.scheme == 'wss';
    final matching =
        _cookies.values
            .where(
              (cookie) =>
                  _domainMatches(
                    host,
                    cookie.domain,
                    hostOnly: cookie.hostOnly,
                  ) &&
                  _pathMatches(path, cookie.path) &&
                  (!cookie.secure || isSecure),
            )
            .toList()
          ..sort((left, right) {
            final byPath = right.path.length.compareTo(left.path.length);
            return byPath != 0
                ? byPath
                : left.creationOrder.compareTo(right.creationOrder);
          });

    final merged = <String, String>{};
    for (final cookie in matching) {
      merged.putIfAbsent(cookie.name, () => cookie.value);
    }
    for (final pair in _parseCookieHeader(callerCookieHeader)) {
      merged[pair.$1] = pair.$2;
    }
    if (merged.isEmpty) {
      return null;
    }
    return merged.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('; ');
  }

  /// Removes all managed cookies.
  void clear() => _cookies.clear();

  /// A safe diagnostic summary that never includes cookie names or values.
  String get redactedSummary =>
      'AcpAffinityCookieStore(${length == 1 ? '1 cookie' : '$length cookies'})';

  @override
  String toString() => redactedSummary;

  _StoredCookie? _parseSetCookie(Uri responseUri, String header) {
    final parts = header.split(';');
    final pair = _parseCookiePair(parts.first);
    if (pair == null ||
        !_validCookieName(pair.$1) ||
        !_validCookieValue(pair.$2)) {
      return null;
    }

    var domain = responseUri.host.toLowerCase();
    var hostOnly = true;
    var path = _defaultPath(responseUri.path);
    var secure = false;
    DateTime? expires;
    int? maxAgeSeconds;

    for (final rawAttribute in parts.skip(1)) {
      final attribute = rawAttribute.trim();
      if (attribute.isEmpty) {
        continue;
      }
      final separator = attribute.indexOf('=');
      final name =
          (separator < 0 ? attribute : attribute.substring(0, separator))
              .trim()
              .toLowerCase();
      final value = separator < 0 ? '' : attribute.substring(separator + 1);
      switch (name) {
        case 'domain':
          final candidate = value.trim().toLowerCase().replaceFirst(
            RegExp(r'^\.+'),
            '',
          );
          if (candidate.isEmpty ||
              !_validDomain(candidate) ||
              !_domainMatches(
                responseUri.host.toLowerCase(),
                candidate,
                hostOnly: false,
              )) {
            return null;
          }
          try {
            if (!_domainPolicy(responseUri, candidate)) {
              return null;
            }
          } on Object {
            return null;
          }
          domain = candidate;
          hostOnly = false;
        case 'path':
          if (value.startsWith('/')) {
            path = value;
          }
        case 'secure':
          secure = true;
        case 'expires':
          expires = _parseCookieDate(value);
        case 'max-age':
          final text = value.trim();
          final seconds = int.tryParse(text);
          if (seconds != null) {
            maxAgeSeconds = seconds;
          } else if (RegExp(r'^[+-]?\d+$').hasMatch(text)) {
            return null;
          }
      }
    }

    final now = _clock().toUtc();
    if (secure &&
        responseUri.scheme != 'https' &&
        responseUri.scheme != 'wss') {
      return null;
    }
    if (pair.$1.startsWith('__Secure-') && !secure) {
      return null;
    }
    if (pair.$1.startsWith('__Host-') &&
        (!secure || !hostOnly || path != '/')) {
      return null;
    }
    DateTime? effectiveExpiry = expires;
    if (maxAgeSeconds case final seconds?) {
      if (seconds <= 0) {
        effectiveExpiry = now;
      } else {
        try {
          effectiveExpiry = now.add(Duration(seconds: seconds));
        } on Object {
          return null;
        }
      }
    }
    return _StoredCookie(
      name: pair.$1,
      value: pair.$2,
      domain: domain,
      hostOnly: hostOnly,
      path: path,
      secure: secure,
      expires: effectiveExpiry,
      creationOrder: _StoredCookie.nextCreationOrder(),
    );
  }

  void _removeExpired() {
    final now = _clock().toUtc();
    _cookies.removeWhere((_, cookie) => cookie.isExpired(now));
  }

  /// Splits a potentially combined `Set-Cookie` header without splitting the
  /// comma inside an `Expires` date.
  static Iterable<String> splitSetCookieHeader(String header) sync* {
    var start = 0;
    var inExpires = false;
    for (var index = 0; index < header.length; index += 1) {
      if (!inExpires &&
          index + 8 <= header.length &&
          header.substring(index, index + 8).toLowerCase() == 'expires=') {
        inExpires = true;
        index += 7;
        continue;
      }
      final character = header.codeUnitAt(index);
      if (inExpires && character == 0x3b) {
        inExpires = false;
        continue;
      }
      if (character != 0x2c) {
        continue;
      }
      final remainder = header.substring(index + 1);
      if (inExpires && !RegExp(r'^\s*[^;,\s]+=.*').hasMatch(remainder)) {
        continue;
      }
      if (!RegExp(r'^\s*[^;,\s]+=').hasMatch(remainder)) {
        continue;
      }
      final value = header.substring(start, index).trim();
      if (value.isNotEmpty) {
        yield value;
      }
      start = index + 1;
      inExpires = false;
    }
    final value = header.substring(start).trim();
    if (value.isNotEmpty) {
      yield value;
    }
  }
}

DateTime _utcNow() => DateTime.now().toUtc();

bool _rejectDomainAttribute(Uri _, String _) => false;

bool _domainMatches(String host, String domain, {required bool hostOnly}) {
  if (hostOnly) {
    return host == domain;
  }
  return host == domain || host.endsWith('.$domain');
}

bool _validDomain(String value) {
  if (value.length > 253 ||
      value.endsWith('.') ||
      value.contains(':') ||
      value.contains('[') ||
      value.contains(']')) {
    return false;
  }
  final labels = value.split('.');
  return labels.every(
    (String label) =>
        label.isNotEmpty &&
        label.length <= 63 &&
        !label.startsWith('-') &&
        !label.endsWith('-') &&
        RegExp(r'^[a-z0-9-]+$').hasMatch(label),
  );
}

bool _pathMatches(String requestPath, String cookiePath) {
  if (requestPath == cookiePath) {
    return true;
  }
  if (!requestPath.startsWith(cookiePath)) {
    return false;
  }
  return cookiePath.endsWith('/') ||
      (requestPath.length > cookiePath.length &&
          requestPath.codeUnitAt(cookiePath.length) == 0x2f);
}

String _defaultPath(String requestPath) {
  if (!requestPath.startsWith('/') || requestPath == '/') {
    return '/';
  }
  final lastSlash = requestPath.lastIndexOf('/');
  return lastSlash <= 0 ? '/' : requestPath.substring(0, lastSlash);
}

(String, String)? _parseCookiePair(String value) {
  final separator = value.indexOf('=');
  if (separator <= 0) {
    return null;
  }
  final name = value.substring(0, separator).trim();
  if (name.isEmpty) {
    return null;
  }
  return (name, value.substring(separator + 1).trim());
}

Iterable<(String, String)> _parseCookieHeader(String? header) sync* {
  if (header == null || header.isEmpty) {
    return;
  }
  for (final value in header.split(';')) {
    final pair = _parseCookiePair(value);
    if (pair != null && _validCookieName(pair.$1)) {
      yield pair;
    }
  }
}

bool _validCookieName(String value) =>
    value.isNotEmpty &&
    !RegExp(r'[\x00-\x20\x7f()<>@,;:\\"/\[\]?={}]').hasMatch(value);

bool _validCookieValue(String value) =>
    !RegExp(r'[\x00-\x1f\x7f]').hasMatch(value);

DateTime? _parseCookieDate(String value) {
  final text = value.trim();
  try {
    return DateTime.parse(text).toUtc();
  } on FormatException {
    // HTTP cookies conventionally use IMF-fixdate, which DateTime.parse does
    // not accept (for example, "Wed, 21 Oct 2030 07:28:00 GMT").
    final match = RegExp(
      r'^(?:Mon|Tue|Wed|Thu|Fri|Sat|Sun),\s*'
      r'(\d{1,2})\s+'
      r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+'
      r'(\d{4})\s+'
      r'(\d{2}):(\d{2}):(\d{2})\s+GMT$',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) {
      return null;
    }
    const months = <String, int>{
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    final day = int.parse(match.group(1)!);
    final month = months[match.group(2)!.toLowerCase()]!;
    final year = int.parse(match.group(3)!);
    final hour = int.parse(match.group(4)!);
    final minute = int.parse(match.group(5)!);
    final second = int.parse(match.group(6)!);
    if (day < 1 || day > 31 || hour > 23 || minute > 59 || second > 59) {
      return null;
    }
    final result = DateTime.utc(year, month, day, hour, minute, second);
    if (result.year != year || result.month != month || result.day != day) {
      return null;
    }
    return result;
  }
}

final class _CookieKey {
  const _CookieKey(this.name, this.domain, this.path);

  final String name;
  final String domain;
  final String path;

  @override
  bool operator ==(Object other) =>
      other is _CookieKey &&
      other.name == name &&
      other.domain == domain &&
      other.path == path;

  @override
  int get hashCode => Object.hash(name, domain, path);
}

final class _StoredCookie {
  const _StoredCookie({
    required this.name,
    required this.value,
    required this.domain,
    required this.hostOnly,
    required this.path,
    required this.secure,
    required this.expires,
    required this.creationOrder,
  });

  static int _creationSequence = 0;

  final String name;
  final String value;
  final String domain;
  final bool hostOnly;
  final String path;
  final bool secure;
  final DateTime? expires;
  final int creationOrder;

  bool isExpired(DateTime now) => expires != null && !expires!.isAfter(now);

  static int nextCreationOrder() => _creationSequence += 1;
}
