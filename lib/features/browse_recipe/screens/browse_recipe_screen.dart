import 'package:dishcovery/features/ingredient_search/screens/IngredientSearchScreen.dart';
import 'package:dishcovery/features/my_cookbook/screens/my_cookbook_screen.dart';
import 'package:dishcovery/features/profile/screens/profile_screen.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe_card.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dishcovery/providers/saved_recipes_provider.dart';

enum SortMode {
  none,
  timeAsc,
  timeDesc,
  difficultyEasy,
  difficultyMedium,
  difficultyHard,
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  // saved recipes are now managed by Riverpod savedRecipesProvider
  late List<Recipe> _visibleRecipes;
  SortMode _sortMode = SortMode.none;

  @override
  void initState() {
    super.initState();
    // start by showing all available recipes
    _visibleRecipes = List<Recipe>.from(mockRecipes);
  }

  int _parseMinutes(String timeStr) {
    // Expect formats like "15 min" or "1 hr 20 min". Extract first number as minutes when possible.
    final m = RegExp(r"(\d+)").firstMatch(timeStr);
    if (m != null) return int.tryParse(m.group(0) ?? '0') ?? 0;
    return 0;
  }

  void _applySort() {
    setState(() {
      if (_sortMode == SortMode.none) {
        _visibleRecipes = List<Recipe>.from(mockRecipes);
      } else if (_sortMode == SortMode.timeAsc) {
        _visibleRecipes.sort(
          (a, b) => _parseMinutes(a.time).compareTo(_parseMinutes(b.time)),
        );
      } else if (_sortMode == SortMode.timeDesc) {
        _visibleRecipes.sort(
          (a, b) => _parseMinutes(b.time).compareTo(_parseMinutes(a.time)),
        );
      } else if (_sortMode == SortMode.difficultyEasy) {
        _visibleRecipes = mockRecipes
            .where((r) => r.difficulty.toLowerCase() == 'easy')
            .toList();
      } else if (_sortMode == SortMode.difficultyMedium) {
        _visibleRecipes = mockRecipes
            .where((r) => r.difficulty.toLowerCase() == 'medium')
            .toList();
      } else if (_sortMode == SortMode.difficultyHard) {
        _visibleRecipes = mockRecipes
            .where((r) => r.difficulty.toLowerCase() == 'hard')
            .toList();
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      // when returning to Home/Browse, show all recipes again (clear search results)
      if (index == 0) {
        _visibleRecipes = List<Recipe>.from(mockRecipes);
        // re-apply sorting if selected
        if (_sortMode != SortMode.none) _applySort();
      }
    });
  }

  void _onIngredientSearch(String ingredient) {
    // apply a simple, case-insensitive filter against recipe ingredients and title
    final query = ingredient.trim().toLowerCase();
    setState(() {
      _currentIndex = 0;
      if (query.isEmpty) {
        _visibleRecipes = List<Recipe>.from(mockRecipes);
      } else {
        _visibleRecipes = mockRecipes.where((r) {
          final inTitle = r.title.toLowerCase().contains(query);
          final inIngredients = r.ingredients.any(
            (ing) => ing.toLowerCase().contains(query),
          );
          return inTitle || inIngredients;
        }).toList();
      }
    });
  }

  Future<void> _toggleSaveRecipe(Recipe recipe) async {
    // use provider to toggle saved state and show a nice snack
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Text(nowSaved ? '💾' : '🗑️', style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                nowSaved ? 'Saved to My Cookbook' : 'Removed from My Cookbook',
                style: TextStyle(
                  color: nowSaved ? Colors.green[900] : Colors.red[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _isRecipeSaved(Recipe recipe) {
    final saved = ref.watch(savedRecipesProvider);
    return saved.contains(recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    final savedIds = ref.watch(savedRecipesProvider);
    final savedRecipes = mockRecipes
        .where((r) => savedIds.contains(r.id))
        .toList();
    if (_currentIndex == 1) {
      return IngredientSearchScreen(
        onSearch: _onIngredientSearch,
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      );
    }

    if (_currentIndex == 2) {
      return CookbookScreen(
        savedRecipes: savedRecipes,
        onToggleSave: _toggleSaveRecipe,
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      );
    }

    if (_currentIndex == 3) {
      return ProfileScreen(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
        savedRecipesCount: savedRecipes.length,
      );
    }

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
          child: Column(
            children: [
              // Header
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find Your next Craving!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sort / Filter menu
                    PopupMenuButton<SortMode>(
                      onSelected: (mode) {
                        _sortMode = mode;
                        _applySort();
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<SortMode>(
                          value: SortMode.none,
                          child: ListTile(
                            leading: const Text(
                              '✨',
                              style: TextStyle(fontSize: 20),
                            ),
                            title: const Text(
                              'Default (All)',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              'Show every recipe',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: _sortMode == SortMode.none
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF059669),
                                  )
                                : null,
                          ),
                        ),
                        PopupMenuItem<SortMode>(
                          value: SortMode.timeAsc,
                          child: ListTile(
                            leading: const Text(
                              '⏱️',
                              style: TextStyle(fontSize: 20),
                            ),
                            title: const Text(
                              'Time: Low → High',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              'Quick recipes first',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: _sortMode == SortMode.timeAsc
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF059669),
                                  )
                                : null,
                          ),
                        ),
                        PopupMenuItem<SortMode>(
                          value: SortMode.timeDesc,
                          child: ListTile(
                            leading: const Text(
                              '🕒',
                              style: TextStyle(fontSize: 20),
                            ),
                            title: const Text(
                              'Time: High → Low',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              'Longer recipes first',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: _sortMode == SortMode.timeDesc
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF059669),
                                  )
                                : null,
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<SortMode>(
                          value: SortMode.difficultyEasy,
                          child: ListTile(
                            leading: const Text(
                              '🟢',
                              style: TextStyle(fontSize: 20),
                            ),
                            title: const Text(
                              'Difficulty: Easy',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              'Simple steps and ingredients',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: _sortMode == SortMode.difficultyEasy
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF059669),
                                  )
                                : null,
                          ),
                        ),
                        PopupMenuItem<SortMode>(
                          value: SortMode.difficultyMedium,
                          child: ListTile(
                            leading: const Text(
                              '🟠',
                              style: TextStyle(fontSize: 20),
                            ),
                            title: const Text(
                              'Difficulty: Medium',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              'A little challenge',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: _sortMode == SortMode.difficultyMedium
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF059669),
                                  )
                                : null,
                          ),
                        ),
                        PopupMenuItem<SortMode>(
                          value: SortMode.difficultyHard,
                          child: ListTile(
                            leading: const Text(
                              '🔴',
                              style: TextStyle(fontSize: 20),
                            ),
                            title: const Text(
                              'Difficulty: Hard',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              'For experienced cooks',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: _sortMode == SortMode.difficultyHard
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF059669),
                                  )
                                : null,
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF059669),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tune,
                              size: 16,
                              color: const Color(0xFF059669),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sort',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Recipe Grid
              // Active sort indicator and modern list area
              if (_sortMode != SortMode.none)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6FFEF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFDCFCE7)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.filter_list,
                              size: 16,
                              color: Color(0xFF059669),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _sortMode == SortMode.timeAsc
                                  ? 'Time: Low → High'
                                  : _sortMode == SortMode.timeDesc
                                  ? 'Time: High → Low'
                                  : _sortMode == SortMode.difficultyEasy
                                  ? 'Difficulty: Easy'
                                  : _sortMode == SortMode.difficultyMedium
                                  ? 'Difficulty: Medium'
                                  : 'Difficulty: Hard',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF065F46),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _sortMode = SortMode.none;
                            _applySort();
                          });
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Color(0xFF065F46)),
                        ),
                      ),
                      const Spacer(),
                      // small hint
                      Text(
                        '${_visibleRecipes.length} results',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              // Recipe Grid (modernized with animation)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutQuart,
                    switchOutCurve: Curves.easeInQuart,
                    child: GridView.builder(
                      key: ValueKey<int>(
                        _visibleRecipes.length + _sortMode.index,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                      itemCount: _visibleRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _visibleRecipes[index];
                        return RecipeCard(
                          recipe: recipe,
                          isSaved: _isRecipeSaved(recipe),
                          onToggleSave: () async =>
                              await _toggleSaveRecipe(recipe),
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
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
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
