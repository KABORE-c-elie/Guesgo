import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guesgo/app/router/app_routes.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/config/app_config.dart';
import 'package:guesgo/core/l10n/app_strings.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/movies/widgets/movie_result_tile.dart';
import 'package:guesgo/features/saved/saved_controller.dart';

/// "My list" — movies saved locally (via [SaveMovieButton] on any card),
/// so they stay browsable even offline. There's no video file behind an
/// entry yet, only its TMDB data.
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  Future<void> _clearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmSheet(
      context,
      icon: Icons.delete_sweep_outlined,
      title: 'Vider la liste',
      message: 'Tous les films enregistrés seront retirés. Cette action est irréversible.',
      confirmLabel: 'Vider',
    );
    if (!confirmed) return;
    await ref.read(savedMoviesProvider.notifier).clearAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedMoviesProvider);
    final imageBaseUrl = ref.watch(appConfigProvider).tmdbImageBaseUrl;

    return CustomScrollView(
      slivers: [
        AppTopBar(
          title: AppStrings.navDownloads,
          subtitle: 'Disponible hors-ligne',
          actions: saved.isEmpty
              ? const []
              : [
                  IconActionButton(
                    icon: Icons.delete_sweep_outlined,
                    tooltip: 'Vider la liste',
                    onPressed: () => _clearAll(context, ref),
                  ),
                ],
        ),
        if (saved.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(
              icon: Icons.bookmark_border_rounded,
              title: 'Ma liste est vide',
              message:
                  "Appuyez sur l'icône de signet d'un film, depuis l'accueil "
                  'ou la recherche, pour le retrouver ici.',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
            sliver: SliverList.separated(
              itemCount: saved.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) => MovieResultTile(
                movie: saved[index],
                imageBaseUrl: imageBaseUrl,
                onTap: () => context.push(AppRoutes.moviePath(saved[index].id)),
              ),
            ),
          ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: AppSizes.navBarInset),
        ),
      ],
    );
  }
}
