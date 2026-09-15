import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/features/movies/data/movie_repository.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_controller.g.dart';

@riverpod
class MovieSearchQuery extends _$MovieSearchQuery {
  @override
  String build() => '';

  void set(String value) => state = value;

  void clear() => state = '';
}

/// Debounced search: on every keystroke this provider re-runs from the top,
/// so an in-flight 400ms wait from a stale keystroke never reaches the
/// network call below it — only the invocation still current when the
/// delay elapses does. No timer/cancellation bookkeeping needed.
@riverpod
Future<List<Movie>> movieSearchResults(Ref ref) async {
  final query = ref.watch(movieSearchQueryProvider).trim();
  if (query.isEmpty) return const [];

  await Future<void>.delayed(const Duration(milliseconds: 400));

  return (await ref
          .watch(movieRepositoryProvider)
          .fetchSearch(query: query))
      .unwrapOrThrow();
}
