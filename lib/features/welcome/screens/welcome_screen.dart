import 'package:dishcovery/widgets/dishcovery_network_image.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback? onBack;

  const WelcomeScreen({Key? key, required this.onGetStarted, this.onBack})
    : super(key: key);

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
                      vertical: isWide ? 40 : 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: isWide
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        // Back button
                        if (onBack != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: onBack,
                            ),
                          ),

                        // Logo and title
                        Row(
                          mainAxisAlignment: isWide
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '🍳',
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              'Dishcovery',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isWide ? 40 : 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Tagline
                        SizedBox(
                          width: isWide ? 640 : double.infinity,
                          child: Text(
                            'Discover delicious recipes using the ingredients you already have — fast, simple, and budget-friendly.',
                            textAlign: isWide
                                ? TextAlign.left
                                : TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: isWide ? 18 : 16,
                              height: 1.4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Feature highlights
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: isWide
                              ? WrapAlignment.start
                              : WrapAlignment.center,
                          children: [
                            _miniFeature('🔍', 'Search by ingredient'),
                            _miniFeature('⏱️', 'Quick & easy'),
                            _miniFeature('❤️', 'Save favorites'),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Middle content: CTA + illustration
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // CTA column
                              Expanded(
                                flex: 5,
                                child: _buildCta(onGetStarted, isWide),
                              ),
                              const SizedBox(width: 32),
                              // Illustration
                              Expanded(flex: 4, child: _illustrationCard()),
                            ],
                          )
                        else ...[
                          _buildCta(onGetStarted, isWide),
                          const SizedBox(height: 24),
                          _illustrationCard(),
                        ],

                        // Footer small note
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                            'Fast. Simple. Home-cooked.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ),
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

  Widget _buildCta(VoidCallback onGetStarted, bool isWide) {
    return SizedBox(
      width: isWide ? 420 : double.infinity,
      child: Row(
        mainAxisAlignment: isWide
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF059669),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniFeature(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _illustrationCard() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DishcoveryNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=70',
            memCacheWidth: 600,
          ),
          Container(color: Colors.black26),
        ],
      ),
    );
  }
}
