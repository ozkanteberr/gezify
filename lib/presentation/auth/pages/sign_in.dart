import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gezify/common/widgets/app_bar.dart';
import 'package:gezify/common/widgets/custom_text_field.dart';
import 'package:gezify/presentation/auth/pages/sign_up.dart';
import 'package:gezify/presentation/home/pages/home_page.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  @override
  late String email, password;
  final firebaseAuth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BasicAppBar(),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Haydi,Giriş Yap",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Lütfen giriş yapınız.",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.grey.shade500)),
              SizedBox(
                height: 40,
              ),
              CustomTextField(
                iconData: Icon(Icons.email),
                hintext: "E-Mail",
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                iconData: Icon(Icons.lock),
                hintext: "Şifre",
                obsecureText: true,
              ),
              Row(children: <Widget>[
                SizedBox(width: 350),
                MaterialButton(
                  onPressed: () {},
                  child: Text(
                    "Şifremi Unuttum",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.blue),
                  ),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 450,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Giriş Yap",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("Hesabınız yok mu?",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.grey.shade400)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text("Kayıt Ol",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.alternate_email,
                          color: Colors.lightBlue, size: 30))
                ],
              )
            ],
          ),
        ));
  }
}
