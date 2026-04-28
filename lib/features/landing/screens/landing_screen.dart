import 'package:dishcovery/widgets/dishcovery_network_image.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const LandingScreen({Key? key, required this.onContinue}) : super(key: key);

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
              final isWide = constraints.maxWidth > 800;
              final isMedium = constraints.maxWidth > 500;

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 64 : (isMedium ? 32 : 20),
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        // Header
                        _buildHeader(isWide),
                        SizedBox(height: isWide ? 60 : 40),

                        // Main content
                        if (isWide)
                          _buildWideLayout(context)
                        else
                          _buildNarrowLayout(context, isMedium),

                        const SizedBox(height: 40),

                        // Features row
                        _buildFeatures(isWide, isMedium),

                        const SizedBox(height: 32),

                        // Footer
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isWide) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('🍳', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 12),
            Text(
              'Dishcovery',
              style: TextStyle(
                fontSize: isWide ? 32 : 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        // CTA in header for wide screens
        if (isWide)
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF059669),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Text content
        Expanded(flex: 5, child: _buildHeroContent(context, true)),
        const SizedBox(width: 48),
        // Right side - Visual
        Expanded(flex: 4, child: _buildHeroVisual(380)),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, bool isMedium) {
    return Column(
      children: [
        _buildHeroContent(context, false),
        const SizedBox(height: 32),
        _buildHeroVisual(isMedium ? 320 : 260),
      ],
    );
  }

  Widget _buildHeroContent(BuildContext context, bool isWide) {
    return Column(
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            '✨ Cook smarter, not harder',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Main headline
        Text(
          'Find Delicious\nRecipes Instantly',
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: isWide ? 52 : 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),

        // Subtitle
        Text(
          'Search by ingredients you have at home and discover budget-friendly meals in seconds.',
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: isWide ? 18 : 16,
            color: Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),

        // CTA Buttons
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: onContinue,
              icon: const Icon(Icons.restaurant_menu, size: 20),
              label: const Text(
                'Start Cooking',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF059669),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.2),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onContinue,
              icon: const Icon(Icons.play_circle_outline, size: 20),
              label: const Text(
                'See How It Works',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroVisual(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Food collage image - using CachedNetworkImage for better performance
          DishcoveryNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&q=70',
            memCacheWidth: 400,
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          // Content overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '500+ Recipes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '⭐ 4.9',
                        style: TextStyle(
                          color: Color(0xFF059669),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your personal cookbook awaits',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures(bool isWide, bool isMedium) {
    final features = [
      {'icon': '🔍', 'title': 'Smart Search', 'desc': 'Find by ingredients'},
      {'icon': '⏱️', 'title': 'Quick Recipes', 'desc': 'Ready in minutes'},
      {'icon': '💚', 'title': 'Save Favorites', 'desc': 'Your cookbook'},
    ];

    if (isWide || isMedium) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: features
            .map((f) => Expanded(child: _featureCard(f, isWide)))
            .toList(),
      );
    }

    return Column(
      children: features.map((f) => _featureCard(f, false)).toList(),
    );
  }

  Widget _featureCard(Map<String, String> feature, bool isWide) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isWide ? 8 : 0,
        vertical: isWide ? 0 : 6,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 16 : 20,
        vertical: isWide ? 20 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: isWide ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: isWide
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Text(feature['icon']!, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  feature['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  feature['desc']!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        '© 2026 Dishcovery · Made with 💚',
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
      ),
    );
  }
}
