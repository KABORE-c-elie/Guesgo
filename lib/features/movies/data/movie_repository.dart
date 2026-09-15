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

  AsyncResult<Movie> fetchDetail(int id) => _fetchOneCached('detail_$id', () async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/movie/$id',
      queryParameters: const {},
    );
    return Movie.fromJson(response.data!);
  });

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

  /// Runs [request]; on success, caches the list under [cacheKey] and
  /// returns it. On failure, serves the cached list for that key if one
  /// exists — otherwise surfaces the mapped [Failure].
  AsyncResult<List<Movie>> _fetchListCached(
    String cacheKey,
    Future<List<Movie>> Function() request,
  ) async {
    try {
      final movies = await request();
      await _cache.put(cacheKey, {
        'movies': movies.map((movie) => movie.toJson()).toList(),
      });
      return Ok(movies);
    } catch (error, stackTrace) {
      final cached = _cachedMovies(cacheKey);
      if (cached != null) return Ok(cached);
      return Err(ErrorMapper.fromAny(error, stackTrace));
    }
  }

  AsyncResult<Movie> _fetchOneCached(
    String cacheKey,
    Future<Movie> Function() request,
  ) async {
    try {
      final movie = await request();
      await _cache.put(cacheKey, {'movie': movie.toJson()});
      return Ok(movie);
    } catch (error, stackTrace) {
      final cached = _cachedMovie(cacheKey);
      if (cached != null) return Ok(cached);
      return Err(ErrorMapper.fromAny(error, stackTrace));
    }
  }

  List<Movie>? _cachedMovies(String cacheKey) {
    final raw = _cache.get(cacheKey);
    if (raw == null) return null;
    final list = (raw['movies'] as List).cast<Map<dynamic, dynamic>>();
    return list.map((json) => Movie.fromJson(deepJsonMap(json))).toList();
  }

  Movie? _cachedMovie(String cacheKey) {
    final raw = _cache.get(cacheKey);
    if (raw == null) return null;
    return Movie.fromJson(deepJsonMap(raw['movie'] as Map));
  }
}
