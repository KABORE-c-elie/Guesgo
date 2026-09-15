import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:guesgo/features/saved/data/saved_movies_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_controller.g.dart';

/// "My list" — movies saved for offline access. Kept alive and read from
/// the Hive box on build so it's available instantly from any screen; every
/// mutation goes through [toggle] so the box and this state never drift.
@Riverpod(keepAlive: true)
class SavedMovies extends _$SavedMovies {
  @override
  List<Movie> build() => ref.watch(savedMoviesRepositoryProvider).all();

  bool isSaved(int movieId) => state.any((movie) => movie.id == movieId);

  Future<void> toggle(Movie movie) async {
    final repository = ref.read(savedMoviesRepositoryProvider);
    if (isSaved(movie.id)) {
      await repository.remove(movie.id);
    } else {
      await repository.save(movie);
    }
    state = repository.all();
  }
}
