import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_boxes.g.dart';

const savedMoviesBoxName = 'saved_movies';

/// Must be opened (`Hive.openBox`) and overridden in `main()` before
/// `runApp` — same pattern as [appConfigProvider]: the default throws so a
/// missing override is caught immediately instead of silently running
/// unconfigured.
@Riverpod(keepAlive: true)
Box<Map<dynamic, dynamic>> savedMoviesBox(Ref ref) =>
    throw StateError('savedMoviesBoxProvider must be overridden in main()');
