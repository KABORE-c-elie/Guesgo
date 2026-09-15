// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `true` once the device reports at least one connected interface. Powers
/// [OfflineBanner] — the visible half of "mode hors-ligne": data falling
/// back to cache is invisible on its own, this is what tells the user why
/// what they're seeing might be stale.

@ProviderFor(isOnline)
final isOnlineProvider = IsOnlineProvider._();

/// `true` once the device reports at least one connected interface. Powers
/// [OfflineBanner] — the visible half of "mode hors-ligne": data falling
/// back to cache is invisible on its own, this is what tells the user why
/// what they're seeing might be stale.

final class IsOnlineProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// `true` once the device reports at least one connected interface. Powers
  /// [OfflineBanner] — the visible half of "mode hors-ligne": data falling
  /// back to cache is invisible on its own, this is what tells the user why
  /// what they're seeing might be stale.
  IsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnlineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnlineHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return isOnline(ref);
  }
}

String _$isOnlineHash() => r'c4f7b716ad1dc27174bac570f69fcda2cd0d1d8d';
