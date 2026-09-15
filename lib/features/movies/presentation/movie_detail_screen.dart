import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guesgo/app/router/app_routes.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/config/app_config.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:guesgo/features/movies/movie_detail_controller.dart';
import 'package:guesgo/features/movies/widgets/save_movie_button.dart';
import 'package:guesgo/features/saved/saved_controller.dart';

/// Movie detail. Structure mirrors the app's other "conversion" screens: a
/// full-bleed hero establishes the subject, a content sheet **overlapping**
/// the image pulls the eye down into the facts.
class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({required this.movieId, super.key});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = ref.watch(movieDetailProvider(movieId));

    return AppScaffold(
      constrainWidth: false,
      showBlooms: false,
      body: AsyncValueWidget<Movie>(
        value: movie,
        onRetry: () => ref.invalidate(movieDetailProvider(movieId)),
        loading: const _DetailSkeleton(),
        data: (movie) => _Body(movie: movie),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final text = Theme.of(context).textTheme;
    final imageBaseUrl = ref.watch(appConfigProvider).tmdbImageBaseUrl;
    final saved = ref.watch(
      savedMoviesProvider.select(
        (movies) => movies.any((m) => m.id == movie.id),
      ),
    );

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Hero(movie: movie, imageBaseUrl: imageBaseUrl),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -32),
                child: Container(
                  decoration: BoxDecoration(
                    color: t.canvas,
                    borderRadius: AppRadius.brSheet,
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    // Must clear the -32 translate below with room to spare,
                    // or the title sits on top of the hero image instead of
                    // under the rounded sheet edge.
                    AppSpacing.giant,
                    AppSpacing.gutter,
                    AppSpacing.xxxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: text.displaySmall?.copyWith(height: 1.15),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          SaveMovieButton(
                            saved: saved,
                            onTap: () => ref
                                .read(savedMoviesProvider.notifier)
                                .toggle(movie),
                          ),
                        ],
                      ),
                      if ((movie.tagline ?? '').isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          movie.tagline!,
                          style: text.bodyMedium?.copyWith(
                            color: t.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      _MetaRow(movie: movie),
                      if ((movie.genres ?? const []).isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            for (final genre in movie.genres!)
                              AppBadge(
                                label: genre.name,
                                style: BadgeStyle.outline,
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxxl),
                      const SectionLabel('Synopsis'),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        movie.overview.isEmpty
                            ? 'Aucun synopsis disponible.'
                            : movie.overview,
                        style: text.bodyLarge?.copyWith(
                          color: t.textSecondary,
                          height: 1.65,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
          left: AppSpacing.lg,
          child: OverlayIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Retour',
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(AppRoutes.home),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.movie, required this.imageBaseUrl});

  final Movie movie;
  final String imageBaseUrl;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    // TMDB backdrops are 16:9 — matching the box to that ratio means
    // BoxFit.cover never has to crop away a meaningful chunk of the image.
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MoviePosterImage(
            imageUrl: movie.backdropUrl(imageBaseUrl),
            seed: movie.id.toString(),
          ),
          DecoratedBox(decoration: BoxDecoration(gradient: t.heroScrim)),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (movie.voteAverage > 0)
        _MetaItem(
          icon: Icons.star_rounded,
          label: movie.voteAverage.toStringAsFixed(1),
          tone: AppTone.warning,
        ),
      if (movie.releaseYear != null)
        _MetaItem(icon: Icons.calendar_today_rounded, label: movie.releaseYear!),
      if (movie.runtimeLabel != null)
        _MetaItem(icon: Icons.schedule_rounded, label: movie.runtimeLabel!),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: AppSpacing.lg, runSpacing: AppSpacing.sm, children: items);
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label, this.tone});

  final IconData icon;
  final String label;
  final AppTone? tone;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = tone == null ? t.textSecondary : t.resolve(tone!).fg;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AspectRatio(
        aspectRatio: 16 / 9,
        child: Skeleton(width: double.infinity, height: double.infinity, radius: 0),
      ),
      SizedBox(height: AppSpacing.xl),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton(height: 30),
            SizedBox(height: AppSpacing.sm),
            Skeleton(width: 220, height: 30),
            SizedBox(height: AppSpacing.xxl),
            SkeletonParagraph(lines: 4),
          ],
        ),
      ),
    ],
  );
}
