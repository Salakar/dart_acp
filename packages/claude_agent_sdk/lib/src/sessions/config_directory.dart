import 'dart:io';

import 'package:path/path.dart' as p;

/// Resolves Claude Code's configuration directory from [environment].
///
/// `CLAUDE_CONFIG_DIR` wins when set (or [override], which callers pass when a
/// configuration directory was named explicitly); otherwise the directory is
/// `.claude` under the user profile.
///
/// The profile comes from `HOME`, then `USERPROFILE`: Windows leaves `HOME`
/// unset, and without that second lookup the working directory below is the
/// only remaining answer — a guess that quietly sends session lookups wherever
/// the host application happened to be launched from. The Claude CLI resolves
/// the profile the same way, so this keeps the SDK reading the store the CLI
/// writes.
String claudeConfigDirectory(
  Map<String, String> environment, {
  String? override,
}) {
  final configured = override ?? environment['CLAUDE_CONFIG_DIR'];
  if (configured != null) return configured;
  return p.join(userProfileDirectory(environment), '.claude');
}

/// Resolves the user profile directory from [environment], for the files
/// Claude Code keeps beside its configuration directory (`~/.claude.json`).
///
/// See [claudeConfigDirectory] for why `USERPROFILE` is consulted.
String userProfileDirectory(Map<String, String> environment) =>
    environment['HOME'] ?? environment['USERPROFILE'] ?? Directory.current.path;
