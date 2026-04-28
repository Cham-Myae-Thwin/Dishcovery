import 'package:dishcovery/features/browse_recipe/screens/browse_recipe_screen.dart';
import 'package:dishcovery/features/welcome/screens/welcome_screen.dart';
import 'package:dishcovery/features/landing/screens/landing_screen.dart';
import 'package:dishcovery/services/image_cache_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  ImageCacheConfig.configure();
  runApp(const ProviderScope(child: DishcoveryApp()));
}

class DishcoveryApp extends StatefulWidget {
  const DishcoveryApp({Key? key}) : super(key: key);

  @override
  State<DishcoveryApp> createState() => _DishcoveryAppState();
}

class _DishcoveryAppState extends State<DishcoveryApp> {
  Route<dynamic> _buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/landing-page':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => LandingScreen(
            onContinue: () => Navigator.of(context).pushNamed('/welcome'),
          ),
        );
      case '/welcome':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => WelcomeScreen(
            onGetStarted: () => Navigator.of(context).pushNamed('/home'),
            onBack: () => Navigator.of(context).pop(),
          ),
        );
      case '/home':
      case '/browse':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => LandingScreen(
            onContinue: () => Navigator.of(context).pushNamed('/welcome'),
          ),
        );
    }
  }

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
      onGenerateRoute: _buildRoute,
    );
  }
}
