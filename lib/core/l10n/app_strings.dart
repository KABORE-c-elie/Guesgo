/// French UI strings shared across features. Kept in one place so a future
/// `flutter_localizations` ARB migration is a mechanical find/replace.
///
/// Only truly generic entries live here; each feature adds its own strings
/// as it's built (auth, movies, downloads...) rather than front-loading
/// content nobody uses yet.
abstract final class AppStrings {
  static const appName = 'Guesgo';
  static const tagline = 'Vos films, partout, même hors-ligne';

  // Generic
  static const loading = 'Chargement…';
  static const errorGeneric = 'Une erreur est survenue.';
  static const connectionLost = 'Connexion perdue';
  static const retry = 'Réessayer';
  static const confirm = 'Confirmer';
  static const cancel = 'Annuler';
  static const save = 'Enregistrer';
  static const delete = 'Supprimer';

  // Navigation (shell-level, shared by every feature)
  static const navHome = 'Accueil';
  static const navSearch = 'Recherche';
  static const navDownloads = 'Téléchargements';
  static const navProfile = 'Profil';

  static const pageNotFoundTitle = 'Page introuvable';
  static const pageNotFoundMessage = "Cette page n'existe pas ou plus.";
}
