part of 'application.dart';

/// Immutable client-side ACP v1 application.
final class AcpClientApp {
  /// Creates an empty client application.
  AcpClientApp({
    String? name,
    this.options = const AcpApplicationOptions(),
    AcpClientInitializationConfiguration? initialization,
    v1.Implementation? implementation,
    v1.ClientCapabilities? capabilities,
    Iterable<AcpMethodDescriptorBase> protocolDescriptors =
        v1_methods.v1StableMethodDescriptors,
  }) : name = name ?? implementation?.name ?? 'client',
       initialization = _resolveClientInitialization(
         initialization,
         implementation,
         capabilities,
       ),
       _protocolDescriptors = List<AcpMethodDescriptorBase>.unmodifiable(
         protocolDescriptors,
       ),
       _bindings = const <_AcpClientBinding>[],
       _middleware = const <AcpMiddleware>[],
       _connectHandlers = const <AcpClientConnectHandler>[];

  /// Creates a client with automatic stable-v1 initialization.
  factory AcpClientApp.v1({
    required v1.Implementation implementation,
    required v1.ClientCapabilities capabilities,
    AcpApplicationOptions options = const AcpApplicationOptions(),
  }) => AcpClientApp(
    implementation: implementation,
    capabilities: capabilities,
    options: options,
  );

  const AcpClientApp._({
    required this.name,
    required this.options,
    required this.initialization,
    required List<AcpMethodDescriptorBase> protocolDescriptors,
    required List<_AcpClientBinding> bindings,
    required List<AcpMiddleware> middleware,
    required List<AcpClientConnectHandler> connectHandlers,
  }) : _protocolDescriptors = protocolDescriptors,
       _bindings = bindings,
       _middleware = middleware,
       _connectHandlers = connectHandlers;

  /// Human-readable diagnostic name.
  final String name;

  /// Application behavior options.
  final AcpApplicationOptions options;

  /// Typed request used to initialize an agent connection.
  final AcpClientInitializationConfiguration? initialization;

  final List<AcpMethodDescriptorBase> _protocolDescriptors;
  final List<_AcpClientBinding> _bindings;
  final List<AcpMiddleware> _middleware;
  final List<AcpClientConnectHandler> _connectHandlers;

  /// Registers a typed request handler and returns a new app.
  AcpClientApp onRequest<P, R>(
    AcpMethodDescriptor<P, R> method,
    AcpClientRequestHandler<P, R> handler,
  ) {
    _validateRegistration(
      method,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.request,
      options: options,
    );
    _validateNoDuplicate(_bindings, method);
    return _copy(
      bindings: <_AcpClientBinding>[
        ..._bindings,
        _AcpClientRequestBinding<P, R>(method, handler),
      ],
    );
  }

  /// Registers a typed notification handler and returns a new app.
  AcpClientApp onNotification<P>(
    AcpMethodDescriptor<P, AcpNoResult> method,
    AcpClientNotificationHandler<P> handler,
  ) {
    _validateRegistration(
      method,
      direction: AcpMethodDirection.agentToClient,
      kind: AcpMethodKind.notification,
      options: options,
    );
    _validateNoDuplicate(_bindings, method);
    return _copy(
      bindings: <_AcpClientBinding>[
        ..._bindings,
        _AcpClientNotificationBinding<P>(method, handler),
      ],
    );
  }

  /// Adds ordered raw middleware and returns a new app.
  AcpClientApp onMessage(AcpMiddleware middleware) =>
      _copy(middleware: <AcpMiddleware>[..._middleware, middleware]);

  /// Adds a handler that runs once initialization completes.
  AcpClientApp onConnect(AcpClientConnectHandler handler) => _copy(
    connectHandlers: <AcpClientConnectHandler>[..._connectHandlers, handler],
  );

  /// Returns a copy with different behavior options.
  AcpClientApp withOptions(AcpApplicationOptions value) => AcpClientApp._(
    name: name,
    options: value,
    initialization: initialization,
    protocolDescriptors: _protocolDescriptors,
    bindings: _bindings,
    middleware: _middleware,
    connectHandlers: _connectHandlers,
  );

  /// Returns a copy whose wire codec recognizes additional descriptors.
  AcpClientApp withProtocolDescriptors(
    Iterable<AcpMethodDescriptorBase> descriptors,
  ) => AcpClientApp._(
    name: name,
    options: options,
    initialization: initialization,
    protocolDescriptors: List<AcpMethodDescriptorBase>.unmodifiable(
      <AcpMethodDescriptorBase>[..._protocolDescriptors, ...descriptors],
    ),
    bindings: _bindings,
    middleware: _middleware,
    connectHandlers: _connectHandlers,
  );

  /// Connects this app to a transport and starts initialization.
  AcpClientConnection connect(
    AcpDuplexStream<Object?> stream, {
    AcpConnectOptions connectOptions = const AcpConnectOptions(),
  }) {
    late AcpConnectionLifecycle lifecycle;
    late AcpClientContext context;
    final _AcpSessionRouter sessionRouter = _AcpSessionRouter();
    final String initializeMethod = initialization?.methodName ?? 'initialize';
    final handlers = <JsonRpcHandler>[
      _initializationGuard(() => lifecycle, initializeMethod),
      sessionRouter.handle,
      for (final AcpMiddleware middleware in _middleware)
        (IncomingJsonRpcMessage message, JsonRpcHandlerContext rawContext) =>
            _middlewareHandler(middleware, context)(message, rawContext),
      for (final _AcpClientBinding binding in _bindings)
        (IncomingJsonRpcMessage message, JsonRpcHandlerContext rawContext) =>
            binding.build(context, lifecycle)(message, rawContext),
    ];
    final JsonRpcConnection rawConnection = JsonRpcConnection(
      stream: _asynchronousInput(stream),
      handlers: handlers,
      options: options.jsonRpcOptions,
      codec: AcpJsonRpcCodec(
        protocolMethods: _protocolMethodNames(_protocolDescriptors, _bindings),
      ),
    );
    lifecycle = AcpConnectionLifecycle._(
      rawConnection: rawConnection,
      requireInitialization: options.requireInitialization,
    );
    context = AcpClientContext._(
      rawConnection: rawConnection,
      lifecycle: lifecycle,
      options: options,
      sessions: sessionRouter,
    );
    final AcpClientConnection connection = AcpClientConnection._(
      rawConnection: rawConnection,
      lifecycle: lifecycle,
      agent: context,
    );
    connection._startHandlers = () => _startClientConnectHandlers(connection);
    if (!connectOptions.deferConnectHandlers) {
      connection.startConnectHandlers();
    }
    if (options.requireInitialization) {
      final AcpClientInitializationConfiguration? adapter = initialization;
      if (adapter == null) {
        final StateError error = StateError(
          'Client initialization configuration is required',
        );
        connection.close(error);
      } else {
        unawaited(
          adapter
              ._start(context, lifecycle)
              .catchError((Object error) => connection.close(error)),
        );
      }
    }
    return connection;
  }

  /// Connects directly to [agent] and waits for initialization.
  Future<AcpDirectConnectionPair> connectWith(
    AcpAgentApp agent, {
    int maximumBufferedMessages = 1024,
  }) => acpConnectApps(
    agent: agent,
    client: this,
    maximumBufferedMessages: maximumBufferedMessages,
  );

  void _startClientConnectHandlers(AcpClientConnection connection) {
    if (connection.lifecycle.isReady) {
      _runClientConnectHandlers(connection, _connectHandlers);
      return;
    }
    unawaited(
      connection.lifecycle.ready.then<void>(
        (_) => _runClientConnectHandlers(connection, _connectHandlers),
        onError: (Object error, StackTrace _) => connection.close(error),
      ),
    );
  }

  AcpClientApp _copy({
    List<_AcpClientBinding>? bindings,
    List<AcpMiddleware>? middleware,
    List<AcpClientConnectHandler>? connectHandlers,
  }) => AcpClientApp._(
    name: name,
    options: options,
    initialization: initialization,
    protocolDescriptors: _protocolDescriptors,
    bindings: List<_AcpClientBinding>.unmodifiable(bindings ?? _bindings),
    middleware: List<AcpMiddleware>.unmodifiable(middleware ?? _middleware),
    connectHandlers: List<AcpClientConnectHandler>.unmodifiable(
      connectHandlers ?? _connectHandlers,
    ),
  );
}

/// Connects an agent and client app over bounded in-process transports.
Future<AcpDirectConnectionPair> acpConnectApps({
  required AcpAgentApp agent,
  required AcpClientApp client,
  int maximumBufferedMessages = 1024,
}) async {
  final AcpInProcessTransportPair<Object?> transports =
      acpInProcessTransportPair<Object?>(
        maximumBufferedMessages: maximumBufferedMessages,
      );
  final AcpAgentConnection agentConnection = agent.connect(transports.left);
  final AcpClientConnection clientConnection = client.connect(transports.right);
  final AcpDirectConnectionPair pair = AcpDirectConnectionPair(
    agent: agentConnection,
    client: clientConnection,
    agentTransport: transports.left,
    clientTransport: transports.right,
  );
  unawaited(
    agentConnection.closed.whenComplete(() => clientConnection.close()),
  );
  unawaited(
    clientConnection.closed.whenComplete(() => agentConnection.close()),
  );
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
