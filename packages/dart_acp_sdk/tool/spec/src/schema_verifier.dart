part of 'verifier.dart';

extension _SchemaEvidenceVerification on SpecEvidenceVerifier {
  ({int lanes, int definitions, int declarations, int codecCases, int methods})
  _verifySchema(JsonMap anchors, Map<String, JsonMap> delegates) {
    final JsonMap pin = _map(anchors['schemaPin'], 'schemaPin');
    final File manifestFile = _file(
      _string(pin['manifest'], 'schemaPin.manifest'),
    );
    final JsonMap manifest = _decodeMap(manifestFile, 'schema manifest');
    final JsonMap official = _map(manifest['official'], 'manifest.official');
    final JsonMap sdk = _map(manifest['sdk'], 'manifest.sdk');
    _expect(
      official['commit'] == pin['officialCommit'],
      'official schema commit differs from anchors',
    );
    _expect(
      sdk['commit'] == pin['sdkCommit'],
      'SDK schema commit differs from anchors',
    );

    final List<Object?> manifestRows = _list(
      manifest['files'],
      'manifest.files',
    );
    final Map<String, String> manifestDigests = <String, String>{};
    for (int index = 0; index < manifestRows.length; index += 1) {
      final JsonMap row = _map(manifestRows[index], 'manifest.files[$index]');
      final String path = _string(row['path'], 'manifest.files[$index].path');
      final String digest = _string(
        row['sha256'],
        'manifest.files[$index].sha256',
      );
      final File snapshot = File('${manifestFile.parent.path}/$path');
      _expect(snapshot.existsSync(), 'missing pinned schema $path');
      _expect(
        sha256Hex(snapshot.readAsBytesSync()) == digest,
        'pinned schema digest mismatch for $path',
      );
      manifestDigests[path] = digest;
    }

    final File reportFile = _file(
      _string(pin['conformanceReport'], 'schemaPin.conformanceReport'),
    );
    final JsonMap report = _decodeMap(reportFile, 'conformance report');
    final List<Object?> laneRows = _list(report['lanes'], 'report.lanes');
    final JsonMap expectedLanes = _map(pin['lanes'], 'schemaPin.lanes');
    _expect(
      laneRows.length == expectedLanes.length &&
          laneRows.length == _integer(report['laneCount'], 'laneCount'),
      'schema lane count mismatch',
    );
    _expect(
      _list(report['uncoveredDeclarations'], 'uncoveredDeclarations').isEmpty,
      'conformance report has uncovered declarations',
    );
    _expect(
      _list(report['uncoveredMethods'], 'uncoveredMethods').isEmpty,
      'conformance report has uncovered methods',
    );
    final JsonMap coverage = _map(report['coveragePolicy'], 'coveragePolicy');
    _expect(
      coverage['wholeFileIgnoreCount'] == 0 &&
          coverage['lineIgnoreCount'] == 0 &&
          _list(coverage['lineIgnores'], 'lineIgnores').isEmpty,
      'generated coverage policy contains ignores',
    );

    final Set<String> caseIds = <String>{};
    final Set<String> methodIds = <String>{};
    final Map<String, ({int definitions, int methods})> actualLanes =
        <String, ({int definitions, int methods})>{};
    var definitionTotal = 0;
    var declarationTotal = 0;
    var caseTotal = 0;
    var methodTotal = 0;
    for (int laneIndex = 0; laneIndex < laneRows.length; laneIndex += 1) {
      final JsonMap lane = _map(laneRows[laneIndex], 'lanes[$laneIndex]');
      final String name = _string(lane['name'], 'lane.name');
      final JsonMap expected = _map(expectedLanes[name], 'expected lane $name');
      final String schemaPath = _string(lane['schemaSource'], '$name.schema');
      _expect(
        manifestDigests[schemaPath] == lane['schemaSha256'],
        '$name schema digest is not pinned by manifest',
      );
      _expect(
        manifestDigests.values.contains(lane['metadataSha256']),
        '$name metadata digest is not pinned by manifest',
      );

      final List<Object?> definitions = _list(
        lane['definitions'],
        '$name.definitions',
      );
      final List<Object?> methods = _list(lane['methods'], '$name.methods');
      var laneDeclarations = 0;
      var laneCases = 0;
      final Set<String> definitionNames = <String>{};
      for (int defIndex = 0; defIndex < definitions.length; defIndex += 1) {
        final JsonMap definition = _map(
          definitions[defIndex],
          '$name.definitions[$defIndex]',
        );
        final String definitionName = _string(
          definition['name'],
          '$name.definition.name',
        );
        _expect(
          definitionNames.add(definitionName),
          '$name duplicate definition $definitionName',
        );
        final List<String> declarations = _strings(
          definition['declarations'],
          '$name.$definitionName.declarations',
        );
        final List<Object?> cases = _list(
          definition['cases'],
          '$name.$definitionName.cases',
        );
        _expect(declarations.isNotEmpty, '$name.$definitionName unimplemented');
        _expect(cases.isNotEmpty, '$name.$definitionName untested');
        final Set<String> covered = <String>{};
        for (int caseIndex = 0; caseIndex < cases.length; caseIndex += 1) {
          final JsonMap testCase = _map(
            cases[caseIndex],
            '$name.$definitionName.cases[$caseIndex]',
          );
          final String id = _string(testCase['id'], 'case.id');
          _expect(caseIds.add(id), 'duplicate generated case ID $id');
          covered.addAll(
            _strings(testCase['coveredDeclarations'], '$id.coverage'),
          );
        }
        _expect(
          covered.containsAll(declarations),
          '$name.$definitionName has uncovered declarations',
        );
        laneDeclarations += declarations.length;
        laneCases += cases.length;
      }

      for (
        int methodIndex = 0;
        methodIndex < methods.length;
        methodIndex += 1
      ) {
        final JsonMap method = _map(
          methods[methodIndex],
          '$name.methods[$methodIndex]',
        );
        final String id = _string(method['id'], '$name.method.id');
        _expect(
          methodIds.add('$name:$id'),
          'duplicate generated method ID $name:$id',
        );
        _string(method['identifier'], '$id.identifier');
        _string(method['wireName'], '$id.wireName');
        final String params = _string(
          method['paramsDefinition'],
          '$id.paramsDefinition',
        );
        _expect(
          definitionNames.contains(params),
          '$id params definition is not in $name',
        );
        final Object? result = method['resultDefinition'];
        if (result != null) {
          _expect(
            definitionNames.contains(_string(result, '$id.resultDefinition')),
            '$id result definition is not in $name',
          );
        }
        _expect(
          method['exercisesParamsCodec'] == true &&
              method['exercisesResultCodec'] == true,
          '$id does not exercise both descriptor codec paths',
        );
      }

      _expect(
        definitions.length == _integer(lane['definitionCount'], '$name defs') &&
            definitions.length == _integer(expected['definitions'], name),
        '$name definition count mismatch',
      );
      _expect(
        laneDeclarations ==
                _integer(lane['declarationCount'], '$name declarations') &&
            laneDeclarations ==
                _integer(expected['declarations'], '$name declarations'),
        '$name declaration count mismatch',
      );
      _expect(
        laneCases == _integer(lane['codecCaseCount'], '$name cases') &&
            laneCases == _integer(expected['codecCases'], '$name cases'),
        '$name codec case count mismatch',
      );
      _expect(
        methods.length == _integer(lane['methodCount'], '$name methods') &&
            methods.length == _integer(expected['methods'], '$name methods'),
        '$name method count mismatch',
      );
      _expect(
        _list(
          lane['uncoveredDeclarations'],
          '$name.uncoveredDeclarations',
        ).isEmpty,
        '$name reports uncovered declarations',
      );
      _expect(
        _list(lane['uncoveredMethods'], '$name.uncoveredMethods').isEmpty,
        '$name reports uncovered methods',
      );
      actualLanes[name] = (
        definitions: definitions.length,
        methods: methods.length,
      );
      definitionTotal += definitions.length;
      declarationTotal += laneDeclarations;
      caseTotal += laneCases;
      methodTotal += methods.length;
    }

    _expect(
      definitionTotal == _integer(report['definitionCount'], 'definitions') &&
          declarationTotal ==
              _integer(report['declarationCount'], 'declarations') &&
          caseTotal == _integer(report['codecCaseCount'], 'codec cases') &&
          methodTotal == _integer(report['methodCount'], 'methods'),
      'aggregate conformance counts differ from lane totals',
    );
    _verifyDelegates(delegates, actualLanes);
    return (
      lanes: laneRows.length,
      definitions: definitionTotal,
      declarations: declarationTotal,
      codecCases: caseTotal,
      methods: methodTotal,
    );
  }

  void _verifyDelegates(
    Map<String, JsonMap> delegates,
    Map<String, ({int definitions, int methods})> lanes,
  ) {
    _expect(delegates.length == 2, 'expected v1 and v2 schema delegates');
    final Set<String> delegatedLanes = <String>{};
    for (final MapEntry<String, JsonMap> entry in delegates.entries) {
      final List<String> names = _strings(
        entry.value['lanes'],
        '${entry.key}.lanes',
      );
      var definitions = 0;
      var methods = 0;
      for (final String name in names) {
        final ({int definitions, int methods})? lane = lanes[name];
        _expect(lane != null, '${entry.key} delegates unknown lane $name');
        _expect(delegatedLanes.add(name), 'lane $name delegated twice');
        definitions += lane!.definitions;
        methods += lane.methods;
      }
      _expect(
        definitions ==
                _integer(entry.value['definitionCount'], 'delegate defs') &&
            methods == _integer(entry.value['methodCount'], 'delegate methods'),
        '${entry.key} delegate counts differ from conformance report',
      );
    }
    _expect(
      delegatedLanes.length == lanes.length &&
          delegatedLanes.containsAll(lanes.keys),
      'not every schema lane is delegated exactly once',
    );
  }
}
