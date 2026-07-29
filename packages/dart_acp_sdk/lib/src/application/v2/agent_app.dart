part of 'application.dart';

/// Immutable agent-side application for the draft ACP v2 baseline.
final class AcpV2AgentApp {
  /// Creates an agent with automatic version-2 initialization.
  AcpV2AgentApp({
    required this.implementation,
    required this.capabilities,
    Iterable<v2.AuthMethod> authMethods = const <v2.AuthMethod>[],
    String? name,
    this.options = const AcpV2ApplicationOptions(),
    Iterable<AcpMethodDescriptorBase> protocolDescriptors =
        v2_methods.v2StableMethodDescriptors,
  }) : name = name ?? implementation.name,
       authMethods = List<v2.AuthMethod>.unmodifiable(authMethods),
       _protocolDescriptors = List<AcpMethodDescriptorBase>.unmodifiable(
         protocolDescriptors,
       ),
       _bindings = const <_AcpV2AgentBinding>[],
       _connectHandlers = const <AcpV2AgentConnectHandler>[];

  const AcpV2AgentApp._({
    required this.implementation,
    required this.capabilities,
    required this.authMethods,
    required this.name,
    required this.options,
    required List<AcpMethodDescriptorBase> protocolDescriptors,
    required List<_AcpV2AgentBinding> bindings,
    required List<AcpV2AgentConnectHandler> connectHandlers,
  }) : _protocolDescriptors = protocolDescriptors,
       _bindings = bindings,
       _connectHandlers = connectHandlers;

  /// Agent implementation details.
  final v2.Implementation implementation;

  /// Agent capabilities.
  final v2.AgentCapabilities capabilities;

  /// Authentication methods; non-empty advertises login and logout together.
  final List<v2.AuthMethod> authMethods;

  /// Human-readable diagnostic name.
  final String name;

  /// Runtime options.
  final AcpV2ApplicationOptions options;

  final List<AcpMethodDescriptorBase> _protocolDescriptors;
  final List<_AcpV2AgentBinding> _bindings;
  final List<AcpV2AgentConnectHandler> _connectHandlers;

  /// Registers a typed request handler and returns a new app.
  AcpV2AgentApp onRequest<P, R>(
    AcpMethodDescriptor<P, R> method,
    AcpV2AgentRequestHandler<P, R> handler,
  ) {
    _validateV2Registration(
      method,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.request,
      options: options,
    );
    if (method.name == v2_methods.initializeMethod.name) {
      throw StateError('ACP v2 initialize is managed by the application');
    }
    _validateV2NoDuplicate(_bindings, method);
    return _copy(
      bindings: <_AcpV2AgentBinding>[
        ..._bindings,
        _AcpV2AgentRequestBinding<P, R>(method, handler),
      ],
    );
  }

  /// Registers a typed notification handler and returns a new app.
  AcpV2AgentApp onNotification<P>(
    AcpMethodDescriptor<P, AcpNoResult> method,
    AcpV2AgentNotificationHandler<P> handler,
  ) {
    _validateV2Registration(
      method,
      direction: AcpMethodDirection.clientToAgent,
      kind: AcpMethodKind.notification,
      options: options,
    );
    _validateV2NoDuplicate(_bindings, method);
    return _copy(
      bindings: <_AcpV2AgentBinding>[
        ..._bindings,
        _AcpV2AgentNotificationBinding<P>(method, handler),
      ],
    );
  }

  /// Adds an exactly-once ready handler.
  AcpV2AgentApp onConnect(AcpV2AgentConnectHandler handler) => _copy(
    connectHandlers: <AcpV2AgentConnectHandler>[..._connectHandlers, handler],
  );

  /// Returns a copy with different options.
  AcpV2AgentApp withOptions(AcpV2ApplicationOptions value) => AcpV2AgentApp._(
    implementation: implementation,
    capabilities: capabilities,
    authMethods: authMethods,
    name: name,
    options: value,
    protocolDescriptors: _protocolDescriptors,
    bindings: _bindings,
    connectHandlers: _connectHandlers,
  );

  /// Adds descriptors recognized by the wire codec.
  AcpV2AgentApp withProtocolDescriptors(
    Iterable<AcpMethodDescriptorBase> descriptors,
  ) => AcpV2AgentApp._(
    implementation: implementation,
    capabilities: capabilities,
    authMethods: authMethods,
    name: name,
    options: options,
    protocolDescriptors: List<AcpMethodDescriptorBase>.unmodifiable(
      <AcpMethodDescriptorBase>[..._protocolDescriptors, ...descriptors],
    ),
    bindings: _bindings,
    connectHandlers: _connectHandlers,
  );

  /// Connects this app to one v2 transport.
  AcpV2AgentConnection connect(
    AcpDuplexStream<Object?> stream, {
    AcpV2ConnectOptions connectOptions = const AcpV2ConnectOptions(),
  }) {
    late AcpV2ConnectionLifecycle lifecycle;
    late AcpV2AgentContext context;
    final handlers = <JsonRpcHandler>[
      _v2InitializationGuard(() => lifecycle),
      (IncomingJsonRpcMessage message, JsonRpcHandlerContext _) async {
        if (message is! IncomingJsonRpcRequest ||
            message.method != v2_methods.initializeMethod.name) {
          return JsonRpcPass(message: message);
        }
        try {
          final v2.InitializeRequest request = _decodeV2Params(
            v2_methods.initializeMethod.paramsCodec,
            message.params,
          );
          _requireV2(request.protocolVersion);
          final response = v2.InitializeResponse(
            protocolVersion: v2.ProtocolVersion(2),
            info: implementation,
            capabilities: capabilities,
            authMethods: authMethods,
          );
          await message.responder.respond(response.toJson());
          lifecycle._markReady(
            peerCapabilities: _v2ClientCapabilities(request),
            peerImplementation: request.info.toAcpJson(),
          );
          return const JsonRpcHandled();
        } on Object catch (error) {
          if (!message.responder.hasResponded) {
            await message.responder.respondException(
              error is JsonRpcRequestException
                  ? error
                  : JsonRpcRequestException.invalidParams(),
            );
          }
          return const JsonRpcHandled();
        }
      },
      for (final _AcpV2AgentBinding binding in _bindings)
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
    context = AcpV2AgentContext._(
      rawConnection: raw,
      lifecycle: lifecycle,
      options: options,
    );
    final connection = AcpV2AgentConnection._(raw, lifecycle, context);
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
    return connection;
  }

  /// Connects directly to [client] over bounded in-process streams.
  Future<AcpV2DirectConnectionPair> connectWith(
    AcpV2ClientApp client, {
    int maximumBufferedMessages = 1024,
  }) => acpV2ConnectApps(
    agent: this,
    client: client,
    maximumBufferedMessages: maximumBufferedMessages,
  );

  AcpV2AgentApp _copy({
    List<_AcpV2AgentBinding>? bindings,
    List<AcpV2AgentConnectHandler>? connectHandlers,
  }) => AcpV2AgentApp._(
    implementation: implementation,
    capabilities: capabilities,
    authMethods: authMethods,
    name: name,
    options: options,
    protocolDescriptors: _protocolDescriptors,
    bindings: List<_AcpV2AgentBinding>.unmodifiable(bindings ?? _bindings),
    connectHandlers: List<AcpV2AgentConnectHandler>.unmodifiable(
      connectHandlers ?? _connectHandlers,
    ),
  );
}

AcpDuplexStream<Object?> _v2AsynchronousInput(
  AcpDuplexStream<Object?> stream,
) => AcpDuplexStream<Object?>(
  readable: stream.readable.asyncMap<Object?>(
    (Object? value) => Future<Object?>.value(value),
  ),
  writable: stream.writable,
);

void _requireV2(v2.ProtocolVersion version) {
  if (version.value != 2) {
    throw JsonRpcRequestException.invalidParams(
      data: <String, Object?>{
        'protocolVersion': version.value,
        'supportedProtocolVersion': 2,
      },
    );
  }
}

AcpV2PeerCapabilities _v2ClientCapabilities(v2.InitializeRequest request) =>
    AcpV2PeerCapabilities(
      AcpJsonObject.fromObject(<String, Object?>{
        'capabilities': request.capabilities.toJson(),
      }),
    );

AcpV2PeerCapabilities _v2AgentCapabilities(v2.InitializeResponse response) {
  return AcpV2PeerCapabilities(
    AcpJsonObject.fromObject(<String, Object?>{
      'capabilities': response.capabilities.toJson(),
      if (response.authMethods case final List<v2.AuthMethod> methods
          when methods.isNotEmpty)
        'authMethods': <Object?>[
          for (final v2.AuthMethod method in methods) method.toJson(),
        ],
    }),
  );
}
