/// Supported reasoning effort.
enum CodexReasoningEffort {
  /// No explicit reasoning.
  none('none'),

  /// Minimal reasoning.
  minimal('minimal'),

  /// Low reasoning.
  low('low'),

  /// Medium reasoning.
  medium('medium'),

  /// High reasoning.
  high('high'),

  /// Extra-high reasoning.
  xhigh('xhigh');

  const CodexReasoningEffort(this.id);

  /// Wire id.
  final String id;

  /// Parses a wire id.
  static CodexReasoningEffort? tryParse(String? value) {
    for (final effort in values) {
      if (effort.id == value) {
        return effort;
      }
    }
    return null;
  }
}

/// Input modality supported by a model.
enum CodexInputModality {
  /// Text input.
  text,

  /// Image input.
  image,
}

/// Additional service tier offered by a model.
enum CodexServiceTier {
  /// Faster service with increased usage.
  fast('fast');

  const CodexServiceTier(this.id);

  /// Wire id.
  final String id;
}

/// A model advertised by the local service.
final class CodexModel {
  /// Creates a model descriptor.
  CodexModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isDefault,
    required this.defaultReasoningEffort,
    required Iterable<CodexReasoningEffort> reasoningEfforts,
    required Iterable<CodexInputModality> inputModalities,
    Iterable<CodexServiceTier> serviceTiers = const <CodexServiceTier>[],
    this.contextWindow,
  }) : reasoningEfforts = List<CodexReasoningEffort>.unmodifiable(
         reasoningEfforts,
       ),
       inputModalities = Set<CodexInputModality>.unmodifiable(inputModalities),
       serviceTiers = Set<CodexServiceTier>.unmodifiable(serviceTiers);

  /// Wire model id.
  final String id;

  /// Display name.
  final String name;

  /// Description.
  final String description;

  /// Whether this is the default model.
  final bool isDefault;

  /// Default reasoning effort.
  final CodexReasoningEffort defaultReasoningEffort;

  /// Supported reasoning efforts.
  final List<CodexReasoningEffort> reasoningEfforts;

  /// Supported input modalities.
  final Set<CodexInputModality> inputModalities;

  /// Supported service tiers.
  final Set<CodexServiceTier> serviceTiers;

  /// Context window in tokens.
  final int? contextWindow;

  /// Whether fast mode can be applied.
  bool get supportsFast => serviceTiers.contains(CodexServiceTier.fast);

  /// Selects [requested] when supported, otherwise the model default.
  CodexReasoningEffort resolveEffort(CodexReasoningEffort? requested) {
    if (requested != null && reasoningEfforts.contains(requested)) {
      return requested;
    }
    return defaultReasoningEffort;
  }
}

/// Correlated model and reasoning selection.
final class CodexModelSelection {
  /// Creates a model selection.
  const CodexModelSelection({required this.model, required this.effort});

  /// Model id.
  final String model;

  /// Reasoning effort.
  final CodexReasoningEffort effort;

  /// Stable combined display/configuration id.
  String get combinedId => '$model/${effort.id}';

  /// Parses the last slash-separated component as an effort.
  static CodexModelSelection parse(String value) {
    final separator = value.lastIndexOf('/');
    if (separator <= 0 || separator == value.length - 1) {
      return CodexModelSelection(
        model: value,
        effort: CodexReasoningEffort.medium,
      );
    }
    final effort = CodexReasoningEffort.tryParse(
      value.substring(separator + 1),
    );
    if (effort == null) {
      return CodexModelSelection(
        model: value,
        effort: CodexReasoningEffort.medium,
      );
    }
    return CodexModelSelection(
      model: value.substring(0, separator),
      effort: effort,
    );
  }
}
