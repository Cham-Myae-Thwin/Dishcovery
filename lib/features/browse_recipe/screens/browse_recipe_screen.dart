import 'package:dishcovery/features/ingredient_search/screens/IngredientSearchScreen.dart';
import 'package:dishcovery/features/my_cookbook/screens/my_cookbook_screen.dart';
import 'package:dishcovery/features/profile/screens/profile_screen.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe_card.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Recipe> _savedRecipes = [];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onIngredientSearch(String ingredient) {
    setState(() {
      _currentIndex = 0;
    });
  }

  void _toggleSaveRecipe(Recipe recipe) {
    setState(() {
      if (_savedRecipes.contains(recipe)) {
        _savedRecipes.remove(recipe);
      } else {
        _savedRecipes.add(recipe);
      }
    });
  }

  bool _isRecipeSaved(Recipe recipe) {
    return _savedRecipes.contains(recipe);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == 1) {
      return IngredientSearchScreen(
        onSearch: _onIngredientSearch,
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      );
    }

    if (_currentIndex == 2) {
      return CookbookScreen(
        savedRecipes: _savedRecipes,
        onToggleSave: _toggleSaveRecipe,
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      );
    }

    if (_currentIndex == 3) {
      return ProfileScreen(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
        savedRecipesCount: _savedRecipes.length,
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
                    Container(
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
                  ],
                ),
              ),

              // Recipe Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: mockRecipes.length,
                    itemBuilder: (context, index) {
                      return RecipeCard(
                        recipe: mockRecipes[index],
                        isSaved: _isRecipeSaved(mockRecipes[index]),
                        onToggleSave: () =>
                            _toggleSaveRecipe(mockRecipes[index]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                recipe: mockRecipes[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
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
