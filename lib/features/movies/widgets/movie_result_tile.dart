import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:guesgo/features/movies/widgets/save_movie_button.dart';
import 'package:guesgo/features/saved/saved_controller.dart';

/// A movie as one row in a vertical results list — poster thumbnail, title,
/// rating and a synopsis snippet. Used by search and the saved-movies list.
class MovieResultTile extends ConsumerWidget {
  const MovieResultTile({
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
    final text = Theme.of(context).textTheme;
    final t = context.tokens;
    final saved = ref.watch(
      savedMoviesProvider.select(
        (movies) => movies.any((m) => m.id == movie.id),
      ),
    );

    return AppSurface(
      onTap: onTap,
      elevation: SurfaceElevation.flat,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: AppRadius.brMd,
                child: SizedBox(
                  width: 72,
                  height: 108,
                  child: MoviePosterImage(
                    imageUrl: movie.posterUrl(imageBaseUrl),
                    seed: movie.id.toString(),
                  ),
                ),
              ),
              Positioned(
                bottom: AppSpacing.xs,
                right: AppSpacing.xs,
                child: SaveMovieButton(
                  saved: saved,
                  dense: true,
                  onTap: () =>
                      ref.read(savedMoviesProvider.notifier).toggle(movie),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: text.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (movie.voteAverage > 0) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: t.resolve(AppTone.warning).fg,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: text.labelMedium,
                      ),
                    ],
                  ),
                ],
                if (movie.overview.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    movie.overview,
                    style: text.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
