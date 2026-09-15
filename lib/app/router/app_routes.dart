/// Top-level route paths. Kept as one constants class so a path never gets
/// typo'd across a [GoRoute] declaration and the `context.go(...)` call site.
abstract final class AppRoutes {
  static const home = '/home';
  static const search = '/search';
  static const downloads = '/downloads';
  static const profile = '/profile';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';

  static const movieDetail = '/movie/:id';
  static String moviePath(int id) => '/movie/$id';
}
