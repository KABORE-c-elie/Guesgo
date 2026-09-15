// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(movieDetail)
final movieDetailProvider = MovieDetailFamily._();

final class MovieDetailProvider
    extends $FunctionalProvider<AsyncValue<Movie>, Movie, FutureOr<Movie>>
    with $FutureModifier<Movie>, $FutureProvider<Movie> {
  MovieDetailProvider._({
    required MovieDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'movieDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$movieDetailHash();

  @override
  String toString() {
    return r'movieDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Movie> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Movie> create(Ref ref) {
    final argument = this.argument as int;
    return movieDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$movieDetailHash() => r'ed8de9a1b9a0ea3c3ae5d0e864b84b1f87a2228c';

final class MovieDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Movie>, int> {
  MovieDetailFamily._()
    : super(
        retry: null,
        name: r'movieDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MovieDetailProvider call(int movieId) =>
      MovieDetailProvider._(argument: movieId, from: this);

  @override
  String toString() => r'movieDetailProvider';
}
