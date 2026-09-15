/// Typed, exhaustive failure hierarchy.
///
/// Repositories never throw: they return `Result<T>` whose error side is one
/// of these. UI maps them to messages via `failure.message` and can branch on
/// the concrete type with a `switch`.
sealed class Failure {
  const Failure({required this.message, this.cause, this.stackTrace});

  /// Human-readable (French) message safe to show to the user.
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType($message)';
}

enum AuthFailureCode {
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  invalidEmail,
  notSignedIn,
  tokenExpired,
  unknown,
}

final class AuthFailure extends Failure {
  const AuthFailure({
    required this.code,
    required super.message,
    super.cause,
    super.stackTrace,
  });

  const AuthFailure.notSignedIn()
    : this(
        code: AuthFailureCode.notSignedIn,
        message: 'Vous devez être connecté.',
      );

  final AuthFailureCode code;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Connexion impossible. Vérifiez votre réseau.',
    super.cause,
    super.stackTrace,
  });
}

/// Non-2xx response from the server (TMDB or Supabase) that isn't better
/// described by a more specific failure below.
final class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Erreur serveur. Réessayez plus tard.',
    this.statusCode,
    super.cause,
    super.stackTrace,
  });

  final int? statusCode;
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required this.resource,
    required super.message,
    super.cause,
    super.stackTrace,
  });

  final String resource;
}

final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
    super.cause,
    super.stackTrace,
  });

  /// Field name -> error message.
  final Map<String, String> fieldErrors;
}

/// Local cache (Hive) read/write error.
final class CacheFailure extends Failure {
  const CacheFailure({
    super.message = "Erreur d'accès au cache local.",
    super.cause,
    super.stackTrace,
  });
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Une erreur inattendue est survenue.',
    super.cause,
    super.stackTrace,
  });
}
