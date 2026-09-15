import 'package:guesgo/core/storage/hive_boxes.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_movies_repository.g.dart';

@Riverpod(keepAlive: true)
SavedMoviesRepository savedMoviesRepository(Ref ref) {
  return SavedMoviesRepository(ref.watch(savedMoviesBoxProvider));
}

/// Local-only store for "my list" ("available offline"). Unlike
/// [MovieRepository], this doesn't go through the Result/Failure machinery:
/// there's no network and no untrusted external payload to parse, so an
/// on-device box read/write essentially cannot fail in normal use.
class SavedMoviesRepository {
  const SavedMoviesRepository(this._box);

  final Box<Map<dynamic, dynamic>> _box;

  List<Movie> all() => _box.values
      .map((json) => Movie.fromJson(Map<String, dynamic>.from(json)))
      .toList();

  bool isSaved(int movieId) => _box.containsKey(movieId.toString());

  Future<void> save(Movie movie) =>
      _box.put(movie.id.toString(), movie.toJson());

  Future<void> remove(int movieId) => _box.delete(movieId.toString());
}
