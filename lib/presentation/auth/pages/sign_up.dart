// ignore_for_file: unused_local_variable, unused_label, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:gezify/common/widgets/app_bar.dart';
import 'package:gezify/common/widgets/custom_text_field.dart';
import 'package:gezify/presentation/auth/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final _formKey = GlobalKey<FormState>();
  late String email,password;
  final firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar(),
      body: Center(
        child: Form(
        key: _formKey,
        
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text("Şimdi Kayıt Ol",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.black
            ),
            ),
            SizedBox(height: 20,),
            Text("Lütfen bilgileri doldurun ve hesap oluşturun.",
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.grey.shade500
            )
            ),
            SizedBox(height: 40,),
            CustomTextField(
              hintext: "İsim",
              iconData: Icon(Icons.people)
              ),
            SizedBox(height: 10,),
            CustomTextField(hintext: "E-mail",
             iconData: Icon(Icons.mail),
             controller: emailController,
             validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen e-posta adresinizi girin';
                  }
                  if (!value.contains('@')) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
             ),
             SizedBox(height: 10,),
            CustomTextField(hintext: "Şifre",
             iconData: Icon(Icons.lock),
             obsecureText: true,
             controller: passwordController,
             validator: (value) {
                  if (value !.isEmpty) {
                    return 'Bilgileri eksiksiz doldurunuz';
                  }
                  if (value.length < 8 || value.length >8) {
                      return "Şifre 8 karakter olmalıdır!";
                    }
                  else{}
                  onSaved: (value){
                    password=value;
                  };
                },
             ),
             SizedBox(height: 10,),
             Padding(
              padding: EdgeInsets.only(right: 280),
              child: Text("Şifre 8 karakter içermelidir",
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.grey.shade500
            )
            ), 
             ),
            SizedBox(height: 30,),
            SizedBox(
              width: 450,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          UserCredential userCredential = await firebaseAuth
                              .createUserWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim());
                          if (userCredential.user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Kayıt Başarılı! Giriş yapabilirsiniz.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          String errorMessage = 'Kayıt sırasında bir hata oluştu.';
                          if (e.code == 'weak-password') {
                            errorMessage = 'Şifre çok zayıf.';
                          } else if (e.code == 'email-already-in-use') {
                            errorMessage = 'Bu e-posta adresi zaten kullanımda.';
                          } else if (e.code == 'invalid-email') {
                            errorMessage = 'Geçersiz e-posta adresi.';
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Kayıt Ol",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Colors.white
            ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
            SizedBox(height: 10),
            Text("Zaten hesabınız var mı?",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.grey.shade400
            )
            ),
            TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text("Giriş yap",
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Colors.blue
                    )
                  ),
                ),
               ],
            ),
            Text("Veya bağlan",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.grey.shade400
            ),
            ),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
               
               children: [
                SizedBox(height: 50,),
                IconButton(onPressed: () {},
                 icon: Icon(Icons.alternate_email,color: Colors.lightBlue,size:30))
               ],
            )

              

          ],
        ),
      ),
    )
    );
  }
}
