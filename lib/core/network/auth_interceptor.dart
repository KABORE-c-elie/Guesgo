import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Attaches the signed-in user's Supabase JWT to every outgoing request.
///
/// TMDB itself ignores this header — it's a public-key API and doesn't need
/// a user token. This interceptor is what carries the token to a real
/// authenticated backend the moment the app calls one (e.g. a Supabase
/// Edge Function, or PostgREST directly instead of through the SDK); wiring
/// it at the Dio level now means no call site has to remember to attach it
/// later.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._client);

  final SupabaseClient _client;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = _client.auth.currentSession?.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
