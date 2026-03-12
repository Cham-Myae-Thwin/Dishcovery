import 'package:flutter/material.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe_card.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dishcovery/providers/saved_recipes_provider.dart';

class IngredientSearchScreen extends StatefulWidget {
  final Function(String) onSearch;
  final int currentIndex;
  final Function(int) onTabTapped;

  const IngredientSearchScreen({
    Key? key,
    required this.onSearch,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  State<IngredientSearchScreen> createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _commonIngredients = [
    'Chicken',
    'Eggs',
    'Potatoes',
    'Tomatoes',
    'Pasta',
  ];

  void _handleSearch(String ingredient) {
    // Perform local filtering and show results in a dedicated page so Home/Browse remains unchanged.
    final query = ingredient.trim().toLowerCase();
    final results = mockRecipes.where((r) {
      final inTitle = r.title.toLowerCase().contains(query);
      final inIngredients = r.ingredients.any(
        (ing) => ing.toLowerCase().contains(query),
      );
      return inTitle || inIngredients;
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          query: ingredient,
          results: results,
          currentIndex: widget.currentIndex,
          onTabTapped: widget.onTabTapped,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE5F5E1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Header
                  const Text(
                    "What's your main ingredient?",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Find easy recipes with what you have.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., chicken, tomato, egg',
                        prefixIcon: Icon(Icons.search, size: 24),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                      style: const TextStyle(fontSize: 18),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _handleSearch(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Popular Ingredients
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Popular ingredients',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _commonIngredients.map((ingredient) {
                      return InkWell(
                        onTap: () => _handleSearch(ingredient),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            ingredient,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    '🥘',
                    style: const TextStyle(
                      fontSize: 60,
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF059669),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Cookbook'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class SearchResultsScreen extends ConsumerWidget {
  final String query;
  final List<Recipe> results;
  final int currentIndex;
  final Function(int) onTabTapped;

  const SearchResultsScreen({
    Key? key,
    required this.query,
    required this.results,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedIds = ref.watch(savedRecipesProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE5F5E1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Results for "$query"',
          style: const TextStyle(color: Color(0xFF111827)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: results.isEmpty
            ? Center(child: Text('No recipes found for "$query"'))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final recipe = results[index];
                  final isSaved = savedIds.contains(recipe.id);
                  return RecipeCard(
                    recipe: recipe,
                    isSaved: isSaved,
                    onToggleSave: () async {
                      final notifier = ref.read(savedRecipesProvider.notifier);
                      final nowSaved = await notifier.toggleAndGet(recipe.id);
                      final messenger = ScaffoldMessenger.of(context);
                      messenger.hideCurrentSnackBar();
                      messenger.showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: nowSaved
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFEE2E2),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          content: Row(
                            children: [
                              Text(
                                nowSaved ? '💾' : '🗑️',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  nowSaved
                                      ? 'Saved to My Cookbook'
                                      : 'Removed from My Cookbook',
                                  style: TextStyle(
                                    color: nowSaved
                                        ? Colors.green[900]
                                        : Colors.red[900],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // First notify the parent (HomeScreen) to update its state.
          onTabTapped(index);
          // If the user tapped a tab other than the Search tab, close
          // the SearchResultsScreen so the HomeScreen (now updated)
          // becomes visible. Keep the results route open when tapping
          // the Search tab itself.
          if (index != 1) {
            Navigator.of(context).pop();
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF059669),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Cookbook'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
