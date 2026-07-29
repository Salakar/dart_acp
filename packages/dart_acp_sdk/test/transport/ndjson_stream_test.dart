import 'dart:async';
import 'dart:convert';

import 'package:dart_acp_sdk/src/transport/duplex_stream.dart';
import 'package:dart_acp_sdk/src/transport/line_buffer.dart';
import 'package:dart_acp_sdk/src/transport/ndjson_stream.dart';
import 'package:test/test.dart';

void main() {
  AcpWritable<List<int>> collectingOutput(
    List<List<int>> chunks, {
    void Function()? onClose,
  }) => AcpWritable<List<int>>(
    write: (List<int> value) {
      chunks.add(List<int>.of(value));
      return Future<void>.value();
    },
    close: () {
      onClose?.call();
      return Future<void>.value();
    },
  );

  group('ndJsonStream readable', () {
    test(
      'parses batches, chunked Unicode, and an unterminated final line',
      () async {
        final Map<String, Object?> message = <String, Object?>{
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'example/é',
        };
        final List<Object?> batch = <Object?>[
          <String, Object?>{'jsonrpc': '2.0', 'method': 'example/note'},
        ];
        final List<int> bytes = utf8.encode(
          '${jsonEncode(message)}\n${jsonEncode(batch)}',
        );
        final int split = bytes.indexOf(0xc3) + 1;
        final Stream<List<int>> input = Stream<List<int>>.fromIterable(
          <List<int>>[bytes.sublist(0, split), bytes.sublist(split)],
        );
        final List<List<int>> output = <List<int>>[];
        final AcpDuplexStream<Object?> stream = ndJsonStream(
          output: collectingOutput(output),
          input: input,
        );

        final List<Object?> values = await stream.readable.toList();

        expect(values, <Object?>[message, batch]);
      },
    );

    test(
      'skips malformed and primitive lines with truncated diagnostics',
      () async {
        final List<NdJsonDiagnostic> diagnostics = <NdJsonDiagnostic>[];
        final Stream<List<int>> input = Stream<List<int>>.value(
          utf8.encode(
            'not valid json with a long suffix\n'
            '42\n'
            '{"jsonrpc":"2.0","method":"after"}\n',
          ),
        );
        final AcpDuplexStream<Object?> stream = ndJsonStream(
          output: collectingOutput(<List<int>>[]),
          input: input,
          options: NdJsonStreamOptions(
            maximumDiagnosticCharacters: 8,
            onDiagnostic: diagnostics.add,
          ),
        );

        final List<Object?> values = await stream.readable.toList();

        expect(values, hasLength(1));
        expect(diagnostics, hasLength(2));
        expect(diagnostics.first.preview, 'not vali…');
        expect(diagnostics.last.preview, '42');
      },
    );

    test('enforces the maximum line size', () async {
      final AcpDuplexStream<Object?> stream = ndJsonStream(
        output: collectingOutput(<List<int>>[]),
        input: Stream<List<int>>.value(utf8.encode('{"too":"large"}\n')),
        options: const NdJsonStreamOptions(maximumLineBytes: 4),
      );

      await expectLater(
        stream.readable.toList(),
        throwsA(isA<LineLengthExceededException>()),
      );
    });

    test('skips over-depth JSON without stopping later lines', () async {
      final diagnostics = <NdJsonDiagnostic>[];
      final stream = ndJsonStream(
        output: collectingOutput(<List<int>>[]),
        input: Stream<List<int>>.value(
          utf8.encode('{"too":[[{}]]}\n{"after":true}\n'),
        ),
        options: NdJsonStreamOptions(
          maximumJsonNestingDepth: 3,
          onDiagnostic: diagnostics.add,
        ),
      );

      expect(await stream.readable.toList(), <Object?>[
        <String, Object?>{'after': true},
      ]);
      expect(diagnostics, hasLength(1));
      expect(diagnostics.single.message, contains('malformed JSON'));
    });

    test('validates the JSON nesting limit', () {
      expect(
        () => ndJsonStream(
          output: collectingOutput(<List<int>>[]),
          input: const Stream<List<int>>.empty(),
          options: const NdJsonStreamOptions(maximumJsonNestingDepth: 0),
        ),
        throwsArgumentError,
      );
    });

    test('throwing diagnostics cannot interrupt later lines', () async {
      final stream = ndJsonStream(
        output: collectingOutput(<List<int>>[]),
        input: Stream<List<int>>.value(
          utf8.encode('not-json\n{"after":true}\n'),
        ),
        options: NdJsonStreamOptions(
          onDiagnostic: (_) => throw StateError('observer failed'),
        ),
      );

      expect(await stream.readable.toList(), <Object?>[
        <String, Object?>{'after': true},
      ]);
    });

    test('cancels the underlying byte stream', () async {
      final Completer<void> cancelled = Completer<void>();
      final StreamController<List<int>> input = StreamController<List<int>>(
        onCancel: cancelled.complete,
      );
      final AcpDuplexStream<Object?> stream = ndJsonStream(
        output: collectingOutput(<List<int>>[]),
        input: input.stream,
      );
      final StreamSubscription<Object?> subscription = stream.readable.listen(
        (Object? _) {},
      );

      await subscription.cancel();

      await cancelled.future;
      await input.close();
    });
  });

  group('ndJsonStream writable', () {
    test('writes one compact JSON value per line in call order', () async {
      final List<List<int>> output = <List<int>>[];
      final AcpDuplexStream<Object?> stream = ndJsonStream(
        output: collectingOutput(output),
        input: const Stream<List<int>>.empty(),
      );

      final Future<void> first = stream.writable.write(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 1,
        'method': 'first',
      });
      final Future<void> second = stream.writable.write(<Object?>[
        <String, Object?>{'jsonrpc': '2.0', 'method': 'note'},
      ]);
      await Future.wait<void>(<Future<void>>[first, second]);

      expect(output.map<String>(utf8.decode).toList(), <String>[
        '{"jsonrpc":"2.0","id":1,"method":"first"}\n',
        '[{"jsonrpc":"2.0","method":"note"}]\n',
      ]);
    });

    test('forwards close only when configured', () async {
      int closes = 0;
      final AcpDuplexStream<Object?> retaining = ndJsonStream(
        output: collectingOutput(<List<int>>[], onClose: () => closes += 1),
        input: const Stream<List<int>>.empty(),
      );
      final AcpDuplexStream<Object?> owning = ndJsonStream(
        output: collectingOutput(<List<int>>[], onClose: () => closes += 1),
        input: const Stream<List<int>>.empty(),
        options: const NdJsonStreamOptions(closeOutput: true),
      );

      await retaining.writable.close();
      await owning.writable.close();

      expect(closes, 1);
    });

    test('propagates asynchronous output failures', () async {
      final StateError failure = StateError('write failed');
      final AcpDuplexStream<Object?> stream = ndJsonStream(
        output: AcpWritable<List<int>>(
          write: (List<int> _) => Future<void>.error(failure),
          close: () => Future<void>.value(),
        ),
        input: const Stream<List<int>>.empty(),
      );

      await expectLater(
        stream.writable.write(<String, Object?>{'ok': true}),
        throwsA(same(failure)),
      );
    });
  });
}
