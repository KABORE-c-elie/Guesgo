import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guesgo/core/errors/failure.dart';
import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/features/movies/data/movie_repository.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _popularResponse() => Response(
  requestOptions: RequestOptions(path: '/movie/popular'),
  statusCode: 200,
  data: {
    'results': [
      {
        'id': 1,
        'title': 'Dune',
        'overview': 'Desert planet.',
        'vote_average': 8.1,
      },
    ],
  },
);

DioException _offlineError(String path) => DioException(
  requestOptions: RequestOptions(path: path),
  type: DioExceptionType.connectionError,
);

void main() {
  late Directory tempDir;
  late Box<Map<dynamic, dynamic>> cache;
  late _MockDio dio;
  late MovieRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('guesgo_movie_repo_test');
    Hive.init(tempDir.path);
    cache = await Hive.openBox<Map<dynamic, dynamic>>('movie_cache_test');
    dio = _MockDio();
    repository = MovieRepository(dio, cache);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('fetchPopular parses movies from the API and caches them', () async {
    when(
      () => dio.get<Map<String, dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => _popularResponse());

    final result = await repository.fetchPopular();

    expect(result, isA<Ok<List<Movie>>>());
    final movies = (result as Ok<List<Movie>>).value;
    expect(movies.single.title, 'Dune');
    expect(cache.get('popular_p1'), isNotNull);
  });

  test(
    'fetchPopular serves the cached list when the network is unreachable',
    () async {
      // First call succeeds and populates the cache.
      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => _popularResponse());
      await repository.fetchPopular();

      // Second call: the network is now down (e.g. plane mode).
      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(_offlineError('/movie/popular'));

      final result = await repository.fetchPopular();

      expect(result, isA<Ok<List<Movie>>>());
      expect((result as Ok<List<Movie>>).value.single.title, 'Dune');
    },
  );

  test(
    'fetchPopular returns a NetworkFailure when offline with nothing cached',
    () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(_offlineError('/movie/popular'));

      final result = await repository.fetchPopular();

      expect(result, isA<Err<List<Movie>>>());
      expect((result as Err<List<Movie>>).failure, isA<NetworkFailure>());
    },
  );

  test('fetchDetail parses genres and runtime from the detail endpoint', () async {
    when(
      () => dio.get<Map<String, dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/movie/1'),
        statusCode: 200,
        data: {
          'id': 1,
          'title': 'Dune',
          'overview': 'Desert planet.',
          'vote_average': 8.1,
          'runtime': 155,
          'genres': [
            {'id': 878, 'name': 'Science-Fiction'},
          ],
        },
      ),
    );

    final result = await repository.fetchDetail(1);

    expect(result, isA<Ok<Movie>>());
    final movie = (result as Ok<Movie>).value;
    expect(movie.runtimeLabel, '2h35');
    expect(movie.genres!.single.name, 'Science-Fiction');
  });

  test(
    'fetchDetail serves a cached movie with nested genres when offline',
    () async {
      // Hive round-trips nested maps (inside `genres`) as `Map<dynamic,
      // dynamic>`, not `Map<String, dynamic>` — this regresses if the
      // cache read stops deep-converting them before calling fromJson.
      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/movie/1'),
          statusCode: 200,
          data: {
            'id': 1,
            'title': 'Dune',
            'overview': 'Desert planet.',
            'vote_average': 8.1,
            'genres': [
              {'id': 878, 'name': 'Science-Fiction'},
            ],
          },
        ),
      );
      await repository.fetchDetail(1); // populates the cache

      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(_offlineError('/movie/1'));

      final result = await repository.fetchDetail(1);

      expect(result, isA<Ok<Movie>>());
      final movie = (result as Ok<Movie>).value;
      expect(movie.genres!.single.name, 'Science-Fiction');
    },
  );
}
