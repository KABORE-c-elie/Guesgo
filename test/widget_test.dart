// Smoke test: confirms the app boots on the ported design system without
// throwing. Repository-layer tests (Étape 8) are what actually exercise
// business logic.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guesgo/app/app.dart';
import 'package:guesgo/core/config/app_config.dart';
import 'package:guesgo/core/config/flavor.dart';

void main() {
  testWidgets('GuesgoApp boots and renders the wordmark', (tester) async {
    final config = AppConfig.fromFlavor(Flavor.dev);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(config)],
        child: const GuesgoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Guesgo'), findsOneWidget);
  });
}
