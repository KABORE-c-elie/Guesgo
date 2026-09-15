# Guesgo

Application Flutter de découverte de films, connectée à l'API [TMDB](https://www.themoviedb.org/)
(The Movie Database) et à un backend réel [Supabase](https://supabase.com/) pour
l'authentification. Persistance locale hors-ligne via Hive.

## Fonctionnalités

- **Authentification** (JWT via Supabase Auth) — inscription, connexion, déconnexion.
- **3 écrans de données issues d'une API REST (TMDB)** — Accueil (films
  tendance/populaires/mieux notés/animation), Recherche (recherche live avec
  debounce), Fiche film (détail : genres, durée, synopsis).
- **Cache local** (Hive) — chaque réponse TMDB est mise en cache par clé de
  requête ; « Ma liste » (films enregistrés) est stockée localement.
- **Mode hors-ligne** — sans réseau, l'app sert automatiquement la dernière
  réponse en cache au lieu d'un écran d'erreur vide, avec une bannière
  « Hors-ligne » visible tant que la connexion n'est pas revenue.
- **Gestion d'erreurs réseau** — messages utilisateur en français avec bouton
  réessayer, jamais d'exception brute affichée à l'écran.

## Architecture

**Feature-First** : chaque fonctionnalité vit dans `lib/features/<nom>/`,
avec ses propres sous-dossiers `data/` (repository), `domain/` (modèles) et
`presentation/` (écrans) quand la fonctionnalité le justifie. Le code
transverse (thème, widgets partagés, réseau, erreurs, stockage) vit dans
`lib/core/` et `lib/app/`.

```
lib/
├── app/                    # App shell : routes (go_router), thème
├── core/
│   ├── config/              # AppConfig (dart-define), Flavor
│   ├── errors/               # Failure (union de types) + ErrorMapper
│   ├── network/               # Client Dio, intercepteur JWT, connectivité
│   ├── result/                 # Result<T> (Ok/Err) — pattern railway-oriented
│   ├── storage/                 # Boîtes Hive (saved_movies, movie_cache)
│   └── widgets/                   # Design system partagé
└── features/
    ├── auth/                # Supabase Auth : repository, controller, écrans
    ├── movies/              # Modèle Movie/Genre + MovieRepository (TMDB)
    ├── saved/               # "Ma liste" (SavedMoviesRepository, Hive)
    ├── home/ search/ downloads/ profile/   # Écrans (onglets)
```

**Repository pattern** : chaque source de données (TMDB, Supabase, Hive) est
encapsulée dans un repository (`MovieRepository`, `AuthRepository`,
`SavedMoviesRepository`). Les écrans ne parlent jamais directement à Dio, au
SDK Supabase ou à une `Box` Hive.

**Gestion d'erreurs typée** : les repositories ne lèvent jamais
d'exception — ils renvoient un `Result<T>` (`Ok` ou `Err`), converti par
`ErrorMapper` depuis n'importe quelle exception (Dio, Supabase Auth,
inconnue) vers un type `Failure` scellé (`NetworkFailure`, `AuthFailure`,
`ServerFailure`...). L'UI fait un `switch` exhaustif dessus.

**State management** : Riverpod (génération de code via `riverpod_generator`)
pour l'injection de dépendances et la gestion d'état asynchrone
(`AsyncValue`).

## APIs utilisées

| API | Usage |
|---|---|
| [TMDB](https://developer.themoviedb.org/reference/intro/getting-started) | Films populaires/tendance/mieux notés, recherche, détail, genres |
| [Supabase Auth](https://supabase.com/docs/guides/auth) | Authentification par email/mot de passe (JWT géré par le SDK, refresh automatique) |

### Intercepteur d'authentification

`lib/core/network/auth_interceptor.dart` — un `Interceptor` Dio qui attache
le token Supabase de l'utilisateur connecté (`Authorization: Bearer <jwt>`)
à chaque requête sortante. TMDB n'en a pas besoin (API publique par clé),
mais l'intercepteur est câblé au niveau du client Dio pour que n'importe
quel futur appel à un backend authentifié (Edge Function Supabase, etc.)
hérite automatiquement du token, sans qu'aucun site d'appel n'ait à y
penser.

### Refresh token

Géré par le SDK `supabase_flutter` : la session (access token + refresh
token) est automatiquement rafraîchie en arrière-plan par le client
Supabase. `AuthRepository.watchUser()` s'abonne à
`Supabase.auth.onAuthStateChange`, qui émet à chaque changement de session
(connexion, déconnexion, refresh) — l'app n'a jamais à gérer l'expiration
manuellement.

### Cache & mode hors-ligne

`MovieRepository` applique une politique *cache-on-success,
fallback-on-failure* : chaque requête réussie écrase son entrée de cache
(clé = endpoint + paramètres, ex. `popular_p1`, `search_dune_p1`) ; chaque
requête échouée (pas de réseau, TMDB indisponible...) tente de servir cette
entrée avant de remonter une erreur. `lib/core/network/connectivity_provider.dart`
expose l'état de connexion (`connectivity_plus`) et pilote la bannière
`OfflineBanner` affichée en haut de l'Accueil et de la Recherche.

## Configuration locale

L'app lit sa clé TMDB et sa config Supabase via `--dart-define-from-file`
(jamais en dur dans le code versionné).

```sh
cp env.example.json env.json   # une fois, `env.json` est ignoré par git
flutter run --dart-define-from-file=env.json
```

Remplissez `env.json` :

```json
{
  "TMDB_API_KEY": "votre_cle",
  "SUPABASE_URL": "https://xxxx.supabase.co",
  "SUPABASE_ANON_KEY": "votre_cle_anon"
}
```

- Clé TMDB gratuite sur [themoviedb.org/settings/api](https://www.themoviedb.org/settings/api).
- URL + clé anon sur le dashboard de votre projet
  [supabase.com](https://supabase.com/dashboard) (Project Settings → API).
- `SUPABASE_URL` / `SUPABASE_ANON_KEY` peuvent rester vides tant que vous ne
  testez pas la connexion/inscription — le reste de l'app fonctionne sans.

## Tests

```sh
flutter test
```

Tests unitaires sur la couche repository (`test/features/**/data/`) :

- `movie_repository_test.dart` — parsing des réponses TMDB, mise en cache,
  service depuis le cache hors-ligne, échec réseau sans cache, parsing du
  détail (genres/durée).
- `saved_movies_repository_test.dart` — sauvegarde/suppression d'un film,
  round-trip Hive avec genres imbriqués.

Un test widget (`test/widget_test.dart`) vérifie que l'app démarre et
affiche l'onglet Accueil sans exception.

## Lancer le projet

```sh
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs  # code généré (Riverpod/Freezed/json_serializable)
flutter run --dart-define-from-file=env.json
```
