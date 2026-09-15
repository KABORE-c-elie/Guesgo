import 'package:dio/dio.dart';
import 'package:guesgo/core/network/dio_client.dart';
import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
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
  return MovieRepository(ref.watch(tmdbDioProvider));
}

class MovieRepository {
  const MovieRepository(this._dio);

  final Dio _dio;

  AsyncResult<List<Movie>> fetchPopular({int page = 1}) => guard(
    () => _fetch('/movie/popular', {'page': page}),
  );

  AsyncResult<List<Movie>> fetchTrending({int page = 1}) => guard(
    () => _fetch('/trending/movie/week', {'page': page}),
  );

  AsyncResult<List<Movie>> fetchTopRated({int page = 1}) => guard(
    () => _fetch('/movie/top_rated', {'page': page}),
  );

  AsyncResult<List<Movie>> fetchByGenre({
    required int genreId,
    String? originalLanguage,
    int page = 1,
  }) => guard(
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
  }) => guard(() => _fetch('/search/movie', {'query': query, 'page': page}));

  AsyncResult<Movie> fetchDetail(int id) => guard(() async {
    final response = await _dio.get<Map<String, dynamic>>('/movie/$id');
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
}
