import 'package:guesgo/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Shown instead of the real app when required configuration
/// (TMDB API key / Supabase URL & anon key) is missing. Keeps the failure
/// visible and actionable instead of a silent blank screen or a crash.
class BootstrapErrorApp extends StatelessWidget {
  const BootstrapErrorApp({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.settings_suggest_outlined, size: 72),
                const SizedBox(height: 24),
                Text(
                  'Configuration manquante',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Relancez avec --dart-define=TMDB_API_KEY=... '
                  '--dart-define=SUPABASE_URL=... '
                  '--dart-define=SUPABASE_ANON_KEY=... (voir le README).',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SelectableText(
                  '$error',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
