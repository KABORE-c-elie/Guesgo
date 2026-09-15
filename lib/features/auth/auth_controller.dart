import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/features/auth/data/auth_repository.dart';
import 'package:guesgo/features/auth/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'
    hide AsyncResult;

part 'auth_controller.g.dart';

/// The signed-in user, or `null` when signed out. Sourced from Supabase's
/// auth-state stream, which emits the current session immediately on
/// subscribe — so this doesn't need a separate "restore session" step.
@Riverpod(keepAlive: true)
Stream<AppUser?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).watchUser();

/// Drives auth actions from the UI. `state` mirrors the in-flight action
/// (loading/error) while the actual session comes from [authStateProvider].
///
/// `keepAlive`: sign-out is triggered from the profile screen, which never
/// watches this provider (only sign-in/up screens do, for their loading
/// spinner) — without `keepAlive`, autoDispose tears it down the instant
/// that `ref.read` returns, and the pending `signOut()` future then crashes
/// trying to write `state` on a disposed provider.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) => _run(
    () => ref
        .read(authRepositoryProvider)
        .signIn(email: email, password: password),
  );

  Future<Result<AppUser>> signUp({
    required String email,
    required String password,
    String? name,
  }) => _run(
    () => ref
        .read(authRepositoryProvider)
        .signUp(email: email, password: password, name: name),
  );

  Future<Result<void>> signOut() =>
      _run(() => ref.read(authRepositoryProvider).signOut());

  Future<Result<T>> _run<T>(AsyncResult<T> Function() action) async {
    state = const AsyncLoading();
    final result = await action();
    state = switch (result) {
      Ok() => const AsyncData(null),
      Err(:final failure) => AsyncError(
        failure,
        failure.stackTrace ?? StackTrace.current,
      ),
    };
    return result;
  }
}
