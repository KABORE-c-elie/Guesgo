import 'package:dio/dio.dart';
import 'package:guesgo/core/errors/error_mapper.dart';
import 'package:guesgo/core/network/dio_client.dart';
import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/core/storage/hive_boxes.dart';
import 'package:guesgo/core/storage/hive_json.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'
    hide AsyncResult;

part 'movie_repository.g.dart';

/// TMDB genre ids the app queries by. TMDB has no "manga" category — the
/// closest is Japanese-language animation, which is what `animation` +
/// `originalLanguage: 'ja'` on [MovieRepository.fetchByGenre] selects.
abstract final class TmdbGenre {
  static const animation = 16;
}

@Riverpod(keepAlive: true)
MovieRepository movieRepository(Ref ref) {
  return MovieRepository(
    ref.watch(tmdbDioProvider),
    ref.watch(movieCacheBoxProvider),
  );
}

/// TMDB-backed movie data, with a cache-on-success / fall-back-on-failure
/// policy: every read that succeeds overwrites its own cache entry: every
/// read that fails (no network, TMDB down...) tries that entry before
/// giving up. The UI never has to know which case it got — offline just
/// looks like slightly stale data instead of a blank error screen.
class MovieRepository {
  const MovieRepository(this._dio, this._cache);

  final Dio _dio;
  final Box<Map<dynamic, dynamic>> _cache;

  AsyncResult<List<Movie>> fetchPopular({int page = 1}) => _fetchListCached(
    'popular_p$page',
    () => _fetch('/movie/popular', {'page': page}),
  );

  AsyncResult<List<Movie>> fetchTrending({int page = 1}) => _fetchListCached(
    'trending_p$page',
    () => _fetch('/trending/movie/week', {'page': page}),
  );

  AsyncResult<List<Movie>> fetchTopRated({int page = 1}) => _fetchListCached(
    'top_rated_p$page',
    () => _fetch('/movie/top_rated', {'page': page}),
  );

  AsyncResult<List<Movie>> fetchByGenre({
    required int genreId,
    String? originalLanguage,
    int page = 1,
  }) => _fetchListCached(
    'genre_${genreId}_${originalLanguage ?? 'any'}_p$page',
    () => _fetch('/discover/movie', {
      'with_genres': genreId,
      'with_original_language': ?originalLanguage,
      'sort_by': 'popularity.desc',
      'page': page,
    }),
  );

  AsyncResult<List<Movie>> fetchSearch({
    required String query,
    int page = 1,
  }) => _fetchListCached(
    'search_${query}_p$page',
    () => _fetch('/search/movie', {'query': query, 'page': page}),
  );

  AsyncResult<Movie> fetchDetail(int id) => _fetchCached<Movie>(
    'detail_$id',
    request: () async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/movie/$id',
        queryParameters: const {},
      );
      return Movie.fromJson(response.data!);
    },
    encode: (movie) => {'movie': movie.toJson()},
    decode: (json) => Movie.fromJson(json['movie'] as Map<String, dynamic>),
  );

  Future<List<Movie>> _fetch(
    String path,
    Map<String, dynamic> queryParameters,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    final results = (response.data!['results'] as List)
        .cast<Map<String, dynamic>>();
    return results.map(Movie.fromJson).toList();
  }

  AsyncResult<List<Movie>> _fetchListCached(
    String cacheKey,
    Future<List<Movie>> Function() request,
  ) => _fetchCached<List<Movie>>(
    cacheKey,
    request: request,
    encode: (movies) => {
      'movies': movies.map((movie) => movie.toJson()).toList(),
    },
    decode: (json) => (json['movies'] as List)
        .cast<Map<String, dynamic>>()
        .map(Movie.fromJson)
        .toList(),
  );

  /// Runs [request]; on success, caches the result under [cacheKey]
  /// (shaped by [encode]) and returns it. On failure, decodes and serves
  /// that cache entry if one exists (via [decode]) — otherwise surfaces
  /// the mapped [Failure]. Shared by every fetch method so "try network,
  /// fall back to cache" is written exactly once regardless of whether
  /// the endpoint returns a list or a single movie.
  AsyncResult<T> _fetchCached<T>(
    String cacheKey, {
    required Future<T> Function() request,
    required Map<String, dynamic> Function(T value) encode,
    required T Function(Map<String, dynamic> json) decode,
  }) async {
    try {
      final value = await request();
      await _cache.put(cacheKey, encode(value));
      return Ok(value);
    } catch (error, stackTrace) {
      final raw = _cache.get(cacheKey);
      if (raw != null) return Ok(decode(deepJsonMap(raw)));
      return Err(ErrorMapper.fromAny(error, stackTrace));
    }
  }
}
