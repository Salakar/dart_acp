import 'dart:io';

import 'package:claude_agent_sdk/src/sessions/config_directory.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('resolves the configuration directory under HOME', () {
    expect(
      claudeConfigDirectory(const {'HOME': '/home/user'}),
      p.join('/home/user', '.claude'),
    );
  });

  test('falls back to USERPROFILE when HOME is unset', () {
    // Windows never sets HOME, so this is the everyday path there — without it
    // the session store resolves against the working directory and every
    // lookup misses the transcripts the CLI actually wrote.
    expect(
      claudeConfigDirectory(const {'USERPROFILE': r'C:\Users\user'}),
      p.join(r'C:\Users\user', '.claude'),
    );
  });

  test('prefers HOME over USERPROFILE when both are set', () {
    expect(
      claudeConfigDirectory(const {
        'HOME': '/home/user',
        'USERPROFILE': r'C:\Users\user',
      }),
      p.join('/home/user', '.claude'),
    );
  });

  test('CLAUDE_CONFIG_DIR wins over the user profile', () {
    expect(
      claudeConfigDirectory(const {
        'CLAUDE_CONFIG_DIR': '/config',
        'HOME': '/home/user',
      }),
      '/config',
    );
  });

  test('an explicit override wins over the environment', () {
    expect(
      claudeConfigDirectory(const {
        'CLAUDE_CONFIG_DIR': '/config',
        'HOME': '/home/user',
      }, override: '/explicit'),
      '/explicit',
    );
  });

  test('falls back to the working directory with no profile at all', () {
    expect(
      claudeConfigDirectory(const {}),
      p.join(Directory.current.path, '.claude'),
    );
  });
}
