import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guesgo/features/movies/domain/genre.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

/// A movie as surfaced by TMDB, trimmed to the fields the app actually
/// uses. [genres], [runtime] and [tagline] only come back from the detail
/// endpoint (`/movie/{id}`) — every list endpoint (`popular`, `trending`,
/// `search`...) leaves them `null`, which is fine: nothing reads them
/// outside the detail screen.
@freezed
abstract class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(name: 'vote_average') @Default(0) double voteAverage,
    @JsonKey(name: 'vote_count') int? voteCount,
    int? runtime,
    String? tagline,
    List<Genre>? genres,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

extension MovieImages on Movie {
  /// Builds a full poster URL from TMDB's relative [posterPath], or `null`
  /// when the movie has none — [MoviePosterImage] renders its designed
  /// fallback in that case rather than a broken-image icon.
  String? posterUrl(String imageBaseUrl, {String size = 'w500'}) =>
      _url(posterPath, imageBaseUrl, size);

  /// Same idea for [backdropPath] — the wide hero image on the detail
  /// screen. Deliberately does **not** fall back to the (portrait) poster:
  /// forcing a 2:3 poster to cover a 16:9 hero crops away most of it. No
  /// backdrop means [MoviePosterImage]'s designed gradient fallback, which
  /// reads as intentional instead of a badly cropped photo.
  String? backdropUrl(String imageBaseUrl, {String size = 'w780'}) =>
      _url(backdropPath, imageBaseUrl, size);

  String? _url(String? path, String imageBaseUrl, String size) {
    if (path == null || path.isEmpty) return null;
    return '$imageBaseUrl/$size$path';
  }

  String? get releaseYear =>
      releaseDate != null && releaseDate!.length >= 4
      ? releaseDate!.substring(0, 4)
      : null;

  String? get runtimeLabel {
    final minutes = runtime;
    if (minutes == null || minutes <= 0) return null;
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    return hours > 0 ? '${hours}h${remaining.toString().padLeft(2, '0')}' : '${minutes}min';
  }
}
