// Smoke test: confirms the app boots on the ported design system without
// throwing. Repository-layer tests are what actually exercise business
// logic — see test/features/**/data/*_repository_test.dart.

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guesgo/app/app.dart';
import 'package:guesgo/core/config/app_config.dart';
import 'package:guesgo/core/config/flavor.dart';
import 'package:guesgo/core/network/connectivity_provider.dart';
import 'package:guesgo/core/storage/hive_boxes.dart';
import 'package:guesgo/features/home/home_controller.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('guesgo_widget_test');
    Hive.init(tempDir.path);
    // google_fonts fetches its font files over the network on first use —
    // in a test environment that has nothing to answer it, it just hangs.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('GuesgoApp boots and renders the home tab', (tester) async {
    final config = AppConfig.fromFlavor(Flavor.dev);

    // Real file I/O (opening a Hive box) never completes inside a plain
    // testWidgets body — its fake/automated clock doesn't drive genuine
    // async platform work. `runAsync` is the documented escape hatch.
    final boxes = await tester.runAsync(() async {
      final saved = await Hive.openBox<Map<dynamic, dynamic>>('saved_test');
      final cache = await Hive.openBox<Map<dynamic, dynamic>>('cache_test');
      return (saved, cache);
    });
    final (savedBox, cacheBox) = boxes!;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(config),
          savedMoviesBoxProvider.overrideWithValue(savedBox),
          movieCacheBoxProvider.overrideWithValue(cacheBox),
          // connectivity_plus talks to a platform channel that has no
          // handler in a widget test — never let a real plugin channel run
          // here, or the stream subscription hangs the test.
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          // No real Dio/TMDB call in a smoke test — this only checks that
          // the widget tree builds, not that the network layer works (that
          // is what the repository tests cover).
          trendingMoviesProvider.overrideWith((ref) async => <Movie>[]),
          popularMoviesProvider.overrideWith((ref) async => <Movie>[]),
          topRatedMoviesProvider.overrideWith((ref) async => <Movie>[]),
          animeMoviesProvider.overrideWith((ref) async => <Movie>[]),
        ],
        child: const GuesgoApp(),
      ),
    );
    // A single pump, not pumpAndSettle: the loading skeleton runs a
    // repeating shimmer animation that never "settles" on its own.
    await tester.pump();

    expect(find.text('Accueil'), findsWidgets);
  });
}
