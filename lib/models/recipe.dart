// recipe.dart
// Recipe model

import 'dart:convert';

class Recipe {
  final String id;
  final String title;
  final int cookingTime;
  final String difficulty;
  final int servings;
  final String mainIngredient;
  final List<String> ingredients;
  final List<String> instructions;
  final bool isSavedInCookbook;
  final List<String> category;

  Recipe({
    required this.id,
    required this.title,
    required this.cookingTime,
    required this.difficulty,
    required this.servings,
    required this.mainIngredient,
    required this.ingredients,
    required this.instructions,
    this.isSavedInCookbook = false,
    required this.category,
  });

  Recipe copyWith({
    String? id,
    String? title,
    int? cookingTime,
    String? difficulty,
    int? servings,
    String? mainIngredient,
    List<String>? ingredients,
    List<String>? instructions,
    bool? isSavedInCookbook,
    List<String>? category,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      mainIngredient: mainIngredient ?? this.mainIngredient,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      isSavedInCookbook: isSavedInCookbook ?? this.isSavedInCookbook,
      category: category ?? this.category,
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      cookingTime: (json['cookingTime'] as num).toInt(),
      difficulty: json['difficulty'] as String? ?? '',
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      mainIngredient: json['mainIngredient'] as String? ?? '',
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      instructions:
          (json['instructions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isSavedInCookbook: json['isSavedInCookbook'] as bool? ?? false,
      category:
          (json['category'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cookingTime': cookingTime,
      'difficulty': difficulty,
      'servings': servings,
      'mainIngredient': mainIngredient,
      'ingredients': ingredients,
      'instructions': instructions,
      'isSavedInCookbook': isSavedInCookbook,
      'category': category,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

// recipe.dart\n// Recipe model placeholder\n\nclass Recipe {\n  // TODO: define model fields\n}\n
