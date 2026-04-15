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
// browse_recipe_screen.dart\n// Main screen for browsing recipes in the BrowseRecipe feature
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  late List<Recipe> _visibleRecipes;
  SortMode _sortMode = SortMode.none;

  @override
  void initState() {
    super.initState();
    _visibleRecipes = List<Recipe>.from(mockRecipes);
  }

  int _parseMinutes(String timeStr) {
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
      if (index == 0) {
        _visibleRecipes = List<Recipe>.from(mockRecipes);
        if (_sortMode != SortMode.none) _applySort();
      }
    });
  }

  void _onIngredientSearch(String ingredient) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Find your next craving',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Browse quick, easy recipes picked just for you.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFE5E7EB),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        _SortMenu(
                          sortMode: _sortMode,
                          onSelected: (mode) {
                            _sortMode = mode;
                            _applySort();
                          },
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
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          const SizedBox(height: 8),

                          if (_sortMode != SortMode.none)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide
                                    ? 32
                                    : isMedium
                                    ? 24
                                    : 16,
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
                                      border: Border.all(
                                        color: const Color(0xFFDCFCE7),
                                      ),
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
                                              : _sortMode ==
                                                    SortMode.difficultyEasy
                                              ? 'Difficulty: Easy'
                                              : _sortMode ==
                                                    SortMode.difficultyMedium
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
                                      style: TextStyle(
                                        color: Color(0xFF065F46),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${_visibleRecipes.length} results',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(
                                isWide
                                    ? 32
                                    : isMedium
                                    ? 24
                                    : 16,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                switchInCurve: Curves.easeOutQuart,
                                switchOutCurve: Curves.easeInQuart,
                                child: GridView.builder(
                                  key: ValueKey<int>(
                                    _visibleRecipes.length + _sortMode.index,
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: isWide
                                            ? 0.9
                                            : isMedium
                                            ? 0.8
                                            : 0.72,
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

class _SortMenu extends StatelessWidget {
  final SortMode sortMode;
  final ValueChanged<SortMode> onSelected;

  const _SortMenu({Key? key, required this.sortMode, required this.onSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortMode>(
      onSelected: onSelected,
      elevation: 8,
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem<SortMode>(
          value: SortMode.none,
          child: _buildMenuTile(
            context,
            icon: '✨',
            title: 'Default (All)',
            subtitle: 'Show every recipe',
            isSelected: sortMode == SortMode.none,
          ),
        ),
        PopupMenuItem<SortMode>(
          value: SortMode.timeAsc,
          child: _buildMenuTile(
            context,
            icon: '⏱️',
            title: 'Time: Low → High',
            subtitle: 'Quick recipes first',
            isSelected: sortMode == SortMode.timeAsc,
          ),
        ),
        PopupMenuItem<SortMode>(
          value: SortMode.timeDesc,
          child: _buildMenuTile(
            context,
            icon: '🕒',
            title: 'Time: High → Low',
            subtitle: 'Longer recipes first',
            isSelected: sortMode == SortMode.timeDesc,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<SortMode>(
          value: SortMode.difficultyEasy,
          child: _buildMenuTile(
            context,
            icon: '🟢',
            title: 'Difficulty: Easy',
            subtitle: 'Simple steps and ingredients',
            isSelected: sortMode == SortMode.difficultyEasy,
          ),
        ),
        PopupMenuItem<SortMode>(
          value: SortMode.difficultyMedium,
          child: _buildMenuTile(
            context,
            icon: '🟠',
            title: 'Difficulty: Medium',
            subtitle: 'A little challenge',
            isSelected: sortMode == SortMode.difficultyMedium,
          ),
        ),
        PopupMenuItem<SortMode>(
          value: SortMode.difficultyHard,
          child: _buildMenuTile(
            context,
            icon: '🔴',
            title: 'Difficulty: Hard',
            subtitle: 'For experienced cooks',
            isSelected: sortMode == SortMode.difficultyHard,
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF059669), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.tune, size: 18, color: Color(0xFF059669)),
            SizedBox(width: 8),
            Text(
              'Sort',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildMenuTile(
  BuildContext context, {
  required String icon,
  required String title,
  required String subtitle,
  required bool isSelected,
}) {
  return Container(
    decoration: BoxDecoration(
      color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: isSelected
          ? Border.all(color: const Color(0xFF059669), width: 1)
          : null,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        if (isSelected) ...[
          const SizedBox(width: 8),
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF059669)),
        ],
      ],
    ),
  );
}
