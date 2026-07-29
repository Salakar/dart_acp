import 'package:dart_acp_sdk/experimental/http.dart';
import 'package:test/test.dart';

void main() {
  group('AcpAffinityCookieStore', () {
    late DateTime now;
    late AcpAffinityCookieStore store;

    setUp(() {
      now = DateTime.utc(2030, 10, 20);
      store = AcpAffinityCookieStore(clock: () => now);
    });

    test('stores, scopes, orders, and expires routing cookies', () {
      store = AcpAffinityCookieStore(
        clock: () => now,
        domainPolicy: (_, String domain) => domain == 'example.com',
      );
      store.store(Uri.parse('https://api.example.com/acp/session'), <String>[
        'route=alpha; Path=/acp; Secure',
        'domain=bravo; Domain=example.com; Path=/',
        'gone=value; Max-Age=0',
      ]);

      expect(
        store.cookieHeader(Uri.parse('https://api.example.com/acp/prompt')),
        'route=alpha; domain=bravo',
      );
      expect(
        store.cookieHeader(Uri.parse('http://api.example.com/acp/prompt')),
        'domain=bravo',
      );
      expect(
        store.cookieHeader(Uri.parse('https://other.example.com/acp')),
        'domain=bravo',
      );
      expect(
        store.cookieHeader(Uri.parse('https://example.invalid/acp')),
        isNull,
      );
      expect(store.length, 2);
    });

    test('rejects parent-domain and public-suffix scope by default', () {
      store.store(Uri.parse('https://api.example.com/acp'), <String>[
        'host=kept; Path=/',
        'parent=rejected; Domain=example.com; Path=/',
        'suffix=rejected; Domain=com; Path=/',
      ]);

      expect(
        store.cookieHeader(Uri.parse('https://api.example.com/acp')),
        'host=kept',
      );
      expect(
        store.cookieHeader(Uri.parse('https://other.example.com/acp')),
        isNull,
      );
    });

    test('domain policy failures reject cookies without escaping', () {
      store = AcpAffinityCookieStore(
        clock: () => now,
        domainPolicy: (_, _) => throw StateError('policy secret'),
      );

      expect(
        () => store.store(Uri.parse('https://api.example.com/acp'), <String>[
          'route=value; Domain=example.com',
        ]),
        returnsNormally,
      );
      expect(store.length, 0);
    });

    test('rejects insecure Secure cookies and invalid cookie prefixes', () {
      store
        ..store(Uri.parse('http://agent.example/acp'), <String>[
          'secure=value; Secure',
        ])
        ..store(Uri.parse('https://agent.example/acp'), <String>[
          '__Secure-route=value',
          '__Host-route=value; Secure; Path=/acp',
          '__Host-valid=value; Secure; Path=/',
        ]);

      expect(
        store.cookieHeader(Uri.parse('https://agent.example/acp')),
        '__Host-valid=value',
      );
    });

    test('ignores an unrepresentable Max-Age without throwing', () {
      expect(
        () => store.store(Uri.parse('https://agent.example/acp'), <String>[
          'route=value; Max-Age=999999999999999999999999999999999999',
        ]),
        returnsNormally,
      );
      expect(store.length, 0);
    });

    test('bounds managed cookie count and individual header length', () {
      store = AcpAffinityCookieStore(
        clock: () => now,
        maximumCookies: 1,
        maximumCookieCharacters: 20,
      );
      store.store(Uri.parse('https://agent.example/acp'), <String>[
        'first=kept',
        'second=ignored',
        'oversized=${'x' * 40}',
      ]);

      expect(
        store.cookieHeader(Uri.parse('https://agent.example/acp')),
        'first=kept',
      );
      expect(store.length, 1);
    });

    test('validates managed cookie resource limits', () {
      expect(
        () => AcpAffinityCookieStore(maximumCookies: 0),
        throwsArgumentError,
      );
      expect(
        () => AcpAffinityCookieStore(maximumCookieCharacters: 0),
        throwsArgumentError,
      );
    });

    test('splits combined headers without splitting Expires dates', () {
      store.store(Uri.parse('https://agent.example/acp'), <String>[
        'transport=alpha; Expires=Wed, 21 Oct 2030 07:28:00 GMT, '
            'route=bravo; Path=/',
      ]);

      expect(
        store.cookieHeader(Uri.parse('https://agent.example/acp')),
        'transport=alpha; route=bravo',
      );

      now = DateTime.utc(2030, 10, 22);
      expect(
        store.cookieHeader(Uri.parse('https://agent.example/acp')),
        'route=bravo',
      );
    });

    test('caller values win and later managed values overwrite', () {
      store.store(Uri.parse('https://agent.example/acp'), <String>[
        'route=alpha',
        'transport=first',
        'transport=second',
      ]);

      expect(
        store.cookieHeader(
          Uri.parse('https://agent.example/acp'),
          callerCookieHeader: 'route=caller; custom=value',
        ),
        'route=caller; transport=second; custom=value',
      );
    });

    test('prefers the most specific matching path for duplicate names', () {
      store
        ..store(Uri.parse('https://agent.example/acp'), <String>[
          'route=root; Path=/',
        ])
        ..store(Uri.parse('https://agent.example/acp'), <String>[
          'route=acp; Path=/acp',
        ]);

      expect(
        store.cookieHeader(Uri.parse('https://agent.example/acp/prompt')),
        'route=acp',
      );
      expect(
        store.cookieHeader(Uri.parse('https://agent.example/other')),
        'route=root',
      );
    });

    test('ignores malformed and unrelated-domain values', () {
      store.store(Uri.parse('https://agent.example/acp'), <String>[
        'missing-separator',
        '=empty',
        'bad name=value',
        'foreign=value; Domain=elsewhere.example',
        'newline=value\r\ninjected=yes',
        'ok=value',
      ]);

      expect(
        store.cookieHeader(Uri.parse('https://agent.example/acp')),
        'ok=value',
      );
    });

    test('clears without exposing cookie data in diagnostics', () {
      store.store(Uri.parse('https://agent.example/acp'), <String>[
        'secret-cookie=secret-value',
      ]);

      expect(store.toString(), 'AcpAffinityCookieStore(1 cookie)');
      expect(store.toString(), isNot(contains('secret')));
      store.clear();
      expect(store.length, 0);
    });
  });
}
