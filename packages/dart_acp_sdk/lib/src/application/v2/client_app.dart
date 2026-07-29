part of 'application.dart';

/// Immutable client-side application for the draft ACP v2 baseline.
final class AcpV2ClientApp {
  /// Creates a client with automatic version-2 initialization.
  AcpV2ClientApp({
    required this.implementation,
    required this.capabilities,
    String? name,
    this.options = const AcpV2ApplicationOptions(),
    Iterable<AcpMethodDescriptorBase> protocolDescriptors =
        v2_methods.v2StableMethodDescriptors,
  }) : name = name ?? implementation.name,
       _protocolDescriptors = List<AcpMethodDescriptorBase>.unmodifiable(
         protocolDescriptors,
       ),
       _bindings = const <_AcpV2ClientBinding>[],
       _connectHandlers = const <AcpV2ClientConnectHandler>[];

  const AcpV2ClientApp._({
    required this.implementation,
    required this.capabilities,
    required this.name,
    required this.options,
    required List<AcpMethodDescriptorBase> protocolDescriptors,
    required List<_AcpV2ClientBinding> bindings,
    required List<AcpV2ClientConnectHandler> connectHandlers,
  }) : _protocolDescriptors = protocolDescriptors,
       _bindings = bindings,
       _connectHandlers = connectHandlers;

  /// Client implementation details.
  final v2.Implementation implementation;

  /// Client capabilities.
  final v2.ClientCapabilities capabilities;

  /// Diagnostic name.
  final String name;

  /// Runtime options.
  final AcpV2ApplicationOptions options;

  final List<AcpMethodDescriptorBase> _protocolDescriptors;
  final List<_AcpV2ClientBinding> _bindings;
  final List<AcpV2ClientConnectHandler> _connectHandlers;

  /// Registers a typed request handler.
  AcpV2ClientApp onRequest<P, R>(
    AcpMethodDescriptor<P, R> method,
    AcpV2ClientRequestHandler<P, R> handler,
  ) {
    _validateV2Registration(
      method,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      options: options,
    );
    _validateV2NoDuplicate(_bindings, method);
    return _copy(
      bindings: <_AcpV2ClientBinding>[
        ..._bindings,
        _AcpV2ClientRequestBinding<P, R>(method, handler),
      ],
    );
  }

  /// Registers a typed notification handler.
  AcpV2ClientApp onNotification<P>(
    AcpMethodDescriptor<P, AcpNoResult> method,
    AcpV2ClientNotificationHandler<P> handler,
  ) {
    _validateV2Registration(
      method,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.notification,
      options: options,
    );
    _validateV2NoDuplicate(_bindings, method);
    return _copy(
      bindings: <_AcpV2ClientBinding>[
        ..._bindings,
        _AcpV2ClientNotificationBinding<P>(method, handler),
      ],
    );
  }

  /// Adds an exactly-once ready handler.
  AcpV2ClientApp onConnect(AcpV2ClientConnectHandler handler) => _copy(
    connectHandlers: <AcpV2ClientConnectHandler>[..._connectHandlers, handler],
  );

  /// Returns a copy with different options.
  AcpV2ClientApp withOptions(AcpV2ApplicationOptions value) => AcpV2ClientApp._(
    implementation: implementation,
    capabilities: capabilities,
    name: name,
    options: value,
    protocolDescriptors: _protocolDescriptors,
    bindings: _bindings,
    connectHandlers: _connectHandlers,
  );

  /// Adds wire-recognized descriptors.
  AcpV2ClientApp withProtocolDescriptors(
    Iterable<AcpMethodDescriptorBase> descriptors,
  ) => AcpV2ClientApp._(
    implementation: implementation,
    capabilities: capabilities,
    name: name,
    options: options,
    protocolDescriptors: List<AcpMethodDescriptorBase>.unmodifiable(
      <AcpMethodDescriptorBase>[..._protocolDescriptors, ...descriptors],
    ),
    bindings: _bindings,
    connectHandlers: _connectHandlers,
  );

  /// Connects this client and begins initialization.
  AcpV2ClientConnection connect(
    AcpDuplexStream<Object?> stream, {
    AcpV2ConnectOptions connectOptions = const AcpV2ConnectOptions(),
  }) {
    late AcpV2ConnectionLifecycle lifecycle;
    late AcpV2ClientContext context;
    final sessionRouter = _AcpV2SessionRouter();
    final handlers = <JsonRpcHandler>[
      _v2InitializationGuard(() => lifecycle),
      sessionRouter.handle,
      for (final _AcpV2ClientBinding binding in _bindings)
        (IncomingJsonRpcMessage message, JsonRpcHandlerContext raw) =>
            binding.build(context)(message, raw),
    ];
    final raw = JsonRpcConnection(
      stream: _v2AsynchronousInput(stream),
      handlers: handlers,
      options: options.jsonRpcOptions,
      codec: AcpJsonRpcCodec(
        protocolMethods: _v2ProtocolNames(_protocolDescriptors, _bindings),
      ),
    );
    lifecycle = AcpV2ConnectionLifecycle._(
      raw,
      requireInitialization: options.requireInitialization,
    );
    context = AcpV2ClientContext._(
      rawConnection: raw,
      lifecycle: lifecycle,
      options: options,
      router: sessionRouter,
    );
    final connection = AcpV2ClientConnection._(raw, lifecycle, context);
    connection._startHandlers = () {
      unawaited(
        lifecycle.ready.then<void>(
          (_) => _runV2ConnectHandlers(connection, _connectHandlers),
          onError: (Object error, StackTrace _) => connection.close(error),
        ),
      );
    };
    if (!connectOptions.deferConnectHandlers) {
      connection.startConnectHandlers();
    }
    if (options.requireInitialization) {
      unawaited(_initialize(context, lifecycle).catchError(connection.close));
    }
    return connection;
  }

  Future<void> _initialize(
    AcpV2ClientContext context,
    AcpV2ConnectionLifecycle lifecycle,
  ) async {
    final response = await context._request(
      v2_methods.initializeMethod,
      v2.InitializeRequest(
        protocolVersion: v2.ProtocolVersion(2),
        info: implementation,
        capabilities: capabilities,
      ),
      duringInitialization: true,
      enforceCapability: false,
    );
    _requireV2(response.protocolVersion);
    lifecycle._markReady(
      peerCapabilities: _v2AgentCapabilities(response),
      peerImplementation: response.info.toAcpJson(),
      peerAuthMethods: response.authMethods,
    );
  }

  /// Connects directly to [agent].
  Future<AcpV2DirectConnectionPair> connectWith(
    AcpV2AgentApp agent, {
    int maximumBufferedMessages = 1024,
  }) => acpV2ConnectApps(
    agent: agent,
    client: this,
    maximumBufferedMessages: maximumBufferedMessages,
  );

  AcpV2ClientApp _copy({
    List<_AcpV2ClientBinding>? bindings,
    List<AcpV2ClientConnectHandler>? connectHandlers,
  }) => AcpV2ClientApp._(
    implementation: implementation,
    capabilities: capabilities,
    name: name,
    options: options,
    protocolDescriptors: _protocolDescriptors,
    bindings: List<_AcpV2ClientBinding>.unmodifiable(bindings ?? _bindings),
    connectHandlers: List<AcpV2ClientConnectHandler>.unmodifiable(
      connectHandlers ?? _connectHandlers,
    ),
  );
}

/// Opens a bounded direct v2 app pair and waits for initialization.
Future<AcpV2DirectConnectionPair> acpV2ConnectApps({
  required AcpV2AgentApp agent,
  required AcpV2ClientApp client,
  int maximumBufferedMessages = 1024,
}) async {
  final transports = acpInProcessTransportPair<Object?>(
    maximumBufferedMessages: maximumBufferedMessages,
  );
  final agentConnection = agent.connect(transports.left);
  final clientConnection = client.connect(transports.right);
  final pair = AcpV2DirectConnectionPair._(
    agentConnection,
    clientConnection,
    transports.left,
    transports.right,
  );
  unawaited(agentConnection.closed.whenComplete(clientConnection.close));
  unawaited(clientConnection.closed.whenComplete(agentConnection.close));
  try {
    await Future.wait<void>(<Future<void>>[
      agentConnection.lifecycle.ready,
      clientConnection.lifecycle.ready,
    ]);
    return pair;
  } on Object {
    await pair.close();
    rethrow;
  }
}
