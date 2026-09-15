import 'package:flutter/material.dart';
import 'package:guesgo/app/theme/theme.dart';

/// Bookmark toggle overlaid on a poster or a result tile. A dark translucent
/// disc regardless of theme — it sits on arbitrary movie artwork, so it
/// needs its own guaranteed contrast rather than a surface token.
class SaveMovieButton extends StatelessWidget {
  const SaveMovieButton({
    required this.saved,
    required this.onTap,
    super.key,
    this.dense = false,
  });

  final bool saved;
  final VoidCallback onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final size = dense ? 28.0 : 32.0;

    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            size: dense ? 16 : 18,
            color: saved ? t.accent : Colors.white,
          ),
        ),
      ),
    );
  }
}
