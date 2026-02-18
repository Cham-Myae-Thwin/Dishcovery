# Dishcovery

This is 

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── recipe.dart                    # Recipe model and mock data
├── screens/
│   ├── home_screen.dart              # Home screen with recipe grid
│   ├── ingredient_search_screen.dart  # Search screen
│   ├── recipe_detail_screen.dart     # Recipe detail view
│   └── profile_screen.dart           # Profile screen
└── widgets/
    └── recipe_card.dart              # Reusable recipe card widget
```

## Setup Instructions

1. **Create a new Flutter project:**
   ```bash
   flutter create recipe_app
   cd recipe_app
   ```

2. **Copy the files:**
   - Copy all files from the `flutter_code` folder into your `lib` folder
   - Replace the existing `main.dart`

3. **Update pubspec.yaml:**
   Add the following dependencies if needed:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     cupertino_icons: ^1.0.2
   ```

4. **Run the app:**
   ```bash
   flutter pub get
   flutter run
   ```

## Features Implemented

✅ Home screen with recipe grid (2 columns)
✅ Recipe cards with images, time, and difficulty badges
✅ Heart icon to save/favorite recipes
✅ Ingredient search screen with search bar and popular ingredients
✅ Recipe detail screen with:
   - Large recipe image
   - Quick info (time, difficulty, servings)
   - Collapsible ingredients list (show 3, expand to see all)
   - Checkbox for ingredients
   - Step-by-step instructions
   - Pro tips section
✅ Profile screen with user info
✅ Bottom navigation bar (4 tabs)
✅ Navigation between screens
✅ Matching color scheme (#E5F5E1 green theme)

## Key Differences from React Version

- Uses Flutter's Material Design components
- State management with StatefulWidget and setState
- Navigation using Navigator.push/pop instead of conditional rendering
- Network images loaded using Image.network()
- Bottom navigation integrated directly in each screen

## Next Steps

To enhance the app further, consider:
- Add state management (Provider, Riverpod, or Bloc)
- Implement search functionality
- Add filtering and sorting
- Persist saved recipes locally (SQLite or Hive)
- Add animations and transitions
- Implement the "My Cookbook" tab
- Add user authentication

## Notes

- All images are loaded from URLs (same as React version)
- The app uses mock data defined in `models/recipe.dart`
- Colors match the original design (#E5F5E1, #059669, etc.)
