import 'dart:convert';
import 'dart:io';

import '../../packages/dart_acp_sdk/tool/schema/src/sha256.dart';

/// Pinned source revision represented by the reference-test matrix.
const String referenceTestSourceCommit =
    'f1c01412e2c3e081f13f343b9e6586c5a4759b8f';

/// SHA-256 of the ordered `file<NUL>line<NUL>title<LF>` source inventory.
const String referenceTestInventorySha256 =
    '504edb90b44b7fb40ba45620fcf7b74cc1c55e086a7cc0f48fd0aca1da82a895';

/// Expected direct `it(...)` declarations in the pinned source suite.
const int referenceTestCaseCount = 375;

/// Expected table-driven declarations recorded outside the direct-case count.
const int referenceParameterizedDeclarationCount = 7;

/// Expected concrete Dart-test references across direct source cases.
const int referenceTestTargetCount = 773;

/// Expected direct-case disposition totals.
const Map<String, int> referenceTestDispositionCounts = <String, int>{
  'dart_test': 301,
  'deprecated_wrapper': 49,
  'official_spec_wins': 25,
};

const Map<String, ({String blob, int cases})> _expectedSourceFiles =
    <String, ({String blob, int cases})>{
      'src/acp.test.ts': (
        blob: '796199d8c8b1c2f938bef780e519c8ae75b365d7',
        cases: 112,
      ),
      'src/connection.test.ts': (
        blob: 'f163ab1092cbd43f5d1ab7a7e12b01ff6a266018',
        cases: 17,
      ),
      'src/cookie-store.test.ts': (
        blob: 'c43068c6ffaaf8942c322b3cf4d0e393fc68cb75',
        cases: 8,
      ),
      'src/http-stream.test.ts': (
        blob: '1ae140f6f4b84ccfbc900352c615c43de66a54f1',
        cases: 31,
      ),
      'src/jsonrpc.test.ts': (
        blob: 'fb08dd4af0dc290f6f716deb942e57c966b9af7b',
        cases: 23,
      ),
      'src/line-buffer.test.ts': (
        blob: 'ddd38b5d7b897f088347790239149c3f79ab2f8d',
        cases: 6,
      ),
      'src/node-adapter.test.ts': (
        blob: 'b44292324ce6aa9f114ebb71f159a145c69fc34d',
        cases: 13,
      ),
      'src/protocol-router.test.ts': (
        blob: 'cb179336b15a563e4f84d632d0660d1fe75fc00f',
        cases: 15,
      ),
      'src/protocol.test.ts': (
        blob: '1192a433b6ce721091b3b674a0dee2f19a0ff3c6',
        cases: 8,
      ),
      'src/schema-deserialize.test.ts': (
        blob: '1b988424103475de4c8a88e866a2d220fdf1f86a',
        cases: 10,
      ),
      'src/server-permission.test.ts': (
        blob: 'b9c16fc42e905575bd23a841e6790b3c64b50f84',
        cases: 2,
      ),
      'src/server-session-sse.test.ts': (
        blob: 'e1af341a1ac5708877a5b53fa155fe8d338c1f1a',
        cases: 11,
      ),
      'src/server-sse.test.ts': (
        blob: '55098ef6df611cf640caf4da5a6181ba5ba258da',
        cases: 1,
      ),
      'src/server-websocket-upgrade.test.ts': (
        blob: 'ac096e36bd1820079105ac42e632b7d7f197a19b',
        cases: 23,
      ),
      'src/server.test.ts': (
        blob: 'cb41ec8207a3baf40d167dc0d9025ece91f4dfd4',
        cases: 36,
      ),
      'src/sse.test.ts': (
        blob: '49bc131118f5f21cfdd029ddcebfd80389fc3ecf',
        cases: 14,
      ),
      'src/stream.test.ts': (
        blob: 'a1d8ea1d377e5bb1d86a969ee10c3179c502f25b',
        cases: 14,
      ),
      'src/v2/acp.test.ts': (
        blob: '4ec569dab9cce966b51882653ce6385134e63b3e',
        cases: 12,
      ),
      'src/ws-stream.test.ts': (
        blob: 'c83411dfb33e5b4d04b887d6d0b6cc1050dc5483',
        cases: 17,
      ),
      'src/ws-utils.test.ts': (
        blob: 'af40e7f5e083ee9c035817faa9ce5e9596111674',
        cases: 2,
      ),
    };

const Set<String> _dispositionKinds = <String>{
  'dart_test',
  'deprecated_wrapper',
  'official_spec_wins',
};

const Set<String> _expectedParameterizedDeclarations = <String>{
  'src/jsonrpc.test.ts:25:'
      'JSON-RPC envelope validation > accepts valid JSON-RPC messages: %o',
  'src/jsonrpc.test.ts:42:'
      'JSON-RPC envelope validation > rejects malformed JSON-RPC messages: %o',
  'src/protocol-router.test.ts:166:'
      'AgentProtocolRouter > rejects a %s protocol version (%s)',
  'src/protocol-router.test.ts:266:'
      'AgentProtocolRouter > does not respond to a first %s',
  'src/server.test.ts:748:AcpServer > rejects %s requests',
  'src/server.test.ts:939:AcpServer > rejects POST with %s Content-Type',
  'src/server.test.ts:989:AcpServer > rejects invalid JSON-RPC messages',
};

/// Result of checking the committed reference-test evidence.
final class ReferenceTestMatrixResult {
  /// Creates a verification result.
  const ReferenceTestMatrixResult({
    required this.errors,
    required this.dispositionCounts,
    required this.targetCount,
  });

  /// Every detected integrity or target error.
  final List<String> errors;

  /// Direct-case counts keyed by disposition.
  final Map<String, int> dispositionCounts;

  /// Number of concrete Dart test references across direct cases.
  final int targetCount;

  /// Whether the matrix is complete and internally consistent.
  bool get isValid => errors.isEmpty;
}

/// Verifies the checked matrix without reading a source clone or the network.
ReferenceTestMatrixResult verifyReferenceTestMatrix({
  required Directory repositoryRoot,
  File? matrixFile,
}) {
  final errors = <String>[];
  final file =
      matrixFile ??
      File(
        '${repositoryRoot.path}${Platform.pathSeparator}tool'
        '${Platform.pathSeparator}reference_test_matrix.json',
      );
  Object? decoded;
  try {
    decoded = jsonDecode(file.readAsStringSync());
  } on Object catch (error) {
    return ReferenceTestMatrixResult(
      errors: <String>['Cannot decode ${file.path}: $error'],
      dispositionCounts: const <String, int>{},
      targetCount: 0,
    );
  }
  final root = _object(decoded, r'$', errors);
  if (root == null) {
    return ReferenceTestMatrixResult(
      errors: errors,
      dispositionCounts: const <String, int>{},
      targetCount: 0,
    );
  }

  _expect(root, 'schemaVersion', 1, r'$', errors);
  _expect(
    root,
    'sourceRepository',
    'https://github.com/agentclientprotocol/typescript-sdk',
    r'$',
    errors,
  );
  _expect(root, 'sourceCommit', referenceTestSourceCommit, r'$', errors);
  _expect(root, 'sourceFileCount', _expectedSourceFiles.length, r'$', errors);
  _expect(root, 'directCaseCount', referenceTestCaseCount, r'$', errors);
  _expect(
    root,
    'parameterizedDeclarationCount',
    referenceParameterizedDeclarationCount,
    r'$',
    errors,
  );
  _expect(
    root,
    'sourceInventorySha256',
    referenceTestInventorySha256,
    r'$',
    errors,
  );
  _verifySourceFiles(root['sourceFiles'], errors);

  final cases = _list(root['cases'], r'$.cases', errors);
  final counts = <String, int>{};
  var targetCount = 0;
  if (cases != null) {
    if (cases.length != referenceTestCaseCount) {
      errors.add(
        r'$.cases must contain '
        '$referenceTestCaseCount rows, found ${cases.length}',
      );
    }
    final keys = <String>{};
    final perFile = <String, int>{};
    final canonical = StringBuffer();
    String? previousSortKey;
    for (var index = 0; index < cases.length; index += 1) {
      final path = '\$.cases[$index]';
      final row = _object(cases[index], path, errors);
      if (row == null) {
        continue;
      }
      final source = _source(row['source'], '$path.source', errors);
      if (source == null) {
        continue;
      }
      final key =
          '${source.commit}|${source.file}:${source.line}|${source.title}';
      if (row['key'] != key) {
        errors.add('$path.key does not match its source tuple');
      }
      if (!keys.add(key)) {
        errors.add('$path duplicates source key $key');
      }
      final sortKey =
          '${source.file}\u0000'
          '${source.line.toString().padLeft(8, '0')}\u0000${source.title}';
      if (previousSortKey != null && sortKey.compareTo(previousSortKey) <= 0) {
        errors.add('$path is not in source-file/line/title order');
      }
      previousSortKey = sortKey;
      perFile.update(source.file, (value) => value + 1, ifAbsent: () => 1);
      canonical
        ..write(source.file)
        ..write('\u0000')
        ..write(source.line)
        ..write('\u0000')
        ..write(source.title)
        ..write('\n');
      final disposition = _object(
        row['disposition'],
        '$path.disposition',
        errors,
      );
      if (disposition != null) {
        final kind = disposition['kind'];
        if (kind is! String || !_dispositionKinds.contains(kind)) {
          errors.add('$path.disposition.kind is not an allowed disposition');
        } else {
          counts.update(kind, (value) => value + 1, ifAbsent: () => 1);
          targetCount += _verifyDisposition(
            disposition,
            kind: kind,
            path: '$path.disposition',
            repositoryRoot: repositoryRoot,
            sourceTitle: source.title,
            errors: errors,
          );
        }
      }
    }
    for (final entry in _expectedSourceFiles.entries) {
      if (perFile[entry.key] != entry.value.cases) {
        errors.add(
          'Source ${entry.key} must have ${entry.value.cases} direct rows, '
          'found ${perFile[entry.key] ?? 0}',
        );
      }
    }
    final digest = sha256Hex(utf8.encode(canonical.toString()));
    if (digest != referenceTestInventorySha256) {
      errors.add(
        'Direct source inventory digest is $digest, expected '
        '$referenceTestInventorySha256',
      );
    }
    for (final entry in referenceTestDispositionCounts.entries) {
      if (counts[entry.key] != entry.value) {
        errors.add(
          'Disposition ${entry.key} must contain ${entry.value} direct rows, '
          'found ${counts[entry.key] ?? 0}',
        );
      }
    }
    if (targetCount != referenceTestTargetCount) {
      errors.add(
        'Direct rows must contain $referenceTestTargetCount concrete Dart '
        'targets, found $targetCount',
      );
    }
  }

  _verifyParameterized(
    root['parameterizedDeclarations'],
    repositoryRoot: repositoryRoot,
    errors: errors,
  );
  return ReferenceTestMatrixResult(
    errors: List<String>.unmodifiable(errors),
    dispositionCounts: Map<String, int>.unmodifiable(counts),
    targetCount: targetCount,
  );
}

void _verifySourceFiles(Object? value, List<String> errors) {
  final rows = _list(value, r'$.sourceFiles', errors);
  if (rows == null) {
    return;
  }
  if (rows.length != _expectedSourceFiles.length) {
    errors.add(
      r'$.sourceFiles must contain '
      '${_expectedSourceFiles.length} rows, found ${rows.length}',
    );
  }
  final seen = <String>{};
  for (var index = 0; index < rows.length; index += 1) {
    final path = '\$.sourceFiles[$index]';
    final row = _object(rows[index], path, errors);
    if (row == null) {
      continue;
    }
    final sourcePath = row['file'];
    if (sourcePath is! String ||
        !_expectedSourceFiles.containsKey(sourcePath)) {
      errors.add('$path.file is not a pinned source test file');
      continue;
    }
    if (!seen.add(sourcePath)) {
      errors.add('$path.file duplicates $sourcePath');
    }
    final expected = _expectedSourceFiles[sourcePath]!;
    if (row['gitBlob'] != expected.blob) {
      errors.add('$path.gitBlob does not match the pinned Git object');
    }
    if (row['directCases'] != expected.cases) {
      errors.add('$path.directCases must be ${expected.cases}');
    }
  }
}

({String commit, String file, int line, String title})? _source(
  Object? value,
  String path,
  List<String> errors,
) {
  final source = _object(value, path, errors);
  if (source == null) {
    return null;
  }
  final commit = source['commit'];
  final file = source['file'];
  final line = source['line'];
  final title = source['test'];
  if (commit != referenceTestSourceCommit) {
    errors.add('$path.commit is not the pinned source commit');
  }
  if (file is! String || !_expectedSourceFiles.containsKey(file)) {
    errors.add('$path.file is not a pinned source test file');
  }
  if (line is! int || line <= 0) {
    errors.add('$path.line must be a positive integer');
  }
  if (title is! String || title.trim().isEmpty || !title.contains(' > ')) {
    errors.add('$path.test must be a nonempty nested test title');
  }
  if (commit is! String ||
      file is! String ||
      line is! int ||
      title is! String) {
    return null;
  }
  return (commit: commit, file: file, line: line, title: title);
}

int _verifyDisposition(
  Map<String, Object?> disposition, {
  required String kind,
  required String path,
  required Directory repositoryRoot,
  String? sourceTitle,
  required List<String> errors,
}) {
  final rationale = disposition['rationale'];
  if (rationale is! String || rationale.trim().length < 40) {
    errors.add('$path.rationale must explain the row-specific disposition');
  } else if (sourceTitle != null &&
      !rationale.contains(sourceTitle.split(' > ').last)) {
    errors.add('$path.rationale must name its exact source test');
  }
  if (kind == 'deprecated_wrapper') {
    final evidence = disposition['deprecationEvidence'];
    if (evidence is! String || !evidence.contains(':')) {
      errors.add('$path.deprecationEvidence must cite a source path and line');
    }
  }
  if (kind == 'official_spec_wins') {
    final reference = disposition['specReference'];
    if (reference is! String || reference.trim().isEmpty) {
      errors.add('$path.specReference must identify the governing rule');
    }
  }
  final targets = _list(disposition['targets'], '$path.targets', errors);
  if (targets == null) {
    return 0;
  }
  if (targets.isEmpty) {
    errors.add('$path.targets must name the selected current Dart behavior');
  }
  final seenTargets = <String>{};
  for (var index = 0; index < targets.length; index += 1) {
    final target = _verifyTarget(
      targets[index],
      path: '$path.targets[$index]',
      repositoryRoot: repositoryRoot,
      errors: errors,
    );
    if (target != null) {
      final key = '${target.file}\u0000${target.testId}';
      if (!seenTargets.add(key)) {
        errors.add('$path.targets[$index] duplicates $key');
      }
      if (rationale is String && !rationale.contains(target.testId)) {
        errors.add('$path.rationale must name target test ${target.testId}');
      }
    }
  }
  return targets.length;
}

({String file, String testId})? _verifyTarget(
  Object? value, {
  required String path,
  required Directory repositoryRoot,
  required List<String> errors,
}) {
  final target = _object(value, path, errors);
  if (target == null) {
    return null;
  }
  final relativeFile = target['file'];
  final testId = target['testId'];
  if (relativeFile is! String ||
      relativeFile.startsWith('/') ||
      relativeFile.contains('\\') ||
      relativeFile.split('/').contains('..') ||
      !relativeFile.startsWith('packages/dart_acp_sdk/test/') ||
      !relativeFile.endsWith('_test.dart')) {
    errors.add('$path.file must be a package test path');
    return null;
  }
  if (testId is! String || testId.trim().isEmpty) {
    errors.add('$path.testId must be a concrete Dart test title');
    return null;
  }
  final targetFile = File(
    '${repositoryRoot.path}${Platform.pathSeparator}'
    '${relativeFile.replaceAll('/', Platform.pathSeparator)}',
  );
  if (!targetFile.existsSync()) {
    errors.add('$path.file does not exist: $relativeFile');
    return null;
  }
  final titles = _DartTestTitleScanner(targetFile.readAsStringSync()).scan();
  final occurrences = titles.where((title) => title == testId).length;
  if (occurrences != 1) {
    errors.add(
      '$path.testId must occur exactly once in $relativeFile, found '
      '$occurrences: $testId',
    );
  }
  return (file: relativeFile, testId: testId);
}

void _verifyParameterized(
  Object? value, {
  required Directory repositoryRoot,
  required List<String> errors,
}) {
  final rows = _list(value, r'$.parameterizedDeclarations', errors);
  if (rows == null) {
    return;
  }
  if (rows.length != referenceParameterizedDeclarationCount) {
    errors.add(
      r'$.parameterizedDeclarations must contain '
      '$referenceParameterizedDeclarationCount rows, found ${rows.length}',
    );
  }
  final keys = <String>{};
  for (var index = 0; index < rows.length; index += 1) {
    final path = '\$.parameterizedDeclarations[$index]';
    final row = _object(rows[index], path, errors);
    if (row == null) {
      continue;
    }
    final source = _source(row['source'], '$path.source', errors);
    if (source == null) {
      continue;
    }
    final key = '${source.file}:${source.line}:${source.title}';
    if (!keys.add(key)) {
      errors.add('$path duplicates $key');
    }
    if (!_expectedParameterizedDeclarations.contains(key)) {
      errors.add('$path is not a pinned table-driven declaration: $key');
    }
    final disposition = _object(
      row['disposition'],
      '$path.disposition',
      errors,
    );
    if (disposition == null) {
      continue;
    }
    final kind = disposition['kind'];
    if (kind is! String || !_dispositionKinds.contains(kind)) {
      errors.add('$path.disposition.kind is not allowed');
    } else {
      _verifyDisposition(
        disposition,
        kind: kind,
        path: '$path.disposition',
        repositoryRoot: repositoryRoot,
        errors: errors,
      );
    }
  }
  for (final expected in _expectedParameterizedDeclarations.difference(keys)) {
    errors.add('Missing pinned table-driven declaration: $expected');
  }
}

void _expect(
  Map<String, Object?> object,
  String key,
  Object expected,
  String path,
  List<String> errors,
) {
  if (object[key] != expected) {
    errors.add('$path.$key must be $expected');
  }
}

Map<String, Object?>? _object(Object? value, String path, List<String> errors) {
  if (value is! Map<Object?, Object?>) {
    errors.add('$path must be an object');
    return null;
  }
  return value.map<String, Object?>(
    (Object? key, Object? entryValue) =>
        MapEntry<String, Object?>(key.toString(), entryValue),
  );
}

List<Object?>? _list(Object? value, String path, List<String> errors) {
  if (value is! List<Object?>) {
    errors.add('$path must be an array');
    return null;
  }
  return value;
}

final class _DartTestTitleScanner {
  _DartTestTitleScanner(this.source);

  final String source;
  var _index = 0;

  List<String> scan() {
    final result = <String>[];
    while (_index < source.length) {
      if (_skipComment()) {
        continue;
      }
      final skippedString = _readString();
      if (skippedString != null) {
        continue;
      }
      if (_isTestCall()) {
        _index += 4;
        _skipWhitespaceAndComments();
        _index += 1;
        _skipWhitespaceAndComments();
        final title = _readString();
        if (title != null) {
          result.add(title);
          continue;
        }
      }
      _index += 1;
    }
    return result;
  }

  bool _isTestCall() {
    if (!source.startsWith('test', _index)) {
      return false;
    }
    if (_index > 0) {
      final previous = source.codeUnitAt(_index - 1);
      if (_isIdentifier(previous) || previous == 46) {
        return false;
      }
    }
    final after = _index + 4;
    if (after < source.length && _isIdentifier(source.codeUnitAt(after))) {
      return false;
    }
    var cursor = after;
    while (cursor < source.length && _isWhitespace(source.codeUnitAt(cursor))) {
      cursor += 1;
    }
    return cursor < source.length && source.codeUnitAt(cursor) == 40;
  }

  void _skipWhitespaceAndComments() {
    while (_index < source.length) {
      if (_isWhitespace(source.codeUnitAt(_index))) {
        _index += 1;
        continue;
      }
      if (!_skipComment()) {
        return;
      }
    }
  }

  bool _skipComment() {
    if (source.startsWith('//', _index)) {
      final newline = source.indexOf('\n', _index + 2);
      _index = newline < 0 ? source.length : newline + 1;
      return true;
    }
    if (!source.startsWith('/*', _index)) {
      return false;
    }
    var depth = 1;
    _index += 2;
    while (_index < source.length && depth > 0) {
      if (source.startsWith('/*', _index)) {
        depth += 1;
        _index += 2;
      } else if (source.startsWith('*/', _index)) {
        depth -= 1;
        _index += 2;
      } else {
        _index += 1;
      }
    }
    return true;
  }

  String? _readString() {
    final start = _index;
    var raw = false;
    if (_index + 1 < source.length &&
        (source[_index] == 'r' || source[_index] == 'R') &&
        (source[_index + 1] == "'" || source[_index + 1] == '"')) {
      raw = true;
      _index += 1;
    }
    if (_index >= source.length ||
        (source[_index] != "'" && source[_index] != '"')) {
      _index = start;
      return null;
    }
    final quote = source[_index];
    final tripleQuote = '$quote$quote$quote';
    final triple = source.startsWith(tripleQuote, _index);
    final delimiter = triple ? tripleQuote : quote;
    _index += delimiter.length;
    final value = StringBuffer();
    while (_index < source.length) {
      if (source.startsWith(delimiter, _index)) {
        _index += delimiter.length;
        return value.toString();
      }
      final character = source[_index];
      if (!raw && character == r'\') {
        if (_index + 1 >= source.length) {
          break;
        }
        final escaped = source[_index + 1];
        value.write(switch (escaped) {
          'n' => '\n',
          'r' => '\r',
          't' => '\t',
          _ => escaped,
        });
        _index += 2;
      } else {
        value.write(character);
        _index += 1;
      }
    }
    _index = source.length;
    return null;
  }
}

bool _isIdentifier(int codeUnit) =>
    (codeUnit >= 48 && codeUnit <= 57) ||
    (codeUnit >= 65 && codeUnit <= 90) ||
    codeUnit == 95 ||
    codeUnit == 36 ||
    (codeUnit >= 97 && codeUnit <= 122);

bool _isWhitespace(int codeUnit) =>
    codeUnit == 9 || codeUnit == 10 || codeUnit == 13 || codeUnit == 32;
