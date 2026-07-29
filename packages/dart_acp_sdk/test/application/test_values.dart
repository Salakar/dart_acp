import 'package:dart_acp_sdk/src/protocol/v1/generated/stable/models.dart';

Implementation implementation(String name) =>
    Implementation(name: name, version: '1.0.0');

ClientCapabilities clientCapabilities({
  bool readTextFile = false,
  bool writeTextFile = false,
  bool terminal = false,
}) => ClientCapabilities(
  fs: FileSystemCapabilities(
    readTextFile: readTextFile,
    writeTextFile: writeTextFile,
  ),
  terminal: terminal,
);

AgentCapabilities agentCapabilities({
  bool image = false,
  bool audio = false,
  bool embeddedContext = false,
  bool loadSession = false,
  bool mcpHttp = false,
  bool mcpSse = false,
  SessionCapabilities? sessions,
}) => AgentCapabilities(
  loadSession: loadSession,
  promptCapabilities: PromptCapabilities(
    image: image,
    audio: audio,
    embeddedContext: embeddedContext,
  ),
  mcpCapabilities: McpCapabilities(http: mcpHttp, sse: mcpSse),
  sessionCapabilities: sessions ?? SessionCapabilities(),
  auth: AgentAuthCapabilities(),
);
