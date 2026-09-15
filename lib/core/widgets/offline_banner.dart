import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/network/connectivity_provider.dart';

/// Shown whenever the device has no network — the visible signal that
/// what's on screen is the last cached response, not a live one.
/// Collapses to nothing the moment connectivity returns.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider).value ?? true;
    if (online) return const SizedBox.shrink();

    final t = context.tokens;
    final colors = t.resolve(AppTone.warning);

    return Container(
      width: double.infinity,
      color: colors.bg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gutter,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: 14, color: colors.fg),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Hors-ligne — affichage des données enregistrées',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: colors.fg),
            ),
          ),
        ],
      ),
    );
  }
}
