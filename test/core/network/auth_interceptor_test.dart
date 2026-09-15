import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guesgo/core/network/auth_interceptor.dart';

class _FakeTokenProvider implements AuthTokenProvider {
  _FakeTokenProvider({this.accessToken});

  @override
  String? accessToken;

  /// What [refresh] yields; `null` simulates the refresh itself failing.
  String? refreshedToken;
  var refreshCallCount = 0;

  @override
  Future<String?> refresh() async {
    refreshCallCount++;
    accessToken = refreshedToken;
    return refreshedToken;
  }
}

/// A scripted adapter: the first call answers with [firstStatus], every
/// call after that with 200 — enough to simulate "token expired, retry
/// succeeds" without any real network I/O. Records every request's
/// Authorization header so a test can assert the retry carried the
/// refreshed token.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter({this.firstStatus = 401, this.alwaysFail = false});

  final int firstStatus;
  final bool alwaysFail;
  final List<String?> authHeadersSeen = [];
  var callCount = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    authHeadersSeen.add(options.headers['Authorization'] as String?);
    final status = (callCount == 1 || alwaysFail) ? firstStatus : 200;
    return ResponseBody.fromString(
      '{}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

Dio _dioWith(_ScriptedAdapter adapter, AuthTokenProvider tokens) {
  final dio = Dio()..httpClientAdapter = adapter;
  dio.interceptors.add(AuthInterceptor(tokens)..dio = dio);
  return dio;
}

void main() {
  test('attaches the current token as a bearer header', () async {
    final tokens = _FakeTokenProvider(accessToken: 'token-1');
    final adapter = _ScriptedAdapter(firstStatus: 200);
    final dio = _dioWith(adapter, tokens);

    await dio.get<void>('/movie/popular');

    expect(adapter.authHeadersSeen.single, 'Bearer token-1');
  });

  test('adds no Authorization header when signed out', () async {
    final tokens = _FakeTokenProvider();
    final adapter = _ScriptedAdapter(firstStatus: 200);
    final dio = _dioWith(adapter, tokens);

    await dio.get<void>('/movie/popular');

    expect(adapter.authHeadersSeen.single, isNull);
  });

  test('a 401 refreshes the token and retries the request once', () async {
    final tokens = _FakeTokenProvider(accessToken: 'expired')
      ..refreshedToken = 'fresh';
    final adapter = _ScriptedAdapter();
    final dio = _dioWith(adapter, tokens);

    final response = await dio.get<void>('/protected');

    expect(response.statusCode, 200);
    expect(tokens.refreshCallCount, 1);
    expect(adapter.callCount, 2);
    expect(
      adapter.authHeadersSeen,
      ['Bearer expired', 'Bearer fresh'],
      reason: 'the retried request must carry the refreshed token',
    );
  });

  test('a failed refresh surfaces the original 401 instead', () async {
    final tokens = _FakeTokenProvider(accessToken: 'expired')
      ..refreshedToken = null;
    final adapter = _ScriptedAdapter(alwaysFail: true);
    final dio = _dioWith(adapter, tokens);

    await expectLater(
      dio.get<void>('/protected'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          401,
        ),
      ),
    );
    expect(tokens.refreshCallCount, 1);
    expect(adapter.callCount, 1, reason: 'no retry once refresh fails');
  });

  test('a non-401 error is forwarded without attempting a refresh', () async {
    final tokens = _FakeTokenProvider(accessToken: 'valid');
    final adapter = _ScriptedAdapter(firstStatus: 500, alwaysFail: true);
    final dio = _dioWith(adapter, tokens);

    await expectLater(dio.get<void>('/movie/popular'), throwsA(isA<DioException>()));
    expect(tokens.refreshCallCount, 0);
  });
}
