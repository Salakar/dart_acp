import 'package:dart_acp_sdk/experimental/v2.dart';
import 'package:test/test.dart';

Implementation _implementation(String name) =>
    Implementation(name: name, version: '1.0.0');

McpServer _stdioServer() => McpServerStdioVariant(
  McpServerStdio(name: 'stdio', command: AbsolutePath('/usr/bin/example-mcp')),
);

McpServer _httpServer() => McpServerHttpVariant(
  McpServerHttp(name: 'http', url: Uri.parse('https://example.test/mcp')),
);

Matcher _missing(String method, String path) =>
    isA<AcpV2CapabilityUnavailableException>()
        .having(
          (AcpV2CapabilityUnavailableException error) => error.method,
          'method',
          method,
        )
        .having(
          (AcpV2CapabilityUnavailableException error) => error.capabilityPath,
          'capabilityPath',
          path,
        );

Future<AcpV2DirectConnectionPair> _connect({
  required AgentCapabilities capabilities,
  void Function()? onNew,
  void Function()? onResume,
  void Function()? onPrompt,
}) {
  final agent =
      AcpV2AgentApp(
            implementation: _implementation('agent'),
            capabilities: capabilities,
          )
          .onNewSession((_) {
            onNew?.call();
            return NewSessionResponse(sessionId: SessionId('session-1'));
          })
          .onResumeSession((_) {
            onResume?.call();
            return ResumeSessionResponse();
          })
          .onPrompt((_) {
            onPrompt?.call();
            return PromptResponse();
          });
  final client = AcpV2ClientApp(
    implementation: _implementation('client'),
    capabilities: ClientCapabilities(),
  );
  return client.connectWith(agent);
}

ResumeSessionRequest _resume({
  List<AbsolutePath>? additionalDirectories,
  List<McpServer>? mcpServers,
}) => ResumeSessionRequest(
  sessionId: SessionId('session-1'),
  cwd: AbsolutePath('/workspace'),
  additionalDirectories: additionalDirectories,
  mcpServers: mcpServers,
);

ContentBlock _image() =>
    ContentBlockImage(ImageContent(data: '', mimeType: MediaType('image/png')));

ContentBlock _audio() =>
    ContentBlockAudio(AudioContent(data: '', mimeType: MediaType('audio/wav')));

ContentBlock _embeddedResource() => ContentBlockResource(
  EmbeddedResource(
    resource: EmbeddedResourceResourceTextResourceContents(
      TextResourceContents(
        text: 'context',
        uri: Uri.parse('file:///workspace/context.txt'),
      ),
    ),
  ),
);

void main() {
  group('v2 session setup capability gates', () {
    test('new rejects each unadvertised setup extension locally', () async {
      var calls = 0;
      final pair = await _connect(
        capabilities: AgentCapabilities(session: SessionCapabilities()),
        onNew: () => calls++,
      );
      final sessions = pair.client.agent.sessions;

      await expectLater(
        sessions
            .newSession(
              cwd: AbsolutePath('/workspace'),
              additionalDirectories: <AbsolutePath>[
                AbsolutePath('/workspace/extra'),
              ],
            )
            .start(),
        throwsA(
          _missing(
            'session/new',
            'agentCapabilities.session.additionalDirectories',
          ),
        ),
      );
      await expectLater(
        sessions
            .newSession(
              cwd: AbsolutePath('/workspace'),
              mcpServers: <McpServer>[_stdioServer()],
            )
            .start(),
        throwsA(_missing('session/new', 'agentCapabilities.session.mcp.stdio')),
      );
      await expectLater(
        sessions
            .newSession(
              cwd: AbsolutePath('/workspace'),
              mcpServers: <McpServer>[_httpServer()],
            )
            .start(),
        throwsA(_missing('session/new', 'agentCapabilities.session.mcp.http')),
      );

      expect(calls, 0);
      await pair.close();
    });

    test('resume rejects each unadvertised setup extension locally', () async {
      var calls = 0;
      final pair = await _connect(
        capabilities: AgentCapabilities(session: SessionCapabilities()),
        onResume: () => calls++,
      );
      final sessions = pair.client.agent.sessions;

      await expectLater(
        sessions.resume(
          _resume(
            additionalDirectories: <AbsolutePath>[
              AbsolutePath('/workspace/extra'),
            ],
          ),
        ),
        throwsA(
          _missing(
            'session/resume',
            'agentCapabilities.session.additionalDirectories',
          ),
        ),
      );
      await expectLater(
        sessions.resume(_resume(mcpServers: <McpServer>[_stdioServer()])),
        throwsA(
          _missing('session/resume', 'agentCapabilities.session.mcp.stdio'),
        ),
      );
      await expectLater(
        sessions.resume(_resume(mcpServers: <McpServer>[_httpServer()])),
        throwsA(
          _missing('session/resume', 'agentCapabilities.session.mcp.http'),
        ),
      );

      expect(calls, 0);
      await pair.close();
    });

    test('advertised setup extensions reach new and resume handlers', () async {
      var newCalls = 0;
      var resumeCalls = 0;
      final pair = await _connect(
        capabilities: AgentCapabilities(
          session: SessionCapabilities(
            additionalDirectories: SessionAdditionalDirectoriesCapabilities(),
            mcp: McpCapabilities(
              stdio: McpStdioCapabilities(),
              http: McpHttpCapabilities(),
            ),
          ),
        ),
        onNew: () => newCalls++,
        onResume: () => resumeCalls++,
      );
      final setupDirectories = <AbsolutePath>[AbsolutePath('/workspace/extra')];
      final setupServers = <McpServer>[_stdioServer(), _httpServer()];

      final created = await pair.client.agent.sessions
          .newSession(
            cwd: AbsolutePath('/workspace'),
            additionalDirectories: setupDirectories,
            mcpServers: setupServers,
          )
          .start();
      created.dispose();
      final resumed = await pair.client.agent.sessions.resume(
        _resume(
          additionalDirectories: setupDirectories,
          mcpServers: setupServers,
        ),
      );
      resumed.dispose();

      expect((newCalls, resumeCalls), (1, 1));
      await pair.close();
    });
  });

  group('v2 prompt content capability gates', () {
    test('rejects exact optional content variants before sending', () async {
      var promptCalls = 0;
      final pair = await _connect(
        capabilities: AgentCapabilities(session: SessionCapabilities()),
        onPrompt: () => promptCalls++,
      );
      final session = await pair.client.agent.sessions
          .newSession(cwd: AbsolutePath('/workspace'))
          .start();
      final cases = <(ContentBlock, String)>[
        (_image(), 'agentCapabilities.session.prompt.image'),
        (_audio(), 'agentCapabilities.session.prompt.audio'),
        (
          _embeddedResource(),
          'agentCapabilities.session.prompt.embeddedContext',
        ),
      ];

      for (final (block, path) in cases) {
        expect(
          () => session.prompt(content: <ContentBlock>[block]),
          throwsA(_missing('session/prompt', path)),
        );
      }

      expect(promptCalls, 0);
      session.dispose();
      await pair.close();
    });

    test('advertised optional content variants reach prompt handler', () async {
      var promptCalls = 0;
      final pair = await _connect(
        capabilities: AgentCapabilities(
          session: SessionCapabilities(
            prompt: PromptCapabilities(
              image: PromptImageCapabilities(),
              audio: PromptAudioCapabilities(),
              embeddedContext: PromptEmbeddedContextCapabilities(),
            ),
          ),
        ),
        onPrompt: () => promptCalls++,
      );
      final session = await pair.client.agent.sessions
          .newSession(cwd: AbsolutePath('/workspace'))
          .start();

      for (final block in <ContentBlock>[
        _image(),
        _audio(),
        _embeddedResource(),
      ]) {
        await session.prompt(content: <ContentBlock>[block]).accepted;
      }

      expect(promptCalls, 3);
      session.dispose();
      await pair.close();
    });
  });
}
