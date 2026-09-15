# guesgo

A new Flutter project.

## Configuration locale

L'app lit sa clé TMDB et sa config Supabase via `--dart-define-from-file`
(jamais en dur dans le code versionné). Copiez le modèle, remplissez vos
valeurs, puis lancez :

```sh
cp env.example.json env.json   # une fois, `env.json` est ignoré par git
flutter run --dart-define-from-file=env.json
```

Clé TMDB gratuite sur
[themoviedb.org/settings/api](https://www.themoviedb.org/settings/api),
URL + clé anon sur le dashboard de votre projet
[supabase.com](https://supabase.com/dashboard) (Project Settings → API).
`SUPABASE_URL` / `SUPABASE_ANON_KEY` peuvent rester vides tant que vous ne
testez pas la connexion/inscription — le reste de l'app fonctionne sans.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
