import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guesgo/app/app.dart';
import 'package:guesgo/core/config/app_config.dart';
import 'package:guesgo/core/config/flavor.dart';
import 'package:guesgo/core/storage/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final savedMoviesBox = await Hive.openBox<Map<dynamic, dynamic>>(
    savedMoviesBoxName,
  );
  final movieCacheBox = await Hive.openBox<Map<dynamic, dynamic>>(
    movieCacheBoxName,
  );

  final config = AppConfig.fromFlavor(Flavor.fromEnvironment());

  // Auth screens are only reachable through user action, so a missing
  // Supabase config (a fresh clone without env.json filled in) fails there
  // instead of blocking the whole app from starting.
  if (config.hasSupabaseConfig) {
    await Supabase.initialize(
      url: config.supabaseUrl,
      // `anonKey` (not the newer `publishableKey`) matches the legacy JWT
      // format this project's Supabase key is issued in.
      // ignore: deprecated_member_use
      anonKey: config.supabaseAnonKey,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        savedMoviesBoxProvider.overrideWithValue(savedMoviesBox),
        movieCacheBoxProvider.overrideWithValue(movieCacheBox),
      ],
      child: const GuesgoApp(),
    ),
  );
}
