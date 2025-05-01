import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/common/widgets/app_bar.dart';
import 'package:gezify/common/widgets/custom_text_field.dart';
import 'package:gezify/common/widgets/sign_with_google.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';

class SignUpPage extends StatefulWidget {
  final void Function()? togglePage;
  SignUpPage({super.key, required this.togglePage});

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
          content: Text("Email,şifre ve isim kısmı boş bırakılamaz!")));
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BasicAppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Şimdi Kayıt Ol",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Lütfen bilgileri doldurun ve hesap oluşturun.",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.grey.shade500)),
                SizedBox(
                  height: 40,
                ),
                CustomTextField(
                  hintext: "İsim",
                  iconData: Icon(Icons.people),
                  controller: nameController,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hintext: "E-mail",
                  iconData: Icon(Icons.mail),
                  controller: emailController,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hintext: "Şifre",
                  iconData: Icon(Icons.lock),
                  obsecureText: true,
                  controller: passwordController,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Şifre en az 6 karakter içermelidir",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: 450,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Zaten hesabınız var mı?",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.grey.shade400)),
                    TextButton(
                      onPressed: widget.togglePage,
                      child: Text("Giriş yap",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.blue)),
                    ),
                  ],
                ),
                Text(
                  "Veya bağlan",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.grey.shade400),
                ),
                SizedBox(
                  height: 10,
                ),
                SignWithGoogle()
              ],
            ),
          ),
        ));
  }
}
