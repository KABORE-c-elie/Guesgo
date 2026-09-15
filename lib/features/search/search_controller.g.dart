// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MovieSearchQuery)
final movieSearchQueryProvider = MovieSearchQueryProvider._();

final class MovieSearchQueryProvider
    extends $NotifierProvider<MovieSearchQuery, String> {
  MovieSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movieSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movieSearchQueryHash();

  @$internal
  @override
  MovieSearchQuery create() => MovieSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$movieSearchQueryHash() => r'90bfa83fc04fd887d7c7655e06d94915e17d8fad';

abstract class _$MovieSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Debounced search: on every keystroke this provider re-runs from the top,
/// so an in-flight 400ms wait from a stale keystroke never reaches the
/// network call below it — only the invocation still current when the
/// delay elapses does. No timer/cancellation bookkeeping needed.

@ProviderFor(movieSearchResults)
final movieSearchResultsProvider = MovieSearchResultsProvider._();

/// Debounced search: on every keystroke this provider re-runs from the top,
/// so an in-flight 400ms wait from a stale keystroke never reaches the
/// network call below it — only the invocation still current when the
/// delay elapses does. No timer/cancellation bookkeeping needed.

final class MovieSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Movie>>,
          List<Movie>,
          FutureOr<List<Movie>>
        >
    with $FutureModifier<List<Movie>>, $FutureProvider<List<Movie>> {
  /// Debounced search: on every keystroke this provider re-runs from the top,
  /// so an in-flight 400ms wait from a stale keystroke never reaches the
  /// network call below it — only the invocation still current when the
  /// delay elapses does. No timer/cancellation bookkeeping needed.
  MovieSearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movieSearchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movieSearchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<Movie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Movie>> create(Ref ref) {
    return movieSearchResults(ref);
  }
}

String _$movieSearchResultsHash() =>
    r'9b512935c829eba72fd6ea0b02664196483f92d3';
