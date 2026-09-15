import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:guesgo/core/errors/failure.dart';
import 'package:guesgo/core/errors/failure_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Single place where platform/SDK exceptions become domain [Failure]s.
abstract final class ErrorMapper {
  static Failure fromAny(Object error, StackTrace stackTrace) {
    return switch (error) {
      FailureException(:final failure) => failure,
      DioException() => _fromDio(error, stackTrace),
      AuthException() => _fromAuth(error, stackTrace),
      SocketException() || TimeoutException() => NetworkFailure(
        cause: error,
        stackTrace: stackTrace,
      ),
      _ => UnexpectedFailure(cause: error, stackTrace: stackTrace),
    };
  }

  static Failure _fromAuth(AuthException error, StackTrace stackTrace) {
    final code = switch (error.code) {
      'invalid_credentials' => AuthFailureCode.invalidCredentials,
      'user_already_exists' => AuthFailureCode.emailAlreadyInUse,
      'weak_password' => AuthFailureCode.weakPassword,
      'email_address_invalid' || 'validation_failed' =>
        AuthFailureCode.invalidEmail,
      'session_expired' || 'refresh_token_not_found' =>
        AuthFailureCode.tokenExpired,
      _ => AuthFailureCode.unknown,
    };
    final message = switch (code) {
      AuthFailureCode.invalidCredentials => 'Email ou mot de passe incorrect.',
      AuthFailureCode.emailAlreadyInUse => 'Un compte existe déjà avec cet email.',
      AuthFailureCode.weakPassword => 'Mot de passe trop faible.',
      AuthFailureCode.invalidEmail => 'Email invalide.',
      AuthFailureCode.tokenExpired => 'Session expirée, reconnectez-vous.',
      AuthFailureCode.notSignedIn || AuthFailureCode.unknown => error.message,
    };
    return AuthFailure(
      code: code,
      message: message,
      cause: error,
      stackTrace: stackTrace,
    );
  }

  static Failure _fromDio(DioException error, StackTrace stackTrace) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(cause: error, stackTrace: stackTrace);
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 404) {
          return NotFoundFailure(
            resource: error.requestOptions.path,
            message: 'Ressource introuvable.',
            cause: error,
            stackTrace: stackTrace,
          );
        }
        return ServerFailure(
          statusCode: status,
          cause: error,
          stackTrace: stackTrace,
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnexpectedFailure(cause: error, stackTrace: stackTrace);
    }
  }
}
