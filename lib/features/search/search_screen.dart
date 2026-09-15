import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guesgo/app/router/app_routes.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/config/app_config.dart';
import 'package:guesgo/core/l10n/app_strings.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/movies/domain/movie.dart';
import 'package:guesgo/features/movies/widgets/movie_result_tile.dart';
import 'package:guesgo/features/search/search_controller.dart';
import 'package:guesgo/features/search/widgets/movie_search_field.dart';

/// Idle state is not an empty page: with no query it prompts, it doesn't
/// just sit blank — a search screen that shows nothing until you type
/// wastes the moment where the user is deciding what to look for.
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(movieSearchQueryProvider);
    final isIdle = query.trim().isEmpty;

    return CustomScrollView(
      slivers: [
        const AppTopBar(title: AppStrings.navSearch),
        const SliverToBoxAdapter(child: OfflineBanner()),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            0,
            AppSpacing.gutter,
            AppSpacing.lg,
          ),
          sliver: SliverToBoxAdapter(child: MovieSearchField()),
        ),
        if (isIdle)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(
              icon: Icons.search_rounded,
              title: 'Trouvez un film',
              message: 'Tapez un titre pour lancer la recherche.',
            ),
          )
        else
          const _Results(),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: AppSizes.navBarInset),
        ),
      ],
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(movieSearchResultsProvider);
    final imageBaseUrl = ref.watch(appConfigProvider).tmdbImageBaseUrl;

    return AsyncValueWidget<List<Movie>>(
      value: results,
      sliver: true,
      loading: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        sliver: SliverList.separated(
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, _) =>
              const Skeleton(height: 108, radius: AppRadius.lg),
        ),
      ),
      onRetry: () => ref.invalidate(movieSearchResultsProvider),
      isEmpty: (list) => list.isEmpty,
      empty: SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(
          icon: Icons.search_off_rounded,
          title: 'Aucun résultat',
          message: 'Aucun film ne correspond à cette recherche.',
          action: AppButton.secondary(
            label: 'Effacer',
            expand: false,
            size: AppButtonSize.medium,
            onPressed: ref.read(movieSearchQueryProvider.notifier).clear,
          ),
        ),
      ),
      data: (list) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        sliver: SliverList.separated(
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) => MovieResultTile(
            movie: list[index],
            imageBaseUrl: imageBaseUrl,
            onTap: () => context.push(AppRoutes.moviePath(list[index].id)),
          ),
        ),
      ),
    );
  }
}
