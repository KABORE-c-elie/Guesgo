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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedMoviesProvider);
    final imageBaseUrl = ref.watch(appConfigProvider).tmdbImageBaseUrl;

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: ScreenHeader(
            title: AppStrings.navDownloads,
            eyebrow: 'Disponible hors-ligne',
          ),
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
