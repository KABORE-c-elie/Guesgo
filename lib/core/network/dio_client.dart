import 'package:dio/dio.dart';
import 'package:guesgo/core/config/app_config.dart';
import 'package:guesgo/core/network/auth_interceptor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dio_client.g.dart';

/// Dio pre-configured for TMDB: base URL and the `api_key`/`language` query
/// params every TMDB call needs, set once instead of at each call site.
@Riverpod(keepAlive: true)
Dio tmdbDio(Ref ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.tmdbBaseUrl,
      queryParameters: {'api_key': config.tmdbApiKey, 'language': 'fr-FR'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Guarded: `Supabase.instance` throws if `Supabase.initialize` was never
  // called (a dev environment with no Supabase config — see main.dart).
  if (config.hasSupabaseConfig) {
    dio.interceptors.add(AuthInterceptor(Supabase.instance.client));
  }

  return dio;
}
