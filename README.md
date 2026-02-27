# Dishcovery

> Dishcovery helps busy university students find simple recipes based on a main ingredient they already have. The MVP runs locally with a small JSON recipe database and uses lightweight string normalization to match ingredient synonyms (no NLP).

## Goals
- Solve decision paralysis and food waste by surfacing easy recipes from ingredients on hand.
- Keep the MVP simple: local JSON DB, O(n) filtering, deterministic normalization, Riverpod for state, GoRouter for navigation.

## Tech stack
- Flutter (multi-platform, web-first support for the MVP)
- State management: Riverpod (planned)
- Navigation: GoRouter
- Local data: `lib/data/recipes.json` (MVP)
- Backend: Firebase planned (analytics, sync) — not integrated in MVP

## Quick start (run on web)

1. Make sure Flutter is installed and supports web. Verify with:

```bash
flutter doctor -v
```

2. From the project root (this repo), fetch dependencies:

```bash
flutter pub get
```

3. Run on Chrome (debug):

```bash
flutter run -d chrome
```

If the automated Chrome launch fails you can run as a web server and open the printed URL manually:

```bash
flutter run -d web-server
# then open http://localhost:PORT in your browser
```

4. Run unit/widget tests:

```bash
flutter test
```

Notes: If this project was not yet initialized with `flutter create`, running `flutter create .` in the repo root will add platform folders; the scripts in this repo assume `lib/` exists and contains the app code.

## Project structure (feature-based)

- `lib/`
  - `core/` — shared app-level helpers, theming, constants
  - `features/` — grouped by feature; each feature contains screens, providers, and internal widgets
    - `welcome/` — `screens/WelcomeScreen.dart`
    - `browse_recipe/` — `screens/BrowseRecipeScreen.dart`
    - `ingredient_search/` — search UI and providers
    - `recipe_detail/` — detail screen
    - `my_cookbook/` — saved recipes
    - `profile/` — user/profile screens
  - `models/` — data models (`recipe.dart`)
  - `services/` — repositories / data-loading (`recipe_repository.dart`)
  - `data/recipes.json` — local JSON DB of recipes (MVP)

This structure groups code by feature to keep related code co-located and easier to iterate on.

## Navigation
- `lib/main.dart` sets up `GoRouter` with routes for `/` (Welcome) and `/browse` (Browse recipes). The Welcome screen includes a `Get started` button that pushes to `/browse`.

## Local JSON DB and normalization (MVP)

Filtering approach (deterministic, cheap):

- Normalize both the user input and each recipe ingredient by:
  - Lowercasing and trimming whitespace
  - Removing punctuation (commas, periods, parentheses)
  - Collapsing multiple spaces and normalizing hyphens
  - Simple plural normalization (strip trailing `s` / `es` when appropriate)
  - A tiny manual synonym map (optional) for common variants, e.g. `bell pepper` ⇄ `capsicum`, `scallion` ⇄ `green onion`.

This is intentionally lightweight (no NLP). The search is an O(n) scan over recipes and matches normalized tokens exactly (optionally count matches for simple relevance). This is fast for small local datasets used in the MVP.

## Adding recipes
- Edit `lib/data/recipes.json` and add recipe objects. Keep a simple shape for the `Recipe` model (id, title, ingredients[], steps[], optional image).

Example recipe item (JSON):

```json
{
  "id": "r1",
  "title": "Scrambled Eggs",
  "ingredients": ["eggs", "salt", "butter"],
  "steps": ["Beat eggs", "Melt butter in pan", "Cook eggs until set"]
}
```

## Tests
- Update or remove the generated `test/widget_test.dart` if you rename the app entrypoint. The repo currently uses `DishcoveryApp` as the root widget; update tests accordingly (the sample generated test references `MyApp` by default).

## Troubleshooting
- If Chrome doesn't open automatically when running `flutter run -d chrome`, try `flutter run -d web-server` and open the printed URL manually.
- If dependencies fail resolving, run `flutter pub get` and inspect `pubspec.yaml` for version constraints. Use `flutter pub outdated` to see updates.
- If you see analysis errors about missing symbols from tests, they usually indicate the test expects a different root widget name — update the test to use `DishcoveryApp()`.

## Next steps (suggested)
- Implement the `Recipe` model and a small `RecipeRepository` that loads `lib/data/recipes.json`.
- Add the lightweight normalization/filtering implementation and unit tests.
- Wire Riverpod providers for search state and saved recipes.
- Add Firebase (analytics + recipe sync) once MVP is stable.

## Contributing
Contributions welcome. Please open issues or PRs for bugs and feature requests. Keep changes small and focused, and add tests where applicable.

## License
This project is unlicensed by default. Add a `LICENSE` file if you want to apply an open-source license.

---
If you want, I can also: add a sample `recipes.json`, implement the normalization function in Dart with unit tests, or patch the PowerShell structure script to be more robust. Tell me which next.
# dishcovery

A new Flutter project.
