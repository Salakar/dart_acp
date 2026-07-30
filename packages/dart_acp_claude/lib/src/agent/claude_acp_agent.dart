import 'dart:async';

import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_sdk/dart_acp_sdk.dart';
import 'package:dart_acp_sdk/experimental/v1_unstable.dart' as unstable;

import '../application/extensions.dart';
import '../configuration/agent_options.dart';
import '../configuration/provider_configuration.dart';
import '../configuration/session_configuration.dart';
import '../configuration/session_options.dart';
import '../conversion/local_command_filter.dart';
import '../conversion/mcp_mapper.dart';
import '../conversion/message_projector.dart';
import '../conversion/plan_projector.dart';
import '../conversion/prompt_mapper.dart';
import '../elicitation/elicitation_mapper.dart';
import '../runtime/contracts.dart';
import 'session_state.dart';

/// ACP v1 agent backed by one Claude SDK client per session.
final class ClaudeAcpAgent {
  /// Creates a reusable agent application.
  ClaudeAcpAgent({
    ClaudeAgentClientFactory? clientFactory,
    ClaudeAcpOptions? options,
    ClaudeAcpEnvironment? environment,
    ClaudeAcpLogger logger = const ClaudeAcpNullLogger(),
    ClaudeAcpFileSystem fileSystem = const LocalClaudeAcpFileSystem(),
    ClaudeAcpClock? clock,
    ClaudeAcpIdGenerator? idGenerator,
    ClaudePromptMapper promptMapper = const ClaudePromptMapper(),
    ClaudeMessageProjector messageProjector = const ClaudeMessageProjector(),
    ClaudeMcpMapper mcpMapper = const ClaudeMcpMapper(),
    ClaudeElicitationMapper elicitationMapper = const ClaudeElicitationMapper(),
    ClaudeLogoutRunner? logoutRunner,
    ClaudeSessionInfoLookup? sessionInfoLookup,
    ClaudeSettingsResolver? settingsResolver,
    ClaudeSessionDelete? sessionDelete,
  }) : options = options ?? ClaudeAcpOptions(),
       environment = environment ?? ClaudeAcpEnvironment(),
       _clientFactory =
           clientFactory ??
           ((value) async => claude.ClaudeAgentClient(options: value)),
       _logger = logger,
       _fileSystem = fileSystem,
       _clock = clock ?? DateTime.now,
       _idGenerator = idGenerator ?? ClaudeAcpRandomIdGenerator().call,
       _promptMapper = promptMapper,
       _messageProjector = messageProjector,
       _mcpMapper = mcpMapper,
       _elicitationMapper = elicitationMapper,
       _sessionInfoLookup = sessionInfoLookup ?? claude.getSessionInfo,
       _sessionDelete = sessionDelete ?? claude.deleteSession,
       _settingsResolver =
           settingsResolver ??
           ((workingDirectory, variables) async {
             final resolved = await claude.resolveSettings(
               workingDirectory: workingDirectory,
               environment: variables,
             );
             return claude.ClaudeResolvedSettings(
               claude.filterEscalatingDefaultMode(resolved),
               provenance: resolved.provenance,
               sources: resolved.sources,
             );
           }),
       _logoutRunner =
           logoutRunner ??
           ((sdkOptions, variables) => claude.logoutClaude(
             options: sdkOptions,
             parentEnvironment: variables,
           )) {
    final baseApp = AcpAgentApp(
      name: 'dart_acp_claude',
      initialization:
          AcpAgentInitialization<
            unstable.InitializeRequest,
            unstable.InitializeResponse
          >(
            method: unstable.initializeMethod,
            peerCapabilities: (request) => AcpPeerCapabilities(
              AcpJsonObject.fromObject(<String, Object?>{
                'clientCapabilities': request.clientCapabilities.toJson(),
              }),
            ),
            peerImplementation: (request) => request.clientInfo?.toAcpJson(),
            validateRequest: (request) {
              if (request.protocolVersion.value != 1) {
                throw JsonRpcRequestException.invalidParams(
                  data: <String, Object?>{
                    'protocolVersion': request.protocolVersion.value,
                    'supportedProtocolVersion': 1,
                  },
                );
              }
            },
          ),
    );
    final unstableApp = unstable.AcpV1UnstableAgentApp(
      baseApp,
    ).withV1UnstableMethods().onRequest(unstable.initializeMethod, _initialize);
    app = unstableApp
        .onAuthenticate(_authenticate)
        .onLogout(_logout)
        .onNewSession(_newSession)
        .onResumeSession(_resumeSession)
        .onLoadSession(_loadSession)
        .onListSessions(_listSessions)
        .onDeleteSession(_deleteSession)
        .onCloseSession(_closeSession)
        .onSetSessionMode(_setMode)
        .onSetSessionConfigOption(_setConfigOption)
        .onPrompt(_prompt)
        .onCancelSession(_cancel)
        .onRequest(unstable.sessionForkMethod, _forkSession)
        .onRequest(unstable.providersListMethod, _listProviders)
        .onRequest(unstable.providersSetMethod, _setProvider)
        .onRequest(unstable.providersDisableMethod, _disableProvider)
        .onRequest(claudeSteeringMethod, _steer);
  }

  /// Adapter defaults.
  final ClaudeAcpOptions options;

  /// Effective process environment.
  final ClaudeAcpEnvironment environment;

  final ClaudeAgentClientFactory _clientFactory;
  final ClaudeAcpLogger _logger;
  final ClaudeAcpFileSystem _fileSystem;
  final ClaudeAcpClock _clock;
  final ClaudeAcpIdGenerator _idGenerator;
  final ClaudePromptMapper _promptMapper;
  final ClaudeMessageProjector _messageProjector;
  final ClaudeMcpMapper _mcpMapper;
  final ClaudeElicitationMapper _elicitationMapper;
  final ClaudeSessionInfoLookup _sessionInfoLookup;
  final ClaudeSessionDelete _sessionDelete;
  final ClaudeSettingsResolver _settingsResolver;
  final ClaudeLogoutRunner _logoutRunner;
  final Map<SessionId, ClaudeAcpSession> _sessions =
      <SessionId, ClaudeAcpSession>{};
  bool _disposed = false;
  ClaudeProviderConfiguration? _provider;

  /// Typed ACP application.
  late final AcpAgentApp app;

  /// Number of currently open sessions.
  int get sessionCount => _sessions.length;

  unstable.InitializeResponse _initialize(
    AcpAgentRequestContext<unstable.InitializeRequest> context,
  ) {
    final capabilities = context.params.clientCapabilities;
    final authMeta = capabilities.auth.meta?.toObject();
    final clientMeta = capabilities.meta?.toObject();
    final supportsGateway = authMeta?['gateway'] == true;
    final supportsTerminal =
        capabilities.auth.terminal || clientMeta?['terminal-auth'] == true;
    return unstable.InitializeResponse(
      protocolVersion: unstable.ProtocolVersion(1),
      agentCapabilities: unstable.AgentCapabilities.fromJson(<String, Object?>{
        'loadSession': true,
        'promptCapabilities': <String, Object?>{
          'image': true,
          'audio': false,
          'embeddedContext': true,
        },
        'mcpCapabilities': <String, Object?>{
          'http': true,
          'sse': true,
          'acp': false,
        },
        'sessionCapabilities': <String, Object?>{
          'list': <String, Object?>{},
          'delete': <String, Object?>{},
          'fork': <String, Object?>{},
          'additionalDirectories': <String, Object?>{},
          'resume': <String, Object?>{},
          'close': <String, Object?>{},
        },
        'auth': <String, Object?>{'logout': <String, Object?>{}},
        'providers': <String, Object?>{},
        '_meta': <String, Object?>{
          'claudeCode': <String, Object?>{
            'promptQueueing': true,
            'maximumPendingPrompts': options.maximumQueuedPrompts,
          },
        },
      }),
      authMethods: <unstable.AuthMethod>[
        if (supportsTerminal) ..._terminalAuthMethods(),
        if (supportsGateway) ..._gatewayAuthMethods(),
      ],
      agentInfo: unstable.Implementation(
        name: 'dart_acp_claude',
        title: 'Claude',
        version: '0.1.0',
      ),
      meta: AcpJsonObject.fromObject(<String, Object?>{
        'steering': <String, Object?>{'supported': true},
      }),
    );
  }

  List<unstable.AuthMethod> _terminalAuthMethods() {
    if (environment.isRemote) {
      if (environment.hideAuthentication) return const <unstable.AuthMethod>[];
      return <unstable.AuthMethod>[
        unstable.AuthMethodAuthMethodTerminal(
          unstable.AuthMethodTerminal(
            id: unstable.AuthMethodId('claude-login'),
            name: 'Log in with Claude',
            description: 'Run Claude login in an interactive terminal.',
            args: const <String>['--cli'],
          ),
        ),
      ];
    }
    return <unstable.AuthMethod>[
      if (!environment.hideAuthentication)
        unstable.AuthMethodAuthMethodTerminal(
          unstable.AuthMethodTerminal(
            id: unstable.AuthMethodId('claude-ai-login'),
            name: 'Claude Subscription',
            description: 'Use a Claude subscription.',
            args: const <String>['--cli', 'auth', 'login', '--claudeai'],
          ),
        ),
      unstable.AuthMethodAuthMethodTerminal(
        unstable.AuthMethodTerminal(
          id: unstable.AuthMethodId('console-login'),
          name: 'Anthropic Console',
          description: 'Use API usage billing.',
          args: const <String>['--cli', 'auth', 'login', '--console'],
        ),
      ),
    ];
  }

  List<unstable.AuthMethod> _gatewayAuthMethods() => <unstable.AuthMethod>[
    unstable.AuthMethodAgentVariant(
      unstable.AuthMethodAgent(
        id: unstable.AuthMethodId('gateway'),
        name: 'Custom model gateway',
        description: 'Use an Anthropic-compatible gateway.',
        meta: AcpJsonObject.fromObject(<String, Object?>{
          'gateway': <String, Object?>{'protocol': 'anthropic'},
        }),
      ),
    ),
    unstable.AuthMethodAgentVariant(
      unstable.AuthMethodAgent(
        id: unstable.AuthMethodId('gateway-bedrock'),
        name: 'Custom model gateway',
        description: 'Use a Bedrock-compatible gateway.',
        meta: AcpJsonObject.fromObject(<String, Object?>{
          'gateway': <String, Object?>{'protocol': 'bedrock'},
        }),
      ),
    ),
  ];

  AuthenticateResponse _authenticate(
    AcpAgentRequestContext<AuthenticateRequest> context,
  ) {
    final method = context.params.methodId.value;
    if (method != 'gateway' && method != 'gateway-bedrock') {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{'methodId': method},
      );
    }
    final gateway = context.params.meta?.toObject()['gateway'];
    if (gateway is! Map<Object?, Object?> ||
        gateway['baseUrl'] is! String ||
        gateway['headers'] is! Map<Object?, Object?>) {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{
          'message': 'Gateway authentication requires baseUrl and headers.',
        },
      );
    }
    final headers = <String, String>{};
    for (final entry
        in (gateway['headers']! as Map<Object?, Object?>).entries) {
      if (entry.key is! String || entry.value is! String) {
        throw JsonRpcRequestException.invalidParams(
          data: <String, Object?>{
            'message': 'Gateway headers must contain string values.',
          },
        );
      }
      headers[entry.key! as String] = entry.value! as String;
    }
    try {
      _provider = ClaudeProviderConfiguration(
        apiType: method == 'gateway-bedrock' ? 'bedrock' : 'anthropic',
        baseUrl: Uri.parse(gateway['baseUrl']! as String),
        headers: headers,
      );
    } on Object catch (error) {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{'message': '$error'},
      );
    }
    return AuthenticateResponse();
  }

  Future<LogoutResponse> _logout(
    AcpAgentRequestContext<LogoutRequest> context,
  ) async {
    _provider = null;
    final sdkOptions = claude.ClaudeAgentOptions(
      cliPath: options.cliPath,
      environment: <String, String>{
        ...environment.variables,
        ...options.environment,
      },
    );
    final exitCode = await _logoutRunner(sdkOptions, <String, String>{
      ...environment.variables,
      ...options.environment,
    });
    if (exitCode != 0) {
      throw JsonRpcRequestException.internalError(
        data: <String, Object?>{
          'message': 'Claude logout failed.',
          'exitCode': exitCode,
        },
      );
    }
    return LogoutResponse();
  }

  Future<NewSessionResponse> _newSession(
    AcpAgentRequestContext<NewSessionRequest> context,
  ) async {
    final sessionOptions = ClaudeAcpSessionOptions.fromMeta(
      context.params.meta,
    );
    final resumeId = sessionOptions.resume;
    final session = await _open(
      peer: context.client,
      id: SessionId(resumeId ?? _idGenerator()),
      cwd: context.params.cwd,
      additionalDirectories: context.params.additionalDirectories,
      mcpServers: context.params.mcpServers,
      meta: context.params.meta,
      resume: resumeId != null,
      resumeSessionId: resumeId,
    );
    return NewSessionResponse(
      sessionId: session.id,
      modes: session.configuration.modes,
      configOptions: session.configuration.options,
    );
  }

  Future<ResumeSessionResponse> _resumeSession(
    AcpAgentRequestContext<ResumeSessionRequest> context,
  ) async {
    final session = await _open(
      peer: context.client,
      id: context.params.sessionId,
      cwd: context.params.cwd,
      additionalDirectories: context.params.additionalDirectories,
      mcpServers: context.params.mcpServers ?? const <McpServer>[],
      meta: context.params.meta,
      resume: true,
    );
    return ResumeSessionResponse(
      modes: session.configuration.modes,
      configOptions: session.configuration.options,
    );
  }

  Future<LoadSessionResponse> _loadSession(
    AcpAgentRequestContext<LoadSessionRequest> context,
  ) async {
    final session = await _open(
      peer: context.client,
      id: context.params.sessionId,
      cwd: context.params.cwd,
      additionalDirectories: context.params.additionalDirectories,
      mcpServers: context.params.mcpServers,
      meta: context.params.meta,
      resume: true,
    );
    await _replay(context.client, session);
    return LoadSessionResponse(
      modes: session.configuration.modes,
      configOptions: session.configuration.options,
    );
  }

  Future<ClaudeAcpSession> _open({
    required AcpAgentContext peer,
    required SessionId id,
    required String cwd,
    required List<String>? additionalDirectories,
    required List<McpServer> mcpServers,
    AcpJsonObject? meta,
    bool resume = false,
    bool fork = false,
    String? resumeSessionId,
  }) async {
    if (_disposed) throw StateError('Agent is disposed');
    final sessionOptions = ClaudeAcpSessionOptions.fromMeta(meta);
    final acpDirectories =
        additionalDirectories ?? sessionOptions.additionalRoots;
    final effectiveDirectories = <String>{
      ...?sessionOptions.additionalDirectories,
      ...acpDirectories,
    }.toList(growable: false);
    await _validateDirectory(cwd, 'cwd');
    for (final directory in effectiveDirectories) {
      await _validateDirectory(directory, 'additionalDirectories');
    }
    if (resume &&
        !fork &&
        !_sessions.containsKey(id) &&
        _sessionInfoLookup(id.value, directory: cwd) == null) {
      throw JsonRpcRequestException.resourceNotFound(uri: id.value);
    }
    final fingerprint = _sessionFingerprint(
      cwd,
      effectiveDirectories,
      mcpServers,
      meta,
    );
    final cached = _sessions[id];
    if (cached != null && cached.fingerprint == fingerprint) return cached;
    final previous = _sessions.remove(id);
    await previous?.close();
    final baseEnvironment = <String, String>{
      ...environment.variables,
      ...options.environment,
      ...?_provider?.environment,
    };
    for (final entry
        in sessionOptions.environment?.entries ??
            const <MapEntry<String, String?>>[]) {
      if (entry.value == null) {
        baseEnvironment.remove(entry.key);
      } else {
        baseEnvironment[entry.key] = entry.value!;
      }
    }
    final settings = await _settingsResolver(cwd, baseEnvironment);
    final mergedEnvironment = <String, String>{
      ...baseEnvironment,
      ...settings.environment,
    };
    final initialMode = options.permissionMode == claude.PermissionMode.standard
        ? _permissionModeFromSettings(settings.defaultPermissionMode)
        : options.permissionMode;
    final initialModel =
        sessionOptions.model ?? options.model ?? settings.model;
    final formElicitation = peer.lifecycle.peerCapabilities.supports(
      'clientCapabilities.elicitation.form',
    );
    final urlElicitation = peer.lifecycle.peerCapabilities.supports(
      'clientCapabilities.elicitation.url',
    );
    final disallowedTools = <String>{
      ...?sessionOptions.disallowedTools,
      if (sessionOptions.disallowedTools == null) ...options.disallowedTools,
      if (!formElicitation) 'AskUserQuestion',
    }.toList(growable: false);
    final mappedMcp = _mcpMapper.map(mcpServers);
    final mergedMcpServers = <String, claude.McpServerConfig>{
      ...?sessionOptions.mcpServers,
      if (mappedMcp is claude.McpServers) ...mappedMcp.servers,
    };
    final effectiveMcp = mergedMcpServers.isEmpty
        ? mappedMcp
        : claude.McpServers(mergedMcpServers);
    final sessionTools =
        sessionOptions.tools ??
        (sessionOptions.disableBuiltInTools
            ? claude.ToolConfiguration.explicit(const <String>[])
            : options.tools);
    final sessionHooks = <claude.HookEvent, List<claude.HookMatcher>>{
      ...options.hooks,
      claude.HookEvent.postToolUse: <claude.HookMatcher>[
        ...?options.hooks[claude.HookEvent.postToolUse],
        claude.HookMatcher(
          matcher: 'EnterPlanMode',
          hooks: <claude.HookCallback>[
            (input, _, _) async {
              if (input is claude.PostToolUseHookInput &&
                  input.toolName == 'EnterPlanMode') {
                final session = _sessions[id];
                if (session != null &&
                    session.configuration.reconcileMode('plan')) {
                  await peer.updateSession(
                    SessionNotification(
                      sessionId: id,
                      update: SessionUpdate.fromJson(<String, Object?>{
                        'sessionUpdate': 'current_mode_update',
                        'currentModeId': 'plan',
                      }),
                    ),
                  );
                  await _sendConfiguration(peer, session);
                }
              }
              return const claude.HookOutput();
            },
          ],
        ),
      ],
    };
    Future<claude.HookOutput> projectTaskHook(
      claude.HookInput input,
      String? _,
      claude.ControlCallbackContext _,
    ) async {
      final session = _sessions[id];
      final update = session?.messageProjection.plan.hook(input);
      if (update != null) {
        await peer.updateSession(
          SessionNotification(sessionId: id, update: update),
        );
      }
      return const claude.HookOutput();
    }

    for (final event in const <claude.HookEvent>[
      claude.HookEvent.taskCreated,
      claude.HookEvent.taskCompleted,
    ]) {
      sessionHooks[event] = <claude.HookMatcher>[
        ...?options.hooks[event],
        claude.HookMatcher(hooks: <claude.HookCallback>[projectTaskHook]),
      ];
    }
    final sdkOptions = claude.ClaudeAgentOptions(
      tools: sessionTools,
      allowedTools: sessionOptions.allowedTools ?? options.allowedTools,
      disallowedTools: disallowedTools,
      systemPrompt: sessionOptions.systemPrompt ?? options.systemPrompt,
      mcp: effectiveMcp,
      strictMcpConfig:
          sessionOptions.strictMcpConfig ?? options.strictMcpConfig,
      permissionMode: initialMode,
      planModeInstructions:
          sessionOptions.planModeInstructions ?? options.planModeInstructions,
      resume: resume ? (resumeSessionId ?? id.value) : null,
      resumeSessionAt: sessionOptions.resumeSessionAt,
      sessionId: resume ? null : id.value,
      forkSession: fork,
      maxTurns: sessionOptions.maxTurns ?? options.maxTurns,
      maxBudgetUsd: sessionOptions.maxBudgetUsd ?? options.maxBudgetUsd,
      taskBudget: sessionOptions.taskBudget ?? options.taskBudget,
      model: initialModel,
      fallbackModel: sessionOptions.fallbackModel ?? options.fallbackModel,
      betas: sessionOptions.betas ?? options.betas,
      agent: sessionOptions.agent ?? options.agent,
      agents: sessionOptions.agents ?? options.agents,
      workingDirectory: cwd,
      addDirectories: effectiveDirectories,
      cliPath: options.cliPath,
      settings:
          sessionOptions.inlineSettings != null ||
              (sessionOptions.settings == null &&
                  options.inlineSettings != null)
          ? null
          : sessionOptions.settings ?? options.settings,
      inlineSettings:
          sessionOptions.inlineSettings ??
          (sessionOptions.settings == null ? options.inlineSettings : null),
      managedSettings:
          sessionOptions.managedSettings ?? options.managedSettings,
      environment: mergedEnvironment,
      extraArguments: <String, String?>{
        ...options.extraArguments,
        ...?sessionOptions.extraArguments,
        'replay-user-messages': '',
      },
      maxBufferSize: sessionOptions.maxBufferSize ?? options.maxBufferSize,
      includePartialMessages: true,
      includeHookEvents:
          sessionOptions.includeHookEvents ?? options.includeHookEvents,
      forwardSubagentText:
          sessionOptions.forwardSubagentText ?? options.forwardSubagentText,
      agentProgressSummaries:
          sessionOptions.agentProgressSummaries ??
          options.agentProgressSummaries,
      promptSuggestions:
          sessionOptions.promptSuggestions ?? options.promptSuggestions,
      toolAliases: sessionOptions.toolAliases ?? options.toolAliases,
      toolConfig: sessionOptions.toolConfig ?? options.toolConfig,
      skills: sessionOptions.skills ?? options.skills,
      settingSources: sessionOptions.settingSources ?? options.settingSources,
      sandbox: sessionOptions.sandbox ?? options.sandbox,
      plugins: sessionOptions.plugins ?? options.plugins,
      thinking: sessionOptions.thinking ?? options.thinking,
      effort: sessionOptions.effort ?? options.effort,
      hooks: sessionHooks,
      enableFileCheckpointing:
          sessionOptions.enableFileCheckpointing ??
          options.enableFileCheckpointing,
      persistSession: sessionOptions.persistSession ?? options.persistSession,
      user: sessionOptions.user ?? options.user,
      title: sessionOptions.title ?? options.title,
      debug: sessionOptions.debug ?? options.debug,
      debugFile: sessionOptions.debugFile ?? options.debugFile,
      outputFormat: sessionOptions.outputFormat ?? options.outputFormat,
      initializeTimeout: options.initializeTimeout,
      controlRequestTimeout: options.controlRequestTimeout,
      allowDangerouslySkipPermissions: options.allowDangerouslySkipPermissions,
      canUseTool: (name, input, permissionContext) =>
          _requestPermission(peer, id, name, input, permissionContext),
      onElicitation: formElicitation || urlElicitation
          ? (request, callbackContext) => _requestMcpElicitation(
              peer,
              id,
              request,
              callbackContext,
              form: formElicitation,
              url: urlElicitation,
            )
          : null,
      onUserDialog: formElicitation
          ? (request, callbackContext) =>
                _requestUserDialog(peer, id, request, callbackContext)
          : null,
      supportedDialogKinds: formElicitation
          ? const <String>[claudeRefusalFallbackDialogKind]
          : const <String>[],
      stderr: (line) => _logger.log(line),
    );
    final client = await _clientFactory(sdkOptions);
    try {
      await client.connect();
    } on Object {
      await client.close();
      rethrow;
    }
    final initialization = client.initializationResult;
    claude.ContextUsage? resumedUsage;
    if (resume) {
      try {
        resumedUsage = await client.getContextUsage();
      } on Object catch (error, stackTrace) {
        _logger.error(
          'Could not restore resumed-session context metadata',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    final configuration = ClaudeSessionConfiguration(
      initialization: initialization,
      initialMode: initialMode,
      requestedModel: resumedUsage?.model ?? initialModel,
      requestedAgent: sessionOptions.agent ?? options.agent,
      requestedEffort:
          sessionOptions.effort ?? options.effort ?? settings.effortLevel,
      availableModels: settings.effective.containsKey('availableModels')
          ? settings.availableModels
          : null,
      modelOverrides: settings.modelOverrides,
      customModelOption: mergedEnvironment['ANTHROPIC_CUSTOM_MODEL_OPTION'],
      useBooleanFastMode: peer.lifecycle.peerCapabilities.supports(
        'clientCapabilities.session.configOptions.boolean',
      ),
      preserveUnknownRequestedModel: resumedUsage?.model.isNotEmpty ?? false,
    );
    final session = ClaudeAcpSession(
      id: id,
      cwd: cwd,
      additionalDirectories: List<String>.unmodifiable(effectiveDirectories),
      client: client,
      configuration: configuration,
      maximumPending: options.maximumQueuedPrompts,
      fingerprint: fingerprint,
      forwardSubagentText:
          sessionOptions.forwardSubagentText ?? options.forwardSubagentText,
      rawSdkMessages: sessionOptions.emitRawSdkMessages,
    );
    final resumedWindow = resumedUsage?.rawMaxTokens ?? resumedUsage?.maxTokens;
    if (resumedWindow != null) {
      session.messageProjection.seedContextWindow(resumedWindow);
    }
    _sessions[id] = session;
    await _sendCommands(peer, session, initialization.commands);
    session.consumer = _consumeSession(peer, session);
    return session;
  }

  claude.PermissionMode _permissionModeFromSettings(String? value) {
    final normalized = value?.trim().toLowerCase();
    return switch (normalized) {
      'acceptedits' ||
      'accept_edits' ||
      'accept edits' => claude.PermissionMode.acceptEdits,
      'manual' => claude.PermissionMode.standard,
      'plan' => claude.PermissionMode.plan,
      'dontask' || 'dont_ask' || "don't ask" => claude.PermissionMode.dontAsk,
      'auto' => claude.PermissionMode.auto,
      'bypasspermissions' ||
      'bypass_permissions' => claude.PermissionMode.bypassPermissions,
      _ => claude.PermissionMode.standard,
    };
  }

  int _sessionFingerprint(
    String cwd,
    List<String> additionalDirectories,
    List<McpServer> mcpServers,
    AcpJsonObject? meta,
  ) {
    final directories = additionalDirectories.toList()..sort();
    final servers =
        mcpServers.map((server) => server.toJson().toString()).toList()..sort();
    final provider = _provider;
    final providerValues = provider == null
        ? const <Object?>[]
        : <Object?>[
            provider.apiType,
            provider.baseUrl,
            ...provider.headers.entries.expand(
              (entry) => <Object?>[entry.key, entry.value],
            ),
          ];
    return Object.hashAll(<Object?>[
      cwd,
      ...directories,
      ...servers,
      meta?.toObject().toString(),
      ...providerValues,
    ]);
  }

  Future<void> _validateDirectory(String path, String field) async {
    if (!_fileSystem.isAbsolute(path) || !await _fileSystem.isDirectory(path)) {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{
          'field': field,
          'path': path,
          'message': 'Path must be an absolute existing directory.',
        },
      );
    }
  }

  Future<void> _sendCommands(
    AcpAgentContext peer,
    ClaudeAcpSession session,
    List<claude.ClaudeCommandInfo> commands,
  ) async {
    final unsupported = <String>{
      'clear',
      'cost',
      'keybindings-help',
      'login',
      'logout',
      'output-style:new',
      'release-notes',
      'todos',
    };
    final update = SessionUpdate.fromJson(<String, Object?>{
      'sessionUpdate': 'available_commands_update',
      'availableCommands': <Object?>[
        for (final command in commands)
          if (!unsupported.contains(command.name))
            <String, Object?>{
              'name': command.name.endsWith(' (MCP)')
                  ? 'mcp:${command.name.substring(0, command.name.length - 6)}'
                  : command.name,
              'description': command.description,
              if (command.argumentHint case final hint?)
                'input': <String, Object?>{'hint': hint},
            },
      ],
    });
    await peer.updateSession(
      SessionNotification(sessionId: session.id, update: update),
    );
  }

  Future<claude.PermissionResult> _requestPermission(
    AcpAgentContext peer,
    SessionId sessionId,
    String name,
    claude.JsonMap input,
    claude.ToolPermissionContext permissionContext,
  ) async {
    final toolId =
        permissionContext.toolUseId ?? 'permission-${_idGenerator()}';
    final session = _sessions[sessionId];
    final parentToolUseId = permissionContext.agentId == null
        ? null
        : session?.parentToolUseIdForAgent(permissionContext.agentId!);
    if (session != null && !session.messageProjection.hasSurfacedTool(toolId)) {
      final block = claude.ToolUseBlock(id: toolId, name: name, input: input);
      session.messageProjection.recordTool(block);
      final plan = session.messageProjection.plan.start(block);
      final update = ClaudePlanProjector.isPlanTool(name)
          ? _messageProjector.tools.start(
              block,
              cwd: session.cwd,
              supportsTerminalOutput: peer.lifecycle.peerCapabilities.supports(
                'clientCapabilities.terminal',
              ),
            )
          : plan ??
                _messageProjector.tools.start(
                  block,
                  cwd: session.cwd,
                  supportsTerminalOutput: peer.lifecycle.peerCapabilities
                      .supports('clientCapabilities.terminal'),
                );
      final attributed = _withParentToolUseId(update, parentToolUseId);
      await peer.updateSession(
        SessionNotification(sessionId: sessionId, update: attributed),
      );
      session.messageProjection.surfaceTool(toolId);
    }
    if (name == 'AskUserQuestion' &&
        peer.lifecycle.peerCapabilities.supports(
          'clientCapabilities.elicitation.form',
        )) {
      return _requestAskUserQuestion(
        peer,
        sessionId,
        input,
        toolId,
        permissionContext.cancellation,
      );
    }
    try {
      final response = await peer.requestPermission(
        RequestPermissionRequest.fromJson(<String, Object?>{
          'sessionId': sessionId.value,
          'toolCall': <String, Object?>{
            'toolCallId': toolId,
            'title': permissionContext.title ?? name,
            'kind': _permissionKind(name),
            'status': 'pending',
            'rawInput': input,
            if (parentToolUseId != null)
              '_meta': <String, Object?>{
                'claudeCode': <String, Object?>{
                  'toolName': name,
                  'parentToolUseId': parentToolUseId,
                  'agentId': permissionContext.agentId,
                },
              },
          },
          'options': <Object?>[
            <String, Object?>{
              'optionId': 'allow-once',
              'name': 'Allow once',
              'kind': 'allow_once',
            },
            if (permissionContext.suppressAlwaysAllowRule != true)
              <String, Object?>{
                'optionId': 'allow-session',
                'name': _alwaysAllowLabel(name, permissionContext.suggestions),
                'kind': 'allow_always',
              },
            <String, Object?>{
              'optionId': 'reject',
              'name': 'Reject',
              'kind': 'reject_once',
            },
          ],
        }),
      );
      final outcome = response.outcome;
      if (outcome is RequestPermissionOutcomeSelected) {
        final selected = outcome.value.optionId.value;
        if (selected == 'allow-once') {
          return claude.PermissionAllowed(
            updatedInput: input,
            decisionClassification:
                claude.PermissionDecisionClassification.userTemporary,
          );
        }
        if (selected == 'allow-session') {
          return claude.PermissionAllowed(
            updatedInput: input,
            updatedPermissions: permissionContext.suggestions,
            decisionClassification:
                claude.PermissionDecisionClassification.userPermanent,
          );
        }
      }
      return const claude.PermissionDenied(
        message: 'User refused permission to run tool',
        decisionClassification:
            claude.PermissionDecisionClassification.userReject,
      );
    } on Object catch (error, stackTrace) {
      _logger.error(
        'Permission request failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const claude.PermissionDenied(
        message: 'Permission request was cancelled',
      );
    }
  }

  SessionUpdate _withParentToolUseId(
    SessionUpdate update,
    String? parentToolUseId,
  ) {
    if (parentToolUseId == null) return update;
    final json = update.toJson();
    final meta = json['_meta'];
    final metadata = meta is Map<Object?, Object?>
        ? <String, Object?>{
            for (final entry in meta.entries)
              if (entry.key is String) entry.key! as String: entry.value,
          }
        : <String, Object?>{};
    final rawClaude = metadata['claudeCode'];
    final claudeMetadata = rawClaude is Map<Object?, Object?>
        ? <String, Object?>{
            for (final entry in rawClaude.entries)
              if (entry.key is String) entry.key! as String: entry.value,
          }
        : <String, Object?>{};
    claudeMetadata['parentToolUseId'] = parentToolUseId;
    return SessionUpdate.fromJson(<String, Object?>{
      ...json,
      '_meta': <String, Object?>{...metadata, 'claudeCode': claudeMetadata},
    });
  }

  String _alwaysAllowLabel(
    String toolName,
    List<claude.PermissionUpdate> suggestions,
  ) {
    if (suggestions.isEmpty) return 'Always allow $toolName';
    final descriptions = <String>{};
    for (final suggestion in suggestions) {
      switch (suggestion) {
        case claude.AddPermissionRules(:final rules):
          descriptions.addAll(
            rules.map(
              (rule) => rule.ruleContent == null
                  ? rule.toolName
                  : '${rule.toolName}(${rule.ruleContent})',
            ),
          );
        case claude.AddPermissionDirectories(:final directories):
          descriptions.addAll(directories);
        default:
          break;
      }
    }
    return descriptions.isEmpty
        ? 'Always allow $toolName'
        : 'Always allow ${descriptions.join(', ')}';
  }

  Future<claude.PermissionResult> _requestAskUserQuestion(
    AcpAgentContext peer,
    SessionId sessionId,
    claude.JsonMap input,
    String toolId,
    claude.ControlCallbackCancellation? callbackCancellation,
  ) async {
    final request = _elicitationMapper.mapAskUserQuestion(
      input,
      sessionId: sessionId,
      toolCallId: toolId,
    );
    if (request == null) {
      return const claude.PermissionDenied(
        message: 'AskUserQuestion called with no valid questions.',
      );
    }
    final source = CancellationSource();
    if (callbackCancellation != null) {
      unawaited(
        callbackCancellation.whenCancelled.then(
          (_) => source.cancel('Claude cancelled the question'),
        ),
      );
    }
    try {
      final response = await peer.createElicitation(
        request,
        cancellationToken: source.token,
      );
      if (callbackCancellation?.isCancelled ?? false) {
        return const claude.PermissionDenied(
          message: 'Tool use was cancelled.',
          shouldInterrupt: true,
        );
      }
      return switch (_elicitationMapper.applyAskUserQuestionResponse(
        response,
        input,
      )) {
        ClaudeAskUserQuestionAnswered(:final updatedInput) =>
          claude.PermissionAllowed(updatedInput: updatedInput),
        ClaudeAskUserQuestionCancelled() => const claude.PermissionDenied(
          message: 'Tool use was cancelled.',
          shouldInterrupt: true,
        ),
      };
    } on Object catch (error, stackTrace) {
      if (!(callbackCancellation?.isCancelled ?? false)) {
        _logger.error(
          'AskUserQuestion elicitation failed',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return const claude.PermissionDenied(
        message: 'Could not present the question to the user.',
      );
    }
  }

  Future<claude.ClaudeElicitationResult> _requestMcpElicitation(
    AcpAgentContext peer,
    SessionId sessionId,
    claude.ClaudeElicitationRequest request,
    claude.ControlCallbackContext callbackContext, {
    required bool form,
    required bool url,
  }) async {
    if ((request.mode == claude.ClaudeElicitationMode.form && !form) ||
        (request.mode == claude.ClaudeElicitationMode.url && !url)) {
      return const claude.ClaudeElicitationResult.decline();
    }
    final mapped = _elicitationMapper.mapMcpRequest(
      request,
      sessionId: sessionId,
      idGenerator: _idGenerator,
    );
    if (mapped == null) {
      return const claude.ClaudeElicitationResult.decline();
    }
    final source = CancellationSource();
    unawaited(
      callbackContext.cancellation.whenCancelled.then(
        (_) => source.cancel('Claude cancelled the elicitation'),
      ),
    );
    try {
      final response = await peer.createElicitation(
        mapped,
        cancellationToken: source.token,
      );
      if (callbackContext.cancellation.isCancelled) {
        return const claude.ClaudeElicitationResult.cancel();
      }
      return _elicitationMapper.mapMcpResponse(response);
    } on Object catch (error, stackTrace) {
      if (callbackContext.cancellation.isCancelled) {
        return const claude.ClaudeElicitationResult.cancel();
      }
      _logger.error(
        'MCP elicitation failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const claude.ClaudeElicitationResult.decline();
    }
  }

  Future<claude.ClaudeUserDialogResult> _requestUserDialog(
    AcpAgentContext peer,
    SessionId sessionId,
    claude.ClaudeUserDialogRequest request,
    claude.ControlCallbackContext callbackContext,
  ) async {
    final mapped = _elicitationMapper.mapRefusalFallback(
      request,
      sessionId: sessionId,
    );
    if (mapped == null) {
      return const claude.ClaudeUserDialogResult.cancelled();
    }
    final source = CancellationSource();
    unawaited(
      callbackContext.cancellation.whenCancelled.then(
        (_) => source.cancel('Claude cancelled the dialog'),
      ),
    );
    try {
      final response = await peer.createElicitation(
        mapped,
        cancellationToken: source.token,
      );
      if (callbackContext.cancellation.isCancelled) {
        return const claude.ClaudeUserDialogResult.cancelled();
      }
      return _elicitationMapper.mapRefusalFallbackResponse(response);
    } on Object catch (error, stackTrace) {
      if (!callbackContext.cancellation.isCancelled) {
        _logger.error(
          'User dialog failed',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return const claude.ClaudeUserDialogResult.cancelled();
    }
  }

  String _permissionKind(String name) => switch (name) {
    'Read' => 'read',
    'Write' || 'Edit' || 'NotebookEdit' => 'edit',
    'Glob' || 'Grep' || 'WebSearch' => 'search',
    'WebFetch' => 'fetch',
    'Bash' || 'TaskOutput' => 'execute',
    'Task' ||
    'Agent' ||
    'TodoWrite' ||
    'TaskCreate' ||
    'TaskUpdate' ||
    'TaskList' ||
    'TaskGet' => 'think',
    'EnterPlanMode' || 'ExitPlanMode' => 'switch_mode',
    _ => 'other',
  };

  Future<PromptResponse> _prompt(
    AcpAgentRequestContext<PromptRequest> context,
  ) {
    final session = _requireSession(context.params.sessionId);
    return session.enqueue(() async {
      context.cancellationToken.throwIfCancelled();
      final registration = context.cancellationToken.register((_) {
        unawaited(
          session.cancel(
            grace: options.forceCancelGrace,
            onForced: () => _logger.error(
              'Claude did not yield after cancellation; forcing the ACP turn '
              'to settle as cancelled.',
            ),
          ),
        );
      });
      try {
        return await _runPrompt(
          peer: context.client,
          session: session,
          prompt: context.params.prompt,
          cancellationToken: context.cancellationToken,
        );
      } finally {
        registration.dispose();
      }
    });
  }

  Future<PromptResponse> _runPrompt({
    required AcpAgentContext peer,
    required ClaudeAcpSession session,
    required List<ContentBlock> prompt,
    CancellationToken? cancellationToken,
  }) async {
    cancellationToken?.throwIfCancelled();
    session.messageProjection.beginTurn();
    final mapped = _promptMapper.map(prompt, sessionId: session.id.value);
    final input = claude.UserInput(
      content: mapped.content,
      sessionId: mapped.sessionId,
      parentToolUseId: mapped.parentToolUseId,
      uuid: _idGenerator(),
    );
    final outcomeFuture = session.beginTurn();
    try {
      await session.client.sendStream(Stream<claude.UserInput>.value(input));
    } on Object catch (error, stackTrace) {
      session.failTurn(error, stackTrace);
      rethrow;
    }
    final outcome = await outcomeFuture;
    cancellationToken?.throwIfCancelled();
    final message = outcome.result;
    final stopReason = _stopReason(message);
    if (_isAuthenticationFailure(message, outcome.assistantError)) {
      throw JsonRpcRequestException.authenticationRequired(
        data: <String, Object?>{
          'message':
              message.errors?.join('\n') ??
              message.result ??
              'Claude authentication is required.',
        },
      );
    }
    if (message.isError &&
        stopReason != StopReason.maxTokens &&
        stopReason != StopReason.cancelled &&
        stopReason != StopReason.refusal) {
      throw JsonRpcRequestException.internalError(
        data: <String, Object?>{
          'message':
              message.errors?.join('\n') ??
              message.result ??
              'Claude turn failed.',
          if (outcome.assistantError case final error?)
            'errorKind': error.wireValue,
          'apiErrorStatus': ?message.apiErrorStatus,
        },
      );
    }
    await _updateSessionInfo(peer, session);
    return PromptResponse(stopReason: stopReason);
  }

  Future<void> _consumeSession(
    AcpAgentContext peer,
    ClaudeAcpSession session,
  ) async {
    try {
      await for (final envelope in session.client.receiveMessageEnvelopes()) {
        await _projectEnvelope(peer, session, envelope);
        session.observe(envelope);
      }
      session.failTurn(
        JsonRpcRequestException.internalError(
          data: const <String, Object?>{
            'message': 'Claude session ended before returning a turn result.',
          },
        ),
      );
    } on Object catch (error, stackTrace) {
      session.failTurn(error, stackTrace);
      if (session.client.isConnected) {
        _logger.error(
          'Claude session consumer failed',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _projectEnvelope(
    AcpAgentContext peer,
    ClaudeAcpSession session,
    claude.ClaudeMessageEnvelope envelope,
  ) async {
    final message = envelope.message;
    if (options.forwardSdkMessages ||
        session.shouldForwardSdkMessage(envelope.raw) ||
        options.sdkMessageFilters.any(
          (filter) => filter.matches(envelope.raw),
        )) {
      await peer.notify(
        claudeSdkMessageMethod,
        ClaudeSdkMessageNotification(
          sessionId: session.id,
          message: AcpJsonObject.fromObject(envelope.raw),
        ),
      );
    }
    if (!session.isBackgroundResult(envelope) &&
        (message is! claude.AssistantMessage ||
            !_isSyntheticLoginMessage(message))) {
      for (final update in _messageProjector.project(
        message,
        cwd: session.cwd,
        state: session.messageProjection,
        supportsTerminalOutput: peer.lifecycle.peerCapabilities.supports(
          'clientCapabilities.terminal',
        ),
        supportsSubagentTranscript:
            peer.lifecycle.peerCapabilities.supports(
              'clientCapabilities._meta.subagent-transcript',
            ) ||
            session.forwardSubagentText,
      )) {
        await peer.updateSession(
          SessionNotification(sessionId: session.id, update: update),
        );
      }
    }
    if (message is claude.ElicitationCompleteMessage &&
        peer.lifecycle.peerCapabilities.supports(
          'clientCapabilities.elicitation.url',
        )) {
      try {
        await peer.completeElicitation(
          CompleteElicitationNotification(
            elicitationId: ElicitationId(message.elicitationId),
          ),
        );
      } on Object catch (error, stackTrace) {
        _logger.error(
          'Could not complete URL elicitation',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    if (message is claude.CompactBoundaryMessage) {
      var used = 0;
      final size = session.messageProjection.contextWindowSize;
      try {
        final usage = await session.client.getContextUsage();
        used = usage.totalTokens;
      } on Object catch (error, stackTrace) {
        _logger.error(
          'Could not refresh context usage after compaction',
          error: error,
          stackTrace: stackTrace,
        );
      }
      await peer.updateSession(
        SessionNotification(
          sessionId: session.id,
          update: SessionUpdate.fromJson(<String, Object?>{
            'sessionUpdate': 'usage_update',
            'used': used,
            'size': size,
          }),
        ),
      );
    }
    final modeChanged = switch (message) {
      claude.RuntimeStatusMessage() => session.configuration.reconcileMode(
        message.permissionMode,
      ),
      _ => false,
    };
    if (modeChanged) {
      await peer.updateSession(
        SessionNotification(
          sessionId: session.id,
          update: SessionUpdate.fromJson(<String, Object?>{
            'sessionUpdate': 'current_mode_update',
            'currentModeId': session.configuration.mode.wireValue,
          }),
        ),
      );
    }
    final configurationChanged =
        modeChanged ||
        switch (message) {
          claude.FastModeStateMessage() =>
            session.configuration.reconcileFastMode(
              message.state,
              disabledReason: message.disabledReason,
            ),
          claude.ResultMessage() when !session.isBackgroundResult(envelope) =>
            session.configuration.reconcileFastMode(
              message.fastModeState,
              disabledReason: message.fastModeDisabledReason,
            ),
          claude.ModelRefusalFallbackMessage()
              when message.direction != 'revert' =>
            session.configuration.reconcileModel(message.fallbackModel),
          _ => false,
        };
    if (configurationChanged && message is claude.ModelRefusalFallbackMessage) {
      session.messageProjection.seedContextWindow(
        session.configuration.inferredContextWindow,
      );
    }
    if (configurationChanged) {
      await _sendConfiguration(peer, session);
    }
  }

  Future<void> _sendConfiguration(
    AcpAgentContext peer,
    ClaudeAcpSession session,
  ) => peer.updateSession(
    SessionNotification(
      sessionId: session.id,
      update: SessionUpdate.fromJson(<String, Object?>{
        'sessionUpdate': 'config_option_update',
        'configOptions': <Object?>[
          for (final option in session.configuration.options) option.toJson(),
        ],
      }),
    ),
  );

  Future<void> _updateSessionInfo(
    AcpAgentContext peer,
    ClaudeAcpSession session,
  ) async {
    try {
      final info = _sessionInfoLookup(session.id.value, directory: session.cwd);
      if (info == null) return;
      final title = _sanitizeTitle(info.customTitle ?? info.summary);
      if (title == session.title) return;
      session.title = title;
      await peer.updateSession(
        SessionNotification(
          sessionId: session.id,
          update: SessionUpdate.fromJson(<String, Object?>{
            'sessionUpdate': 'session_info_update',
            'title': title,
            'updatedAt': info.lastModified.toUtc().toIso8601String(),
          }),
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.error(
        'Could not refresh session metadata',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  StopReason _stopReason(claude.ResultMessage message) {
    if (message.terminalReason == 'aborted_streaming' ||
        message.terminalReason == 'aborted_tools') {
      return StopReason.cancelled;
    }
    if (message.subtype == 'error_max_turns' ||
        message.terminalReason == 'max_turns') {
      return StopReason.maxTurnRequests;
    }
    if (message.stopReason == 'max_tokens') return StopReason.maxTokens;
    if (message.stopReason == 'refusal') return StopReason.refusal;
    if (message.errors?.any((value) => value.toLowerCase().contains('refus')) ??
        false) {
      return StopReason.refusal;
    }
    return StopReason.endTurn;
  }

  Future<void> _replay(AcpAgentContext peer, ClaudeAcpSession session) async {
    final messages = claude.getSessionMessages(
      session.id.value,
      directory: session.cwd,
    );
    const codec = claude.MessageCodec();
    for (final historical in messages) {
      var payload = historical.message;
      if (payload is! Map<Object?, Object?>) continue;
      if (historical.type == 'assistant' && _isSyntheticLoginPayload(payload)) {
        continue;
      }
      if (historical.type == 'user') {
        final visible = stripClaudeLocalCommandMetadata(payload['content']);
        if (visible == null) continue;
        payload = <Object?, Object?>{...payload, 'content': visible};
      }
      final json = <String, Object?>{
        'type': historical.type,
        'uuid': historical.uuid,
        'session_id': historical.sessionId,
        'parent_tool_use_id': ?historical.parentToolUseId,
        'message': <String, Object?>{
          for (final entry in payload.entries)
            if (entry.key is String) entry.key! as String: entry.value,
        },
      };
      try {
        final decoded = codec.decode(json);
        if (decoded == null) continue;
        for (final update in _messageProjector.project(
          decoded,
          cwd: session.cwd,
          supportsSubagentTranscript:
              peer.lifecycle.peerCapabilities.supports(
                'clientCapabilities._meta.subagent-transcript',
              ) ||
              session.forwardSubagentText,
        )) {
          await peer.updateSession(
            SessionNotification(sessionId: session.id, update: update),
          );
        }
      } on claude.MessageParseException catch (error) {
        _logger.error('Skipped malformed session history', error: error);
      }
    }
  }

  ListSessionsResponse _listSessions(
    AcpAgentRequestContext<ListSessionsRequest> context,
  ) {
    final cursor = int.tryParse(context.params.cursor ?? '') ?? 0;
    final sessions = claude.listSessions(
      directory: context.params.cwd,
      limit: 50,
      offset: cursor,
    );
    return ListSessionsResponse(
      sessions: <SessionInfo>[
        for (final session in sessions)
          if (session.cwd case final cwd?)
            SessionInfo(
              sessionId: SessionId(session.sessionId),
              cwd: cwd,
              title: _sanitizeTitle(session.customTitle ?? session.summary),
              updatedAt: session.lastModified.toUtc().toIso8601String(),
            ),
      ],
      nextCursor: sessions.length == 50 ? '${cursor + 50}' : null,
    );
  }

  String _sanitizeTitle(String value) {
    final singleLine = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (singleLine.length <= 256) return singleLine;
    return singleLine.substring(0, 256);
  }

  bool _isAuthenticationFailure(
    claude.ResultMessage message,
    claude.AssistantMessageError? assistantError,
  ) {
    if (assistantError == claude.AssistantMessageError.authenticationFailed) {
      return true;
    }
    return <String>[
      ...?message.errors,
      ?message.result,
    ].any((value) => value.contains('Please run /login'));
  }

  bool _isSyntheticLoginMessage(claude.AssistantMessage message) =>
      message.model == '<synthetic>' &&
      message.content.length == 1 &&
      message.content.single is claude.TextBlock &&
      (message.content.single as claude.TextBlock).text.contains(
        'Please run /login',
      );

  bool _isSyntheticLoginPayload(Map<Object?, Object?> message) {
    final content = message['content'];
    if (message['model'] != '<synthetic>' ||
        content is! List<Object?> ||
        content.length != 1) {
      return false;
    }
    final block = content.single;
    return block is Map<Object?, Object?> &&
        block['type'] == 'text' &&
        block['text'] is String &&
        (block['text']! as String).contains('Please run /login');
  }

  Future<DeleteSessionResponse> _deleteSession(
    AcpAgentRequestContext<DeleteSessionRequest> context,
  ) async {
    final id = context.params.sessionId;
    final session = _sessions.remove(id);
    final directory = session?.cwd ?? _sessionInfoLookup(id.value)?.cwd;
    await session?.close();
    _sessionDelete(id.value, directory: directory);
    return DeleteSessionResponse();
  }

  Future<CloseSessionResponse> _closeSession(
    AcpAgentRequestContext<CloseSessionRequest> context,
  ) async {
    final session = _sessions.remove(context.params.sessionId);
    if (session == null) {
      throw JsonRpcRequestException.resourceNotFound(
        uri: context.params.sessionId.value,
      );
    }
    await session.close();
    return CloseSessionResponse();
  }

  Future<SetSessionModeResponse> _setMode(
    AcpAgentRequestContext<SetSessionModeRequest> context,
  ) async {
    final session = _requireSession(context.params.sessionId);
    final mode = claude.PermissionMode.values
        .where((value) => value.wireValue == context.params.modeId.value)
        .firstOrNull;
    if (mode == null ||
        !session.configuration.modes.availableModes.any(
          (value) => value.id.value == mode.wireValue,
        )) {
      throw JsonRpcRequestException.invalidParams();
    }
    await session.client.setPermissionMode(mode);
    session.configuration.mode = mode;
    return SetSessionModeResponse();
  }

  Future<SetSessionConfigOptionResponse> _setConfigOption(
    AcpAgentRequestContext<SetSessionConfigOptionRequest> context,
  ) async {
    final session = _requireSession(context.params.sessionId);
    final value = switch (context.params.variant) {
      SetSessionConfigOptionRequestValueId(:final value) => value.value,
      SetSessionConfigOptionRequestBoolean(:final value) => value,
    };
    try {
      await session.configuration.apply(
        context.params.configId.value,
        value,
        session.client,
      );
      if (context.params.configId.value == 'model') {
        session.messageProjection.seedContextWindow(
          session.configuration.inferredContextWindow,
        );
      }
    } on FormatException catch (error) {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{'message': error.message},
      );
    }
    return SetSessionConfigOptionResponse(
      configOptions: session.configuration.options,
    );
  }

  Future<void> _cancel(
    AcpAgentNotificationContext<CancelNotification> context,
  ) async {
    final session = _sessions[context.params.sessionId];
    if (session == null || !session.isActive) return;
    await session.cancel(
      grace: options.forceCancelGrace,
      onForced: () => _logger.error(
        'Claude did not yield after cancellation; forcing the ACP turn to '
        'settle as cancelled.',
      ),
    );
  }

  Future<ClaudeSteeringResponse> _steer(
    AcpAgentRequestContext<ClaudeSteeringRequest> context,
  ) async {
    final session = _requireSession(context.params.sessionId);
    final input = _promptMapper.map(
      context.params.prompt,
      sessionId: session.id.value,
    );
    if (session.isActive) {
      await session.client.sendStream(
        Stream<claude.UserInput>.value(
          claude.UserInput(
            content: input.content,
            sessionId: input.sessionId,
            parentToolUseId: input.parentToolUseId,
            uuid: _idGenerator(),
            priority: 'now',
          ),
        ),
      );
      return const ClaudeSteeringResponse(ClaudeSteeringOutcome.injected);
    }
    unawaited(
      session
          .enqueue(
            () => _runPrompt(
              peer: context.client,
              session: session,
              prompt: context.params.prompt,
            ),
          )
          .catchError((Object error, StackTrace stackTrace) {
            _logger.error(
              'Steered turn failed',
              error: error,
              stackTrace: stackTrace,
            );
            return PromptResponse(stopReason: StopReason.endTurn);
          }),
    );
    return const ClaudeSteeringResponse(ClaudeSteeringOutcome.startedNewTurn);
  }

  Future<unstable.ForkSessionResponse> _forkSession(
    AcpAgentRequestContext<unstable.ForkSessionRequest> context,
  ) async {
    if (!_sessions.containsKey(SessionId(context.params.sessionId.value)) &&
        _sessionInfoLookup(
              context.params.sessionId.value,
              directory: context.params.cwd,
            ) ==
            null) {
      throw JsonRpcRequestException.resourceNotFound(
        uri: context.params.sessionId.value,
      );
    }
    final session = await _open(
      peer: context.client,
      id: SessionId(_idGenerator()),
      cwd: context.params.cwd,
      additionalDirectories: context.params.additionalDirectories,
      mcpServers: <McpServer>[
        for (final server
            in context.params.mcpServers ?? const <unstable.McpServer>[])
          McpServer.fromJson(server.toJson()),
      ],
      meta: context.params.meta,
      resume: true,
      fork: true,
      resumeSessionId: context.params.sessionId.value,
    );
    return unstable.ForkSessionResponse.fromJson(<String, Object?>{
      'sessionId': session.id.value,
      'modes': session.configuration.modes.toJson(),
      'configOptions': <Object?>[
        for (final option in session.configuration.options) option.toJson(),
      ],
    });
  }

  unstable.ListProvidersResponse _listProviders(
    AcpAgentRequestContext<unstable.ListProvidersRequest> context,
  ) => unstable.ListProvidersResponse.fromJson(<String, Object?>{
    'providers': <Object?>[
      <String, Object?>{
        'providerId': 'main',
        'supported': <Object?>['anthropic', 'bedrock', 'vertex'],
        'required': false,
        if (_provider case final provider?)
          'current': <String, Object?>{
            'apiType': provider.apiType,
            'baseUrl': '${provider.baseUrl}',
          },
      },
    ],
  });

  unstable.SetProviderResponse _setProvider(
    AcpAgentRequestContext<unstable.SetProviderRequest> context,
  ) {
    final request = context.params;
    if (request.providerId.value != 'main') {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{'providerId': request.providerId.value},
      );
    }
    final meta = request.meta?.toObject();
    final claudeMeta = meta?['claudeCode'];
    final vertex = claudeMeta is Map<Object?, Object?>
        ? claudeMeta['vertex']
        : null;
    try {
      _provider = ClaudeProviderConfiguration(
        apiType: request.apiType.value,
        baseUrl: Uri.parse(request.baseUrl),
        headers: request.headers ?? const <String, String>{},
        vertexProjectId: vertex is Map<Object?, Object?>
            ? vertex['projectId'] as String?
            : null,
        vertexRegion: vertex is Map<Object?, Object?>
            ? vertex['region'] as String?
            : null,
      );
    } on Object catch (error) {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{'message': '$error'},
      );
    }
    return unstable.SetProviderResponse();
  }

  unstable.DisableProviderResponse _disableProvider(
    AcpAgentRequestContext<unstable.DisableProviderRequest> context,
  ) {
    if (context.params.providerId.value == 'main') {
      _provider = null;
    }
    return unstable.DisableProviderResponse();
  }

  ClaudeAcpSession _requireSession(SessionId id) {
    final session = _sessions[id];
    if (session == null) {
      throw JsonRpcRequestException.invalidParams(
        data: <String, Object?>{'sessionId': id.value},
      );
    }
    return session;
  }

  /// Closes every live session exactly once.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    final sessions = _sessions.values.toList(growable: false);
    _sessions.clear();
    await Future.wait(sessions.map((session) => session.close()));
  }

  /// Current time seam used by session metadata.
  DateTime get now => _clock();
}
