import 'json_schema.dart';
import 'naming.dart';
import 'validator.dart';

/// Emits concrete, codec-correlated descriptors for one protocol lane.
final class MethodEmitter {
  /// Creates a method emitter.
  const MethodEmitter({
    required this.schema,
    required this.methods,
    required this.protocolVersion,
    required this.laneName,
    required this.stabilityByMethod,
    required this.sourceDigest,
  });

  /// The schema containing every descriptor model.
  final SchemaDocument schema;

  /// Validated method correlations from schema metadata.
  final List<MethodFact> methods;

  /// ACP protocol generation, either 1 or 2.
  final int protocolVersion;

  /// Lower-camel lane identifier such as `v1Stable`.
  final String laneName;

  /// Stability enum member by exact wire method.
  final Map<String, String> stabilityByMethod;

  /// SHA-256 of the metadata source.
  final String sourceDigest;

  /// Descriptor facts paired with their emitted Dart identifiers.
  List<({MethodFact fact, String name})> get emittedMethods => _namedMethods();

  /// Emits the complete descriptor library.
  String emit() {
    final emitted = _namedMethods();
    final output = StringBuffer()..write(_header());
    for (final entry in emitted) {
      _emitDescriptor(output, entry.fact, entry.name);
      output.writeln();
    }
    _emitRegistry(output, emitted);
    return output.toString();
  }

  String _header() {
    final output = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
      ..writeln('// Schema: ${schema.sourceName}')
      ..writeln('// Metadata SHA-256: $sourceDigest')
      ..writeln()
      ..writeln("import '../../../method.dart';")
      ..writeln("import 'models.dart';");
    output.writeln();
    return output.toString();
  }

  List<({MethodFact fact, String name})> _namedMethods() {
    final baseCounts = <String, int>{};
    for (final MethodFact fact in methods) {
      final String base = dartMemberName(fact.metadataKey);
      baseCounts[base] = (baseCounts[base] ?? 0) + 1;
    }
    final usedNames = <String>{};
    final emitted = <({MethodFact fact, String name})>[];
    for (final MethodFact fact in methods) {
      final String base = dartMemberName(fact.metadataKey);
      final String name = baseCounts[base] == 1
          ? '${base}Method'
          : '$base${_directionSuffix(fact.side)}'
                '${_kindSuffix(fact.kind)}Method';
      if (!usedNames.add(name)) {
        throw StateError(
          'Duplicate descriptor identifier $name for ${fact.method}',
        );
      }
      emitted.add((fact: fact, name: name));
    }
    return List<({MethodFact fact, String name})>.unmodifiable(emitted);
  }

  void _emitRegistry(
    StringBuffer output,
    List<({MethodFact fact, String name})> emitted,
  ) {
    output
      ..writeln('/// Every generated method descriptor in this lane.')
      ..writeln(
        'const List<AcpMethodDescriptorBase> '
        '${laneName}MethodDescriptors = <AcpMethodDescriptorBase>[',
      );
    for (final entry in emitted) {
      output.writeln('  ${entry.name},');
    }
    output
      ..writeln('];')
      ..writeln()
      ..writeln('/// Duplicate-checked lookup registry for this lane.')
      ..writeln(
        'final AcpMethodRegistry ${laneName}MethodRegistry = '
        'AcpMethodRegistry(${laneName}MethodDescriptors);',
      );
  }

  void _emitDescriptor(StringBuffer output, MethodFact fact, String name) {
    final String params = dartTypeName(fact.paramsDefinition);
    final String paramsCodec = '${dartMemberName(fact.paramsDefinition)}Codec';
    final bool isNotification = fact.kind == MethodPayloadKind.notification;
    final String result = isNotification
        ? 'AcpNoResult'
        : dartTypeName(fact.resultDefinition!);
    final String resultCodec = isNotification
        ? 'acpNoResultCodec'
        : '${dartMemberName(fact.resultDefinition!)}Codec';
    final String? capability = _capabilityPath(
      fact.method,
      protocolVersion: protocolVersion,
    );
    final String documentation =
        fact.documentation ?? 'Schema method `${fact.method}`.';
    _docs(output, documentation);
    output
      ..writeln(
        'const AcpMethodDescriptor<$params, $result> $name = '
        'AcpMethodDescriptor<$params, $result>(',
      )
      ..writeln('  name: ${dartStringLiteral(fact.method)},')
      ..writeln(
        '  dartName: '
        '${dartStringLiteral(dartMemberName(fact.metadataKey))},',
      )
      ..writeln('  protocol: AcpProtocolGeneration.v$protocolVersion,')
      ..writeln(
        '  stability: AcpMethodStability.'
        '${stabilityByMethod[fact.method] ?? _baselineStability},',
      )
      ..writeln('  direction: AcpMethodDirection.${_direction(fact.side)},')
      ..writeln(
        '  kind: AcpMethodKind.'
        '${isNotification ? 'notification' : 'request'},',
      )
      ..writeln(
        '  paramsDefinition: '
        '${dartStringLiteral(fact.paramsDefinition)},',
      )
      ..writeln('  paramsCodec: $paramsCodec,')
      ..writeln('  resultCodec: $resultCodec,')
      ..writeln(
        '  resultDefinition: '
        '${isNotification ? 'null' : dartStringLiteral(fact.resultDefinition!)},',
      )
      ..writeln(
        '  capabilityPath: '
        '${capability == null ? 'null' : dartStringLiteral(capability)},',
      )
      ..writeln('  documentation: ${dartStringLiteral(documentation)},')
      ..writeln(');');
  }

  String get _baselineStability => protocolVersion == 1 ? 'stable' : 'draft';

  String _direction(String side) => switch (side) {
    'agent' => 'clientToAgent',
    'client' => 'agentToClient',
    'protocol' => 'either',
    _ => throw StateError('Unknown method side $side'),
  };
}

String _directionSuffix(String side) => switch (side) {
  'agent' => 'ClientToAgent',
  'client' => 'AgentToClient',
  'protocol' => 'Either',
  _ => throw StateError('Unknown method side $side'),
};

String _kindSuffix(MethodPayloadKind kind) => switch (kind) {
  MethodPayloadKind.request => 'Request',
  MethodPayloadKind.notification => 'Notification',
  MethodPayloadKind.response => throw StateError(
    'Response payload cannot have its own descriptor',
  ),
};

String? _capabilityPath(String method, {required int protocolVersion}) {
  if (protocolVersion == 2) {
    switch (method) {
      case 'auth/login':
      case 'auth/logout':
        return 'agentCapabilities.authMethods';
      case 'session/new':
      case 'session/list':
      case 'session/resume':
      case 'session/close':
      case 'session/prompt':
      case 'session/cancel':
      case 'session/set_config_option':
        return 'agentCapabilities.session';
      case 'session/delete':
        return 'agentCapabilities.session.delete';
      case 'session/request_permission':
        return null;
    }
  } else {
    switch (method) {
      case 'authenticate':
        return 'agentCapabilities.authMethods';
      case 'logout':
        return 'agentCapabilities.auth.logout';
      case 'session/set_mode':
      case 'session/set_config_option':
      case 'session/request_permission':
        return null;
    }
  }
  const paths = <String, String>{
    'session/load': 'agentCapabilities.loadSession',
    'session/list': 'agentCapabilities.sessionCapabilities.list',
    'session/delete': 'agentCapabilities.sessionCapabilities.delete',
    'session/resume': 'agentCapabilities.sessionCapabilities.resume',
    'session/close': 'agentCapabilities.sessionCapabilities.close',
    'session/fork': 'agentCapabilities.sessionCapabilities.fork',
    'session/set_mode': 'agentCapabilities.sessionCapabilities.modes',
    'session/set_config_option':
        'agentCapabilities.sessionCapabilities.configOptions',
    'session/request_permission':
        'agentCapabilities.sessionCapabilities.permissions',
    'fs/read_text_file': 'clientCapabilities.fs.readTextFile',
    'fs/write_text_file': 'clientCapabilities.fs.writeTextFile',
    'terminal/create': 'clientCapabilities.terminal',
    'terminal/output': 'clientCapabilities.terminal',
    'terminal/release': 'clientCapabilities.terminal',
    'terminal/wait_for_exit': 'clientCapabilities.terminal',
    'terminal/kill': 'clientCapabilities.terminal',
    'elicitation/create': 'clientCapabilities.elicitation',
    'elicitation/complete': 'clientCapabilities.elicitation.url',
    'mcp/message': 'capabilities.mcp',
    'provider/list': 'capabilities.providers',
    'provider/authenticate': 'capabilities.providers',
    'session/nes': 'capabilities.nextEditSuggestions',
    'text_file/did_open': 'capabilities.documents',
    'text_file/did_change': 'capabilities.documents',
    'text_file/did_close': 'capabilities.documents',
  };
  return paths[method];
}

void _docs(StringBuffer output, String text) {
  final lines = text
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n');
  for (final String line in lines) {
    output.writeln(line.isEmpty ? '///' : '/// ${sanitizeDartdoc(line)}');
  }
}
