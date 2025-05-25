import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:gezify/presentation/auth/presentation/pages/auth_gate.dart';
import 'package:gezify/presentation/splash/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  Future<Widget> _loadNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    // Eğer onboarding görülmemişse, onu göster ve işaretle
    if (!seenOnboarding) {
      await prefs.setBool('seenOnboarding', true);
      return const OnboardingPage();
    } else {
      return const AuthGate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _loadNextScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedSplashScreen(
            splash: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  "assets/Lottie/animation1.json",
                  width: 250,
                  height: 250,
                ),
              ],
            ),
            nextScreen: snapshot.data!,
            splashIconSize: 400,
            backgroundColor: Colors.white,
            duration: 2500,
            animationDuration: const Duration(milliseconds: 1000),
            splashTransition: SplashTransition.fadeTransition,
          );
        } else {
          // Splash yüklenene kadar geçici boş ekran veya progress
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
