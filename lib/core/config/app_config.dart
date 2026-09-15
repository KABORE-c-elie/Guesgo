import 'package:guesgo/core/config/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

/// Immutable runtime configuration derived from the [Flavor].
///
/// Secrets (TMDB API key, Supabase URL/anon key) are never hard-coded: they
/// are read from `--dart-define` at build/run time, so they never land in a
/// versioned file. See the README for the exact command to run locally.
@immutable
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.tmdbApiKey,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.tmdbBaseUrl = 'https://api.themoviedb.org/3',
    this.tmdbImageBaseUrl = 'https://image.tmdb.org/t/p',
  });

  factory AppConfig.fromFlavor(Flavor flavor) {
    // `String.fromEnvironment` must be a compile-time constant, so the key
    // is read once here rather than per-flavor.
    const tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    return switch (flavor) {
      Flavor.dev => const AppConfig(
        flavor: Flavor.dev,
        appName: 'Guesgo (dev)',
        tmdbApiKey: tmdbApiKey,
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey,
      ),
      Flavor.staging => const AppConfig(
        flavor: Flavor.staging,
        appName: 'Guesgo (staging)',
        tmdbApiKey: tmdbApiKey,
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey,
      ),
      Flavor.prod => const AppConfig(
        flavor: Flavor.prod,
        appName: 'Guesgo',
        tmdbApiKey: tmdbApiKey,
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey,
      ),
    };
  }

  final Flavor flavor;
  final String appName;

  /// TMDB v3 API key (query param `api_key`). Get one free at
  /// themoviedb.org/settings/api.
  final String tmdbApiKey;
  final String tmdbBaseUrl;
  final String tmdbImageBaseUrl;

  /// Supabase project REST endpoint and anon (public) key. The anon key is
  /// safe to ship client-side — Supabase's row-level security, not secrecy
  /// of this key, is what protects data — but it still comes from
  /// `--dart-define` so each developer/CI targets their own project.
  final String supabaseUrl;
  final String supabaseAnonKey;

  bool get hasTmdbKey => tmdbApiKey.isNotEmpty;

  bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}

/// Must be overridden in `main()`; the default throws on purpose so a
/// missing override is caught immediately instead of silently running
/// unconfigured.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) =>
    throw StateError('appConfigProvider must be overridden in main()');

/// Injectable clock. Override in tests to freeze time.
typedef Clock = DateTime Function();

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => DateTime.now;
