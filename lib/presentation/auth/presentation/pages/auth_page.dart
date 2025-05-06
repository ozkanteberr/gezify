import 'package:flutter/material.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_in.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_up.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void tooglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInPage(
        togglePage: tooglePages,
      );
    } else {
      return SignUpPage(
        togglePage: tooglePages,
      );
    }
  }
}
