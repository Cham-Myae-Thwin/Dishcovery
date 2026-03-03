// user.dart
// Simple User model for Dishcovery

import 'dart:convert';

class User {
  final String id;
  final String name;
  final int cookbookCount;
  final List<String> savedRecipeIds;

  User({
    required this.id,
    required this.name,
    this.cookbookCount = 0,
    List<String>? savedRecipeIds,
  }) : savedRecipeIds = savedRecipeIds ?? [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      cookbookCount: (json['cookbookCount'] as num?)?.toInt() ?? 0,
      savedRecipeIds: (json['savedRecipes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cookbookCount': cookbookCount,
      'savedRecipes': savedRecipeIds,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
