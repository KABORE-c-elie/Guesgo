import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guesgo/core/l10n/app_strings.dart';
import 'package:guesgo/core/widgets/design_system.dart';

/// Chrome shared by every top-level destination: the aurora background and
/// the floating nav bar live here once, so a feature screen only returns its
/// scrollable content — never its own [AppScaffold].
///
/// Each screen must pad its scrollable's bottom with [AppSizes.navBarInset]
/// so its last item clears the floating bar.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: AppStrings.navHome,
    ),
    NavDestination(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search_rounded,
      label: AppStrings.navSearch,
    ),
    NavDestination(
      icon: Icons.download_outlined,
      selectedIcon: Icons.download_rounded,
      label: AppStrings.navDownloads,
    ),
    NavDestination(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: AppStrings.navProfile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: navigationShell,
      bottomBar: AppNavBar(
        destinations: _destinations,
        selectedIndex: navigationShell.currentIndex,
        // `initialLocation: true` on a re-tap of the already-selected tab
        // pops that branch back to its root instead of doing nothing.
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
