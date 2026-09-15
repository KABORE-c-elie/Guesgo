import 'package:guesgo/app/theme/theme.dart';
import 'package:flutter/material.dart';

/// Initials avatar with a **deterministic** gradient.
///
/// The hue pair is derived from the name, so the same person always gets
/// the same colours across the app (profile, header...). That consistency is
/// what makes an avatar act as an identity cue rather than decoration — and
/// it costs nothing compared to storing a picture.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.name,
    super.key,
    this.size = 40,
    this.imageUrl,
    this.showRing = false,
    this.glow = false,
  });

  final String name;
  final double size;
  final String? imageUrl;
  final bool showRing;
  final bool glow;

  static const _palettes = <List<Color>>[
    [AppPalette.iris400, AppPalette.iris600],
    [AppPalette.violet400, AppPalette.fuchsia500],
    [AppPalette.sky400, AppPalette.iris500],
    [AppPalette.teal400, AppPalette.mint600],
    [AppPalette.ember400, AppPalette.rose500],
    [AppPalette.amber400, AppPalette.ember600],
  ];

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  List<Color> get _gradient {
    if (name.isEmpty) return _palettes.first;
    final hash = name.codeUnits.fold<int>(
      7,
      (acc, c) => (acc * 31 + c) & 0xFFFF,
    );
    return _palettes[hash % _palettes.length];
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final colors = _gradient;

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: colors.first.withValues(alpha: 0.4),
                  blurRadius: size * 0.35,
                  offset: Offset(0, size * 0.12),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _label(context),
            )
          : _label(context),
    );

    if (showRing) {
      avatar = Container(
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: t.brand, width: 2),
        ),
        child: avatar,
      );
    }
    return avatar;
  }

  Widget _label(BuildContext context) => Text(
    _initials,
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
      color: Colors.white,
      fontSize: size * 0.38,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    ),
  );
}
