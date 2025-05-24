import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/common/widgets/app_bar.dart';
import 'package:gezify/common/widgets/custom_text_field.dart';
import 'package:gezify/common/widgets/sign_with_google.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_states.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_in.dart';
import 'package:gezify/presentation/home/presentation/pages/home_page.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    final authCubit = context.read<AuthCubit>();

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      authCubit.register(email, password, name);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email, şifre ve isim kısmı boş bırakılamaz!")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is Authanticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFE0F2F1),
          body: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.25,
                  child: Image.asset(
                    'assets/images/signin.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          BasicAppBar(),
                          const SizedBox(height: 20),
                          const SizedBox(height: 20),
                          Text(
                            "Şimdi Kayıt Ol",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: const Color(0xFF004D40),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Lütfen bilgileri doldurun ve hesap oluşturun.",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 450,
                            child: Column(
                              children: [
                                CustomTextField(
                                  hintext: "İsim",
                                  iconData: Icon(Icons.people),
                                  controller: nameController,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  hintext: "E-mail",
                                  iconData: Icon(Icons.email_outlined),
                                  controller: emailController,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  hintext: "Şifre",
                                  iconData: Icon(Icons.lock_outline),
                                  obsecureText: true,
                                  controller: passwordController,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 31.0),
                              child: Text(
                                "Şifre en az 6 karakter içermelidir.",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: const Color.fromARGB(255, 53, 53, 53)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 310,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00796B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                       color: Colors.black.withOpacity(0.5),
                                        width: 1.2),
                              ),
                              child: Text(
                                "Kayıt Ol",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Zaten hesabınız var mı?",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInPage(),
                                      ));
                                },
                                child: Text("Giriş yap",
                                    style: TextStyle(color: Color(0xFF004D40))),
                              ),
                            ],
                          ),
                          Text(
                            "veya bağlan",
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 10),
                          SignWithGoogle(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
