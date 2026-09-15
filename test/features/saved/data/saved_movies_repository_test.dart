import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:guesgo/features/movies/domain/genre.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:guesgo/features/saved/data/saved_movies_repository.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<Map<dynamic, dynamic>> box;
  late SavedMoviesRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('guesgo_saved_repo_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<Map<dynamic, dynamic>>('saved_movies_test');
    repository = SavedMoviesRepository(box);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('save then isSaved reflects the stored movie', () async {
    const movie = Movie(id: 42, title: 'Interstellar', overview: '...');
    expect(repository.isSaved(42), isFalse);

    await repository.save(movie);

    expect(repository.isSaved(42), isTrue);
    expect(repository.all().single.title, 'Interstellar');
  });

  test('remove deletes the movie from the saved list', () async {
    const movie = Movie(id: 7, title: 'Arrival', overview: '...');
    await repository.save(movie);

    await repository.remove(7);

    expect(repository.isSaved(7), isFalse);
    expect(repository.all(), isEmpty);
  });

  test(
    'save then all() round-trips a movie with nested genres through Hive',
    () async {
      // Regression: Hive returns nested maps as `Map<dynamic, dynamic>`,
      // which used to crash `Movie.fromJson` on read-back (`genres` casts
      // its entries straight to `Map<String, dynamic>`).
      const movie = Movie(
        id: 1,
        title: 'Dune',
        overview: 'Desert planet.',
        genres: [Genre(id: 878, name: 'Science-Fiction')],
      );

      await repository.save(movie);

      expect(repository.all().single.genres!.single.name, 'Science-Fiction');
    },
  );
}
