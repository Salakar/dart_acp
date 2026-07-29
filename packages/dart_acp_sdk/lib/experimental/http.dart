// coverage-exempt: directives-only
/// Experimental ACP HTTP/SSE client APIs.
///
/// These APIs may change before a stable release. The transport does not
/// provide authentication, authorization, automatic reconnect, or replay.
/// Browser Fetch uses the browser cookie jar and cannot expose `Set-Cookie` or
/// attach caller-managed `Cookie` headers.
///
/// {@canonicalFor affinity_cookie_store.AcpAffinityCookieStore}
/// {@canonicalFor application_stream.acpApplicationStream}
/// {@canonicalFor http_adapter.AcpHttpCookiePolicy}
/// {@canonicalFor http_adapter.AcpHttpHeaders}
/// {@canonicalFor http_adapter.AcpHttpRequest}
/// {@canonicalFor http_adapter.AcpHttpResponse}
/// {@canonicalFor sse.AcpRemoteDiagnostic}
/// {@canonicalFor sse.AcpRemoteDiagnosticHandler}
library;

export '../src/remote/affinity_cookie_store.dart';
export '../src/remote/application_stream.dart';
export '../src/remote/http_adapter.dart';
export '../src/remote/http_adapter_factory.dart';
export '../src/remote/http_client.dart';
export '../src/remote/sse.dart';
