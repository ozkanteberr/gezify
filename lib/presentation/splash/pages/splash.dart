import 'package:flutter/material.dart';
import 'package:gezify/core/configs/assets/app_images.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(AppImages.appLogo)),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(Duration(seconds: 2));
  }
}
