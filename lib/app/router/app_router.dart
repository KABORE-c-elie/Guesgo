import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guesgo/app/router/app_routes.dart';
import 'package:guesgo/app/router/app_shell.dart';
import 'package:guesgo/core/l10n/app_strings.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/auth/presentation/sign_in_screen.dart';
import 'package:guesgo/features/auth/presentation/sign_up_screen.dart';
import 'package:guesgo/features/downloads/downloads_screen.dart';
import 'package:guesgo/features/home/home_screen.dart';
import 'package:guesgo/features/movies/presentation/movie_detail_screen.dart';
import 'package:guesgo/features/profile/profile_screen.dart';
import 'package:guesgo/features/search/search_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// One [GoRouter] instance for the app's lifetime — recreating it on every
/// rebuild would reset navigation state, so it is `keepAlive`.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.downloads,
                builder: (context, state) => const DownloadsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.movieDetail,
        builder: (context, state) => MovieDetailScreen(
          movieId: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
    errorBuilder: (context, state) => AppScaffold(
      body: ErrorStateView(
        title: AppStrings.pageNotFoundTitle,
        message: AppStrings.pageNotFoundMessage,
        icon: Icons.explore_off_rounded,
        onRetry: () => context.go(AppRoutes.home),
      ),
    ),
  );
}
