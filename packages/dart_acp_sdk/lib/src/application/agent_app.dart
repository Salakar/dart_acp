part of 'application.dart';

/// Immutable agent-side ACP v1 application.
final class AcpAgentApp {
  /// Creates an empty agent application.
  AcpAgentApp({
    String? name,
    this.options = const AcpApplicationOptions(),
    AcpAgentInitializationConfiguration? initialization,
    v1.Implementation? implementation,
    v1.AgentCapabilities? capabilities,
    Iterable<v1.AuthMethod> authMethods = const <v1.AuthMethod>[],
    Iterable<AcpMethodDescriptorBase> protocolDescriptors =
        v1_methods.v1StableMethodDescriptors,
  }) : name = name ?? implementation?.name ?? 'agent',
       initialization = _resolveAgentInitialization(
         initialization,
         implementation,
         capabilities,
       ),
       _protocolDescriptors = List<AcpMethodDescriptorBase>.unmodifiable(
         protocolDescriptors,
       ),
       _bindings = _initialAgentBindings(
         initialization,
         implementation,
         capabilities,
         authMethods,
       ),
       _middleware = const <AcpMiddleware>[],
       _connectHandlers = const <AcpAgentConnectHandler>[];

  /// Creates an agent with automatic stable-v1 initialization.
  factory AcpAgentApp.v1({
    required v1.Implementation implementation,
    required v1.AgentCapabilities capabilities,
    Iterable<v1.AuthMethod> authMethods = const <v1.AuthMethod>[],
    AcpApplicationOptions options = const AcpApplicationOptions(),
  }) => AcpAgentApp(
    implementation: implementation,
    capabilities: capabilities,
    authMethods: authMethods,
    options: options,
  );

  const AcpAgentApp._({
    required this.name,
    required this.options,
    required this.initialization,
    required List<AcpMethodDescriptorBase> protocolDescriptors,
    required List<_AcpAgentBinding> bindings,
    required List<AcpMiddleware> middleware,
    required List<AcpAgentConnectHandler> connectHandlers,
  }) : _protocolDescriptors = protocolDescriptors,
       _bindings = bindings,
       _middleware = middleware,
       _connectHandlers = connectHandlers;

  /// Human-readable diagnostic name.
  final String name;

  /// Application behavior options.
  final AcpApplicationOptions options;

  /// Typed initialization metadata extraction.
  final AcpAgentInitializationConfiguration? initialization;

  final List<AcpMethodDescriptorBase> _protocolDescriptors;
  final List<_AcpAgentBinding> _bindings;
  final List<AcpMiddleware> _middleware;
  final List<AcpAgentConnectHandler> _connectHandlers;

  /// Registers a typed request handler and returns a new app.
  AcpAgentApp onRequest<P, R>(
    AcpMethodDescriptor<P, R> method,
    AcpAgentRequestHandler<P, R> handler,
  ) {
    _validateRegistration(
      method,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      options: options,
    );
    _validateNoDuplicate(_bindings, method);
    return _copy(
      bindings: <_AcpAgentBinding>[
        ..._bindings,
        _AcpAgentRequestBinding<P, R>(method, handler),
      ],
    );
  }

  /// Registers a typed notification handler and returns a new app.
  AcpAgentApp onNotification<P>(
    AcpMethodDescriptor<P, AcpNoResult> method,
    AcpAgentNotificationHandler<P> handler,
  ) {
    _validateRegistration(
      method,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      options: options,
    );
    _validateNoDuplicate(_bindings, method);
    return _copy(
      bindings: <_AcpAgentBinding>[
        ..._bindings,
        _AcpAgentNotificationBinding<P>(method, handler),
      ],
    );
  }

  /// Adds ordered raw middleware and returns a new app.
  AcpAgentApp onMessage(AcpMiddleware middleware) =>
      _copy(middleware: <AcpMiddleware>[..._middleware, middleware]);

  /// Adds a handler that runs once initialization completes.
  AcpAgentApp onConnect(AcpAgentConnectHandler handler) => _copy(
    connectHandlers: <AcpAgentConnectHandler>[..._connectHandlers, handler],
  );

  /// Returns a copy with different behavior options.
  AcpAgentApp withOptions(AcpApplicationOptions value) => AcpAgentApp._(
    name: name,
    options: value,
    initialization: initialization,
    protocolDescriptors: _protocolDescriptors,
    bindings: _bindings,
    middleware: _middleware,
    connectHandlers: _connectHandlers,
  );

  /// Returns a copy whose wire codec recognizes additional descriptors.
  AcpAgentApp withProtocolDescriptors(
    Iterable<AcpMethodDescriptorBase> descriptors,
  ) => AcpAgentApp._(
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

  /// Connects this app to a transport.
  AcpAgentConnection connect(
    AcpDuplexStream<Object?> stream, {
    AcpConnectOptions connectOptions = const AcpConnectOptions(),
  }) {
    late AcpConnectionLifecycle lifecycle;
    late AcpAgentContext context;
    final String initializeMethod = initialization?.methodName ?? 'initialize';
    final handlers = <JsonRpcHandler>[
      _initializationGuard(() => lifecycle, initializeMethod),
      for (final AcpMiddleware middleware in _middleware)
        (IncomingJsonRpcMessage message, JsonRpcHandlerContext rawContext) =>
            _middlewareHandler(middleware, context)(message, rawContext),
      for (final _AcpAgentBinding binding in _bindings)
        (
          IncomingJsonRpcMessage message,
          JsonRpcHandlerContext rawContext,
        ) async {
          final bool isInitialization =
              !lifecycle.isReady &&
              binding.descriptor.name == initializeMethod &&
              message is IncomingJsonRpcRequest;
          try {
            if (isInitialization) {
              initialization?._validate(message.params.value);
            }
            final JsonRpcHandleResult? result = await binding.build(
              context,
              lifecycle,
            )(message, rawContext);
            if (isInitialization &&
                message.responder.hasResponded &&
                result is JsonRpcHandled) {
              final AcpAgentInitializationConfiguration? adapter =
                  initialization;
              if (adapter == null) {
                lifecycle._markReady(
                  peerCapabilities: AcpPeerCapabilities.empty(),
                );
              } else {
                adapter._establish(message.params.value, lifecycle);
              }
            }
            return result;
          } on Object catch (error) {
            if (isInitialization && !message.responder.hasResponded) {
              final JsonRpcRequestException responseError =
                  error is JsonRpcRequestException
                  ? error
                  : JsonRpcRequestException.invalidParams();
              await message.responder.respondException(responseError);
              lifecycle._rawConnection.close(error);
              return const JsonRpcHandled();
            }
            rethrow;
          }
        },
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
    context = AcpAgentContext._(
      rawConnection: rawConnection,
      lifecycle: lifecycle,
      options: options,
    );
    final AcpAgentConnection connection = AcpAgentConnection._(
      rawConnection: rawConnection,
      lifecycle: lifecycle,
      client: context,
    );
    connection._startHandlers = () => _startAgentConnectHandlers(connection);
    if (!connectOptions.deferConnectHandlers) {
      connection.startConnectHandlers();
    }
    return connection;
  }

  /// Connects directly to [client] and waits for initialization.
  Future<AcpDirectConnectionPair> connectWith(
    AcpClientApp client, {
    int maximumBufferedMessages = 1024,
  }) => acpConnectApps(
    agent: this,
    client: client,
    maximumBufferedMessages: maximumBufferedMessages,
  );

  void _startAgentConnectHandlers(AcpAgentConnection connection) {
    if (connection.lifecycle.isReady) {
      _runAgentConnectHandlers(connection, _connectHandlers);
      return;
    }
    unawaited(
      connection.lifecycle.ready.then<void>(
        (_) => _runAgentConnectHandlers(connection, _connectHandlers),
        onError: (Object error, StackTrace _) => connection.close(error),
      ),
    );
  }

  AcpAgentApp _copy({
    List<_AcpAgentBinding>? bindings,
    List<AcpMiddleware>? middleware,
    List<AcpAgentConnectHandler>? connectHandlers,
  }) => AcpAgentApp._(
    name: name,
    options: options,
    initialization: initialization,
    protocolDescriptors: _protocolDescriptors,
    bindings: List<_AcpAgentBinding>.unmodifiable(bindings ?? _bindings),
    middleware: List<AcpMiddleware>.unmodifiable(middleware ?? _middleware),
    connectHandlers: List<AcpAgentConnectHandler>.unmodifiable(
      connectHandlers ?? _connectHandlers,
    ),
  );
}
