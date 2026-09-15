import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/widgets/app_background.dart';
import 'package:guesgo/core/widgets/app_button.dart';
import 'package:guesgo/core/widgets/app_surface.dart';
import 'package:guesgo/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

/// Shared chrome for the authentication screens: a compact top bar (back ·
/// mark), a centred title/lead, then the form. Centring works here — and
/// only here — because these screens hold one short column with a single
/// decision; the browsing screens stay left-aligned.
class AuthShell extends StatelessWidget {
  const AuthShell({
    required this.title,
    required this.lead,
    required this.children,
    super.key,
    this.onBack,
    this.footer,
  });

  final String title;
  final String lead;
  final List<Widget> children;
  final VoidCallback? onBack;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = Theme.of(context).textTheme;
    final gutter = context.gutter;

    return AppScaffold(
      showBlooms: false,
      constrainWidth: false,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ResponsiveColumn(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    gutter,
                    AppSpacing.md,
                    gutter,
                    footer == null ? AppSpacing.xxl : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 44,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 44,
                              child: onBack == null
                                  ? null
                                  : CircleBackButton(onPressed: onBack!),
                            ),
                            const Expanded(
                              child: Center(child: AppLogo(size: 34)),
                            ),
                            const SizedBox(width: 44),
                          ],
                        ),
                      ),
                      SizedBox(height: context.responsive(medium: 28, small: 18)),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: text.displaySmall,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Text(
                            lead,
                            textAlign: TextAlign.center,
                            style: text.bodyLarge?.copyWith(
                              color: t.textSecondary,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.responsive(medium: 30, small: 22)),
                      ...children,
                    ],
                  ),
                ),
              ),
              if (footer != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      gutter,
                      AppSpacing.xxl,
                      gutter,
                      AppSpacing.xxl,
                    ),
                    child: Align(alignment: Alignment.bottomCenter, child: footer),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Pas encore de compte ? S'inscrire".
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    required this.prompt,
    required this.action,
    required this.onTap,
    super.key,
  });

  final String prompt;
  final String action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = Theme.of(context).textTheme;

    // Wrap, not Row: two variable-length strings on one line overflow the
    // moment the copy or the text scale changes.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        Text(prompt, style: text.bodyMedium),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: text.bodyMedium?.copyWith(
              color: t.brand,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// Four-segment password strength meter, scored on what actually matters —
/// length first, then variety — rather than a regex that rejects a
/// perfectly good passphrase for lacking a punctuation mark.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({required this.password, super.key});

  final String password;

  int get _score {
    if (password.isEmpty) return 0;
    var score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 10) score++;
    if (RegExp('[A-Z]').hasMatch(password) &&
        RegExp('[a-z]').hasMatch(password)) {
      score++;
    }
    if (RegExp('[0-9]').hasMatch(password) ||
        RegExp('[^A-Za-z0-9]').hasMatch(password)) {
      score++;
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final score = _score;

    final (tone, label) = switch (score) {
      0 => (AppTone.neutral, ''),
      1 => (AppTone.danger, 'Faible'),
      2 => (AppTone.warning, 'Moyen'),
      3 => (AppTone.info, 'Bon'),
      _ => (AppTone.success, 'Fort'),
    };
    final colors = t.resolve(tone);

    return Row(
      children: [
        for (var i = 1; i <= 4; i++) ...[
          if (i > 1) const SizedBox(width: 5),
          Expanded(
            child: AnimatedContainer(
              duration: AppMotion.short,
              curve: AppMotion.standard,
              height: 4,
              decoration: BoxDecoration(
                color: i <= score ? colors.solid : t.borderStrong,
                borderRadius: AppRadius.brPill,
              ),
            ),
          ),
        ],
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          width: 44,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: colors.fg),
          ),
        ),
      ],
    );
  }
}
