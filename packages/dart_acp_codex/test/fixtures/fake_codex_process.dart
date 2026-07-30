import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  if (arguments.singleOrNull != 'app-server') {
    exitCode = 64;
    return;
  }
  switch (Platform.environment['FAKE_CODEX_MODE']) {
    case 'exit':
      stderr.writeln('fake process failure');
      exitCode = 3;
      return;
    case 'hang':
      await Future<void>.delayed(const Duration(days: 1));
    default:
      break;
  }

  try {
    await for (final line
        in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
      final message = jsonDecode(line);
      if (message is! Map<String, Object?> || message['id'] == null) {
        continue;
      }
      final result = switch (message['method']) {
        'initialize' => <String, Object?>{'codexHome': '/tmp/fake-codex'},
        'model/list' => <String, Object?>{
          'data': <Object?>[
            <String, Object?>{
              'id': 'fake-model',
              'isDefault': true,
              'defaultReasoningEffort': 'medium',
              'supportedReasoningEfforts': <Object?>['medium'],
              'inputModalities': <Object?>['text'],
            },
          ],
        },
        _ => <String, Object?>{},
      };
      stdout.writeln(
        jsonEncode(<String, Object?>{'id': message['id'], 'result': result}),
      );
    }
    _log('clean eof');
  } on Object catch (error, stackTrace) {
    _log('$error\n$stackTrace');
    rethrow;
  }
}

void _log(String message) {
  final path = Platform.environment['FAKE_CODEX_LOG'];
  if (path != null) {
    File(path).writeAsStringSync('$message\n', mode: FileMode.append);
  }
}
