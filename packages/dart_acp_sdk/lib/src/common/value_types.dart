/// A nonempty ACP session identifier.
extension type const AcpSessionId._(String value) {
  /// Validates and creates a session identifier.
  factory AcpSessionId(String value) {
    _requireNonempty(value, 'session ID');
    return AcpSessionId._(value);
  }
}

/// A nonempty ACP terminal identifier.
extension type const AcpTerminalId._(String value) {
  /// Validates and creates a terminal identifier.
  factory AcpTerminalId(String value) {
    _requireNonempty(value, 'terminal ID');
    return AcpTerminalId._(value);
  }
}

/// A nonempty ACP tool-call identifier.
extension type const AcpToolCallId._(String value) {
  /// Validates and creates a tool-call identifier.
  factory AcpToolCallId(String value) {
    _requireNonempty(value, 'tool-call ID');
    return AcpToolCallId._(value);
  }
}

/// A nonempty ACP message identifier.
extension type const AcpMessageId._(String value) {
  /// Validates and creates a message identifier.
  factory AcpMessageId(String value) {
    _requireNonempty(value, 'message ID');
    return AcpMessageId._(value);
  }
}

/// A nonempty ACP provider identifier.
extension type const AcpProviderId._(String value) {
  /// Validates and creates a provider identifier.
  factory AcpProviderId(String value) {
    _requireNonempty(value, 'provider ID');
    return AcpProviderId._(value);
  }
}

/// A nonempty ACP plan identifier.
extension type const AcpPlanId._(String value) {
  /// Validates and creates a plan identifier.
  factory AcpPlanId(String value) {
    _requireNonempty(value, 'plan ID');
    return AcpPlanId._(value);
  }
}

/// A nonempty ACP elicitation identifier.
extension type const AcpElicitationId._(String value) {
  /// Validates and creates an elicitation identifier.
  factory AcpElicitationId(String value) {
    _requireNonempty(value, 'elicitation ID');
    return AcpElicitationId._(value);
  }
}

/// An absolute path written in POSIX, Windows drive-root, or UNC form.
extension type const AcpAbsolutePath._(String value) {
  /// Validates and creates an absolute path without host-OS normalization.
  factory AcpAbsolutePath(String value) {
    if (!isValid(value)) {
      throw FormatException('ACP path must be absolute: $value');
    }
    return AcpAbsolutePath._(value);
  }

  /// Whether [value] is an absolute POSIX, drive-root, or UNC path.
  static bool isValid(String value) {
    if (value.startsWith('/')) {
      return true;
    }
    if (value.startsWith(r'\\')) {
      return value.length > 2;
    }
    if (value.length < 3) {
      return false;
    }
    final int first = value.codeUnitAt(0);
    final bool hasAsciiDriveLetter =
        (first >= 65 && first <= 90) || (first >= 97 && first <= 122);
    return hasAsciiDriveLetter &&
        value.codeUnitAt(1) == 58 &&
        (value.codeUnitAt(2) == 47 || value.codeUnitAt(2) == 92);
  }
}

/// An RFC 3339 date-time string that preserves its exact wire spelling.
extension type const AcpDateTimeString._(String value) {
  /// Validates and creates an RFC 3339 date-time string.
  factory AcpDateTimeString(String value) {
    if (!_rfc3339.hasMatch(value) || DateTime.tryParse(value) == null) {
      throw FormatException('Invalid RFC 3339 date-time: $value');
    }
    return AcpDateTimeString._(value);
  }

  static final RegExp _rfc3339 = RegExp(
    r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}'
    r'(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})$',
  );
}

/// An ACP protocol major version in the schema's unsigned 16-bit range.
extension type const AcpProtocolVersion._(int value) {
  /// Validates and creates a protocol version.
  factory AcpProtocolVersion(int value) {
    if (value < 0 || value > 65535) {
      throw RangeError.range(value, 0, 65535, 'protocolVersion');
    }
    return AcpProtocolVersion._(value);
  }
}

/// A signed 64-bit integer represented exactly on every Dart platform.
final class AcpInt64 {
  /// Validates and creates a signed 64-bit integer.
  factory AcpInt64(BigInt value) {
    if (value < minValue || value > maxValue) {
      throw RangeError('Signed 64-bit integer is out of range: $value');
    }
    return AcpInt64._(value);
  }

  const AcpInt64._(this.value);

  /// The exact integer value.
  final BigInt value;

  /// The smallest signed 64-bit integer.
  static final BigInt minValue = BigInt.parse('-9223372036854775808');

  /// The largest signed 64-bit integer.
  static final BigInt maxValue = BigInt.parse('9223372036854775807');

  @override
  bool operator ==(Object other) => other is AcpInt64 && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

/// An unsigned 64-bit integer represented exactly on every Dart platform.
final class AcpUint64 {
  /// Validates and creates an unsigned 64-bit integer.
  factory AcpUint64(BigInt value) {
    if (value.isNegative || value > maxValue) {
      throw RangeError('Unsigned 64-bit integer is out of range: $value');
    }
    return AcpUint64._(value);
  }

  const AcpUint64._(this.value);

  /// The exact integer value.
  final BigInt value;

  /// The largest unsigned 64-bit integer.
  static final BigInt maxValue = BigInt.parse('18446744073709551615');

  @override
  bool operator ==(Object other) => other is AcpUint64 && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

void _requireNonempty(String value, String label) {
  if (value.isEmpty) {
    throw FormatException('ACP $label must not be empty');
  }
}
