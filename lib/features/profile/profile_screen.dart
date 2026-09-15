import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guesgo/app/router/app_routes.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/errors/failure.dart';
import 'package:guesgo/core/extensions/context_x.dart';
import 'package:guesgo/core/l10n/app_strings.dart';
import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/auth/auth_controller.dart';
import 'package:guesgo/features/auth/domain/app_user.dart';
import 'package:guesgo/features/saved/saved_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);

    return userAsync.when(
      loading: () => const _ProfileSkeleton(),
      error: (error, _) => Center(
        child: ErrorStateView(
          message: error is Failure ? error.message : AppStrings.errorGeneric,
          onRetry: () => ref.invalidate(authStateProvider),
        ),
      ),
      data: (user) =>
          user == null ? const _SignedOutView() : _SignedInView(user: user),
    );
  }
}

/// Shaped like the identity card + stats row it's about to become, so the
/// (usually brief) wait for the auth stream's first event doesn't flash a
/// bare spinner in the middle of the screen.
class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const AppTopBar(title: AppStrings.navProfile),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            AppSizes.navBarInset,
          ),
          sliver: SliverList.list(
            children: const [
              Skeleton(
                width: double.infinity,
                height: 132,
                radius: AppRadius.xxl,
              ),
              SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(child: Skeleton(height: 92, radius: AppRadius.lg)),
                  SizedBox(width: AppSpacing.md),
                  Expanded(child: Skeleton(height: 92, radius: AppRadius.lg)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// No account system requirement to browse the app — signing in only
/// unlocks syncing "my list" across devices, so this is an invitation, not
/// a gate.
class _SignedOutView extends StatelessWidget {
  const _SignedOutView();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const AppTopBar(title: AppStrings.navProfile),
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyStateView(
            icon: Icons.person_outline_rounded,
            title: 'Connectez-vous',
            message:
                'Créez un compte pour retrouver votre liste sur tous vos '
                'appareils.',
            action: AppButton.primary(
              label: 'Se connecter',
              expand: false,
              onPressed: () => context.push(AppRoutes.signIn),
            ),
            secondaryAction: AppButton.ghost(
              label: 'Créer un compte',
              expand: false,
              onPressed: () => context.push(AppRoutes.signUp),
            ),
          ),
        ),
      ],
    );
  }
}

class _SignedInView extends ConsumerWidget {
  const _SignedInView({required this.user});

  final AppUser user;

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmSheet(
      context,
      icon: Icons.logout_rounded,
      title: 'Se déconnecter',
      message: 'Vous devrez vous reconnecter pour retrouver votre liste.',
      confirmLabel: 'Se déconnecter',
    );
    if (!confirmed || !context.mounted) return;

    final result = await ref.read(authControllerProvider.notifier).signOut();
    if (!context.mounted) return;
    if (result case Err(:final failure)) context.showFailure(failure);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedCount = ref.watch(savedMoviesProvider).length;
    final themeMode = ref.watch(themeModeControllerProvider);
    final t = context.tokens;
    final text = Theme.of(context).textTheme;
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return CustomScrollView(
      slivers: [
        const AppTopBar(title: AppStrings.navProfile),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            AppSizes.navBarInset,
          ),
          sliver: SliverList.list(
            children: [
              _IdentityCard(user: user),
              const SizedBox(height: AppSpacing.xl),
              _Stats(
                savedCount: savedCount,
                emailConfirmed: user.emailConfirmed,
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionLabel('Préférences'),
              const SizedBox(height: AppSpacing.md),
              AppSurface(
                padding: EdgeInsets.zero,
                elevation: SurfaceElevation.flat,
                child: SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  secondary: Icon(
                    Icons.dark_mode_outlined,
                    color: t.textSecondary,
                  ),
                  title: Text('Mode sombre', style: text.titleMedium),
                  value: isDark,
                  onChanged: (_) => ref
                      .read(themeModeControllerProvider.notifier)
                      .toggle(context),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionLabel('Assistance'),
              const SizedBox(height: AppSpacing.md),
              _MenuGroup(
                items: [
                  _MenuItem(
                    icon: Icons.badge_outlined,
                    label: 'Modifier le profil',
                    onTap: () => context.showToast(
                      'Bientôt disponible',
                      icon: Icons.info_outline_rounded,
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.help_outline_rounded,
                    label: "Centre d'aide",
                    onTap: () => context.showToast(
                      'Bientôt disponible',
                      icon: Icons.info_outline_rounded,
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'À propos',
                    onTap: () => context.showToast(
                      'Bientôt disponible',
                      icon: Icons.info_outline_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton.secondary(
                label: 'Se déconnecter',
                icon: Icons.logout_rounded,
                onPressed: () => _signOut(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Gradient identity header — same shape as the design system's other
/// "hero" surfaces (movie cards, badges): the brand gradient carries
/// identity, not a plain card.
class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = Theme.of(context).textTheme;
    final displayName = (user.name?.isNotEmpty ?? false)
        ? user.name!
        : user.email;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: t.brandGradient,
        borderRadius: AppRadius.brXxl,
        boxShadow: [
          BoxShadow(
            color: t.brand.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: AppAvatar(name: displayName, size: 62),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: text.headlineSmall?.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: text.bodySmall?.copyWith(color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.createdAt != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Membre depuis ${user.createdAt!.year}',
                    style: text.labelSmall?.copyWith(
                      color: Colors.white70,
                      letterSpacing: 0.2,
                    ),
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

class _Stats extends StatelessWidget {
  const _Stats({required this.savedCount, required this.emailConfirmed});

  final int savedCount;
  final bool emailConfirmed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatTile(
            value: '$savedCount',
            label: 'Films sauvegardés',
            icon: Icons.bookmark_rounded,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: StatTile(
            value: emailConfirmed ? 'Vérifié' : 'En attente',
            label: 'Email',
            icon: emailConfirmed
                ? Icons.verified_rounded
                : Icons.mail_outline_rounded,
            tone: emailConfirmed ? AppTone.success : AppTone.warning,
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  const _MenuItem({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// Grouped rows sharing one surface, iOS-settings style — dividers between
/// items instead of a card per row, which halves the visual noise.
class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return AppSurface(
      padding: EdgeInsets.zero,
      elevation: SurfaceElevation.flat,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const AppDivider(indent: 60, height: 1),
            InkWell(
              onTap: items[i].onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    Icon(items[i].icon, size: 20, color: t.textSecondary),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Text(
                        items[i].label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: t.textTertiary),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
