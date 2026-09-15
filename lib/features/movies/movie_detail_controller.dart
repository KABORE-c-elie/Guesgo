import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/features/movies/data/movie_repository.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'
    hide AsyncResult;

part 'movie_detail_controller.g.dart';

@riverpod
Future<Movie> movieDetail(Ref ref, int movieId) async => (await ref
        .watch(movieRepositoryProvider)
        .fetchDetail(movieId))
    .unwrapOrThrow();
