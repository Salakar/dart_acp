part of 'application.dart';

/// One typed entry in a heterogeneous draft-v2 batch.
sealed class AcpV2BatchEntry<T> {
  const AcpV2BatchEntry(this.method);

  /// Descriptor governing this call.
  final AcpMethodDescriptorBase method;

  /// Wire message kind.
  AcpMethodKind get kind;

  JsonRpcBatchEntry _wireEntry();
}

/// A typed request entry.
final class AcpV2BatchRequest<P, R> extends AcpV2BatchEntry<R> {
  /// Creates a request entry.
  const AcpV2BatchRequest(
    this.descriptor,
    this.params, {
    this.cancellationToken,
  }) : super(descriptor);

  /// Typed descriptor.
  final AcpMethodDescriptor<P, R> descriptor;

  /// Typed params.
  final P params;

  /// Optional cancellation.
  final CancellationToken? cancellationToken;

  @override
  AcpMethodKind get kind => AcpMethodKind.request;

  @override
  JsonRpcBatchEntry _wireEntry() => JsonRpcBatchRequest<Object?>(
    method: descriptor.name,
    params: JsonRpcParams.value(descriptor.paramsCodec.encode(params)),
    decode: descriptor.resultCodec.decode,
    cancellationToken: cancellationToken,
  );
}

/// A notification entry whose output slot is `void`.
final class AcpV2BatchNotification<P> extends AcpV2BatchEntry<void> {
  /// Creates a notification entry.
  const AcpV2BatchNotification(this.descriptor, this.params)
    : super(descriptor);

  /// Typed descriptor.
  final AcpMethodDescriptor<P, AcpNoResult> descriptor;

  /// Typed params.
  final P params;

  @override
  AcpMethodKind get kind => AcpMethodKind.notification;

  @override
  JsonRpcBatchEntry _wireEntry() => JsonRpcBatchNotification(
    method: descriptor.name,
    params: JsonRpcParams.value(descriptor.paramsCodec.encode(params)),
  );
}

/// Creates batch request entries directly from generated descriptors.
extension AcpV2RequestBatchEntry<P, R> on AcpMethodDescriptor<P, R> {
  /// Binds [params] to this request descriptor.
  AcpV2BatchRequest<P, R> call(
    P params, {
    CancellationToken? cancellationToken,
  }) => AcpV2BatchRequest<P, R>(
    this,
    params,
    cancellationToken: cancellationToken,
  );
}

/// Creates batch notification entries directly from generated descriptors.
extension AcpV2NotificationBatchEntry<P>
    on AcpMethodDescriptor<P, AcpNoResult> {
  /// Binds [params] to this notification descriptor.
  AcpV2BatchNotification<P> notify(P params) =>
      AcpV2BatchNotification<P>(this, params);
}

/// A non-empty advanced-form heterogeneous batch.
final class AcpV2Batch {
  /// Creates a validated non-empty batch.
  AcpV2Batch(Iterable<AcpV2BatchEntry<Object?>> entries)
    : entries = List<AcpV2BatchEntry<Object?>>.unmodifiable(entries) {
    if (this.entries.isEmpty) {
      throw ArgumentError.value(entries, 'entries', 'must not be empty');
    }
  }

  /// Type-erased entries; each request still owns its result decoder.
  final List<AcpV2BatchEntry<Object?>> entries;
}

/// Practical two-entry typed record helper.
extension AcpV2BatchRecord2<A, B> on (AcpV2BatchEntry<A>, AcpV2BatchEntry<B>) {
  /// Sends the pair in one frame and preserves output slot types.
  Future<(A, B)> sendWith(AcpV2CallContext context) async {
    final List<Object?> values = await context._sendBatchEntries(
      <AcpV2BatchEntry<Object?>>[$1, $2],
    );
    return (values[0] as A, values[1] as B);
  }
}

/// Practical three-entry typed record helper.
extension AcpV2BatchRecord3<A, B, C>
    on (AcpV2BatchEntry<A>, AcpV2BatchEntry<B>, AcpV2BatchEntry<C>) {
  /// Sends the record in one frame and preserves output slot types.
  Future<(A, B, C)> sendWith(AcpV2CallContext context) async {
    final List<Object?> values = await context._sendBatchEntries(
      <AcpV2BatchEntry<Object?>>[$1, $2, $3],
    );
    return (values[0] as A, values[1] as B, values[2] as C);
  }
}
