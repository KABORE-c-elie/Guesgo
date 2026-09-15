import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// What [AuthInterceptor] needs from an auth backend — kept minimal and
/// Supabase-agnostic so the interceptor's retry-on-401 logic is unit
/// testable with a fake, instead of having to stand up a real
/// `SupabaseClient`.
abstract interface class AuthTokenProvider {
  /// The current access token, or `null` if signed out.
  String? get accessToken;

  /// Refreshes the session and returns the new access token, or `null` if
  /// the refresh itself failed (e.g. the refresh token also expired).
  Future<String?> refresh();
}

class SupabaseAuthTokenProvider implements AuthTokenProvider {
  const SupabaseAuthTokenProvider(this._client);

  final SupabaseClient _client;

  @override
  String? get accessToken => _client.auth.currentSession?.accessToken;

  @override
  Future<String?> refresh() async {
    final response = await _client.auth.refreshSession();
    return response.session?.accessToken;
  }
}

/// Attaches the signed-in user's JWT to every outgoing request, and
/// refreshes + retries once on a 401.
///
/// TMDB itself ignores the header and never 401s on it — it's a
/// public-key API — so the refresh path only fires the moment a call site
/// talks to an actual authenticated backend (a Supabase Edge Function, or
/// PostgREST directly instead of through the SDK). Wiring the refresh
/// here, rather than in each call site, is what makes it "just work" for
/// any future endpoint: nothing about calling one has to know a token can
/// expire.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  final AuthTokenProvider _tokens;

  /// Set right after construction (see `dio_client.dart`) — needed to
  /// retry a failed request through the *same* [Dio] instance, so it
  /// keeps the same base options and doesn't re-trigger this interceptor
  /// in a loop.
  late final Dio dio;

  bool _refreshing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokens.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;

    // `_refreshing` guards against a stampede: if several requests 401 at
    // once, only the first refreshes the session — retrying the others
    // would just refresh again for no reason.
    if (!isUnauthorized || _tokens.accessToken == null || _refreshing) {
      return handler.next(err);
    }

    _refreshing = true;
    try {
      final newToken = await _tokens.refresh();
      if (newToken == null) return handler.next(err);

      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer $newToken';
      final retryResponse = await dio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } catch (_) {
      // Refresh itself failed — surface the original 401, not that error.
      handler.next(err);
    } finally {
      _refreshing = false;
    }
  }
}
