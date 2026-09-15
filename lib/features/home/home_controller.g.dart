// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One provider per home rail. `trendingMovies` is the feed's loading gate
/// (see `_MovieFeed` in `home_screen.dart`) — the others simply don't render
/// their rail if they come back empty or fail.

@ProviderFor(trendingMovies)
final trendingMoviesProvider = TrendingMoviesProvider._();

/// One provider per home rail. `trendingMovies` is the feed's loading gate
/// (see `_MovieFeed` in `home_screen.dart`) — the others simply don't render
/// their rail if they come back empty or fail.

final class TrendingMoviesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Movie>>,
          List<Movie>,
          FutureOr<List<Movie>>
        >
    with $FutureModifier<List<Movie>>, $FutureProvider<List<Movie>> {
  /// One provider per home rail. `trendingMovies` is the feed's loading gate
  /// (see `_MovieFeed` in `home_screen.dart`) — the others simply don't render
  /// their rail if they come back empty or fail.
  TrendingMoviesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trendingMoviesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trendingMoviesHash();

  @$internal
  @override
  $FutureProviderElement<List<Movie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Movie>> create(Ref ref) {
    return trendingMovies(ref);
  }
}

String _$trendingMoviesHash() => r'f18453c993edd438095e5aaeadf24f5c4f3d329e';

@ProviderFor(popularMovies)
final popularMoviesProvider = PopularMoviesProvider._();

final class PopularMoviesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Movie>>,
          List<Movie>,
          FutureOr<List<Movie>>
        >
    with $FutureModifier<List<Movie>>, $FutureProvider<List<Movie>> {
  PopularMoviesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularMoviesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularMoviesHash();

  @$internal
  @override
  $FutureProviderElement<List<Movie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Movie>> create(Ref ref) {
    return popularMovies(ref);
  }
}

String _$popularMoviesHash() => r'eb457498529a8be3b57680083a4fa7dad5718518';

@ProviderFor(topRatedMovies)
final topRatedMoviesProvider = TopRatedMoviesProvider._();

final class TopRatedMoviesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Movie>>,
          List<Movie>,
          FutureOr<List<Movie>>
        >
    with $FutureModifier<List<Movie>>, $FutureProvider<List<Movie>> {
  TopRatedMoviesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topRatedMoviesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topRatedMoviesHash();

  @$internal
  @override
  $FutureProviderElement<List<Movie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Movie>> create(Ref ref) {
    return topRatedMovies(ref);
  }
}

String _$topRatedMoviesHash() => r'f874a5d1f56c561abf3f90b985dbdfa9d99de573';

@ProviderFor(animeMovies)
final animeMoviesProvider = AnimeMoviesProvider._();

final class AnimeMoviesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Movie>>,
          List<Movie>,
          FutureOr<List<Movie>>
        >
    with $FutureModifier<List<Movie>>, $FutureProvider<List<Movie>> {
  AnimeMoviesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'animeMoviesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$animeMoviesHash();

  @$internal
  @override
  $FutureProviderElement<List<Movie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Movie>> create(Ref ref) {
    return animeMovies(ref);
  }
}

String _$animeMoviesHash() => r'4f9eccafa91582a35875194c0a117f94f7a107cb';
