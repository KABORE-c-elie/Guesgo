import 'package:dio/dio.dart';
import 'package:guesgo/core/config/app_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// Dio pre-configured for TMDB: base URL and the `api_key`/`language` query
/// params every TMDB call needs, set once instead of at each call site.
@Riverpod(keepAlive: true)
Dio tmdbDio(Ref ref) {
  final config = ref.watch(appConfigProvider);
  return Dio(
    BaseOptions(
      baseUrl: config.tmdbBaseUrl,
      queryParameters: {'api_key': config.tmdbApiKey, 'language': 'fr-FR'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
}
