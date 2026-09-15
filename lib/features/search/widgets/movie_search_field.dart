import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/search/search_controller.dart';

/// Search input bound to [movieSearchQueryProvider]. A separate widget (not
/// inlined in the screen) so the [TextEditingController] survives screen
/// rebuilds without re-syncing on every keystroke.
class MovieSearchField extends ConsumerStatefulWidget {
  const MovieSearchField({super.key, this.autofocus = false});

  final bool autofocus;

  @override
  ConsumerState<MovieSearchField> createState() => _MovieSearchFieldState();
}

class _MovieSearchFieldState extends ConsumerState<MovieSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(movieSearchQueryProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(movieSearchQueryProvider);
    // Keep the field in sync when the query is cleared from elsewhere (the
    // empty-state button).
    if (_controller.text != query) {
      _controller.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }

    return AppSearchField(
      hint: 'Rechercher un film…',
      controller: _controller,
      value: query,
      autofocus: widget.autofocus,
      onChanged: ref.read(movieSearchQueryProvider.notifier).set,
      onClear: () {
        _controller.clear();
        ref.read(movieSearchQueryProvider.notifier).clear();
      },
    );
  }
}
