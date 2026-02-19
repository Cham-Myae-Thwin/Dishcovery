import 'package:dishcovery/features/recipe_detail/screens/recipe.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final bool isSaved;
  final VoidCallback? onToggleSave;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
    this.isSaved = false,
    this.onToggleSave,
  }) : super(key: key);

  Color _getDifficultyColor() {
    switch (recipe.difficulty) {
      case 'Easy':
        return const Color(0xFF10B981);
      case 'Medium':
        return const Color(0xFFF59E0B);
      case 'Hard':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  Color _getDifficultyBgColor() {
    switch (recipe.difficulty) {
      case 'Easy':
        return const Color(0xFFD1FAE5);
      case 'Medium':
        return const Color(0xFFFEF3C7);
      case 'Hard':
        return const Color(0xFFFEE2E2);
      default:
        return Colors.grey[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(recipe.image, fit: BoxFit.cover),
                  ),
                ),
                // Heart button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onToggleSave,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        color: isSaved ? Colors.red : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Badges
                    Row(
                      children: [
                        // Time badge
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Color(0xFF374151),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    recipe.time,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF374151),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Difficulty badge
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyBgColor(),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              recipe.difficulty,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _getDifficultyColor(),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
    );
  }
}
