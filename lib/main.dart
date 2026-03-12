import 'package:dishcovery/features/browse_recipe/screens/browse_recipe_screen.dart';
import 'package:dishcovery/features/welcome/screens/welcome_screen.dart';
import 'package:dishcovery/features/landing/screens/landing_screen.dart';
import 'package:dishcovery/services/image_cache_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ImageCacheConfig.configure();
  runApp(const ProviderScope(child: DishcoveryApp()));
}

class DishcoveryApp extends StatefulWidget {
  const DishcoveryApp({Key? key}) : super(key: key);

  @override
  State<DishcoveryApp> createState() => _DishcoveryAppState();
}

class _DishcoveryAppState extends State<DishcoveryApp> {
  bool _showWelcome = true;
  bool _showLanding = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dishcovery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'Inter',
      ),
      home: _showLanding
          ? LandingScreen(
              onContinue: () {
                setState(() {
                  _showLanding = false;
                });
              },
            )
          : _showWelcome
          ? WelcomeScreen(
              onGetStarted: () {
                setState(() {
                  _showWelcome = false;
                });
              },
              onBack: () {
                setState(() {
                  _showLanding = true;
                });
              },
            )
          : const HomeScreen(),
    );
  }
}
