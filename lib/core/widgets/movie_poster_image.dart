import 'package:cached_network_image/cached_network_image.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/widgets/app_skeleton.dart';
import 'package:flutter/material.dart';

/// Movie artwork (poster or backdrop) with a designed fallback.
///
/// A movie without an image is not an error state: rather than a grey box
/// with a broken-image glyph, we render a **deterministic gradient** derived
/// from [seed] (the movie id). Two consequences that matter at scale: a grid
/// of image-less entries still looks intentional, and the same movie keeps
/// the same colours everywhere it appears — including offline, where a
/// poster may not have been cached yet.
class MoviePosterImage extends StatelessWidget {
  const MoviePosterImage({
    super.key,
    this.imageUrl,
    this.height,
    this.width = double.infinity,
    this.borderRadius = BorderRadius.zero,
    this.seed,
    this.icon = Icons.local_movies_rounded,
    this.fit = BoxFit.cover,
  });

  final String? imageUrl;
  final double? height;
  final double? width;
  final BorderRadius borderRadius;

  /// Stable string (movie id, title) used to pick the fallback gradient.
  final String? seed;
  final IconData icon;
  final BoxFit fit;

  static const _gradients = <List<Color>>[
    [AppPalette.iris500, AppPalette.iris800],
    [AppPalette.violet500, AppPalette.iris700],
    [AppPalette.sky500, AppPalette.iris600],
    [AppPalette.teal500, AppPalette.sky600],
    [AppPalette.ember500, AppPalette.rose600],
    [AppPalette.fuchsia500, AppPalette.violet500],
  ];

  List<Color> get _fallbackGradient {
    final key = seed ?? imageUrl ?? '';
    if (key.isEmpty) return _gradients.first;
    final hash = key.codeUnits.fold<int>(11, (a, c) => (a * 33 + c) & 0xFFFF);
    return _gradients[hash % _gradients.length];
  }

  Widget _fallback(BuildContext context) {
    final colors = _fallbackGradient;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 40, color: Colors.white.withValues(alpha: 0.28)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return ClipRRect(
      borderRadius: borderRadius,
      child: url == null || url.isEmpty
          ? _fallback(context)
          : CachedNetworkImage(
              imageUrl: url,
              height: height,
              width: width,
              fit: fit,
              fadeInDuration: AppMotion.medium,
              placeholder: (_, _) =>
                  Skeleton(height: height ?? 200, radius: 0),
              errorWidget: (context, _, _) => _fallback(context),
            ),
    );
  }
}
