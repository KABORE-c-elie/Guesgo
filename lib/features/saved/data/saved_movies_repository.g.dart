// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_movies_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(savedMoviesRepository)
final savedMoviesRepositoryProvider = SavedMoviesRepositoryProvider._();

final class SavedMoviesRepositoryProvider
    extends
        $FunctionalProvider<
          SavedMoviesRepository,
          SavedMoviesRepository,
          SavedMoviesRepository
        >
    with $Provider<SavedMoviesRepository> {
  SavedMoviesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedMoviesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedMoviesRepositoryHash();

  @$internal
  @override
  $ProviderElement<SavedMoviesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SavedMoviesRepository create(Ref ref) {
    return savedMoviesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SavedMoviesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SavedMoviesRepository>(value),
    );
  }
}

String _$savedMoviesRepositoryHash() =>
    r'99815a33fd3b1a5d4972b5cbc5642003fa887d4f';
