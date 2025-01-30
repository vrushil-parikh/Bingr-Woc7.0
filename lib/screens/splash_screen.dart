import 'package:bingr/screens/auth/auth_page.dart';
import 'package:bingr/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate loading or initialization (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    // Check login status
    final pref = await SharedPreferences.getInstance();
    final isLoggedIn = pref.getBool('isLoggedIn') ?? false;

    // Navigate to the appropriate screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? const HomePage() : const AuthPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 150,
          child: Hero(
              tag: 'HeroTag',
              child: Image.asset("assets/images/app_logo.png")),
        ),
      ),
    );
  }
}
