// local_recipe_repository.dart
// Simple local repository that loads recipes from assets and manages saved state

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class LocalRecipeRepository {
  static const _savedKey = 'saved_recipe_ids';

  Future<List<Recipe>> loadAllRecipes() async {
    final data = await rootBundle.loadString('lib/data/recipes.json');
    final list = jsonDecode(data) as List<dynamic>;
    return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Recipe?> getRecipeDetail(String id) async {
    final all = await loadAllRecipes();
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  // Lightweight normalization for ingredient matching
  String _normalize(String s) {
    var t = s.toLowerCase().trim();
  // remove punctuation (keep word characters, whitespace and hyphens)
  t = t.replaceAll(RegExp(r'[^\w\s-]'), '');
  // collapse whitespace
  t = t.replaceAll(RegExp(r'\s+'), ' ');
    // simple plural handling: strip trailing s/es
    if (t.endsWith('es')) t = t.substring(0, t.length - 2);
    else if (t.endsWith('s')) t = t.substring(0, t.length - 1);
    return t;
  }

  Future<List<Recipe>> getRecipes({String? ingredient, String? difficulty}) async {
    final all = await loadAllRecipes();
    if ((ingredient == null || ingredient.isEmpty) && (difficulty == null || difficulty.isEmpty)) {
      return all;
    }

    final normIngredient = ingredient != null && ingredient.isNotEmpty ? _normalize(ingredient) : null;
    final normDifficulty = difficulty != null && difficulty.isNotEmpty ? difficulty.toLowerCase().trim() : null;

    return all.where((r) {
      var matchesIngredient = true;
      var matchesDifficulty = true;

      if (normIngredient != null) {
        final recipeTokens = r.ingredients.map((i) => _normalize(i));
        matchesIngredient = recipeTokens.any((t) => t.contains(normIngredient) || normIngredient.contains(t));
      }

      if (normDifficulty != null && normDifficulty.isNotEmpty) {
        matchesDifficulty = r.difficulty.toLowerCase() == normDifficulty;
      }

      return matchesIngredient && matchesDifficulty;
    }).toList();
  }

  Future<List<String>> _loadSavedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_savedKey) ?? [];
  }

  Future<void> _saveIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_savedKey, ids);
  }

  Future<bool> isRecipeSaved(String id) async {
    final ids = await _loadSavedIds();
    return ids.contains(id);
  }

  // returns new saved count
  Future<int> toggleSaveRecipe(String id) async {
    final ids = await _loadSavedIds();
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    await _saveIds(ids);
    return ids.length;
  }
}

