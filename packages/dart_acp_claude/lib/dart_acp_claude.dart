/// An ACP-compatible coding agent powered by the Claude Agent SDK for Dart.
library;

export 'package:claude_agent_sdk/claude_agent_sdk.dart'
    show
        AgentDefinition,
        AgentMcpServer,
        BuiltinToolConfig,
        EffortLevel,
        HookEvent,
        HookMatcher,
        JsonSchemaOutputFormat,
        McpServerConfig,
        PermissionMode,
        SandboxSettings,
        SdkPluginConfig,
        SdkBeta,
        SettingSource,
        SkillsConfiguration,
        SystemPrompt,
        TaskBudget,
        ThinkingConfig,
        ToolConfiguration;
export 'package:dart_acp_sdk/dart_acp_sdk.dart';

export 'src/agent/claude_acp_agent.dart';
export 'src/application/extensions.dart';
export 'src/application/runtime.dart';
export 'src/client.dart';
export 'src/configuration/agent_options.dart';
export 'src/configuration/provider_configuration.dart';
export 'src/configuration/session_configuration.dart';
export 'src/configuration/session_options.dart';
export 'src/conversion/local_command_filter.dart';
export 'src/conversion/mcp_mapper.dart';
export 'src/conversion/message_projector.dart';
export 'src/conversion/plan_projector.dart';
export 'src/conversion/prompt_mapper.dart';
export 'src/conversion/tool_projector.dart';
export 'src/elicitation/elicitation_mapper.dart';
export 'src/runtime/cli.dart';
export 'src/runtime/contracts.dart';
