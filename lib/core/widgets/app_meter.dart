import 'package:guesgo/app/theme/theme.dart';
import 'package:flutter/material.dart';

/// A single KPI: value, label, optional icon/trailing. The value is set in
/// display type and everything else recedes, so a row of these scans in a
/// glance.
class StatTile extends StatelessWidget {
  const StatTile({
    required this.value,
    required this.label,
    super.key,
    this.icon,
    this.tone = AppTone.brand,
    this.trailing,
  });

  final String value;
  final String label;
  final IconData? icon;
  final AppTone tone;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final colors = t.resolve(tone);
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colors.bg,
                    borderRadius: AppRadius.brXs,
                  ),
                  child: Icon(icon, size: 16, color: colors.fg),
                ),
              const Spacer(),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: text.headlineMedium?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: text.bodySmall, maxLines: 1),
        ],
      ),
    );
  }
}
