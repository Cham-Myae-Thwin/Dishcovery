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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF059669), Color(0xFF10B981), Color(0xFF34D399)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isMedium = constraints.maxWidth > 600;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 32 : 20,
                      vertical: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "What's your main ingredient?",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Find easy recipes with what you have at home.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'e.g., chicken, tomato, egg',
                              prefixIcon: const Icon(Icons.search, size: 22),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                            ),
                            style: const TextStyle(fontSize: 16),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _handleSearch(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWide
                                ? 32
                                : isMedium
                                ? 24
                                : 20,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Popular ingredients',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _commonIngredients.map((ingredient) {
                                  return InkWell(
                                    onTap: () => _handleSearch(ingredient),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFE5E7EB),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        ingredient,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 40),
                              Center(
                                child: Column(
                                  children: const [
                                    Text(
                                      '🥘',
                                      style: TextStyle(
                                        fontSize: 60,
                                        color: Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Search by ingredient to find recipes',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF059669), Color(0xFF10B981), Color(0xFF34D399)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isMedium = constraints.maxWidth > 600;
              final crossAxisCount = isWide
                  ? 4
                  : isMedium
                  ? 3
                  : 2;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 32 : 20,
                      vertical: 18,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Results for "$query"',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                results.isEmpty
                                    ? 'No recipes found'
                                    : '${results.length} recipes found',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFE5E7EB),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          isWide
                              ? 32
                              : isMedium
                              ? 24
                              : 16,
                        ),
                        child: results.isEmpty
                            ? const Center(
                                child: Text(
                                  'Try a different ingredient or spelling.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: isWide
                                          ? 0.9
                                          : isMedium
                                          ? 0.8
                                          : 0.75,
                                    ),
                                itemCount: results.length,
                                itemBuilder: (context, index) {
                                  final recipe = results[index];
                                  final isSaved = savedIds.contains(recipe.id);
                                  return RecipeCard(
                                    recipe: recipe,
                                    isSaved: isSaved,
                                    onToggleSave: () async {
                                      final notifier = ref.read(
                                        savedRecipesProvider.notifier,
                                      );
                                      final nowSaved = await notifier
                                          .toggleAndGet(recipe.id);
                                      final messenger = ScaffoldMessenger.of(
                                        context,
                                      );
                                      messenger.hideCurrentSnackBar();
                                      messenger.showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: nowSaved
                                              ? const Color(0xFFDCFCE7)
                                              : const Color(0xFFFEE2E2),
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          content: Row(
                                            children: [
                                              const Text(
                                                '💾',
                                                style: TextStyle(fontSize: 20),
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
                                              RecipeDetailScreen(
                                                recipe: recipe,
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: const Color(0xFF059669),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          onTabTapped(index);
          // If navigating away from search, pop the results screen
          if (index != 1) {
            Navigator.of(context).pop();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'My Cookbook',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
