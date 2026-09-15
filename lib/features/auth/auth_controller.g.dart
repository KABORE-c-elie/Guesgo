// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in user, or `null` when signed out. Sourced from Supabase's
/// auth-state stream, which emits the current session immediately on
/// subscribe — so this doesn't need a separate "restore session" step.

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// The signed-in user, or `null` when signed out. Sourced from Supabase's
/// auth-state stream, which emits the current session immediately on
/// subscribe — so this doesn't need a separate "restore session" step.

final class AuthStateProvider
    extends
        $FunctionalProvider<AsyncValue<AppUser?>, AppUser?, Stream<AppUser?>>
    with $FutureModifier<AppUser?>, $StreamProvider<AppUser?> {
  /// The signed-in user, or `null` when signed out. Sourced from Supabase's
  /// auth-state stream, which emits the current session immediately on
  /// subscribe — so this doesn't need a separate "restore session" step.
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<AppUser?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AppUser?> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'2e090c37b1f90224c29936800a45af16026b21c1';

/// Drives auth actions from the UI. `state` mirrors the in-flight action
/// (loading/error) while the actual session comes from [authStateProvider].
///
/// `keepAlive`: sign-out is triggered from the profile screen, which never
/// watches this provider (only sign-in/up screens do, for their loading
/// spinner) — without `keepAlive`, autoDispose tears it down the instant
/// that `ref.read` returns, and the pending `signOut()` future then crashes
/// trying to write `state` on a disposed provider.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Drives auth actions from the UI. `state` mirrors the in-flight action
/// (loading/error) while the actual session comes from [authStateProvider].
///
/// `keepAlive`: sign-out is triggered from the profile screen, which never
/// watches this provider (only sign-in/up screens do, for their loading
/// spinner) — without `keepAlive`, autoDispose tears it down the instant
/// that `ref.read` returns, and the pending `signOut()` future then crashes
/// trying to write `state` on a disposed provider.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, void> {
  /// Drives auth actions from the UI. `state` mirrors the in-flight action
  /// (loading/error) while the actual session comes from [authStateProvider].
  ///
  /// `keepAlive`: sign-out is triggered from the profile screen, which never
  /// watches this provider (only sign-in/up screens do, for their loading
  /// spinner) — without `keepAlive`, autoDispose tears it down the instant
  /// that `ref.read` returns, and the pending `signOut()` future then crashes
  /// trying to write `state` on a disposed provider.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'c7ed4f4b1d009f003719a667ebcc650cc57b0a21';

/// Drives auth actions from the UI. `state` mirrors the in-flight action
/// (loading/error) while the actual session comes from [authStateProvider].
///
/// `keepAlive`: sign-out is triggered from the profile screen, which never
/// watches this provider (only sign-in/up screens do, for their loading
/// spinner) — without `keepAlive`, autoDispose tears it down the instant
/// that `ref.read` returns, and the pending `signOut()` future then crashes
/// trying to write `state` on a disposed provider.

abstract class _$AuthController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
