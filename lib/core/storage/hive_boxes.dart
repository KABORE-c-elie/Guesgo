import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_boxes.g.dart';

const savedMoviesBoxName = 'saved_movies';
const movieCacheBoxName = 'movie_cache';

/// Must be opened (`Hive.openBox`) and overridden in `main()` before
/// `runApp` — same pattern as [appConfigProvider]: the default throws so a
/// missing override is caught immediately instead of silently running
/// unconfigured.
@Riverpod(keepAlive: true)
Box<Map<dynamic, dynamic>> savedMoviesBox(Ref ref) =>
    throw StateError('savedMoviesBoxProvider must be overridden in main()');

/// Last-known-good TMDB responses, keyed per query (`popular_p1`,
/// `search_dune_p1`...). [MovieRepository] reads from here when a request
/// fails, so the app can still show *something* offline instead of a bare
/// error screen.
@Riverpod(keepAlive: true)
Box<Map<dynamic, dynamic>> movieCacheBox(Ref ref) =>
    throw StateError('movieCacheBoxProvider must be overridden in main()');
