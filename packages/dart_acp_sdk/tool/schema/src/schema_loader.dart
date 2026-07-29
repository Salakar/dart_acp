import 'dart:convert';
import 'dart:io';

import 'json_schema.dart';
import 'sha256.dart';

/// One checked-in snapshot recorded in the schema manifest.
final class SnapshotEntry {
  /// Creates a snapshot entry.
  const SnapshotEntry({
    required this.source,
    required this.path,
    required this.sha256,
    required this.url,
  });

  /// The repository alias, `official` or `sdk`.
  final String source;

  /// Manifest-relative file path.
  final String path;

  /// Expected lowercase SHA-256 digest.
  final String sha256;

  /// Immutable provenance URL for the pinned commit.
  final String url;
}

/// Repository provenance stored in the schema manifest.
final class RepositorySnapshot {
  /// Creates repository provenance.
  const RepositorySnapshot({required this.repository, required this.commit});

  /// Canonical GitHub repository URL.
  final String repository;

  /// Exact 40-character Git commit.
  final String commit;
}

/// Parsed schema snapshot manifest.
final class SchemaManifest {
  /// Loads and validates a manifest from [file].
  factory SchemaManifest.load(File file) {
    final Object? decoded = jsonDecode(file.readAsStringSync());
    final root = _stringMap(decoded, file.path);
    final int formatVersion = _integer(root['formatVersion'], 'formatVersion');
    if (formatVersion != 1) {
      throw FormatException(
        'Unsupported schema manifest version $formatVersion',
      );
    }
    final official = _repository(root['official'], 'official');
    final sdk = _repository(root['sdk'], 'sdk');
    final Object? filesValue = root['files'];
    if (filesValue is! List<Object?>) {
      throw const FormatException('Manifest files must be an array');
    }
    final files = <SnapshotEntry>[];
    final paths = <String>{};
    for (int index = 0; index < filesValue.length; index += 1) {
      final map = _stringMap(filesValue[index], 'files[$index]');
      final entry = SnapshotEntry(
        source: _string(map['source'], 'files[$index].source'),
        path: _string(map['path'], 'files[$index].path'),
        sha256: _string(map['sha256'], 'files[$index].sha256'),
        url: _string(map['url'], 'files[$index].url'),
      );
      if (!paths.add(entry.path)) {
        throw FormatException('Duplicate manifest path ${entry.path}');
      }
      if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(entry.sha256)) {
        throw FormatException('Invalid SHA-256 for ${entry.path}');
      }
      files.add(entry);
    }
    return SchemaManifest._(
      formatVersion: formatVersion,
      official: official,
      sdk: sdk,
      files: files,
    );
  }

  SchemaManifest._({
    required this.formatVersion,
    required this.official,
    required this.sdk,
    required Iterable<SnapshotEntry> files,
  }) : files = List<SnapshotEntry>.unmodifiable(files);

  /// Manifest format version.
  final int formatVersion;

  /// Official protocol repository provenance.
  final RepositorySnapshot official;

  /// SDK repository provenance.
  final RepositorySnapshot sdk;

  /// Every checked-in snapshot.
  final List<SnapshotEntry> files;

  /// Finds one entry by manifest-relative [path].
  SnapshotEntry entry(String path) {
    for (final SnapshotEntry candidate in files) {
      if (candidate.path == path) {
        return candidate;
      }
    }
    throw StateError('Snapshot is not listed in the manifest: $path');
  }
}

/// A parsed method metadata document.
final class MethodMetadata {
  /// Parses method metadata for [sourceName].
  factory MethodMetadata.fromJson(Object? json, {required String sourceName}) {
    final root = _stringMap(json, sourceName);
    return MethodMetadata._(
      version: _integer(root['version'], '$sourceName.version'),
      agentMethods: _methodMap(root['agentMethods'], 'agentMethods'),
      clientMethods: _methodMap(root['clientMethods'], 'clientMethods'),
      protocolMethods: _methodMap(root['protocolMethods'], 'protocolMethods'),
    );
  }

  MethodMetadata._({
    required this.version,
    required this.agentMethods,
    required this.clientMethods,
    required this.protocolMethods,
  });

  /// Protocol version represented by the metadata.
  final int version;

  /// Methods implemented by the agent.
  final Map<String, String> agentMethods;

  /// Methods implemented by the client.
  final Map<String, String> clientMethods;

  /// Protocol-level methods either peer may receive.
  final Map<String, String> protocolMethods;

  /// Every metadata key and exact wire method, grouped by receiving side.
  Iterable<({String side, String dartKey, String method})> get methods sync* {
    for (final MapEntry<String, String> entry in agentMethods.entries) {
      yield (side: 'agent', dartKey: entry.key, method: entry.value);
    }
    for (final MapEntry<String, String> entry in clientMethods.entries) {
      yield (side: 'client', dartKey: entry.key, method: entry.value);
    }
    for (final MapEntry<String, String> entry in protocolMethods.entries) {
      yield (side: 'protocol', dartKey: entry.key, method: entry.value);
    }
  }
}

/// Loads and digest-checks schema snapshots from one package checkout.
final class SchemaLoader {
  /// Creates a loader rooted at `tool/schema`.
  SchemaLoader(Directory schemaToolRoot)
    : _root = schemaToolRoot,
      manifest = SchemaManifest.load(
        File('${schemaToolRoot.path}/schema_manifest.json'),
      );

  final Directory _root;

  /// The parsed snapshot manifest.
  final SchemaManifest manifest;

  /// Verifies every manifest file and returns its bytes by path.
  Map<String, List<int>> verifyAll() {
    final result = <String, List<int>>{};
    for (final SnapshotEntry entry in manifest.files) {
      final File file = File('${_root.path}/${entry.path}');
      if (!file.existsSync()) {
        throw StateError('Missing schema snapshot: ${entry.path}');
      }
      final List<int> bytes = file.readAsBytesSync();
      final String actual = sha256Hex(bytes);
      if (actual != entry.sha256) {
        throw StateError(
          'Schema digest mismatch for ${entry.path}: '
          'expected ${entry.sha256}, got $actual',
        );
      }
      result[entry.path] = bytes;
    }
    return Map<String, List<int>>.unmodifiable(result);
  }

  /// Loads one schema document after verifying its manifest digest.
  SchemaDocument loadSchema(String path) {
    final List<int> bytes = _verifiedBytes(path);
    return SchemaDocument.fromJson(
      jsonDecode(utf8.decode(bytes)),
      sourceName: path,
    );
  }

  /// Loads one method metadata document after digest verification.
  MethodMetadata loadMetadata(String path) {
    final List<int> bytes = _verifiedBytes(path);
    return MethodMetadata.fromJson(
      jsonDecode(utf8.decode(bytes)),
      sourceName: path,
    );
  }

  List<int> _verifiedBytes(String path) {
    final SnapshotEntry entry = manifest.entry(path);
    final File file = File('${_root.path}/$path');
    if (!file.existsSync()) {
      throw StateError('Missing schema snapshot: $path');
    }
    final List<int> bytes = file.readAsBytesSync();
    final String actual = sha256Hex(bytes);
    if (actual != entry.sha256) {
      throw StateError(
        'Schema digest mismatch for $path: '
        'expected ${entry.sha256}, got $actual',
      );
    }
    return bytes;
  }
}

RepositorySnapshot _repository(Object? value, String context) {
  final map = _stringMap(value, context);
  final String commit = _string(map['commit'], '$context.commit');
  if (!RegExp(r'^[0-9a-f]{40}$').hasMatch(commit)) {
    throw FormatException('Invalid commit in $context: $commit');
  }
  return RepositorySnapshot(
    repository: _string(map['repository'], '$context.repository'),
    commit: commit,
  );
}

Map<String, String> _methodMap(Object? value, String context) {
  final raw = _stringMap(value, context);
  final result = <String, String>{};
  final keys = raw.keys.toList(growable: false)..sort();
  for (final String key in keys) {
    result[key] = _string(raw[key], '$context.$key');
  }
  return Map<String, String>.unmodifiable(result);
}

Map<String, Object?> _stringMap(Object? value, String context) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException('Expected an object at $context');
  }
  final result = <String, Object?>{};
  for (final MapEntry<Object?, Object?> entry in value.entries) {
    final Object? key = entry.key;
    if (key is! String) {
      throw FormatException('Expected a string key at $context');
    }
    result[key] = entry.value;
  }
  return result;
}

String _string(Object? value, String context) {
  if (value is! String) {
    throw FormatException('Expected a string at $context');
  }
  return value;
}

int _integer(Object? value, String context) {
  if (value is! int) {
    throw FormatException('Expected an integer at $context');
  }
  return value;
}
