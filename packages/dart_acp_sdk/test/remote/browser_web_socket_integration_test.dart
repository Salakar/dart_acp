@TestOn('browser')
library;

import 'dart:async';

import 'package:dart_acp_sdk/experimental/web_socket.dart';
import 'package:test/test.dart';

void main() {
  test(
    'browser WebSocket adapter opens, sends, receives, and closes',
    () async {
      final adapter = createPlatformWebSocketAdapter();
      try {
        final channel = await adapter
            .connect(
              AcpWebSocketConnectRequest(
                uri: Uri.parse('ws://127.0.0.1:47321/echo'),
                protocols: const <String>['acp'],
              ),
            )
            .timeout(const Duration(seconds: 2));
        final frames = StreamIterator<AcpWebSocketFrame>(channel.frames);

        await channel.sendText('hello browser websocket');

        expect(await frames.moveNext(), isTrue);
        expect(
          frames.current,
          isA<AcpWebSocketTextFrame>().having(
            (frame) => frame.text,
            'text',
            'hello browser websocket',
          ),
        );
        await channel.sendText('send-binary');
        expect(await frames.moveNext(), isTrue);
        expect(frames.current, isA<AcpWebSocketBinaryFrame>());
        await frames.cancel();
        await channel.close(code: 1000, reason: 'test complete');
        await channel.closed;
      } finally {
        await adapter.close();
      }
    },
  );
}
