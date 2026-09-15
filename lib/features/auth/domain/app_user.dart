import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

/// Authenticated identity (Supabase Auth user). The password never lives
/// here — Supabase Auth owns credentials.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    String? name,
    DateTime? createdAt,
    @Default(false) bool emailConfirmed,
  }) = _AppUser;
}
