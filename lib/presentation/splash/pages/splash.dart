import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gezify/presentation/auth/presentation/pages/auth_gate.dart';
import 'package:gezify/presentation/splash/pages/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Widget _nextScreen;

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (!seenOnboarding) {
      _nextScreen = const OnboardingPage();
      await prefs.setBool('seenOnboarding', true);
    } else {
      _nextScreen = const AuthGate();
    }
  }

  @override
  void initState() {
    super.initState();
    _init().then((_) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => _nextScreen),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F5F2), // Dilersen farklı bir sade renk de verebilirsin
      body: Center(
        child: Lottie.asset(
          "assets/Lottie/animation4.json",
          width: MediaQuery.of(context).size.width * 1,
          fit: BoxFit.contain,
          
        ),
      ),
    );
  }
}
