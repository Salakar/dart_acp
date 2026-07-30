import 'package:claude_agent_sdk/claude_agent_sdk.dart' as claude;
import 'package:dart_acp_claude/dart_acp_claude.dart';
import 'package:test/test.dart';

void main() {
  test('decodes serializable SDK options from ACP session metadata', () {
    final options = ClaudeAcpSessionOptions.fromMeta(
      AcpJsonObject.fromObject(<String, Object?>{
        'additionalRoots': <Object?>['/legacy'],
        'claudeCode': <String, Object?>{
          'emitRawSDKMessages': <Object?>[
            <String, Object?>{
              'type': 'system',
              'subtype': 'status',
              'origin': 'peer',
            },
          ],
          'options': <String, Object?>{
            'resume': 'existing-session',
            'resumeSessionAt': 'assistant-message',
            'additionalDirectories': <Object?>['/sdk'],
            'tools': <Object?>['Read', 'Agent'],
            'agent': 'reviewer',
            'agents': <String, Object?>{
              'reviewer': <String, Object?>{
                'description': 'Reviews changes',
                'prompt': 'Review carefully',
                'tools': <Object?>['Read'],
                'effort': 'high',
                'background': true,
              },
            },
            'allowedTools': <Object?>['Read'],
            'disallowedTools': <Object?>['Bash'],
            'toolAliases': <String, Object?>{'Task': 'Agent'},
            'toolConfig': <String, Object?>{
              'askUserQuestion': <String, Object?>{'previewFormat': 'html'},
            },
            'systemPrompt': <String, Object?>{
              'type': 'preset',
              'preset': 'claude_code',
              'append': 'Be concise.',
            },
            'mcpServers': <String, Object?>{
              'docs': <String, Object?>{
                'type': 'http',
                'url': 'https://example.test/mcp',
                'tools': <Object?>[
                  <String, Object?>{
                    'name': 'lookup',
                    'permission_policy': 'always_allow',
                  },
                ],
              },
            },
            'strictMcpConfig': true,
            'planModeInstructions': 'Plan carefully.',
            'maxTurns': 12,
            'maxBudgetUsd': 1.5,
            'taskBudget': <String, Object?>{'total': 9000},
            'model': 'sonnet',
            'fallbackModel': 'haiku',
            'betas': <Object?>['context-1m-2025-08-07'],
            'settings': <String, Object?>{'model': 'configured'},
            'managedSettings': <String, Object?>{'cleanupPeriodDays': 7},
            'env': <String, Object?>{'TOKEN': 'value', 'REMOVE': null},
            'extraArgs': <String, Object?>{
              'future-flag': 'value',
              'boolean-flag': null,
            },
            'maxBufferSize': 1048576,
            'includeHookEvents': true,
            'forwardSubagentText': true,
            'promptSuggestions': true,
            'agentProgressSummaries': true,
            'settingSources': <Object?>['project', 'local'],
            'skills': <Object?>['review'],
            'plugins': <Object?>[
              <String, Object?>{
                'type': 'local',
                'path': '/plugin',
                'skipMcpDiscovery': true,
              },
            ],
            'thinking': <String, Object?>{
              'type': 'enabled',
              'budgetTokens': 4096,
            },
            'effort': 'high',
            'outputFormat': <String, Object?>{
              'type': 'json_schema',
              'schema': <String, Object?>{'type': 'object'},
            },
            'enableFileCheckpointing': true,
            'persistSession': false,
            'user': 'runner',
            'title': 'Review',
            'debug': true,
            'debugFile': '/tmp/debug.log',
          },
        },
      }),
    );

    expect(options.additionalRoots, <String>['/legacy']);
    expect(options.resume, 'existing-session');
    expect(options.resumeSessionAt, 'assistant-message');
    expect(options.additionalDirectories, <String>['/sdk']);
    expect(options.tools, isA<claude.ExplicitTools>());
    expect(options.agents, contains('reviewer'));
    expect(options.agents!['reviewer']!.runsInBackground, isTrue);
    expect(options.allowedTools, <String>['Read']);
    expect(options.disallowedTools, <String>['Bash']);
    expect(options.toolAliases, containsPair('Task', 'Agent'));
    expect(options.toolConfig!.questionPreviewFormat, isNotNull);
    expect(options.systemPrompt, isA<claude.ClaudeCodeSystemPrompt>());
    expect(options.mcpServers!['docs'], isA<claude.McpHttpServerConfig>());
    expect(options.strictMcpConfig, isTrue);
    expect(options.maxTurns, 12);
    expect(options.maxBudgetUsd, 1.5);
    expect(options.taskBudget!.totalTokens, 9000);
    expect(options.model, 'sonnet');
    expect(options.betas, <claude.SdkBeta>[claude.SdkBeta.context1m]);
    expect(options.inlineSettings, containsPair('model', 'configured'));
    expect(options.environment, containsPair('REMOVE', null));
    expect(options.extraArguments, containsPair('boolean-flag', null));
    expect(options.settingSources, <claude.SettingSource>[
      claude.SettingSource.project,
      claude.SettingSource.local,
    ]);
    expect(options.skills, isA<claude.NamedSkills>());
    expect(options.plugins!.single.skipMcpDiscovery, isTrue);
    expect(options.thinking, isA<claude.EnabledThinking>());
    expect(options.effort, claude.EffortLevel.high);
    expect(options.outputFormat, isNotNull);
    expect(options.enableFileCheckpointing, isTrue);
    expect(options.persistSession, isFalse);
    expect(options.user, 'runner');
    expect(options.title, 'Review');
    expect(options.emitRawSdkMessages, isA<List<ClaudeSdkMessageFilter>>());
  });

  test('supports legacy tool disabling and validates malformed metadata', () {
    final disabled = ClaudeAcpSessionOptions.fromMeta(
      AcpJsonObject.fromObject(<String, Object?>{'disableBuiltInTools': true}),
    );
    expect(disabled.disableBuiltInTools, isTrue);

    expect(
      () => ClaudeAcpSessionOptions.fromMeta(
        AcpJsonObject.fromObject(<String, Object?>{
          'claudeCode': <String, Object?>{
            'options': <String, Object?>{
              'agents': <String, Object?>{
                'bad': <String, Object?>{'description': 'missing prompt'},
              },
            },
          },
        }),
      ),
      throwsFormatException,
    );
  });

  test('decodes alternate presets, transports, agents, and full sandbox', () {
    final options = ClaudeAcpSessionOptions.fromMeta(
      AcpJsonObject.fromObject(<String, Object?>{
        'claudeCode': <String, Object?>{
          'emitRawSDKMessages': true,
          'options': <String, Object?>{
            'tools': <String, Object?>{
              'type': 'preset',
              'preset': 'claude_code',
            },
            'systemPrompt': <Object?>['First block', 'Second block'],
            'agents': <String, Object?>{
              'worker': <String, Object?>{
                'description': 'Does work',
                'prompt': 'Work carefully',
                'tools': <Object?>['Read'],
                'disallowedTools': <Object?>['Bash'],
                'model': 'haiku',
                'criticalSystemReminder_EXPERIMENTAL': 'Stay focused',
                'skills': <Object?>['review'],
                'memory': 'project',
                'mcpServers': <Object?>[
                  'shared',
                  <String, Object?>{
                    'inline': <String, Object?>{
                      'command': 'server',
                      'args': <Object?>['--stdio'],
                      'env': <String, Object?>{'KEY': 'value'},
                      'timeout': 1000,
                      'alwaysLoad': true,
                    },
                  },
                ],
                'initialPrompt': 'Begin',
                'maxTurns': 3,
                'background': false,
                'effort': 7,
                'permissionMode': 'plan',
                'observer': 'watcher',
                'observerMessage': 'Watch safety',
              },
            },
            'mcpServers': <String, Object?>{
              'events': <String, Object?>{
                'type': 'sse',
                'url': 'https://example.test/events',
                'headers': <String, Object?>{'X-Test': '1'},
                'timeout': 2000,
                'alwaysLoad': false,
              },
              'stdio': <String, Object?>{
                'command': 'server',
                'args': <Object?>['--stdio'],
                'env': <String, Object?>{'KEY': 'value'},
              },
            },
            'toolConfig': <String, Object?>{
              'askUserQuestion': <String, Object?>{'previewFormat': 'markdown'},
            },
            'skills': 'all',
            'thinking': <String, Object?>{
              'type': 'adaptive',
              'display': 'summarized',
            },
            'sandbox': <String, Object?>{
              'enabled': true,
              'failIfUnavailable': true,
              'autoAllowBashIfSandboxed': true,
              'excludedCommands': <Object?>['docker'],
              'allowUnsandboxedCommands': false,
              'network': <String, Object?>{
                'allowedDomains': <Object?>['allowed.test'],
                'deniedDomains': <Object?>['denied.test'],
                'allowManagedDomainsOnly': true,
                'strictAllowlist': true,
                'allowUnixSockets': <Object?>['/tmp/socket'],
                'allowAllUnixSockets': false,
                'allowLocalBinding': true,
                'allowMachLookup': <Object?>['com.example.*'],
                'httpProxyPort': 8080,
                'socksProxyPort': 1080,
                'tlsTerminate': <String, Object?>{
                  'caCertPath': '/cert',
                  'caKeyPath': '/key',
                },
              },
              'filesystem': <String, Object?>{
                'allowWrite': <Object?>['/write'],
                'denyWrite': <Object?>['/deny-write'],
                'denyRead': <Object?>['/deny-read'],
                'allowRead': <Object?>['/read'],
                'allowManagedReadPathsOnly': true,
                'disabled': false,
              },
              'credentials': <String, Object?>{
                'files': <Object?>[
                  <String, Object?>{'path': '/credentials'},
                ],
                'envVars': <Object?>[
                  <String, Object?>{
                    'name': 'TOKEN',
                    'mode': 'mask',
                    'injectHosts': <Object?>['api.example.test'],
                  },
                  <String, Object?>{'name': 'DENIED'},
                ],
                'allowPlaintextInject': false,
              },
              'ignoreViolations': <String, Object?>{
                'file': <Object?>['/cache'],
                'network': <Object?>['localhost'],
              },
              'enableWeakerNestedSandbox': true,
              'enableWeakerNetworkIsolation': true,
              'allowAppleEvents': false,
              'ripgrep': <String, Object?>{
                'command': 'rg',
                'args': <Object?>['--hidden'],
              },
              'bwrapPath': '/bin/bwrap',
              'socatPath': '/bin/socat',
            },
          },
        },
      }),
    );

    expect(options.emitRawSdkMessages, isTrue);
    expect(options.tools, isA<claude.ClaudeCodeTools>());
    expect(options.systemPrompt, isA<claude.BlockSystemPrompt>());
    final worker = options.agents!['worker']!;
    expect(worker.numericEffort, 7);
    expect(worker.mcpServers, hasLength(2));
    expect(worker.observer, 'watcher');
    expect(options.mcpServers!['events'], isA<claude.McpSseServerConfig>());
    expect(options.mcpServers!['stdio'], isA<claude.McpStdioServerConfig>());
    expect(options.skills, isA<claude.AllSkills>());
    expect(options.thinking, isA<claude.AdaptiveThinking>());
    expect(options.sandbox!.network!.strictAllowlist, isTrue);
    expect(options.sandbox!.filesystem!.allowedReadPaths, <String>['/read']);
    expect(options.sandbox!.credentials!.files, hasLength(1));
    expect(options.sandbox!.credentials!.environmentVariables, hasLength(2));
    expect(options.sandbox!.ripgrep!.command, 'rg');

    final disabled = ClaudeAcpSessionOptions.fromMeta(
      AcpJsonObject.fromObject(<String, Object?>{
        'claudeCode': <String, Object?>{
          'options': <String, Object?>{
            'thinking': <String, Object?>{'type': 'disabled'},
          },
        },
      }),
    );
    expect(disabled.thinking, isA<claude.DisabledThinking>());
  });

  test('rejects malformed values at every session-option boundary', () {
    ClaudeAcpSessionOptions parse(
      Object? options, {
      Object? rawMessages = false,
      Object? additionalRoots = const <Object?>[],
    }) => ClaudeAcpSessionOptions.fromMeta(
      AcpJsonObject.fromObject(<String, Object?>{
        'additionalRoots': additionalRoots,
        'claudeCode': <String, Object?>{
          'emitRawSDKMessages': rawMessages,
          'options': options,
        },
      }),
    );

    final malformed = <Object?>[
      <String, Object?>{
        'tools': <Object?>['Read', 1],
      },
      <String, Object?>{
        'tools': <String, Object?>{'type': 'future'},
      },
      <String, Object?>{
        'systemPrompt': <Object?>['valid', 1],
      },
      <String, Object?>{
        'systemPrompt': <String, Object?>{'type': 'future'},
      },
      <String, Object?>{
        'agents': <String, Object?>{
          'bad': <String, Object?>{
            'description': 'bad',
            'prompt': 'bad',
            'mcpServers': 'not-an-array',
          },
        },
      },
      <String, Object?>{
        'agents': <String, Object?>{
          'bad': <String, Object?>{
            'description': 'bad',
            'prompt': 'bad',
            'mcpServers': <Object?>[
              <String, Object?>{
                'one': <String, Object?>{'command': 'one'},
                'two': <String, Object?>{'command': 'two'},
              },
            ],
          },
        },
      },
      <String, Object?>{
        'mcpServers': <String, Object?>{
          'bad': <String, Object?>{
            'type': 'http',
            'url': 'https://example.test',
            'tools': 'not-an-array',
          },
        },
      },
      <String, Object?>{
        'toolConfig': <String, Object?>{
          'askUserQuestion': <String, Object?>{'previewFormat': 'future'},
        },
      },
      <String, Object?>{'betas': 'not-an-array'},
      <String, Object?>{
        'betas': <Object?>['future-beta'],
      },
      <String, Object?>{'settingSources': 'not-an-array'},
      <String, Object?>{
        'settingSources': <Object?>['future'],
      },
      <String, Object?>{'skills': 1},
      <String, Object?>{
        'skills': <Object?>['valid', 1],
      },
      <String, Object?>{
        'thinking': <String, Object?>{'type': 'adaptive', 'display': 'future'},
      },
      <String, Object?>{
        'thinking': <String, Object?>{'type': 'future'},
      },
      <String, Object?>{'effort': 'future'},
      <String, Object?>{
        'agents': <String, Object?>{
          'bad': <String, Object?>{
            'description': 'bad',
            'prompt': 'bad',
            'permissionMode': 'future',
          },
        },
      },
      <String, Object?>{
        'outputFormat': <String, Object?>{'type': 'future'},
      },
      <String, Object?>{'plugins': 'not-an-array'},
      <String, Object?>{
        'plugins': <Object?>[
          <String, Object?>{'type': 'remote', 'path': '/plugin'},
        ],
      },
      <String, Object?>{
        'sandbox': <String, Object?>{
          'credentials': <String, Object?>{
            'envVars': <Object?>[
              <String, Object?>{'name': 'TOKEN', 'mode': 'future'},
            ],
          },
        },
      },
      <String, Object?>{
        'taskBudget': <String, Object?>{'total': 'many'},
      },
      <String, Object?>{'maxTurns': 'many'},
      <String, Object?>{'maxBudgetUsd': 'much'},
      <String, Object?>{'debug': 'yes'},
      <String, Object?>{'model': 1},
      <String, Object?>{
        'toolAliases': <String, Object?>{'Read': 1},
      },
      <String, Object?>{
        'env': <String, Object?>{'KEY': 1},
      },
    ];
    for (final value in malformed) {
      expect(() => parse(value), throwsFormatException);
    }
    expect(() => parse(null, rawMessages: 'yes'), throwsFormatException);
    expect(() => parse(null, additionalRoots: 'root'), throwsFormatException);
    expect(
      () => parse(null, additionalRoots: <Object?>['/ok', 1]),
      throwsFormatException,
    );
    expect(() => parse('not-an-object'), throwsFormatException);
  });
}
