import 'package:guesgo/core/errors/failure.dart';
import 'package:guesgo/core/errors/failure_exception.dart';
import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/features/auth/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'
    hide AsyncResult;
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(Supabase.instance.client);

class AuthRepository {
  const AuthRepository(this._client);

  final SupabaseClient _client;

  AppUser? get currentUser => _toAppUser(_client.auth.currentUser);

  /// Emits on every sign-in/sign-out/token refresh. Never completes.
  Stream<AppUser?> watchUser() => _client.auth.onAuthStateChange.map(
    (state) => _toAppUser(state.session?.user),
  );

  AsyncResult<AppUser> signIn({
    required String email,
    required String password,
  }) => guard(() async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = _toAppUser(response.user);
    if (user == null) {
      throw const FailureException(
        AuthFailure(
          code: AuthFailureCode.invalidCredentials,
          message: 'Email ou mot de passe incorrect.',
        ),
      );
    }
    return user;
  });

  AsyncResult<AppUser> signUp({
    required String email,
    required String password,
    String? name,
  }) => guard(() async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: name == null ? null : {'name': name},
    );
    final user = _toAppUser(response.user);
    if (user == null) {
      throw const FailureException(
        UnexpectedFailure(message: 'Impossible de créer le compte.'),
      );
    }
    return user;
  });

  AsyncResult<void> signOut() => guard(() => _client.auth.signOut());

  AppUser? _toAppUser(User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String?,
      createdAt: DateTime.tryParse(user.createdAt),
      emailConfirmed: user.emailConfirmedAt != null,
    );
  }
}
