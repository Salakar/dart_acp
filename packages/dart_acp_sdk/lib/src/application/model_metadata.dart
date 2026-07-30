part of 'application.dart';

/// One input modality accepted by a selectable model.
///
/// ACP leaves per-option metadata extensible. This value object gives clients
/// and adapters a provider-neutral vocabulary while preserving future
/// modality identifiers that this SDK version does not know yet.
final class AcpModelInputModality {
  /// Creates a modality from its wire identifier.
  const AcpModelInputModality(this.id);

  /// Plain text input.
  static const text = AcpModelInputModality('text');

  /// Image input.
  static const image = AcpModelInputModality('image');

  /// Audio input.
  static const audio = AcpModelInputModality('audio');

  /// Provider-neutral wire identifier.
  final String id;

  @override
  bool operator ==(Object other) =>
      other is AcpModelInputModality && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AcpModelInputModality($id)';
}

/// Builds provider-neutral SDK metadata for a model configuration option.
///
/// The encoded shape deliberately mirrors the provider's generic
/// `inputModalities` inventory rather than translating it into a
/// client/product-specific capability namespace.
AcpJsonObject acpModelOptionMeta({
  required Iterable<AcpModelInputModality> inputModalities,
  AcpJsonObject? additionalMetadata,
}) {
  final modalities = <String>{
    for (final modality in inputModalities)
      if (modality.id.trim().isNotEmpty) modality.id.trim(),
  };
  return AcpJsonObject.fromObject(<String, Object?>{
    ...?additionalMetadata?.toObject(),
    'inputModalities': modalities.toList(growable: false),
  });
}

/// Provider-neutral model information attached to an ACP select option.
extension AcpModelSessionConfigOption on v1.SessionConfigSelectOption {
  /// Input modalities advertised for this model, or `null` when unpublished.
  ///
  /// Unknown string values are retained as [AcpModelInputModality] instances.
  /// An explicit empty array remains a non-null empty set so clients can
  /// distinguish "accepts no input modalities" from "use connection-level
  /// capabilities as the fallback".
  Set<AcpModelInputModality>? get modelInputModalities {
    final raw = meta?.toObject()['inputModalities'];
    if (raw is! List<Object?>) {
      return null;
    }
    return Set<AcpModelInputModality>.unmodifiable(<AcpModelInputModality>{
      for (final value in raw)
        if (value is String && value.trim().isNotEmpty)
          AcpModelInputModality(value.trim()),
    });
  }
}
