import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/config/app_config.dart';
import 'package:guesgo/core/extensions/context_x.dart';
import 'package:guesgo/core/l10n/app_strings.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/home/home_controller.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:guesgo/features/movies/widgets/movie_rail.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(trendingMoviesProvider)
          ..invalidate(popularMoviesProvider)
          ..invalidate(topRatedMoviesProvider)
          ..invalidate(animeMoviesProvider);
        await ref.read(trendingMoviesProvider.future);
      },
      child: CustomScrollView(
        slivers: [
          AppTopBar(
            title: AppStrings.navHome,
            subtitle: 'Populaires en ce moment',
            showLogo: true,
            actions: [
              IconActionButton(
                icon: Icons.notifications_none_rounded,
                tooltip: 'Notifications',
                onPressed: () => context.showToast(
                  'Bientôt disponible',
                  icon: Icons.info_outline_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconActionButton(
                icon: Icons.tune_rounded,
                tooltip: 'Filtrer',
                onPressed: () => context.showToast(
                  'Bientôt disponible',
                  icon: Icons.info_outline_rounded,
                ),
              ),
            ],
          ),
          const SliverToBoxAdapter(child: OfflineBanner()),
          const _MovieFeed(),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: AppSizes.navBarInset),
          ),
        ],
      ),
    );
  }
}

/// Every home rail, stacked vertically so the screen scrolls down while each
/// rail scrolls left/right on its own axis.
class _MovieFeed extends ConsumerWidget {
  const _MovieFeed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(trendingMoviesProvider);
    final popular = ref.watch(popularMoviesProvider);
    final topRated = ref.watch(topRatedMoviesProvider);
    final anime = ref.watch(animeMoviesProvider);
    final imageBaseUrl = ref.watch(appConfigProvider).tmdbImageBaseUrl;

    // `trending` is the single loading/error gate for the whole feed: four
    // rails resolving at different times would read as a glitch rather than
    // content arriving. Once it settles, every other rail renders if it has
    // data and is silently omitted otherwise — one failed genre query
    // shouldn't blank a screen that has three other rails to show.
    return AsyncValueWidget<List<Movie>>(
      value: trending,
      sliver: true,
      loading: const SliverToBoxAdapter(child: _FeedSkeleton()),
      onRetry: () => ref.invalidate(trendingMoviesProvider),
      data: (trendingMovies) {
        final sections = <(String, List<Movie>)>[
          ('Tendance', trendingMovies),
          ('Populaires', popular.value ?? const []),
          ('Mieux notés', topRated.value ?? const []),
          ('Animation', anime.value ?? const []),
        ].where((section) => section.$2.isNotEmpty).toList();

        if (sections.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(message: 'Aucun film pour le moment.'),
          );
        }

        return SliverList.list(
          children: [
            for (final (title, movies) in sections) ...[
              SectionHeader(title: title),
              MovieRail(movies: movies, imageBaseUrl: imageBaseUrl),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ],
        );
      },
    );
  }
}

/// Two placeholder rails, shaped like the real feed — a skeleton reads as
/// "this is where content will land" in a way a centred spinner never does.
class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: 120, height: 20),
          SizedBox(height: AppSpacing.lg),
          _RailSkeleton(),
          SizedBox(height: AppSpacing.xxl),
          Skeleton(width: 100, height: 20),
          SizedBox(height: AppSpacing.lg),
          _RailSkeleton(),
        ],
      ),
    );
  }
}

class _RailSkeleton extends StatelessWidget {
  const _RailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, _) => const SizedBox(
          width: 140,
          child: Skeleton(
            width: double.infinity,
            height: double.infinity,
            radius: AppRadius.lg,
          ),
        ),
      ),
    );
  }
}
