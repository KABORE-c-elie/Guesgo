// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_boxes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Must be opened (`Hive.openBox`) and overridden in `main()` before
/// `runApp` — same pattern as [appConfigProvider]: the default throws so a
/// missing override is caught immediately instead of silently running
/// unconfigured.

@ProviderFor(savedMoviesBox)
final savedMoviesBoxProvider = SavedMoviesBoxProvider._();

/// Must be opened (`Hive.openBox`) and overridden in `main()` before
/// `runApp` — same pattern as [appConfigProvider]: the default throws so a
/// missing override is caught immediately instead of silently running
/// unconfigured.

final class SavedMoviesBoxProvider
    extends
        $FunctionalProvider<
          Box<Map<dynamic, dynamic>>,
          Box<Map<dynamic, dynamic>>,
          Box<Map<dynamic, dynamic>>
        >
    with $Provider<Box<Map<dynamic, dynamic>>> {
  /// Must be opened (`Hive.openBox`) and overridden in `main()` before
  /// `runApp` — same pattern as [appConfigProvider]: the default throws so a
  /// missing override is caught immediately instead of silently running
  /// unconfigured.
  SavedMoviesBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedMoviesBoxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedMoviesBoxHash();

  @$internal
  @override
  $ProviderElement<Box<Map<dynamic, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Box<Map<dynamic, dynamic>> create(Ref ref) {
    return savedMoviesBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<Map<dynamic, dynamic>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<Map<dynamic, dynamic>>>(value),
    );
  }
}

String _$savedMoviesBoxHash() => r'b41c41f86cbf3892e74439eb50734b47e2b698a7';

/// Last-known-good TMDB responses, keyed per query (`popular_p1`,
/// `search_dune_p1`...). [MovieRepository] reads from here when a request
/// fails, so the app can still show *something* offline instead of a bare
/// error screen.

@ProviderFor(movieCacheBox)
final movieCacheBoxProvider = MovieCacheBoxProvider._();

/// Last-known-good TMDB responses, keyed per query (`popular_p1`,
/// `search_dune_p1`...). [MovieRepository] reads from here when a request
/// fails, so the app can still show *something* offline instead of a bare
/// error screen.

final class MovieCacheBoxProvider
    extends
        $FunctionalProvider<
          Box<Map<dynamic, dynamic>>,
          Box<Map<dynamic, dynamic>>,
          Box<Map<dynamic, dynamic>>
        >
    with $Provider<Box<Map<dynamic, dynamic>>> {
  /// Last-known-good TMDB responses, keyed per query (`popular_p1`,
  /// `search_dune_p1`...). [MovieRepository] reads from here when a request
  /// fails, so the app can still show *something* offline instead of a bare
  /// error screen.
  MovieCacheBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movieCacheBoxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movieCacheBoxHash();

  @$internal
  @override
  $ProviderElement<Box<Map<dynamic, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Box<Map<dynamic, dynamic>> create(Ref ref) {
    return movieCacheBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<Map<dynamic, dynamic>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<Map<dynamic, dynamic>>>(value),
    );
  }
}

String _$movieCacheBoxHash() => r'b08dd562c8e10c1d75b30af953d0c1ff093197e7';
