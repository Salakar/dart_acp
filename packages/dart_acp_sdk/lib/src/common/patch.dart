/// A protocol field whose omission, explicit `null`, and value are distinct.
sealed class AcpPatch<T> {
  /// Creates a patch value.
  const AcpPatch();

  /// Leaves the existing field unchanged and omits it during serialization.
  const factory AcpPatch.unchanged() = AcpPatchUnchanged<T>;

  /// Clears the field by writing an explicit JSON `null`.
  const factory AcpPatch.clear() = AcpPatchClear<T>;

  /// Replaces the field with [value].
  const factory AcpPatch.set(T value) = AcpPatchSet<T>;

  /// Whether this patch leaves the field unchanged.
  bool get isUnchanged => this is AcpPatchUnchanged<T>;

  /// Whether this patch explicitly clears the field.
  bool get isClear => this is AcpPatchClear<T>;

  /// Whether this patch contains a replacement value.
  bool get isSet => this is AcpPatchSet<T>;

  /// Returns the set value, or `null` when this patch is not [AcpPatchSet].
  T? get valueOrNull => switch (this) {
    AcpPatchSet<T>(:final value) => value,
    AcpPatchUnchanged<T>() || AcpPatchClear<T>() => null,
  };

  /// Applies this patch to [current].
  T? applyTo(T? current) => switch (this) {
    AcpPatchUnchanged<T>() => current,
    AcpPatchClear<T>() => null,
    AcpPatchSet<T>(:final value) => value,
  };

  /// Transforms a set value while preserving unchanged and clear states.
  AcpPatch<R> map<R>(R Function(T value) transform) => switch (this) {
    AcpPatchUnchanged<T>() => AcpPatch<R>.unchanged(),
    AcpPatchClear<T>() => AcpPatch<R>.clear(),
    AcpPatchSet<T>(:final value) => AcpPatch<R>.set(transform(value)),
  };

  /// Writes this patch to [target] using [encode].
  ///
  /// Unchanged patches do not add a key, clear patches write `null`, and set
  /// patches write the encoded replacement value.
  void writeTo(
    Map<String, Object?> target,
    String key,
    Object? Function(T value) encode,
  ) {
    switch (this) {
      case AcpPatchUnchanged<T>():
        return;
      case AcpPatchClear<T>():
        target[key] = null;
      case AcpPatchSet<T>(:final value):
        target[key] = encode(value);
    }
  }
}

/// A patch that omits the field and leaves stored state unchanged.
final class AcpPatchUnchanged<T> extends AcpPatch<T> {
  /// Creates an unchanged patch.
  const AcpPatchUnchanged();

  @override
  bool operator ==(Object other) => other is AcpPatchUnchanged<T>;

  @override
  int get hashCode => Object.hash(AcpPatchUnchanged, T);

  @override
  String toString() => 'AcpPatch<$T>.unchanged()';
}

/// A patch that explicitly clears a nullable field.
final class AcpPatchClear<T> extends AcpPatch<T> {
  /// Creates a clear patch.
  const AcpPatchClear();

  @override
  bool operator ==(Object other) => other is AcpPatchClear<T>;

  @override
  int get hashCode => Object.hash(AcpPatchClear, T);

  @override
  String toString() => 'AcpPatch<$T>.clear()';
}

/// A patch that replaces a field with [value].
final class AcpPatchSet<T> extends AcpPatch<T> {
  /// Creates a set patch.
  const AcpPatchSet(this.value);

  /// The replacement value.
  final T value;

  @override
  bool operator ==(Object other) =>
      other is AcpPatchSet<T> && other.value == value;

  @override
  int get hashCode => Object.hash(AcpPatchSet, value);

  @override
  String toString() => 'AcpPatch<$T>.set($value)';
}

/// A value whose presence is distinct from its value.
sealed class AcpOptional<T> {
  /// Creates an optional value.
  const AcpOptional();

  /// Creates an absent optional value.
  const factory AcpOptional.absent() = AcpAbsent<T>;

  /// Creates a present optional value.
  const factory AcpOptional.present(T value) = AcpPresent<T>;

  /// Whether a value is present.
  bool get isPresent => this is AcpPresent<T>;

  /// Returns the present value, or `null` when absent.
  T? get valueOrNull => switch (this) {
    AcpPresent<T>(:final value) => value,
    AcpAbsent<T>() => null,
  };
}

/// An absent optional value.
final class AcpAbsent<T> extends AcpOptional<T> {
  /// Creates an absent optional value.
  const AcpAbsent();

  @override
  bool operator ==(Object other) => other is AcpAbsent<T>;

  @override
  int get hashCode => Object.hash(AcpAbsent, T);

  @override
  String toString() => 'AcpOptional<$T>.absent()';
}

/// A present optional [value].
final class AcpPresent<T> extends AcpOptional<T> {
  /// Creates a present optional value.
  const AcpPresent(this.value);

  /// The present value.
  final T value;

  @override
  bool operator ==(Object other) =>
      other is AcpPresent<T> && other.value == value;

  @override
  int get hashCode => Object.hash(AcpPresent, value);

  @override
  String toString() => 'AcpOptional<$T>.present($value)';
}
