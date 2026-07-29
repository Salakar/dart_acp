@TestOn('vm')
library;

import 'package:test/test.dart';

import '../../tool/src/chrome_test_runner.dart';

void main() {
  group('buildChromeTestArguments', () {
    test('pins Chrome dart2js and forwards coverage arguments verbatim', () {
      expect(
        buildChromeTestArguments(const <String>[
          '--coverage-path=coverage/web.info',
          '--branch-coverage',
        ]),
        const <String>[
          '--suppress-analytics',
          'test',
          '--platform',
          'chrome',
          '--compiler',
          'dart2js',
          '--coverage-path=coverage/web.info',
          '--branch-coverage',
        ],
      );
    });

    test('forwards a focused test path after the pinned options', () {
      expect(
        buildChromeTestArguments(const <String>[
          'test/remote/platform_web_test.dart',
        ]),
        const <String>[
          '--suppress-analytics',
          'test',
          '--platform',
          'chrome',
          '--compiler',
          'dart2js',
          'test/remote/platform_web_test.dart',
        ],
      );
    });
  });

  group('parseBrowserWebSocketHelperReadyLine', () {
    test('accepts the exact loopback WebSocket readiness sentinel', () {
      expect(
        parseBrowserWebSocketHelperReadyLine(
          '${browserWebSocketHelperReadyPrefix}ws://127.0.0.1:47321/echo',
        ),
        Uri.parse('ws://127.0.0.1:47321/echo'),
      );
    });

    test('rejects logs, non-loopback hosts, and invalid endpoints', () {
      expect(
        parseBrowserWebSocketHelperReadyLine(
          'server listening on ws://127.0.0.1:47321/echo',
        ),
        isNull,
      );
      expect(
        parseBrowserWebSocketHelperReadyLine(
          '${browserWebSocketHelperReadyPrefix}ws://example.com:47321/echo',
        ),
        isNull,
      );
      expect(
        parseBrowserWebSocketHelperReadyLine(
          '${browserWebSocketHelperReadyPrefix}ws://127.0.0.1:47321/wrong',
        ),
        isNull,
      );
    });
  });
}
