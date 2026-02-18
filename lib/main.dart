import 'package:dishcovery/features/browse_recipe/screens/browse_recipe_screen.dart';
import 'package:dishcovery/features/welcome/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DishcoveryApp());
}

class DishcoveryApp extends StatefulWidget {
  const DishcoveryApp({Key? key}) : super(key: key);

  @override
  State<DishcoveryApp> createState() => _DishcoveryAppState();
}

class _DishcoveryAppState extends State<DishcoveryApp> {
  bool _showWelcome = true;

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
      home: _showWelcome
          ? WelcomeScreen(
              onGetStarted: () {
                setState(() {
                  _showWelcome = false;
                });
              },
            )
          : const HomeScreen(),
    );
  }
}
