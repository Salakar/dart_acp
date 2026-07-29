import 'dart:convert';
import 'dart:io';

import '../../schema/src/sha256.dart';

part 'schema_verifier.dart';

typedef JsonMap = Map<String, Object?>;

/// Counts produced by a successful offline ACP specification audit.
final class SpecVerificationResult {
  const SpecVerificationResult({
    required this.indexPages,
    required this.protocolPages,
    required this.requirements,
    required this.schemaLanes,
    required this.schemaDefinitions,
    required this.schemaDeclarations,
    required this.schemaCodecCases,
    required this.schemaMethods,
    required this.indexDispositions,
    required this.requirementRationales,
  });

  final int indexPages;
  final int protocolPages;
  final int requirements;
  final int schemaLanes;
  final int schemaDefinitions;
  final int schemaDeclarations;
  final int schemaCodecCases;
  final int schemaMethods;
  final Map<String, int> indexDispositions;
  final Map<String, int> requirementRationales;

  /// A deterministic one-line report suitable for CI logs.
  String get summary {
    final String index = _formatCounts(indexDispositions);
    final String rules = _formatCounts(requirementRationales);
    return 'ACP spec evidence verified: '
        '$indexPages index pages ($index); '
        '$protocolPages protocol pages, $requirements requirements ($rules); '
        '$schemaLanes schema lanes, $schemaDefinitions definitions, '
        '$schemaDeclarations declarations, $schemaCodecCases codec cases, '
        '$schemaMethods methods.';
  }
}

/// Verifies the checked ACP documentation and schema evidence without network.
final class SpecEvidenceVerifier {
  SpecEvidenceVerifier(Directory packageRoot)
    : packageRoot = packageRoot.absolute;

  final Directory packageRoot;

  SpecVerificationResult verify() {
    final JsonMap catalog = _readMap('tool/spec/index_catalog.json');
    final JsonMap sources = _readMap('tool/spec/page_sources.json');
    final JsonMap anchors = _readMap('tool/spec/anchors.json');
    final JsonMap v1 = _readMap('tool/spec/requirements_v1.json');
    final JsonMap v2 = _readMap('tool/spec/requirements_v2.json');

    final ({Set<String> tracedUrls, Map<String, int> dispositions}) index =
        _verifyIndex(catalog);
    final Map<String, JsonMap> sourcePages = _verifyPageSources(
      sources,
      index.tracedUrls,
    );
    final ({
      Map<String, JsonMap> implementations,
      Map<String, JsonMap> tests,
      Map<String, String> rationales,
    })
    resolvedAnchors = _verifyAnchors(anchors);
    final ({
      int count,
      Map<String, int> rationales,
      Map<String, JsonMap> schemaDelegates,
    })
    requirements = _verifyRequirements(
      <JsonMap>[v1, v2],
      sourcePages,
      resolvedAnchors.implementations,
      resolvedAnchors.tests,
      resolvedAnchors.rationales,
    );
    final ({
      int lanes,
      int definitions,
      int declarations,
      int codecCases,
      int methods,
    })
    schema = _verifySchema(anchors, requirements.schemaDelegates);

    return SpecVerificationResult(
      indexPages: _integer(catalog['pageCount'], 'catalog.pageCount'),
      protocolPages: sourcePages.length,
      requirements: requirements.count,
      schemaLanes: schema.lanes,
      schemaDefinitions: schema.definitions,
      schemaDeclarations: schema.declarations,
      schemaCodecCases: schema.codecCases,
      schemaMethods: schema.methods,
      indexDispositions: Map<String, int>.unmodifiable(index.dispositions),
      requirementRationales: Map<String, int>.unmodifiable(
        requirements.rationales,
      ),
    );
  }

  ({Set<String> tracedUrls, Map<String, int> dispositions}) _verifyIndex(
    JsonMap catalog,
  ) {
    _expect(catalog['formatVersion'] == 1, 'catalog formatVersion must be 1');
    final File snapshot = _file('tool/spec/snapshots/llms.txt');
    _expect(snapshot.existsSync(), 'missing ${snapshot.path}');
    final List<int> bytes = snapshot.readAsBytesSync();
    final String text = utf8.decode(bytes);

    _expect(
      sha256Hex(bytes) == _string(catalog['sourceSha256'], 'sourceSha256'),
      'llms.txt digest does not match index_catalog.json',
    );
    _expect(
      bytes.length == _integer(catalog['sourceByteCount'], 'sourceByteCount'),
      'llms.txt byte count does not match index_catalog.json',
    );
    _expect(
      '\n'.allMatches(text).length ==
          _integer(catalog['sourceLineCount'], 'sourceLineCount'),
      'llms.txt line count does not match index_catalog.json',
    );

    final RegExp linkPattern = RegExp(
      r'^- \[[^\]]+\]\((https://agentclientprotocol\.com/[^)]+)\)'
      r'(?:: .*)?$',
      multiLine: true,
    );
    final List<String> snapshotUrls = linkPattern
        .allMatches(text)
        .map((RegExpMatch match) => match.group(1)!)
        .toList(growable: false);
    final List<Object?> rows = _list(catalog['rows'], 'catalog.rows');
    _expect(
      rows.length == _integer(catalog['pageCount'], 'catalog.pageCount'),
      'catalog page count does not match its rows',
    );
    _expect(
      snapshotUrls.length == rows.length,
      'catalog does not contain every llms.txt page',
    );

    final JsonMap rationales = _map(
      catalog['rationales'],
      'catalog.rationales',
    );
    final Set<String> seen = <String>{};
    final Set<String> traced = <String>{};
    final Map<String, int> dispositions = <String, int>{};
    for (int index = 0; index < rows.length; index += 1) {
      final JsonMap row = _map(rows[index], 'catalog.rows[$index]');
      final String url = _string(row['url'], 'catalog.rows[$index].url');
      _expect(url == snapshotUrls[index], 'catalog order differs at $url');
      _expect(seen.add(url), 'duplicate catalog URL $url');
      final String disposition = _string(
        row['disposition'],
        'catalog.rows[$index].disposition',
      );
      final String rationaleId = _string(
        row['rationaleId'],
        'catalog.rows[$index].rationaleId',
      );
      final String rationale = _string(
        rationales[rationaleId],
        'catalog.rationales.$rationaleId',
      );
      _expect(
        disposition == rationaleId,
        '$url disposition and rationaleId differ',
      );
      _expect(
        !rationale.toLowerCase().contains('unexplained'),
        '$url has an unexplained rationale',
      );
      dispositions.update(
        disposition,
        (int value) => value + 1,
        ifAbsent: () => 1,
      );
      if (disposition == 'traced') {
        _expect(
          url.contains('/protocol/v1/') || url.contains('/protocol/v2/'),
          'non-protocol catalog page marked traced: $url',
        );
        traced.add(url);
      } else {
        _expect(
          !url.contains('/protocol/v1/') && !url.contains('/protocol/v2/'),
          'protocol catalog page is not traced: $url',
        );
      }
    }
    _expect(traced.length == 38, 'expected 38 traced protocol pages');
    return (tracedUrls: traced, dispositions: dispositions);
  }

  Map<String, JsonMap> _verifyPageSources(
    JsonMap sources,
    Set<String> tracedUrls,
  ) {
    _expect(sources['formatVersion'] == 1, 'source formatVersion must be 1');
    _expect(
      _isSha256(_string(sources['sourceSha256'], 'sources.sourceSha256')),
      'invalid llms-full.txt digest',
    );
    _expect(
      _integer(sources['sourceLineCount'], 'sources.sourceLineCount') > 0,
      'llms-full.txt line count must be positive',
    );
    _expect(
      _integer(sources['sourceByteCount'], 'sources.sourceByteCount') > 0,
      'llms-full.txt byte count must be positive',
    );

    final List<Object?> rows = _list(sources['pages'], 'sources.pages');
    _expect(
      rows.length == _integer(sources['pageCount'], 'sources.pageCount'),
      'page_sources pageCount does not match pages',
    );
    final Map<String, JsonMap> pages = <String, JsonMap>{};
    var previousEnd = 0;
    for (int index = 0; index < rows.length; index += 1) {
      final JsonMap row = _map(rows[index], 'sources.pages[$index]');
      final String url = _string(row['url'], 'sources.pages[$index].url');
      _expect(pages[url] == null, 'duplicate page source $url');
      _expect(
        _isSha256(_string(row['sha256'], '$url.sha256')),
        '$url bad hash',
      );
      final int start = _integer(row['startLine'], '$url.startLine');
      final int end = _integer(row['endLine'], '$url.endLine');
      final int headings = _integer(row['headingCount'], '$url.headingCount');
      _expect(start > previousEnd, '$url line range overlaps prior page');
      _expect(end >= start, '$url line range is reversed');
      _expect(headings > 0, '$url must record at least one heading');
      previousEnd = end;
      pages[url] = row;
    }
    _expect(
      pages.keys.toSet().containsAll(tracedUrls) &&
          tracedUrls.containsAll(pages.keys),
      'page_sources and traced catalog URLs differ',
    );
    return pages;
  }

  ({
    Map<String, JsonMap> implementations,
    Map<String, JsonMap> tests,
    Map<String, String> rationales,
  })
  _verifyAnchors(JsonMap anchors) {
    _expect(anchors['formatVersion'] == 1, 'anchor formatVersion must be 1');
    final JsonMap authority = _map(anchors['authority'], 'authority');
    for (final String key in <String>[
      'behavior',
      'wireShape',
      'conflictPolicy',
    ]) {
      _string(authority[key], 'authority.$key');
    }

    final JsonMap rationaleValues = _map(
      anchors['rationales'],
      'anchors.rationales',
    );
    final Map<String, String> rationales = <String, String>{};
    for (final MapEntry<String, Object?> entry in rationaleValues.entries) {
      final String value = _string(entry.value, 'rationales.${entry.key}');
      _expect(
        !value.toLowerCase().contains('unexplained'),
        '${entry.key} is unexplained',
      );
      rationales[entry.key] = value;
    }

    final JsonMap implementationValues = _map(
      anchors['implementationAnchors'],
      'implementationAnchors',
    );
    final Map<String, JsonMap> implementations = <String, JsonMap>{};
    for (final MapEntry<String, Object?> entry
        in implementationValues.entries) {
      final JsonMap anchor = _map(entry.value, entry.key);
      final List<String> paths = _strings(
        anchor['paths'],
        '${entry.key}.paths',
      );
      _expect(paths.isNotEmpty, '${entry.key} has no implementation paths');
      for (final String path in paths) {
        _expect(_file(path).existsSync(), '${entry.key} missing $path');
      }
      implementations[entry.key] = anchor;
    }

    final JsonMap testValues = _map(anchors['testAnchors'], 'testAnchors');
    final Map<String, JsonMap> tests = <String, JsonMap>{};
    final Map<String, String> testSources = <String, String>{};
    for (final MapEntry<String, Object?> entry in testValues.entries) {
      final JsonMap anchor = _map(entry.value, entry.key);
      final String path = _string(anchor['path'], '${entry.key}.path');
      final String needle = _string(anchor['needle'], '${entry.key}.needle');
      final File file = _file(path);
      _expect(file.existsSync(), '${entry.key} missing $path');
      final String source = testSources.putIfAbsent(
        path,
        file.readAsStringSync,
      );
      _expect(
        source.contains(needle),
        '${entry.key} missing test ID "$needle"',
      );
      tests[entry.key] = anchor;
    }
    return (
      implementations: implementations,
      tests: tests,
      rationales: rationales,
    );
  }

  ({
    int count,
    Map<String, int> rationales,
    Map<String, JsonMap> schemaDelegates,
  })
  _verifyRequirements(
    List<JsonMap> matrices,
    Map<String, JsonMap> sourcePages,
    Map<String, JsonMap> implementations,
    Map<String, JsonMap> tests,
    Map<String, String> rationaleDefinitions,
  ) {
    final Set<String> seenPages = <String>{};
    final Set<String> seenRequirements = <String>{};
    final Map<String, int> rationales = <String, int>{};
    final Map<String, JsonMap> schemaDelegates = <String, JsonMap>{};
    var requirementCount = 0;

    for (final JsonMap matrix in matrices) {
      _expect(matrix['formatVersion'] == 1, 'requirement formatVersion != 1');
      final int version = _integer(
        matrix['protocolVersion'],
        'protocolVersion',
      );
      final List<Object?> pages = _list(matrix['pages'], 'v$version.pages');
      _expect(
        pages.length == _integer(matrix['pageCount'], 'v$version.pageCount'),
        'v$version pageCount does not match pages',
      );
      for (int pageIndex = 0; pageIndex < pages.length; pageIndex += 1) {
        final JsonMap page = _map(
          pages[pageIndex],
          'v$version.pages[$pageIndex]',
        );
        final String url = _string(page['url'], 'page.url');
        _expect(url.contains('/protocol/v$version/'), '$url in wrong matrix');
        _expect(seenPages.add(url), 'duplicate requirement page $url');
        final JsonMap? source = sourcePages[url];
        _expect(source != null, '$url has no live page source evidence');

        final List<String> implementationIds = _strings(
          page['implementationIds'],
          '$url.implementationIds',
        );
        final List<String> testIds = _strings(page['testIds'], '$url.testIds');
        _expect(
          implementationIds.isNotEmpty,
          '$url has no implementation anchors',
        );
        _expect(testIds.isNotEmpty, '$url has no test anchors');
        for (final String id in implementationIds) {
          _expect(implementations.containsKey(id), '$url unknown impl ID $id');
        }
        for (final String id in testIds) {
          _expect(tests.containsKey(id), '$url unknown test ID $id');
        }

        final List<Object?> rules = _list(
          page['requirements'],
          '$url.requirements',
        );
        _expect(rules.isNotEmpty, '$url has no requirement rows');
        final List<String> coveredSections = <String>[];
        for (int ruleIndex = 0; ruleIndex < rules.length; ruleIndex += 1) {
          final JsonMap rule = _map(
            rules[ruleIndex],
            '$url.requirements[$ruleIndex]',
          );
          final String id = _string(rule['id'], '$url.requirement.id');
          _expect(id.startsWith('v$version.'), '$id has wrong version prefix');
          _expect(seenRequirements.add(id), 'duplicate requirement ID $id');
          final String summary = _string(rule['summary'], '$id.summary');
          _expect(
            !summary.toLowerCase().contains('unexplained') &&
                !summary.contains('TODO'),
            '$id has an unexplained summary',
          );
          final String rationaleId = _string(
            rule['rationaleId'],
            '$id.rationaleId',
          );
          _expect(
            rationaleDefinitions.containsKey(rationaleId),
            '$id unknown rationale $rationaleId',
          );
          rationales.update(
            rationaleId,
            (int value) => value + 1,
            ifAbsent: () => 1,
          );
          if (page['schemaDelegate'] == null) {
            final List<String> sections = _strings(
              rule['sections'],
              '$id.sections',
            );
            _expect(sections.isNotEmpty, '$id has no audited sections');
            coveredSections.addAll(sections);
          } else {
            _expect(rule['sections'] == null, '$id must delegate schema rows');
          }
          requirementCount += 1;
        }

        if (page['schemaDelegate'] != null) {
          _expect(
            url.endsWith('/schema.md'),
            '$url delegates schema outside schema page',
          );
          final JsonMap delegate = _map(
            page['schemaDelegate'],
            '$url.schemaDelegate',
          );
          _expect(
            _strings(delegate['lanes'], '$url.schemaDelegate.lanes').isNotEmpty,
            '$url delegates no schema lanes',
          );
          schemaDelegates[url] = delegate;
        } else {
          final List<String> headings = _strings(
            page['headings'],
            '$url.headings',
          );
          _expect(
            headings.length ==
                _integer(source!['headingCount'], '$url.headingCount'),
            '$url headings do not match live heading count',
          );
          _expect(
            _sameMultiset(headings, coveredSections),
            '$url headings are missing or duplicated in rules',
          );
        }
      }
    }
    _expect(
      seenPages.length == sourcePages.length &&
          seenPages.containsAll(sourcePages.keys),
      'requirement matrices do not cover all live protocol pages',
    );
    return (
      count: requirementCount,
      rationales: rationales,
      schemaDelegates: schemaDelegates,
    );
  }

  JsonMap _readMap(String relativePath) =>
      _decodeMap(_file(relativePath), relativePath);

  JsonMap _decodeMap(File file, String context) {
    _expect(file.existsSync(), 'missing ${file.path}');
    return _map(jsonDecode(file.readAsStringSync()), context);
  }

  File _file(String relativePath) => File('${packageRoot.path}/$relativePath');
}

JsonMap _map(Object? value, String context) {
  if (value is! Map<Object?, Object?>) {
    throw StateError('$context must be an object');
  }
  final JsonMap result = <String, Object?>{};
  for (final MapEntry<Object?, Object?> entry in value.entries) {
    if (entry.key is! String) {
      throw StateError('$context contains a non-string key');
    }
    result[entry.key! as String] = entry.value;
  }
  return result;
}

List<Object?> _list(Object? value, String context) {
  if (value is! List<Object?>) {
    throw StateError('$context must be an array');
  }
  return value;
}

List<String> _strings(Object? value, String context) {
  final List<Object?> values = _list(value, context);
  return <String>[
    for (int index = 0; index < values.length; index += 1)
      _string(values[index], '$context[$index]'),
  ];
}

String _string(Object? value, String context) {
  if (value is! String || value.trim().isEmpty) {
    throw StateError('$context must be a non-empty string');
  }
  return value;
}

int _integer(Object? value, String context) {
  if (value is! int) {
    throw StateError('$context must be an integer');
  }
  return value;
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

bool _isSha256(String value) => RegExp(r'^[0-9a-f]{64}$').hasMatch(value);

bool _sameMultiset(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }
  final List<String> sortedLeft = left.toList()..sort();
  final List<String> sortedRight = right.toList()..sort();
  for (int index = 0; index < sortedLeft.length; index += 1) {
    if (sortedLeft[index] != sortedRight[index]) {
      return false;
    }
  }
  return true;
}

String _formatCounts(Map<String, int> counts) {
  final List<String> keys = counts.keys.toList()..sort();
  return keys.map((String key) => '$key=${counts[key]}').join(', ');
}
