import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gezify/common/widgets/custom_text_field.dart';
import 'package:gezify/common/widgets/sign_with_google.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_states.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_up.dart';
import 'package:gezify/presentation/forgot_password/presentation/forgot_pw_screen.dart';
import 'package:gezify/presentation/home/presentation/pages/home_page.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      body: Stack(
        children: [
          // Arka plan görseli
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'assets/images/signin.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          BlocListener<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is Authanticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else if (state is Unauthenticated &&
                  state.errorMessage != null) {
                Fluttertoast.showToast(
                  msg: state.errorMessage.toString(),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        SizedBox(height: 150),
                        Text(
                          "Haydi, Giriş Yap",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: const Color(0xFF004D40),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Seyahate başlamak için giriş yapın.",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 40),
                        CustomTextField(
                          controller: _emailController,
                          iconData: Icon(Icons.email_outlined),
                          hintext: "E-Mail",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen email adresinizi girin';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          iconData: Icon(Icons.lock_outline),
                          hintext: "Şifre",
                          obsecureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen şifrenizi girin';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Şifremi Unuttum",
                                style: TextStyle(color: Color(0xFF004D40)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 310,
                          height: 50,
                          child: BlocBuilder<AuthCubit, AuthStates>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthCubit>().login(
                                                _emailController.text,
                                                _passwordController.text,
                                              );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00796B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: Colors.black.withOpacity(0.5),
                                        width: 1.2), // siyah kenarlık
                                  ),
                                ),
                                child: state is AuthLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        "Giriş Yap",
                                        style: TextStyle(color: Colors.white),
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hesabınız yok mu?",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()),
                                );
                              },
                              child: Text("Kayıt Ol",
                                  style: TextStyle(color: Color(0xFF004D40))),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "veya bağlan",
                          style: TextStyle(
                              color: const Color.fromARGB(229, 86, 109, 83)),
                        ),
                        SizedBox(height: 20),
                        SignWithGoogle(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
