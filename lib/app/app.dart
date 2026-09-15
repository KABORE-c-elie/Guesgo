import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guesgo/app/router/app_router.dart';
import 'package:guesgo/app/theme/theme.dart';

/// Application root.
class GuesgoApp extends ConsumerWidget {
  const GuesgoApp({super.key});

  /// Accessibility text scaling is honoured but bounded: past ~1.35 dense
  /// cards break apart. Clamping is the honest trade-off — the alternative
  /// is ignoring the setting entirely.
  static const _minTextScale = 0.85;
  static const _maxTextScale = 1.35;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Guesgo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      themeAnimationDuration: AppTheme.themeSwitchDuration,
      themeAnimationCurve: AppMotion.standard,
      scrollBehavior: const _AppScrollBehavior(),
      routerConfig: router,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: media.textScaler.clamp(
              minScaleFactor: _minTextScale,
              maxScaleFactor: _maxTextScale,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

/// Lets the app be dragged with a mouse or a stylus (desktop, web previews)
/// and keeps the iOS bouncing physics on every platform.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
