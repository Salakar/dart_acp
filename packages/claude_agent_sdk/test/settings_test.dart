import 'dart:convert';
import 'dart:io';

import 'package:claude_agent_sdk/claude_agent_sdk.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;
  late Directory user;
  late Directory project;
  late File managed;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('claude-settings-');
    user = await Directory('${root.path}/user').create();
    project = await Directory('${root.path}/project').create();
    managed = File('${root.path}/managed.json');
  });

  tearDown(() => root.delete(recursive: true));

  Future<void> write(File file, Map<String, Object?> value) async {
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(value));
  }

  test(
    'merges tiers, unions arrays, and gives managed policy priority',
    () async {
      await write(File('${user.path}/settings.json'), <String, Object?>{
        'model': 'user-model',
        'effortLevel': 'high',
        'availableModels': <Object?>['user-model', 'shared'],
        'modelOverrides': <String, Object?>{
          'user-model': 'provider-user-model',
        },
        'permissions': <String, Object?>{'defaultMode': 'dontAsk'},
      });
      await write(
        File('${project.path}/.claude/settings.json'),
        <String, Object?>{
          'model': 'project-model',
          'availableModels': <Object?>['shared', 'project-model'],
          'permissions': <String, Object?>{
            'defaultMode': 'bypassPermissions',
            'deny': <Object?>['Read(.env)'],
          },
        },
      );
      await write(
        File('${project.path}/.claude/settings.local.json'),
        <String, Object?>{
          'model': 'local-model',
          'permissions': <String, Object?>{'defaultMode': 'acceptEdits'},
        },
      );
      await write(managed, <String, Object?>{
        'env': <String, Object?>{'POLICY': 'enabled'},
      });

      final resolved = await resolveClaudeSettings(
        workingDirectory: project.path,
        userConfigDirectory: user.path,
        managedSettingsPath: managed.path,
        environment: const <String, String>{},
        operatingSystem: 'linux',
      );

      expect(resolved.model, 'local-model');
      expect(resolved.effortLevel, EffortLevel.high);
      expect(resolved.availableModels, <String>[
        'user-model',
        'shared',
        'project-model',
      ]);
      expect(resolved.defaultPermissionMode, 'acceptEdits');
      expect(resolved.modelOverrides, <String, String>{
        'user-model': 'provider-user-model',
      });
      expect((resolved.effective['permissions']! as Map)['deny'], <Object?>[
        'Read(.env)',
      ]);
      expect(resolved.environment, <String, String>{'POLICY': 'enabled'});
      expect(
        () => (resolved.effective['env']! as Map)['POLICY'] = 'changed',
        throwsUnsupportedError,
      );
    },
  );

  test('filters escalating project modes but preserves safe modes', () async {
    await write(
      File('${project.path}/.claude/settings.json'),
      <String, Object?>{
        'permissions': <String, Object?>{
          'defaultMode': 'auto',
          'allow': <Object?>['Read'],
        },
      },
    );
    final filtered = await resolveClaudeSettings(
      workingDirectory: project.path,
      userConfigDirectory: user.path,
      managedSettingsPath: managed.path,
      environment: const <String, String>{},
    );
    expect(filtered.defaultPermissionMode, isNull);
    expect((filtered.effective['permissions']! as Map)['allow'], <Object?>[
      'Read',
    ]);

    await write(
      File('${project.path}/.claude/settings.json'),
      <String, Object?>{
        'permissions': <String, Object?>{'defaultMode': 'plan'},
      },
    );
    final safe = await resolveClaudeSettings(
      workingDirectory: project.path,
      userConfigDirectory: user.path,
      managedSettingsPath: managed.path,
      environment: const <String, String>{},
    );
    expect(safe.defaultPermissionMode, 'plan');
  });

  test('reports raw cascade provenance and filters trust separately', () async {
    await write(File('${user.path}/settings.json'), <String, Object?>{
      'model': 'user-model',
    });
    await write(
      File('${project.path}/.claude/settings.json'),
      <String, Object?>{
        'permissions': <String, Object?>{'defaultMode': 'auto'},
      },
    );
    final resolved = await resolveSettings(
      workingDirectory: project.path,
      userConfigDirectory: user.path,
      managedSettingsPath: managed.path,
      environment: const <String, String>{},
      managedSettings: <String, Object?>{
        'model': 'must-be-dropped',
        'allowManagedMcpServersOnly': true,
        'permissions': <String, Object?>{
          'deny': <Object?>['Bash'],
          'allow': <Object?>['Read'],
        },
      },
    );

    expect(resolved.defaultPermissionMode, 'auto');
    expect(
      (filterEscalatingDefaultMode(resolved)['permissions']! as Map)
          .containsKey('defaultMode'),
      isFalse,
    );
    expect(resolved.model, 'user-model');
    expect(resolved.provenance['model']?.source, 'user');
    expect(resolved.sources.map((source) => source.source), [
      'user',
      'project',
      'managed',
    ]);
    final managedLayer = resolved.sources.last.settings;
    expect(managedLayer, isNot(contains('model')));
    expect(managedLayer['permissions'], <String, Object?>{
      'deny': <Object?>['Bash'],
    });
  });

  test('empty setting sources loads only managed policy', () async {
    await write(File('${user.path}/settings.json'), <String, Object?>{
      'model': 'ignored',
    });
    await write(managed, <String, Object?>{
      'env': <String, Object?>{'MANAGED': '1'},
    });
    final resolved = await resolveClaudeSettings(
      workingDirectory: project.path,
      settingSources: const <SettingSource>[],
      userConfigDirectory: user.path,
      managedSettingsPath: managed.path,
      environment: const <String, String>{},
    );
    expect(resolved.model, isNull);
    expect(resolved.environment['MANAGED'], '1');
  });

  test('reports malformed settings with their path', () async {
    final projectFile = File('${project.path}/.claude/settings.json');
    await projectFile.parent.create(recursive: true);
    await projectFile.writeAsString('{bad');
    await expectLater(
      resolveClaudeSettings(
        workingDirectory: project.path,
        userConfigDirectory: user.path,
        managedSettingsPath: managed.path,
        environment: const <String, String>{},
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains(projectFile.path),
        ),
      ),
    );
  });
}
