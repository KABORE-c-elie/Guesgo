// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dio pre-configured for TMDB: base URL and the `api_key`/`language` query
/// params every TMDB call needs, set once instead of at each call site.

@ProviderFor(tmdbDio)
final tmdbDioProvider = TmdbDioProvider._();

/// Dio pre-configured for TMDB: base URL and the `api_key`/`language` query
/// params every TMDB call needs, set once instead of at each call site.

final class TmdbDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dio pre-configured for TMDB: base URL and the `api_key`/`language` query
  /// params every TMDB call needs, set once instead of at each call site.
  TmdbDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tmdbDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tmdbDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return tmdbDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$tmdbDioHash() => r'5ca00936d1d437ed2e749629f62be0077fbbf203';
