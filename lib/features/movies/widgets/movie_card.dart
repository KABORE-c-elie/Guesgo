import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:guesgo/features/movies/widgets/save_movie_button.dart';
import 'package:guesgo/features/saved/saved_controller.dart';

/// A movie poster with its title. Shared by any feature that lists movies
/// (home, search, downloads) so they stay visually identical, whether laid
/// out in a grid or a horizontal rail.
class MovieCard extends ConsumerWidget {
  const MovieCard({
    required this.movie,
    required this.imageBaseUrl,
    super.key,
    this.onTap,
  });

  final Movie movie;
  final String imageBaseUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(
      savedMoviesProvider.select(
        (movies) => movies.any((m) => m.id == movie.id),
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: AppRadius.brLg,
                    child: MoviePosterImage(
                      imageUrl: movie.posterUrl(imageBaseUrl),
                      seed: movie.id.toString(),
                    ),
                  ),
                ),
                if (movie.voteAverage > 0)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: AppBadge(
                      label: movie.voteAverage.toStringAsFixed(1),
                      icon: Icons.star_rounded,
                      style: BadgeStyle.solid,
                      dense: true,
                    ),
                  ),
                Positioned(
                  top: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: SaveMovieButton(
                    saved: saved,
                    dense: true,
                    onTap: () => ref.read(savedMoviesProvider.notifier).toggle(movie),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
