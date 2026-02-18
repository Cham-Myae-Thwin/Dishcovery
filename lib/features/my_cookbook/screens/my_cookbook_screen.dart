// MyCookbookScreen.dart\n// Placeholder screen for the MyCookbook feature.\n\nimport 'package:flutter/material.dart';\n\n// TODO: Implement MyCookbook screen\n

import 'package:dishcovery/features/recipe_detail/screens/Recipe.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe_card.dart';
import 'package:dishcovery/features/recipe_detail/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';

class CookbookScreen extends StatelessWidget {
  final List<Recipe> savedRecipes;
  final Function(Recipe) onToggleSave;
  final int currentIndex;
  final Function(int) onTabTapped;

  const CookbookScreen({
    Key? key,
    required this.savedRecipes,
    required this.onToggleSave,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE5F5E1),
              Colors.white,
            ],
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'My CookBook ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      '👩‍🍳',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),

              // Recipe Grid or Empty State
              Expanded(
                child: savedRecipes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '📖',
                              style: TextStyle(fontSize: 80),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No saved recipes yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Start saving your favorite recipes!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: savedRecipes.length,
                          itemBuilder: (context, index) {
                            return RecipeCard(
                              recipe: savedRecipes[index],
                              isSaved: true,
                              onToggleSave: () =>
                                  onToggleSave(savedRecipes[index]),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailScreen(
                                      recipe: savedRecipes[index],
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
        currentIndex: currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF059669),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Cookbook',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
