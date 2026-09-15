import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guesgo/app/router/app_routes.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:guesgo/features/movies/widgets/movie_card.dart';

/// Horizontal, swipeable row of movies — the same rail pattern used for
/// event rows: `ListView.separated` on `Axis.horizontal` rather than a
/// fixed grid, so the row scrolls left/right instead of paginating down.
class MovieRail extends StatelessWidget {
  const MovieRail({required this.movies, required this.imageBaseUrl, super.key});

  final List<Movie> movies;
  final String imageBaseUrl;

  static const _cardWidth = 140.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 252,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) => SizedBox(
          width: _cardWidth,
          child: MovieCard(
            movie: movies[index],
            imageBaseUrl: imageBaseUrl,
            onTap: () => context.push(AppRoutes.moviePath(movies[index].id)),
          ),
        ),
      ),
    );
  }
}
