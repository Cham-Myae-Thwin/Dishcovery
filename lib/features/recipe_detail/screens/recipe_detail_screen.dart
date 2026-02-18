import 'package:dishcovery/features/recipe_detail/screens/Recipe.dart';
import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _isSaved = false;
  bool _showAllIngredients = false;
  final Set<int> _checkedIngredients = {};

  Color _getDifficultyColor() {
    switch (widget.recipe.difficulty) {
      case 'Easy':
        return const Color(0xFF059669);
      case 'Medium':
        return const Color(0xFFD97706);
      case 'Hard':
        return const Color(0xFFDC2626);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedIngredients = _showAllIngredients
        ? widget.recipe.ingredients
        : widget.recipe.ingredients.take(3).toList();
    final hasMoreIngredients = widget.recipe.ingredients.length > 3;

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
        child: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: const Color(0xFFE5F5E1).withOpacity(0.95),
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isSaved ? Icons.favorite : Icons.favorite_border,
                      color: _isSaved ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSaved = !_isSaved;
                      });
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.recipe.image,
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Info bar at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.recipe.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  widget.recipe.time,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Icon(Icons.circle,
                                    color: _getDifficultyColor(), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  widget.recipe.difficulty,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                const Icon(Icons.people,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  widget.recipe.servings,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ingredients Section
                    const Row(
                      children: [
                        Text('📝', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8),
                        Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...displayedIngredients.asMap().entries.map((entry) {
                      final index = entry.key;
                      final ingredient = entry.value;
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _checkedIngredients.contains(index),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _checkedIngredients.add(index);
                            } else {
                              _checkedIngredients.remove(index);
                            }
                          });
                        },
                        title: Text(
                          ingredient,
                          style: TextStyle(
                            decoration: _checkedIngredients.contains(index)
                                ? TextDecoration.lineThrough
                                : null,
                            color: _checkedIngredients.contains(index)
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        activeColor: const Color(0xFF059669),
                      );
                    }).toList(),
                    if (hasMoreIngredients)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showAllIngredients = !_showAllIngredients;
                          });
                        },
                        child: Text(
                          _showAllIngredients
                              ? 'Show less'
                              : 'See more (${widget.recipe.ingredients.length - 3} more)',
                          style: const TextStyle(
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Instructions Section
                    const Row(
                      children: [
                        Text('👨‍🍳', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8),
                        Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...widget.recipe.instructions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final instruction = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF059669),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                instruction,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    // Tips Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '💡 Pro Tip: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Add avocado and fresh cilantro for extra flavor and creaminess!',
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
