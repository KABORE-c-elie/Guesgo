// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "My list" — movies saved for offline access. Kept alive and read from
/// the Hive box on build so it's available instantly from any screen; every
/// mutation goes through [toggle] so the box and this state never drift.

@ProviderFor(SavedMovies)
final savedMoviesProvider = SavedMoviesProvider._();

/// "My list" — movies saved for offline access. Kept alive and read from
/// the Hive box on build so it's available instantly from any screen; every
/// mutation goes through [toggle] so the box and this state never drift.
final class SavedMoviesProvider
    extends $NotifierProvider<SavedMovies, List<Movie>> {
  /// "My list" — movies saved for offline access. Kept alive and read from
  /// the Hive box on build so it's available instantly from any screen; every
  /// mutation goes through [toggle] so the box and this state never drift.
  SavedMoviesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedMoviesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedMoviesHash();

  @$internal
  @override
  SavedMovies create() => SavedMovies();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Movie> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Movie>>(value),
    );
  }
}

String _$savedMoviesHash() => r'1fd76829c8af895b8f4498e3d7c017cf95601b75';

/// "My list" — movies saved for offline access. Kept alive and read from
/// the Hive box on build so it's available instantly from any screen; every
/// mutation goes through [toggle] so the box and this state never drift.

abstract class _$SavedMovies extends $Notifier<List<Movie>> {
  List<Movie> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Movie>, List<Movie>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Movie>, List<Movie>>,
              List<Movie>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
