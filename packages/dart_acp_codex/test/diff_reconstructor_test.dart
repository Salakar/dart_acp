import 'dart:io';

import 'package:dart_acp_codex/src/app_server/json_values.dart';
import 'package:dart_acp_codex/src/bridge/diff_reconstructor.dart';
import 'package:test/test.dart';

void main() {
  const reconstructor = CodexDiffReconstructor();

  test('maps add and delete changes without filesystem access', () {
    expect(
      reconstructor.reconstruct(
        CodexJsonObject.from(<String, Object?>{
          'path': '/tmp/new.dart',
          'diff': 'new\n',
          'kind': <String, Object?>{'type': 'add'},
        }),
      ),
      containsPair('newText', 'new\n'),
    );
    expect(
      reconstructor.reconstruct(
        CodexJsonObject.from(<String, Object?>{
          'path': '/tmp/old.dart',
          'diff': 'old\n',
          'kind': <String, Object?>{'type': 'delete'},
        }),
      ),
      containsPair('oldText', 'old\n'),
    );
  });

  test('applies and reverses updates including moved files', () async {
    final directory = await Directory.systemTemp.createTemp(
      'dart_acp_codex_diff_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final source = File('${directory.path}/old.txt');
    final moved = File('${directory.path}/new.txt');
    const patch = '@@ -1,2 +1,2 @@\n one\n-two\n+three\n';
    await source.writeAsString('one\ntwo\n');

    final applied = reconstructor.reconstruct(
      CodexJsonObject.from(<String, Object?>{
        'path': source.path,
        'diff': patch,
        'kind': <String, Object?>{'type': 'update'},
      }),
    )!;
    expect(applied['oldText'], 'one\ntwo\n');
    expect(applied['newText'], 'one\nthree\n');

    await source.delete();
    await moved.writeAsString('one\nthree\n');
    final reversed = reconstructor.reconstruct(
      CodexJsonObject.from(<String, Object?>{
        'path': source.path,
        'diff': '$patch\nMoved to: ${moved.path}',
        'kind': <String, Object?>{'type': 'update', 'move_path': moved.path},
      }),
    )!;
    expect(reversed['path'], moved.path);
    expect(reversed['oldText'], 'one\ntwo\n');
    expect(reversed['newText'], 'one\nthree\n');
  });

  test('omits malformed or unresolvable updates', () {
    expect(
      reconstructor.reconstruct(
        CodexJsonObject.from(<String, Object?>{
          'path': '/definitely/missing',
          'diff': 'not a patch',
          'kind': <String, Object?>{'type': 'update'},
        }),
      ),
      isNull,
    );
    expect(reconstructor.reconstruct(CodexJsonObject.empty), isNull);
  });
}
