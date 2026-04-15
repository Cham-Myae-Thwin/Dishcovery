import 'dart:convert';
import 'package:dishcovery/models/recipe.dart';
import 'package:dishcovery/providers/saved_recipes_provider.dart';
import 'package:dishcovery/services/persistent_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

// Mocks
class MockHttpClient extends Mock implements http.Client {}

class MockPersistentStorage extends Mock implements PersistentStorage {}

// A simple RecipeRepository class for demonstration since the original is a placeholder
class RecipeRepository {
  final http.Client client;

  RecipeRepository(this.client);

  Future<List<Recipe>> fetchRecipes() async {
    final response =
        await client.get(Uri.parse('https://api.example.com/recipes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    if (query.isEmpty) {
      return [];
    }
    final response =
        await client.get(Uri.parse('https://api.example.com/search?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search recipes');
    }
  }
}

void main() {
  late RecipeRepository recipeRepository;
  late MockHttpClient mockHttpClient;
  late MockPersistentStorage mockPersistentStorage;

  setUp(() {
    mockHttpClient = MockHttpClient();
    recipeRepository = RecipeRepository(mockHttpClient);
    mockPersistentStorage = MockPersistentStorage();
  });

  // Mock Recipe Data
  final mockRecipe = Recipe(
    id: '1',
    title: 'Test Recipe',
    cookingTime: 30,
    difficulty: 'Easy',
    servings: 4,
    mainIngredient: 'flour',
    ingredients: ['1 cup flour', '1 egg'],
    instructions: ['Mix flour and egg.', 'Bake at 350.'],
    category: ['test'],
  );

  final mockRecipesJson = json.encode([mockRecipe.toJson()]);

  group('RecipeRepository', () {
    group('fetchRecipes', () {
      test('returns a list of recipes on successful API call', () async {
        // Arrange
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response(mockRecipesJson, 200),
        );

        // Act
        final recipes = await recipeRepository.fetchRecipes();

        // Assert
        expect(recipes, isA<List<Recipe>>());
        expect(recipes.first.title, 'Test Recipe');
      });

      test('throws an exception on API failure', () async {
        // Arrange
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response('Server error', 500),
        );

        // Act & Assert
        expect(recipeRepository.fetchRecipes(), throwsException);
      });
    });

    group('searchRecipes', () {
      test('returns a list of recipes for a valid search query', () async {
        // Arrange
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response(mockRecipesJson, 200),
        );

        // Act
        final recipes = await recipeRepository.searchRecipes('test');

        // Assert
        expect(recipes, isA<List<Recipe>>());
        expect(recipes.first.title, 'Test Recipe');
      });

      test('returns an empty list for an empty search query', () async {
        // Act
        final recipes = await recipeRepository.searchRecipes('');

        // Assert
        expect(recipes, isEmpty);
        verifyNever(() => mockHttpClient.get(any()));
      });

      test('throws an exception on API failure', () async {
        // Arrange
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response('Server error', 500),
        );

        // Act & Assert
        expect(recipeRepository.searchRecipes('test'), throwsException);
      });
    });
  });

  group('SavedRecipesNotifier (saveRecipe)', () {
    test('initial state is empty after loading from empty storage', () async {
      // Arrange
      when(() => mockPersistentStorage.readStringList(any()))
          .thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [
          persistentStorageProvider.overrideWithValue(mockPersistentStorage),
        ],
      );

      // Act & Assert
      expect(container.read(savedRecipesProvider), isEmpty);
    });

    test('saves a recipe ID', () async {
      // Arrange
      when(() => mockPersistentStorage.readStringList(any()))
          .thenAnswer((_) async => []);
      when(() => mockPersistentStorage.writeStringList(any(), any()))
          .thenAnswer((_) async {});
      final container = ProviderContainer(
        overrides: [
          persistentStorageProvider.overrideWithValue(mockPersistentStorage),
        ],
      );
      final notifier = container.read(savedRecipesProvider.notifier);

      // Act
      await notifier.toggle('1');

      // Assert
      expect(container.read(savedRecipesProvider), ['1']);
      verify(() =>
              mockPersistentStorage.writeStringList('saved_recipe_ids', ['1']))
          .called(1);
    });

    test('removes a saved recipe ID', () async {
      // Arrange
      when(() => mockPersistentStorage.readStringList(any()))
          .thenAnswer((_) async => ['1']);
      when(() => mockPersistentStorage.writeStringList(any(), any()))
          .thenAnswer((_) async {});
      final container = ProviderContainer(
        overrides: [
          persistentStorageProvider.overrideWithValue(mockPersistentStorage),
        ],
      );
      final notifier = container.read(savedRecipesProvider.notifier);

      // Act
      await notifier.toggle('1');

      // Assert
      expect(container.read(savedRecipesProvider), isEmpty);
      verify(() =>
              mockPersistentStorage.writeStringList('saved_recipe_ids', []))
          .called(1);
    });

    test('toggleAndGet returns true when saving and false when removing',
        () async {
      // Arrange
      when(() => mockPersistentStorage.readStringList(any()))
          .thenAnswer((_) async => []);
      when(() => mockPersistentStorage.writeStringList(any(), any()))
          .thenAnswer((_) async {});
      final container = ProviderContainer(
        overrides: [
          persistentStorageProvider.overrideWithValue(mockPersistentStorage),
        ],
      );
      final notifier = container.read(savedRecipesProvider.notifier);

      // Act & Assert
      bool isSaved = await notifier.toggleAndGet('1');
      expect(isSaved, isTrue);
      expect(container.read(savedRecipesProvider), ['1']);

      isSaved = await notifier.toggleAndGet('1');
      expect(isSaved, isFalse);
      expect(container.read(savedRecipesProvider), isEmpty);
    });
  });
}
