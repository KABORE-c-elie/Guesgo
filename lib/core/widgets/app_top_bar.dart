import 'dart:ui';

import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/widgets/app_surface.dart';
import 'package:flutter/material.dart';

/// The fixed top bar every tab opens with: brand mark, title (+ optional
/// subtitle), optional trailing actions. `pinned: true` keeps it in place
/// while the body scrolls underneath — a screen's identity shouldn't
/// scroll away with its content.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    required this.title,
    super.key,
    this.subtitle,
    this.actions = const [],
    this.showLogo = false,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  /// Only the home screen is the app's own "identity" moment — every other
  /// tab is about its own content, not the brand, so the mark would just
  /// repeat itself for no reason.
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = Theme.of(context).textTheme;

    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 68,
      titleSpacing: AppSpacing.gutter,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: t.glass,
              border: Border(bottom: BorderSide(color: t.borderSubtle)),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          if (showLogo) ...[
            const AppLogo(size: 36),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: text.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: text.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: actions.isEmpty
          ? null
          : [...actions, const SizedBox(width: AppSpacing.sm)],
    );
  }
}
