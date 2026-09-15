import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/features/movies/data/movie_repository.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

/// One provider per home rail. `trendingMovies` is the feed's loading gate
/// (see `_MovieFeed` in `home_screen.dart`) — the others simply don't render
/// their rail if they come back empty or fail.
@riverpod
Future<List<Movie>> trendingMovies(Ref ref) async =>
    (await ref.watch(movieRepositoryProvider).fetchTrending()).unwrapOrThrow();

@riverpod
Future<List<Movie>> popularMovies(Ref ref) async =>
    (await ref.watch(movieRepositoryProvider).fetchPopular()).unwrapOrThrow();

@riverpod
Future<List<Movie>> topRatedMovies(Ref ref) async =>
    (await ref.watch(movieRepositoryProvider).fetchTopRated()).unwrapOrThrow();

@riverpod
Future<List<Movie>> animeMovies(Ref ref) async =>
    (await ref
            .watch(movieRepositoryProvider)
            .fetchByGenre(genreId: TmdbGenre.animation, originalLanguage: 'ja'))
        .unwrapOrThrow();
